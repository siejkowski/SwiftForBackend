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

let note = Note(content: "note \(random())")
note.save()

print(Query<Note>().results)

print("elo")

//Log.logger = HeliumLogger()
//connectToDatabase { database in
//    let router = provideRouter(database)
//
//    let server = HttpServer.listen(8080, delegate: router)
//
//    Server.run()
//}
