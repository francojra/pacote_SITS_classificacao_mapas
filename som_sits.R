# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 25/07/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

#  Self-organized maps for sample quality control - Capítulo 14 ----------------------------------------------------------------------------

# Configurations to run this chapter -------------------------------------------------------------------------------------------------------

library(tibble) # Pacote para exibir dados em formato tibble
library(sits) # Pacote para executar as funções do sits
library(sitsdata) # Pacote para vissualizar séries temporais de amostras
library(kohonen) # Pacote para executar o mapa SOM

# Estabelecer um diretório, caso ele não exista

tempdir_r <- "ts_som"
dir.create(tempdir_r, showWarnings = FALSE)

# Introdução -------------------------------------------------------------------------------------------------------------------------------

# O pacote sits promove uma técnica de clusterização baseada em self-organizing maps (SOM)
# como uma alternativa a clusterização hierárquica para controle de qualidade do treinamento
# das amostras. O SOM é uma técnica de redução da dimensionalidade, onde dados de alta dimensão
# são mapeados em um mapa de duas dimensões, mantendo as relações topológicas entre os padrões
# de dados. O mapa SOM em 2D é composto de unidades chamadas neurônios. Cada neurônio tem um
# vetor de peso com a mesma dimensão das amostras de treinamento. No início, os neurônios 
# recebem um pequeno valor aleatório e depois são treinados por aprendizado competitivo. O
# algoritmo calcula as distâncias de cada membro do conjunto de treinamento para todos os
# neurônios e encontra o neurônio mais próximo da entrada, chamado de melhor unidade correspondente.

# Os dados de entrada para avaliação da qualidade é um conjunto de amostras de treinamento, os
# quais são dados de alta dimensionalidade; por exemplo, uma série temporal com 25 instâncias
# de 4 bandas espectrais tem 100 dimensões. Ao projetar um conjunto de dados de alta dimensão 
# em um mapa SOM 2D, as unidades do mapa (chamadas neurônios) competem por cada amostra. Cada
# série temporal irá ser mapeada para um dos neurônios. Como o número de neurônios é menor que
# o número de classes, cada neurônio irá ser associado com muitas séries temporais. O resultado
# do mapa 2D irá ser um conjunto de clusters. Considerando que o SOM preserva a estrutura 
# topológica de vizinhança em múltiplas dimensões, clusters que contêm amostras treinadas com
# um dado rótulo geralmente serão vizinhos no espaço 2D. Os vizinhos de cada neurônio do mapa
# SOM promove informação sobre a variabilidade interclasse e intraclasse, que é usada para
# detectar ruídos das amostras. 

# Selecionar conjunto de dados e bandas ----------------------------------------------------------------------------------------------------

# Extraindo apenas as bandas NDVI e EVI

samples_cerrado_mod13q1_2bands <- sits_select(
    data = samples_cerrado_mod13q1, 
    bands = c("NDVI", "EVI"))

# Mostrar o resumo das amostras

summary(samples_cerrado_mod13q1_2bands)

# Criando o mapa SOM -----------------------------------------------------------------------------------------------------------------------

# Clustering time series using SOM
som_cluster <- sits_som_map(samples_cerrado_mod13q1_2bands,
    grid_xdim = 15, # Tamanho da grade no eixo x
    grid_ydim = 15, # Tamanho da grade no eixo y
    alpha = 1.0, # Taxa de aprendizagem inicial
    distance = "dtw", # ou "euclidean", mede a similaridade entre sequências temporais
    rlen = 20 # Número de iterações
)

view(som_cluster$data)
view(som_cluster$labelled_neurons)

# Salvar tabela do SOM ---------------------------------------------------------------------------------------------------------------------

class(som_cluster$data)

tab_som_cluster <- som_cluster$data

saveRDS(tab_som_cluster, "tab_som_cluster.rds")
tab <- readRDS("tab_som_cluster.rds")
view(tab)

# Sugerimos o uso da métrica de Distorção Temporal Dinâmica (“dtw”) como medida de di
# stância. Trata-se de uma técnica utilizada para medir a similaridade entre duas sequências 
# temporais que podem variar em velocidade ou tempo. A ideia central da DTW é encontrar 
# o alinhamento ideal entre duas sequências, permitindo o mapeamento não linear de uma sequência 
# sobre a outra. Na análise de séries temporais, a DTW combina duas séries ligeiramente fora 
# de sincronia. Essa propriedade é útil em estudos de uso do solo para combinar séries temporais 
# de áreas agrícolas.

