# convert dsm output polygons to geographic coordinates for use in leaflet
library(rgdal)
shp_alb = '~/Dropbox/raincoast/tippy/data/shp/dsm_ply5k_final_alb'
shp_gcs = '~/github/consmap/data/bc_spp_gcs'
ply_alb = readOGR(dirname(shp_alb), basename(shp_alb))
ply_gcs = spTransform(ply_alb, CRS('+proj=longlat +datum=WGS84'))
writeOGR(ply_gcs, dirname(shp_gcs), basename(shp_gcs), driver='ESRI Shapefile')


# OLD ----

require(readxl)
require(readr)
require(dplyr)
#require(RODBC)
#require(ggplot2)
#require(scales)

# ArcGIS on AMPHITRITE (bbest laptop VMWARE)
# Z:\bbest On My Mac\Dropbox\raincoast\tippy\vis\mxd\raincoast_lcrouting_5routes_cruiseship.mxd
# raster R:\data\cost\v72zc2 # tanker: v72zw, cruise: v72zc
cost_orig = '~/Dropbox/raincoast/tippy/data/cost/v72zw' 
# cost_gcs = '~/Google Drive/dissertation/data/bc/v72zw_epsg4326.grd'
# to_raster(cost_orig, cost_gcs, '+init=epsg:4326')
cost_mer = '~/Google Drive/dissertation/data/bc/v72zw_epsg3857.grd'
to_raster(cost_orig, cost_mer, proj_out=epsg3857, debug = T, overwrite = T, min_to_na = T)



d = read_excel(
  '~/Documents/svn_win/raincoast/params/tables_publish.xls', 
  'dsm params')
spp_labels = read_csv(
  '~/Documents/svn_win/raincoast/params/DistParams_labels.csv')                         
spp_order = rev(c(
  'DP','HP','PW',                     # dolphins
  'FW','HW','KW','MW',                # whales
  'HSout','HSin','SSLout','SSLin'))   # pinnipeds



con = odbcConnectExcel('params/tables_publish.xls')
excel_sheets(path)
d = t(sqlFetch(con, 'density_dsm_v60$', colnames=1, rownames='F1')) # )
spp.labels = read.csv('params/DistParams_labels.csv', row.names=1)                         
spp.order = rev(c('DP','HP','PW',
                  'FW','HW','KW','MW',
                  'HSout','HSin','SSLout','SSLin'))
d = cbind(d, data.frame(
  label=factor(row.names(d), levels=spp.order, labels=spp.labels[spp.order,'label'], ordered=T)))