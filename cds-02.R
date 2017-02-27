# Cornell's Data Science class, HW 2
# https://cdstrainingprogram.github.io/assignments/Assignment%202.ipynb

library(tidyverse)


# 1-1 Initial setup
AirData <- as_tibble(datasets::airquality)
volcano <- datasets::volcano

# 1-2 Topographic analysis of volcano
apply(volcano, 1, FUN = max)
apply(volcano, 1, FUN = min)

# 1-3 Mean of Variables in AirData
AirData %>%
  select(Ozone:Temp) %>%
  apply(2, FUN = mean, na.rm = TRUE)

# 1-4 Analysis by Category in AirData
group_by(AirData, Month) %>%
  summarise(avg.temp = mean(Temp, na.rm = TRUE))

group_by(AirData, Month) %>%
  summarise(total.rad = sum(Solar.R, na.rm = TRUE))

# 2-1 Subset selection
tmd <- select(AirData, Temp, Month, Day)
osw <- select(AirData, -Temp, -Month, -Day)

# 2-2 Filtering
largeSolarR <- filter(AirData, Solar.R > 200)

# 2-3 Joins
# [Me: lame choice of using joins!]
