import UIKit
import LocalAuthentication

class AuthenticationManager {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    func authenticateUser(userID: String) {
        let context = LAContext()
        let reason = "Bekreft identiteten din for å få tilgang."
        context.localizedFallbackTitle = "Bruk passkode"
        
        showActivityIndicator()
        feedbackGenerator.impactOccurred() // Haptisk tilbakemelding
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    if success {
                        self.saveAuthenticationStatus(for: userID, isAuthenticated: true)
                    }
                }
            }
        }
    }
    
    private func saveAuthenticationStatus(for userID: String, isAuthenticated: Bool) {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated_\(userID)")
    }
}
