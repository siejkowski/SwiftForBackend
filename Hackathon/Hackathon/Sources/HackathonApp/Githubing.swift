import HTTPSClient
import JSON

public class GithubClient {
    
    private let paths = [
        "Kitura" : "/repos/IBM-Swift/Kitura",
        "Perfect" : "/repos/perfectlysoft/perfect",
        "Vapor" : "/repos/qutheory/vapor",
        "Zewo" : "/repos/zewo/zewo",
        "Curassow" : "/repos/kylef/Curassow",
        "Swifter" : "/repos/httpswift/swifter",
        "Taylor" : "/repos/izqui/Taylor",
        "Swifton" : "/repos/necolt/Swifton",
        "Express" : "/repos/crossroadlabs/Express",
        "Nest" : "/repos/nestproject/nest",
        "Blackfish" : "/repos/elliottminns/blackfish",
        "Dynamo" : "/repos/johnno1962/Dynamo",
        "Kunugi" : "/repos/novi/Kunugi",
        "Trevi" : "/repos/Trevi-Swift/Trevi"
    ]
    
    private let headers: Headers = ["User-Agent": "sfb"]
 
    private let client: HTTPSClient.Client
    
    public init() throws {
        self.client = try HTTPSClient.Client(host: "api.github.com", port: 443)
    }
    
    public func fetchStars(progressCallback: (String, Int) -> ()) -> [String : Int] {
        var result: [String : Int] = [:]
        for (name, path) in paths {
            let _ = getStarsForPath(path).map { stars in
                progressCallback(name, stars)
                return stars
            }
            .map { result[name] = $0 }
        }
        return result
    }
    
    private func getStarsForPath(path: String) -> Int? {
        do {
            let response = try client.get(path, headers: headers)
            guard let body = response.body.buffer else { throw SlackClientError() }
            let json = try JSONParser().parse(body).asDictionary()
            return try json["stargazers_count"]?.asInt()
        } catch {
            return .None
        }
    }
    
    
}
