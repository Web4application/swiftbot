import Vapor

func routes(_ app: Application) throws {
app.get { req in
req.fileio.streamFile(at: app.directory.publicDirectory + "index.html")
}

app.post("ai") { req -> EventLoopFuture<Response> in
let input = try req.content.decode(Input.self)
let aiResponse = processAI(input.text)
return req.eventLoop.makeSucceededFuture(Response(message: aiResponse))
}
}

struct Input: Content {
let text: String
}

struct Response: Content {
let message: String
}

func processAI(_ text: String) -> String {
// Placeholder for AI processing logic
return "Processed: \(text)"
}

