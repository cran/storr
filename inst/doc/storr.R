## -----------------------------------------------------------------------------
library(storr)

## -----------------------------------------------------------------------------
path <- tempfile("storr_")
st <- storr::storr_rds(path)

## ----eval=FALSE---------------------------------------------------------------
#  dr <- storr::driver_rds(path)

## ----eval=FALSE---------------------------------------------------------------
#  st <- storr::storr(dr)

## -----------------------------------------------------------------------------
st$set("mykey", mtcars)

## -----------------------------------------------------------------------------
head(st$get("mykey"))

## -----------------------------------------------------------------------------
st$list()

## -----------------------------------------------------------------------------
st$exists("mykey")

st$exists("another_key")

## -----------------------------------------------------------------------------
st$del("mykey")

## -----------------------------------------------------------------------------
st$list()

## -----------------------------------------------------------------------------
h <- st$list_hashes()
h

## -----------------------------------------------------------------------------
st$hash_object(mtcars)

## -----------------------------------------------------------------------------
head(st$get_value(h))

## -----------------------------------------------------------------------------
st$exists_object(h)

## -----------------------------------------------------------------------------
del <- st$gc()
del

st$list_hashes()

## -----------------------------------------------------------------------------
st$default_namespace

## -----------------------------------------------------------------------------
st$list_namespaces()

## -----------------------------------------------------------------------------
st$set("a", runif(5), namespace = "other_things")
st$list_namespaces()

## -----------------------------------------------------------------------------
st$list()
st$list("other_things")

## ----error = TRUE-------------------------------------------------------------
st$get("a")
st$get("a", "other_things")

## -----------------------------------------------------------------------------
st$mset(c("a", "b", "c"), list(1, 2, 3))
st$get("a")

## -----------------------------------------------------------------------------
st$mget(c("a", "b", "c"))

## -----------------------------------------------------------------------------
st$mget("a")
st$mget(character(0))

## -----------------------------------------------------------------------------
st$mset("x", list("a", "b"), namespace = c("ns1", "ns2"))
st$mget("x", c("ns1", "ns2"))

st$mget(c("a", "b", "x"), c("objects", "objects", "ns1"))

## -----------------------------------------------------------------------------
st$import(list(a = 1, b = 2))
st$list()
st$get("a")

## -----------------------------------------------------------------------------
e <- st$export(new.env(parent = emptyenv()))
ls(e)
e$a

st_copy <- st$export(storr_environment())
st_copy$list()
st$get("a")

st2 <- storr::storr(driver = storr::driver_rds(tempfile("storr_")))
st2$list()
st2$import(st)
st2$list()

## -----------------------------------------------------------------------------
dir(file.path(path, "keys", "objects"))
readLines(file.path(path, "keys", "objects", "a"))
st$get_hash("a")

## -----------------------------------------------------------------------------
st$list_hashes()

## -----------------------------------------------------------------------------
dir(file.path(path, "data"))

## -----------------------------------------------------------------------------
st <- storr::storr(driver = storr::driver_rds(tempfile("storr_")))

## -----------------------------------------------------------------------------
ls(st$envir)

## -----------------------------------------------------------------------------
set.seed(2)
st$set("mykey", runif(100))

## -----------------------------------------------------------------------------
ls(st$envir)

## -----------------------------------------------------------------------------
st$hash_object(st$envir[[ls(st$envir)]])

## -----------------------------------------------------------------------------
st$get_hash("mykey")

## -----------------------------------------------------------------------------
st$get_value

## -----------------------------------------------------------------------------
hash <- st$get_hash("mykey")
if (requireNamespace("rbenchmark")) {
  rbenchmark::benchmark(st$get_value(hash, use_cache = TRUE),
                        st$get_value(hash, use_cache = FALSE),
                        replications = 1000, order = NULL)[1:4]
}

## -----------------------------------------------------------------------------
tryCatch(st$get("no_such_key"),
         KeyError = function(e) NULL)

## -----------------------------------------------------------------------------
st$set("foo", letters)
ok <- st$driver$del_object(st$get_hash("foo"))
st$flush_cache()
tryCatch(st$get("foo"),
         KeyError = function(e) NULL,
         HashError = function(e) message("Data is deleted"))

