import ArgumentParser
import GoogleGenerativeAI

struct Summarize: AsyncParsableCommand {
    @Option var model: String = "gemini-2.5-pro"
    @Argument(help: "Path to a Markdown, PDF, or plain‑text file.")
    var filePath: String

    func run() async throws {
        let body = try FileLoader.load(path: filePath)
        let prompt = "Summarize the following document in bullet points:\n\n\(body)"
        let ai = GenerativeAI(apiKey: Env.apiKey)
        let response = try await ai.text(model: model, prompt: prompt)
        print(response.text)
    }
}
