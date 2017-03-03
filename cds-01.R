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

NewGenderDist <- tribble(
  ~major, ~male, ~female,
  "material science", 21, 32,
  "mechanical engineering", 205, 78,
  "unaffiliated", 746, 690
) %>%
  full_join(GenderDist)

NewGenderDist %>%
  mutate(malevsfemale = female - male)


# Problem 2 - initial analysis.
titanic <- read_csv("https://query.data.world/s/7kzir5uonudtrjdkvy8nm9zpm")
titanic
summary(titanic)
# 1309 observations, 14 variables. pclass, survived, sex, embarked are factors. 

# 2-3. subsets of data
titanic %>%
  filter(age < 1) %>%
  select(age)

malePassengers <- titanic %>%
  filter(sex == "male") %>%
  select(-sex)

# 2-4 max, mean, sd.
summary(malePassengers$age)
sd(malePassengers$age, na.rm = TRUE)
