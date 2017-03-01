# Problems from the book "All of statistics"

library(ggvis)
library(tidyverse)

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

