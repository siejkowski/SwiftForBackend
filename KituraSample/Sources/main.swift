import Foundation
import KituraSys
import KituraNet
import KituraRouter
import LoggerAPI
import HeliumLogger
#if os(Linux)
    import Glibc
#endif

print("hello touk!")

Log.logger = HeliumLogger()

connectToDatabase { database in
    let router = provideRouter(database)

    let server = HttpServer.listen(8080, delegate: router)

    Server.run()
}



