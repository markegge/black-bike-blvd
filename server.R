library(leaflet)
library(RColorBrewer)
library(scales)
library(jsonlite)

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    # lines <- readLines("lines.geojson") %>% # warm = FALSE)
    #   paste(collapse = "\n") %>%
    #   fromJSON(simplifyVector = FALSE)
    lines <- readRDS("lines.rds")
    points <- read.csv("points.csv", stringsAsFactors = FALSE)
    
    buffer <- readRDS("buffer.rds")
    # green dashes for shared lane
    
    leaflet() %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFya2VnZ2UiLCJhIjoiY2lrb245YWh3MHhtMXV4a21ld2R5Ymh0ciJ9.i0E2OrjPHLVtIRpN82tU5w",
        # urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -111.0365, lat = 45.67, zoom = 13) %>%
      addPolygons(group = "1 Mile Buffer", weight = 3, opacity = 0.9, fillOpacity = 0.1, 
                  color = "orange", 
                  dashArray = "4", data = buffer) %>%
      addPolylines(group = "Paths", popup = ~Name, layerId = ~Name, data = lines) %>%
      addMarkers(group = "Intersections", popup = ~Name, 
                 icon = ~makeIcon(iconUrl = paste0("icons/", Icon),
                                  iconAnchorX = 12,
                                  iconAnchorY = 12),
                 data = points) %>%
      addLayersControl(
        overlayGroups = c("Paths", "Intersections", "1 Mile Buffer"),
        options = layersControlOptions(collapsed = FALSE),
        position = "bottomleft"
      )

  })
  

  # Show a popup at the given location
  showDetails <- function(id, lat, lng) {
    print(id)
    selected <- lines[lines$Name == id, ]
    content <- as.character(tagList(
      tags$h2(selected$Name),
      tags$h4("Cost:", scales::dollar(as.integer(selected$Estimate))),
      tags$p(selected$Descript)
      # tags$strong(HTML(sprintf("%s, %s %s",
      #                          selectedZip$city.x, selectedZip$state.x, selectedZip$zipcode
      # ))), tags$br(),
      # sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
      # sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
      # sprintf("Adult population: %s", selectedZip$adultpop)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showDetails(event$id, event$lat, event$lng)
    })
  })
  
}