# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 30/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

# Data visualisation in SITS ---------------------------------------------------------------------------------------------------------------

## Configurations to run this chapter

library(sits)
library(sitsdata)
tempdir_visualization_sits <- "pRaticando-Software-R"
dir.create(tempdir_visualization_sits, showWarnings = FALSE, recursive = TRUE)

# Plotting ---------------------------------------------------------------------------------------------------------------------------------

## The plot() function produces a graphical display of data cubes, 
## time series, models, and SOM maps.
## he plotting of time series, models, and SOM outputs uses 
## the ggplot2 package; maps are plotted using the tmap package. 
## When plotting images and classified maps, users can control 
## the output, with appropriate parameters for each type of image.

# set the directory where the data is 
data_dir <- system.file("extdata/Rondonia-20LMR", package = "sitsdata")

# Plotting false color maps ----------------------------------------------------------------------------------------------------------------

# We refer to false color maps as images that are plotted on a 
# color scale. Usually, these are single bands, indexes such as 
# NDVI or DEMs. 

  # read the data cube
ro_20LMR <- sits_cube(
  source = "MPC", 
  collection = "SENTINEL-2-L2A",
  data_dir = data_dir
)

# plot the NDVI for date 2022-08-01
plot(ro_20LMR, 
     band = "NDVI", 
     date = "2022-08-01", 
     palette = "Greens",
     legend_position = "outside",
     scale = 1.0)
