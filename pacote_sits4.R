# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 22/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/earth-observation-data-cubes.html -------------------------------------------------------

# Computing NDVI and other spectral indices ------------------------------------------------------------------------------------------------

# Pacotes e diretório ----------------------------------------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)
# set tempdir if it does not exist 
tempdir_r <- "arquivos_sits" # Nome da pasta
dir.create(tempdir_r, showWarnings = FALSE, 
           recursive = TRUE)

# Calculando índices de vegetação ----------------------------------------------------------------------------------------------------------

# Create an non-regular data cube from AWS
s2_cube <- sits_cube(
    source = "AWS",
    collection = "SENTINEL-S2-L2A-COGS",
    tiles = "20LKP",
    bands = c("B02", "B03", "B04", 
              "B05", "B06", "B07", 
              "B08", "B8A", "B11", 
              "B12","CLOUD"),
    start_date = as.Date("2018-07-01"),
    end_date = as.Date("2018-08-31"))

# Regularize the cube to 15 day intervals
reg_cube <- sits_regularize(
          cube       = s2_cube,
          output_dir = tempdir_r,
          res        = 60,
          period     = "P15D",
          multicores = 4)

# Calculate NDVI index using bands B08 and B04
reg_cube <- sits_apply(reg_cube,
    NDVI = (B08 - B04)/(B08 + B04),
    output_dir = tempdir_r
)

# Plot
plot(reg_cube, band = "NDVI", palette = "RdYlGn")

# We now compare the traditional NDVI with other vegetation 
# index computed using red-edge bands. The example below such 
# the NDRE1 index, obtained using bands B06 and B05.

# Notice that the contrast between forests and deforested 
# areas is more robust in the NDRE1 index than with NDVI.

# Calculate NDRE1 index using bands B06 and B05
reg_cube <- sits_apply(reg_cube,
    NDRE1 = (B06 - B05)/(B06 + B05),
    output_dir = tempdir_r
)

# Plot NDRE1 index
plot(reg_cube, band = "NDRE1",  palette = "RdYlGn")

# Spectral indexes for identifying burned areas --------------------------------------------------------------------------------------------

# Band combinations can also generate spectral indices for 
# detecting degradation by fires, which are an important 
# element in environmental degradation. 

# One well-established technique for detecting burned areas 
# with remote sensing images is the normalized burn ratio 
# (NBR), the difference between the near-infrared and the 
# short wave infrared band, calculated using bands B8A and B12.

# Calculate the NBR index
reg_cube <- sits_apply(reg_cube,
    NBR = (B12 - B8A)/(B12 + B8A),
    output_dir = tempdir_r
)

# Plot the NBR for the first date
plot(reg_cube, band = "NBR", palette = "Reds")

# Support for non-normalized indexes -------------------------------------------------------------------------------------------------------

# CVI is a spectral index used to estimate the chlorophyll 
# content and overall health of vegetation. It combines bands 
# in visible and near-infrared (NIR) regions to assess 
# vegetation characteristics. Since CVI is not normalized, 
# we have to set the parameter normalized to FALSE to inform 
# sits_apply().
