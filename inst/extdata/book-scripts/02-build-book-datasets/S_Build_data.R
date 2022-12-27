# global vars
first_date <- '2010-01-01'
last_date <- '2023-01-01'

# get ibov data
my_f <- 'data/CH04-ibovespa.csv'
dir.create('data')

if (file.exists(my_f)) invisible(file.remove(my_f))

df_ibov <- yfR::yf_get(
  '^BVSP',
  first_date,
  last_date)

df_ibov <- df_ibov |>
  dplyr::select(ref_date, price_close)

#readr::write_csv(x = df, path = my_f, col_names = TRUE)
readr::write_csv(df, my_f)

my_f <- 'data/CH04-ibovespa-Excel.xlsx'
writexl::write_xlsx(df_ibov,
                 my_f)

# sp500
# ibov
my_f <- 'data/CH04-SP500.csv'

if (file.exists(my_f)) invisible(file.remove(my_f))

df_sp500 <- yfR::yf_get(
  '^GSPC',
  first_date,
  last_date)

df_sp500 <- df_sp500 |>
  dplyr::select(ref_date, price_close)

#readr::write_csv(x = df, path = my_f, col_names = TRUE)
readr::write_csv(df_sp500, my_f)

my_f <- 'data/CH04-SP500-Excel.xlsx'
writexl::write_xlsx(df_sp500, my_f)



# bizare csv file 01
f_out <- 'data/CH04-funky_csv_file.csv'

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
