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
# Define UI for application that draws a histogram


shinyUI(fluidPage(
  
  responsive =FALSE, 
  dashboardPage(
    dashboardHeader(title="Dashobard regional"),
    dashboardSidebar(),
    dashboardBody(  sidebarLayout(
      
      sidebarPanel(
      ),
      
      mainPanel(
        tabsetPanel(
          #tabPanel("Tour1", plotlyOutput("distPlot")),
          tabPanel("Tour2", plotlyOutput("distPlot"))
          
        )
      )  
    )),
    skin="red"
    ),
  
  

  
)
)

