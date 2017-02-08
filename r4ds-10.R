library(tibble)
library(ggvis)

# Learn about tibbles
vignette("tibble")

# Corollation between sepal length and petal length? Seems like yes!
as_tibble(iris) %>%
  ggvis(~Sepal.Length, ~Petal.Length) %>%
  layer_points()

# Creating a tibble
tibble(
  x = 1:5,
  y = 1,
  z = x^2+y
)

# Bad column names
tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

# Transposed tibble
tribble(
  ~x, ~y, ~z,
  "a", 2, 3.4,
  "b", 1, 5.6
)

# Large tibbles display pretty nicely
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# Selectively displaying data
nycflights13::flights %>%
  print(n = 10, width = Inf)
nycflights13::flights %>%
  View()

# extraction by name or position
df <- tibble(x = runif(5), y = rnorm(5))

df$x
df[["x"]]
df[[1]]

# Extraction by pipes
df %>%
  .$x

# 10.5 Exercises

#1 printing a tibble, the result will start out with "A tibble: dim1 x dim2"

#2
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

# When it's a tibble, the result is always a tibble.
df <- tibble(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]
