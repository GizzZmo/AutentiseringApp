import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Velkommen til AutentiseringApp!")
                .font(.largeTitle)
                .padding()

            Button("Start Autentisering") {
                AuthenticationManager().authenticateUser(userID: "jon123")
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}
