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
  
  
  
  
  
  
  # Show a plot of the generated distribution
  
  #Groupe 1 : DEP, graphiques 1 à 5

  #Groupe 2 : DEP, graphiques 6 à 11
  fluidRow(
    #titlePanel(h1("Pourcentage de voix sur le nombre de votes totaux par département pour chacun des quatres premiers candidats",
    #              style={'color: white;
    #                    background-color: #142236;
    #                    margin-left: -15px;
    #                    margin-right: -15px;
    #                    padding-left: 205px;'})),
    #Bouton T1
    actionButton("G2_T1", "Résultats du premier tour"),
    
    #Bouton T2
    actionButton("G2_T2", "Résultats du second tour"),
  ),          
  fluidRow(          
    ###Carte 1/3
    column(6,
           plotlyOutput("ga4")
    ),
    
    column(6,
           plotlyOutput("ga5")
    )),
  
  
  fluidRow(
    column(6,
           plotlyOutput("ga6")
    ),
    column(6,
           plotlyOutput("ga7")
    )
  ),
  
  
  
  #Groupe 3 : DEP, graphiques 12 à 17
  
)
)

