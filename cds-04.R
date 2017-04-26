library(ggdendro)
library(ggvis)
library(mclust)
library(tidyverse)

# HW from https://cdstrainingprogram.github.io/assignments/Assignment%204.ipynb
# data from https://www.kaggle.com/uciml/breast-cancer-wisconsin-data
setwd("C:/Users/dm635/Downloads")





# Problem 1 - Hierarchical Clustering


# 1-0 Initial Setup
cancer <- read_csv("cancer.csv") %>% select(-X33)
cancer_modified <- cancer %>% select(-id, -diagnosis)


# 1-1 I am you, and you are me
# no. 3 and 5 are closest (ids 84300903 & 84358402)
dist(cancer_modified %>% head(5))


# 1-2 Hierarchical clustering
hc_cancer <- hclust(dist(cancer_modified), "ward.D2") %>% as.dendrogram()


# 1-3 Dendrogram
ddata <- dendro_data(hc_cancer, type = "rectangle")

# It looks like there are 2-3 clusters, which fits well with the actual cluster number (2).
ggplot(segment(ddata)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) + 
  coord_flip() + 
  scale_y_reverse(expand = c(0.2, 0))





# Problem 2 - K means, Mixture, and PCA


# 2-1 K-Means Clustering
km_model <- cancer_modified %>%
  select(radius_mean, smoothness_mean) %>%
  kmeans(centers = 2, iter.max = 20, nstart=1000)

cancer_data <- cancer_modified %>%
  select(radius_mean, smoothness_mean) %>%
  cbind(km_model$cluster)

names(cancer_data)[3] <- "cluster"

# Original dataset
cancer %>%
  ggvis(~radius_mean, ~smoothness_mean, fill = ~diagnosis) %>%
  layer_points()

# K-means model.
cancer_data %>%
  ggvis(~radius_mean, ~smoothness_mean, fill = ~cluster) %>%
  layer_points()


#2-2 Gausian Mixture Model
model_gmm <- Mclust(select(cancer, radius_mean, smoothness_mean))
summary(model_gmm)

# Plot of GMM classification
cancer %>%
  ggvis(~radius_mean, ~smoothness_mean, fill = ~factor(model_gmm$classification)) %>%
  layer_points()


# 2-3 PC Principal Final Justice
cancer.pca <- prcomp(cancer_modified, center = TRUE, scale. = TRUE)
screeplot(cancer.pca)
