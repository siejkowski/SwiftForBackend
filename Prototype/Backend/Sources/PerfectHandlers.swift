import PerfectLib

// This function is required. The Perfect framework expects to find this function
// to do initialization
public func PerfectServerModuleInit() {
    
    // Install the built-in routing handler. 
    // This is required by Perfect to initialize everything
    Routing.Handler.registerGlobally()
   
    Routing.Routes["GET", "/"] = { _ in 
        return RootHandler()
    }

    // register a route for gettings posts
    Routing.Routes["GET", "/posts"] = { _ in
        return GetPostHandler()
    }
    
    // register a route for creating a new post
    Routing.Routes["POST", "/posts"] = { _ in
        return PostHandler()
    }
}

class RootHandler : RequestHandler {
    func handleRequest(request: WebRequest, response: WebResponse) {
        response.appendBodyString("hello there")
        response.requestCompletedCallback()
    }
}

class GetPostHandler: RequestHandler {
    func handleRequest(request: WebRequest, response: WebResponse) {
        response.appendBodyString("get posts")
        response.requestCompletedCallback()
    }
}

class PostHandler: RequestHandler {
    func handleRequest(request: WebRequest, response: WebResponse) {
        response.appendBodyString("creating post")
        response.requestCompletedCallback()
    }
}
