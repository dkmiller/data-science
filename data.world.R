library(ggvis)

df <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/airline-safety/airline-safety.csv", header = TRUE)

head(df)

# There's an extreme outlier with >70 incidents
df %>%
  ggvis(~incidents_85_99, ~fatalities_85_99) %>%
  layer_points()

# Let's find the outlier. It's Aeroflot! 
df[df$incidents_85_99 > 70, ]

# Let's compare fatalities per avail_seat_km_per_week
df %>%
  ggvis(~avail_seat_km_per_week, ~fatalities_85_99) %>%
  layer_points(fill = ~factor(airline))
