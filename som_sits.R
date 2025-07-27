# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 24/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

#  Self-organized maps for sample quality control - Capítulo 14 ----------------------------------------------------------------------------

# Configurations to run this chapter -------------------------------------------------------------------------------------------------------

library(tibble)
library(sits)
library(sitsdata)
library(kohonen)

# set tempdir if it does not exist 
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

# Take only the NDVI and EVI bands
samples_cerrado_mod13q1_2bands <- sits_select(
    data = samples_cerrado_mod13q1, 
    bands = c("NDVI", "EVI"))

# Show the summary of the samples
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

# Plot the SOM map
plot(som_cluster)

# A grade SOM mostra que a maioria das classes está associada a neurônios próximos umas das outras, 
# embora haja exceções. Alguns neurônios de Pastagem estão distantes do cluster principal porque 
# a transição entre áreas de savana aberta e pastagem nem sempre é bem definida e depende do clima 
# e da latitude. Além disso, os neurônios associados a Soy_Fallow estão dispersos no mapa, indicando 
# possíveis problemas na distinção desta classe das demais classes agrícolas. O mapa SOM pode ser 
# usado para remover outliers, como mostrado abaixo.












