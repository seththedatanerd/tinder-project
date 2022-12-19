install.packages("rjson")
library(rjson)
tinder <- fromJSON(file = "profiles_2021-11-10.json")
tinder %>%
unnest_wider(test)
install.packages("httr")
install.packages("glue")
install.packages("tibble")
install.packages("dplyr")
install.packages("purrr")
install.packages("tidyr")
install.packages("jsonlite")
library(httr) # accessing APIs
library(glue) # pass variables into strings
library(tibble) # nicer dataframes
library(purrr) # apply functions to lists
library(dplyr) # data wrangling
library(tidyr) # creating tidy data
library(jsonlite) # JSON parsing

tinder_data <- read_json("profiles_2021-11-10.json") #calls tinder data env

#Lets wrap the whole json list in a tibble
tinder <- tibble(profile_info = tinder)
tinder
#Lets make it a tiny bit more readable
tinder %>% unnest_wider(profile_info)

#Lets grab only the information we want
tinder %>% unnest_wider(profile_info) %>% select(`_id`,conversationsMeta,matches, user)

#Lets dive deeper into those named lists
General_Data <- tinder %>% unnest_wider(profile_info) %>% 
select(user, conversationsMeta)%>% 
  hoist(user, gender = "gender", DoB = "birthDate", Lowest_Age_Filter = "ageFilterMin", GenderPreference = "interestedIn") %>%
  hoist(conversationsMeta, NrOfConvos = "nrOfConversations", averageConversationLength = "averageConversationLength",nrOfOneMessageConversations = "nrOfOneMessageConversations", nrOfGhostingsAfterInitialMessage = "nrOfGhostingsAfterInitialMessage") %>%
  select(-user,-conversationsMeta)
General_Data

matches_daily_by_gender <- tinder %>% unnest_wider(profile_info) %>% 
  select(matches, user)%>% 
  unnest_longer(matches) %>% 
  hoist(user, gender = "gender", DoB = "birthDate")%>% 
  select(-user, -DoB) 
matches_daily_by_gender

my_df <- as.data.frame(General_Data)
write.csv(my_df, "//files.kent.ac.uk/usersJ/jsm47/Home/My Files//General_Data.csv", row.names= FALSE)

my_df2 <- as.data.frame(matches_daily_by_gender)
write.csv(my_df2, "//files.kent.ac.uk/usersJ/jsm47/Home/My Files//matches_daily_by_gender.csv", row.names= FALSE)


