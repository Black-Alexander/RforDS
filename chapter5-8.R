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

## other functions for select() - 
## starts_with("") ends_with("") contains matches("")


select(flights, contains("TIME"))

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


##### 5.6.1 Combining multiple operations with the pipe

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longerthere's more 
# ability to make up delays in the air?

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE) +
  geom_smooth(method = 'loess')

#> `geom_smooth()` using method = 'loess'

#### Second version of top

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

#### Plot scatter

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Convert to a tibble so it prints nicely
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam'




























