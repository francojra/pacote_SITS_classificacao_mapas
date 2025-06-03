# Carregando o pacote
library(sits)
library(sf)

# Define coordenadas (longitude e latitude) da ROI - exemplo: região amazônica
roi_bbox <- st_bbox(c(xmin = -54.0, xmax = -53.5, ymin = -3.0, ymax = -2.5), crs = st_crs(4326)) %>%
  st_as_sfc()

# Definindo o intervalo de tempo
time_range <- c("2020-06-01", "2020-09-30")

# Criando um cube de imagens Sentinel-2 diretamente da AWS
s2_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-2-L2A",
  roi = roi_bbox,
  bands = c("B04", "B08", "NDVI"),
  start_date = "2020-06-01",
  end_date = "2020-09-30",
  tile = "T21LYC",
  progress = TRUE
)

# Mostrando os metadados do cube
print(s2_cube)

# Criar amostras (para treinamento)
# Você pode ter um arquivo .csv com coordenadas e rótulos, mas aqui criamos aleatoriamente (exemplo educativo)
samples <- sits_select(
  data = s2_cube,
  samples = 100,
  labels = c("Forest", "Non-Forest")
)

# Treinar um modelo de classificação (Random Forest)
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
