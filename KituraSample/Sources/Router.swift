import Foundation
import KituraSys
import KituraNet
import KituraRouter

func provideRouter() -> Router {

    let router = Router()

    router.get("/hello") { _, response, next in
        response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
        try! response.status(HttpStatusCode.OK).send("Hello World, from Kitura!").end()
        next()
    }

    return router

}