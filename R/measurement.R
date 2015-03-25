library(XML)
library(RCurl)

API_ROOT <- 'https://atlas.ripe.net/api/v1/'
HTTPHEADER <- c(Accept = 'application/xml')
TYPES <- list(integer = as.integer,
              boolean = function(x) x == 'True',
              hash = function(.) NA,
              null = function(.) NA)

#' For example, https://atlas.ripe.net/api/v1/measurement/
#' or https://atlas.ripe.net/api/v1/measurement/1001/
get.measurement <- function(id = NULL) {
  if (is.null(id))
    url <- paste0(API_ROOT, 'measurement/')
  else
    url <- paste0(API_ROOT, 'measurement/', id, '/')
  text <- RCurl::getURL(url, httpheader = HTTPHEADER)
  xml <- XML::xmlTreeParse(text)

  if (is.null(id)) {
    # xml$doc$children$response[['meta']]

    # This doesn't work. Dunno why.
    # Reduce(rbind, lapply(xml$doc$children$response[['objects']], .parse.object))

    objects <- xml$doc$children$response[['objects']]
    df <- objects[[1]]
    for (object in objects[-1])
      df <- rbind(df, object)
    df

  } else {
    .parse.object(xml$doc$children$object)
  }
}

.parse.object <- function(object) {
  f <- function(name) {
    node <- object[[name]]
    attrs <- xmlAttrs(node)
    if ('type' %in% names(attrs)) {
      type <- TYPES[[attrs[['type']]]]
    } else if (length(node) == 1) {
      type <- as.character
    } else {
      type <- TYPES[['null']]
    }
    v <- xmlValue(node)
    if (length(v) == 0)
      v <- NA
    df <- data.frame(k = type(v))
    names(df) <- name
    df
  }
  dfs <- lapply(names(object), f)
  do.call(cbind, dfs)
}

#' For example, https://atlas.ripe.net/api/v1/measurement/1001/result/
get.result <- function(id)
  paste0(API_ROOT, 'measurement/', id, 'result/')
