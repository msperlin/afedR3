# get ibov data
library(BatchGetSymbols)
library(tidyverse)

my_d <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(my_d)

# ibov
my.f <- 'data/Ibov.csv'

dir.create('data')

if (file.exists(my.f)) invisible(file.remove(my.f))

df <- BatchGetSymbols::BatchGetSymbols('^BVSP',
                                       first.date = '2010-01-01',
                                       last.date = '2021-01-01')[[2]]

df <- dplyr::select(df, ref.date, price.close)

#readr::write_csv(x = df, path = my.f, col_names = TRUE)
write_csv(df, my.f)
xlsx::write.xlsx(df, 'data/Ibov_xlsx.xlsx', sheetName = 'Sheet1', row.names = FALSE)

# sp500
# ibov
my.f <- 'data/SP500.csv'

dir.create('data')

if (file.exists(my.f)) invisible(file.remove(my.f))

df <- BatchGetSymbols::BatchGetSymbols('^BVSP',
                                       first.date = '2010-01-01',
                                       last.date = '2021-01-01')[[2]]

df <- dplyr::select(df, ref.date, price.close)

#readr::write_csv(x = df, path = my.f, col_names = TRUE)
write_csv(df, my.f)
xlsx::write.xlsx(df, 'data/SP500_xlsx.xlsx', sheetName = 'Sheet1', row.names = FALSE)


# bizare csv file 01
f_out <- 'data/funky_csv_file.csv'

set.seed(100)
my_N <- 100
df_cities <- read.csv('raw_data_csv/br_cities.csv') %>%
  left_join(read.csv('raw_data_csv/br_states.csv') %>%
              rename(state = NOME,
                     COD.UF = COD) ) %>%
  sample_n(my_N) %>%
  mutate(number_col = runif(my_N)*100)

my_header <- str_glue('Exemplo de arquivo .csv com formato alternativo:\n',
                      '- colunas separadas por ";"\n',
                      '- decimal como ","\n\n',
                    'Dados retirados em {Sys.Date()}\n',
                    'Origem: www.funkysite.com.br\n\n')

write_lines(my_header, file = f_out, append = FALSE)

write.table(x = df_cities, file = f_out, sep = ';', quote = FALSE,
            append = TRUE, fileEncoding = 'UTF-8', dec = ',', row.names = FALSE)


# bizare csv file 02
f_out <- 'data/another_funky_csv_file.csv'

set.seed(100)
my_N <- 100
df_cities <- read.csv('raw_data_csv/br_cities.csv') %>%
  left_join(read.csv('raw_data_csv/br_states.csv') %>%
              rename(state = NOME,
                     COD.UF = COD) ) %>%
  sample_n(my_N) %>%
  mutate(number_col = runif(my_N)*100)

my_header <- str_glue('Outro exemplo de arquivo .csv com formato alternativo:\n',
                      '- colunas separadas por "|"\n',
                      '- decimal como "?"\n\n',
                      'Dados retirados em {Sys.Date()}\n',
                      'Origem: www.funkysite.com.br\n\n')

write_lines(my_header, file = f_out, append = FALSE)

write.table(x = df_cities, file = f_out, sep = '|', quote = FALSE,
            append = TRUE, fileEncoding = 'UTF-8', dec = '?', row.names = FALSE)


# tsv file
f_out <- 'data/example_tsv.csv'

set.seed(100)
my_N <- 100
df_cities <- read.csv('raw_data_csv/br_cities.csv')

write_delim(x = df_cities, file = f_out, delim = '\t')

# grunfeld
data(Grunfeld)

write_csv(Grunfeld, file = 'data/grunfeld.csv')

