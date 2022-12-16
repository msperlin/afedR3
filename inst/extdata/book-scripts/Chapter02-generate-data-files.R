# script for generating all book files

data_dir <- 'inst/extdata/data/'
#if (!fs::dir_exists(data_dir)) fs::dir_create(data_dir)

# Inflation ----
library(GetBCBData)
library(ggplot2)
library(tidyverse)

first_date <- '2005-01-01'
last_date <- '2022-10-01'

# inflation
df_inflation <- gbcbd_get_series(
  433,
  first.date = first_date,
  last.date = last_date,
  cache.path =fs::path_temp('bcb')
) |>
  mutate(value = value/100) |>
  janitor::clean_names()

f_out <- stringr::str_glue(
  'Chapter02-inflation-BR-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_inflation, fs::path(data_dir, f_out ))


## Petrobras Stock Price ---
first_date <- '2015-01-01'
last_date <- '2022-10-15'

df_single <- yfR::yf_get(
  tickers = 'PETR3.SA',
  first_date = first_date,
  last_date = last_date,
  be_quiet = TRUE,
  freq_data = 'monthly'
)

f_out <- stringr::str_glue(
  'Chapter02-PETR-stock-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_single, fs::path(data_dir, f_out ))

## Ibovespa and PETR3
first_date <- '2015-01-01'
last_date <- '2022-10-15'

tickers <- c('^BVSP', 'PETR3.SA')

df_yf <- yfR::yf_get(
  tickers = tickers,
  first_date = first_date,
  last_date = last_date,
  be_quiet = TRUE,
  freq_data = 'monthly'
)

f_out <- stringr::str_glue(
  'Chapter02-PETR3-and-BVSP-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_yf , fs::path(data_dir, f_out ))

# EGIE3
first_date <- '2016-01-01'
last_date <- '2022-10-15'
df <- yfR::yf_get(
  'EGIE3.SA',
  first_date = first_date,
  last_date = last_date,
  freq_data = 'monthly'
)

f_out <- stringr::str_glue(
  'Chapter02-EGIE3-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_yf , fs::path(data_dir, f_out ))

# savings ration
df <- datasets::LifeCycleSavings |>
  dplyr::mutate(saving_ratio = sr/dpi) |>
  tibble::rownames_to_column(var = 'country')

f_out <- stringr::str_glue(
  'Chapter02-SavingsRatios-World-1960-1970.csv'
)

write_csv(df , fs::path(data_dir, f_out ))
