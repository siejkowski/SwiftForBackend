import Foundation
import UIKit

class APIClient {
    
    typealias Callback = (NSData?, NSURLResponse?, NSError?) -> Void
    
    private let session: NSURLSession
    private let configuration: APIConfiguration
    
    init(session: NSURLSession, configuration: APIConfiguration) {
        self.session = session
        self.configuration = configuration
    }
    
    func fetchAllData() {
        guard let request = requestWithPath("/data") else { return }
        request.HTTPMethod = "GET"
        performRequest(request) { data, response, error in
            print(data)
        }
    }
    
    func postData(data: NSData) {
        guard let request = requestWithPath("/data") else { return }
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        performRequest(request) { data, response, error in
            print(data)
        }
    }
    
    private func requestWithPath(path: String) -> NSMutableURLRequest? {
        let components = NSURLComponents()
        components.scheme = configuration.scheme
        components.host = configuration.host
        components.port = configuration.port
        components.path = path
        return components.URL.map { NSMutableURLRequest(URL: $0) }
    }
    
    private func performRequest(request: NSURLRequest, callback: Callback) {
        let task = self.session.dataTaskWithRequest(request, completionHandler: callback)
        task.resume()
    }
    
}
