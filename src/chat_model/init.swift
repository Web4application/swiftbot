import ArgumentParser
import GoogleGenerativeAI

struct Chat: AsyncParsableCommand {
    @Option var model: String = "gemini-2.5-pro"

    mutating func run() async throws {
        print("💬  Enter 'exit' to quit.")
        let ai = GenerativeAI(apiKey: Env.apiKey)
        var history: [Message] = []

        while let line = readLine(strippingNewline: true) {
            if line.lowercased() == "exit" { break }
            history.append(.init(role: .user, content: line))
            let response = try await ai.chat(model: model, history: history)
            print("🤖", response.text)
            history.append(.init(role: .assistant, content: response.text))
        }
    }
}
