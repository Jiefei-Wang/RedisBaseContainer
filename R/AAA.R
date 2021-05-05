###########################
## container provider
###########################
# The base container
.RedisContainer <- setRefClass(
    "RedisContainer",
    fields = list(
        sysPackages = "CharOrNULL",
        RPackages = "CharOrNULL",
        backend = "CharOrNULL"
    ),
    contains = "DockerContainer"
)

.RedisParamContainer <- setRefClass(
    "RedisParamContainer",
    contains = "RedisContainer"
)
.doRedisContainer <- setRefClass(
    "doRedisContainer",
    contains = "RedisContainer"
)
