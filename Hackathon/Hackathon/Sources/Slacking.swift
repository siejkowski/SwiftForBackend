import WebSocket
import HTTPSClient
import JSON

struct SlackClientError : ErrorType {}

public class SlackClient {

    private let headers: Headers = ["Content-Type": "application/x-www-form-urlencoded"]
    
    private let slackToken = "xoxb-29685368228-tkILhjUEkq3F6qSBahe0Kw1W"
    
    private let rtmAPIPath = "/api/rtm.start"
    
    private let client: HTTPSClient.Client
    
    public init() throws {
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
            try self.postToSlack(self.client, channel: channel)
        }
    }
    
    private func obtainWebSockerUri() throws -> URI {
        let response = try self.client.post(rtmAPIPath, headers: headers, body: "token=\(slackToken)")
        guard let body = response.body.buffer else { throw SlackClientError() }
        let json = try JSONParser().parse(body).asDictionary()
        guard let url = try json["url"]?.asString() else { throw SlackClientError() }
        return try URI(string: url)
    }

    private func postToSlack(client: HTTPSClient.Client, channel: String) throws {
        try client.post("/api/chat.postMessage", headers: headers, body: "token=xoxb-29685368228-tkILhjUEkq3F6qSBahe0Kw1W&channel=\(channel)&text=\("elo elo elo!")")
    }

}