# Exercise: EDA from Chapter 2 of the book "Doing data science"

library(ggplot2)
library(ggvis)
library(tidyverse)

nyt1 <- read_csv("http://stat.columbia.edu/~rachel/datasets/nyt1.csv")

nyt1 <- nyt1 %>%
  mutate(age_group = cut(Age, breaks = c(-Inf,17,24,34,44,54,64,Inf)))

nyt1 <- nyt1 %>%
  mutate(age_group = as.character(age_group))

nyt1 <- nyt1 %>%
  mutate(CTR = Clicks / Impressions)

nyt1 %>%
  ggvis(~CTR) %>%
  layer_histograms()

ggplot(data = nyt1, mapping = aes(x = CTR, color = age_group)) + 
  geom_freqpoly(binwidth = 0.01)
