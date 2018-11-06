library(leaflet)

# navbarPage("Black Avenue Bicycle Corridor", id="nav",
#       tabPanel("Map",

fluidPage(
  fluidRow(
    # column(3,
    #       img(class = "img-polaroid",
    #           src = ("black_ave.png"), 
    #           width = "500px"),
    #       tags$small(
    #         "Source: Google Street View"
    #       )
    # )

    column(width = 8,
           class = "affix",
          # div(class="outer",
          #   tags$head(
          #     # Include our custom CSS
          #     includeCSS("styles.css")
          #   ),
          tags$style(type = "text/css", "#map {height: calc(100vh) !important; width: 100%;}"),
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
          leafletOutput("map", width="100%", height="100%"),
        
      
          tags$div(id="cite",
                 'Concept by Mark Egge'
                 #tags$em('Mark Egge')
          )
        ),
    column(width = 4,
           offset = 8,
           includeMarkdown("README.md")
    )
  )
)


