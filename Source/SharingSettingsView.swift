import SwiftUI
import CloudKit
import UserNotifications

struct SharingSettingsView: View {
    @State private var selectedParticipant: CKShare.Participant?
    @State private var showConfirmation = false
    @State private var pushVarslingerAktivert = UserDefaults.standard.bool(forKey: "PushVarslingerAktivert")
    var participants: [CKShare.Participant] = []
    
    var body: some View {
        VStack {
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
                    Button("Kun lesing") {
                        selectedParticipant?.permission = .readOnly
                        sendVarsling(melding: "Delingstillatelse oppdatert: Kun lesing")
                    }
                    Button("Kan redigere") {
                        selectedParticipant?.permission = .readWrite
                        sendVarsling(melding: "Delingstillatelse oppdatert: Kan redigere")
                    }
                    Button("Avbryt", role: .cancel) {}
                }
            }

            Toggle("Aktiver push-varslinger", isOn: $pushVarslingerAktivert)
                .onChange(of: pushVarslingerAktivert) { nyVerdi in
                    let senter = UNUserNotificationCenter.current()
                    senter.requestAuthorization(options: [.alert, .sound, .badge]) { gittTillatelse, _ in
                        if !gittTillatelse { pushVarslingerAktivert = false }
                    }
                    UserDefaults.standard.set(pushVarslingerAktivert, forKey: "PushVarslingerAktivert")
                }
                .padding()
        }
    }

    private func sendVarsling(melding: String) {
        guard pushVarslingerAktivert else { return }
        
        let innhold = UNMutableNotificationContent()
        innhold.title = "Delingsinnstillinger"
        innhold.body = melding
        innhold.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let forespørsel = UNNotificationRequest(identifier: "DelingVarsling", content: innhold, trigger: trigger)
        
        UNUserNotificationCenter.current().add(forespørsel)
    }
}
