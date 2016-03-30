import PerfectLib

public func PerfectServerModuleInit() {
    
    PageHandlerRegistry.addPageHandler("DefaultHandler") {
        return DefaultHandler()
    }
    
    PageHandlerRegistry.addPageHandler("UploadHandler") {
        return UploadHandler()
    }
    
}

class DefaultHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        return [:]
    }
}

class UploadHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        var values = MustacheEvaluationContext.MapType()
        let title = context.webRequest?.queryParams.filter { $0.0 == "name" }.first?.1
        values["title"] = title ?? "swift"
        return values
    }
}
