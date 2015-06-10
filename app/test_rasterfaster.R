# https://gist.github.com/jcheng5/a1c48a18d0ea3623c0e6
# Prerequisites:
# devtools::install_github("jcheng5/rasterfaster")
# devtools::install_github("rstudio/leaflet@raster")

library(shiny)
library(leaflet)

showRaster <- function(r, defaultTiles = TRUE, colorFunc = colorBin("RdBu", c(minValue(r), maxValue(r)), 8)) {
  if (!inherits(r, "RasterLayer")) {
    stop("showRaster only works with raster layers")
  }
  if (!identical(r@file@driver, "raster")) {
    stop("showRaster only works with .grd files")
  }
  
  ui <- tagList(
    tags$head(tags$style(type="text/css",
                         "html, body { width: 100%; height: 100%; padding: 0; margin: 0; }"
    )),
    leafletOutput("map", width = "100%", height = "100%")
  )
  
  server <- function(input, output, session) {
    output$map <- renderLeaflet({
      
      l <- leaflet() %>% setView(0, 0, zoom = 1)
      
      opacity <- 1
      if (defaultTiles) {
        l <- l %>% addTiles(options = tileOptions(noWrap = TRUE))
        opacity <- 0.5
      }
      
      l <- l %>% addRaster(r, options = tileOptions(opacity = opacity, noWrap = TRUE, detectRetina = FALSE),
                           colorFunc = colorFunc)
      
      l
    })
  }
  
  shinyApp(ui, server, options = list(launch.browser = getOption("viewer", TRUE)))
}


# MUST be 1) .grd file, 2) with `numeric` data, and 3) in unprojected WGS84.
# If your raster is in a different file format, use writeRaster() to create
# a .grd version. Performance is quite insensitive to resolution/size, so
# provide the highest resolution data you can.
p <- '~/Google Drive/dissertation/data/bc/cost_v72zc.grd'
r <- raster::raster(p)

# Show the map
showRaster(r, TRUE)