## setwd('C:/Users/User/Documents/R/win-library/3.4')

library(tidyverse)
library(nycflights13)

####### Chapter 13: Relational data

airlines
airports
planes
weather

planes %>% 
  count(tailnum) %>% 
  filter(n>1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

flights2 %>%
  select(-origin, -dest) %>% 
  mutate(names = airlines$name[match(carrier, airlines$carrier)]) %>% 
  select(names)

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

x %>% 
  inner_join(y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")


####### Chapter 14: String Manipulation




















