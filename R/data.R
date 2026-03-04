#' Superman Actor Data
#'
#' Physical characteristics and ratings data for actors who have played
#' Superman across various films and TV shows.
#'
#' @format A tibble with 11 rows and variables:
#' \describe{
#'   \item{num}{Participant id number}
#'   \item{type}{Media type (Film, TV Show, Serial)}
#'   \item{title}{Title of the production}
#'   \item{year}{Release year}
#'   \item{clark_actor}{Actor playing Clark Kent/Superman}
#'   \item{clark_height}{Clark Kent/Superman actor's height in meters}
#'   \item{clark_age}{Clark Kent/Superman actor's age at debut
#'   #'(years)}
#'   \item{lois_actor}{Actor playing Lois Lane}
#'   \item{lois_height}{Lois Lane actor's height in meters}
#'   \item{lois_age}{Lois Lane actor's age at debut (years)}
#'   \item{clark_height_in}{Clark Kent/Superman actor's height in inches}
#'   \item{lois_height_in}{Lois Lane actor's height in inches}
#'   \item{clark_grp}{Clark Height group: 1 = under 72 inches, 2 = 72+ inches}
#'   \item{height_diff}{Height difference between Lois and Clark in inches (Clark - Lois)}
#'   \item{age_diff}{Age difference between Lois and Clark in years}

#'   \item{age_gap}{Height gap category: 1 = <6in, 2 = 6-8in, 3 = >8in}
#'   \item{rt_critics_score}{Rotten Tomatoes critics score}
#'   \item{rt_audience_score}{Rotten Tomatoes audience score}
#'   \item{tomatometer}{Critics rating: 1 = Rotten (<60), 2 = Fresh (60+)}
#'   \item{rt_avg}{Average of critics and audience scores}
#'   \item{ldb_likes}{Letterboxd likes}
#'   \item{ldb_scores}{Letterboxd score}
#'   \item{popular}{Popularity category based on Letterboxd likes}
#' }
#'
#' @source Compiled from the internet including Rotten Tomatoes, Letterboxd, and IMDb.
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


#' Superman Movies Box Office Data
#'
#' Box office and production data for Superman theatrical films,
#' including budget, domestic and international grosses, and MPAA ratings.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{imdb_id}{IMDb title ID (e.g., "tt0078346")}
#'   \item{title}{Movie title}
#'   \item{year}{Release year}
#'   \item{description}{Movie description/tagline}
#'   \item{domestic_gross}{Domestic box office gross (millions USD)}
#'   \item{domestic_pct}{Domestic percentage of worldwide gross}
#'   \item{international_gross}{International box office gross (millions USD)}
#'   \item{international_pct}{International percentage of worldwide gross}
#'   \item{worldwide_gross}{Worldwide box office gross (millions USD)}
#'   \item{distributor}{Domestic distributor}
#'   \item{opening_weekend}{Domestic opening weekend gross (millions USD)}
#'   \item{budget}{Production budget (millions USD)}
#'   \item{release_date}{Earliest release date}
#'   \item{mpaa}{MPAA rating (G, PG, PG-13, R)}
#'   \item{runtime_min}{Runtime in minutes}
#'   \item{genres}{Genres (space-separated)}
#'   \item{poster_url}{Movie poster URL (low resolution)}
#'   \item{poster_url_hires}{Movie poster URL (high resolution)}
#'   \item{clark_actor}{Actor playing Clark Kent/Superman (for joining with superman dataset)}
#'   \item{roi}{Return on investment ((worldwide - budget) / budget)}
#'   \item{budget_cat}{Budget category: Low (<$50M), Medium ($50-150M), High (>$150M)}
#'   \item{box_office_cat}{Box office category: Low (<$100M), Medium ($100-500M), High (>$500M)}
#' }
#'
#' @source IMDb Box Office Mojo
#'
#' @examples
#' \dontrun{
#' superman_movies
#' combined <- join_superman_data()
#' combined |> export_sav(path = "superman_combined.sav")
#' }
"superman_movies"

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
#'   \item{wing_total}{Number of wings eaten}
#'   \item{alt_food}{Alternative food used instead of wings}
#'   \item{helpers}{Drinks or other items used to help with the heat}
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
#'   \item{result}{Succeeded (1), Failed (2), or Incomplete (3)}
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

#' Hot Ones Sauce Data
#'
#' Data on hot sauces used in each season and position of Hot Ones,
#' including Scoville Heat Unit ratings.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{season}{Season of Hot Ones}
#'   \item{order}{Sauce position in the lineup (1-10, from mildest to hottest)}
#'   \item{sauce_name}{Name of the hot sauce}
#'   \item{SHU}{Scoville Heat Units (SHU) rating}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hot_ones_sauces"

#' Hot Ones Episode Data
#'
#' Episode-level data from the YouTube show Hot Ones, including
#' guest names, titles, and YouTube engagement metrics.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{season}{Season of Hot Ones}
#'   \item{order}{Episode number within season}
#'   \item{guest}{Name of the guest}
#'   \item{episode_title}{Full title of the episode}
#'   \item{publish_date}{Date the episode was published on YouTube}
#'   \item{views}{Number of YouTube views (in millions)}
#'   \item{likes}{Number of YouTube likes}
#'   \item{comments}{Number of YouTube comments}
#'   \item{short_description}{Short description of the episode}
#'   \item{img}{URL to episode thumbnail image}
#'   \item{video_id}{YouTube video ID}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hot_ones_episodes"

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

