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
samples_matogrosso <- readRDS("samples_matogrosso_modis.rds")
samples_matogrosso
view(samples_matogrosso)

# Creating a data cube based on the ground truth samples -----------------------------------------------------------------------------------

# Find the the bounding box of the data
lat_max <- max(samples_matogrosso[["latitude"]])
lat_min <- min(samples_matogrosso[["latitude"]])
lon_max <- max(samples_matogrosso[["longitude"]])
lon_min <- min(samples_matogrosso[["longitude"]])

# Define the roi for the LEM dataset
roi_lem <- c(
    "lat_max" = lat_max,
    "lat_min" = lat_min,
    "lon_max" = lon_max,
    "lon_min" = lon_min)

# Define a data cube in the BDC repository based on the LEM ROI
bdc_cube <- sits_cube(
    source = "BDC",
    collection  = "CBERS-WFI-16D",
    bands = c("NDVI", "EVI"),
    roi = roi_lem,
    start_date = "2019-09-30",
    end_date = "2020-09-29"
)

# copy the data cube to a local directory  -------------------------------------------------------------------------------------------------

# Copy the region of interest to a local directory
lem_cube <- sits_cube_copy(
    cube = bdc_cube,
    roi = roi_lem,
    output_dir = tempdir_r2
)

library(sf)

# Plot the cube 
plot(lem_cube, band = "NDVI", palette = "RdYlGn")

# Show the description of the data cube
lem_cube

# Show information on the images files which are part of a data cube
lem_cube$file_info[[1]]

# Show the R object that describes the data cube
sits_timeline(lem_cube)

# The time series tibble -------------------------------------------------------------------------------------------------------------------

# Retrieve the time series for each samples based on a data.frame
samples_lem_time_series <- sits_get_data(
    cube = lem_cube,
    samples = samples_matogrosso
)
