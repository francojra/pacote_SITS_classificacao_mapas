
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