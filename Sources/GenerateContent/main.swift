import ArgumentParser
import GoogleGenerativeAI

@main
struct SwiftBot: AsyncParsableCommand {
    @Option var model: String
    @Argument var prompt: String

    mutating func run() async throws {
        let genAI = GenerativeAI(apiKey: ProcessInfo.processInfo.environment["GEMINI_API_KEY"]!)
        let response = try await genAI.text(model: model, prompt: prompt)
        print(response.text)
    }
}
