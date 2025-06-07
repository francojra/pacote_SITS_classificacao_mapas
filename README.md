# Pacote SITS - Séries Temporais e Classificação de uso e Cobertura do Solo 

#### Autoria do script: Jeanne Franco
#### Data: 23/05/25

### Por que trabalhar com séries temporais de imagens de satélite?

Imageamento de satélite promove o mais extensivo dado sobre nosso ambiente. Ao abranger várias áreas da superfície da terra, as imagens permitem aos pesquisadores analisar transformações locais e globais. Ao observar o mesmo local em diferentes tempos, os satélites fornecem dados sobre mudanças ambientais e pesquisar áreas que são difíceis de observar do solo. Dado características únicas delas, as imagens oferecem essenciais informações para muitas aplicações, incluindo desmatamento, produção agrícola, segurança alimentar, áreas urbanas, escassez de água e degradação da terra. Usando séries temporais, especialistas melhoram o entendimento deles sobre processos e padrões ecológicos. Em vez de selecionar imagens individuais de datas específicas e compará-las, os pesquisadores rastreiam as mudanças continuamente.

### Tempo primeiro, espaço depois

“*Time-first, space-later*” é um conceito de classificação de imagem de satélite que toma análises de séries temporais como primeiro passo para analisar dados de sensoriamento remoto, com informação espacial sendo considerada após todas as séries de tempo serem classificadas. O tempo primeiro traz um melhor entendimento das mudanças nas paisagens. Detectar e rastrear tendências sazonais e de longo prazo torna-se viável, bem como identificar eventos anômalos ou padrões nos dados, como incêndios florestais, inundações, ou secas. Cada pixel em um cubo de dado é tratado como uma série temporal, usando informação disponível nas instâncias temporais do caso. Classificação de séries temporais é baseada em pixel, produzindo um conjunto de pixels rotulados. Esse resultado é então usado como input para o *space-later* do método. Nessa fase, um algoritmo de suavização (smoothing) melhor os resultados da classificação *Time-first* ao considerar a vizinhança espacial de cada pixel. O mapa resultante assim combina ambos informações espaciais e temporais.


