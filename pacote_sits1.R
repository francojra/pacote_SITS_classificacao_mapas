# Carregando o pacote
library(sits)
library(sf)
library(gdalcubes)

# Define coordenadas (longitude e latitude) da ROI - exemplo: região amazônica
roi_bbox <- st_bbox(c(xmin = -54.0, xmax = -53.5, ymin = -3.0, ymax = -2.5), crs = st_crs(4326)) %>%
  st_as_sfc()

# Definindo o intervalo de tempo
time_range <- c("2020-06-01", "2020-09-30")

# Verificar coleções e bandas 
sits_list_collections()

# Criando um cube de imagens Sentinel-2 diretamente da AWS
s2_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-2-L2A",
  roi = roi_bbox,
  bands = c("B04", "B08", "B06"),
  start_date = "2020-06-01",
  end_date = "2020-09-30",
  tile = "T21LYC",
  progress = TRUE
)

# Mostrando os metadados do cube
print(s2_cube)
View(s2_cube)

# Regularizando o cube (etapa obrigatória)
s2_cube <- sits_regularize(
  cube = s2_cube,
  period = "P16D",
  res = 10,
  snap = "near",
  output_dir = "regularized_cube"  # pasta onde arquivos regulares serão salvos
)

# Criar amostras (para treinamento)
# Você pode ter um arquivo .csv com coordenadas e rótulos, mas aqui criamos aleatoriamente (exemplo educativo)
samples_tbl <- tibble::tibble(
  longitude = c(-53.8, -53.7),
  latitude = c(-2.9, -2.7),
  start_date = "2020-06-01",
  end_date = "2020-09-30",
  label = c("Forest", "Non-Forest")
)

# Criar amostras com os dados do cube
samples <- sits_get_data(cube = s2_cube, samples = samples_tbl)

# Treinar modelo
model <- sits_train(samples, ml_method = sits_rfor())

# Classificação da área
classified_cube <- sits_classify(data = s2_cube, ml_model = model)

# Suavização opcional para reduzir ruído
smoothed_cube <- sits_smooth(classified_cube)

# Gerar o mapa de classificação final (primeira data)
sits_export(
  data = smoothed_cube,
  format = "GTiff",
  filename = "classified_map.tif"
)

# Visualizar resultado
plot(smoothed_cube)
