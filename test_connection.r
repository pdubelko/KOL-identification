library(rtweet)
library(tidyverse)

currentDate <- Sys.Date()

# create a KOL dataframe
kol_df <- read.csv("~/resources/BD2022/bdkol.csv")

# print(kol_df)

# By the way...
#ESKD = End Stage Kidney Disease
#ONC = Oncology
#PAD = Peripheral Arterial Disease

kol_users <- kol_df$Twitter.Handle

token <- readr::read_rds("~/resources/M1/rtweet_token.rds")
kol_tweet_full_df <- lookup_users(kol_users, token=token)

colnames(kol_tweet_full_df)

keeps <- c("created_at","screen_name","status_url","text","favorite_count","retweet_count",
           "name","followers_count","friends_count", "listed_count", "statuses_count",
           "favourites_count","account_created_at","user_id","status_id",
           "source","is_quote",
           "is_retweet","retweet_count","retweet_status_id","retweet_text","retweet_created_at",
           "retweet_source","retweet_favorite_count","retweet_retweet_count",
           "description"
           )

kol_tweets <- as.data.frame(kol_tweet_full_df[keeps])

kol_tweets['date_pulled'] <- currentDate

#class(kol_tweets)



file_name = paste("KOL_tweets_", currentDate, ".csv", sep="")
write_csv(kol_tweets, file_name)

## If you want to look at all columns
#kol_tweets_full <- as.data.frame(kol_tweet_full_df)
#file_name_full = paste("KOL_tweets_full_", currentDate, ".csv", sep="")
#write_csv(kol_tweets_full, file_name_full)

## Get Followers - Does Not Work without Elevated Access
test_flw <- get_followers("ahmed_kamel_ir", n = 10000)

## Get Favorites - Does Not Work without Elevated Access
jkr <- get_favorites("jk_rowling", n = 3000)

## Search Tweets - Does Not Work without Elevated Access
rt <- search_tweets2("MAGA", n=2000)
