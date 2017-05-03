library(tidyverse)

setwd("C:/Users/dm635/Documents/GitHub/tidbits/2017-03-13_L_sgn")

prepare.Lval <- function(name, s) {
  read_csv(name) %>% 
    mutate(sgn = sign(trace)) %>%
    mutate(euler = 1/(1 - sgn*prime^(-s))) %>%
    mutate(L = cumprod(euler)) 
}

prepare.L <- function(name) {
  read_csv(name) %>% 
    mutate(sgn = sign(trace)) %>%
    mutate(euler = 1/(1 - sgn/prime)) %>%
    mutate(L = cumprod(euler)) 
}

# It seems like L_sgn(E,1) knows the product of rank(E) and the Tamagawa numbers.

# [0, 0, 1, -1, 0]
# rank 0: to L(1) = 2.9019...
# regulator = 0.0511114082399688
# Omega = 5.98691729246392
# prod c_p = 1
# #E_tor = 1
# Sha_an = 1
prepare.L("rank0.csv") %>% tail()

prepare.L("14a1_lpdata.txt") %>% tail()



# [0, 0, 1, -1, 0]
# rank 1: to L(1) = 4.9987...
# regulator = 0.05111140824
# Omega = 5.98691729246
# prod c_p = 1
# #E_tors = 1
# Sha_an = 1
prepare.L("rank1.csv") %>% tail()

# [0, 1, 1, -2, 0]
# rank 2: L(1) = 6.5930...
# regulator = 0.152460177943
# Omega = 4.98042512171 
# prod c_p = 1
# #E_tors = 1
# Sha_an = 1
prepare.L("rank2.csv") %>% tail()

# rank 3: L(1) = 7.6268...
# regulator = 0.417143558758
# Omega = 4.15168798309
# prod c_p = 1
# E_tor = 1
# Sha_an = 1
prepare.L("rank3.csv")  %>% tail()

# [1, -1, 0, -79, 289]
# rank 4: L(1) = 4.3983...
# regulator = 1.50434488828
# Omega = 	2.97267184726
# prod c_p = 2
# E_tor = 1
# Sha_an = 1
prepare.L("rank4.csv") %>% tail()

# [0, 0, 1, -79, 342]
# rank 5 : L(1) = 9.0622...
# regulator = 14.7905275701311
# prod c_p = 1
# #E_tors = 1
# Sha_an = 1
prepare.L("rank5.csv") %>% tail()

# [1, 1, 0, -2582, 48720]
# rank 6: L(1) = 3.4056...
# regulator = 68.2713769131913
# Omega = 1.17465465757293
# prod c_p = 4
# #E_tors = 1
prepare.L("rank6.csv") %>% tail()

# [0,0,0,-10012,346900]
# rank 7 : L(1) = 5.2023...
# prod c_p = 4
prepare.L("rank7.csv") %>% tail()

# rank 8 : L(1) = 4.5498...
prepare.L("rank8.csv") %>% tail()

# rank 9 : L(1) = 5.6004...
prepare.L("rank9.csv") %>% tail()

# rank 10 : L(1) = 9.8209...
prepare.L("rank10.csv") %>% tail()
