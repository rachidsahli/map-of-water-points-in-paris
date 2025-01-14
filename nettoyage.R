# Modification de a table eau.csv

# Correction du mot fontaine dans la variable Nom_df
eau$Lieu <- gsub("Fontaines", "Fontaine", eau$Lieu)

# Capitalisation d'uniquement la premiere lettre
eau$Nom.voie <- paste(toupper(substring(eau$Nom.voie, 1, 1)), tolower(substring(eau$Nom.voie, 2)), sep="")

# Correction du mot ilots/espaces_verts dans la variable Nom_df
eau$Lieu <- gsub("Ilots_espaces_verts ", "Ilots/espaces verts", eau$Lieu)
