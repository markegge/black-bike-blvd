library(leaflet)

navbarPage("Black Avenue Bicycle Corridor", id="nav",
      tabPanel("Map",
        div(class="outer",           
          tags$head(
            # Include our custom CSS
            includeCSS("styles.css")
          ),
          
          # If not using custom CSS, set height of leafletOutput to a number instead of percent
          leafletOutput("map", width="100%", height="100%"),
          
          # absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
          #               draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
          #               width = 330, height = "auto",
          #               
          #               h2("ZIP explorer"),
          #               
          #               conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
          #                                # Only prompt for threshold when coloring or sizing by superzip
          #                                numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
          #               )
          # ),
          
          tags$div(id="cite",
                   'Concept by Mark Egge'
                   #tags$em('Mark Egge')
          )
        )
      ),
      tabPanel("About",
               fluidRow(
                 column(6,
                        includeMarkdown("README.md")
                 ),
                 column(3,
                        img(class = "img-polaroid",
                            src = ("black_ave.png"), 
                            width = "500px"),
                        tags$small(
                          "Source: Google Street View"
                        )
                 )
               )
      )
)
