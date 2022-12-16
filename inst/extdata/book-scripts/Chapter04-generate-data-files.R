# script for generating all book files

library(tidyverse)

data_dir <- 'inst/extdata/data/'

# sp500 -- 1950 ----


first_date <- '1950-01-01'
last_date <- Sys.Date()

df_sp500 <- yfR::yf_get(
  tickers = "^GSPC",
  first_date = first_date,
  last_date = last_date,
  be_quiet = FALSE,
  freq_data = 'daily'
)

df_sp500 <- df_sp500 |>
  select(ref_date, price_adjusted,
         ret_adjusted_prices) |>
  na.omit() |>
  mutate(year = lubridate::floor_date(ref_date,
                                      unit = lubridate::years(10)),
         decade = lubridate::floor_date(ref_date,
                                        unit = lubridate::years(10)))


f_out <- stringr::str_glue(
  'Chapter04-sp500-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_sp500, fs::path(data_dir, f_out ))

##  SELIC
first_date <- '2000-01-01'
last_date <- Sys.Date()
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
  'Chapter04-selic-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_selic, fs::path(data_dir, f_out ))


## credit data - ISLR ----
credit <- tibble::as_tibble(ISLR::Credit)

numeric_cols <- which(
  sapply(credit , class) %in% c("integer", "numeric")
)

df_num <- credit[, numeric_cols]

f_out <- stringr::str_glue(
  'Chapter04-credit-ISLR.csv'
)

write_csv(df_num, fs::path(data_dir, f_out ))

# Stocks and inflation ----
require(tidyverse)

set.seed(100)
df_ibov <- yfR::yf_index_composition("IBOV")

# select top and bottom by performance
first_date <- '2005-01-01'
last_date <- "2022-01-04"

df_ibov <- yfR::yf_collection_get('IBOV', first_date, last_date,
                                  thresh_bad_data = 0.15, )

tab <- df_ibov |>
  group_by(ticker) |>
  summarise(min_date = min(ref_date),
            max_date = max(ref_date),
            n_years = lubridate::interval(min_date, max_date) / lubridate::years(1),
            total_ret = last(price_adjusted)/first(price_adjusted) - 1,
            ret_aa = (1+total_ret)^(1/n_years) -1) |>
  ungroup() |>
  arrange(ret_aa)

how_many <- 14

filtered <- bind_rows(tab |> slice_head(n = how_many/2),
                      tab |> slice_tail(n = how_many/2)
)

tickers <- filtered$ticker

df_inflation <- GetBCBData::gbcbd_get_series(
  433,
  first.date = first_date,
  last.date = last_date,
  cache.path = fs::path_temp('bcb')
)  |>
  janitor::clean_names() |>
  mutate(value = value/100,
         year = lubridate::year(ref_date)) |>
  group_by(year) |>
  summarise(inflation = last(cumprod(1 + value)) - 1)

df_yf <- yfR::yf_get(
  tickers,
  first_date = first_date,
  last_date = last_date,
  thresh_bad_data = 0.15,
  freq_data = "yearly"
) |>
  mutate(year = lubridate::year(ref_date)) |>
  left_join(df_inflation,
            by = "year")


df_perf <- df_yf |>
  group_by(ticker) |>
  summarise(min_date = min(ref_date),
            max_date = max(ref_date),
            n_years = lubridate::interval(min_date, max_date) / lubridate::years(1),
            total_ret = last(price_adjusted)/first(price_adjusted) - 1,
            total_inflation = last(cumprod(1+inflation)) - 1,
            ret_aa = (1+total_ret)^(1/n_years) -1,
            text = str_glue(
              "{vdr::format_percent(ret_aa)} ao ano | {vdr::format_percent(total_ret)} total ",
              " [{format(min_date, '%m/%Y')} -> {format(max_date, '%m/%Y')}]" ),
            text_color = if_else(total_ret >= total_inflation, "Acima IPCA", "Abaixo IPCA")) |>
  ungroup()

df_perf

f_out <- stringr::str_glue(
  'Chapter04-performance-{how_many}-stocks-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

readr::write_csv(df_perf, fs::path(data_dir, f_out ))

p <- ggplot(df_perf) +
  geom_col(aes(x = ret_aa,
               y = reorder(ticker, ret_aa),
               fill = text_color),
           alpha = 0.35) +
  geom_text(aes(x = 0,
                y = ticker,
                label = text),
            nudge_x = 0.0) +
  labs(
    title = str_glue("Desempenho de {nrow(df_perf)} ações [",
                     "{min(lubridate::year(df_perf$min_date))} e ",
                     "{max(lubridate::year(df_perf$max_date))}]"),
    subtitle = str_glue(
      "Inflação anual média (IPCA) igual a ",
      "{vdr::format_percent(mean(df_inflation$inflation))} "
    ),
    x = "Retorno Anual",
    y = "Empresa/Ação",
    fill = "Bate Inflação?",
    caption = "Dados do Yahoo Finance") +
  theme_light() +
  scale_x_continuous(label = vdr::format_percent)


p


#  stocks by country
library(dplyr)

first_date <- '2015-01-01'
last_date <- Sys.Date()
n_stocks <- 3
set.seed(10)

df_tickers <- bind_rows(
  tibble(ticker = paste0(sample(yfR::yf_index_composition("IBOV")$ticker, n_stocks), ".SA"),
         country = "Brazil"),
  tibble(ticker = sample(yfR::yf_index_composition("SP500")$ticker, n_stocks),
         country = "USA"),
  tibble(ticker = paste0(sample(yfR::yf_index_composition("FTSE")$ticker, n_stocks), ".L"),
         country = "UK")
)

df_yf <- yfR::yf_get(tickers = df_tickers$ticker,
                     first_date = first_date,
                     last_date = last_date) |>
  left_join(df_tickers) |>
  select(ref_date, ticker, country, cumret_adjusted_prices)

p <- ggplot(df_yf, aes(x = ref_date, y = cumret_adjusted_prices, color = ticker)) +
  geom_line() +
  labs(title = "Desempenho de ações") +
  theme_light() +
  facet_wrap(~country)

p

f_out <- stringr::str_glue(
  'Chapter04-stocks-by-country-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

readr::write_csv(
  df_yf, fs::path(data_dir, f_out )
  )
