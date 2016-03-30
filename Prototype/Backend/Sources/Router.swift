import Foundation
import KituraSys
import KituraNet
import Kitura
import SwiftyJSON
import LoggerAPI
import FluentSQLite
import Fluent

func provideRouter() -> Router {
    return Router()
    .all("/*", middleware: BodyParser())
    .all("/*", middleware: StaticFileServer())
    .post("/user") { (request: RouterRequest, response: RouterResponse, next) in
        guard let json = request.body?.asJson() else {
            response.send("Wrong request, no json body").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        guard let content = json["content"].string
        else {
            response.send("Wrong request, no content").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        let note = Note(content: content)
        note.save()
        let id = Query<Note>().filter(note.contentKey, note.content).first?.id
        response.send(id ?? "not found").status(HttpStatusCode.OK).forceEnd()
    }
    .get("/user/:id?") { (request: RouterRequest, response: RouterResponse, next) in
        let results = Query<Note>().results
        guard let maybeId = request.params["id"],
              let id = Int(maybeId) else {
            response.send("id is required").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        guard results.count > id else {
            response.send("id outside range").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        let note = Query<Note>().results[id]
        response.send(note.content).status(HttpStatusCode.OK).forceEnd()
    }
    .delete("/user/:id?") { (request: RouterRequest, response: RouterResponse, next) in
        let results = Query<Note>().results
        guard let maybeId = request.params["id"],
              let id = Int(maybeId) else {
            response.send("id is required").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        guard results.count > id else {
            response.send("id outside range").status(HttpStatusCode.BAD_REQUEST).forceEnd()
            return
        }
        let note = Query<Note>().results[id]
        note.delete()
        response.status(HttpStatusCode.OK).forceEnd()
    }
    .get("/users") { (request: RouterRequest, response: RouterResponse, next) in
        let results = Query<Note>().results
        let contentsString = results.map { note in note.content }
        let contents = contentsString.map { content in JSON(content) }
        response.sendJson(JSON(contents)).status(HttpStatusCode.OK).forceEnd()
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

