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
