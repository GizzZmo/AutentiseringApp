import CloudKit
import UserNotifications

class CloudKitDelingsManager {
    private let privatDatabase = CKContainer.default().privateCloudDatabase
    private let brukerInnstillinger = BrukerInnstillingerManager.standard
    private var notifikasjonsLogg: [String] = []

    func delPost(postID: CKRecord.ID, ferdig: @escaping (CKShare?) -> Void) {
        privatDatabase.fetch(withRecordID: postID) { post, feil in
            if let feil = feil {
                print("Feil ved henting av post: \(feil.localizedDescription)")
                self.lagreNotifikasjonsLogg("Feil ved henting av post: \(feil.localizedDescription)")
                ferdig(nil)
                return
            }
            
            guard let post = post else {
                print("Posten ble ikke funnet.")
                self.lagreNotifikasjonsLogg("Posten ble ikke funnet.")
                ferdig(nil)
                return
            }

            let deling = CKShare(rootRecord: post)
            let valgtTillatelse = self.brukerInnstillinger.hentDelingstillatelse()

            // Sett tilgang basert på brukerens preferanse
            switch valgtTillatelse {
            case .kunLesing:
                deling.publicPermission = .readOnly
            case .lesOgSkriv:
                deling.publicPermission = .readWrite
            case .privat:
                deling.publicPermission = .none
            }

            privatDatabase.save(deling) { lagretDeling, lagringsFeil in
                if let lagringsFeil = lagringsFeil {
                    print("Feil ved lagring av deling: \(lagringsFeil.localizedDescription)")
                    self.lagreNotifikasjonsLogg("Feil ved lagring av deling: \(lagringsFeil.localizedDescription)")
                } else {
                    self.sendVarsling("Delingen er oppdatert!")
                    self.lagreNotifikasjonsLogg("Push-varsling sendt for oppdatert deling.")
                }
                ferdig(lagretDeling)
            }
        }
    }

    private func sendVarsling(_ melding: String) {
        let innhold = UNMutableNotificationContent()
        innhold.title = "AutentiseringApp"
        innhold.body = melding
        innhold.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let forespørsel = UNNotificationRequest(identifier: "delingVarsling", content: innhold, trigger: trigger)

        UNUserNotificationCenter.current().add(forespørsel)
    }
    
    private func lagreNotifikasjonsLogg(_ melding: String) {
        DispatchQueue.main.async {
            self.notifikasjonsLogg.append("\(Date()): \(melding)")
        }
    }
}
