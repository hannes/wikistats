library(Rook)
library(rjson)
library(dtw)

s <- Rhttpd$new()
s$start(port=1337)

pmatrix <- readRDS("~/Desktop/wikistats/matrix.rds")
pnames <- dimnames(pmatrix)[[1]]

intermediates <- 100

dtwrecommend <- function(env){
	# parse request
	req <- Request$new(env)
	params <- Utils$parse_query(env$QUERY_STRING);

	page <- params$p
	resultsize <- as.integer(params$n)
	if (length(resultsize) < 1) resultsize <- 10
	callback <- params$callback

	if (!(page %in% pnames)) {
		return(list(status = 400L,body=paste0("Page ",page," not found.")))
	}

	message(page," [",resultsize,"]")

	# find query series
	query <- t(pmatrix[pnames == page,])

	# TODO : if nothing is found, return

	# run first iteration, euclidian distance
	dists <- dist(query,pmatrix,method="Euclidean")
	candidates <- dimnames(dists)[[2]][head(order(dists),intermediates)]
	# remove query itself
	candidates <- candidates[2:length(candidates)]

	# run second iteration, dtw
	refine <- pmatrix[pnames %in% candidates,]
	dists2 <- dist(query,refine,method="DTW")
	resids <- head(order(dists2),resultsize)
	results <- data.frame(page=dimnames(dists2)[[2]][resids],distance=as.numeric(dists2[resids]))
	resultobj <- list()
	resultobj$related <- unname(split(results, rownames(results)))
	# return result
	
	message("done.")
	if (!is.null(callback)) return(
	list(
	    status = 200L,
	    headers = list(
	    'Content-Type' = 'application/javascript'
	    ),
	    body = paste0(callback,"(",toJSON(resultobj),");")
	))
	else return(
	list(
	    status = 200L,
	    headers = list(
	    'Content-Type' = 'application/json'
	    ),
	    body = toJSON(resultobj)
	))

}
s$add(app=dtwrecommend, name='dtwrecommend')

# wait to keep rook running
while(TRUE) Sys.sleep(.Machine$integer.max)