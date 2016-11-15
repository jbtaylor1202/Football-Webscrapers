library(rvest)
library(tidyverse)
library(stringr)


season_urls <- read.csv("Season URLs.csv",stringsAsFactors = FALSE) 
season_urls_list <- as.list(season_urls$url)

#Extract Team Data
team_data <- data.frame(season = character(),
                        team_name = character(),
                        squad_size = numeric(),
                        squad_foreign_players = numeric(),
                        squad_average_age = numeric(),
                        squad_market_value = character(),
                        stringsAsFactors = FALSE)


for(i in season_urls_list){
  scraped_URL <- read_html(i)
  
  Team_URLs <- scraped_URL %>% 
    html_nodes(".hide-for-pad .vereinprofil_tooltip") %>% 
    html_attr("href") %>% 
    as.character()
  
  Team_URLs <- paste0("http://www.transfermarkt.com", Team_URLs)
 
               for (i in Team_URLs){
                    Team_URLs <- read_html(i)
                      
                     cat("Processing...", i, "\n")
                      
                     season <- str_sub(i, -4, -1)
                     
                     team_name <- Team_URLs %>% 
                        html_nodes(".dataName b") %>% 
                        html_text() %>% 
                        as.character()
                      
                      squad_size <- Team_URLs %>% 
                        html_nodes(".dataDaten:nth-child(1) p:nth-child(1) .dataValue") %>% 
                        html_text() %>% 
                        as.numeric()
                      
                      squad_market_value <- Team_URLs %>% 
                        html_nodes(".dataMarktwert a") %>% 
                        html_text() %>% 
                        as.character()
                      
                      squad_average_age <- Team_URLs %>% 
                        html_nodes(".dataDaten:nth-child(1) p:nth-child(2) .dataValue") %>% 
                        html_text() %>% 
                        as.character()
                      
                      squad_foreign_players <- Team_URLs %>% 
                        html_nodes("p~ p+ p .dataValue > a") %>% 
                        html_text() %>% 
                        as.numeric()
                   
                      Temp_Dataframe <- data.frame(season, team_name, squad_size, squad_foreign_players, squad_average_age, squad_market_value)
                      team_data <- rbind(team_data, Temp_Dataframe)
                      
                      cat("Processed...", i, "\n", "\n")
                      Sys.sleep(runif(min = 0.01, max = 0.5))
                      }
  }

write.csv(team_data, file = "team_data.csv")
