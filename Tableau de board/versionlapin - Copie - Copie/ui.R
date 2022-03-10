#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
thematic::thematic_shiny()

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@300;400;500;600;700&display=swap');      body {
        font-family: 'Hind Siliguri', sans-serif;
      }
      h2 {
       font-family: 'Hind Siliguri', sans-serif;
      }
            h3 {
       font-family: 'Hind Siliguri', sans-serif;
      }
      .shiny-input-container {
        color: #474747;
      }"))),
  setBackgroundColor(
    color = "white",
    gradient = "radial",
    direction = c("top", "left")
  ),


  
  #Groupe 3 : DEP, graphiques 12 à 17
  fluidRow(
    
    #Bouton Blancs
    actionButton("G3_blancs", "Taux de votes blancs"),
    #Bouton abstention
    actionButton("G3_abstention", "Taux d'abstention")
  ),
  fluidRow(
    ###Carte 14 ou 17
    column(8, 
           plotlyOutput("ga8")
    ),
    ####Carte 12 ou 15
    column(4, 
           plotlyOutput("ga9")
    )
  )
)
)

