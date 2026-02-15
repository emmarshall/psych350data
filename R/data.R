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
#'
#' @format A tibble with variables including:
#' \describe{
#'   \item{subn}{Unique guest/participant number}
#'   \item{name}{Guest full name}
#'   \item{gender}{Guest gender: Male (1), Female (2)}
#'   \item{age}{Guest age at time of appearance}
#'   \item{occupation}{Guest primary occupation (1-14, see value labels)}
#'   \item{SHU_1}{Sauce 1 Scoville Heat Units}
#'   \item{SHU_2}{Sauce 2 Scoville Heat Units}
#'   \item{SHU_3}{Sauce 3 Scoville Heat Units}
#'   \item{SHU_4}{Sauce 4 Scoville Heat Units}
#'   \item{SHU_5}{Sauce 5 Scoville Heat Units}
#'   \item{SHU_6}{Sauce 6 Scoville Heat Units}
#'   \item{SHU_7}{Sauce 7 Scoville Heat Units}
#'   \item{SHU_8}{Sauce 8 Scoville Heat Units}
#'   \item{SHU_9}{Sauce 9 Scoville Heat Units}
#'   \item{SHU_10}{Sauce 10 Scoville Heat Units}
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

#' Candy Rankings Data
#'
#' Simplified version with only candy name, chocolate indicator,
#' sugar percentile, price percentile, and win percentage.
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

#' Interpersonal Relationships Survey Data
#'
#' Simulated survey data (n = 574) from college students at a predominantly white
#' rural state university, containing demographics, relationship variables, and
#' scores on several interpersonal and psychological scales including the DAQ,
#' Interpersonal Dependency Inventory, Interpersonal Reactivity Index,
#' Sociability Scale, RISC, GCB, and LSAS-SR.
#'
#' @format A tibble with 574 rows and 33 variables:
#' \describe{
#'   \item{age}{Age in years (18-25)}
#'   \item{gender}{Self-described gender: Male (1), Female (2), Another (3)}
#'   \item{sexorient}{Sexual orientation (1-11, see value labels)}
#'   \item{race}{Self-described race: Asian (1), Black (2), Indigenous/Aboriginal/First Nations (3), Latino/Hispanic (4), Middle Eastern (5), White (6), Other (7)}
#'   \item{hand}{Writing hand: Right (1), Left (2), Both (3)}
#'   \item{community}{Childhood community type: Rural (1), Small town (2), Suburban (3), Urban (4)}
#'   \item{parentedu}{Parent graduated from four-year college: No (0), Yes (1)}
#'   \item{famclass}{Childhood social class: Working class (1), Lower class (2), Lower middle class (3), Upper middle class (4), Upper class (5)}
#'   \item{faminc}{Family income during senior year of high school}
#'   \item{numsib}{Number of siblings}
#'   \item{move}{Number of times moved as a child}
#'   \item{clsfrn}{Number of close friends}
#'   \item{clsfrlst}{Number of people who would list you as a close friend}
#'   \item{greek_in}{Fraternity/sorority membership: Independent (1), Greek (2)}
#'   \item{campus}{Living on campus: No (0), Yes (1)}
#'   \item{relsp}{Romantic relationship status (1-5, see value labels)}
#'   \item{rlength}{Length of current or last relationship in months}
#'   \item{serious}{Seriousness rating of current/most recent relationship (1-7)}
#'   \item{numrels}{Number of dating relationships}
#'   \item{gcb}{Generic Conspiracist Beliefs scale score}
#'   \item{datdaq}{Dating subscale of the DAQ}
#'   \item{assrtdaq}{Assertiveness subscale of the DAQ}
#'   \item{emorel}{Emotional Reliance on Others subscale of the IDI}
#'   \item{lacksc}{Lack of Self-Confidence subscale of the IDI}
#'   \item{auto}{Assertion of Autonomy subscale of the IDI}
#'   \item{perspec}{Perspective-Taking subscale of the IRI}
#'   \item{fantasy}{Fantasy subscale of the IRI}
#'   \item{empath}{Empathic Concern subscale of the IRI}
#'   \item{distress}{Personal Distress subscale of the IRI}
#'   \item{polsoc}{Political Sociability subscale of Sociability Scale}
#'   \item{npolsoc}{Non-Political Sociability subscale of Sociability Scale}
#'   \item{risc}{Relational-Interdependent Self-Construal Scale score}
#'   \item{lsas}{Liebowitz Social Anxiety Scale self-report total (LSAS-SR)}
#' }
#'
#' @source Simulated data generated to resemble plausible survey responses
#'   from undergraduate psychology students.
"interpersonal_data"

