
library(rvest)
library(openxlsx)

bbclist<- c('https://www.bbc.com/sport/football/premier-league/top-scorers',
            'https://www.bbc.com/sport/football/spanish-la-liga/top-scorers',
            'https://www.bbc.com/sport/football/german-bundesliga/top-scorers',
            'https://www.bbc.com/sport/football/french-ligue-one/top-scorers',
            'https://www.bbc.com/sport/football/italian-serie-a/top-scorers')

leagues<-c('EPL','La Liga', 'Bundesliga', 'Lique One', 'Serie A')

for (i in 1:length(bbclist)){
  download.file(bbclist[i], destfile = paste(leagues[i],'.html'), quiet =TRUE)
}

topscorer<-""  
temp<- ""
for (i in leagues){
  
  players = read_html(paste(i,'.html')) %>%
    html_nodes(".top-player-stats__name") %>% 
    html_text() 
  scored = read_html(paste(i,'.html')) %>%
    html_nodes(".top-player-stats__goals-scored-number") %>% 
    html_text() 
  team = read_html(paste(i,'.html')) %>%
    html_nodes(".team-short-name") %>% 
    html_text() 
  assist = read_html(paste(i,'.html')) %>%
    html_nodes(".top-player-stats__assists") %>% 
    html_text() 
  
  mpg = read_html(paste(i,'.html')) %>%
    html_nodes(".top-player-stats__mins-per-goal") %>% 
    html_text()  
  
  shotper = read_html(paste(i,'.html')) %>%
    html_nodes(".percentage-goals-on-target") %>% 
    html_text()  
  
  minplayed = read_html(paste(i,'.html')) %>%
    html_nodes(".top-player-stats__mins-played") %>% 
    html_text() 
  
  shots = read_html(paste(i,'.html')) %>%
    html_nodes(".shots-total") %>% 
    html_text() 
  shotsongoal = read_html(paste(i,'.html')) %>%
    html_nodes(".shots-on-goal-total") %>% 
    html_text() 
  
  temp <-data.frame(cbind(players,scored, team,i, assist, mpg, shotper, minplayed, shots, shotsongoal))
  
  
  
  topscorer<-data.frame(rbind(topscorer,temp))
}

topscorer<-topscorer[-1,]
colnames(topscorer)[4] <- "League"
topscorer<-cbind(topscorer,Sys.Date())
  write.xlsx(topscorer, file=paste("topscorerdata",Sys.Date(), ".xlsx"), sheetName = "Sheet1", 
             col.names = TRUE, row.names = FALSE, append = FALSE)
