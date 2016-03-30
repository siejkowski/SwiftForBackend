import Foundation
import UIKit

class ApplicationController {
    
    private lazy var window: UIWindow = UIWindow()
    private lazy var apiClient = APIClient(
        session: NSURLSession.sharedSession(),
        configuration: APIConfiguration(scheme: "http", host: "192.168.99.100", port: 8080)
    )
    
    func kickOff() {
        window.rootViewController = UINavigationController(rootViewController: ViewController(apiClient: self.apiClient)) 
        window.makeKeyAndVisible()
    }
    
}