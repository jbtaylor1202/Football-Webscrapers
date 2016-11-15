#Based on https://sportsdatachallenge.wordpress.com/

library(rvest)

URL <- "http://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1/plus/?saison_id=2016"

Scraped_URL <- read_html(URL)

Team_URLs <- Scraped_URL %>% 
  html_nodes(".hide-for-pad .vereinprofil_tooltip") %>% 
  html_attr("href") %>% 
  as.character()


Team_URLs <- paste0("http://www.transfermarkt.com", Team_URLs)
                    
                    
Player_Data <- data.frame(Player_Name = character(),
                          Player_Position = character(),
                          Player_URL = character(), 
                          Player_Team = character(),
                          stringsAsFactors = FALSE)

for (i in Team_URLs){
  
  Team_URLs <- read_html(i)
  
  cat("Processing...", i, "\n")
                 
  Player_Name <- Team_URLs %>% 
    html_nodes("#yw1 .spielprofil_tooltip") %>% 
    html_text() %>% 
    as.character()
  
  Player_Position <- Team_URLs %>% 
    html_nodes("#yw1 .inline-table tr+ tr td") %>% 
    html_text() %>% 
    as.character()
                 
  Player_URL <- Team_URLs %>% 
    html_nodes("#yw1 .spielprofil_tooltip") %>% 
    html_attr("href") %>% 
    as.character()
  
  Player_Team <- Team_URLs %>%
    html_nodes(".dataName") %>%
    html_text() %>%
    as.character()

  Temp_Dataframe <- data.frame(Player_Name, Player_Position, Player_URL, Player_Team)
  Player_Data <- rbind(Player_Data, Temp_Dataframe)
  cat("Processed...", i, "\n", "\n")
  Sys.sleep(0.2)
}
 
no.of.rows <- nrow(Player_Data)
odd_indexes<-seq(1,no.of.rows,2)
Player_Data <- data.frame(Player_Data[odd_indexes,])
               
Player_Data$Player_URL <- paste0("http://www.transfermarkt.com",Player_Data$Player_URL)



Player_Data_Value <- data.frame(Player_Name = character(),
                          Player_Position = character(),
                          Player_URL = character(), 
                          Player_Team = character(),
                          stringsAsFactors = FALSE)

for (i in Player_Data$Player_URL) {
  
  player_value_scrape <- read_html(i)
  
  MarketValue <- player_value_scrape %>%
    html_nodes(".dataMarktwert a") %>%
    html_text() %>%
    as.character()
  
  Player <- player_value_scrape %>%
    html_nodes("h1") %>%
    html_text() %>%
    as.character()
  
  if (length(MarketValue) > 0) {
    
    temp2 <- data.frame(Player,MarketValue)
    Catcher2 <- rbind(Catcher2,temp2)
    
  } else {}
  
  cat("*")
  
}

