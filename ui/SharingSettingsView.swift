import SwiftUI

struct DelingsInnstillingerView: View {
    @State private var valgtTillatelse: BrukerInnstillingerManager.Delingstillatelse = .kunLesing
    private let brukerInnstillinger = BrukerInnstillingerManager.standard

    var body: some View {
        VStack {
            Text("Velg delingstillatelse")
                .font(.headline)

            Picker("Delingstillatelse", selection: $valgtTillatelse) {
                Text("Kun lesing").tag(BrukerInnstillingerManager.Delingstillatelse.kunLesing)
                Text("Les og skriv").tag(BrukerInnstillingerManager.Delingstillatelse.lesOgSkriv)
                Text("Privat").tag(BrukerInnstillingerManager.Delingstillatelse.privat)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Lagre") {
                brukerInnstillinger.settDelingstillatelse(valgtTillatelse)
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            valgtTillatelse = brukerInnstillinger.hentDelingstillatelse()
        }
    }
}
