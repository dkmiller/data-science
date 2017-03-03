library(ggplot2)
library(nycflights13)
library(tidyverse)

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))

diamonds %>%
  count(cut)

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.2)

diamonds %>%
  count(cut_width(carat, 0.5))

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

unusual <- diamonds %>%
  filter(y < 3 | y > 20) %>%
  arrange(y)

# 7.3.4 Exercises

# 2. It appears that there are no diamonds with prices in the $1450-$1550 range. 
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 10) +
  coord_cartesian(xlim = c(1300,1700))

# 3. A lot more diamonds are 1 carat, probably because a nice number like that sells better. 
sum(diamonds$carat == 0.99)
sum(diamonds$carat == 1)


diamonds2 <- diamonds %>%
  mutate(y = ifelse(y<3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()

# 7.4.1 Exercises

# 1. Missing values give a warning, but are removed. 
ggplot(diamonds2) +
  geom_histogram(mapping = aes(x = y), binwidth = 10)

# 2. na.rm
mean(diamonds2$y)
mean(diamonds2$y, na.rm = TRUE)
sum(diamonds2$y)
sum(diamonds2$y, na.rm = TRUE)

# 7.5

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()




