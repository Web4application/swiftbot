import SwiftUI

class FunctionCallingViewModel: ObservableObject {
    // Published properties to update the UI
    @Published var messages: [Message] = [] // Array of messages displayed in the UI
    @Published var busy: Bool = false // Indicates if a process is ongoing
    @Published var recognizedText: String = "" // Captures recognized speech text
    @Published var hasError: Bool = false // Flag to trigger error alert
    @Published var error: Error? // Holds the error information

    // Start speech recognition logic
    func startRecognition() {
        // Example logic for speech recognition, replace with actual implementation
        busy = true
        recognizedText = "" // Clear any previous recognized text

        // Simulating speech recognition delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.recognizedText = "Hello, how can I assist you?"
            self.busy = false
        }
    }

    // Send recognized text or user input message to a service
    func sendMessage(_ text: String) async {
        busy = true
        let newMessage = Message(message: text)
        messages.append(newMessage)

        // Simulate an API call or message processing
        do {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // Simulated delay
            let responseMessage = Message(message: "You said: \(text)")
            messages.append(responseMessage)
        } catch {
            self.hasError = true
            self.error = error
        }
        busy = false
    }
}