#' Self-Descriptive Survey Data
#'
#' Simulated survey data (n = 547) from college students at a predominantly white
#' rural state university, containing demographics, relationship variables, and
#' scores on personality and self-concept measures including the TIPI Big Five,
#' MAAS, RFQ, ATQ-30, Rosenberg Self-Esteem, and New General Self-Efficacy scales.
#'
#' @format A tibble with 547 rows and 37 variables:
#' \describe{
#'   \item{age}{Age in years (18-25)}
#'   \item{gender}{Self-described gender: Male (1), Female (2), Another (3)}
#'   \item{sexorient}{Sexual orientation (1-11, see value labels)}
#'   \item{race}{Self-described race: Asian (1), Black (2), Indigenous/Aboriginal/First Nations (3), Latino/Hispanic (4), Middle Eastern (5), White (6), Other (7)}
#'   \item{hand}{Writing hand: Right (1), Left (2), Both (3)}
#'   \item{community}{Childhood community type: Rural (1), Small town (2), Suburban (3), Urban (4)}
#'   \item{parentedu}{Parent graduated from four-year college: No (0), Yes (1)}
#'   \item{famclass}{Childhood social class: Working class (1), Lower class (2), Lower middle class (3), Upper middle class (4), Upper class (5)}
#'   \item{faminc}{Family income during senior year of high school}
#'   \item{numsib}{Number of siblings}
#'   \item{move}{Number of times moved as a child}
#'   \item{clsfrn}{Number of close friends}
#'   \item{clsfrlst}{Number of people who would list you as a close friend}
#'   \item{greek_in}{Fraternity/sorority membership: Independent (1), Greek (2)}
#'   \item{campus}{Living on campus: No (0), Yes (1)}
#'   \item{relsp}{Romantic relationship status (1-5, see value labels)}
#'   \item{rlength}{Length of current or last relationship in months}
#'   \item{serious}{Seriousness rating of current/most recent relationship (1-7)}
#'   \item{numrels}{Number of dating relationships}
#'   \item{extraversion}{Extraversion subscale of the TIPI (1-7)}
#'   \item{agreeableness}{Agreeableness subscale of the TIPI (1-7)}
#'   \item{conscientiousness}{Conscientiousness subscale of the TIPI (1-7)}
#'   \item{emot_stability}{Emotional Stability subscale of the TIPI (1-7)}
#'   \item{openness}{Openness to Experience subscale of the TIPI (1-7)}
#'   \item{disc}{Discomfort with Ambiguity subscale of the MAAS}
#'   \item{moral}{Moral Absolutism/Splitting subscale of the MAAS}
#'   \item{comp}{Need for Complexity and Novelty subscale of the MAAS}
#'   \item{maas}{MAAS total score}
#'   \item{rse}{Rosenberg Self-Esteem scale score}
#'   \item{promote}{Promotion Focus subscale of the RFQ}
#'   \item{prevent}{Prevention Focus subscale of the RFQ}
#'   \item{atq}{Automatic Thoughts Questionnaire (ATQ-30) total score}
#'   \item{pmdc}{Personal Maladjustment and Desire for Change subscale of the ATQ}
#'   \item{nsne}{Negative Self-Concepts and Negative Expectations subscale of the ATQ}
#'   \item{lse}{Low Self-Esteem subscale of the ATQ}
#'   \item{help}{Helplessness subscale of the ATQ}
#'   \item{ngse}{New General Self-Efficacy scale score}
#' }
#'
#' @source Simulated data generated to resemble plausible survey responses
#'   from undergraduate psychology students.
"self_descriptive_data"
