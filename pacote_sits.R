# Instalação dos pacotes (se necessário)
# install.packages("sits")
# install.packages("sf")
# install.packages("raster")

# Carregar os pacotes necessários
library(sits)
library(sf)
library(raster)

# 1. Definir configurações iniciais
set.seed(1234)
sits_config(progress = FALSE)  # Configurações do SITS

# 2. Carregar dados de exemplo (substitua por seus próprios dados)
# Carregar dados de treinamento
sits::cerrado_2classes
sits::samples_modis_ndvi
data("cerrado_2classes")
samples <- cerrado_2classes
class(samples)
View(samples)

# 3. Pré-processamento dos dados
# Criar série temporal suavizada
ts_smoothed <- sits_smooth(
  data      = samples,
  times     = 3,
  window_size = 9,
  cube = "MOD13Q1",
  .bands    = c("NDVI", "EVI")
)

# Calcular índices adicionais (exemplo: NDVI)
ts_processed <- sits_apply(
  ts_smoothed,
  NDVI = (nir - red) / (nir + red)
)

# 4. Treinar o modelo
model <- sits_train(
  samples      = ts_processed,
  ml_method    = sits_rfor()  # Random Forest
)

# 5. Carregar dados de imagem para classificação (substitua por seu cubo de dados)
# Exemplo usando dados MODIS
data("modis_cube")
cube <- modis_cube

# 6. Classificação da imagem
probs_cube <- sits_classify(
  data       = cube,
  ml_model   = model,
  memsize    = 8,
  multicores = 2
)

# 7. Pós-processamento
# Suavização bayesiana
bayes_cube <- sits_smooth(
  probs_cube,
  type = "bayesian",
  window_size = 7
)

# 8. Gerar mapa final de classificação
classified_map <- sits_label_classification(
  bayes_cube,
  smoothing = "median",
  window_size = 5
)

# 9. Visualizar resultados
plot(classified_map, 
     title = "Mapa de Classificação de Uso e Cobertura do Solo",
     palette = "RdYlGn")

# 10. Validação (se houver dados de referência)
validation <- sits_kfold_validate(
  ts_processed,
  folds = 5,
  ml_method = sits_rfor()
)

sits_accuracy(validation)