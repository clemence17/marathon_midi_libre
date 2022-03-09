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

#df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/Presidentielle_2017_Departement_Tour_2.xls")
df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/villes_2.xls")
df=as.data.frame(df)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$distPlot <- renderPlotly({
    
    
    #ggplot(data = df, aes(x=df[,1],y=df[,2], fill=df[,3])) + geom_col(position="dodge") + ggtitle('histo')
    ggplotly(ggplot(data=df, aes(x=ville, y=vote, fill=candidat)) +
               geom_bar(stat="identity", position=position_dodge(), colour="black") +
               scale_fill_manual(values=c("#142236", "#FC4E07")))

    
  })


})
