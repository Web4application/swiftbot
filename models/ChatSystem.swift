import SwiftUI
import Foundation

/// Represents a single message in the chat history.
struct Message: Identifiable {
    let id = UUID()
    let message: String
    let timestamp: Date
    
    init(message: String, timestamp: Date = Date()) {
        self.message = message
        self.timestamp = timestamp
    }
}

/// Manages the interaction between the user and the AI model, maintaining chat history.
@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
public class Chat: ObservableObject {
    private let model: GenerativeModel

    /// Maintains the chat history for the current session.
    @Published public var history: [ModelContent]

    /// Initializes a new `Chat` instance.
    init(model: GenerativeModel, history: [ModelContent] = []) {
        self.model = model
        self.history = history
    }

    /// Sends a message using the existing history as context, returning the response.
    public func sendMessage(_ parts: any ThrowingPartsRepresentable...) async throws -> GenerateContentResponse {
        return try await sendMessage([ModelContent(parts: parts)])
    }

    /// Handles the actual sending logic, appending new messages and responses to the history.
    public func sendMessage(_ content: @autoclosure () throws -> [ModelContent]) async throws -> GenerateContentResponse {
        let newContent = try content().map { content in
            ModelContent(role: content.role ?? "user", parts: content.parts)
        }

        let request = history + newContent
        let result = try await model.generateContent(request)

        guard let reply = result.candidates.first?.content else {
            throw NSError(domain: "RODA AI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No content available."])
        }

        history.append(contentsOf: newContent)
        history.append(ModelContent(role: "model", parts: reply.parts))
        return result
    }
}

/// Handles the business logic for the chat UI, bridging the UI and backend chat logic.
class FunctionCallingViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var busy: Bool = false
    @Published var recognizedText: String = ""
    @Published var hasError: Bool = false
    @Published var error: Error?

    private let chat: Chat

    init(chat: Chat) {
        self.chat = chat
    }

    /// Starts speech recognition (placeholder implementation).
    func startRecognition() {
        busy = true
        recognizedText = ""

        // Simulating recognition delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.recognizedText = "Hello, how can I assist you?"
            self.busy = false
        }
    }

    /// Sends a message to the AI model and processes the response.
    func sendMessage(_ text: String) async {
        busy = true
        let newMessage = Message(message: text)
        messages.append(newMessage)

        do {
            let response = try await chat.sendMessage(ModelContent(role: "user", parts: [.text(text)]))
            if let replyText = response.candidates.first?.content.parts.compactMap({ part in
                switch part {
                case .text(let string): return string
                default: return nil
                }
            }).joined() {
                messages.append(Message(message: replyText))
            }
        } catch {
            self.hasError = true
            self.error = error
        }

        busy = false
    }
}

/// Represents the user interface for interacting with RODA AI.
struct ContentView: View {
    @StateObject private var viewModel: FunctionCallingViewModel

    init(chat: Chat) {
        _viewModel = StateObject(wrappedValue: FunctionCallingViewModel(chat: chat))
    }

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                Text(message.message)
            }

            if viewModel.busy {
                ProgressView()
            } else {
                HStack {
                    TextField("Type your message...", text: $viewModel.recognizedText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Send") {
                        Task {
                            await viewModel.sendMessage(viewModel.recognizedText)
                        }
                    }
                    .padding()
                    .disabled(viewModel.recognizedText.isEmpty)
                }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }
}
