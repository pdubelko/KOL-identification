# import corpus -- tweets pulled by KOLs
import_corpus <- function(file) {
  tweets <- read_rds(file)
  tweets
}

# top interactions by user
top_interactions <- function(corpus, sn) {
  tweets <- corpus
  mentionedVec <- vector()
  kol_tweet <- tweets %>% filter(screen_name == sn)
  for (x in 1:nrow(kol_tweet)) {
    mentionedVec <- c(mentionedVec, unlist(kol_tweet[x, "mentions_screen_name"]))
  }

  mentioned_counts <- data.frame(table(sapply(mentionedVec, function(x) x))) %>%
    arrange(desc(Freq)) %>%
    rename(word = Var1, n = Freq) %>%
    slice(1:10)

  mentioned_counts
}
# import congress corpus -- tweets pulled by congress handle
import_congress <- function(file) {
  congress_tweets <- read_csv(file)
  congress_tweets <- congress_tweets %>%
    select(
      created_at, screen_name, text, favorite_count,
      retweet_count
    ) %>%
    mutate(screen_name = as.factor(screen_name))
  congress_tweets
}

# import summary stats
import_KOL_stats <- function(file) {
  summary_stats <- read_csv(file)
  summary_stats <- summary_stats %>%
    mutate(
      # most_recent_tweet = strftime(MostRecentStatusDTS, "%F %T", tz = "America/Los_Angeles"),
      # account_created = strftime(AccountCreated, "%F %T", tz = "America/Los_Angeles"),
      most_recent_tweet = strftime(MostRecentStatusDTS, "%F %T"),
      account_created = strftime(AccountCreated, "%F %T"),
      average_favorites = round(FavoritesPerTweet, 2),
      MRF_Ind_str = str(MRF_Ind)
    )
  summary_stats
}

# top used words of any corpus
top_words <- function(corpus) {
  top_words <- corpus %>%
    select(text) %>%
    mutate(
      text = str_remove_all(text, "@[[:alnum:]_]+\\b"),
      text = str_remove_all(text, "&\\w+;")
    ) %>%
    tidytext::unnest_tokens(word, text) %>%
    filter(
      !word %in% c("http", "https", "t.co"),
      nchar(word) >= 3
    ) %>%
    anti_join(tidytext::stop_words, by = "word") %>%
    count(word, sort = TRUE) %>%
    slice(1:10)
  top_words
}

top_words_100 <- function(corpus) {
  top_words <- corpus %>%
    select(text) %>%
    mutate(
      text = str_remove_all(text, "@[[:alnum:]_]+\\b"),
      text = str_remove_all(text, "&\\w+;")
    ) %>%
    tidytext::unnest_tokens(word, text) %>%
    filter(
      !word %in% c("http", "https", "t.co"),
      nchar(word) >= 3
    ) %>%
    anti_join(tidytext::stop_words, by = "word") %>%
    count(word, sort = TRUE) %>%
    slice(1:20)
  top_words
}

# top words filter by screen name
top_words_user <- function(corpus, sn) {
  top_words <- corpus %>%
    filter(screen_name == sn) %>%
    select(text) %>%
    mutate(
      text = str_remove_all(text, "@[[:alnum:]_]+\\b"),
      text = str_remove_all(text, "&\\w+;")
    ) %>%
    tidytext::unnest_tokens(word, text) %>%
    filter(
      !word %in% c("http", "https", "t.co"),
      nchar(word) >= 3
    ) %>%
    anti_join(tidytext::stop_words, by = "word") %>%
    count(word, sort = TRUE) %>%
    slice(1:10)
  top_words
}