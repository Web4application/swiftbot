import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FunctionCallingViewModel()

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                Text(message.message)
                    .onTapGesture {
                        // Example usage of the API key
                        if let apiKey = ConfigManager.shared.apiKey {
                            print("API Key: \(apiKey)")
                            // Use the API key here
                        }
                    }
            }

            if viewModel.busy {
                ProgressView()
            } else {
                Button("Speak") {
                    viewModel.startRecognition()
                }
                .padding()
            }
        }
        .onChange(of: viewModel.recognizedText) { newText in
            if !newText.isEmpty {
                Task {
                    await viewModel.sendMessage(newText)
                }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

class FunctionCallingViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var busy: Bool = false
    @Published var recognizedText: String = ""
    @Published var hasError: Bool = false
    @Published var error: Error?

    func startRecognition() {
        // Start recognition logic
    }

    func sendMessage(_ text: String) async {
        // Send message logic
    }
}

struct Message: Identifiable {
    let id = UUID()
    let message: String
}
