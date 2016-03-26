import Foundation
import KituraSys
import KituraNet
import CouchDB
import LoggerAPI
import HeliumLogger
import SwiftyJSON

func connectToDatabase(callback: (Database) -> ()) {
    let couchDBClient = CouchDBClient(connectionProperties: getConnectionProperties())
    couchDBClient.dbExists(databaseName) { (exists: Bool, error: NSError?) in
        if let error = error {
            fatalError("connection unavailable \(error.userInfo)")
        } else if exists {
            callback(couchDBClient.database(databaseName))
        } else {
            createDatabase(couchDBClient, callback: callback)
        }
    }
}

private let hostname = "couchdb"
private let port: Int16 = 5984
private let databaseName = "users"

private func getConnectionProperties() -> ConnectionProperties {
    return ConnectionProperties(
            hostName: hostname,
            port: port,
            secured: false // http or https?
    )
}

private func createDatabase(couchDBClient: CouchDBClient, callback: (Database) -> ()) {
    couchDBClient.createDB(databaseName) { (database: Database?, error: NSError?) in
        guard let database = database
        else { fatalError("database creation error \(error?.userInfo)") }
        callback(database)
    }
}

extension Database {

    private var databaseErrorDomain: String { get { return "CouchDBDomain" }}

    public func                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 retrieveAll(callback: (JSON?, NSError?) -> ()) {
        let requestOptions: [ClientRequestOptions] = [
                .Hostname(connProperties.hostName),
                .Port(connProperties.port),
                .Method("GET"),
                .Path("/\(escapedName)/_all_docs?include_docs=true"),
                .Headers(["Accept": "application/json", "Content-Type": "application/json"])
        ]
        performRequest(requestOptions, callback: callback)
    }

    func performRequest(requestOptions: [ClientRequestOptions], callback: (JSON?, NSError?) -> ()) {
        let req = Http.request(requestOptions) { (response: ClientResponse?) in
            self.processResponse(response, callback: callback)
        }
        req.end()
    }


    func processResponse(response: ClientResponse?, @noescape callback: (JSON?, NSError?) -> ()) {
        var error: NSError?
        var document: JSON?
        if let response = response {
            let body = NSMutableData()
            try! response.readAllData(body)
            document = JSON(data: body)
            if response.statusCode != HttpStatusCode.OK {
                error = NSError(domain: databaseErrorDomain, code: response.statusCode.rawValue, userInfo: [:])
            }
        } else {
            error = NSError(domain: databaseErrorDomain, code: Database.InternalError, userInfo: [:])
        }
        callback(document, error)
    }

}