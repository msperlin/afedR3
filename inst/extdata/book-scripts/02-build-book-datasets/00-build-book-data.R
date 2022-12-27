library(dplyr)

# global vars
first_date <- '2010-01-01'
last_date <- '2023-01-01'
path_files <- 'inst/extdata/data'

build_path <- function(f_in) {
  fs::path(path_files, f_in)
}


# ibov data ----
my_f <- build_path('CH04-ibovespa.csv')

if (file.exists(my_f)) invisible(file.remove(my_f))

df_ibov <- yfR::yf_get(
  '^BVSP',
  first_date,
  last_date)

df_ibov <- df_ibov |>
  dplyr::select(ref_date, price_close)

#readr::write_csv(x = df, path = my_f, col_names = TRUE)
readr::write_csv(df_ibov, my_f)

my_f <- build_path('CH04-ibovespa-Excel.xlsx')
writexl::write_xlsx(df_ibov,
                 my_f)

# sp500 data ----
my_f <- build_path('CH04-SP500.csv')

if (file.exists(my_f)) invisible(file.remove(my_f))

df_sp500 <- yfR::yf_get(
  '^GSPC',
  first_date,
  last_date)

df_sp500 <- df_sp500 |>
  dplyr::select(ref_date, price_close)

#readr::write_csv(x = df, path = my_f, col_names = TRUE)
readr::write_csv(df_sp500, my_f)

my_f <- build_path('CH04-SP500-Excel.xlsx')
writexl::write_xlsx(df_sp500, my_f)



# bizare csv file 01 ----
f_out <- build_path('CH04-funky_csv_file.csv')

example_df <- wakefield::r_data(n = 100)

set.seed(100)
my_N <- 100

my_header <- stringr::str_glue('Example of funky file:\n',
                      '- columns separated by ";"\n',
                      '- decimal points as ","\n\n',
                      'Data build in {Sys.Date()}\n',
                      'Origin: www.funkysite.com.br\n\n')

readr::write_lines(my_header, file = f_out, append = FALSE)

write.table(x = example_df, file = f_out, sep = ';', quote = FALSE,
            append = TRUE, fileEncoding = 'UTF-8', dec = ',', row.names = FALSE)


# bizare csv file 02 ----
f_out <- build_path('CH04_another-funky-csv-file.csv')

example_df <- wakefield::r_data_frame(
  wakefield::name(),
  wakefield::grade(),
  wakefield::age(), n = 100)

my_header <- stringr::str_glue('Outro exemplo de arquivo .csv com formato alternativo:\n',
                      '- colunas separadas por "|"\n',
                      '- decimal como "?"\n\n',
                      'Dados retirados em {Sys.Date()}\n',
                      'Origem: www.funkysite.com.br\n\n')

readr::write_lines(example_df, file = f_out, append = FALSE)

write.table(x = example_df, file = f_out, sep = '|', quote = FALSE,
            append = TRUE, fileEncoding = 'UTF-8', dec = '?', row.names = FALSE)


# tsv file (exercises) ----
f_out <- build_path('CH04_example-tsv.tsv')

set.seed(100)
my_N <- 100
df_example <- wakefield::r_data(100)

readr::write_delim(x = df_example, file = f_out, delim = '\t')

# pride and prejudice -----
f_out <- build_path('CH04-price-and-prejudice.txt')
id <- 1342
df_book <- gutenbergr::gutenberg_download(id)

book_text <- paste0(
  df_book$text,
  collapse = '\n'
)

readr::write_lines(book_text, f_out)

# grunfeld ----
data('Grunfeld', package = "plm")
grunfeld <- Grunfeld
f_out <- build_path('CH11_grunfeld.csv')

readr::write_csv(grunfeld, f_out)
