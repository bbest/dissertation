
Looking at versions on my Mac laptop salacia:

```r
devtools::session_info()
```

On fitz terminal:

```bash
# install gdal and proj
sudo apt-get install libgdal-dev
sudo apt-get install libproj-dev

# open R as root
sudo R
```

In R install packages:
```r
# from CRAN
install.packages(c(
  'sp','rgdal','raster','gdistance','shiny'))

# from Github
devtools::install_github(c(
  'rstudio/htmltools',
  'hadley/scales',
  'rstudio/ggvis',
  'jcheng5/rasterfaster',
  'rstudio/leaflet@joe/feature/raster-image',
  'daattali/shinyjs'))

# existing: 'markdown'
```
