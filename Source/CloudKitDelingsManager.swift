import CloudKit

class CloudKitDelingsManager {
    private let container = CKContainer.default()
    private let privatDatabase = CKContainer.default().privateCloudDatabase
    private let brukerInnstillinger = BrukerInnstillingerManager.standard

    func delPost(postID: CKRecord.ID, ferdig: @escaping (CKShare?) -> Void) {
        privatDatabase.fetch(withRecordID: postID) { post, feil in
            guard let post = post else {
                print("Feil: Kunne ikke hente posten.")
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
                if let feil = lagringsFeil {
                    print("Feil ved lagring av CKShare: \(feil.localizedDescription)")
                } else {
                    print("Deling lagret: \(lagretDeling?.recordID.recordName ?? "Ukjent")")
                }
                ferdig(lagretDeling)
            }
        }
    }
}
