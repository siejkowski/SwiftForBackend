import PerfectLib

public func PerfectServerModuleInit() {
    
//    Routing.Handler.registerGlobally()
    
//    Routing.Routes["/qwe"] = { _ in return QweHandler() }
    
    PageHandlerRegistry.addPageHandler("DefaultHandler") {
        return DefaultHandler()
    }
    
    PageHandlerRegistry.addPageHandler("UploadHandler") {
        return UploadHandler()
    }
    
}

class QweHandler: RequestHandler {
    func handleRequest(request: WebRequest, response: WebResponse) {
        response.appendBodyString("qwe ftw")
        response.requestCompletedCallback()
    }
}

class DefaultHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        print("DefaultHandler got request")
        return MustacheEvaluationContext.MapType()
    }
}

class UploadHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        print("UploadHandler got request")
        
        var values = MustacheEvaluationContext.MapType()
        values["title"] = "swift"
        return values
    }
}



//public func PerfectServerModuleInit() {
//    
//    Routing.Handler.registerGlobally()
//    
//    print(PerfectServer.staticPerfectServer.homeDir())
//   
////    Routing.Routes["GET", "/"] = { _ in
////        return RootHandler()
////    }
//    
//    PageHandlerRegistry.addPageHandler("NullHandler") {
//        return NullHandler()
//    }
//
//    // register a route for gettings posts
//    Routing.Routes["GET", "/posts"] = { _ in
//        return GetPostHandler()
//    }
//    
//    // register a route for creating a new post
//    Routing.Routes["POST", "/posts"] = { _ in
//        return PostHandler()
//    }
//}
//
//class NullHandler: PageHandler { // all template handlers must inherit from PageHandler
//    
//    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
//        return MustacheEvaluationContext.MapType()
//    }
//    
//}
//
//class RootHandler : RequestHandler {
//    func handleRequest(request: WebRequest, response: WebResponse) {
//        response.appendBodyString("hello there")
//        response.requestCompletedCallback()
//    }
//}
//
//class GetPostHandler: RequestHandler {
//    func handleRequest(request: WebRequest, response: WebResponse) {
//        response.appendBodyString("get posts")
//        response.requestCompletedCallback()
//    }
//}
//
//class PostHandler: RequestHandler {
//    func handleRequest(request: WebRequest, response: WebResponse) {
//        response.appendBodyString("creating post")
//        response.requestCompletedCallback()
//    }
//}
