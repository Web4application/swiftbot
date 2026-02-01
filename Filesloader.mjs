import Foundation
import PDFKit   // only used when available

enum FileLoader {
    static func load(path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        switch url.pathExtension.lowercased() {
        case "pdf":
            guard
                let pdf = PDFDocument(url: url),
                let pageText = (0..<pdf.pageCount)
                    .compactMap({ pdf.page(at: $0)?.string })
                    .joined(separator: "\n")
            else { throw CocoaError(.fileReadCorruptFile) }
            return pageText
        default:
            return try String(contentsOf: url)
        }
    }
}

enum Env {
    static var apiKey: String {
        guard let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !key.isEmpty
        else { fatalError("❌ Set GEMINI_API_KEY in your environment.") }
        return key
    }
}
