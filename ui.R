dashboardPage(
  # Page Setup -------------------
  title = "BD Capstone",
  dashboardHeader(
    title = "Twitter Analytics"
  ),
  # Sidebar ----------------------
  dashboardSidebar(
    sidebarMenu(
      menuItem("KOL Corpus", tabName = "tab_main", icon = icon("atom", verify_fa = FALSE)),
      menuItem("KOL Summary Statistics", tabName = "tab_stats", icon = icon("dna", verify_fa = FALSE)),
      menuItem("KOL Ranking", tabName = "tab_rank", icon = icon("chart-line")),
      menuItem("Potential KOL Finder", tabName = "tab_identify", icon = icon("magnifying-glass", verify_fa = FALSE)),
      menuItem("Congress Summary Statistics", tabName = "tab_cong", icon = icon("calendar", verify_fa = FALSE)),
      menuItem("Clustering", tabName = "tab_cluster", icon = icon("circle-nodes", verify_fa = FALSE)),
      menuItem("About", tabName = "tab_about", icon = icon("circle-question", verify_fa = FALSE))
    )
  ),
  # Main Body ---------------------
  dashboardBody(
    tabItems(
      # KOL Corpus -----------------
      tabItem(
        "tab_main",
        # Create summary boxes------
        fluidRow(
          valueBoxOutput("box_total_tweets"),
          valueBoxOutput("box_total_KOLs"),
          valueBoxOutput("box_total_likes")
        ),
        # Corpus -------------------
        fluidRow(
          box(
            width = "12",
            status = "primary",
            dataTableOutput("tweets")
          )
        )
      ),
      # KOL Summary Stats -----------
      tabItem(
        "tab_stats",
        fluidRow(
          box(
            width = "6 col-md-4",
            solidHeader = TRUE,
            title = "KOL Metrics",
            selectInput("select_kol", "Choose a KOL:", choices = unique(tweets$screen_name)),
            actionButton("update_kol", "Generate")
          )
        ),
        # Plots for KOL Metrics --------------
        fluidRow(
          tabBox(
            width = 12,
            tabPanel(
              status = "primary",
              title = "Stats",
              htmlOutput("summary_stats")
            ),
            tabPanel(
              status = "primary",
              title = "Top Words",
              withSpinner(plotlyOutput("plot_top_words", height = "250px"))
            ),
            tabPanel(
              status = "warning",
              title = "Word Cloud",
              withSpinner(plotOutput("wordcloud_plot"))
            ),
            tabPanel(
              status = "success",
              title = "Top Mentions",
              withSpinner(plotlyOutput("plot_top_mentions", height = "250px"))
            )
          )
        )
      ),
      # KOL Influence Analytics -------------
      tabItem(
        "tab_rank",
        fluidRow(
          box(
            width = 12,
            title = "MRF Analysis",
            solidHeader = TRUE,
            status = "primary",
            htmlOutput("mrf_summary")
          )
        ),
        fluidRow(
          tabBox(
            width = 12,
            tabPanel(
              status = "Primary",
              title = "Influence Count",
              withSpinner(plotlyOutput("plot_influence_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "MRF Distribution",
              withSpinner(plotlyOutput("plot_mrf_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Tweets Distribution",
              withSpinner(plotlyOutput("plot_tweet_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Recency Distribution",
              withSpinner(plotlyOutput("plot_recency_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Frequency Distribution",
              withSpinner(plotlyOutput("plot_freq_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Follower + Friends Distribution",
              withSpinner(plotlyOutput("plot_follower_dist", height = "250px"))
            )
          )
        ),
        fluidRow(
          box(
            width = "12",
            status = "primary",
            dataTableOutput("kol_influence")
          )
        )
      ),
      tabItem(
        "tab_identify",
        fluidRow(
          tabBox(
            width = 12,
            #   tabPanel(
            #     status = 'Primary',
            #     title = "Word Cloud",
            #     withSpinner(plotlyOutput("plot_influence_cloud", height = "250px"))
            #   ),
            tabPanel(
              status = "Primary",
              title = "Influence Count",
              withSpinner(plotlyOutput("plot_influence_new_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "MRF Distribution",
              withSpinner(plotlyOutput("plot_mrf_new_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Tweets Distribution",
              withSpinner(plotlyOutput("plot_tweet_new_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Recency Distribution",
              withSpinner(plotlyOutput("plot_recency_new_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Frequency Distribution",
              withSpinner(plotlyOutput("plot_freq_new_dist", height = "250px"))
            ),
            tabPanel(
              status = "Primary",
              title = "Follower + Friend Distribution",
              withSpinner(plotlyOutput("plot_follower_new_dist", height = "250px"))
            )
          )
        ),
        fluidRow(
          box(
            width = "12",
            status = "primary",
            dataTableOutput("kol_find")
          )
        )
      ),
      tabItem(
        "tab_cong",
        fluidRow(
          tabBox(
            width = 12,
            tabPanel(
              status = "primary",
              title = "Top Words",
              withSpinner(plotlyOutput("plot_top_words_cong", height = "250px"))
            ),
            tabPanel(
              status = "warning",
              title = "Word Cloud",
              withSpinner(plotOutput("wordcloud_plot_cong"))
            ),
            tabPanel(
              status = "success",
              title = "Top Mentions",
              withSpinner(plotlyOutput("plot_top_mentions_cong", height = "250px"))
            )
          )
        ),
        fluidRow(
          box(
            width = "12",
            status = "primary",
            dataTableOutput("congress_tweets")
          )
        )
      ),
      tabItem(
        "tab_cluster",
        fluidRow(
          plotlyOutput("cluster_plot")
        ),
        fluidRow(
          width = 6,
          dataTableOutput("cluster_df")
        )
      ),
      tabItem(
        "tab_about",
        fluidRow(
          # About This Dashboard ------------------------------------------------
          box(
            title = "About This Dashboard",
            status = "danger",
            width = "6 col-lg-4",
            tags$p(
              "This dashboard was created by MSBA students at the UCSD Rady School of Management",
              tags$a(
                href = "https://rady.ucsd.edu/programs/ms-business-analytics/index.html",
                target = "_blank", "UCSD Rady School of Management"
              ),
              "in collaboration with",
              tags$a(
                href = "https://urldefense.com/v3/__https://www.bd.com/en-us__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42IMuc6WXA$  ",
                target = "_blank", "BD"
              ),
              "for the Summer 2022 Capstone project."
            ),
            tags$p(
              "BD Group 1: Timothy Clarke, Paige Dubelko, Nicholas Feldman, Cindy Sun, Michael Smargon."
            ),
            tags$p(
              tags$a(
                href = "https://rady.ucsd.edu/programs/ms-business-analytics/index.html",
                target = "_blank",
                tags$img(
                  class = "image-responsive",
                  src = "ucsd.jpeg",
                  style = "max-width: 250px;"
                )
              ),
              tags$a(
                href = "https://urldefense.com/v3/__https://www.bd.com/en-us__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42IMuc6WXA$  ",
                target = "_blank",
                tags$img(
                  class = "image-responsive",
                  src = "BDlogo.png",
                  style = "max-width: 250px;"
                )
              )
            )
          ),
          box(
            title = "Tech Stack",
            # status = "primary",
            width = "6 col-md-4",
            tags$p(
              class = "text-center",
              tags$a(
                href = "https://urldefense.com/v3/__https://www.r-project.org__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42JmkV6WQg$  ",
                target = "_blank",
                tags$img(
                  class = "image-responsive",
                  src = "https://urldefense.com/v3/__https://www.r-project.org/logo/Rlogo.svg__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42LaOqog4Q$  ",
                  style = "max-width: 75px;"
                )
              ),
              tags$a(
                href = "https://urldefense.com/v3/__https://rtweet.info__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42Iun7Cfrw$  ",
                target = "_blank",
                tags$img(
                  class = "image-responsive",
                  src = "rtweet.png",
                  style = "max-width: 75px; margin-left: 2em;"
                )
              )
            ),
            tags$p(
              "This dashboard was built in",
              tags$a(href = "https://urldefense.com/v3/__https://r-project.org__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42JX26W3sg$  ", target = "_blank", "R"),
              "and", tags$a(href = "https://urldefense.com/v3/__https://rstudio.com__;!!Mih3wA!C5_hSCbsP0rrl5XHQLfsHGbG3P2nMGtitIk6d2-0y6GwOx6NfGtoHz-kDXEC7ytSUcDHodFkJQRk42LhFwKy7Q$  ", target = "_blank", "RStudio"), "with",
              tags$strong("shiny,"),
              tags$strong("shinydashboard,"),
              tags$strong("rtweet,"),
              tags$strong("plotly,"),
              "the", tags$strong("tidyverse,"),
              "and many more packages."
            )
          )
        ),
        fluidRow(
          box(
            title = "Project Overview",
            width = "12 col-lg-4",
            tags$strong("Project Objective"),
            tags$p(
              "Our project focused on gathering relevant data
            from twitter that could further BD’s ability to gain insights into an existing
            list of KOLs as well as to come up with methods of finding potential candidate
            healthcare professionals that could be added to future KOL lists."
            ),
            tags$p(""),
            tags$strong("Data Description"),
            tags$p(
              "BD has given us four lists. The first list contains 65 KOLs with 7
            variables which are names, institutions, countries, Twitter handles,
            Twitter URLs, and report names. The second list contains keywords such as names of
            specialties, medical congresses, competitors, relevant journals, regulatory bodies, and products."
            ),
            tags$p("We obtained thousands of tweets posted by the KOLs and selected 24 variables that we are interested in,
                 such as text, favorite count, followers count, friends count, retweet count, retweet text")
          )
        )
      )
    )
  )
)