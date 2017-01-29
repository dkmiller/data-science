library("gsl")
library("tidyverse")
setwd("/Users/dm635/Documents/GitHub/tidbits/2016-11-15_Kolmogorov-Smirnov")

df <- read.csv("11a1.csv")
primes <- select(df, prime)
hist(primes$prime, breaks = 50, prob = TRUE)
Li <- function(x) { expint_Ei(log(x)) - expint_Ei(log(2)) }

cdf <- function(t) {Li(10000000*t) / Li(10000000)}
ks.test(primes$prime / 10000000, cdf)
