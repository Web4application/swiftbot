import Foundation

struct Message: Identifiable {
    let id = UUID() // Unique identifier for each message
    let message: String // The content of the message
    let timestamp: Date // Optional: Time when the message was created
    
    init(message: String, timestamp: Date = Date()) {
        self.message = message
        self.timestamp = timestamp
    }
}