#' Nebraska Football Box Scores (1962–2024)
#'
#' Game-level team statistics for all Nebraska Cornhuskers football games
#' from September 1962 through the 2024 season. Includes scoring, rushing,
#' passing, turnovers, penalties, point spreads, and weather data.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{Date the game was played.}
#'   \item{time}{Kickoff time (Central Time).}
#'   \item{season}{Season (year) the game was played.}
#'   \item{opp}{Nebraska's opponent.}
#'   \item{site}{Game location: "home", "away", "neutral-home", or "neutral-away".}
#'   \item{conference}{Whether the opponent was a conference opponent (TRUE/FALSE).}
#'   \item{opp_rank}{Opponent's ranking entering the game (CFP when available, otherwise AP).}
#'   \item{ne_rank}{Nebraska's ranking entering the game (CFP when available, otherwise AP).}
#'   \item{result}{Game result: W (Win), L (Loss), or T (Tie).}
#'   \item{opp_score}{Opponent's total score.}
#'   \item{ne_score}{Nebraska's total score.}
#'   \item{opp_score_q1}{Opponent's first quarter points.}
#'   \item{opp_score_q2}{Opponent's second quarter points.}
#'   \item{opp_score_q3}{Opponent's third quarter points.}
#'   \item{opp_score_q4}{Opponent's fourth quarter points.}
#'   \item{opp_score_ot}{Opponent's overtime points.}
#'   \item{ne_score_q1}{Nebraska's first quarter points.}
#'   \item{ne_score_q2}{Nebraska's second quarter points.}
#'   \item{ne_score_q3}{Nebraska's third quarter points.}
#'   \item{ne_score_q4}{Nebraska's fourth quarter points.}
#'   \item{ne_score_ot}{Nebraska's overtime points.}
#'   \item{opp_rush_att}{Opponent's rushing attempts.}
#'   \item{opp_rush_yards}{Opponent's rushing yards.}
#'   \item{ne_rush_att}{Nebraska's rushing attempts.}
#'   \item{ne_rush_yards}{Nebraska's rushing yards.}
#'   \item{opp_pass_comp}{Opponent's passing completions.}
#'   \item{opp_pass_att}{Opponent's passing attempts.}
#'   \item{opp_pass_yards}{Opponent's passing yards.}
#'   \item{ne_pass_comp}{Nebraska's passing completions.}
#'   \item{ne_pass_att}{Nebraska's passing attempts.}
#'   \item{ne_pass_yards}{Nebraska's passing yards.}
#'   \item{opp_first_downs}{Opponent's first downs.}
#'   \item{ne_first_downs}{Nebraska's first downs.}
#'   \item{opp_third_down_comp}{Opponent's successful third down conversions.}
#'   \item{opp_third_down_att}{Opponent's third down attempts.}
#'   \item{ne_third_down_comp}{Nebraska's successful third down conversions.}
#'   \item{ne_third_down_att}{Nebraska's third down attempts.}
#'   \item{opp_fourth_down_comp}{Opponent's successful fourth down conversions.}
#'   \item{opp_fourth_down_att}{Opponent's fourth down attempts.}
#'   \item{ne_fourth_down_comp}{Nebraska's successful fourth down conversions.}
#'   \item{ne_fourth_down_att}{Nebraska's fourth down attempts.}
#'   \item{opp_int}{Interceptions thrown by the opponent.}
#'   \item{opp_fum}{Fumbles lost by the opponent.}
#'   \item{ne_int}{Interceptions thrown by Nebraska.}
#'   \item{ne_fum}{Fumbles lost by Nebraska.}
#'   \item{opp_pen_num}{Opponent's number of penalties.}
#'   \item{opp_pen_yards}{Opponent's penalty yards.}
#'   \item{ne_pen_num}{Nebraska's number of penalties.}
#'   \item{ne_pen_yards}{Nebraska's penalty yards.}
#'   \item{opp_possession}{Opponent's time of possession (MM:SS).}
#'   \item{ne_possession}{Nebraska's time of possession (MM:SS).}
#'   \item{spread}{Point spread. Negative means Nebraska was favored.}
#'   \item{total}{Betting total (Over/Under).}
#'   \item{temp}{Temperature at kickoff (Fahrenheit).}
#'   \item{humidity}{Relative humidity at kickoff (0.0 to 1.0).}
#'   \item{wind_speed}{Wind speed at kickoff (mph).}
#'   \item{wind_bearing}{Wind direction at kickoff in degrees (0 = North, clockwise).}
#' }
#'
#' @details
#' Data completeness notes:
#' \itemize{
#'   \item Scoring by quarter, first down, third/fourth down, and opponent penalty
#'     data begins in the 2004 season.
#'   \item Nebraska penalty data is incomplete before 1972-09-16 (Texas A&M).
#'   \item Time of possession data begins in 2012, complete from 2013 onward.
#'   \item Point spread data is mostly absent before 1978; available for most
#'     games from 1978 onward.
#'   \item Betting total data is available for most games from 2006 onward.
#'   \item Weather data sourced from the DarkSky API and Weather Underground.
#'     Temperature and humidity are fairly reliable; wind data less so.
#' }
#'
#' @source Compiled from historical Nebraska football records.
"huskers"

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


