import Foundation
import Speech
import AVFoundation

enum Participant {
    case system
    case user
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var message: String
    let participant: Participant
    var pending = false

    static func pending(participant: Participant) -> ChatMessage {
        Self(message: "", participant: participant, pending: true)
    }
}

extension ChatMessage {
    static var samples: [ChatMessage] = [
        .init(message: "Hello. What can I do for you today?", participant: .system),
        .init(message: "Show me a simple loop in Swift.", participant: .user),
        .init(message: """
        Sure, here is a simple loop in Swift:

        # Example 1
        ```
        for i in 1...5 {
            print("Hello, world!")
        }
        ```

        This loop will print the string "Hello, world!" five times. The for loop iterates over a range of numbers,
        in this case the numbers from 1 to 5. The variable i is assigned each number in the range, and the code inside the loop is executed.

        **Here is another example of a simple loop in Swift:**
        ```swift
        var sum = 0
        for i in 1...100 {
            sum += i
        }
        print("The sum of the numbers from 1 to 100 is \\(sum).")
        ```

        This loop calculates the sum of the numbers from 1 to 100. The variable sum is initialized to 0, and then the for loop iterates over the range of numbers from 1 to 100. The variable i is assigned [...]
        """, participant: .system),
    ]

    static var sample = samples[0]
}

class SpeechService: NSObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private let request = SFSpeechAudioBufferRecognitionRequest()

    func startSpeechRecognition(completion: @escaping (String?) -> Void) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            completion(nil)
            return
        }

        let inputNode = audioEngine.inputNode
        let recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                completion(result.bestTranscription.formattedString)
            } else {
                completion(nil)
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }
}

class TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}

// Example usage
let speechService = SpeechService()
let textToSpeechService = TextToSpeechService()

speechService.startSpeechRecognition { recognizedText in
    if let text = recognizedText {
        // Process the recognized text and generate response
        let response = "You said: \(text)"
        textToSpeechService.speak(text: response)
    }
}
