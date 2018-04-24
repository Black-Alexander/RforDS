library(tidyverse)
library(MASS)

## https://www.linkedin.com/pulse/weighted-linear-regression-r-blaine-bateman-eaf-llc/
## Blaine Bateman example problem on Weighted Lin regression
# model <- lm(y ~ x, data = x_data)
# y_pred <- predict(model, data = new_x_data)


## Generate data for regression
set.seed(1)
x_data <- seq(1, 100, 1)
y_raw <- 3.5 + 2.1 * x_data
y_noise <- rnorm(n = 100, mean = 0, sd = 5)

y <- data.frame(x = x_data, y = y_raw + y_noise)

## Model

pred <- lm(y ~ x, data = y)

plot(pred)

resid(pred) # list of residuals

ggplot(data = pred, aes(x = resid(pred))) +
  geom_histogram() +
  geom_density(aes(y = ..count..)) +
  theme_bw()

ggplot(data = pred, aes(x = resid(pred))) +
  geom_histogram(aes(y = ..density..)) +
  geom_density(aes(y = ..density..)) 
theme_bw()

ggplot(data = pred, aes(x = resid(pred))) +
  stat_bin(geom = "bar", position = "dodge", bins = 15) +
  theme_bw()

summary(pred)

######### Test messier data

set.seed(2)

X_data2 <- seq(1, 1000, 1)

#

# Y is linear in x with uniform, periodic, and skewed noise

#

Y_raw2 <- 1.37 + 2.097 * x_data2

Y_noise2 <- (X_data2 / 100) * 25 * (sin(2 * pi * X_data2/100)) * 
  
  runif(n = length(X_data2), min = 3, max  = 4.5) +
  
  (X_data2 / 100)^3 * runif(n = 100, min = 1, max = 5)

Y <- data.frame(X = X_data2, Y = Y_raw2 + Y_noise2)

model2 <- lm(Y ~ X, data = Y)
plot(model2)
summary(model2)

ggplot(data = model2, aes(x = resid(model2))) +
  geom_histogram(aes(y = ..density..)) +
  geom_density() +
  theme_bw()

## heteroskedasticity: residuals do exhibit the unwanted
## variations we observe (need homoskedasticity)

# Could apply weights to the linear regression model
# How to normalize data


# Weighted_fit <- rlm(Y ~ X, data = Y, weights = 1/sd_variance)

########################################################################

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Fuel economy declination") +
  theme(plot.title = element_text(size = rel(1.5)),
        plot.background = element_rect(fill = "gray"),
        panel.border = element_rect(linetype = "dashed", fill = NA),
        panel.grid.major = element_line(colour = "black"),
        # panel.grid.major.y = element_blank() # remove y grids
        # panel.grid.major.x = element_blank() # remove x grids
        
        ## Axes
        axis.line = element_line(size = 3, colour = "grey80"),
        axis.text = element_text(colour = "red"),
        axis.ticks = element_line(size = 2),
        axis.ticks.length = unit(0.25, "cm"),
        axis.title.y = element_text(size = rel(1.5), angle = 90),
        axis.title.x = element_text(size = rel(1))
        
        ## Legend
        
        
  )




