import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import Mustache
import Foundation

let resourcePath = "Hello.app/Contents/Resources"

let log = Log()
let logger = LogMiddleware(log: log)
    
public func createRouter() -> Router {
    return Router { route in
        
        route.get("/hello") { _ in
            return Response(body: "hello world")
        }
        
        let template = try! Template(string: "hello {{ name }}")
        route.get("/hello/:name") { request in
            guard let name = request.pathParameters["name"] else {
                return Response(status: .BadRequest)
            }
            return Response(body: try! template.render(Box(dictionary: ["name" : name])))
        }
        
        route.fallback(responder: FileResponder(basePath: resourcePath))
    }
}

let isRunningProduction = NSClassFromString("XCTestCase") == nil

if isRunningProduction {
    try Server(middleware: logger, responder: createRouter()).start()
} else {
//    let queue = NSOperationQueue()
//    queue.addOperationWithBlock {
//        try! Server(middleware: logger, responder: createRouter()).start()
//    }
}
