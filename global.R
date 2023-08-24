# ---- Libraries ----
dep <- c(
  "shiny", "shinydashboard", "forcats", "ggplot2", "plotly", "lubridate",
  "stringr", "tidyr", "purrr", "dplyr", "shinycssloaders", "DT", "readxl",
  "tidyverse", "data.table", "statar", "factoextra", "FactoMineR",
  "wordcloud", "RColorBrewer", "tidytext"
)

for (d in dep) {
  if (!require(d, character.only = TRUE)) {
    install.packages(d, repos = "https://urldefense.com/v3/__https://cran.rstudio.com/__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42JY-5T-hA$  ")
    library(d, character.only = TRUE)
  }
}

# set timezone
options(tz = "America/Los_Angeles")

# --- Analytic Functions ------
source(here::here("Modules/functions.R"))
source(here::here("Modules/kol_ranking.R"))
source(here::here("Modules/kol_finder_TIM_mod.R"))
source(here::here("Modules/cluster_analysis.R"))

# Data and file directories
# data_loc <- "~/resources/BD2022/BD-share/project/Data/"
# file_loc <- "~/resources/BD2022/BD-share/project/Files/"

# user relative paths
data_loc <- "../project/Data/"
file_loc <- "../project/Files/"

# --- Variables ---------------
tweets <- import_corpus(paste0(data_loc, "KOL_tweets_transformed.rds"))
# tweets <- import_corpus("../../Main/Data/KOL_tweets_transformed.rds")
summary_stats <- import_KOL_stats(paste0(data_loc, "KOL_Stats.csv"))
congress <- import_congress(paste0(data_loc, "congress_tweets_corpus_narrow.csv"))
tweets_transformed <- paste0(data_loc, "KOL_tweets_transformed.rds")

## load in necessary files
top_kol <- read_rds(paste0(data_loc, "Top1000.rds"))
kol_finder_corpus <- read_rds(paste0(data_loc, "Mentioned_tweets_corpus.rds"))
kol_find <- kol_finder(top_kol, kol_finder_corpus, summary_stats)

# cluster analysis
useful_keywords <- read_excel(paste0(file_loc, "Useful Words.xlsx"))

cluster_df <- cluster_analysis(tweets, useful_keywords)
scaled_data <- cluster_df[[1]]
clusters <- cluster_df[[2]]
kol_clusters <- cluster_df[[3]]