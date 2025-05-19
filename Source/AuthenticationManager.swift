import UIKit
import LocalAuthentication

class AuthenticationManager {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    func authenticateUser(userID: String, completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        let reason = "Bekreft identiteten din for å få tilgang."
        context.localizedFallbackTitle = "Bruk passkode"

        showActivityIndicator()
        feedbackGenerator.impactOccurred() // Haptisk tilbakemelding

        // Check if biometrics are available
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evalError in
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    if success {
                        self.saveAuthenticationStatus(for: userID, isAuthenticated: true)
                        completion(true, nil)
                    } else {
                        let errorMessage = self.handleAuthenticationError(evalError)
                        completion(false, errorMessage)
                    }
                }
            }
        } else {
            completion(false, "Biometric authentication unavailable. Please use password login.")
        }
    }

    private func handleAuthenticationError(_ error: Error?) -> String {
        guard let error = error as? LAError else { return "Unknown authentication error." }

        switch error.code {
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .userCancel:
            return "Authentication canceled by user."
        case .biometryNotAvailable:
            return "Biometric authentication is not available on this device."
        case .biometryNotEnrolled:
            return "No biometric data is enrolled. Please set up Face ID or Touch ID."
        default:
            return "An unexpected error occurred."
        }
    }

    private func saveAuthenticationStatus(for userID: String, isAuthenticated: Bool) {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated_\(userID)")
    }
}
