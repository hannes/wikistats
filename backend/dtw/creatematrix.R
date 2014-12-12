# the who's who of data management are needed for this 
library(MonetDB.R)
library(reshape2)
library(data.table)

conn <- mc("wikistats")

tf <- tempfile()	
message("export")
dbGetQuery(conn,paste0('copy select "page","year","week","count" from weekcountenf into \'',tf,'\' using delimiters \'\t\''))
message("load")
ds <- as.data.frame(fread(tf,header=F,sep="\t",colClasses=c("character","integer","integer","numeric")))
names(ds) <- c("page","year","week","count")

message("yw")
ds$yw <- as.integer(sprintf("%d%02d",ds$year, ds$week))

message("cast")
da <- acast(ds, page ~ yw, value.var="count")

message("na")
da[is.na(da)] <- 0

message("save")
saveRDS(da,file="~/Desktop/wikistats/matrix.rds")

message("done")