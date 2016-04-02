import WebSocket
import HTTPSClient
import JSON

struct SlackClientError : ErrorType {}

public class SlackClient {

    private let headers: Headers = ["Content-Type": "application/x-www-form-urlencoded"]
    
    private let slackToken = "INSERT_YOUR_SLACK_API_TOKEN_HERE"
    
    private let rtmAPIPath = "/api/rtm.start"
    
    private let client: HTTPSClient.Client
    
    private let githubClient: GithubClient
    
    public init(githubClient: GithubClient) throws {
        self.githubClient = githubClient
        self.client = try HTTPSClient.Client(host: "slack.com", port: 443)
    }

    public func connectToSlack() throws {
        let uri = try self.obtainWebSockerUri()
        let sc = try WebSocket.Client(ssl: true, host: uri.host!, port: 443) {
            (socket: Socket) throws -> Void in
            self.setupSocket(socket)
        }
        sc.connectInBackground(uri.path!)
    }
    
    private func setupSocket(socket: Socket) {
        socket.onText { (message: String) in try self.parseSlackEvent(message) }
        socket.onPing { (data) in try socket.pong() }
        socket.onPong { (data) in try socket.ping() }
        socket.onBinary { (data) in print(data) }
        socket.onClose { (code: CloseCode?, reason: String?) in
            print("close with code: \(code ?? .NoStatus), reason: \(reason ?? "no reason")")
        }
    }
    
    private func parseSlackEvent(message: String) throws {
        let eventDict = try JSONParser().parse(message.data).asDictionary()
        guard let type = eventDict["type"]?.string,
              let text = eventDict["text"]?.string,
              let channel = eventDict["channel"]?.string
        else { return }
        if type == "message" && text == "sfb" {
            self.postToSlack(channel)
        }
    }
    
    private func obtainWebSockerUri() throws -> URI {
        let response = try self.client.post(
            rtmAPIPath,
            headers: headers,
            body: "token=\(slackToken)"
        )
        guard let body = response.body.buffer else { throw SlackClientError() }
        let json = try JSONParser().parse(body).asDictionary()
        guard let url = try json["url"]?.asString() else { throw SlackClientError() }
        return try URI(string: url)
    }

    private func postToSlack(channel: String) {
        self.postMessage(channel, text: "Just a sec!")
        let results = self.githubClient.fetchStars { name, stars in
            self.postMessage(channel, text: "Fetching \(name) data from Github...")
        }
        self.postMessage(channel, text: messageFromResults(results))
    }
    
    private func messageFromResults(results: [String: Int]) -> String {
        return results.sort { (r1, r2) -> Bool in
            let (n1, s1) = r1
            let (n2, s2) = r2
            if s1 == s2 { return n1 < n2 }
            else { return s1 > s2 }
        }.reduce("The final score is:") { acc, elem in
            let (name, stars) = elem
            return acc + "\n\(name): \(stars) 🌟"
        }
    }
    
    private func postMessage(channel: String, text: String) {
        do {
            try self.client.post("/api/chat.postMessage", headers: headers, body: "token=\(slackToken)&channel=\(channel)&text=\(text)")
        } catch {}
    }

}
