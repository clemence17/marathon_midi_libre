#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rsconnect)
library(shiny)
library(ggplot2)
library("readxl")
library(fpp3)
library(ggiraph)


#df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/Presidentielle_2017_Departement_Tour_2.xls")
df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/villes_2.xls")
df=as.data.frame(df)
dep1 <- read.csv2('C:/Users/elmen/OneDrive/Documents/github/marathon/Code_donnees_diag_circulaire/Presidentielle_Tour_1_dept_clean.csv')
heraut <- 
  dep1%>%filter(Libelle=="Herault")
mycols <- c("#D86473", "#057C85", "#FFCB05", "#127DB3", "#0E4D7C", "#C41424", "#034EA1", "#051237", "#2ABAFF", "#A4061A", "#87B2BC")

heraut$tooltip <- c(paste0("Nom = ", heraut$Nom, ", Voix = ", heraut$Voix))

my_gg<- ggplot(data = heraut, aes(x="",y=Voix, fill=Nom,tooltip=tooltip)) +
  geom_bar_interactive(width=1, stat="identity") +
  coord_polar("y", start=0)+
  scale_fill_manual(values = mycols) +
  theme_void()


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$distPlot <- renderPlotly({
    
    ggplotly(ggplot(data=df, aes(x=ville, y=vote, fill=candidat)) +
               geom_bar(stat="identity", position=position_dodge(), colour="black") +
               scale_fill_manual(values=c("#051237", "#2ABAFF")))
    
    
  })
  
  
  
  
  output$Diagr <- renderggiraph({
    ggiraph(code = print(my_gg), selection_type = "multiple")
    
    
  })
  
})
