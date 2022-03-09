#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggiraph)
library(plotly)
library(shinydashboard)
library(shinyWidgets)
library(shinythemes)
# Define UI for application that draws a histogram c("#142236", "#E61D23")


shinyUI(fluidPage(theme = shinytheme("simplex"),
                  
                  setBackgroundColor(
                    color = "#ecf0f5",
                    gradient = "radial",
                    direction = c("top", "left")
                  ),
                  
                  titlePanel(h1("Dashboard regional",
                                style={'color: white;
                        font-style: oblique ;
                        background-color:#142236;
                        margin-left: -15px;
                        margin-right: -15px;
                        padding-left: 605px;'})
                  ),
                  
                  
                  sidebarLayout(
                    sidebarPanel(
                      selectInput("tour", "Tour",
                                  choices = list("Tour 1" = "topleft", "Tour 2" = "topright"))
                    ),
                    mainPanel(
                      fluidRow(
                        splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("distPlot"), ggiraphOutput("Diagr"))
                      )
                      
                    )
                  )
)
)


