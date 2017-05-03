library(lubridate)
library(nycflights13)
library(tidyverse)





# 16.2.4 Exercises

# 1. You get a warning message and it returns NA. 
ymd(c("2010-10-10", "bananas"))

# 2. You can get the current date in another time zone. 
# This is important because it can be different days at the same time 
# around the world. 

# 3. 
mdy("January 1, 2010")
ymd("2015-Mar-07")
dmy("06-Jun-2017")
mdy(c("August 19 (2015)", "July 1 (2015)"))
mdy("12/30/14")
