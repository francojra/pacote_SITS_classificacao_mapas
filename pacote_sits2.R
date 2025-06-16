
# sits: Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------

# Baixar e carregar pacote sitsdata --------------------------------------------------------------------------------------------------------

# library(devtools) # Necessário para baixar o pacote
# options(download.file.method = "wininet")
# devtools::install_github("e-sensing/sitsdata")

# Baixar pacotes para análises -------------------------------------------------------------------------------------------------------------

library(tibble)
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

# The time series tibble -------------------------------------------------------------------------------------------------------------------

# To handle time series information, sits uses a tibble. 
# Tibbles are extensions of the data.frame tabular data 
# structures provided by the tidyverse set of packages. 
# The example below shows a tibble with 1,837 time series 
# obtained from MODIS MOD13Q1 images. Each series has four 
# attributes: two bands (NIR and MIR) and two indexes 
# (NDVI and EVI). This dataset is available in package sitsdata.

# The time series tibble contains data and metadata. The first 
# six columns contain the metadata: spatial and temporal 
# information, the label assigned to the sample, and the data 
# cube from where the data has been extracted. The time_series 
# column contains the time series data for each spatiotemporal 
# location. This data is also organized as a tibble, with a 
# column with the dates and the other columns with the values 
# for each spectral band.

data("samples_matogrosso_mod13q1", package = "sitsdata")
view(samples_matogrosso_mod13q1)

# Load the time series for MODIS samples for Mato Grosso

view(samples_matogrosso_mod13q1[1, ]$time_series[[1]])

summary(samples_matogrosso_mod13q1)

# select all samples with label "Forest"

samples_forest <- dplyr::filter(
  samples_matogrosso_mod13q1,
  label == "Forest"
)

view(samples_forest)

# select the NDVI band for all samples with label "Forest"

samples_forest_ndvi <- sits_select(
  samples_forest,
  band = "NDVI" # Entretanto, gera gráficos de todos os índices
)

view(samples_forest_ndvi)

plot(samples_forest_ndvi)

# Treinando um modelo de machine learning --------------------------------------------------------------------------------------------------

set.seed(03022024)

# Select the bands NDVI and EVI

samples_2bands <- sits_select(
  data = samples_matogrosso_mod13q1,
  bands = c("NDVI", "EVI")
)

view(samples_2bands)

# Train a random forest model

rf_model <- sits_train(
  samples = samples_2bands,
  ml_method = sits_rfor()
)

# Plot the most important variables of the model

# install.packages("randomForestExplainer")
library(randomForestExplainer)

plot(rf_model)

# Classificação do modelo de machine learning -------------------------------------------------------------------------------------------------------

# Após treinar o modelo de machine learning, o próximo passo
# é classificar o cubo de dados usando sits_classify().
# Essa função produz um conjunto de probabilidades de mapa
# raster, uma para cada classe. Para cada um desses mapas, o
# valor do pixel é proporcional a probabilidade que ele pertence
# a classe.

# Classify the raster image

sinop_probs <- sits_classify(
  data = sinop_cube,
  ml_model = rf_model,
  multicores = 2,
  memsize = 8,
  output_dir = "arquivos_pacote_sits"
)

class(sinop_probs)
view(sinop_probs)

# Plot the probability cube for class Forest

plot(sinop_probs, labels = "Forest", palette = "BuGn")

# Espacial smoothing -----------------------------------------------------------------------------------------------------------------------

# Quando se trabalha com grandes quantidades de dados de observação
# da terra, existe muita variabilidade em cada classe. Como resultado,
# alguns pixels podem ser classificados incorretamente. Para resolver
# esses problemas, sits_smooth() pega um cubo de probabilidades como input
# e usa as classes de probabilidades de cada vizinhança do pixel para 
# reduzir incertezas de classes. A plotagem do mapa de probabilidade suavizado
# para a classe forest mostra que a maioria dos valores discrepantes
# foram removidos.

# Perform spatial smoothing

sinop_bayes <- sits_smooth(
  cube = sinop_probs,
  multicores = 2,
  memsize = 8,
  output_dir = "arquivos_pacote_sits"
)

view(sinop_bayes)

plot(sinop_bayes, labels = "Forest", palette = "BuGn")
plot(sinop_bayes, labels = "Soy_Cotton", palette = "BuGn")

# Rotulando um cubo de dados de probabilidade ----------------------------------------------------------------------------------------------

# After removing outliers using local smoothing, the final 
# classification map can be obtained using sits_label_classification(). 
# This function assigns each pixel to the class with the highest 
# probability.

# Label the probability file

sinop_map <- sits_label_classification(
  cube = sinop_bayes,
  output_dir = "arquivos_pacote_sits"
)

view(sinop_map)

plot(sinop_map)

# Exercício --------------------------------------------------------------------------------------------------------------------------------

## Baixar pacotes

library(tibble)
library(sits)
library(sitsdata)

## Criar um cubo de dados

sits::sits_list_collections()

## Definir uma região de interesse

# Oeste, Sul, Leste, Norte
# -49.3667,-14.9694,-47.8105,-13.5454
# A latitude indica a distância norte ou sul do Equador
# a longitude mede a distância leste ou oeste do Meridiano de Greenwich

roi <- list(
  lon_min = -47.6000, lat_min = -14.2000,
  lon_max = -47.5000, lat_max = -14.1000
)

# roi <- c(
#   lon_min = -43.5526, lat_min = -2.9644,
#   lon_max = -42.5124, lat_max = -2.1671
# )

sinop_cube <- sits_cube(
  source = "BDC", # "AWS"
  collection = "MOD13Q1-6.1", # "SENTINEL-2-L2A"
  #tiles = "23MMU", # Quando define o roi, 
  # não precisa colocar o tile, pois o tile já 
  # é uma região definida.
  bands = c("NDVI", "EVI"), # "B02", "B8A", "B11"
  #data_dir = system.file("extdata/sinop", package = "sitsdata"),
  parse_info = c("satellite", "sensor", "tile", "band", "date"),
  roi = roi
)

view(sinop_cube)

# Mostrar dados de tempo do cubo

sits_timeline(sinop_cube)

## Criar mapa NDVI para primeira data

### NDVI 2013
plot(sinop_cube, 
  dates = "2013-05-25",
  band = "NDVI",
  palette = "RdYlGn"
)

### NDVI 2025
plot(sinop_cube, 
  dates = "2025-05-25",
  band = "NDVI",
  palette = "RdYlGn"
)

# Mostrar informações sobre os arquivos de imagens que são
# parte do cubo de dados

view(sinop_cube$file_info[[1]])

  
  
  
