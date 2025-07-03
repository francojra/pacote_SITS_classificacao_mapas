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

# Classifying deforestation in Rondonia ----------------------------------------------------------------------------------------------------

# To access the data, it is needed to clone the rondonia20LMR 
# repository from the e-sensing GitHub repository into a local 
# directory. To do this, open a terminal and execute the 
# following commands:

# git clone https://github.com/e-sensing/rondonia20LMR.git

# After cloning the repository, the local directory path can be 
# used to proceed with the example. 

# This path will serve as the reference location for accessing 
# the dataset and continuing with the subsequent steps in the 
# analysis workflow.

# In the rondonia20LMR directory, the file deforestation_samples_v18.rds 
# contains time series extracted from Sentinel-2 satellite images over 
# tile 20LMR.

# Samples path

samples_path <- "rondonia20LMR/inst/extdata/samples/deforestation_samples_v18.rds"

# Read the Cerrado samples

deforestation_samples_v18 <- readRDS(samples_path)

view(deforestation_samples_v18)

# As shown in the previous example, the sits_patterns() function 
# from the sits package allows the visualization of the temporal 
# patterns of the classes. 

# Generate the temporal patterns

deforestation_samples_v18  |> 
     sits_select(bands = c("B02", "B8A", "B11")) |> 
     sits_patterns() |> 
     plot()

# Build Data Cube and visualize band combination -------------------------------------------------------------------------------------------

# Images path

images_path <- "rondonia20LMR/inst/extdata/images/"

# Access local data cube

cube_20LMR <- sits_cube(
     source = "MPC",
     collection = "SENTINEL-2-L2A",
     data_dir = images_path,
     start_date = "2022-01-05",
     end_date = "2022-11-05"
)

view(cube_20LMR)

cube_20LMR$file_info[[1]]

view(cube_20LMR$file_info[[1]])

# The sits_cube() function creates the data cube cube_20LMR 
# with the Sentinel-2 tile 20LMR images available in the 
# repository. Each temporal instance includes the spectral 
# bands B02, B03, B04, B05, B06, B07, B08, B8A, B11 and B12.

# Plot one temporal instance

plot(cube_20LMR, red = "B04", 
     green = "B03", blue = "B02")

# SITS provides the sits_select() function, which filters only 
# the selected bands and dates from a set of time series or a 
# data cube. As shown in the code below:

# Select only bands B02, B8A and B11

samples_3bands <- sits_select(
        data = deforestation_samples_v18,
        bands = c("B02", "B8A", "B11")
)

view(samples_3bands)

view(samples_3bands$time_series[[1]])
