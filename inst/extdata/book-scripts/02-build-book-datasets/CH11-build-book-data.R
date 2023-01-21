library(dplyr)

# global vars
path_files <- 'inst/extdata/data'

build_path <- function(f_in) {
  fs::path(path_files, f_in)
}

# SP500
my_f <- build_path('CH11_SP500.csv')
first_date <- '1950-01-01'
last_date <- Sys.Date()

if (file.exists(my_f)) invisible(file.remove(my_f))

df_sp500 <- yfR::yf_get(
  '^GSPC',
  first_date,
  last_date)

df_sp500 <- df_sp500 |>
  dplyr::select(ref_date, price_close, ret_adjusted_prices)

readr::write_csv(df_sp500, my_f)

# grunfeld ----
data('Grunfeld', package = "plm")
grunfeld <- Grunfeld
f_out <- build_path('CH11_grunfeld.csv')

readr::write_csv(grunfeld, f_out)

# credit card data ----
link <- "https://raw.githubusercontent.com/FederatedAI/FATE/master/examples/data/UCI_Credit_Card.csv"

df_credit <- readr::read_csv(link)

f_out <- build_path('CH11_UCI-Credit-Card.csv')
readr::write_csv(df_credit, f_out)

#
