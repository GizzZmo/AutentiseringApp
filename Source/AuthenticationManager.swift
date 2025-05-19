import UIKit
import LocalAuthentication

class AutentiseringsManager {
    private let tilbakemeldingsGenerator = UIImpactFeedbackGenerator(style: .medium)

    func autentiserBruker(brukerID: String, ferdig: @escaping (Bool, String?) -> Void) {
        let kontekst = LAContext()
        var feil: NSError?
        let grunn = "Bekreft identiteten din for å få tilgang."
        kontekst.localizedFallbackTitle = "Bruk passkode"

        visAktivitetsindikator()
        tilbakemeldingsGenerator.impactOccurred() // Haptisk tilbakemelding

        // Sjekk om biometrisk autentisering er tilgjengelig
        if kontekst.canEvaluatePolicy(.deviceOwnerAuthentication, error: &feil) {
            kontekst.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: grunn) { suksess, evalFeil in
                DispatchQueue.main.async {
                    self.skjulAktivitetsindikator()
                    if suksess {
                        self.lagreAutentiseringsstatus(for: brukerID, erAutentisert: true)
                        ferdig(true, nil)
                    } else {
                        let feilMelding = self.håndterAutentiseringsfeil(evalFeil)
                        ferdig(false, feilMelding)
                    }
                }
            }
        } else {
            ferdig(false, "Biometrisk autentisering er ikke tilgjengelig. Vennligst bruk passkode.")
        }
    }

    private func håndterAutentiseringsfeil(_ feil: Error?) -> String {
        guard let feil = feil as? LAError else { return "Ukjent autentiseringsfeil." }

        switch feil.code {
        case .authenticationFailed:
            return "Autentisering mislyktes. Vennligst prøv igjen."
        case .userCancel:
            return "Autentisering avbrutt av bruker."
        case .biometryNotAvailable:
            return "Biometrisk autentisering er ikke tilgjengelig på denne enheten."
        case .biometryNotEnrolled:
            return "Ingen biometriske data er registrert. Vennligst sett opp Face ID eller Touch ID."
        default:
            return "En uventet feil oppstod."
        }
    }

    private func lagreAutentiseringsstatus(for brukerID: String, erAutentisert: Bool) {
        UserDefaults.standard.set(erAutentisert, forKey: "erAutentisert_\(brukerID)")
    }
}
