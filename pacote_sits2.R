
# sits: Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------

# Baixar e carregar pacote sitsdata --------------------------------------------------------------------------------------------------------

library(devtools) # Necessário para baixar o pacote
options(download.file.method = "wininet")
devtools::install_github("e-sensing/sitsdata")

# Baixar pacotes para análises -------------------------------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)

# Create a data cube using local files ---------------------------------------------------------------------------------------------------

sinop_cube <- sits_cube(
  source = "BDC",
  collection = "MOD13Q1-6.1",
  bands = c("NDVI", "EVI"),
  data_dir = system.file("extdata/sinop", package = "sitsdata"),
  parse_info = c("satellite", "sensor", "tile", "band", "date")
)

# Plot the NDVI for the first date (2013-09-14) --------------------------------------------------------------------------------------------

plot(sinop_cube,
  band = "NDVI",
  dates = "2013-09-14",
  palette = "RdYlGn"
)

# The R object returned by sits_cube() contains the metadata 
# describing the contents of the data cube. It includes data
# source and collection, satellite, sensor, tile in the
# collection, bounding box, projection, and list of files.
# Each file refers to one band of an image at one of the
# temporal instances of the cube.

view(sinop_cube)

# The list of image files which make up the data cube is stored 
# as a data frame in the column file_info. For each file, sits 
# stores information about spectral band, reference date, size, 
# spatial resolution, coordinate reference system, bounding box,
# path to file location and cloud cover information 
# (when available).

# Show information on the images files which are part of a data cube

view(sinop_cube$file_info[[1]])

# Show the R object that describes the data cube

sits_timeline(sinop_cube)

# The timeline of the sinop_cube data cube has 23 intervals 
# with a temporal difference of 16 days. The chosen dates 
# capture the agricultural calendar in Mato Grosso, Brazil. 
# The agricultural year starts in September-October with the 
# sowing of the summer crop (usually soybeans) which is 
# harvested in February-March. Then the winter crop 
# (mostly Corn, Cotton or Millet) is planted in March and 
# harvested in June-July. For LULC classification, the training 
# samples and the date cube should share a timeline with the 
# same number of intervals and similar start and end dates.

