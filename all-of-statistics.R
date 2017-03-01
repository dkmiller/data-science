# Problems from the book "All of statistics"

library(ggvis)
library(tidyverse)
library(TTR)

# 3.8 Exercises

# 9. Plot the averages of uniform vs. Cauchy distributed random variables. 
df <- tibble(X = rnorm(10000), C = rnorm(10000)) %>%
  mutate(rn = row_number()) %>%
  mutate(Xbar = cumsum(X) / rn, Cbar = cumsum(C) / rn) 

df %>%
  ggvis(~rn, ~Xbar) %>%
  layer_points()

df %>%
  ggvis(~rn, ~Cbar) %>%
  layer_points()

# Xbar converges to the true mean (1/2), while Cbar never converges. 

# 10. 
df <- tibble(Y = 2*rbernoulli(10000) - 1) %>%
  mutate(i = row_number()) %>%
  mutate(X = cumsum(Y)) %>%
  mutate(E = X / i) %>%
  mutate(V = runSD(X, cumulative = T)^2)

# Random behavior...
df %>%
  ggvis(~i, ~X) %>% 
  layer_points()

