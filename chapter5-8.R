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

## Find the worst members of each group
flights %>% 
  group_by(year, month) %>% 
  filter(rank(desc(arr_delay)) < 10)

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365 
  )

popular_dests %>% 
  group_by(dest) %>% 
  select(carrier, dest) %>% 
  arrange(dest)


####### Chapter 7: Exploratory Data Analysis

# Generate questions about your data
# Search for answers by visualizing, transforming, and modelling
# use what you learn to refine your questions and/or generate new Q's

## Visualizing distritibutions

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(cut))

diamonds %>% 
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

## Find counts from the histogram

diamonds %>% 
  count(cut_width(carat, 0.5))

## Overlay multiple histograms then use geom_freqpoly

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

(unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
)

## Replace missing values so data is not included using mutate()

diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

head(diamonds2$y)

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

## Suppress warning na warning with na.rm = TRUE

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

## Use mutate() to create new variables for the df

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)




   