if(!require(ggplot2)) install.packages('ggplot2')
if(!require(yfR)) install.packages('yfR')
if(!require(dplyr)) install.packages('dplyr')

library(ggplot2)
library(yfR)
library(dplyr)

# set tickers
my_tickers <- c('META', 'GM')

# get data
df_prices <- yf_get(
  tickers = my_tickers,
  first_date = '2015-01-01'
  )

# make plot
p <- ggplot(data = df_prices, aes(x = ref_date,
                                  y = price_adjusted))+
  geom_line() + facet_wrap(~ticker) +
  theme_bw()

x11() ; print(p)

# make table
tab <- df_prices %>%
  group_by(ticker) %>%
  summarise(
    total_return = last(price_adjusted)/first(price_adjusted) - 1
  )

print(tab)
