
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

In R:
```r
install.packages(
  c('sp','rgdal','raster','gdistance'))
devtools::install_github(
  c(
    'rstudio/htmltools',
    'hadley/scales',
    'rstudio/leaflet@joe/feature/raster-image',
    'daattali/shinyjs',
    'rstudio/ggvis'))

# existing: 'shiny','markdown'
```
