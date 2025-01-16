# Carte des points d'eau à Paris

Ce mini-projet utilise le langage R pour créer une **carte interactive** des points d'eau publics dans la ville de Paris. Il inclut également une application **Shiny** permettant de visualiser et d'explorer les données de manière dynamique.

## Description

L'objectif principal est de fournir une visualisation géographique des points d'eau à Paris, accessible via une interface utilisateur intuitive grâce à Shiny. La carte interactive est construite avec le package `leaflet` en R, offrant une navigation fluide et des fonctionnalités interactives pour explorer les différents points d'eau localisés dans les arrondissements parisiens.

## Structure du Projet

- **main.R** : Contient le code R qui charge les données, les traite, et génère la carte interactive (version script).
- **app.R** : Contient le code pour l'application Shiny permettant de visualiser la carte de manière dynamique.
- **water_data/** : Dossier contenant les données sur les points d'eau, telles que leur localisation géographique et leur type.
- 
## Prérequis

- **R** (version 4.0 ou plus récente recommandée)
- **Packages R nécessaires** :  
  - `leaflet`  
  - `leaflet.extras`  
  - `dplyr`  
  - `tidyr`  
  - `shiny`
 
  
## Aperçu
<img width="916" alt="Capture d’écran 2024-11-12 à 01 54 24" src="https://github.com/user-attachments/assets/3afb9a4c-021d-4fb9-8c26-8c1f236049c1">

## Interface

<img width="916" alt="Capture d’écran 2025-01-16 à 22.29.32" src="https://github.com/user-attachments/assets/3afb9a4c-021d-4fb9-8c26-8c1f236049c1">