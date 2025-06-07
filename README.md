# Pacote SITS - Séries Temporais e Classificação de uso e Cobertura do Solo 

#### Autoria do script: Jeanne Franco
#### Data: 23/05/25
#### Referência: https://e-sensing.github.io/sitsbook/introduction.html

## Conceitos

### Por que trabalhar com séries temporais de imagens de satélite?

Imageamento de satélite promove o mais extensivo dado sobre nosso ambiente. Ao abranger várias áreas da superfície da terra, as imagens permitem aos pesquisadores analisar transformações locais e globais. Ao observar o mesmo local em diferentes tempos, os satélites fornecem dados sobre mudanças ambientais e pesquisar áreas que são difíceis de observar do solo. Dado características únicas delas, as imagens oferecem essenciais informações para muitas aplicações, incluindo desmatamento, produção agrícola, segurança alimentar, áreas urbanas, escassez de água e degradação da terra. Usando séries temporais, especialistas melhoram o entendimento deles sobre processos e padrões ecológicos. Em vez de selecionar imagens individuais de datas específicas e compará-las, os pesquisadores rastreiam as mudanças continuamente.

### Tempo primeiro, espaço depois

“*Time-first, space-later*” é um conceito de classificação de imagem de satélite que toma análises de séries temporais como primeiro passo para analisar dados de sensoriamento remoto, com informação espacial sendo considerada após todas as séries de tempo serem classificadas. O tempo primeiro traz um melhor entendimento das mudanças nas paisagens. Detectar e rastrear tendências sazonais e de longo prazo torna-se viável, bem como identificar eventos anômalos ou padrões nos dados, como incêndios florestais, inundações, ou secas. Cada pixel em um cubo de dado é tratado como uma série temporal, usando informação disponível nas instâncias temporais do caso. Classificação de séries temporais é baseada em pixel, produzindo um conjunto de pixels rotulados. Esse resultado é então usado como input para o *space-later* do método. Nessa fase, um algoritmo de suavização (smoothing) melhor os resultados da classificação *Time-first* ao considerar a vizinhança espacial de cada pixel. O mapa resultante assim combina ambos informações espaciais e temporais.

### Cobertura e uso da terra

A Food and Agriculture Organization define cobertura da terra como "a cobertura biofísica observada sobre a superfície da terra". A cobertura da terra pode ser observada e mapeada diretamente através de imagens de sensoriamento remoto. Nas diretrizes e relatórios da FAO, uso da terra é descrita como "as atividades ou propósitos humanos para os quais a terra é gerida ou explorada". Apesar do "*uso da terra*" e "*cobertura da terra*" denotar diferentes abordagens para descrever a paisagem da terra, na prática existe considerável sobreposição entre esses conceitos. Ao classificar imagens de sensoriamento remoto, áreas naturais são classificadas usando tipos de cobertura da terra (ex.: floresta), enquanto áreas modificadas por humanos são descritas com uso de classes da terra (ex.: pasto).

Uma das vantagens de usar imagens de séries temporais para classificação da terra é a capacidade delas de medir mudanças na paisagem relacionadas a práticas de agricultura. Por exemplo, séries temporais de um índice de vegetação em uma área de produção agrícola mostrará um padrão de mínimos (estágios de plantio e semeadura) e máximos (estágio de floração). Assim, esquemas de classificação sobre imagens de dados de séries temporais pode ser mais rico e mais detalhado que aqueles associados apenas com cobertura da terra. A seguir, nós usamos o termo classificação da terra (*land classification*) para se referir a classificação da imagem representando ambos cobertura da terra e classes de uso da terra.


