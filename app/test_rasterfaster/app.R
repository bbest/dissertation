# Run: shiny::runApp('~/github/dissertation/app/test_rasterfaster')
# Original: https://gist.github.com/jcheng5/a1c48a18d0ea3623c0e6
# Prerequisites:
# - devtools::install_github("jcheng5/rasterfaster")
# - devtools::install_github("rstudio/leaflet@raster")
# shiny::runApp('~/github/dissertation/app/test_rasterfaster')

library(shiny)
library(leaflet)
library(raster)
#library(rasterfaster)

# # get AddLegend() not in leaflet@raster -- requires evalFormula in layers.R
# devtools::source_url('https://raw.github.com/rstudio/leaflet/master/R/legend.R')
# devtools::source_url('https://raw.github.com/rstudio/leaflet/master/R/layers.R')
# devtools::source_url('https://raw.github.com/rstudio/leaflet/master/R/normalize.R')

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
      
      # add raster
      l <- l %>% addRaster(r, options = tileOptions(opacity = opacity, noWrap = TRUE, detectRetina = FALSE),
                           colorFunc = colorFunc)
      
#       # add legend
#       l <- l %>%
#         addLegend(
#           'bottomright', pal = colorFunc, values = seq(minValue(r), maxValue(r), 8),
#           title = 'Density (indiv/km2)',
#           labFormat = labelFormat(prefix = '')
#         )
      
      # show leaflet
      l
    })
  }
  
  shinyApp(ui, server, options = list(launch.browser = getOption("viewer", TRUE)))
}


# MUST be 1) .grd file, 2) with `numeric` data, and 3) in unprojected WGS84.
# If your raster is in a different file format, use writeRaster() to create
# a .grd version. Performance is quite insensitive to resolution/size, so
# provide the highest resolution data you can.
f <- 'v72zw_4326.grd' # tanker: v72zw, cruise: v72zc
p <- normalizePath(file.path('~/Google Drive/dissertation/data/bc', f), mustWork=F)
#p <- system.file(package='rasterfaster','sample.grd')
r <- raster(p)
#plot(r)

# Show the map
showRaster(r, TRUE)

