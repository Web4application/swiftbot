import ArgumentParser
import GoogleGenerativeAI

struct Generate: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Generate fresh content from a prompt."
    )

    @Option(name: .shortAndLong, help: "Model name (e.g. gemini-2.5-pro)")
    var model: String = "gemini-2.5-pro"

    @Argument(help: "Prompt text.")
    var prompt: String

    func run() async throws {
        let genAI = GenerativeAI(apiKey: Env.apiKey)
        let response = try await genAI.text(model: model, prompt: prompt)
        print(response.text)
    }
}
