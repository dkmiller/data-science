library(ggvis)
library(magrittr)
library(tidyverse)

# Recreation of Figure 3.4 on p. 67. 
df <- tibble(
  x = rnorm(300),
  y = rnorm(300)
)

# If you condition on a collider variable, spurious correlations can ensue. 
df %>%
  ggvis(~x,~y) %>%
  layer_points(fill = ~factor(x+y > 1))

# Basically no correlation between x and y.
df %$% cor(x,y)

# Strong negative correlation between x and y. 
df %>%
  filter(x+y>1) %$%
  cor(x,y)
