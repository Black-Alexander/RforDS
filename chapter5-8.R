## setwd('C:/Users/Sky/Documents/R/win-library/3.4')

library(tidyverse)
library(nycflights13)

####### Chapter 5: Data Transformation

flights

## print in tibble if you want to view everything
## tibbles are df but tweaked to work better in tidyverse

## key dplyr functions: filter(), arrange(), select(), mutate(), summarise()

jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25)) ## Show data with extra ()

(nov_dec <- filter(flights, month %in% c(11, 12)))

## filter() over includes rows where condition = TRUE

df <- tibble(x = c(1, NA, 3))
df1 <- data.frame(x = c(1, NA, 3))

filter(df, x > 1)
filter(df, is.na(x) | x > 1)

## 5.2.4 Exercises

names(flights)
filter(flights, arr_delay >= 2)
filter(flights, dest == "IAH" | dest == "HOU")

table(is.na(flights$dep_time))

## sum of all NAs
sapply(flights, function(x) 
  {sum(is.na(x))}
  )

arrange(flights, year, month, day)

arrange(flights, desc(arr_delay))

## Missing values are always sorted at the end
df <- tibble(x = c(5, 2, NA))
arrange(df, x)

## Order by NA first???  HOW
arrange(flights, desc(is.na(arr_delay)))

arrange(flights, desc(minute))
arrange(flights, desc(distance))
arrange(flights, (distance))



























































