import Speech
import AVFoundation
import CoreML

class SpeechRecognitionManager: ObservableObject {
    @Published var recognizedText = ""
    @Published var isRecording = false // Visual indicator for recording state
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechSynthesizer = AVSpeechSynthesizer() // TTS engine for real-time feedback
    
    // Starts the process of speech recognition
    func startRecognition() {
        requestAuthorization()
    }
    
    // Requests permission to use speech recognition
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startRecording()
                case .denied, .restricted, .notDetermined:
                    self.speakFeedback("Speech recognition authorization is denied or not allowed.")
                @unknown default:
                    fatalError("Unknown speech recognition authorization status.")
                }
            }
        }
    }

    // Starts recording audio and processes it for transcription and voice verification
    private func startRecording() {
        if audioEngine.isRunning {
            stopRecording()
            return
        }
        
        isRecording = true
        speakFeedback("Starting speech recognition.")
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a recognition request.")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                // Real-time spoken feedback for recognized speech
                self.speakFeedback("You said: \(self.recognizedText)")
                // Example: Execute commands based on recognized text
                self.executeCommand(from: self.recognizedText)
            }
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            if self.verifyUserVoice(buffer: buffer) {
                self.recognitionRequest?.append(buffer)
            }
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            speakFeedback("Audio engine failed to start.")
            print("Audio engine could not start: \(error.localizedDescription)")
        }
    }

    // Stops recording and ends the recognition task
    private func stopRecording() {
        isRecording = false
        speakFeedback("Stopping speech recognition.")
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
    }

    // Verifies if the input audio matches the intended user's voice
    private func verifyUserVoice(buffer: AVAudioPCMBuffer) -> Bool {
        // Placeholder for voice verification logic
        return true
    }

    // Provides real-time spoken feedback using text-to-speech
    private func speakFeedback(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    // Example: Executes a command based on recognized text
    private func executeCommand(from text: String) {
        switch text.lowercased() {
        case "turn on the light":
            speakFeedback("Turning on the light.")
            // Add code to integrate with smart home APIs here
        case "what's the weather":
            speakFeedback("Fetching the weather information.")
            // Integrate with a weather API and respond accordingly
        default:
            speakFeedback("Sorry, I didn't understand that command.")
        }
    }

    // Saves the recognized transcription to a file
    func saveTranscription(to fileName: String) {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try recognizedText.write(to: fileURL, atomically: true, encoding: .utf8)
            speakFeedback("Transcription saved successfully.")
            print("Transcription saved at: \(fileURL)")
        } catch {
            speakFeedback("Failed to save transcription.")
            print("Failed to save transcription: \(error.localizedDescription)")
        }
    }
}
