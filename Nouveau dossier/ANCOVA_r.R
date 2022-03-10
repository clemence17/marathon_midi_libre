library(tidyverse)
library(ggpubr)
library(rstatix)
library(broom)

data<-read.delim(file("clipboard"), header = TRUE, sep = "\t", quote = "\"", dec = ".", fill = TRUE)
summary(data)

ggscatter(
  data, x = "pretest", y = "Voix",
  color = "group", add = "reg.line"
)+
  stat_regline_equation(
    aes(label =  paste(..eq.label.., ..rr.label.., sep = "~~~~"), color = group)
  )


# Calculer le modèle, la covariable passe en premier
model <- lm(% Abs/Ins ~ Libellé.de.la.région + Tx_pauvrete, data = data)
# Inspecter les paramètres de diagnostic du modèle
model.metrics <- augment(model) %>%
  select(-.hat, -.sigma, -.fitted, -.se.fit) # Supprimer les détails
head(model.metrics, 3)

summary(model)

Libel = as.factor(data$Libellé.de.la.région)

model1 <- lm(data$X..Abs.Ins ~ -1 + Libel + data$Tx_pauvrete:Libel)
summary(model1)
model1

