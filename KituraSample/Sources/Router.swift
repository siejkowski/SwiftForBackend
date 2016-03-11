import Foundation
import KituraSys
import KituraNet
import KituraRouter
import CouchDB
import SwiftyJSON
import LoggerAPI
import HeliumLogger
import Mustache

func provideRouter(database: Database) -> Router {
    return Router()
    .use("/*", middleware: BodyParser())
    .use("/*", middleware: StaticFileServer())
    .get("/hello") { _, response, next in
        defer { next() }
        response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
        response.status(HttpStatusCode.OK).send("Hello World, from TouK!").forceEnd()
    }
    .get("/users") { (request: RouterRequest, response: RouterResponse, next) in
        defer { next() }
        database.retrieveAll { (json: JSON?, error: NSError?) in
            guard let json = json else {
                response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).forceEnd()
                return
            }
            if response.handleError(error) {
                response.sendJson(json["rows"]).status(HttpStatusCode.OK).forceEnd()
            }
        }
    }
    .post("/user") { (request: RouterRequest, response: RouterResponse, next) in
        defer { next() }
        request.body?.asJson().map { json in
            database.create(json) { (id: String?, rev:String?, document: JSON?, error: NSError?) in
                if response.handleError(error) {
                    Log.info("user saved to database. id: \(id), rev: \(rev), document: \(document)")
                    let responseBody: JSON = ["id": id]
                    response.sendJson(responseBody).status(HttpStatusCode.OK).forceEnd()
                }
            }
        }
    }
    .get("/html/:name?") { (request: RouterRequest, response: RouterResponse, next) in
        defer { next() }
        do {
            let name = request.params["name"] ?? "Swift"
            let data = try NSData(contentsOfFile: "resources/template.mustache", options: [])
            if let templateString = String(data: data, encoding: NSUTF8StringEncoding) {
                let template = try Template(string: templateString)
                try response.send(template.render(Box(dictionary: ["name": name]))).end()
            }
        } catch {}
    }
    .get("/logo") { (request: RouterRequest, response: RouterResponse, next) in
        defer { next() }
        let req = Http.request("https://api.github.com/users/touk") { (toukResponse: ClientResponse?) in
            guard let jsonString = try! toukResponse?.readString(),
                  let avatar = JSON(jsonString)["avatar_url"].string
            else {
                response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).forceEnd()
                return
            }
            let req = Http.request(avatar) { (avatarResponse: ClientResponse?) in
                let data = NSMutableData()
                try! avatarResponse?.readAllData(data)
                response.status(HttpStatusCode.OK).sendData(data).forceEnd()
            }
            req.end()
        }
        req.end()
    }
}

extension RouterResponse {
    func forceEnd() -> RouterResponse {
        return try! self.end()
    }

    func handleError(error: NSError?) -> Bool {
        if let _ = error {
            self.status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return false
        }
        return true
    }
}

