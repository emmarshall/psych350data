#' Superman Actor Data
#'
#' Data on 11 actors who have portrayed Clark Kent/Superman across various media,
#' including height measurements, Rotten Tomatoes scores, and Letterboxd ratings.
#'
#' @format A tibble with 11 rows and 21 variables:
#' \describe{
#'   \item{num}{Unique number for each actor}
#'   \item{media}{Title of media (1-10, see value labels)}
#'   \item{year}{Year of release}
#'   \item{type}{Type of media: Film (1), TV Series (2), Serial (3)}
#'   \item{clark_height}{Height of Superman actor in meters}
#'   \item{lois_height}{Height of Lois Lane actor in meters (NA if unknown)}
#'   \item{rt_critics_score}{Rotten Tomatoes critics score (0-100)}
#'   \item{rt_critic_count}{Number of critic reviews}
#'   \item{rt_audience_score}{Rotten Tomatoes audience score (0-100)}
#'   \item{rt_audience_count}{Number of audience ratings}
#'   \item{ldb_likes}{Letterboxd user likes}
#'   \item{ldb_scores}{Letterboxd average rating (1-5 stars)}
#'   \item{clark_height_in}{Height of Superman actor in inches}
#'   \item{lois_height_in}{Height of Lois Lane actor in inches}
#'   \item{clark_grp}{Whether Superman actor is over 6ft: under (1), over (2)}
#'   \item{height_diff}{Height difference in inches}
#'   \item{height_gap}{Height gap category: minimal (1), average (2), big (3)}
#'   \item{tomatometer}{Fresh (2) or Rotten (1) on Rotten Tomatoes}
#'   \item{rt_avg}{Average of critics and audience scores}
#'   \item{rt_diff}{Weighted difference between critics and audience}
#'   \item{popular}{Popularity: low (1), mid (2), high (3)}
#' }
#'
#' @source Rotten Tomatoes, Letterboxd, IMDB
"superman"


#' Superman SMES Data
#'
#' Simulated data for 47 participants rating Superman media on the
#' Subjective Media Experience Scale (SMES), grouped by height gap
#' between the Superman and Lois Lane actors.
#'
#' @format A data frame with 47 rows and 5 variables:
#' \describe{
#'   \item{num}{Unique participant number}
#'   \item{height_gap}{Height gap category: Minimal (1), Average (2), Big (3)}
#'   \item{emotional_impact}{Emotional Impact subscale (sum of 4 items, range 4-20)}
#'   \item{aesthetic_appeal}{Aesthetic Appeal subscale (sum of 3 items, range 3-15)}
#'   \item{cognitive_engagement}{Cognitive Engagement subscale (mean of 4 items, range 0-7)}
#' }
"superman_smes"


#' Hot Ones Guest Data
#'
#' Data on guests from the YouTube show Hot Ones, including demographic
#' information, Scoville ratings for each sauce, and YouTube engagement metrics.
#' Categorical variables (gender, result, occupation) are stored as numeric codes.
#' Views are in millions.
#'
#' @format A tibble with variables including:
#' \describe{
#'   \item{subn}{Unique guest/participant number}
#'   \item{name}{Guest full name}
#'   \item{gender}{Guest gender: Male (1), Female (2)}
#'   \item{age}{Guest age at time of appearance}
#'   \item{occupation}{Guest primary occupation (1-14, see value labels)}
#'   \item{SHU_1 through SHU_10}{Scoville Heat Units for sauces 1-10}
#'   \item{result}{Succeeded (1) or Failed (2)}
#'   \item{appearances}{Number of appearances on the show}
#'   \item{season}{Season number}
#'   \item{order}{Episode number within season}
#'   \item{views}{YouTube views (in millions)}
#'   \item{likes}{YouTube likes}
#'   \item{comments}{YouTube comments}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hot_ones"


#' Tip-Jokes Experiment Data
#'
#' Data from Gueguen (2002) examining whether a waiter leaving a joke
#' or an advertisement on a card affects tipping behavior.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{card}{Type of card: Advertisement (1), Joke (2), None (3)}
#'   \item{tip}{Whether customer left a tip: No (0), Yes (1)}
#'   \item{ad}{Indicator for ad card: 0/1}
#'   \item{joke}{Indicator for joke card: 0/1}
#'   \item{none}{Indicator for no card: 0/1}
#' }
#'
#' @source Gueguen, N. (2002). Journal of Applied Social Psychology.
"tip_jokes"


#' MCU Films Data
#'
#' Data on Marvel Cinematic Universe films through the Infinity Saga,
#' including box office performance and Rotten Tomatoes scores.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{movie}{Title of the movie}
#'   \item{length_hrs}{Movie length: hours portion}
#'   \item{length_min}{Movie length: minutes portion}
#'   \item{release_date}{US release date}
#'   \item{opening_weekend_us}{Opening weekend US box office (unadjusted)}
#'   \item{gross_us}{Total US box office (unadjusted)}
#'   \item{gross_world}{Total worldwide box office (unadjusted)}
#'   \item{phase}{MCU Phase: 1, 2, or 3}
#'   \item{critics}{RT critics score (0-100)}
#'   \item{audience}{RT audience score (0-100)}
#'   \item{favor}{Whether critics (1) or audience (2) score is higher}
#' }
#'
#' @source Internet Movie Database
"mcu"


