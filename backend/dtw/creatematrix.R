library(MonetDB.R)
library(reshape2)
library(dtw)
#mserver5 --set embedded_r=true --dbpath=`pwd`/dbfarm --set mapi_port=50001

conn <- mc("",port=50001)

ds <- dbReadTable(conn,"weekcountenf")
ds <- data.frame(page=pg,year=yr,week=wk,count=ct)
ds$yw <- as.integer(sprintf("%d%02d",ds$year, ds$week))
da <- acast(ds, page ~ yw, value.var="count")
da[is.na(da)] <- 0

saveRDS(da,file="~/Desktop/wikistats/matrix.rds")