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
  theme_void() + theme(plot.title = element_text(size=20,vjust = 0.7)) 
)

#Couleurs des partis
couleurs_T1=c("#0E4D7C", "#051237", "#2ABAFF","#DE313D")
couleurs_T2=c( "#051237", "#2ABAFF")
couleurs_T2v2=c( "#2ABAFF", "#051237")
abstention="#D41574"

carte_dep=read.csv2("carte_dep.csv",sep=",",dec=".", header = T)
carte_cant=read.csv2("carte_cant.csv",sep=",",dec=".", header = T)

setDT(carte_dep)
setDT(carte_cant)
#carte_dep[,tour:=ifelse(tour==1,"Premier tour","Second tour")]


g12=ggplot(carte_cant)+
  geom_bar(aes(x = canton, y=abstention_inscrits),fill=abstention,stat="identity",position=position_dodge(),width =0.6)+ 
  labs(fill = "Candidat") + xlab("")+
  theme(axis.text.x= element_text(size=17,colour = "#000000"))+
  theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nimes","Perpignan","Beziers"))+ coord_flip() +ggtitle("Taux d'abstention pour\nles plus grandes villes")+ ylab("Asbtention \npar rapport au nombre \nd'inscrits en %")


g15=ggplot(carte_cant)+
  geom_bar(aes(x = canton, y=blancs_inscrits),fill="#E6B52E",stat="identity",position=position_dodge(),width =0.6)+ 
  labs(fill = "Candidat") + xlab("")+
  ylab("Votes blancs\npar rapport au nombre\nd'inscrits en %")+theme(axis.text.x= element_text(size=17,colour = "#000000"))+
  theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nimes","Perpignan","Beziers")) + coord_flip()+ggtitle("Taux de votes blancs pour\nles plus grandes villes")


g13=ggplot(carte_dep[place==1 & nom_region=="Occitanie",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = abstention_inscrits), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high=abstention, limits=c(15,25))+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) + labs(fill = "Asbtention \npar rapport au nombre \nd'inscrits en %") + facet_grid(.~tour)+ggtitle("Evolution du taux d'abstention")

g14=ggplot(carte_dep[place==1 & nom_region=="Occitanie",], aes(long, lat, group = group))+
  geom_polygon(aes(fill = blancs_inscrits), color = "white", size = 0.1)+ 
  scale_fill_gradient(low="#ECEEF0", high="#E6B52E")+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) +
  labs(fill = "Votes blancs\npar rapport au nombre\nd'inscrits en %") + facet_grid(.~tour)+ggtitle("Evolution du taux de votes blancs",)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  ################G1########################
  ######Défaut cartes france
  #####G1 ga1

  v4 <- reactiveValues(data = NULL)
  

  observeEvent(input$G3_abstention, {
    v4$data=1
  })
  observeEvent(input$G3_blancs, {
    v4$data=NULL
  })
  

  output$ga8 <- renderPlotly({
    if (is.null(v4$data)) return(g14)
    ggplotly(g13)
  })
  output$ga9 <- renderPlotly({
    if (is.null(v4$data)) return(g15)
    ggplotly(g12)
  })
  
  
  
})
