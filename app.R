#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
library(shiny)
library(leaflet)
# Read the data
source("leitura_dados.R")

# Define UI for application that draws a map
ui <- fluidPage(

    navbarPage("Mapa", id="nav",
               tabPanel("Mapa Interativo",
                        div(class="outer",
                            tags$head(
                                #Include our custom CSS
                                includeCSS("styles.css"),
                                #includeScript("gomap.js")
                            ),
                            
                            leafletOutput("map", width="100%", height="100%"),
                            absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                          draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                          width = 330, height = "auto",
                                          
                                          h2("Mapa de pontos de interesse dos alunos em Osasco(SP)"),
                                          )
        )

               )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    ## Interactive Map ###########################################
    
    # Create the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles(attribution = ' Osasco ') %>%  
            setView(lng =  -46.7685951, lat = -23.5061744, zoom = 15)
    })
    
    
    # This observer is responsible for maintaining the circles and legend,
    # according to the variables the user has chosen to map to color and size.
    observe({
        
        getColor <- function(df) {
            sapply(df$tipo, function(tipo) {
                if(tipo == "DESGASTE_SAUDE") {
                    "green"
                } else if(tipo == "TRABALHO") {
                    "orange"
                } else {
                    "red"
                } })
        }
        
        icons <- awesomeIcons(
            icon = 'ios-close',
            iconColor = 'black',
            library = 'ion',
            markerColor = getColor(df)
        )
        
        
        
        leafletProxy("map", data = df) %>% 
            clearMarkers() %>% 
            addAwesomeMarkers(~Longitude, ~Latitude, label = ~Nome, icon = icons) %>% 
            addLegend("bottomright",labels = levels(df$tipo), colors = c("red", "green", "orange" ))
        
    })
    
    
    #funcao que mostra a cidade clicada
     showPopup <- function(lat, lng) {
      selectedZip <- df %>% filter(Latitude == lat & Longitude == lng)
       content <- as.character(tagList(
         tags$h4(HTML(sprintf("%s",
                              selectedZip$Nome
         ))),
         sprintf("Endereco: %s", selectedZip$ENDERECO),tags$br(),
         sprintf("Ocorrência: %s", selectedZip$OCORRENCIA),tags$br()
       ))
       
       leafletProxy("map") %>% addPopups(lng, lat, content)

     }
    
    
    
    #observador que mostra a cidade clicada
    observe({
       leafletProxy("map") %>% clearPopups()
       event <- input$map_marker_click
       if (is.null(event))
         return()
       isolate({
         showPopup(event$lat, event$lng)
         
       })
     })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

#rsconnect::deployApp(account = "chicodias")