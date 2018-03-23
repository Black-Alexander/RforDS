setwd('C:/Users/Sky/Documents/R/win-library/3.4')

## Basic R Review Chapter 3

library(tidyverse)

p1 <- ggplot(data = mpg) + 
  ## Mapping argument: Defines how variables in your ds are mapped to visual properties
  geom_point(mapping = aes(x = displ, y = hwy))

## This looks the same w/o the mapping argument
p2 <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

## Aesthetic mappings

p3 <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

p4 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

p5 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

p6 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

## Facets

p7 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

p8 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

p9 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

## Creating smooth lines (LOESS)

p10 <- ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

## Split LOESS line by drv values (3 total)
p11 <- ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

p12 <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ,y = hwy, linetype = drv, color = drv)
              , show.legend = FALSE)

p13 <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  theme_bw()

## p13 = p14
p14 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth() +
  theme_bw()





















