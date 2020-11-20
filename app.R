#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
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
            addTiles(attribution = ' Osascoas ') %>%  
            setView(lng =  -46.7685951, lat = -23.5061744, zoom = 15)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

#rsconnect::deployApp(account = "chicodias")