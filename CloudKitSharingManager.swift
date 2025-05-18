import CloudKit

class CloudKitSharingManager {
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    func shareRecord(recordID: CKRecord.ID, completion: @escaping (CKShare?) -> Void) {
        privateDatabase.fetch(withRecordID: recordID) { record, error in
            guard let record = record else {
                completion(nil)
                return
            }

            let share = CKShare(rootRecord: record)
            share.publicPermission = .readWrite
            let participant = CKShare.Participant()
            participant.permission = .readOnly
            share.addParticipant(participant)

            self.privateDatabase.save(share) { savedShare, _ in
                completion(savedShare)
            }
        }
    }
}



📜 CloudKitSubscriptionManager.swift
import CloudKit

class CloudKitSubscriptionManager {
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    func createSubscription() {
        let subscription = CKQuerySubscription(
            recordType: "UserData",
            predicate: NSPredicate(value: true),
            options: [.firesOnRecordCreation, .firesOnRecordUpdate]
        )

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        privateDatabase.save(subscription) { _, _ in }
    }
}



📜 UserSettingsManager.swift
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



📜 SharingSettingsView.swift
import SwiftUI
import CloudKit

struct SharingSettingsView: View {
    @State private var selectedParticipant: CKShare.Participant?
    @State private var showConfirmation = false
    var participants: [CKShare.Participant] = []

    var body: some View {
        List(participants, id: \.userIdentity) { participant in
            Button(action: {
                selectedParticipant = participant
                showConfirmation = true
            }) {
                HStack {
                    Text(participant.userIdentity.name ?? "Ukjent bruker")
                    Spacer()
                    Text(participant.permission == .readOnly ? "Kun lesing" : "Kan redigere")
                        .foregroundColor(.blue)
                }
            }
            .confirmationDialog("Endre tillatelser?", isPresented: $showConfirmation) {
                Button("Kun lesing") { selectedParticipant?.permission = .readOnly }
                Button("Kan redigere") { selectedParticipant?.permission = .readWrite }
                Button("Avbryt", role: .cancel) {}
            }
        }
    }
}



📜 Slack-varsler (slack_notify.sh)
#!/bin/bash

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR_WEBHOOK_URL"

PAYLOAD='{
    "text": "🚀 Ny oppdatering på GitHub! AutentiseringApp er nå live.",
    "username": "GitHubBot",
    "icon_emoji": ":rocket:"
}'

curl -X POST -H 'Content-type: application/json' --data "$PAYLOAD" "$SLACK_WEBHOOK_URL"



🎯 Nå har vi:
✔ Komplett akademisk filstruktur
✔ Automatisert GitHub deploy med actions
✔ Slack-varsler etter vellykket deploy
✔ Swift-kildekoder for autentisering, synkronisering og deling
✔ Sanntidsoppdateringer med CloudKit Subscriptions
✔ UI-komponenter for tilgangsstyring
Vil du også ha støtte for CI/CD med Docker? 🚀😊
