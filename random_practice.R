library(tidyverse)
library(MASS)
library(gridExtra)

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
  geom_density(aes(y = ..density..)) +
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
        panel.grid.minor = element_line(colour = "grey"), 
        # panel.grid.major.y = element_blank() # remove y grids
        # panel.grid.major.x = element_blank() # remove x grids
        
        ## Axes --------------------------------------------- 
        
        axis.line = element_line(size = 3, colour = "grey80"),
        axis.text = element_text(colour = "red"),
        axis.ticks = element_line(size = 2),
        axis.ticks.length = unit(0.25, "cm"),
        axis.title.y = element_text(size = rel(1.5), angle = 90),
        axis.title.x = element_text(size = rel(1))
        
  
  )


## Legend ---------------------------------------------------

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl), shape = factor(vs))) +
  labs(
    title = "Weights and Mpg",
    x = "Weight (1000 lbs)",
    y = "Fuel economy (mpg)",
    colour = "Cylinders",
    shape = "Transmission") + 
  theme(legend.justification = c("right","top"),
        legend.title = element_text(face = "bold"),
        legend.position = c(.95, .95), #"bottom"
        legend.box.just = "right",
        legend.margin = margin(2, 2, 2, 2),
        legend.key.size = unit(.25, "cm"),
        #legend.key.width = unit(5, "cm")
        #legend.text = element_text(colour = 'red'
         #, angle = 45, size = 10, hjust = 3, vjust = 3, face = 'bold')
        #legend.box.background =  element_rect(),
        legend.background = element_rect(colour = "light gray", size = .25), 
        plot.title = element_text(size = rel(1.5)),
        plot.margin = margin(15, 15, 15, 15),
        plot.background = element_rect(fill = "gray", linetype = "dashed"),
        panel.grid.minor = element_line(colour = "grey"),
        panel.border = element_rect(linetype = "dashed", fill = NA),
        axis.title.y = element_text(colour = "black"),
        axis.ticks = element_line(colour = "black")
        )

## Strips -----------------------------------------------------

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  facet_wrap( ~ cyl ) +
  theme(
    strip.background = element_rect(colour = "black", fill = "light pink"),
    strip.text = element_text(colour = "white", face = "bold"),
    panel.spacing = unit(1, "lines")
    
    )


# par(mfrow = c(2,1))

p1 <- ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  facet_wrap( ~ cyl) +
  theme(
    strip.background = element_rect(colour = "black", fill = "light pink"),
    strip.text = element_text(colour = "white", face = "bold"),
    panel.spacing = unit(1, "cm")
    
  )


ggplot(data = mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
  geom_point() +
  facet_wrap( ~ cyl) +
  labs(
    title = "Weights and Mpg",
    sub = "Subtitle",
    x = "Weight (1000 lbs)",
    y = "Fuel economy (mpg)",
    colour = "Cylinders",
    shape = "Transmission") +
  # ylim(c(0,100)) + # limit y axis range
    # alternatives to limit range
    # scale_x_continuous(limits = c(0,50))
  theme(
    strip.background = element_rect(colour = "black", fill = "light pink"),
    strip.text = element_text(colour = "white", face = "bold"),
    panel.spacing = unit(1, "lines"),
    plot.title = element_text(size = 10, hjust = 0.5, lineheight = 0.8,
                              vjust = 1),
     #hjust = 0.5 to center or margin = margin(10, 0 ,10 ,0)
    plot.subtitle = element_text(size = rel(.6)),
    axis.ticks = element_blank(),
    axis.text = element_blank(), # remove tick text and ticks
    #axis.text.x = element_text(color, angle , size , vjust ) # change size of and rotate axis text
    #legend.title = element_blank()
    legend.title = element_text(colour = "chocolate", size = 10, face = "bold"),
    legend.key = element_rect(fill = "light pink"),
    panel.grid.major = element_line(colour = "grey"),
    panel.grid.minor = element_line(colour = "grey")
    # plot.background = element_rect(fill = NA)
    
    ) +
  scale_color_discrete(name = "Cylindas")


# grid.arrange(p1,p2,nrow = 2)
# additional practice
# http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/







