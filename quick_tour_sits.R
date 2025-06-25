# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 24/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

# A quick tour of SITS ---------------------------------------------------------------------------------------------------------------------

# Configurations to run this chapter -------------------------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)
# set tempdir if it does not exist 
tempdir_r2 <- "~pRaticando-Softawer-R"
dir.create(tempdir_r2, showWarnings = FALSE, recursive = TRUE)

# Training samples -------------------------------------------------------------------------------------------------------------------------

# Load the samples for LEM from the "sitsdata" package
# select the directory for the samples 
samples_dir <- system.file("data", package = "sitsdata")
samples_dir

# Estebelecer o caminho do diretório acima
setwd("C:/Users/jeann/AppData/Local/R/win-library/4.5/sitsdata/data")
dir(samples_dir) # Apresenta os arquivos do diretório estabelecido

# retrieve a data.frame with the samples
samples_cerrado <- readRDS("samples_cerrado_lc8.rds")
samples_cerrado
view(samples_cerrado)
