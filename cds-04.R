library(ggvis)
library(tidyverse)

setwd("C:/Users/dm635/Downloads")

cancer <- read_csv("cancer.csv")

cancer_modified <- cancer %>% select(-id, -diagnosis)