#' Mock Jury Data
#'
#' Data from Plaster (1989) examining effects of physical attractiveness
#' on mock jury sentencing decisions.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{attr}{Attractiveness: Beautiful (1), Average (2), Unattractive (3)}
#'   \item{crime}{Crime type: Burglary (1), Swindle (2)}
#'   \item{years}{Sentence length in years}
#'   \item{serious}{Seriousness rating}
#'   \item{exciting}{Rating of the photo for 'exciting'}
#'   \item{calm}{Rating of the photo for 'calm'}
#'   \item{independent}{Rating of the photo for 'independent'}
#'   \item{sincere}{Rating of the photo for 'sincere'}
#'   \item{warm}{Rating of the photo for 'warm'}
#'   \item{phyattr}{Rating of the photo for 'physical attractiveness'}
#'   \item{sociable}{Rating of the photo for 'sociable'}
#'   \item{kind}{Rating of the photo for 'kind'}
#'   \item{intelligent}{Rating of the photo for 'intelligent'}
#'   \item{strong}{Rating of the photo for 'strong'}
#'   \item{sophisticated}{Rating of the photo for 'sophisticated'}
#'   \item{happy}{Rating of the photo for 'happy'}
#'   \item{ownPA}{Self-rating of physical attractiveness}
#' }
#'
#' @source Plaster, M. E. (1989). East Carolina University.
"mock_jury"


#' Candy Rankings Data (Full)
#'
#' Data on 85 candy types with ingredient indicators, sugar/price
#' percentiles, and win percentages from 269,000 matchups.
#'
#' @format A data frame with 85 rows and 13 variables:
#' \describe{
#'   \item{competitorname}{The name of the candy}
#'   \item{chocolate}{Contains chocolate? (0=No, 1=Yes)}
#'   \item{fruity}{Fruit flavored? (0=No, 1=Yes)}
#'   \item{caramel}{Contains caramel? (0=No, 1=Yes)}
#'   \item{peanutyalmondy}{Contains peanuts/almonds? (0=No, 1=Yes)}
#'   \item{nougat}{Contains nougat? (0=No, 1=Yes)}
#'   \item{crispedricewafer}{Contains crisped rice/wafers? (0=No, 1=Yes)}
#'   \item{hard}{Hard candy? (0=No, 1=Yes)}
#'   \item{bar}{Candy bar? (0=No, 1=Yes)}
#'   \item{pluribus}{One of many in bag/box? (0=No, 1=Yes)}
#'   \item{sugarpercent}{Sugar percentile within dataset}
#'   \item{pricepercent}{Unit price percentile}
#'   \item{winpercent}{Win percentage from 269,000 matchups}
#' }
#'
#' @source FiveThirtyEight candy power rankings
"candy"


#' Candy Rankings Data (Simplified)
#'
#' Simplified version of the candy dataset with only candy name, chocolate
#' indicator, sugar percentile, price percentile, and win percentage.
#'
#' @format A data frame with 85 rows and 5 variables:
#' \describe{
#'   \item{competitorname}{The name of the candy}
#'   \item{chocolate}{Contains chocolate? (0=No, 1=Yes)}
#'   \item{sugarpercent}{Sugar percentile within dataset}
#'   \item{pricepercent}{Unit price percentile}
#'   \item{winpercent}{Win percentage from 269,000 matchups}
#' }
#'
#' @source FiveThirtyEight candy power rankings
"candy_simple"


#' Extramarital Affairs Data
#'
#' Cross-section data from a 1969 Psychology Today survey on extramarital affairs.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{affairs}{Frequency of affairs (0, 1, 2, 3, 7, 12)}
#'   \item{gender}{Female (1), Male (2)}
#'   \item{age}{Age in years (bracket midpoints)}
#'   \item{yearsmarried}{Years married: <7 (1), 7-<10 (2), 14+ (3)}
#'   \item{children}{Children: No (1), Yes (2)}
#'   \item{religiousness}{Religiousness (1-5 scale)}
#'   \item{education}{Education level (9-20)}
#'   \item{occupation}{Hollingshead occupation (1-7)}
#'   \item{rating}{Marriage self-rating (1-5)}
#' }
#'
#' @source Fair, R.C. (1978). Journal of Political Economy.
"affairs"


#' Football Concussion Brain Data
#'
#' Brain measurements comparing football players (with and without
#' concussion history) to non-football-playing controls.
#'
#' @format A data frame with 3 variables:
#' \describe{
#'   \item{group}{Control (1), Football no concussion (2), Football with concussion (3)}
#'   \item{years}{Years of football played}
#'   \item{volume}{Total hippocampus volume in cubic centimeters}
#' }
#'
#' @source Singh R, Meier T, et al., JAMA, 311(18), 2014.
"football"
