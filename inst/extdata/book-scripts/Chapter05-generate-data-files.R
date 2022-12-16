# script for generating all book files
library(tidyverse)

data_dir <- 'inst/extdata/data/'

##  SELIC
first_date <- '2000-01-01'
last_date <- '2021-12-31'
diff_years <- 3

df_selic <- GetBCBData::gbcbd_get_series(1178, first_date, last_date) |>
  filter(ref.date >= first_date) |>
  mutate(value = value/100) |>
  select(ref.date, value) |>
  rename(ref_date = ref.date,
         selic = value) |>
  mutate(ref_year = lubridate::floor_date(ref_date,
                                          lubridate::years(diff_years))) |>
  filter(ref_year >= first_date)

df_labels <- tibble(
  ref_year = unique(df_selic$ref_year),
  period_label = str_glue("{lubridate::year(ref_year)}-{lubridate::year(ref_year)+ diff_years}")
)

df_selic <- df_selic |>
  left_join(df_labels)

f_out <- stringr::str_glue(
  'Chapter05-selic-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_selic, fs::path(data_dir, f_out ))


