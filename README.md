
# Repository for R package afedR3

Includes several functions related to the third edition of book
“Analyzing Financial and Economic Data with R”, available in the
following formats:

- [Amazon](https://www.amazon.com/dp/B084LSNXMN) - full length book
- [Online version](https://www.msperlin.com/afedR/) - first seven
  chapters

## Installation

    # only in github
    devtools::install_github('msperlin/afedR3')

## Example of usage

### Listing available datasets

``` r
afedR3::data_list()
#> 
#> ── Available data files at ']8;;file:///tmp/RtmpHaVfRd/temp_libpath15e277402813/afedR3/extdata/data/tmp/RtmpHaVfRd/temp_libpath15e277402813/afedR3/extd]8;;
#> ℹ CH04_another-funky-csv-file.csv
#> ℹ CH04_example-fst.fst
#> ℹ CH04_example-sqlite.SQLite
#> ℹ CH04_example-tsv.tsv
#> ℹ CH04_funky-csv-file.csv
#> ℹ CH04_ibovespa-Excel.xlsx
#> ℹ CH04_ibovespa.csv
#> ℹ CH04_price-and-prejudice.txt
#> ℹ CH04_SP500-Excel.xlsx
#> ℹ CH04_SP500.csv
#> ℹ CH07_FileWithLatinChar_Latin1.txt
#> ℹ CH07_FileWithLatinChar_UTF-8.txt
#> ℹ CH08_some-stocks-SP500.csv
#> ℹ CH08_wide-example-stocks.csv
#> ℹ CH11_grunfeld.csv
#> ℹ CH11_UCI-Credit-Card.csv
#> 
#> ✔ You can read files using afedR3::data_import(name_of_file)
#> ✔ Example: df <- afedR3::data_import('CH08_wide-example-stocks.csv')
```

### Fetching data from book repository

``` r
file_name <- 'CH04_SP500.csv'
path_to_file <- afedR3::data_path(file_name)

df <- readr::read_csv(path_to_file)
#> Rows: 3269 Columns: 2
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl  (1): price_close
#> date (1): ref_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
dplyr::glimpse(df)
#> Rows: 3,269
#> Columns: 2
#> $ ref_date    <date> 2010-01-04, 2010-01-05, 2010-01-06, 2010-01-07, 2010-01-0…
#> $ price_close <dbl> 1132.99, 1136.52, 1137.14, 1141.69, 1144.98, 1146.98, 1136…
```

### Copying all book files to local directory

``` r
temp_path <- fs::path_temp('afedR3')

flag <- afedR3::bookfiles_get(path_to_copy = temp_path)
#> ℹ Path ']8;;file:///tmp/RtmpJllCj3/afedR3/tmp/RtmpJllCj3/afedR3]8;;' does not exists and is created.
#> ℹ Copying data files files to ']8;;file:///tmp/RtmpJllCj3/afedR3/data/tmp/RtmpJllCj3/afedR3/data]8;;'
#> ✔    16 files copied
#> ℹ Copying book script files to ']8;;file:///tmp/RtmpJllCj3/afedR3/book-scripts/tmp/RtmpJllCj3/afedR3/book-scripts]8;;'
#> ℹ Files available at ]8;;file:///tmp/RtmpJllCj3/afedR3/tmp/RtmpJllCj3/afedR3]8;;
```
