import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import Mustache

let log = Log()
let logger = LogMiddleware(log: log)

let router = Router { route in
    route.get("/hello") { _ in
        return Response(body: "hello world")
    }
    route.get("/hello/:name") { request in
        if let name = request.pathParameters["name"] {
            let template = try! Template(string: "hello {{ name }}")
            return Response(body: try! template.render(Box(dictionary: ["name" : name])))
        } else {
            return Response(status: .BadRequest)
        }
    }
    route.fallback(responder: FileResponder(basePath: "Hello.app/Contents/Resources"))
}

try Server(middleware: logger, responder: router).start()