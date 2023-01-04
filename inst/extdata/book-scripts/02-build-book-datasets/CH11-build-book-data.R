library(dplyr)

# global vars
first_date <- '2010-01-01'
last_date <- '2023-01-01'
path_files <- 'inst/extdata/data'

build_path <- function(f_in) {
  fs::path(path_files, f_in)
}

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
