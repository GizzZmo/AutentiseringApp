import CloudKit

class CloudKitDelingsManager {
    private let container = CKContainer.default()
    private let privatDatabase = CKContainer.default().privateCloudDatabase

    func delPost(postID: CKRecord.ID, ferdig: @escaping (CKShare?) -> Void) {
        privatDatabase.fetch(withRecordID: postID) { post, feil in
            guard let post = post else {
                ferdig(nil)
                return
            }
            
            let deling = CKShare(rootRecord: post)
            deling.publicPermission = .readWrite

            // Sjekk tilgang for deltaker
            guard let deltaker = deling.currentUserParticipant else {
                ferdig(nil)
                return
            }
            
            deltaker.permission = .readOnly
            
            privatDatabase.save(deling) { lagretDeling, lagringsFeil in
                if let feil = lagringsFeil {
                    print("Feil ved lagring av CKShare: \(feil.localizedDescription)")
                }
                ferdig(lagretDeling)
            }
        }
    }
}
