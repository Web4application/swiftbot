import Foundation

/// Represents the result of content generation.
struct GenerateContentResponse {
    struct Candidate {
        let content: ModelContent
    }

    let candidates: [Candidate]
}

/// Represents an error that may occur during content generation.
enum GenerateContentError: Error {
    case invalidRequest
    case networkError(underlying: Error)
    case modelError(underlying: Error)

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "The request was invalid."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .modelError(let error):
            return "Model error: \(error.localizedDescription)"
        }
    }
}

/// A protocol for parts of a message that can be represented in the chat.
protocol ThrowingPartsRepresentable {}

/// Represents content sent to or received from the AI model.
struct ModelContent {
    enum Part {
        case text(String)
        case other(Data) // Extend for multimedia, etc.
    }

    let role: String? // "user", "model", etc.
    let parts: [Part]
}

/// Handles the generation of content using an AI model.
class GenerativeModel {
    private let apiEndpoint: URL
    private let apiKey: String

    /// Initializes a `GenerativeModel` instance.
    init(apiEndpoint: URL, apiKey: String) {
        self.apiEndpoint = apiEndpoint
        self.apiKey = apiKey
    }

    /// Sends a content generation request and returns the response.
    func generateContent(_ content: [ModelContent]) async throws -> GenerateContentResponse {
        var request = URLRequest(url: apiEndpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // Convert `ModelContent` into a format expected by the API
        let payload = content.map { modelContent in
            [
                "role": modelContent.role ?? "user",
                "content": modelContent.parts.compactMap { part in
                    switch part {
                    case .text(let text):
                        return text
                    default:
                        return nil
                    }
                }.joined()
            ]
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: ["messages": payload])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw GenerateContentError.invalidRequest
            }

            // Parse the response into a `GenerateContentResponse`
            let decodedResponse = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
            return decodedResponse
        } catch {
            throw GenerateContentError.networkError(underlying: error)
        }
    }

    /// Streams content generation results in real time.
    func generateContentStream(_ content: [ModelContent]) -> AsyncThrowingStream<GenerateContentResponse, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let response = try await generateContent(content)
                    continuation.yield(response)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
