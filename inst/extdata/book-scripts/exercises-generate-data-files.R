# script for generating all book files
library(tidyverse)

data_dir <- 'inst/extdata/data/'

##  sus data
df_sus <- fetch_datasus(year_start = 2019,
                        year_end = 2019,
                        uf = "RS",
                        information_system = "SIM-DO") |>
  process_sim() |>
  dplyr::mutate(age = as.numeric(IDADEanos)) |>
  dplyr::select(age, ESC, SEXO) |>
  na.omit()


f_out <- stringr::str_glue(
  'Exercises-sus-mortality-data.csv'
)

readr::write_csv(df_sus, fs::path(data_dir, f_out ))
