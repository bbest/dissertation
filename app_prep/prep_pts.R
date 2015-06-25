# prep of data files
# points.csv: `x = raster('data/v72zw_epsg3857.grd'); plot(x); click(x)` to get Web Mercator x, y
# extents.csv: clicked on corners of bounding box in google.maps.com to get lon/lat

library(dplyr)
library(sp)
library(rgdal)
library(raster)

# params
epsg4326 <- "+proj=longlat +datum=WGS84 +no_defs"
epsg3857 <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs"

# paths
app_dir = '~/github/dissertation/app/bdb'
if (!file.exists('data')) setwd(app_dir) 
rdata = 'data/routes.Rdata' # '~/Google Drive/dissertation/data/routing/demo.Rdata'
grd = 'data/v72zw_epsg3857.grd' # '~/Google Drive/dissertation/data/bc/v72zw_epsg3857.grd'
extents_csv = 'data/extents.csv'
points_csv = 'data/points.csv'

# read in raster ----
r = raster(grd)

# create points -----
pts = read.csv(
  text = '
extent, name, x_epsg3857, y_epsg3857, notes
"British Columbia, Canada", "Port Kitimat", -14323291, 7171167, "http://www.kitimat.ca/EN/main/business/invest-in-kitimat/port-of-kitimat.html"
"British Columbia, Canada", "S of Haida Gwaii", -14580291, 6780167')
# Port Kitimat (http://www.kitimat.ca/EN/main/business/invest-in-kitimat/port-of-kitimat.html)

# project pts from web mercator to gcs
pts_mer = pts
coordinates(pts_mer) = c('x_epsg3857', 'y_epsg3857')
proj4string(pts_mer) <- epsg3857
pts_gcs = spTransform(pts_mer, crs(epsg4326))
pts = pts %>%
  cbind(
    coordinates(pts_gcs) %>%
      as.data.frame() %>%
      dplyr::select(lon=x_epsg3857, lat=y_epsg3857))
write.csv(pts, points_csv, row.names=F)