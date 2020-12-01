library(wordcloud)
library(tidyverse)
library(tm)
library(ggpubr)
library(readxl)
library(wordcloud2)
library(gridExtra)

# Leitura dos dados
df2 <- read_excel("quest.xlsx")

# Distribuicão de alunos por sala
df2 %>% ggplot() + geom_bar(aes(sala)) + theme_pubr() + ylab("número de alunos")

# Distribuicão de gênero
df2 %>% ggplot() + geom_bar(aes(gênero)) + theme_pubr() 

# Colapsando os bairros em seis categorias
df2$bairro <- gsub("Vila Menk","Vila Menck",df2$bairro) %>% as_factor() %>%  fct_lump(4,other_level = "Outros") 

# Numero de alunos por bairro

value <- fct_count(df2$bairro, sort = T, prop = T)
ggplot(value, aes(f, n)) +  
  geom_bar(position="dodge", stat="identity", color="black") +
  geom_text(aes(x=f, y=n, label = scales::percent(p), hjust=-.2), position = position_dodge(width=0.9)) +
  coord_flip() + theme_pubr()




# Total de pontos positivos
pontos <- c(df2$pontos1,df2$positivos2,df2$positivos3)

# Categorias dos pontos positivos mencionados
p <- tibble(x = pontos) %>% filter(x != 0)

p %>% ggplot +geom_bar (aes(x)) + coord_flip() + 
  scale_x_discrete(limits = c("5", "4", "3", 
                              "2", "1"),
                   labels = c("Lugares para exercícios físicos,\n Praças e áreas verdes", "Pontos \ncomerciais",  "Rede de acolhimento \ne proteção", "Características \nidentificadas", 
                              "Equipamentos \nPúblicos")) + theme_pubr() + xlab(" ") + ylab("Menções")


#grid.arrange(q,r,ncol=2)
# vamos concatenar os pontos elencados pelos alunos, pre processar e 
# exibir a wordcloud

positivos <- c(df2$positivo1,df2$positivo2,df2$positivo3)

negativos <- c(df2$negativo1,df2$negativo2,df2$negativo3)


# Funcao de pre-processamento textual
prepros <- function(corpus){
# juntar todas as repostas
#  docs <- paste(corpus, collapse = " ")
  docs <- corpus
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

# remove palavras similares
  docs <- tm_map(docs, stemDocument)

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

c <-TermDocumentMatrix(negativos)
# encontrar quais as palavras do texto estão associadas com "best"
faa <- findAssocs(c, terms = c("falta","rua","ruas"), corlimit = 0.14)

#faa <- findAssocs(TDF(positivos), terms = c("praça","casa","parque"), corlimit = 0.14)

cors <- tibble(Palavra = names(faa$falta),Frequência = as.numeric(faa$falta))


ggdotchart(dfm, x = "name", y = "mpg",
           color = "cyl",                                # Color by groups
           palette = c("#00AFBB", "#E7B800", "#FC4E07"), # Custom color palette
           sorting = "descending",                       # Sort value in descending order
           add = "segments",                             # Add segments from y = 0 to dots
           rotate = TRUE,                                # Rotate vertically
           group = "cyl",                                # Order by groups
           dot.size = 6,                                 # Large dot size
           label = round(dfm$mpg),                        # Add mpg values as dot labels
           font.label = list(color = "white", size = 9, 
                             vjust = 0.5),               # Adjust label parameters
           ggtheme = theme_pubr()                        # ggplot2 theme
)


cors %>%  ggdotchart("Palavra", "Frequência", 
                     sorting = "descending",                       # Sort value in descending order
                     label = scales::percent(cors$Frequência,accuracy = 1),
                     font.label = list(color = "#eeeeee", size = 9, 
                                       vjust = 0.5),
                     #add = "segments",
                     dot.size = 8, 
                     color = "#222222",
                     rotate = TRUE,                                # Rotate vertically
                                                    # Large dot size
                     
                     ggtheme = theme_pubr()                        # ggplot2 theme
)+
  theme_cleveland()+
  ggtitle("Falta...")
