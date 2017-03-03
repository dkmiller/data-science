# Problem set 3 from Cornell Data Science class
# https://cdstrainingprogram.github.io/assignments/Assignment%203.ipynb

# Problem 1 - Basic Data Visualization

library(ggmap)
library(ggvis)
library(plotly)
library(tidyverse)

cancer <- read_csv("../Downloads/data.csv")

# 1-1 Basic Data Visualization with Histogram
# Data set: https://www.kaggle.com/uciml/breast-cancer-wisconsin-data
cancer %>%
  filter(area_se <= 150) %>%
  ggvis(~area_se) %>%
  layer_histograms(width = 10)

# 1-2 Density Plot
cancer %>%
  filter(area_se <= 150) %>%
  ggvis(~area_se) %>%
  layer_densities()

# 1-3 Correlation Analysis
# concavity_mean and compactness_mean show the highest correlation. 
cancer %>%
  select(compactness_mean, concavity_mean, `concave points_mean`, symmetry_mean) %>%
  cor()

cancer %>%
  ggvis(~concavity_mean, ~compactness_mean) %>%
  layer_points()

# 1-4 Make GG Plot Again
cancer %>%
  ggvis(~`concave points_mean`, ~symmetry_mean) %>%
  layer_points(fill = ~diagnosis)

# 1-5 Box Plot
cancer %>%
  ggvis(~diagnosis, ~radius_worst) %>%
  layer_boxplots()

# 1-6 Scatterplot 3D
plot_ly(cancer, 
  x = ~texture_worst, 
  y = ~radius_worst, 
  z = ~`concave points_worst`, 
  color = ~diagnosis, 
  colors = c('green', 'red')) %>%
  add_markers() %>%
  layout()





# Problem 2 - Advanced Data Visualization
# Data set: https://www.kaggle.com/c/predict-west-nile-virus/data

# 2-0 Initial Setup
nile <- read_csv("../Downloads/train.csv")

# 2-1 Map Map
qmap("Chicago, IL", zoom = 11, maptype = "roadmap") +
  geom_point(data = nile, aes(x = Longitude, y = Latitude), color = "red") +
  geom_density2d(data = nile, aes(x = Longitude, y = Latitude))

# 2-2 Contour Plot
qmap("Chicago, IL", zoom = 11, maptype = "roadmap") +
  geom_point(data = nile, aes(x = Longitude, y = Latitude), color = "red") +
  geom_density2d(data = nile, aes(x = Longitude, y = Latitude))

# 2-3 Interactive Plotly
g = list(
  scope = "usa",
  showland = TRUE,
  landcolor = toRGB("grey83"),
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white"),
  showlakes = TRUE,
  showsubunits = TRUE
)

plot_geo(
  nile, 
  lat = ~Latitude, 
  lon = ~Longitude) %>%
  add_markers(
    text = nile$Species, 
    hoverinfo = "text"
  ) %>%
  layout(title = "Test title", geo = g)
