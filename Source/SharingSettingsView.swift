import SwiftUI
import CloudKit
import UserNotifications

struct SharingSettingsView: View {
    @State private var selectedParticipant: CKShare.Participant?
    @State private var showConfirmation = false
    @State private var pushVarslingerAktivert = UserDefaults.standard.bool(forKey: "PushVarslingerAktivert")
    @State private var søkeTekst: String = ""
    @State private var participants: [CKShare.Participant] = []
    @State private var delingsHistorikk: [String] = []
    private let privatDatabase = CKContainer.default().privateCloudDatabase
    
    var body: some View {
        VStack {
            TextField("Søk etter deltaker...", text: $søkeTekst)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            List(filteredParticipants(), id: \.userIdentity) { participant in
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
                        lagreHistorikk("Kun lesing satt for \(selectedParticipant?.userIdentity.name ?? "Ukjent")")
                        sendVarsling(melding: "Delingstillatelse oppdatert: Kun lesing")
                    }
                    Button("Kan redigere") {
                        selectedParticipant?.permission = .readWrite
                        lagreHistorikk("Kan redigere satt for \(selectedParticipant?.userIdentity.name ?? "Ukjent")")
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
            
            List(delingsHistorikk, id: \.self) { historikk in
                Text(historikk)
            }
            .padding()
        }
        .onAppear {
            hentCloudKitData()
        }
    }

    private func filteredParticipants() -> [CKShare.Participant] {
        if søkeTekst.isEmpty {
            return participants
        } else {
            return participants.filter { $0.userIdentity.name?.localizedCaseInsensitiveContains(søkeTekst) ?? false }
        }
    }

    private func hentCloudKitData() {
        let delingsSpørring = CKQuery(recordType: "SharingData", predicate: NSPredicate(value: true))
        privatDatabase.perform(delingsSpørring, inZoneWith: nil) { result, feil in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self.participants = result.compactMap { $0 as? CKShare.Participant }
            }
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
    
    private func lagreHistorikk(_ melding: String) {
        DispatchQueue.main.async {
            self.delingsHistorikk.append("\(Date()): \(melding)")
        }
    }
}
