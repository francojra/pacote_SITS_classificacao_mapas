# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 23/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

# Temporal reduction operations ------------------------------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)

#  Introduction ----------------------------------------------------------------------------------------------------------------------------

## Existem casos quando usuários quer produzir resultados os
## valores de uma série temporal associados a cada pixel de 
## um cubo de dados usando operações de redução. No contexto de
## análises de séries temporais, um operador de redução é uma
## função que reduz uma sequência de pontos de dados em um simples
## valor ou em um menor conjunto de valores. Esse processo envolve
## resumir ou agregar as informações de uma série temporal de forma
## significativa. Operadores de redução são frequentemente usados
## para extrair estatísticas chaves ou características de um dado,
## tornando ele mais fácil para analisar e interpretar.

# Exemplo ----------------------------------------------------------------------------------------------------------------------------------

# Define a region of interest to be enclosed in the data cube
roi <- c(
    "lon_min" = -55.80259, 
    "lon_max" = -55.199, 
    "lat_min" = -11.80208, 
    "lat_max" = -11.49583
)

# Define a data cube in the MPC repository using NDVI MODIS data
ndvi_cube <- sits_cube(
    source = "MPC",
    collection  = "MOD13Q1-6.1",
    bands = c("NDVI"),
    roi = roi,
    start_date =  "2018-05-01",
    end_date = "2018-09-30"
)

tempdir_r1 <- "arquivos_sits1" # Nome da pasta
dir.create(tempdir_r1, showWarnings = FALSE, 
           recursive = TRUE)

# Copy the cube to a local file system
ndvi_cube_local <- sits_cube_copy(
    cube = ndvi_cube,
    output_dir = tempdir_r1,
    multicores = 4
)

## Após criar um cubo de dados local sobre os conteúdos do cubo
## MPC MODIS com a banda NDVI, nós podemos calcular os valores
## máximos de NDVI para cada pixel das imagens durante o período
## de 01-05-2018 a 30-09-2018.

# create a local directory to store the result of the operation
tempdir_r_ndvi_max <- file.path(tempdir_r1, "ndvi_max")
dir.create(tempdir_r_ndvi_max, showWarnings = FALSE)

# Calculate the NBR index
max_ndvi_cube <- sits_reduce(ndvi_cube_local,
    NDVIMAX = t_max(NDVI), # t_max() é um operador de redução
    output_dir = tempdir_r_ndvi_max,
    multicores = 4,
    progress = TRUE
)

plot(max_ndvi_cube, band = "NDVIMAX")
plot(ndvi_cube, band = "NDVI")
