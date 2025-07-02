# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 01/07/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

# How to use SITS with real examples -------------------------------------------------------------------------------------------------------

# The following scripts show examples of how to use sits for 
# land classification. The first is a classification of a 
# Sentinel-2 tile in Rondonia (Brasil) to detect deforestation 
# and the second a land use and land cover classification of 
# area in the Cerrado biome in Brazil.

# Configuration to run the examples in this chapter ----------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)

# set tempdir if it does not exist

tempdir_r <- "praticando-SITS" # Cria nova pasta no diretório
dir.create(tempdir_r, recursive = TRUE)

# set tempdir for Cerrado if it does not exist

## Cria duas novas pastas para Cerrado e Rondonia
## dentro da nova pasta criada no diretório

tempdir_cerrado_cube <- paste0(tempdir_r, "/cerrado/cube")
tempdir_cerrado <- paste0(tempdir_r, "/cerrado")
dir.create(tempdir_cerrado, recursive = TRUE)
dir.create(tempdir_cerrado_cube, recursive = TRUE)

# set tempdir for Rondonia if it does not exist

tempdir_rondonia <- paste0(tempdir_r, "/rondonia")
dir.create(tempdir_rondonia, recursive = TRUE)
