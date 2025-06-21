
# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 18/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/earth-observation-data-cubes.html -------------------------------------------------------

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(sits)
library(sitsdata)
library(raster)
library(ggplot2)
library(ggspatial)

# Amazon Web Services ----------------------------------------------------------------------------------------------------------------------

# Criar um cubo de dados cobrindo uma área do Brasil

s2_23MMU_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-2-L2A",
  tiles = "23MMU",
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = "2018-07-12",
  end_date = "2019-07-28"
)

plot(s2_23MMU_cube,
  red = "B11",
  blue = "B02",
  green = "B8A",
  date = "2018-10-05"
)

# Microsoft Planetary Computer - SENTINEL-2/2A images in MPC -------------------------------------------------------------------------------

# Criar um cubo de dados cobrindo uma área da Amazônia

s2_20LKP_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  tiles = "20LKP",
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = "2019-07-01",
  end_date = "2019-07-28"
)

# Plotar uma composição de cor de uma data do cubo 

plot(s2_20LKP_cube_MPC,
  red = "B11", blue = "B02", green = "B8A",
  date = "2019-07-18"
)

# LANDSAT-C2-L2 images in MPC --------------------------------------------------------------------------------------------------------------

## Para essa coleção, pesquisa por tile não é suportado, o parâmetro 
## roi (região de interesse) deve ser usado para esse cubo. O
## exemplo abaixo mostra como recuperar dados de uma região de
## interesse cobrindo a cidade de Brasília.

# Ler um ROI que cobre parte da costa nordeste do Brasil

roi <- c(
  lon_min = -43.5526, lat_min = -2.9644,
  lon_max = -42.5124, lat_max = -2.1671
)

# Selecionar um cubo

s2_L8_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "LANDSAT-C2-L2",
  bands = c("BLUE", "RED", "GREEN", "NIR08", "SWIR16", "CLOUD"),
  roi = roi,
  start_date = "2019-06-01",
  end_date = "2019-09-01"
)

# Plotar o tile que cobre os lençois maranhenses 

plot(s2_L8_cube_MPC,
  red = "RED", green = "GREEN", blue = "BLUE",
  date = "2019-06-30"
)

## Teste

roi <- c(
  lon_min = -47.6000, lat_min = -14.2000,
  lon_max = -47.5000, lat_max = -14.1000
)

s2_L8_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "LANDSAT-C2-L2",
  bands = c("BLUE", "RED", "GREEN", "NIR08", "SWIR16", "CLOUD"),
  roi = roi,
  start_date = "2019-06-01",
  end_date = "2019-09-01"
)

View(s2_L8_cube_MPC)
sits_timeline(s2_L8_cube_MPC) # Importante sempre verificar as
# datas disponíveis para esse cubo com um diferente roi

plot(s2_L8_cube_MPC,
  red = "RED", green = "GREEN", blue = "BLUE",
  date = "2019-06-20"
)

sits::sits_bbox(s2_L8_cube_MPC)
summary(s2_L8_cube_MPC)

# SENTINEL-1-GRD images in MPC -------------------------------------------------------------------------------------------------------------

cube_s1_grd <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-GRD",
  bands = c("VV"),
  orbit = "descending",
  tiles = c("21LUJ", "21LVJ"),
  start_date = "2021-08-01",
  end_date = "2021-09-30"
)

plot(cube_s1_grd, band = "VV", palette = "Greys")

# SENTINEL-1-RTC images in MPC -------------------------------------------------------------------------------------------------------------

cube_s1_rtc <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-RTC",
  bands = c("VV", "VH"),
  orbit = "descending",
  tiles = "18NZM",
  start_date = "2021-08-01",
  end_date = "2021-09-30"
)

plot(cube_s1_rtc, band = "VV", palette = "Greys")

# Copernicus DEM 30 meter images in MPC ----------------------------------------------------------------------------------------------------

cube_dem_30 <- sits_cube(
  source = "MPC",
  collection = "COP-DEM-GLO-30",
  tiles = "20LMR",
  band = "ELEVATION"
)

plot(cube_dem_30, band = "ELEVATION", palette = "RdYlGn", rev = TRUE)

sits:sits_bbox(cube_dem_30)

# Brazil Data Cube -------------------------------------------------------------------------------------------------------------------------

# Define a tile from the CBERS-4/4A AWFI collection
cbers_tile <- sits_cube(
  source = "BDC",
  collection = "CBERS-WFI-16D",
  #tiles = "005004",
  roi = roi,
  bands = c("B13", "B14", "B15", "B16", "CLOUD"),
  start_date = "2021-05-01",
  end_date = "2021-09-01"
)

# Plot one time instance
plot(cbers_tile,
  red = "B15",
  green = "B16",
  blue = "B13",
  date = "2021-05-09"
)

## Teste

# Definir região de interesse

roi <- c(
  lon_min = -48.6153, lat_min = -16.9743,
  lon_max = -44.1079, lat_max = -13.2180
)

# Criar cubo

cbers_tile <- sits_cube(
  source = "BDC",
  collection = "CBERS-WFI-16D",
  #tiles = "005004",
  roi = roi,
  bands = c("B13", "B14", "B15", "B16", "CLOUD"),
  start_date = "2021-05-01",
  end_date = "2021-09-01"
)

# Criar mapa

plot(cbers_tile,
  red = "B15",
  green = "B16",
  blue = "B13",
  date = "2021-05-09"
)

# Digital Earth Africa ---------------------------------------------------------------------------------------------------------------------

