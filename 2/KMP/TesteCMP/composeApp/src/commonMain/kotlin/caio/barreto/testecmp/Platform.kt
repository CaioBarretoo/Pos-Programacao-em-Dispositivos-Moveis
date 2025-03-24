package caio.barreto.testecmp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform