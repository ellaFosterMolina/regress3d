# Creating simulated data on hair length for women, men, and nonbinary folks
# Originally in C:\Users\Ella\Dropbox\fr17to_swat\2020Fall\RAs\anovaRegressionPlaneCode.R
# Modified 2024-08-14

usethis::use_data(hair_data, overwrite = F)

library(tidyr)
library(dplyr)

# simulated population size
num_men <- 800
num_women <- 800
num_nonbin <- 50

#create simulated data on hair length
#weibull https://en.wikipedia.org/wiki/Weibull_distribution
amplificationFactor = 4
hair <- data.frame(female = amplificationFactor*rweibull(num_men, shape =2, scale = 3 ),
                   male = rweibull(num_men, shape = 1.5, scale = 2.2))


hairLong <- hair %>% pivot_longer(everything(),names_to="gender", values_to = "length" )

hairLongNB <- hairLong %>% bind_rows(data.frame(gender = rep( "nonbinary", num_nonbin),
                                                length = 2*rweibull(num_nonbin, shape = .9, scale =2.2)))

hairLongNB <-hairLongNB %>%
  mutate(dummy = 1, genderPivot = gender) %>%
  pivot_wider(names_from = genderPivot, values_from = dummy, values_fill=0)

hair_data <-hairLong %>%
  mutate(dummy = 1, genderPivot = gender) %>%
  pivot_wider(names_from = genderPivot, values_from = dummy, values_fill=0)

# save(hair_data, file = "hair_data.Rda")

