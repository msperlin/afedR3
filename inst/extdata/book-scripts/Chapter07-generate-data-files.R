# script for generating all book files
library(tidyverse)

data_dir <- 'inst/extdata/data/'

##  municipes of brazil
url <- "https://raw.githubusercontent.com/kelvins/Municipios-Brasileiros/main/csv/municipios.csv"

df_mun <- readr::read_csv(url)

f_out <- stringr::str_glue(
  'Chapter07-latlong-cities-brazil.csv'
)

write_csv(df_mun, fs::path(data_dir, f_out ))

## data on states
f <- system.file("extdata/rawdata/raw_data_ibge.csv", package = "vdr")

df_ibge <- readr::read_csv(f) |>
  janitor::clean_names() |>
  dplyr::rename(rendimento_mensal_domiciliar = rendimento_mensal_domiciliar_per_capita_r_2021) |>
  select(uf, codigo, rendimento_mensal_domiciliar)

f_out <- stringr::str_glue(
  'Chapter07-data-ibge.csv'
)

readr::write_csv(df_ibge, fs::path(data_dir, f_out ))

# universities
url <- "https://download.inep.gov.br/microdados/microdados_censo_da_educacao_superior_2020.zip"
zip_out <- fs::path(tempdir(), "uni-files")
f_dl <- fs::path(tempdir(),
                 basename(url))

if (!fs::file_exists(f_dl)) {
  options(download.file.method = "curl",
          download.file.extra="-k -L")
  download.file(url, f_dl)
}

unzip(f_dl,
      exdir = zip_out,
      junkpaths = TRUE)

f_uni <- fs::path(zip_out, "MICRODADOS_CADASTRO_IES_2020.CSV")

df_uni <- readr::read_csv2(f_uni, locale = readr::locale(encoding = "Latin1")) |>
  dplyr::select(NU_ANO_CENSO, NO_IES, QT_DOC_TOTAL) |>
  dplyr::filter(stringr::str_detect(NO_IES, "UNIVERSIDADE FEDERAL"))

f_out <- stringr::str_glue(
  'Chapter07-federal-universities.csv'
)

readr::write_csv(df_uni, fs::path(data_dir, f_out ))
