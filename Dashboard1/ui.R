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
      .shiny-input-container {
        color: #474747;
      }"))),
  setBackgroundColor(
    color = "white",
    gradient = "radial",
    direction = c("top", "left")
  ),
  
  titlePanel(h1("  ",)
  ),
  
  
  
  
  # Show a plot of the generated distribution
  
  #Groupe 1 : DEP, graphiques 1 5
  fluidRow(
    #Bouton National
    actionButton("G1_occitanie", "Occitanie"),
    #Bouton dÃ©partemental
    actionButton("G1_FR", "France") 
  ),        
  fluidRow( 
    
    ###Carte 1/3
    column(8,h2(" "),
           plotlyOutput("ga1")
    ),
    
    column(4,
           plotlyOutput("ga3")
    ),
    
    
    
    
  )
)
)

