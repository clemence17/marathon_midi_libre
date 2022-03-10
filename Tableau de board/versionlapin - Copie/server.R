#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Librairies
library(shiny)
library(data.table)
library(tidyverse)
library(stringr)
library(stringi)
library(ggplot2)
library(plotly)
library(maps)

theme_set(
  theme_void() + theme(plot.title = element_text(size=20))
)

#Couleurs des partis
couleurs_T1=c("#0E4D7C", "#051237", "#2ABAFF","#DE313D")
couleurs_T2=c( "#051237", "#2ABAFF")
couleurs_T2v2=c( "#2ABAFF", "#051237")
abstention="#D41574"

carte_dep=read.csv2("carte_dep.csv",sep=",",dec=".")
carte_cant=read.csv2("carte_cant.csv",sep=",",dec=".")

setDT(carte_dep)
setDT(carte_cant)
#carte_dep[,tour:=ifelse(tour==1,"Premier tour","Second tour")]




g6=ggplot(carte_dep[nom=="MACRON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[3])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes") +ggtitle("Taux de votes\npour Emmanuel Macron")
g7=ggplot(carte_dep[nom=="MACRON" & nom_region=="Occitanie" & tour=="Second tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[3])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes")  +ggtitle("Taux de votes\npour Emmanuel Macron")


g8=ggplot(carte_dep[nom=="LE PEN" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[2])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes") + ggtitle("Taux de votes\npour Marine Le Pen")


g9=ggplot(carte_dep[nom=="LE PEN" & nom_region=="Occitanie" & tour=="Second tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[2])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes") + ggtitle("Taux de votes\npour Marine Le Pen")
g10=ggplot(carte_dep[nom=="MELENCHON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[4])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes") + ggtitle("Taux de votes\npour Jean-Luc Mélenchon")

g11=ggplot(carte_dep[nom=="FILLON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = votes_votant), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[1])+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "% de votes") +ggtitle("Taux de votes\npour François Fillon")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  ################G1########################
  ######Défaut cartes france
  #####G1 ga1

  v3 <- reactiveValues(data = NULL)
  
  observeEvent(input$G2_T1, {
    v3$data=NULL
  })
  observeEvent(input$G2_T2, {
    v3$data=1
  })
 
  
  
  output$ga4 <- renderPlotly({
    if (is.null(v3$data)) return( ggplotly(g6))
    ggplotly(g7)
  })
  output$ga5 <- renderPlotly({
    if (is.null(v3$data)) return(ggplotly(g8))
    ggplotly(g9)
  })
  output$ga6 <- renderPlotly({
    if (is.null(v3$data)) return(ggplotly(g10))
    
  })
  output$ga7 <- renderPlotly({
    if (is.null(v3$data)) return(ggplotly(g11))
  
  })
  
  
})
