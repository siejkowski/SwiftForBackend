import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import Mustache
import Foundation
import WebSocket
import HTTPSClient
import JSON

let resourcePath = "./public"

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
        
//        route.get("/slack") { request in
        
//        }
        
        route.fallback(responder: FileResponder(basePath: resourcePath))
    }
}

func connectToSlack() throws {
    let client = try Client(host: "slack.com", port: 443)
    let headers: Headers = ["Content-Type": "application/x-www-form-urlencoded"]
    let response = try client.post("/api/rtm.start", headers: headers, body: "token=xoxb-29685368228-tkILhjUEkq3F6qSBahe0Kw1W")
    let json = try JSONParser().parse(response.body.buffer!)
    let url = try json.asDictionary()["url"]?.asString()
    let uri = try URI(string: url!)
    print(uri.host!)
    print(uri.path!)
    let c: Socket throws -> Void = { (socket: Socket) throws -> Void in
        socket.onText { (message: String) in
            print(message)
            do {
                let event = try JSONParser().parse(message.data)
                let eventDict: [String: JSON] = try event.asDictionary()
                guard let type = eventDict["type"],
                    let text = eventDict["text"],
                    let channel = eventDict["channel"]
                    else {
                        return
                }
                if type.string! == "message" && text.string! == "sfb" {
                    try client.post("/api/chat.postMessage", headers: headers, body: "token=xoxb-29685368228-tkILhjUEkq3F6qSBahe0Kw1W&channel=\(channel.string!)&text=\("elo elo elo!")")
                }
            } catch {
                print("error \(error)")
            }
        }
        socket.onPing { (data) in
            print("got ping!")
            try! socket.pong()
            print("send pong!")
        }
        socket.onPong { (data) in
            print("got pong!")
            try! socket.ping()
            print("send ping!")
        }
        socket.onBinary { (data) in
            print("binary")
        }
        socket.onClose { (code: CloseCode?, reason: String?) in
            print("close with code: \(code ?? .NoStatus), reason: \(reason ?? "no reason")")
        }
    }
    let sc = try Client(ssl: true, host: uri.host!, port: 443, onConnect: c)
    sc.connectInBackground(uri.path!)
}

let isRunningProduction = NSClassFromString("XCTestCase") == nil

if isRunningProduction {
//    try connectToSlack()
    try Server(responder: createRouter()).start()
} else {
    //    let queue = NSOperationQueue()
    //    queue.addOperationWithBlock {
    //        try! Server(middleware: logger, responder: createRouter()).start()
    //    }
}

