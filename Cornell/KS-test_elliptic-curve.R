library(ggvis)
library(tidyverse)

setwd("../tidbits/2017-03-13_L_sgn")

# Data from a rank 0 elliptic curve
df <- read_csv("rank0.csv") %>%
  mutate(Satake = acos(trace / (2*prime^0.5)))

# Expected distribution.
tibble(KS = replicate(10000, ks.test(rnorm(100), pnorm)$statistic)) %>%
  ggvis(~KS) %>%
  layer_histograms()

# CDF of Sato-Tate distribution
cdf.ST <- function(x) {
  ifelse(x <= 0, 0, 
         ifelse(x <= pi, 
                (x - sin(x)*cos(x)) / pi,
                1))
}

# Store KS test(100 Satake params) for a bunch of examples. 
v <- c()
for(i in 1:70000) {
  range <- c(i:(i+99))
  v[i] <- ks.test(df$Satake[range], cdf.ST)$statistic
}

# Success! The distribution of KS test(100 Satake params) seems to 
# converge to the expected distribution. 
tibble(KS = v) %>%
  ggvis(~KS) %>%
  layer_histograms()
