# script for generating all book files

data_dir <- 'inst/extdata/data/'

## BVSP, SP500, FTSE
first_date <- '2015-01-01'
last_date <- '2022-05-01'

df_indices <- yfR::yf_get(
  tickers = c('^BVSP', "^FTSE", "^GSPC"),
  first_date = first_date,
  last_date = last_date,
  be_quiet = TRUE,
  freq_data = 'monthly'
)

f_out <- stringr::str_glue(
  'Chapter03-bvsp-ftse-sp500-{lubridate::year(first_date)}-{lubridate::year(last_date)}.csv'
)

write_csv(df_indices, fs::path(data_dir, f_out ))
