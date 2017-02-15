# Chapter 12: tidy data

library(tidyverse)

# 4 tables, only one is well formatted.
table1
table2
table3

# This one is especially bad.
table4a

tidy4a <-table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")

tidy4b <- table4b %>%
  gather(`1999`, `2000`, key = "year", value = "population")

left_join(tidy4a, tidy4b)

spread(table2, key = type, value = count)

# 12.3.3 Exercises

#1. Why are gather and spread not symmetrical?

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half   = c(   1,    2,    1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
  spread(year, return) %>%
  gather("year", "return", `2015`:`2016`)
