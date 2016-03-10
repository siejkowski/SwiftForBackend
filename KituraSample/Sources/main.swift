import Foundation
import KituraSys
import KituraNet
import KituraRouter
import LoggerAPI
import HeliumLogger
#if os(Linux)
    import Glibc
#endif
import KituraMustache

Log.logger = HeliumLogger()

let router = provideRouter()

let server = HttpServer.listen(8080, delegate: router)

Server.run()

