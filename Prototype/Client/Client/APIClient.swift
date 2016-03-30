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
    
    func fetchAllData(callback: ([(String, String)]) -> ()) {
        guard let request = requestWithPath("/users") else { return }
        request.HTTPMethod = "GET"
        performRequest(request) { data, response, error in
            if let data = data,
                let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String : String]] {
                dispatch_async(dispatch_get_main_queue()) {
                    let tuples = json.filter { $0.first != nil }
                                    .map { ($0.first!.0, $0.first!.1) }
                    callback(tuples)
                }
            }
        }
    }
    
    func postData(title: String, callback: () -> ()) {
        guard let data = "{\"content\":\"\(title)\"}".dataUsingEncoding(NSUTF8StringEncoding),
              let request = requestWithPath("/user")
        else { return }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        performRequest(request) { data, response, error in
            print(String(data: data ?? NSData(), encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue()) {
                callback()
            }
        }
    }
    
    func removeData(id: String, callback: () -> ()) {
        guard let request = requestWithPath("/user/\(id)") else { return }
        request.HTTPMethod = "DELETE"
        performRequest(request) { data, response, error in
            print(String(data: data ?? NSData(), encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue()) {
                callback()
            }
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
