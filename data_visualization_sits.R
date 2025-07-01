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

# Plotting RGB color composite maps --------------------------------------------------------------------------------------------------------

# For RGB color composite maps.

# plot a color composite for date 2022-08-01

plot(ro_20LMR, 
     red = "B11", 
     green = "B8A",
     blue = "B02",
     date = "2022-08-01", 
     scale = 1.0)

# Plotting classified maps -----------------------------------------------------------------------------------------------------------------

# Classified maps pose an additional challenge for plotting because 
# of the association between labels and colors.

# Create a cube based on a classified image 

data_dir <- system.file("extdata/Rondonia-20LLP", 
                        package = "sitsdata")

# Read the classified cube

rondonia_class_cube <- sits_cube(
    source = "AWS",
    collection = "SENTINEL-S2-L2A-COGS",
    bands = "class",
    labels = c("1" = "Burned", "2" = "Cleared", 
               "3" = "Degraded", "4" =  "Natural_Forest"),
    data_dir = data_dir
)

# Plot the classified cube

plot(rondonia_class_cube,
  legend = c("Burned" = "#a93226",
             "Cleared" = "#f9e79f",
             "Degraded" = "#d4efdf",
             "Natural_Forest" = "#1e8449"
             ),
  scale = 1.0,
  legend_position = "outside"
)

# Visualization of data cubes in interactive maps ------------------------------------------------------------------------------------------

# Data cubes and samples can also be shown as interactive maps using 
# sits_view(). This function creates tiled overlays of different 
# kinds of data cubes, allowing comparison between the original, 
# intermediate, and final results. It also includes background maps. 
# The following example creates an interactive map combining the 
# original data cube with the classified map.

sits_view(rondonia_class_cube,
            legend = c("Burned" = "#a93226",
             "Cleared" = "#f9e79f",
             "Degraded" = "#d4efdf",
             "Natural_Forest" = "#1e8449"
             )
)

# How colors work in sits -----------------------------------------------------------------------------------------------------------------

# In the examples provided in the book, the color legend is taken 
# from a predefined color palette provided by sits. The default color 
# definition file used by sits includes 220 class names, which can 
# be shown using sits_colors().

# Point default `sits` colors

sits_colors()
