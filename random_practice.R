library(tidyverse)


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
  theme_bw()





########################################################################






