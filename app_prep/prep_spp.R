require(readxl)
require(readr)
require(dplyr)
#require(RODBC)
#require(ggplot2)
#require(scales)


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