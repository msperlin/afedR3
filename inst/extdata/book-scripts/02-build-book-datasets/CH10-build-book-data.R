library(dplyr)

set.seed(10)

# global vars
first_date <- '2010-01-01'
last_date <- '2023-01-01'
path_files <- 'inst/extdata/data'

build_path <- function(f_in) {
  fs::path(path_files, f_in)
}

# SP500 ----
my_f <- build_path('CH10_sp500-stocks-long-by-year.csv')
n_stocks <- 50
df_sp500 <- yfR::yf_index_composition('SP500')

selected <- sample(unique(df_sp500$ticker), n_stocks)

df_yf <- yfR::yf_get(selected,
                     first_date,
                     last_date,
                     freq_data = 'yearly')

readr::write_csv(df_yf, my_f)

