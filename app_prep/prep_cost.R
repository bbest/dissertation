# - [moll projection example in R](http://stackoverflow.com/questions/27535047/how-to-properly-project-and-plot-raster-in-r)
# - [Using R to quickly create an interactive online map using the leafletR package | Technical Tidbits From Spatial Analysis & Data Science](http://zevross.com/blog/2014/04/11/using-r-to-quickly-create-an-interactive-online-map-using-the-leafletr-package/)
# - [add raster to leaflet map in shiny - Google Groups](https://groups.google.com/forum/#!topic/shiny-discuss/iUOqqo3ZFss)
# - [Leaflet for R - Legends](http://rstudio.github.io/leaflet/legends.html)
# - [Leaflet for R - GeoJSON](https://rstudio.github.io/leaflet/geojson.html)

library(rgdal)
library(raster)

to_raster <- function(
  path_in, path_out, 
  proj_in = projection(raster(path_in)), proj_out='+init=epsg:3857', 
  debug = F, overwrite = F, min_to_na = F){
  # epsg:4326 is WGS84, epsg:3857 is Google or Web Mercator
  
  # debug
  if (debug){
    cat(str(match.call()))
    print(GDALinfo(path_in))
  }
  
  # checks
  if(file.exists(path_out) & !overwrite){
    message(sprintf('path_out already exists and overwrite=F:\n  %s', path_out))
    return()
  }
  stopifnot(file.exists(path_in))
  stopifnot(!is.na(proj_in))

  # read
  r = raster(path_in)
  projection(r) = proj_in

  # project
  #e_out = projectExtent(r_in, crs=CRS(proj_out)) 
  #res(e_out) <- min(res(e_out)) # use min x or y, otherwise can have diff't x, y widths
  #r_out = projectRaster(r_in, e_out, method='bilinear')
  #r_out = projectRaster(r_in, crs=CRS(proj_out), method='bilinear')
  
  # remove zeros
  #browser()
  #plot(r_in)
  #r_in
  #click(r_in)
  #rx = r_in == min(values(r_in), na.rm = T)
  #plot(rx)
  
  #plot(r_out)
  #click(r_out)
  
#   r2 = r_out == min(values(r_out), na.rm = T)
#   plot(r2)
#   plot(r_in)
#   
  if (min_to_na) {
    r = mask(r, r, maskvalue = min(values(r), na.rm = T))
  } 
  #plot(r2)
  #r2 # x:783, y:695, res:1000m
  
  r = projectRaster(r, crs=CRS(proj_out), res=xres(r), method='bilinear')
  #r3 # x:1308, y:1228, res:1000
  #plot(r3)

  # write
  raster::writeRaster(r, path_out, format='raster', overwrite=overwrite)
  
  # debug
  if (debug){
    plot(r)
    print(GDALinfo(path_out))
  }
}

# https://github.com/rstudio/leaflet/blob/ed8bbe0dd8c59594cfbb46d4678f836940463c4c/R/layers.R#L89-L90
epsg4326 <- "+proj=longlat +datum=WGS84 +no_defs"
epsg3857 <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs"

# ArcGIS on AMPHITRITE (bbest laptop VMWARE)
# Z:\bbest On My Mac\Dropbox\raincoast\tippy\vis\mxd\raincoast_lcrouting_5routes_cruiseship.mxd
# raster R:\data\cost\v72zc2 # tanker: v72zw, cruise: v72zc
cost_orig = '~/Dropbox/raincoast/tippy/data/cost/v72zw' 
# cost_gcs = '~/Google Drive/dissertation/data/bc/v72zw_epsg4326.grd'
# to_raster(cost_orig, cost_gcs, '+init=epsg:4326')
cost_mer = '~/Google Drive/dissertation/data/bc/v72zw_epsg3857.grd'
to_raster(cost_orig, cost_mer, proj_out=epsg3857, debug = T, overwrite = T, min_to_na = T)



# # https://www.nceas.ucsb.edu/globalmarine/models
# gl_p_mol = '~/Downloads/model_lzw.tif'
# gl_p_gcs = '~/Downloads/model_lzw_gcs.grd'
# system.time(
#   to_raster(
#     path_in  = gl_p_mol, 
#     path_out = gl_p_gcs, 
#     proj_in  = '+proj=moll +ellps=WGS84', 
#     proj_out = '+init=epsg:4326', 
#     debug = T)
#   ) / 60 # started 9:01