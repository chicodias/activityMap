# Mapa da Atividade - Osasco(SP)

Este repositório contém o  código em linguagem *R*, implementado com auxílio das biblitecas *shiny* e *leaflet*, de um site interativo de um mapa da cidade de Osasco - SP, com pontos de interesse elencados através de um questionário aplicado alunos da E.E. Prof. Alcyr de Oliveira Ponciúncula, na disciplina de Sociologia.

Nosso objetivo é a criação de um *Recurso Educacional Aberto*(REA) que possa mapear diferentes pontos de interesse. Nesse caso, recebemos um conjunto de dados com o mapeamento geografico de pontos de interesse em Osasco(SP), classificados como **positivos** ou **negativos** pelos alunos.

Um pré processamento inicial do dados envolveu classificar esses locais em cinco categorias - -, assim como registrar sua respectiva latitude e longitude, para que um paradigma de representação visual pudesse ser adotado - aqui, utilizaremos as coordenadas geográficas dos pontos para representá-los num cartograma e exibir interativamente algumas informações, tais como:

A aplicação encontra-se disponível em: <https://chicodias.shinyapps.io/activitymap/>.

## Implementação

O arquivo `dados.xlsx` contém o questionário aplicado aos alunos. O arquivo `app.r` contém o código da aplicação em *shiny* responsável por gerar o site. Nele, utilizamos a biblioteca *leaflet* para renderizar o mapa e plotar os pontos de interesse, e também carregamos informações sobre o município a partir da biblioteca *brazilmaps*.