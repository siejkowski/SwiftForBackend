import Foundation
import UIKit

class ApplicationController {
    
    private lazy var window: UIWindow = UIWindow()
    private lazy var apiClient = APIClient(
        session: NSURLSession.sharedSession(),
        configuration: APIConfiguration(scheme: "http", host: "localhost", port: 8080)
    )
    
    func kickOff() {
        window.rootViewController = ViewController(apiClient: self.apiClient)
        window.makeKeyAndVisible()
    }
    
}