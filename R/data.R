#' Simulated hair length data
#'
#' A simulated dataset that shows plausible hair lengths for 3 gender categories.
#'
#' @format `hair_data`
#' A data frame with 1630 rows and 9 columns:
#' \describe{
#'   \item{X}{Row number}
#'   \item{gender}{Gender identification: male, female, or nonbinary}
#'   \item{length}{Hair length in inches}
#'   \item{isFemale_num}{numeric binary indicator for whether observation is female}
#'   \item{isFemale}{Labels for isFemale_num}
#'   \item{isMale_num}{numeric binary indicator for whether observation is male}
#'   \item{isMale}{Labels for isMale_num}
#'   \item{isNonbinary_num}{numeric binary indicator for whether observation is nonbinary}
#'   \item{isNonbinary}{Labels for isNonbinary_num}
#' }
#'
#' @source R/hair_data.R
"hair_data"

#' County level voting and demographics data.
#'
#' Demographics sourced from census.gov in 2019. Voting records from https://github.com/tonmcg/US_County_Level_Election_Results_08-16, sourced from The Guardian (2012) and Townhall.com (2016)
#'
#' @format `county_data`
#' A data frame with 3142 rows and 65 columns:
#' \describe{
#'   \item{FIPS}{Five digit Federal Information Processing Standards code that uniquely identifies counties and county equivalents in the United States}
#'   \item{state}{State name}
#'   \item{county_state}{County and state names for display}
#'   \item{state_abbrv}{State abbreviation}
#'   \item{county}{County name}
#'   \item{pop_estimate16}{Population in the county in 2016}
#'   \item{any_college}{Percent of the county that attended college for some period of time, regardless of whether they got a degree.}
#'   \item{college_2cat_num}{Coded as 1 if the county is categorized as high college attendance, zero if low. See college_2cat for categorization rule.}
#'   \item{college_2cat}{High college attendance counties have over 51.24% college attendance (any_college). Low college attendance counties have under 51.24% college attendance. The mean value of any_college is 51.24.}
#'   \item{prcnt_black}{Percent of the county that is Black.}
#'   \item{prcnt_unemployed}{Percent of the population that is unemployed but looking for employment in 2016.}
#'   \item{prcnt_unemployed_log}{Logged percent of the population that is unemployed but looking for employment in 2016.}
#'   \item{median_income16}{o	Median household income in the county in 2016.}
#'   \item{median_income16_1k}{Median household income in the county in 2016 in units of 1,000 dollars.}
#'   \item{r_shift}{Percentage difference between the Republican presidential vote in that county in 2016 and 2012. For example, 46.7955% of Kent County in Delaware (FIPS 20001) voted for Romney in 2012. In 2016, 49.81482% of that county voted for Trump. Therefore, the county shifted towards the Republican presidential candidate by 3.01325%. Positive value mean leaning more Republican; negative values mean leaning less Republican.}
#'   \item{prcnt_GOP16}{Percent of the county that voted for the Republican presidential candidate, Donald Trump, in 2016.}
#'   \item{plurality_Trump16}{Binary: 0 if less than a plurality of the county that voted for the Republican presidential candidate, Donald Trump, in 2016. 1 otherwise}
#' }
#'
#' @source R/county_data.R
"county_data"

#' County level voting and demographics data for California counties.
#'
#' Demographics sourced from census.gov in 2019. Voting records from https://github.com/tonmcg/US_County_Level_Election_Results_08-16, sourced from The Guardian (2012) and Townhall.com (2016)
#'
#' @format `cali_counties`
#' A data frame with 3142 rows and 65 columns:
#' \describe{
#'   \item{FIPS}{Five digit Federal Information Processing Standards code that uniquely identifies counties and county equivalents in the United States}
#'   \item{state}{State name}
#'   \item{county_state}{County and state names for display}
#'   \item{state_abbrv}{State abbreviation}
#'   \item{county}{County name}
#'   \item{pop_estimate16}{Population in the county in 2016}
#'   \item{any_college}{Percent of the county that attended college for some period of time, regardless of whether they got a degree.}
#'   \item{college_2cat_num}{Coded as 1 if the county is categorized as high college attendance, zero if low. See college_2cat for categorization rule.}
#'   \item{college_2cat}{High college attendance counties have over 51.24% college attendance (any_college). Low college attendance counties have under 51.24% college attendance. The mean value of any_college is 51.24.}
#'   \item{prcnt_black}{Percent of the county that is Black.}
#'   \item{prcnt_unemployed}{Percent of the population that is unemployed but looking for employment in 2016.}
#'   \item{prcnt_unemployed_log}{Logged percent of the population that is unemployed but looking for employment in 2016.}
#'   \item{median_income16}{o	Median household income in the county in 2016.}
#'   \item{median_income16_1k}{Median household income in the county in 2016 in units of 1,000 dollars.}
#'   \item{r_shift}{Percentage difference between the Republican presidential vote in that county in 2016 and 2012. For example, 46.7955% of Kent County in Delaware (FIPS 20001) voted for Romney in 2012. In 2016, 49.81482% of that county voted for Trump. Therefore, the county shifted towards the Republican presidential candidate by 3.01325%. Positive value mean leaning more Republican; negative values mean leaning less Republican.}
#'   \item{prcnt_GOP16}{Percent of the county that voted for the Republican presidential candidate, Donald Trump, in 2016.}
#'   \item{plurality_Trump16}{Binary: 0 if less than a plurality of the county that voted for the Republican presidential candidate, Donald Trump, in 2016. 1 otherwise}
#' }
#'
#' @source R/cali_counties.R
"cali_counties"

