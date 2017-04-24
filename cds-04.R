library(ggvis)
library(tidyverse)

setwd("C:/Users/dm635/Downloads")

cancer <- read_csv("cancer.csv") %>% select(-X33)

cancer_modified <- cancer %>% select(-id, -diagnosis)

# no. 3 and 5 are closest (ids 84300903 & 84358402)
dist(cancer_modified %>% head(5))

hc_cancer <- hclust(dist(cancer_modified), "ward.D2") %>% as.dendrogram()
