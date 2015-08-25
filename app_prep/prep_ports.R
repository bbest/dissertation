library(ggmap)  # geocode
library(readxl) # read_excel
library(readr)  # write_csv
library(dplyr)

# vars
xlsx = '~/github/consmap/data/ports_bc.xlsx'
csv  = '~/github/consmap/data/ports_bc.csv'
  
# get shipping data by port, international and domestic
ports_int = readxl::read_excel(xlsx, 'int', skip=2)
ports_dom = readxl::read_excel(xlsx, 'dom', skip=2)

# join ports and calculate 
ports = ports_int %>%
  select(port, int_ktons = total_ktons) %>%
  full_join(
    ports_dom %>%
      select(port, dom_ktons = total_ktons),
    by='port') %>%
  replace(is.na(.), 0) %>%
  mutate(
    sum_ktons = int_ktons + dom_ktons,
    lon = NA,
    lat = NA) %>%
  filter(sum_ktons > 0) %>%
  arrange(port) %>%
  rename(name=port)


# override with manual Google Map searches for ones that returned same value as BC
port_locs = list(
  'Kultus Cove'       = c('lon'=-127.6278580,'lat'=50.4848111),
  'Chatham Sound'     = c('lon'=-130.5833352,'lat'=54.3666666),
  'Pitt River Quarry' = c('lon'=-122.6446215,'lat'=49.2947082))

# get lat and lon for place
for (i in 1:nrow(ports)){ # i=1
  port = ports$name[[i]]
  if (port %in% names(port_locs)){
    loc = port_locs[[port]]
  } else {
    loc = ggmap::geocode(sprintf('%s, British Columbia', ports$name[i]), output='latlon', messaging=F)
  }
  ports$lon[i] = loc[['lon']]
  ports$lat[i] = loc[['lat']]
}

# get ports with same location as BC
loc_bc = ggmap::geocode('British Columbia', output='latlon', messaging=F)
ports_loc_eq_bc = ports %>%
  filter(lon == loc_bc[['lon']] & lat == loc_bc[['lat']])
stopifnot(nrow(ports_loc_eq_bc)==0)

# get port codes
# ports.0 = ports; ports = select(ports,-code)
codes = read_csv('~/github/consmap/data/ports/seaport_codes.csv') %>%
  filter(COUNTRY=='CA') %>%
  select(name=NAME, code=CODE)
port_codes = c(
  'Chatham Sound'               = 'CHN',
  'East Coast Vancouver Island' = 'EVC', # TODO: add lon/lat to East Coast Vancouver Island
  'Kultus Cove'                 = 'KLC',
  'Metro Vancouver'             = 'VAN',
  'Pitt River Quarry'           = 'PRQ',
  'Watson Island'               = 'WAI') %>% 
  as.data.frame() %>% add_rownames() %>%  # names()
  select_(.dots = c('name'='rowname', 'code'='.'))
ports = ports %>%
  left_join(rbind(codes, port_codes), by='name')
# filter(ports, is.na(code)) %>% .$name %>% paste(collapse="','")
stopifnot(nrow(filter(ports, is.na(code)))==0)
stopifnot(sum(duplicated(ports$name))==0)

# TODO: find nearest pixel centroid

# write csv
write_csv(ports, csv)
