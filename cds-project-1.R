library(tidyverse)

# Using data from a Kaggle competition
# https://www.kaggle.com/miroslavsabo/young-people-survey
# The actual file is:
# https://www.kaggle.com/miroslavsabo/young-people-survey/downloads/responses.csv
setwd("GitHub/data-science/")
survey <- read_csv("cds-young-people.csv")

# Use only columns hat are numeric.
survey <- Filter(is.numeric,survey) 
# Rename columns so that reformulate works properly.
colnames(survey) <- gsub(' - ', '__', colnames(survey))


# Create a table with one column: the column names of survey
model.eff <- tibble(name = colnames(survey))


# Computes improvement over baseline effectiveness. 
eff.imp <- function(col.name) {
  # Split into test / training data for later cross-validation. 
  train.ind <- sample(nrow(survey), 0.8*nrow(survey))
  train <- survey[train.ind,]
  test <- survey[-train.ind,]
  
  form <- reformulate(c("."), response = col.name)
  model <- glm(data = train, formula = form)
  pred <- predict(model, newdata = test) %>%
    round()
  eff <- length(pred[pred == test[[col.name]]]) / length(pred)
  bas.eff <- sort(table(survey[[col.name]]), decreasing = TRUE)[1] / length(survey[[col.name]])
  res <- eff - bas.eff
  attributes(res) <- NULL
  unlist(res)
} 


model.eff$eff <- unlist(lapply(model.eff$name, eff.imp))



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




effectiveness <- tibble(name = colnames(survey))

effectiveness %>%
  mutate




