library(dplyr)

set.seed(10)

# global vars
first_date <- '2018-01-01'
last_date <- '2023-01-01'
path_files <- 'inst/extdata/data'

build_path <- function(f_in) {
  fs::path(path_files, f_in)
}

# SP500 ----
my_f <- build_path('CH08_some-stocks-SP500.csv')
n_stocks <- 15
df_sp500 <- yfR::yf_index_composition('SP500')

selected <- sample(unique(df_sp500$ticker), n_stocks)

df_yf <- yfR::yf_get(selected,
                     first_date,
                     last_date)

readr::write_csv(df_yf, my_f)

# wide df ----
my_f <- build_path('CH08_wide-example-stocks.csv')
n_stocks <- 4
selected <- sample(unique(df_yf$ticker), n_stocks)

df_yf <- df_yf  |>
  dplyr::filter(ticker %in% selected)

wide_df <- yfR::yf_convert_to_wide(df_yf)$price_adjusted

readr::write_csv(wide_df, my_f)
