## code to prepare `county_data` dataset goes here

load("C:\\Users\\Ella\\Dropbox\\research\\dira\\threeD_regressions_DiRA\\functions_data\\countyData.Rda")
library(tidyverse)
county_data <- countyData
county_data <- county_data %>%
  select(FIPS, state, countyState, stateAbbrv, county, popEstimate16, anyCollege,
         college_2cat, college_2cat_num, prcntWhiteNotLatino, prcntBlack, prcntUnemployed,
         poverty, popChg15, medianIncome16, rShift, prcntGOP12, prcntGOP16, prcntDem12,
         prcntDem16, totalVote, region)
names(county_data) <- c("FIPS", "state", "county_state", "state_abbrv", "county", "pop_estimate16", "any_college",
                        "college_2cat", "college_2cat_num", "prcnt_white_not_latino", "prcnt_black", "prcnt_unemployed",
                        "poverty", "pop_chg15", "median_income16", "r_shift", "prcnt_GOP12", "prcnt_GOP16", "prcnt_dem12",
                        "prcnt_dem16", "total_vote", "region")
county_data <- county_data %>%
  mutate(plurality_vote16 = case_when(prcnt_GOP16 > prcnt_dem16 ~ "Trump",
                                      prcnt_GOP16 < prcnt_dem16 ~ "Clinton"),
         plurality_Trump16 = case_when(prcnt_GOP16 > prcnt_dem16 ~ 1,
                                       prcnt_GOP16 < prcnt_dem16 ~ 0),
         .after = prcnt_dem16)

usethis::use_data(county_data, overwrite = TRUE)
