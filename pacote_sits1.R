# Carregar os pacotes necessários

library(sits)

# Carregando o pacote
library(sits)

# Definindo uma região de interesse (bbox) - exemplo: parte da Amazônia
roi <- tibble::tibble(
  longitude = c(-54.0, -53.5),
  latitude = c(-3.0, -2.5)
)

# Definindo o intervalo de tempo
time_range <- c("2020-06-01", "2020-09-30")

# Criando um cube de imagens Sentinel-2 diretamente da AWS
s2_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-2-L2A",
  roi = roi,
  bands = c("B04", "B08", "NDVI"),  # Red, NIR, NDVI
  start_date = time_range[1],
  end_date = time_range[2],
  tile = "T21LYC",
  label = NA,
  cloud_filter = 0.1,
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
