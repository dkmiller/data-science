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

# 2-0 Create indices column
AirData <- mutate(AirData, ind = rownames(AirData))

# 2-1 Subset selection
tmd <- select(AirData, ind, Temp, Month, Day)
osw <- select(AirData, -Temp, -Month, -Day)

# 2-2 Filtering
largeSolarR <- filter(osw, Solar.R > 200)

# 2-3 Joins
largeSolarR %>%
  inner_join(tmd, by = "ind")

#2-4 Aggregation, counting
AirData %>%
  group_by(Month) %>%
  summarise(tempByMonth = sd(Temp, na.rm = TRUE))

AirData %>%
  group_by(Month) %>%
  summarise(monthFreq = sum(!is.na(Temp)))

# 2-5 Feature generation using mutate
AirData %>%
  mutate(TempC = (Temp - 32) * (5/9))

# 3 Data manipulation continued
titanic <- read_csv("https://query.data.world/s/7kzir5uonudtrjdkvy8nm9zpm")

# 3-1 Split name column
titanic <- titanic %>%
  separate(name, c("LastName", "temp"), sep = ",")

titanic <- titanic %>%
  separate(temp, c("Title", "FirstName"), sep = "[.]", extra = "merge")

# titanic[475,]
# A name with two periods!

# 3-2 Combine columns
titanic %>%
  mutate(FullName = paste(FirstName, LastName, sep = " "))
