import UIKit
import LocalAuthentication
import Security

class AuthenticationManager {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let maxFeilForsøk = 3
    private var feilForsøk = UserDefaults.standard.integer(forKey: "FeilForsøk")

    func autentiserBruker(brukerID: String, passord: String?, ferdig: @escaping (Bool, String?) -> Void) {
        guard feilForsøk < maxFeilForsøk else {
            ferdig(false, "Kontoen er låst etter flere mislykkede forsøk.")
            return
        }

        let kontekst = LAContext()
        let grunn = "Bekreft identiteten din for å få tilgang."
        kontekst.localizedFallbackTitle = "Bruk passord"

        visAktivitetsindikator()
        feedbackGenerator.impactOccurred()

        // Biometrisk autentisering først
        if kontekst.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            kontekst.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: grunn) { suksess, evalFeil in
                DispatchQueue.main.async {
                    self.skjulAktivitetsindikator()
                    if suksess {
                        self.lagreAutentiseringsstatus(for: brukerID, erAutentisert: true)
                        ferdig(true, nil)
                    } else {
                        self.håndterFallbackAutentisering(brukerID: brukerID, passord: passord, ferdig: ferdig)
                    }
                }
            }
        } else {
            håndterFallbackAutentisering(brukerID: brukerID, passord: passord, ferdig: ferdig)
        }
    }

    private func håndterFallbackAutentisering(brukerID: String, passord: String?, ferdig: @escaping (Bool, String?) -> Void) {
        guard let lagretPassord = hentPassordFraKeychain(for: brukerID) else {
            ferdig(false, "Ingen lagret passord funnet.")
            return
        }

        if passord == lagretPassord {
            feilForsøk = 0
            UserDefaults.standard.set(feilForsøk, forKey: "FeilForsøk")
            ferdig(true, nil)
        } else {
            feilForsøk += 1
            UserDefaults.standard.set(feilForsøk, forKey: "FeilForsøk")

            if feilForsøk >= maxFeilForsøk {
                ferdig(false, "Kontoen er låst. Tilbakestill passord for tilgang.")
            } else {
                ferdig(false, "Feil passord. Forsøk igjen.")
            }
        }
    }

    private func lagreAutentiseringsstatus(for brukerID: String, erAutentisert: Bool) {
        let statusData = "\(erAutentisert)".data(using: .utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: brukerID,
            kSecValueData as String: statusData!
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    func tilbakestillPassord(brukerID: String, nyttPassord: String) {
        lagrePassordTilKeychain(for: brukerID, passord: nyttPassord)
        feilForsøk = 0
        UserDefaults.standard.set(feilForsøk, forKey: "FeilForsøk")
    }

    private func lagrePassordTilKeychain(for brukerID: String, passord: String) {
        let data = passord.data(using: .utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: brukerID,
            kSecValueData as String: data!
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func hentPassordFraKeychain(for brukerID: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: brukerID,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
