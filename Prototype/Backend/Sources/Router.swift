//import Foundation
//import KituraSys
//import KituraNet
//import KituraRouter
//import CouchDB
//import SwiftyJSON
//import LoggerAPI
//import HeliumLogger
//import Mustache
//import WebSocket
//
//func provideRouter(database: Database) -> Router {
//    return Router()
//    .use("/*", middleware: BodyParser())
//    .use("/*", middleware: StaticFileServer())
//
//    .get("/slack") { _, response, next in
//        let slackApiToken = "xoxb-29685368228-tkILhjUEkq3F6qSBahe0Kw1W"
//        let requestOptions: [ClientRequestOptions] = [
//                .Schema("https://"),
//                .Hostname("slack.com"),
//                .Port(443),
//                .Path("/api/rtm.start"),
//                .Method("POST"),
//                .Headers(["User-Agent": "*"])
//        ]
//        let req = Http.request(requestOptions) { (clientResponse: ClientResponse?) in
//            guard let clientResponse = clientResponse else {
//                response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).forceEnd()
//                return
//            }
//            let data = NSMutableData()
//            try! clientResponse.readAllData(data)
//            let string = String(data: data, encoding: NSUTF8StringEncoding)!
//            let stringData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
//            let json = JSON(data: stringData)
//            let url = json["url"].stringValue
//
//            let client = try! Client(ssl: true, host: "mpmulti-vy5o.slack-msgs.com", port: 443) { (socket: Socket) in
//                try socket.loop()
//            }
//            client.connectInBackground(path: "websocket/LpGCWeaxYJt-G_ByBm-r0Y4_gnMEMIkIpwuUNHMaAT7PB5jQ5THdsh-dPluOsprx_CXA2b1mNzsxTtoBvx41G5Zw1O3hZ8sdG0v9DrECbsI7fCZ_FbGZIimBVz3O9VNfyxHnL2Mit92vwK7x4bofsg==")
//
//
//
////            do {
////                let socket: BlueSocket = try BlueSocket.defaultConfigured()
////                let sub = url.substringWithRange(Range(start: url.startIndex.advancedBy(6), end: url.endIndex))
////                print(sub)
////                try socket.connectTo(sub, port: 443)
////                let message = try socket.readString()
////                print(message)
////                socket.close()
////            } catch {
////                print("error: '\(error)")
////            }
//            response.send(url).status(HttpStatusCode.OK).forceEnd()
//        }
//        req.end("token=\(slackApiToken)&simple_latest=true&no_unreads=true")
//    }
//
//    .get("/hello") { _, response, next in
//        defer { next() }
//        response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
//        response.status(HttpStatusCode.OK).send("Hello World, from TouK!").forceEnd()
//    }
//    .get("/users") { (request: RouterRequest, response: RouterResponse, next) in
//        defer { next() }
//        database.retrieveAll { (json: JSON?, error: NSError?) in
//            guard let json = json else {
//                response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).forceEnd()
//                return
//            }
//            if response.handleError(error) {
//                response.sendJson(json["rows"]).status(HttpStatusCode.OK).forceEnd()
//            }
//        }
//    }
//    .post("/user") { (request: RouterRequest, response: RouterResponse, next) in
//        defer { next() }
//        request.body?.asJson().map { json in
//            database.create(json) { (id: String?, rev:String?, document: JSON?, error: NSError?) in
//                if response.handleError(error) {
//                    Log.info("user saved to database. id: \(id), rev: \(rev), document: \(document)")
//                    let responseBody: JSON = ["id": id]
//                    response.sendJson(responseBody).status(HttpStatusCode.OK).forceEnd()
//                }
//            }
//        }
//    }
//    .get("/html/:name?") { (request: RouterRequest, response: RouterResponse, next) in
//        defer { next() }
//        do {
//            let name = request.params["name"] ?? "Swift"
//            let data = try NSData(contentsOfFile: "resources/template.mustache", options: [])
//            if let templateString = String(data: data, encoding: NSUTF8StringEncoding) {
//                let template = try Template(string: templateString)
//                try response.send(template.render(Box(dictionary: ["name": name]))).end()
//            }
//        } catch {}
//    }
//    .get("/logo") { (request: RouterRequest, response: RouterResponse, next) in
//        defer { next() }
//        let requestOptions: [ClientRequestOptions] = [
//                .Schema("https://"),
//                .Hostname("api.github.com"),
//                .Port(443),
//                .Path("/users/touk"),
//                .Method("GET"),
//                .Headers(["User-Agent": "touk"])
//        ]
//        let req = Http.request(requestOptions) { (toukResponse: ClientResponse?) in
//            let data = NSMutableData()
//            try! toukResponse?.readAllData(data)
//            let stringData = String(data: data, encoding: NSUTF8StringEncoding)
//            let json = JSON(data: data)
//            Log.info("json: \(json)")
//            guard let avatar = json["avatar_url"].string
//            else {
//                response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).forceEnd()
//                return
//            }
//            let req = Http.request(avatar) { (avatarResponse: ClientResponse?) in
//                let data = NSMutableData()
//                try! avatarResponse?.readAllData(data)
//                response.status(HttpStatusCode.OK).sendData(data).forceEnd()
//            }
//            req.end()
//        }
//        req.end()
//    }
//}
//
//extension RouterResponse {
//    func forceEnd() -> RouterResponse {
//        return try! self.end()
//    }
//
//    func handleError(error: NSError?) -> Bool {
//        if let _ = error {
//            self.status(HttpStatusCode.BAD_REQUEST).forceEnd()
//            return false
//        }
//        return true
//    }
//}
//
