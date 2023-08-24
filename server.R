function(session, input, output) {
  # Use global function to import corpus(s) / summary stats
  #####################
  # KOL CORPUS

  # Summary Boxes ---------------------------
  output$box_total_tweets <- renderValueBox({
    valueBox(
      value = format(as.numeric(nrow(tweets)), decimal.mark = ".", big.mark = ","),
      subtitle = "Total Tweets",
      color = "blue",
      icon = icon("comment-dots", verify_fa = FALSE),
      width = "4 col-lg-2"
    )
  })
  output$box_total_KOLs <- renderValueBox({
    valueBox(
      value = format(as.numeric(length(unique(tweets$screen_name))), decimal.mark = ".", big.mark = ","),
      subtitle = "Distinct KOLs",
      color = "orange",
      icon = icon("user-circle", verify_fa = FALSE),
      width = "4 col-lg-2"
    )
  })
  output$box_total_likes <- renderValueBox({
    valueBox(
      value = format(as.numeric(sum(tweets$favorite_count)), decimal.mark = ".", big.mark = ","),
      subtitle = "Likes",
      color = "fuchsia",
      icon = icon("heart", verify_fa = FALSE),
      width = "4 col-lg-2"
    )
  })

  # KOL Corpus ------------------------------
  output$tweets <- renderDataTable(
    {
      tweets %>%
        select(created_at, screen_name, text, retweet_count, favorite_count, "SentDir") %>%
        # mutate(created_at = strftime(created_at, "%F %T", tz = "PST⁠⁠")) %>%
        mutate(created_at = strftime(created_at, "%F %T")) %>%
        mutate(across(where(is.numeric), ~ round(., 2)), screen_name = as.factor(screen_name))
    },
    selection = "none",
    style = "default",
    rownames = FALSE,
    colnames = c("Timestamp", "User", "Tweet", "Retweet", "Fav", "Sentiment"),
    filter = "top",
    options = list(
      dom = "Blfrtip",
      buttons =
        list("copy", "print", list(
          extend = "collection",
          buttons = c("csv", "excel", "pdf"),
          text = "Download"
        )),
      columnDefs = list(list(
        visible = TRUE,
        targets = "_all"
      )),
      searchHighlight = TRUE,
      pagingType = "simple",
      pageLength = 15, # default length of the above options
      server = TRUE, # enable server-side processing for better performance
      processing = FALSE
    )
  )

  # KOL Summary Statistics -----------------------
  row_stats <- reactive({
    stats <- summary_stats %>% filter(ScreenName == input$select_kol)
    stats
  })


  output$summary_stats <- renderText({
    paste(
      "<b>Follower Count: ", row_stats()$LatestFollowersCnt[1], "<br />",
      "Total Tweets: ", row_stats()$TotalTweets[1], "<br />",
      "Most Recent Tweet: ", row_stats()$MostRecentStatusDTS[1], "<br />",
      "Account Created: ", row_stats()$AccountCreated[1], "<br />",
      "Average Favorites: ", row_stats()$average_favorites[1], "</b>"
    )
  })


  output$sum_stats <- DT::renderDataTable(
    {
      summary_specific %>% mutate(across(where(is.numeric), ~ round(., 2)))
    },
    extensions = "Buttons",
    selection = "none",
    style = "default",
    rownames = FALSE,
    colnames = c(
      "Screen Name", "Follower Count", "Total Tweets", "Most Recent Tweet",
      "Account Created", "Avg Retweets", "Avg Favorites"
    ),
    filter = "top",
    options = list(
      dom = "Blfrtip",
      buttons =
        list("copy", "print", list(
          extend = "collection",
          buttons = c("csv", "excel", "pdf"),
          text = "Download"
        )),
      columnDefs = list(list(
        visible = TRUE,
        targets = "_all"
      )),
      searchHighlight = TRUE,
      pagingType = "simple",
      pageLength = 15, # default length of the above options
      server = TRUE, # enable server-side processing for better performance
      processing = FALSE
    )
  )

  # Top Words by KOL
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update_kol
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        top_words_user(tweets, input$select_kol)
      })
    })
  })

  terms_kols <- reactive({
    # Change when the "update" button is pressed...
    input$update_kol
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        top_interactions(tweets, input$select_kol)
      })
    })
  })

  wordcloud_rep <- repeatable(wordcloud)
  output$wordcloud_plot <- renderPlot({
    v <- terms()
    wordcloud_rep(v$word, v$n,
      scale = c(4, 0.5),
      colors = brewer.pal(8, "Dark2")
    )
  })

  output$plot_top_words <- renderPlotly({
    v <- terms()
    v %>%
      plot_ly(x = ~n, y = ~word, type = "bar", orientation = "h") %>%
      layout(
        yaxis = list(title = "", categoryorder = "total ascending"),
        xaxis = list(title = "Count"),
        hovermode = "compare"
      )
  })

  output$plot_top_mentions <- renderPlotly({
    v <- terms_kols()
    v %>%
      plot_ly(x = ~n, y = ~word, type = "bar", orientation = "h") %>%
      layout(
        yaxis = list(title = "", categoryorder = "total ascending"),
        xaxis = list(title = "Count"),
        hovermode = "compare"
      )
  })

  # Congress Corpus -------------------------

  # filtered_congress <- reactive({
  # filtered_congress <- congress %>% filter(screen_name == input$select_congress)
  # filtered_congress
  # })


  output$congress_tweets <- DT::renderDataTable(
    {
      congress %>% mutate(across(where(is.numeric), ~ round(., 2)))
    },
    extensions = "Buttons",
    selection = "single",
    style = "bootstrap",
    rownames = FALSE,
    colnames = c("Timestamp", "User", "Tweet", "RT", "Fav"),
    filter = "top",
    options = list(
      dom = "Blfrtip",
      buttons =

        list("copy", "print", list(
          extend = "collection",
          buttons = c("csv", "excel", "pdf"),
          text = "Download"
        ))
    )
  )

  output$wordcloud_plot_cong <- renderPlot({
    v <- top_words(congress)
    wordcloud_rep(v$word, v$n,
      scale = c(4, 0.5),
      colors = brewer.pal(8, "Dark2")
    )
  })

  output$plot_top_words_cong <- renderPlotly({
    v <- top_words(congress)
    v %>%
      plot_ly(x = ~n, y = ~word, type = "bar", orientation = "h") %>%
      layout(
        yaxis = list(title = "", categoryorder = "total ascending"),
        xaxis = list(title = "Count"),
        hovermode = "compare"
      )
  })

  # KOL INFLUENCE --------------------

  output$mrf_summary <- renderText(paste(" <h4> Influence had been determined using a novel methodology called MRF Influence Analysis. </h4>
                                     <p>\"M\" Stands for \"Messaging = Friends + Followers\" (More is Better) <br>
                                     \"R\" stands for \"Recency = How long has it been since last tweet\" (Less is Better) <br>
                                      \"F\" stands for \"Frequency\" = How many often do people tweet\" (More is Better) <br>
                                      Each KOL is evaluated 1 - 5 in each area.  \"111\" is the best possible score... \"555\" is the worst.
                                      Many different MRF scores are possible. </p>"))

  output$kol_influence <- DT::renderDataTable(
    {
      summary_stats %>%
        select(
          ScreenName, Name, Institution, FavoritesPerTweet, Participation, Tweet_RecencyWeeks,
          Weekly_Tweet_Freq, Influence, MRF_Ind
        ) %>%
        mutate(across(where(is.numeric), ~ round(., 2)))
    },
    selection = "single",
    style = "bootstrap",
    rownames = FALSE,
    colnames = c(
      "Screen Name", "Name", "Institution", "Avg Fav", "Messaging (F+F)",
      "Recency (Weeks)", "Frequency (Tweets/Week)", "Influence", "MRF"
    ),
    filter = "top",
    options = list(lengthMenu = c(5, 10, 25, 50, 100), pageLength = 10)
  )

  # MRF Distributions -------------------------------------

  output$plot_influence_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~Influence, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(
          title = "Influence", categoryorder = "array",
          categoryarray = c(
            "High",
            "Medium",
            "Low",
            "None"
          )
        )
      )
  })

  output$plot_tweet_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~TotalTweets, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Total Tweets")
      )
  })

  output$plot_recency_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~Tweet_RecencyWeeks, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Tweet Recency")
      )
  })

  output$plot_freq_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~Weekly_Tweet_Freq, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Tweet Frequency")
      )
  })

  output$plot_follower_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~LatestFollowersCnt, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Follower Counts")
      )
  })

  output$plot_mrf_dist <- renderPlotly({
    summary_stats %>%
      plot_ly(x = ~ as.character(MRF_Ind), type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "MRF Score")
      )
  })

  # MRF for Identifying Influencers Distributions -------------------------------------
  #
  # output$plot_influence_cloud <- renderPlot({
  #   v <- top_words_100(kol_finder_corpus)
  #   wordcloud_rep(v$word, v$n, scale=c(2,0.25),
  #                 colors=brewer.pal(8, "Dark2"))
  # })

  output$plot_influence_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~Influence, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(
          title = "Influence", categoryorder = "array",
          categoryarray = c(
            "High",
            "Medium",
            "Low",
            "None"
          )
        )
      )
  })

  output$plot_tweet_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~TotalTweets, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Total Tweets")
      )
  })

  output$plot_recency_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~Tweet_RecencyWeeks, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Tweet Recency")
      )
  })

  output$plot_freq_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~Weekly_Tweet_Freq, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Tweet Frequency")
      )
  })

  output$plot_follower_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~LatestFollowersCnt, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "Follower Counts")
      )
  })

  output$plot_mrf_new_dist <- renderPlotly({
    kol_find %>%
      plot_ly(x = ~MRF_Ind_str, type = "histogram") %>%
      layout(
        yaxis = list(title = "Count"),
        xaxis = list(title = "MRF Score")
      )
  })

  output$kol_find <- DT::renderDataTable(
    {
      kol_find %>%
        select(
          ScreenName, Name, Participation, Tweet_RecencyWeeks,
          Weekly_Tweet_Freq, MRF_Ind, Influence
        ) %>%
        mutate(across(where(is.numeric), ~ round(., 2)))
    },
    selection = "single",
    style = "bootstrap",
    rownames = FALSE,
    colnames = c(
      "Screen Name", "Name", "Messaging (F+F)",
      "Recency (Weeks)", "Frequency (Tweets/Week)", "MRF", "Influence"
    ),
    filter = "top",
    options = list(lengthMenu = c(5, 10, 25, 50, 100), pageLength = 10)
  )

  # Clustering Tab -----------------
  output$cluster_plot <- renderPlotly({
    ggplotly(fviz_cluster(
      list(data = scaled_data, cluster = clusters),
      aes(text = paste("X":x, "Y":y, "Cluster":cluster))
    )
    + theme_classic()
      + theme(legend.position = "none")
      + ggtitle(label = "KOL Clustering by Keyword Analysis"),
    tooltip = c("text")
    )
  })

  output$cluster_df <- DT::renderDataTable(
    {
      kol_clusters %>% select(screen_name, cluster_group)
    },
    selection = "single",
    style = "bootstrap",
    rownames = FALSE,
    colnames = c("Screen Name", "Cluster"),
    filter = "top",
    options = list(lengthMenu = c(5, 10, 25, 50, 100), pageLength = 10)
  )
}