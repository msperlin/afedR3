
# Repository for R package afedR3

Includes several functions related to the third edition of book
“Analyzing Financial and Economic Data with R”, available in the
following formats:

- [Amazon](https://www.amazon.com/dp/B084LSNXMN) - full length book
- [Online version](https://www.msperlin.com/afedR/) - first seven
  chapters

## Installation

    # only in github (will not pass cran checks)
    devtools::install_github('msperlin/afedR3')

## Example of usage

### Listing available datasets

``` r
afedR3::list_available_data()
#>  [1] "Brazil_footbal_games.csv"                        
#>  [2] "example_tsv.csv"                                 
#>  [3] "FileWithLatinChar_Latin1.txt"                    
#>  [4] "FileWithLatinChar_UTF-8.txt"                     
#>  [5] "Financial Sample.xlsx"                           
#>  [6] "FTSE.csv"                                        
#>  [7] "funky_csv_file.csv"                              
#>  [8] "funky_csv2.csv"                                  
#>  [9] "grunfeld.csv"                                    
#> [10] "Ibov_long_2010-01-01_2018-09-12.rds"             
#> [11] "IbovComp_long_2015-01-01_2019-11-10.rds"         
#> [12] "pride_and_prejudice.txt"                         
#> [13] "SP500_comp_long_2014-10-17_2019-10-16.rds"       
#> [14] "SP500_comp_YEARLY_long_2014-10-03_2019-10-02.rds"
#> [15] "SP500_Excel.xlsx"                                
#> [16] "SP500_long_yearly_2010-01-01_2019-11-04.rds"     
#> [17] "SP500_Stocks_long_by_year.rds"                   
#> [18] "SP500_xlsx.xlsx"                                 
#> [19] "SP500-Stocks_long.csv"                           
#> [20] "SP500-Stocks_wide.csv"                           
#> [21] "SP500-Stocks-WithRet.rds"                        
#> [22] "SP500.csv"                                       
#> [23] "SQLite_db.SQLITE"                                
#> [24] "TDData_ALL_2019-10-02.rds"                       
#> [25] "temp_file.xlsx"                                  
#> [26] "temp_fst.fst"                                    
#> [27] "temp_rds.rds"                                    
#> [28] "temp_writexl.xlsx"                               
#> [29] "temp_xlsx.xlsx"                                  
#> [30] "temp.csv"                                        
#> [31] "temp.fst"                                        
#> [32] "temp.RData"                                      
#> [33] "temp.rds"                                        
#> [34] "temp.txt"                                        
#> [35] "temp.xlsx"                                       
#> [36] "top25babynames-by-sex-2005-2017.csv"             
#> [37] "UCI_Credit_Card.csv"
```

### Fetching data from book repository

``` r
file_name <- 'SP500.csv'
path_to_file <- afedR3::get_data_file(file_name)

df <- readr::read_csv(path_to_file)
#> Rows: 2718 Columns: 2
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl  (1): price.close
#> date (1): ref.date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
dplyr::glimpse(df)
#> Rows: 2,718
#> Columns: 2
#> $ ref.date    <date> 2010-01-04, 2010-01-05, 2010-01-06, 2010-01-07, 2010-01-0…
#> $ price.close <dbl> 70045, 70240, 70729, 70451, 70263, 70433, 70076, 70385, 69…
```

### Copying all book files to local directory

``` r
temp_path <- fs::path_temp('afedR3')

flag <- afedR3::copy_book_files(path_to_copy = temp_path)
#> Warning in afedR3::copy_book_files(path_to_copy = temp_path):
#> Path /tmp/Rtmpy4Nqo2/afedR3 was not found. Creating folder..
#> Copying data files files to /tmp/Rtmpy4Nqo2/afedR3/afedR files/data
#>  37 files copied
#> Copying end-of-chapter (eoc) exercises with solutions to /tmp/Rtmpy4Nqo2/afedR3/afedR files/eoc-exercises/
#>  99 files copied
#> Copying R code to /tmp/Rtmpy4Nqo2/afedR3/afedR files/R-code
#>  15 files copied
```
