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
    
    black_ave <- readRDS("black_ave.rds")
    gallagator <- readRDS("gallagator.rds")
    
    
    leaflet() %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFya2VnZ2UiLCJhIjoiY2lrb245YWh3MHhtMXV4a21ld2R5Ymh0ciJ9.i0E2OrjPHLVtIRpN82tU5w",
        # urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -111.0365, lat = 45.67, zoom = 13) %>%
      addPolylines(group = "Black Ave Bike Boulevard", layerId = "Black Ave Bike Boulevard", 
                   weight = 4,
                   popup = "Black Avenue Green Sharrow Lane",
                   opacity = .9,
                   color = "#66FF00", dashArray = "5",
                   data = black_ave) %>%
      addPolylines(group = "Gallagator", 
                   layerId = "Gallagator", 
                   popup = "Paved and Swept Gallagator Trail",
                   weight = 3, opacity = 0.9,
                   color = "#FF4040", dashArray = "4",
                   data = gallagator) %>%
      addPolylines(group = "Paths", popup = ~Name, layerId = ~Name, 
                   data = lines[!lines$Name %in% c("Black Avenue Green Sharrow Lane", "Concrete Pavement", 
                                                   "Concrete Pavement (Gallagator Mid)", "South Gallagator"), ]) %>%
      
      # c("Garfield Street Green Sharrows", "")
      addPolygons(group = "1 Mile Buffer", weight = 2, opacity = 0.8, fillOpacity = 0.0, 
                  color = "#68228B", 
                  dashArray = "4", 
                  options = pathOptions(clickable = FALSE),
                  data = buffer) %>%
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
    # leafletProxy("map") %>% addPopups(lng, lat, content)
  }
  
  # # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      if(event$id == FALSE)
        return()
      
      showDetails(event$id, event$lat, event$lng)
    })
  })
  
}