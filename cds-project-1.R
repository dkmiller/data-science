library(tidyverse)

# Project 1, from the Cornell Data Science course
# https://cdstrainingprogram.github.io/assignments/Project1.pdf


# Using data from a Kaggle competition
# https://www.kaggle.com/miroslavsabo/young-people-survey
# The actual file is:
# https://www.kaggle.com/miroslavsabo/young-people-survey/downloads/responses.csv
setwd("GitHub/data-science/")
survey <- read_csv("cds-young-people.csv")

# Use only columns that are numeric.
survey <- Filter(is.numeric,survey) 
# Rename columns so that reformulate works properly.
colnames(survey) <- gsub(' - ', '__', colnames(survey))


# The baseline effectiveness of a column is the ratio
# (# occurances of  most common value) / (total number of data points)
baseline.effectiveness <- function(col.name) {
  sort(table(survey[[col.name]]), decreasing = TRUE)[1] / length(survey[[col.name]])
}

# Computes effectiveness (# correct predictions / # cases) for the given 
# column. 
effectiveness <- function(col.name) {
  # Split into test / training data for later cross-validation. 
  train.indices <- sample(nrow(survey), 0.8*nrow(survey))
  train <- survey[train.indices,]
  test <- survey[-train.indices,]
  
  form <- reformulate(c("."), response = col.name)
  model <- glm(data = train, formula = form)
  pred <- predict(model, newdata = test) %>%
    round()
  length(pred[pred == test[[col.name]]]) / length(pred)
} 



# Create a table with one column: the column names of survey
model.eff <- tibble(name = colnames(survey))

# Long computation. Create a GLM for each column, and compute its 
# effectiveness. For some reason, the obvious thing to do (mutate) 
# doesn't work here. 
model.eff$eff <- unlist(lapply(model.eff$name, effectiveness))
model.eff$base <- unlist(lapply(model.eff$name, baseline.effectiveness))


# The top ten all have predictive power 30% or more better than "baseline
# effectiveness." 
model.eff %>%
  mutate(improvement = eff - base) %>%
  arrange(desc(improvement)) 
