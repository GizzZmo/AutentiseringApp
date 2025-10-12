# API Dokumentasjon 📖

Dette dokumentet beskriver alle offentlige API-er som tilbys av AutentiseringApp.

## 📑 Innhold

- [AuthenticationManager](#authenticationmanager)
- [CloudKitDelingsManager](#cloudkitdelingsmanager)
- [CloudKitSubscriptionManager](#cloudkitsubscriptionmanager)
- [BrukerInnstillingerManager](#brukerinnstillingermanager)
- [SharingSettingsView](#sharingsettingsview)

---

## AuthenticationManager

Håndterer all autentiseringslogikk inkludert biometrisk autentisering og passordadministrasjon.

### Initialisering

```swift
let authManager = AuthenticationManager()
```

### Metoder

#### `autentiserBruker(brukerID:passord:ferdig:)`

Autentiserer en bruker med biometriske data eller passord.

**Signatur:**
```swift
func autentiserBruker(
    brukerID: String,
    passord: String?,
    ferdig: @escaping (Bool, String?) -> Void
)
```

**Parametere:**
- `brukerID`: Unik identifikator for brukeren (f.eks. e-postadresse eller brukernavn)
- `passord`: Valgfritt passord. Hvis `nil`, forsøkes biometrisk autentisering først
- `ferdig`: Completion handler som mottar:
  - `Bool`: `true` hvis autentisering vellykket, `false` ellers
  - `String?`: Feilmelding hvis autentisering feilet, `nil` ved suksess

**Eksempel:**
```swift
authManager.autentiserBruker(brukerID: "user@example.com", passord: nil) { suksess, feil in
    if suksess {
        print("✅ Innlogget!")
    } else {
        print("❌ Feil: \(feil ?? "Ukjent feil")")
    }
}
```

**Oppførsel:**
1. Sjekker om brukeren har nådd maks antall mislykkede forsøk (3)
2. Hvis ikke låst, forsøker biometrisk autentisering (Face ID/Touch ID)
3. Ved feil i biometrisk autentisering, faller tilbake til passordautentisering
4. Øker feiltellerverdi ved mislykket passordautentisering
5. Låser kontoen ved 3 eller flere mislykkede forsøk

**Haptisk Tilbakemelding:**
- Gir vibrasjonstilbakemelding ved autentiseringsforsøk

---

#### `tilbakestillPassord(brukerID:nyttPassord:)`

Tilbakestiller passord for en bruker og opphever kontolåsing.

**Signatur:**
```swift
func tilbakestillPassord(brukerID: String, nyttPassord: String)
```

**Parametere:**
- `brukerID`: Unik identifikator for brukeren
- `nyttPassord`: Det nye passordet som skal lagres

**Eksempel:**
```swift
authManager.tilbakestillPassord(
    brukerID: "user@example.com",
    nyttPassord: "NyttSikkertPassord123!"
)
```

**Oppførsel:**
- Lagrer nytt passord kryptert i iOS Keychain
- Nullstiller feiltellerverdi til 0
- Opphever eventuelle kontolåsinger

**Sikkerhet:**
- Passord lagres kryptert via iOS Keychain
- Ingen passord lagres i klartekst
- `kSecClassGenericPassword` brukes for sikker lagring

---

### Private Metoder

Disse metodene er interne og ikke tilgjengelige for eksterne brukere:

- `håndterFallbackAutentisering(brukerID:passord:ferdig:)` - Håndterer passordautentisering
- `lagreAutentiseringsstatus(for:erAutentisert:)` - Lagrer autentiseringsstatus i Keychain
- `lagrePassordTilKeychain(for:passord:)` - Lagrer passord sikkert
- `hentPassordFraKeychain(for:)` - Henter lagret passord

---

## CloudKitDelingsManager

Administrerer deling av data mellom brukere via CloudKit CKShare.

### Initialisering

```swift
let delingsManager = CloudKitDelingsManager()
```

### Egenskaper

- `privatDatabase`: Privat CloudKit-database
- `brukerInnstillinger`: Instans av BrukerInnstillingerManager

### Metoder

#### `delPost(postID:ferdig:)`

Deler en CloudKit-post med andre brukere.

**Signatur:**
```swift
func delPost(postID: CKRecord.ID, ferdig: @escaping (CKShare?) -> Void)
```

**Parametere:**
- `postID`: CloudKit Record ID for posten som skal deles
- `ferdig`: Completion handler som mottar `CKShare?` objekt (nil ved feil)

**Eksempel:**
```swift
let recordID = CKRecord.ID(recordName: "myImportantData")
delingsManager.delPost(postID: recordID) { share in
    if let share = share {
        print("Deling vellykket!")
        print("Share URL: \(share.url?.absoluteString ?? "N/A")")
        
        // Del URL med andre brukere via UIActivityViewController
        let activityVC = UIActivityViewController(
            activityItems: [share.url!],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    } else {
        print("Kunne ikke dele posten")
    }
}
```

**Oppførsel:**
1. Henter posten fra CloudKit privat database
2. Oppretter et CKShare-objekt for posten
3. Setter tillatelser basert på brukerinnstillinger:
   - `.kunLesing` → `publicPermission = .readOnly`
   - `.lesOgSkriv` → `publicPermission = .readWrite`
   - `.privat` → `publicPermission = .none`
4. Lagrer CKShare i CloudKit
5. Sender push-varsling ved vellykket deling
6. Logger all aktivitet

**Push-Varsler:**
- Automatisk varsling sendes ved vellykket deling
- Varslingstittel: "AutentiseringApp"
- Varslingslyd: Standard systemlyd

---

## CloudKitSubscriptionManager

Håndterer CloudKit subscriptions for sanntidsoppdateringer.

### Initialisering

```swift
let subscriptionManager = CloudKitSubscriptionManager()
```

### Funksjonalitet

- Oppretter database subscriptions for push-varsler
- Håndterer innkommende CloudKit-notifikasjoner
- Synkroniserer data automatisk ved endringer

### Bruk

```swift
// Manager initialiseres og setter opp subscriptions automatisk
let subscriptionManager = CloudKitSubscriptionManager()

// Subscriptions håndteres automatisk i bakgrunnen
```

**Automatiske Funksjoner:**
- Oppretter CKQuerySubscription for relevante data
- Registrerer for push notifications
- Håndterer CloudKit-varsler når data endres
- Trigger datasynkronisering ved endringer

---

## BrukerInnstillingerManager

Administrerer brukerspesifikke innstillinger og preferanser.

### Singleton Instance

```swift
let innstillinger = BrukerInnstillingerManager.standard
```

### Enums

#### `Delingstillatelse`

Definerer tilgangsnivåer for datadeling.

```swift
enum Delingstillatelse: String {
    case kunLesing = "Kun lesing"
    case lesOgSkriv = "Les og skriv"
    case privat = "Privat"
}
```

**Verdier:**
- `.kunLesing`: Andre brukere kan kun lese data
- `.lesOgSkriv`: Andre brukere kan lese og redigere data
- `.privat`: Ingen deling tillatt

### Metoder

#### `settDelingstillatelse(_:)`

Setter ønsket delingstillatelse for brukeren.

**Signatur:**
```swift
func settDelingstillatelse(_ tillatelse: Delingstillatelse)
```

**Eksempel:**
```swift
innstillinger.settDelingstillatelse(.kunLesing)
```

---

#### `hentDelingstillatelse()`

Henter gjeldende delingstillatelse.

**Signatur:**
```swift
func hentDelingstillatelse() -> Delingstillatelse
```

**Returns:** Gjeldende `Delingstillatelse` (default: `.kunLesing`)

**Eksempel:**
```swift
let tillatelse = innstillinger.hentDelingstillatelse()

switch tillatelse {
case .kunLesing:
    print("Data er delt som read-only")
case .lesOgSkriv:
    print("Data kan redigeres av andre")
case .privat:
    print("Data er privat")
}
```

**Lagring:**
- Bruker `UserDefaults` for persistent lagring
- Nøkkel: `"delingstillatelse"`
- Verdi lagres som `String` (enum raw value)

---

## SharingSettingsView

SwiftUI-visning for administrasjon av delingsinnstillinger.

### Bruk

```swift
import SwiftUI
import AutentiseringApp

struct SettingsScreen: View {
    var body: some View {
        NavigationView {
            SharingSettingsView()
                .navigationTitle("Delingsinnstillinger")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
```

### Funksjonalitet

- Moderne SwiftUI-grensesnitt
- Valg av delingstillatelser
- Visuell tilbakemelding på valg
- Direkte integrasjon med BrukerInnstillingerManager

---

## Feilhåndtering

### Generelle Prinsipper

Alle asynkrone metoder bruker completion handlers for feilhåndtering:

```swift
// Pattern: (Success, Error?) eller (Data?, Error?)
methodName() { success, error in
    if success {
        // Håndter suksess
    } else if let error = error {
        // Håndter feil
    }
}
```

### Vanlige Feilscenarier

#### Autentisering

**Feilmeldinger:**
- `"Kontoen er låst etter flere mislykkede forsøk."` - For mange feil passord
- `"Ingen lagret passord funnet."` - Ingen passord i Keychain
- `"Feil passord. Forsøk igjen."` - Feil passord (før låsing)
- `"Kontoen er låst. Tilbakestill passord for tilgang."` - Konto låst

**Løsning:**
```swift
authManager.autentiserBruker(brukerID: id, passord: pwd) { suksess, feil in
    if !suksess {
        if feil?.contains("låst") == true {
            // Vis passordtilbakestillingsflyt
            showPasswordReset()
        } else {
            // Vis generell feilmelding
            showAlert(message: feil ?? "Autentisering feilet")
        }
    }
}
```

#### CloudKit

**Feilscenarier:**
- Ingen nettverksforbindelse
- Bruker ikke logget inn på iCloud
- CloudKit quota overskredet
- Tillatelser ikke konfigurert

**Debugging:**
```swift
delingsManager.delPost(postID: id) { share in
    if share == nil {
        // Sjekk CloudKit-status
        CKContainer.default().accountStatus { status, error in
            print("CloudKit status: \(status)")
        }
    }
}
```

---

## Best Practices

### Autentisering

1. **Alltid bruk biometrisk først**
   ```swift
   authManager.autentiserBruker(brukerID: id, passord: nil) { ... }
   ```

2. **Håndter fallback elegant**
   ```swift
   if !success && error?.contains("biometrisk") == true {
       promptForPassword()
   }
   ```

3. **Lagre passord sikker**
   - Bruk alltid `tilbakestillPassord()` for å lagre
   - Aldri lagre passord i UserDefaults eller andre usikre steder

### CloudKit

1. **Sjekk nettverkstilkobling**
   ```swift
   import Network
   
   let monitor = NWPathMonitor()
   monitor.pathUpdateHandler = { path in
       if path.status == .satisfied {
           // Trygt å bruke CloudKit
       }
   }
   ```

2. **Håndter offline-tilstand**
   - Cache data lokalt
   - Synkroniser når online igjen

3. **Batch-operasjoner**
   - Bruk batch operations for flere poster
   - Reduserer API-kall og forbedrer ytelse

### SwiftUI

1. **Bruk @State for lokale verdier**
   ```swift
   @State private var isAuthenticated = false
   ```

2. **Bruk @Published for delte verdier**
   ```swift
   class AuthViewModel: ObservableObject {
       @Published var isAuthenticated = false
   }
   ```

3. **Unngå retain cycles**
   ```swift
   authManager.autentiserBruker(...) { [weak self] success, error in
       self?.handleAuth(success: success)
   }
   ```

---

## Ytelsesoptimalisering

### Keychain-operasjoner

- Keychain-operasjoner er relativt trege
- Cache autentiseringsstatus hvis mulig
- Unngå unødvendige keychain-oppslag

### CloudKit-operasjoner

- Batch flere operasjoner sammen
- Bruk CKModifyRecordsOperation for bedre kontroll
- Implementer retry-logikk for feilede operasjoner

```swift
let operation = CKModifyRecordsOperation(
    recordsToSave: records,
    recordIDsToDelete: nil
)
operation.modifyRecordsCompletionBlock = { saved, deleted, error in
    if let error = error as? CKError {
        if error.code == .networkUnavailable {
            // Retry senere
        }
    }
}
```

---

## Sikkerhet

### Keychain Best Practices

1. **Bruk korrekt accessibility level**
   ```swift
   kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
   ```

2. **Valider input**
   ```swift
   guard !brukerID.isEmpty, !passord.isEmpty else {
       return
   }
   ```

3. **Tøm sensitive data**
   ```swift
   var password = "secret"
   defer {
       password = ""
   }
   ```

### CloudKit Security

1. **Valider permissions**
   - Sjekk alltid CKShare permissions før visning
   
2. **Sanitize user input**
   - Valider all brukerinndata før lagring i CloudKit

3. **Bruk private database**
   - Bruk private database for brukerdata
   - Public database kun for delt, ikke-sensitiv data

---

## Eksempler

### Komplett Autentiseringsflyt

```swift
import SwiftUI
import AutentiseringApp

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private let authManager = AuthenticationManager()
    private let userID = "user@example.com"
    
    func authenticate() {
        authManager.autentiserBruker(brukerID: userID, passord: nil) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthenticated = success
                self?.errorMessage = error
            }
        }
    }
    
    func authenticateWithPassword(_ password: String) {
        authManager.autentiserBruker(brukerID: userID, passord: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthenticated = success
                self?.errorMessage = error
            }
        }
    }
    
    func resetPassword(_ newPassword: String) {
        authManager.tilbakestillPassord(brukerID: userID, nyttPassord: newPassword)
        errorMessage = nil
    }
}

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var password = ""
    @State private var showPasswordField = false
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isAuthenticated {
                authenticatedView
            } else {
                loginView
            }
        }
        .padding()
    }
    
    private var loginView: some View {
        VStack(spacing: 20) {
            Text("Velkommen")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Logg inn med Face ID") {
                viewModel.authenticate()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Bruk passord") {
                showPasswordField.toggle()
            }
            
            if showPasswordField {
                SecureField("Passord", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Logg inn") {
                    viewModel.authenticateWithPassword(password)
                }
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    private var authenticatedView: some View {
        VStack {
            Text("✅ Autentisert!")
                .font(.title)
                .foregroundColor(.green)
        }
    }
}
```

### Komplett CloudKit-Delingsflyt

```swift
import SwiftUI
import CloudKit
import AutentiseringApp

struct DataSharingView: View {
    @State private var shareURL: URL?
    @State private var isSharing = false
    @State private var errorMessage: String?
    
    let delingsManager = CloudKitDelingsManager()
    let innstillinger = BrukerInnstillingerManager.standard
    
    var body: some View {
        VStack(spacing: 20) {
            // Velg delingstillatelse
            Picker("Tilgangsnivå", selection: $selectedPermission) {
                Text("Kun Lesing").tag(BrukerInnstillingerManager.Delingstillatelse.kunLesing)
                Text("Les og Skriv").tag(BrukerInnstillingerManager.Delingstillatelse.lesOgSkriv)
                Text("Privat").tag(BrukerInnstillingerManager.Delingstillatelse.privat)
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPermission) { newValue in
                innstillinger.settDelingstillatelse(newValue)
            }
            
            // Del-knapp
            Button(action: shareData) {
                if isSharing {
                    ProgressView()
                } else {
                    Label("Del Data", systemImage: "square.and.arrow.up")
                }
            }
            .disabled(isSharing || selectedPermission == .privat)
            .buttonStyle(.borderedProminent)
            
            // Del via system share sheet
            if let url = shareURL {
                ShareLink(item: url) {
                    Label("Send Invitasjon", systemImage: "envelope")
                }
            }
            
            // Feilmelding
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
    
    @State private var selectedPermission = BrukerInnstillingerManager.Delingstillatelse.kunLesing
    
    private func shareData() {
        isSharing = true
        errorMessage = nil
        
        let recordID = CKRecord.ID(recordName: "myDataRecord")
        
        delingsManager.delPost(postID: recordID) { share in
            DispatchQueue.main.async {
                isSharing = false
                
                if let share = share {
                    shareURL = share.url
                } else {
                    errorMessage = "Kunne ikke dele data"
                }
            }
        }
    }
}
```

---

## Versjonering

API følger [Semantic Versioning](https://semver.org/):

- **MAJOR**: Inkompatible API-endringer
- **MINOR**: Ny funksjonalitet, bakoverkompatibel
- **PATCH**: Bugfixes, bakoverkompatibel

**Nåværende versjon**: 1.0.0

---

## Avhengigheter

### Eksterne Packages

- **swift-nio** (2.0.0+): Nettverkskommunikasjon
- **swift-crypto** (2.0.0+): Kryptografiske operasjoner

### Apple Frameworks

- **LocalAuthentication**: Biometrisk autentisering
- **CloudKit**: Skybasert datalagring og synkronisering
- **Security**: Keychain-operasjoner
- **UserNotifications**: Push-varsler
- **SwiftUI**: Brukergrensesnitt

---

## Support

For API-spørsmål:
- Se [ABOUT.md](ABOUT.md) for arkitekturinformasjon
- Se [HOWTO.md](HOWTO.md) for brukerveiledning
- Opprett et GitHub Issue for bugs eller feature requests

---

**Sist oppdatert**: 2025-10  
**API Versjon**: 1.0.0
