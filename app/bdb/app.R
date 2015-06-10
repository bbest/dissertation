# two panel interactive plot:
# - left: tradeoff chart to click on tradeoff
# - right: 
#
# TODO:
# - cleanup, checkin, upload to server, email
# - table: highlight row with table
# - select alternate points to route (need time progressed), see
#   https://rstudio.github.io/leaflet/shiny.html#inputsevents
#   http://stackoverflow.com/questions/28938642/marker-mouse-click-event-in-r-leaflet-for-shiny
# - try cells as polygons

library(dplyr)
library(sp)
library(rgdal)
library(raster)
library(gdistance)
library(shiny)
library(shinyjs)   # devtools::install_github("daattali/shinyjs")
show = sp::show
library(leaflet)   # devtools::install_github("rstudio/leaflet@joe/feature/raster-image")
#library(DT)       # devtools::install_github("rstudio/DT")
library(ggvis)     # devtools::install_github("rstudio/ggvis") # https://github.com/rstudio/ggvis/pull/381
library(markdown)

# params
epsg4326 <- "+proj=longlat +datum=WGS84 +no_defs"
epsg3857 <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs"
load_rdata = T

# paths
app_dir = '~/github/dissertation/app/bdb'
rdata = '~/Google Drive/dissertation/data/routing/demo.Rdata'
grd = '~/Google Drive/dissertation/data/bc/v72zw_epsg3857.grd'

# read in raster ----
r = raster(grd)