dea_s2_cube <- sits_cube(
  source = "DEAFRICA",
  collection = "SENTINEL-2-L2A",
  roi = c(
    lon_min = 46.1, lat_min = -15.6,
    lon_max = 46.6, lat_max = -16.1
  ),
  bands = c("B02", "B04", "B08"),
  start_date = "2019-04-01",
  end_date = "2019-05-30"
)

plot(dea_s2_cube, red = "B04", blue = "B02", green = "B08")

dea_l9_cube <- sits_cube(
  source = "DEAFRICA",
  collection = "LS9-SR",
  roi = c(
    lon_min = 33.0, lat_min = -3.60,
    lon_max = 33.6, lat_max = -3.00
  ),
  bands = c("B04", "B05", "B06"),
  start_date = "2023-05-01",
  end_date = "2023-08-30"
)

plot(dea_l9_cube,
  date = "2023-06-26",
  red = "B06", green = "B05", blue = "B04"
)

dea_alos_cube <- sits_cube(
  source = "DEAFRICA",
  collection = "ALOS-PALSAR-MOSAIC",
  roi = c(
    lon_min = 28.69, lat_min = -2.35,
    lon_max = 29.35, lat_max = -1.56
  ),
  bands = c("HH", "HV"),
  start_date = "2020-01-01",
  end_date = "2020-12-31"
)

plot(dea_alos_cube, band = "HH", palette = "RdYlGn")

# Digital Earth Australia ------------------------------------------------------------------------------------------------------------------

# get roi for an MGRS tile
bbox_55KGR <- sits_mgrs_to_roi("55KGR")

# retrieve the world cover map for the chosen roi
s2_56KKV <- sits_cube(
  source = "DEAUSTRALIA",
  collection = "GA_S2AM_ARD_3",
  tiles = "56KKV",
  bands = c("BLUE", "GREEN", "RED", "NIR-2", "SWIR-2", "CLOUD"),
  start_date = "2023-09-01",
  end_date = "2023-11-30"
)

# plot the resulting map
plot(s2_56KKV, green = "NIR-2", blue = "BLUE", red = "SWIR-2", date = "2023-10-14")

# EO products from TERRASCOPE --------------------------------------------------------------------------------------------------------------

# get roi for an MGRS tile
bbox_22LBL <- sits_mgrs_to_roi("22LBL")

# retrieve the world cover map for the chosen roi
world_cover_2021 <- sits_cube(
  source = "TERRASCOPE",
  collection = "WORLD-COVER-2021",
  roi = bbox_22LBL
)

# cut the 3 x 3 degree grid to match the MGRS tile 22LBL
world_cover_2021_20LBL <- sits_cube_copy(
  cube = world_cover_2021,
  roi = bbox_22LBL,
  multicores = 6,
  output_dir = "arquivos_pacote_sits"
)

# plot the resulting map
plot(world_cover_2021_20LBL)

## Teste

roi <- c(
  lon_min = -47.6000, lat_min = -14.2000,
  lon_max = -47.5000, lat_max = -14.1000
)

world_cover_2021 <- sits_cube(
  source = "TERRASCOPE",
  collection = "WORLD-COVER-2021",
  roi = roi
)

world_cover_2021_teste <- sits_cube_copy(
  cube = world_cover_2021,
  roi = roi,
  multicores = 6,
  output_dir = "arquivos_pacote_sits"
)

plot(world_cover_2021_teste)

# Planet data as ARD local files -----------------------------------------------------------------------------------------------------------

# Define the directory where Planet files are stored
data_dir <- system.file("extdata/Planet", package = "sitsdata")

# Create a data cube from local files
planet_cube <- sits_cube(
  source = "PLANET",
  collection = "MOSAIC",
  data_dir = data_dir,
  roi = roi
)

# Plot the first instance of the Planet data in natural colors
plot(planet_cube, red = "B3", green = "B2", blue = "B1")

# Reading classified images as local data cube ---------------------------------------------------------------------------------------------

# Create a cube based on a classified image
data_dir <- system.file("extdata/Rondonia-20LLP",
  package = "sitsdata"
)

# File name  "SENTINEL-2_MSI_20LLP_2020-06-04_2021-08-26_class_v1.tif"
Rondonia_class_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-S2-L2A-COGS",
  bands = "class",
  labels = c(
    "1" = "Burned_Area", "2" = "Cleared_Area",
    "3" = "Highly_Degraded", "4" = "Forest"
  ), 
  data_dir = data_dir,
  parse_info = c(
    "satellite", "sensor", "tile", "start_date", "end_date",
    "band", "version"
  )
)

View(Rondonia_class_cube)

# Plot the classified cube
plot(Rondonia_class_cube)

# Regularizing data cubes ------------------------------------------------------------------------------------------------------------------

# Creating an irregular data cube from MPC
s2_cube_rondonia <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  roi = roi,
  tiles = c("20LKP", "20LLP"),
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = as.Date("2018-06-30"),
  end_date = as.Date("2018-08-31")
)

# Show the different timelines of the cube tiles
sits_timeline(s2_cube_rondonia)

# plot the first image of the irregular cube
s2_cube_rondonia |>
  dplyr::filter(tile == "20LLP") |>
  plot(red = "B11", green = "B8A", blue = "B02", date = "2018-07-03")

## Teste

# Creating an irregular data cube from MPC
s2_cube_teste <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  roi = roi,
 # tiles = c("20LKP", "20LLP"),
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = as.Date("2018-06-30"),
  end_date = as.Date("2018-08-31")
)

# Show the different timelines of the cube tiles
sits_timeline(s2_cube_teste)

plot(s2_cube_teste, 
     red = "B11", green = "B8A", 
     blue = "B02", date = "2018-07-04")

sits_bbox(s2_cube_teste)
