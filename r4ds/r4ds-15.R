library(ggvis)
library(forcats)
library(tidyverse)

# 15.3.1 Exercises

# 1. All the labels bump over each other, so it's hard to see what they are.
gss_cat %>%
  count(rincome) %>%
  ggvis(~rincome, ~n) %>%
  layer_boxplots() %>%
  add_axis("x", properties = axis_props(labels = list(angle = 90, align = "left")))
# Rotating the labels helps!

# 2. 
# Most common religion: protestant
gss_cat %>%
  count(relig) %>%
  arrange(desc(n))
# Most common party: hard to say from the data.
gss_cat %>%
  count(partyid) %>%
  arrange(desc(n))