# create points -----
pts = read.csv(
  text = '
  name, x, y
  Port Kitimat, -14323291, 7171167
  S of Haida Gwaii, -14580291, 6780167')
  # Port Kitimat (http://www.kitimat.ca/EN/main/business/invest-in-kitimat/port-of-kitimat.html)

# project pts from web mercator to gcs
pts_mer = pts
coordinates(pts_mer) = c('x', 'y')
proj4string(pts_mer) <- epsg3857
pts_gcs = spTransform(pts_mer, crs(epsg4326))
pts = pts %>%
  cbind(
    coordinates(pts_gcs) %>%
    as.data.frame() %>%
      dplyr::select(lon=x, lat=y))

# default transform for d data.frame
d_transform = 'x * 10'
  
# routes: load or get shortestPath
if (load_rdata){
  stopifnot(file.exists(rdata))
  load(rdata)
  stopifnot(exists(c('routes')))
} else {
  
  # normalize cost surface
  x = (r / cellStats(r,'max'))

  # ones map for getting linear path
  r1 = r
  r1[!is.na(r)] = 1

  # transformations to apply to species cost resistance raster
  transforms = c(
    'x * 0', 'x * 0.1', 'x * 0.5', 'x * 1', 
    'x * 10', 'x * 100', 'x * 1000', 'x * 10000', 
    'x^2', '(x*10)^2', '(x*100)^2', 'x^3')
  
  routes = list()
  for (i in 1:length(transforms)){ # i=8

    # apply transform to raster
    xt = eval(parse(text=transforms[i]))
    
    # calculate shortest path
    rt = shortestPath(
      # TODO: think of m_vals as transforms: x * 100, x^2, s
      geoCorrection(transition(1 / (r1 + xt), mean, directions=8), type="c"), 
      coordinates(pts_mer)[1,],
      coordinates(pts_mer)[2,],
      output='SpatialLines')
    
    # input to list with gcs projection, cost and distance
    routes = append(routes, list(list(
      transform = transforms[i],
      route_gcs = spTransform(rt, crs(epsg4326)),
      cost_x = sum(unlist(extract(x, rt)), na.rm=T), # sum(extract(x, rt)),
      dist_km = SpatialLinesLengths(rt) / 1000)))
  }
  
  # save
  save(routes, file = rdata)
}

# # quick routes update #routes0 = routes
# for (i in 1:length(routes)){ # i=1
#   #routes[[i]]$dist_km = routes[[i]]$dist_m / 1000
#   routes[[i]]$dist_m <- NULL
# }

# extract data from routes
d = data.frame(
  transform = sapply(routes, function(z) z$transform),
  dist_km = sapply(routes, function(z) z$dist_km),
  cost_x = sapply(routes, function(z) z$cost_x)) %>%
  mutate(
    industry = dist_km - min(dist_km),
    conservation = cost_x - min(cost_x)) %>%
  arrange(industry, desc(conservation))

cat_txt_tradeoff = function(transform){
  txt = with(
    d[d$transform==transform,],
    sprintf(paste(
      '- transformation: %s',
      '- dist _(km)_: %0.2f',
      '- cost: %0.2f',
      '- **industry** _(dist - min(dist))_: %0.2f',
      '- **conservation** _(cost - min(cost))_: %0.2f',
      sep='\n'),
      transform,
      dist_km,
      cost_x,
      industry,
      conservation)) %>%
    renderMarkdown(text = .)
  return(txt)
}

# # plot transforms
# f = '~/github/dissertation/fig/routing/shortestPath_transforms.pdf'
# pdf(f)
# plot(x, col=fields::two.colors(start='darkblue', end='red', middle='white', alpha=.5))
# cols = fields::tim.colors(length(transforms))
# for (i in 1:length(transforms)){ # i=16
#   lines(spTransform(routes[[i]]$route, crs(epsg3857)), col=cols[i], lwd=2)
# }
# legend('bottomleft', as.character(transforms), col=cols, lwd=2)
# dev.off()
# system(sprintf('open %s', f))

# ui ----
ui <- fluidPage(
  useShinyjs(),

  navbarPage(
    "Conservation",
    tabPanel(
      "Routing",
      fluidRow(
        helpText('Click on a point in the tradeoff chart below to display the mapped route to the right and values below. Map is zoomable/pannable and start/end points clickable.')),

      fluidRow(
        column(
          4,  # 
          hidden(textInput('txt_transform', 'selected transform', value = d_transform)),
          div(
            style = "height:400px; background-color:#f5f5f5",
            ggvisOutput("ggvis"))),
      
        column(
          8,
          leafletOutput("mymap", height='400px') #,
          #p(),
          #actionButton("recalc", "Reroute"))
          )),
      
      hr(),
      
      fluidRow(
        column(
          4,
          #DT::dataTableOutput('dt_tbl'))
          p(
            "Tradeoff selected: ",
            div(id = "txt_tradeoff", HTML(cat_txt_tradeoff(d_transform)))
            )),
        column(
          8,
          helpText(HTML(renderMarkdown(text='Welcome to Conservation Routing! Least cost routes are calculated based on different cost surfaces. 
                   The initial cost surface applies a constant value for all cells resulting in a Euclidean path
                   with the minimum distance. This path would be the least costly to industry, making it 
                   the reference point (_min(dist)_) to which other routes are compared. Other paths are calculated
                   by applying transformations to the conservation risk surface, which is calculated as the cumulative species score 
                   weighted by extinction risk. The summation of conservation risk values traversed by the path determines
                   the conservation score. The reference point (_min(cost)_) is subtracted from all values.')))))),
    
    tabPanel(
      "Siting")))

# server ----
server <- function(input, output, session) {

#   points <- eventReactive(input$recalc, {
#     # lr: 48.282911, -121.955969 (lon, lng)
#     # ul: 54.552710, -134.326578
#     # lon: 55 - 48 = 7
#     # lng: -121 - -134 = 13
#     x = c(-134, -121)
#     y = c(48, 55)
#     n = 10
#     cbind(rnorm(n) * diff(x)/2 + mean(x), rnorm(n) * diff(y)/2 + mean(y))
#   }, ignoreNULL = FALSE)
#   lns_gcs <- eventReactive(input$recalc, {
#     get_route(input$bw_adjust)
#   }, ignoreNULL = FALSE)
   
#   get_route <- eventReactive(input$transform, {
#     routes[[input$transform]][['route_gcs']]
#   })
  
  # chart ----
  d_hover <- function(x) {
    if(is.null(x)) return(NULL)
    row <- d[d$transform == x$transform, ]
    paste0(names(row), ": ", format(row), collapse = "<br />")
  }
  
  d_click <- function(x) {
    if(is.null(x)) return(NULL)
    
    # update hidden text to update map, visible text to show details of selected point
    updateTextInput(session, 'txt_transform', value = x$transform)
    shinyjs::text(id = "txt_tradeoff", text = cat_txt_tradeoff(x$transform))
    
    # highlight selected point
    i <- which(d$transform == x$transform)
    isolate({
      values$stroke <- rep(pt_cols[['off']], nrow(d))
      values$stroke[i] <- pt_cols[['on']]})
    
    # return popup of values in HTML
    row <- d[d$transform == x$transform, ]
    paste0(names(row), ": ", format(row), collapse = "<br />")
  }
  
  # initialize points
  #pt_cols = c(on='blue', off='slategray')
  pt_cols = c(on='blue', off='slategray')
  d_stroke = rep(pt_cols[['off']], nrow(d))
  d_stroke[d$transform == d_transform] = pt_cols[['on']]
  values <- reactiveValues(stroke=d_stroke) # values = data.frame(stroke=d_stroke)
  
  d_vis <- reactive({
    d %>%
      ggvis(~conservation, ~industry, key := ~transform) %>% # 
      layer_paths(stroke := 'slategray') %>% 
      layer_points(stroke := ~values$stroke, strokeWidth := 3) %>% # 
      scale_numeric('x', reverse=T) %>%
      scale_numeric('y', reverse=T) %>% 
      add_tooltip(d_hover, 'hover') %>% 
      add_tooltip(d_click, 'click') %>%
      add_axis('x', title = 'conservation (risk from min)') %>% 
      add_axis('y', title = 'industry (km from min)') %>% 
      hide_legend('stroke') %>%
      #set_options(width = 300, height = 400) %>%
      set_options(width = "auto", height = "auto", resizable=FALSE)
  })
  d_vis %>% bind_shiny("ggvis") 

  # TODO: add shinyjs::text
  
#   # table ----
#   output$dt_tbl = DT::renderDataTable({
#     datatable(d, selection='single', filter='none', options = list(
#       pageLength = nrow(d),
#       #initComplete = JS('function(setting, json) { alert("done"); }')
#       initComplete = JS(
#         'function(setting, json) { 
#         var trs = $("#dt_tbl tbody tr");
#         $(trs[1]).addClass("selected");
#         alert("done"); }')
#       ))
#   }, server = F)
#   # TODO: add shinyjs Click behavior to table to deselect/select
#   i = 
#   $(".selected").removeClass('selected')
    
  # http://rstudio.github.io/DT/shiny.html#row-selection
  # http://datatables.net/examples/api/select_single_row.html
  # var trs = $('#example tbody tr')
  # $(trs[1]).addClass('selected')
  # http://stackoverflow.com/questions/24750623/select-a-row-from-html-table-and-send-values-onclick-of-a-button
  # http://shiny.rstudio.com/articles/selecting-rows-of-data.html

  # map ----
  b = extent(pts_gcs)
  x = (r / cellStats(r,'max'))
  x_rng = c(cellStats(x,'min'), cellStats(x,'max'))
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Stamen.TonerLite", options = providerTileOptions(noWrap = TRUE)) %>% 
      addRasterImage(
        x, opacity = 0.8, project = F,
        colors = colorNumeric(palette = 'Reds', domain = x_rng, na.color = "#00000000", alpha = TRUE)) %>%
      addCircleMarkers(
        ~lon, ~lat, radius=6, color='blue', data=pts, 
        popup = ~sprintf('<b>%s</b><br>%0.2f, %0.2f', name, lon, lat)) %>%
      addLegend(
        'bottomleft', 
        pal = colorNumeric(palette = 'Reds', domain = x_rng),
        values = x_rng, title = 'Conservation <br> Risk') %>%
      fitBounds(b@xmin, b@ymin, b@xmax, b@ymax)
  })

  
  df = local({
    n = 300; x = rnorm(n); y = rnorm(n)
    z = sqrt(x^2 + y^2); z[sample(n, 10)] = NA
    data.frame(x, y, z)
  })
  pal = colorNumeric('OrRd', df$z)
  leaflet() %>%
    addCircleMarkers(~x, ~y, color = ~pal(z), data=df) %>%
    addLegend(pal = pal, values = range(df$z, na.rm=T), title='z')
  
  leaflet() %>%
    addCircleMarkers(~x, ~y, color = ~pal(z), data=df) %>%
    addLegend(pal = pal, values = range(df$z, na.rm=T), title='z')
  
  
  #observeEvent(input$map1_marker_click, {
  observeEvent(input$txt_transform, {
    # add least cost path
    i = which(sapply(routes, function(z) z$transform) == input$txt_transform)
    leafletProxy('mymap') %>%
      removeShape(c('routes')) %>% 
      addPolylines(data = routes[[i]][['route_gcs']], layerId='routes', color='blue') # , color='purple', weight=3)
  })
  
}

shinyApp(ui, server)

# 
# deploy by copying over ssh to the NCEAS server with Nick Brand
#   system(sprintf('sudo chown -R %s /srv/shiny-server/%s'), nceas_user, app_name) # may have to run this from Terminal if permission errors
system(sprintf('rsync -r --delete %s bbest@fitz.nceas.ucsb.edu:/srv/shiny-server/', app_dir))
system(sprintf("ssh bbest@fitz.nceas.ucsb.edu 'chmod g+w -R /srv/shiny-server/%s'", basename(app_dir)))

# push files to github app branch
system('git add -A; git commit -a -m "deployed app"; git push origin app')