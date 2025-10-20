import ArgumentParser

@main
struct SwiftBot: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "🍃 SwiftBot – a Gemini‑powered AI CLI.",
        subcommands: [Generate.self, Summarize.self, Chat.self],
        defaultSubcommand: Generate.self
    )
}
