import Foundation

class UserSettingsManager {
    static let shared = UserSettingsManager()

    func saveUserPreference(for userID: String, key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: "\(userID)_\(key)")
    }

    func getUserPreference(for userID: String, key: String) -> Any? {
        return UserDefaults.standard.object(forKey: "\(userID)_\(key)")
    }
}
