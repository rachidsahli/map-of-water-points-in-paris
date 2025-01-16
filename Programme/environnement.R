# Import library ---------------

library(shiny) # Application
library(bslib) # Application
library(htmltools) # Manipulation de contenu html
library(dplyr) # Manipulation de données
library(leaflet) # Carte
library(leaflet.extras) # Carte
library(rsconnect) # Déploiement de l'application
library(tidyr) # Manipulation de données

# Import data ---------------

commerce_eau <- read.csv("Data/commerces-eau-de-paris.csv", header = TRUE, sep = ";")
fontaines_a_boire <- read.csv("Data/fontaines-a-boire.csv", header = TRUE, sep = ";")
ilots_equipements <- read.csv("Data/ilots-de-fraicheur-equipements-activites.csv", header = TRUE, sep = ";")
ilots_espaces_verts <- read.csv("Data/ilots-de-fraicheur-espaces-verts-frais.csv", header = TRUE, sep = ";")

eau <- read.csv("Data/eau.csv", header = TRUE)
