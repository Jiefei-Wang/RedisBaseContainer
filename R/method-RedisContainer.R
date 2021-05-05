RedisContainer <- function(image = "", name = NULL,  environment = list(),
                           maxWorkerNum = 4L,
                           RPackages = NULL,
                           sysPackages = NULL){
  .RedisContainer$new(
    name=name, image = image,
    environment = environment,
    maxWorkerNum = as.integer(maxWorkerNum),
    RPackages=RPackages,
    sysPackages=sysPackages)
}

doRedisContainer <- function(image = "", name = NULL,  environment = list(),
                             maxWorkerNum = 4L,
                             RPackages = NULL,
                             sysPackages = NULL){
  .doRedisContainer$new(
    name=name, image = image,
    environment = environment,
    maxWorkerNum = as.integer(maxWorkerNum),
    RPackages=RPackages,
    sysPackages=sysPackages,
    backend = "doRedis")
}

RedisParamContainer <- function(image = "", name = NULL,  environment = list(),
                                maxWorkerNum = 4L,
                                RPackages = NULL,
                                sysPackages = NULL){
  .RedisParamContainer$new(
    name=name, image = image,
    environment = environment,
    maxWorkerNum = as.integer(maxWorkerNum),
    RPackages=RPackages,
    sysPackages=sysPackages,
    backend = "RedisParam")
}

#' Common RedisContainer parameter
#'
#' Common RedisContainer parameter
#'
#' @param image Character, the container image
#' @param name Character, the optional name of the container
#' @param environment List, the environment variables in the container
#' @param tag Character, the image tag
#' @rdname RedisContainer-commom-parameters
#' @name RedisContainer-commom-parameters
#' @return No reuturn value
NULL

#' Get the Bioconductor Redis server container
#'
#' Get the Bioconductor Redis server container.
#'
#' @inheritParams RedisContainer-commom-parameters
#' @examples RedisServerContainer()
#' @return a `RedisContainerProvider` object
#' @export
RedisServerContainer <- function(environment = list(), tag = "latest"){
  name <- "redisRServerContainer"
  image <- paste0("dockerparallel/redis-r-server:",tag)
  RedisContainer(image = image, name=name,
                 environment=environment,
                 maxWorkerNum=1L)
}

#' Get the Redis worker container
#'
#' Get the Redis worker container.
#'
#' @inheritParams RedisContainer-commom-parameters
#' @param image Character, the worker image used by the container
#' @param backend Character, the parallel backend used in the container
#' @param RPackages Character, a vector of R packages that will be installed
#' by `AnVIL::install` before connecting with the server
#' @param sysPackages Character, a vector of system packages that will be installed
#' by `apt-get install` before running the R worker
#' @param maxWorkerNum Integer, the maximum worker number in a container
#'
#' @examples BiocBPRPWorkerContainer()
#' @return a `RedisContainerProvider` object
#' @export
RedisWorkerContainer <- function(
  image = c("r-base", "bioconductor"),
  backend = c("doRedis", "RedisParam"),
  RPackages = NULL,
  sysPackages = NULL,
  environment = list(),
  maxWorkerNum = 4L,
  tag = "latest"){
  image <- match.arg(image)
  backend <- match.arg(backend)

  name <- "redisRWorkerContainer"
  image <- paste0("dockerparallel/", image, "-worker:",tag)
  if(backend == "doRedis"){
    doRedisContainer(image = image, name=name, RPackages=RPackages, sysPackages=sysPackages,
                     environment=environment,
                     maxWorkerNum=maxWorkerNum)
  }else{
    RedisParamContainer(image = image, name=name, RPackages=RPackages, sysPackages=sysPackages,
                        environment=environment,
                        maxWorkerNum=maxWorkerNum)
  }
}

#' Show the Redis container
#'
#' Show the Redis container
#'
#' @param object The `RedisContainer` object
#' @return No return value
#' @export
setMethod("show", "RedisContainer", function(object){
  cat("Redis container reference object\n")
  cat("  Image:     ", object$image, "\n")
  cat("  backend:   ", object$backend, "\n")

  cat("  maxWorkers:", object$maxWorkerNum, "\n")
  if(!is.null(object$RPackages)){
    cat("  R packages:", paste0(object$RPackages, collapse = ", "), "\n")
  }
  if(!is.null(object$sysPackages)){
    cat("  system packages:", paste0(object$sysPackages, collapse = ", "), "\n")
  }
  cat("  Environment variables:\n")
  for(i in names(object$environment)){
    cat("    ",i,": ", object$environment[[i]], "\n",sep="")
  }
  invisible(NULL)
})
