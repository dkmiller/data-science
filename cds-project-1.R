library(magrittr)
library(rpart)
library(tidyverse)

# Using data from a Kaggle competition
# https://www.kaggle.com/miroslavsabo/young-people-survey
# The actual file is:
# https://www.kaggle.com/miroslavsabo/young-people-survey/downloads/responses.csv
setwd("GitHub/data-science/")
survey <- read_csv("young-people.csv") %>%
  select(-`Internet usage`, -`Education`)


# Try to find the features with worst baseline prediction (i.e., the features 
# with least common "most common value"). These will be the features with the 
# "flattest" histograms. 
best <- apply(survey, 2, function(x) { sort(table(x), decreasing = TRUE)[1] / length(x) }) %>%
  sort() %>%
  extract(1:15) 
# Try: `Adrenaline sports`, `Life struggles`, `Writing notes`, `Hiphop, Rap`, 
# `Shopping centres`, `Snakes`, `Alternative`
# All of these have baseline prediction rate <= 25%. 

best <- attributes(best)$names

try.glm <- function(col.name) {
  # Split into test / training data for later cross-validation. 
  train.ind <- sample(nrow(survey), 0.8*nrow(survey))
  train <- survey[train.ind,]
  test <- survey[-train.ind,]
  
  form <- reformulate(c("."), response = col.name)
  model <- glm(data = train, formula = form)
  pred <- predict(model, newdata = test) %>%
    round()
  length(pred[pred == test[[col.name]]]) / length(pred)
} 

best %>%
  mutate(effect = try.glm(name))

effectiveness <- tibble(col.name = c("Adrenaline sports", "Life struggles", "")) %>%
  mutate(effect = try.glm(col.name))

for(name in best) {
  print(name)
  print(try.glm(name))
}

try.glm("Adrenaline sports")
try.glm("Life struggles")
try.glm("Writing notes")
try.glm("Snakes")


# Split into test / training data for later cross-validation. 
train.ind <- sample(nrow(survey), 0.8*nrow(survey))
train <- survey[train.ind,]
test <- survey[-train.ind,]

model <- glm(data = train, Alternative ~ .)
predict <- predict(model, newdata = test) %>% round()

length(predict[predict == test$Alternative]) / length(predict)
