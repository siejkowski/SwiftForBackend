import KituraSys
import KituraNet
import Kitura
import FluentSQLite
import Fluent
#if os(Linux)
import Glibc
#else
import Darwin
#endif

let sqlDriver = SQLiteDriver()
Database.driver = sqlDriver

struct Note : Model {

    let idKey = "id"
    let id: String?

    let contentKey = "content"
    let content: String

    static var table: String { get { return "notes" } }

    func serialize() -> [String: String] {
        return [idKey : id ?? "NULL", contentKey : content]
    }

    init(content: String) {
        self.id = nil
        self.content = content
    }

    init(serialized: [String: String]) {
        self.id = serialized[idKey] ?? ""
        self.content = serialized[contentKey] ?? ""
    }
}

let router = provideRouter()
let server = HttpServer.listen(8080, delegate: router)
Server.run()
