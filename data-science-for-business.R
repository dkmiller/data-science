library(ggvis)
library(tidyverse)

# Examples from the book "Data science for business" by Foster Provost and Tom 
# Fawcett. 





# Chapter 3. Mushroom classification (poisonous vs. non-poisonous). 
# Data set from UCI. 

shroom_URL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"
shroom_features <- c("class", "cap_shape", "cap_surface", "cap-color", 
                     "bruises", "odor", "gill_attachment", "gill_spacing", 
                     "gill_size", "gill_color", "stalk_shape", "stalk_root", 
                     "stalk_surface_above_ring", "stalk_surface_below_ring", "stalk_color_above_ring", "stalk_color_below_ring", 
                     "veil_type", "veil_color", "ring_number", "ring_type", 
                     "spore_print_color", "population", "habitat")

shrooms <- read_csv(shroom_URL, col_names = shroom_features)

# Computes Shannon entropy of a frequency vector. 
shannon.entropy <- function(freqs) {
  probs <- freqs / sum(freqs)
  -sum(probs * log2(probs))
}

# Compute and plot an entropy chart for the attribute `gill_color`.
df <- shrooms %>%
  group_by(gill_color, class) %>%
  summarise(count = n()) %>%
  group_by(gill_color) %>%
  summarize(entropy = shannon.entropy(count), count = sum(count)) %>%
  arrange(desc(entropy))

barplot(df$entropy,df$count, space = 0, names.arg = df$gill_color)

