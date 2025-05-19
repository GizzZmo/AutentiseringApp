import CloudKit
import UserNotifications

class CloudKitDelingsManager {
    private let privatDatabase = CKContainer.default().privateCloudDatabase
    private let brukerInnstillinger = BrukerInnstillingerManager.standard

    func delPost(postID: CKRecord.ID, ferdig: @escaping (CKShare?) -> Void) {
        privatDatabase.fetch(withRecordID: postID) { post, feil in
            guard let post = post else {
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
                if lagringsFeil == nil {
                    self.sendVarsling("Delingen er oppdatert!")
                    self.oppdaterCloudKitData()
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

    private func oppdaterCloudKitData() {
        let delingsSpørring = CKQuery(recordType: "SharingData", predicate: NSPredicate(value: true))
        privatDatabase.perform(delingsSpørring, inZoneWith: nil) { result, feil in
            if let feil = feil {
                print("Feil ved oppdatering av CloudKit-data: \(feil.localizedDescription)")
            } else {
                print("CloudKit-data oppdatert.")
            }
        }
    }
}
