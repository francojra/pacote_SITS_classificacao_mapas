# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 24/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

#  Self-organized maps for sample quality control - Capítulo 14 ----------------------------------------------------------------------------

# Configurations to run this chapter -------------------------------------------------------------------------------------------------------

library(tibble)
library(sits)
library(sitsdata)

# set tempdir if it does not exist 
tempdir_r <- "ts_som"
dir.create(tempdir_r, showWarnings = FALSE)

