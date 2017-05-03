# Chapter 14 from "R for data science"
# http://r4ds.had.co.nz/strings.html

library(tidyverse)
library(stringr)

# 14.2.5 Exercises

# 1. paste0(..., collapse) === paste(..., sep="", collapse)

# 2. str_c(x, y), where x is a single and y is a vector. Then sep is put 
# between x and the entries of y, while collapse is put between the 
# concatentations of x and individual vectors in y. 

# 3. 
middle <- function(s) {
  x = ceiling(str_length(s)/2)
  str_sub(s, start = x, end = -x)
}

# 4. str_wrap makes a long string into paragraphs. 

# 5. str_trim trims whitespace from the start and end of a string. In 
#contrast, str_pad adds  whitespace to the start and end. 





# 14.3.1.1 Exercises

# 1. The strings "\", "\\", "\\\" don't match because the first consists of 
# just an escape character, the second is the regular expression "\", and the 
# third is an escape character together with a regular expression. 

# 2. 
rgx <- "\"'\\\\"

# 3. The regex \..\..\.. will match "period anything period anything period 
# anything"





# 14.3.2.1 Exercises

# 1. 
rgx <- "^\\$\\^\\$$"

# 2. 
str_view(words, "^y", match = T)
str_view(words, "x$", match = T)
str_view(words, "^...$", match = T)
str_view(words, ".......", match = T)





# 14.3.3.1 Exercises

# 1. 
str_view(words, "^[aeiou]", match = T)
str_view(words, "^[^aeiou]+$", match = T)
str_view(words, "[^e]ed$", match = T)
str_view(words, "(ing|ise)$", match = T)

# 2. Rule fails (weigh)
str_view(words, "[^c]ei", match = T)

# 3. Yes, it is!
str_view(words, "q[^u]", match = T)

# 4. 
str_view(words, ".our", match = T)

# 5. 
rgx <- "\\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d\\d\\d"





# 14.3.4.1 Exercises

# 1. ? === {,1}
#    + === {1,}
#    * === {0,}

# 2.
str_view(words, "^[^aeiou]{3,}", match = T)
str_view(words, "[aeiou]{3,}", match = T)
str_view(words, "([aeiou][^aeiou]){2,}", match = T)





# 14.3.5.1 Exercises

# 2. 
str_view(words, "^(.).*\\1$", match = T)
str_view(words, "(..).*\\1", match = T)
str_view(words, "(.).*\\1.*\\1", match = T)