# Resultados do sits_som_map(): a) conjunto original de dados com duas adicionais colunas para cada
# série de tempo: id_sample (o original id de cada amostra) e id_neuron (o id do neurônio a qual
# ele pertence). O b) labelled_neurons, um tibble com informações sobre os neurônios. Para cada neurônio
# ele informa as probabilidades a priori e posteriori de todos os rótulos que ocorrem nas amostras;
# e c) o SOM grid. Os neurônios são rotulados por votação majoritária.

# Plotar o mapa SOM 

plot(som_cluster)

# A grade SOM mostra que a maioria das classes está associada a neurônios próximos umas das outras, 
# embora haja exceções. Alguns neurônios de Pastagem estão distantes do cluster principal porque 
# a transição entre áreas de savana aberta e pastagem nem sempre é bem definida e depende do clima 
# e da latitude. Além disso, os neurônios associados a Soy_Fallow estão dispersos no mapa, indicando 
# possíveis problemas na distinção desta classe das demais classes agrícolas. O mapa SOM pode ser 
# usado para remover outliers, como mostrado abaixo.

# Medindo a confusão entre rótulos usando o SOM --------------------------------------------------------------------------------------------

# O segundo passo na avaliação de qualidade baseada em SOM é entender a confusão entre rótulos.
# A função sits_som_evaluate_cluster() agrupa neurônios por seu rótulo majoritário e produz um tibble. 
# Os neurônios são agrupados em clusters, e haverá tantos clusters quantos forem os rótulos.
# Os resultados mostram a porcentagem de amostras de cada rótulo em cada cluster. Idealmente, 
# todas as amostras de cada cluster teriam o mesmo rótulo. Na prática, os clusters contêm amostras 
# com rótulos diferentes. Essa informação ajuda a medir a confusão entre as amostras.

# Produzir uma tibble com o resumo da mistura dos rótulos

som_eval <- sits_som_evaluate_cluster(som_cluster)

# Mostrar o resultado

print(som_eval, n = 81) 

# Muitos rótulos estão associados a clusters onde há algumas amostras com rótulos diferentes. 
# Essa confusão entre rótulos surge porque a rotulagem de amostras é subjetiva e pode ser tendenciosa. 
# Em muitos casos, os intérpretes usam dados de alta resolução para identificar amostras.
# Em nosso estudo de caso, uma imagem MOD13Q1 possui pixels com resolução de 250 m. Portanto, a 
# correspondência entre os locais rotulados em imagens de alta resolução e imagens de média a baixa 
# resolução não é direta.

# A confusão por rótulo de amostra pode ser visualizada em um gráfico de barras usando plot(), 
# como mostrado abaixo. O gráfico de barras mostra alguma confusão entre os rótulos associados à 
# vegetação natural típica do Cerrado brasileiro (Savana, Parque de Savana, Savana Rochosa).

graf <- plot(som_eval) 

library(ggplot2)

ggplot(som_eval, aes(x = mixture_percentage, y = class, fill = cluster)) +
  geom_col(position = "fill") +
  scale_fill_brewer(type = "div", palette = "Paired") 

# Essa mistura se deve à grande variabilidade da vegetação natural do bioma Cerrado, 
# o que dificulta o traçado de limites nítidos entre as classes.
# Também é visível alguma confusão entre as classes agrícolas. A classe Fallow_Cotton é 
# particularmente difícil, visto que muitas das amostras atribuídas a esta classe são 
# confundidas com Soy_Cotton e Millet_Cotton.

# Detectando o ruído das amostras usando SOM -----------------------------------------------------------------------------------------------

# A terceira etapa na avaliação da qualidade usa a distribuição de probabilidade discreta 
# associada a cada neurônio, que está incluída no tibble labeled_neurons produzido por 
# sits_som_map().

view(som_cluster$labelled_neurons)

#  O algoritmo calcula dois valores para cada amostra:

# - Probabilidade a priori: a probabilidade de que o rótulo atribuído à amostra esteja correto, 
# considerando a frequência de amostras no mesmo neurônio. Por exemplo, se um neurônio possui 
# 20 amostras, das quais 15 são rotuladas como Pasto e 5 como Floresta, todas as amostras 
# rotuladas como Floresta recebem uma probabilidade a priori de 25%. Isso indica que as amostras 
# de Floresta nesse neurônio podem não ser de boa qualidade.

# - Probabilidade posterior: a probabilidade de que o rótulo atribuído à amostra esteja correto,
# considerando os neurônios vizinhos. Considere o caso do neurônio mencionado acima, cujas 
# amostras rotuladas como Pasto têm uma probabilidade anterior de 75%. O que acontece se todos 
# os neurônios vizinhos tiverem Floresta como rótulo majoritário? Para responder a essa pergunta, 
# usamos inferência bayesiana para estimar se essas amostras são ruidosas com base nos neurônios 
# circundantes.
