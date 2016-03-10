import Foundation
import KituraSys
import KituraNet
import KituraRouter
import CouchDB
import SwiftyJSON
import LoggerAPI
import HeliumLogger

func handleError(response: RouterResponse, error: NSError?) -> Bool {
    if let _ = error {
        try! response.status(HttpStatusCode.BAD_REQUEST).end()
        return false
    }
    return true
}

extension Database {

    public func retrieveAll(callback: (JSON?, NSError?) -> ()) {

        let requestOptions: [ClientRequestOptions] = [
                .Hostname(connProperties.hostName),
                .Port(connProperties.port),
                .Method("GET"),
                .Path("/\(escapedName)/_all_docs?include_docs=true")
            ]
        var headers = [String:String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        var document: JSON?
        let req = Http.request(requestOptions) { (response: ClientResponse?) in
            var error: NSError?
            if let response = response {
                let body = NSMutableData()
                try! response.readAllData(body)
                document = JSON(data: body)
                if response.statusCode != HttpStatusCode.OK {
                    error = NSError(domain: "CouchDBDomain", code: response.statusCode.rawValue, userInfo: [:])
                }
            } else {
                error = NSError(domain: "CouchDBDomain", code: Database.InternalError, userInfo: [:])
            }
            callback(document, error)
        }
        req.end()
    }
}

func provideRouter(database: Database) -> Router {

    let router = Router()

    router.use("/*", middleware: BodyParser())

    router.get("/hello") { _, response, next in
        response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
        try! response.status(HttpStatusCode.OK)
                     .send("Hello World, from TouK!")
                     .end()
        next()
    }

    router.get("/users") { (request: RouterRequest, response: RouterResponse, next) in
        database.retrieveAll { (json: JSON?, error: NSError?) in
            if let json = json {
                if handleError(response, error: error) {
                    try! response.sendJson(json["rows"]).status(HttpStatusCode.OK).end()
                }
            }
        }
    }

    router.post("/user") { (request: RouterRequest, response: RouterResponse, next) in
        request.body?.asJson().map { json in
            database.create(json) { (id: String?, rev:String?, document: JSON?, error: NSError?) in
                if handleError(response, error: error) {
                    Log.info("user saved to database. id: \(id), rev: \(rev), document: \(document)")
                    let responseBody: JSON = ["id": id]
                    try! response.sendJson(responseBody).status(HttpStatusCode.OK).end()
                }
            }
        }
//        next()
    }


    return router

}

func connectToDatabase(callback: (Database) -> ()) {
    let connProperties = ConnectionProperties(hostName: "couchdb",
            port: 5984,
            secured: false)

    let connPropertiesStr = connProperties.toString()
    print("connPropertiesStr:\n\(connPropertiesStr)")

    let couchDBClient = CouchDBClient(connectionProperties: connProperties)
    print("Hostname is: \(couchDBClient.connProperties.hostName)")

    couchDBClient.dbExists("users") { (exists: Bool, error: NSError?) in
        if let error = error {
            fatalError("connection unavailable \(error.userInfo)")
        } else if exists {
            callback(couchDBClient.database("users"))
        } else {
            couchDBClient.createDB("users") { (database: Database?, error: NSError?) in
                if let database = database {
                    callback(database)
                } else {
                    fatalError("database creation error \(error?.userInfo)")
                }

            }
        }
    }
}