# HW 1 for Cornell's Data Science class, spring 2017. 
# http://nbviewer.jupyter.org/github/cdstrainingprogram/cdstrainingprogram.github.io/blob/master/assignments/Assignment%201.ipynb
# http://datascienceis.life

library(tidyverse)
gender <- c("male", "male", "male", "female", "female") %>%
  as.factor()

x <- seq(-pi,pi,0.1)
plot(x, sin(x))

airquality$Temp %>%
  hist()

boxplot(airquality$Ozone)

# Problem 1 - data structure.

# Parts 1-2. Create vectors & data frame.
GenderDist <- tribble(
  ~major, ~male, ~female,
  "biomedical engineering", 23, 65,
  "computer science", 326, 134,
  "info science", 20, 23,
  "chemical engineering", 88, 99,
  "operation research", 110, 107
)

GenderDist$female %>%
  max()
GenderDist$female %>%
  mean()
GenderDist$female %>%
  sd()
