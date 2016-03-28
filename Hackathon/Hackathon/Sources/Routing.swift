import Router
import HTTPFile
import Mustache

let resourcePath = "./public"

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
