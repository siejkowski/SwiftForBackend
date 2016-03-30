import HTTPServer
import LogMiddleware
import Router
import HackathonApp

let log = Log()
let logger = LogMiddleware(log: log)

let slackClient = try SlackClient(githubClient: GithubClient())
try slackClient.connectToSlack()
try Server(responder: createRouter()).start()
