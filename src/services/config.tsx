import Foundation

class ConfigManager {
    static let shared = ConfigManager()
    var apiKey: String?

    private init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            apiKey = dict["YourAPIKey"] as? String
        }
    }
}
