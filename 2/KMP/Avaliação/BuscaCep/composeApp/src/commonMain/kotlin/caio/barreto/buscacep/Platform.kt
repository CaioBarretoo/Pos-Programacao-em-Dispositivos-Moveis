package caio.barreto.buscacep

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform