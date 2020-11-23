library(wordcloud)
library(tidyverse)
library(ggpubr)

# Leitura dos dados
df2 <- read_excel("quest.xlsx")

# Distribuicão de alunos por sala
df2 %>% ggplot() + geom_bar(aes(sala)) + theme_pubr() + ylab("número de alunos")

# Distribuicão de gênero
df2 %>% ggplot() + geom_bar(aes(gênero)) + theme_pubr() 

# Colapsando os bairros em seis categorias
df2$bairro <- df2$bairro %>% as_factor() %>%  fct_lump(5)

# Numero de alunos por bairro
df2 %>% ggplot() + geom_bar(aes(bairro)) + theme_pubr() +  ylab("número de alunos")

# Total de pontos positivos
pontos <- c(df2$pontos1,df2$positivos2,df2$positivos3)

# Categorias dos pontos positivos mencionados
table(pontos)


# vamos concatenar os pontos elencados pelos alunos, pre processar e 
# exibir a wordcloud

positivos <- c(df2$positivo1,df2$positivo2,df2$positivo3)

negativos <- c(df2$negativo1,df2$negativo2,df2$negativo3)


# Funcao de pre-processamento textual
prepros <- function(corpus){
# juntar todas as repostas
  docs <- paste(corpus, collapse = " ")

# trata como um corpus
  docs <- Corpus(VectorSource(docs))

# converter o texto para letras minúsculas
  docs <- tm_map(docs, content_transformer(tolower))

# remover pontuação
  docs <- tm_map(docs, removePunctuation)

# remover espaços em branco extras
  docs <- tm_map(docs, stripWhitespace)

# remover os números
  docs <- tm_map(docs, removeNumbers)

# remover palavras que devem ser desconsideradas 
#docs <- tm_map(docs, removeWords, c("minha", "hotel", "room", "rooms",
#                                    "etc")) 

# remover palavras comuns (stopwords) em portugues
  docs <- tm_map(docs, removeWords, stopwords("pt-br"))

  return(docs)
}

positivos <- prepros(positivos)
negativos <- prepros(negativos)

# Funcao que calcula a matriz de frequencia para as palavras do corpus
TDF <- function(corpus){
dtm <- TermDocumentMatrix(corpus)

m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

return(d)
}

# wordclouds de aspectos positivos e negativos
wordcloud2(TDF(positivos))

wordcloud2(TDF(negativos))


