# 💡 HOWTO - Detaljert Brukerveiledning

Denne veiledningen gir deg en steg-for-steg introduksjon til hvordan du bruker og implementerer AutentiseringApp i dine egne prosjekter.

## 📑 Innhold

1. [Grunnleggende Oppsett](#1-grunnleggende-oppsett)
2. [Autentisering](#2-autentisering)
3. [CloudKit-Synkronisering](#3-cloudkit-synkronisering)
4. [Data- og Tilgangsstyring](#4-data--og-tilgangsstyring)
5. [UI-Komponenter](#5-ui-komponenter)
6. [Testing og Debugging](#6-testing-og-debugging)
7. [Deployment](#7-deployment)
8. [Vanlige Problemer](#8-vanlige-problemer)

---

## 1️⃣ Grunnleggende Oppsett

### Installasjon via Swift Package Manager

**Steg 1**: Åpne ditt Xcode-prosjekt

**Steg 2**: Legg til package dependency
```
File → Add Packages... → https://github.com/GizzZmo/AutentiseringApp.git
```

**Steg 3**: Velg versjon
- Velg "Up to Next Major Version" for stabil versjon
- Eller velg en spesifikk branch for utviklingsversjoner

**Steg 4**: Importer i din kode
```swift
import AutentiseringApp
```

### Lokal Utvikling

For å utvikle og teste lokalt:

```bash
# 1. Klon repositoryet
git clone https://github.com/GizzZmo/AutentiseringApp.git
cd AutentiseringApp

# 2. Installer avhengigheter
sh Scripts/setup.sh

# 3. Åpne i Xcode
open Package.swift

# 4. Bygg prosjektet
swift build

# 5. Kjør tester
swift test
```

### Konfigurasjon av iCloud

For å bruke CloudKit-funksjoner:

**Steg 1**: Aktiver CloudKit i Xcode
- Velg prosjektet i Project Navigator
- Gå til "Signing & Capabilities"
- Klikk "+ Capability"
- Legg til "iCloud"
- Aktiver "CloudKit"

**Steg 2**: Konfigurer Container
- Opprett eller velg en CloudKit container
- Bruk samme container ID på tvers av apper som skal dele data

---

## 2️⃣ Autentisering

### Face ID & Touch ID Autentisering

AutentiseringApp tilbyr biometrisk autentisering med automatisk fallback til passord.

#### Grunnleggende Implementasjon

```swift
import AutentiseringApp

class LoginViewController {
    let authManager = AuthenticationManager()
    
    func login() {
        authManager.autentiserBruker(
            brukerID: "bruker@example.com",
            passord: nil  // nil for biometrisk autentisering
        ) { suksess, feilmelding in
            if suksess {
                self.navigateToMainScreen()
            } else {
                self.showError(feilmelding ?? "Autentisering feilet")
            }
        }
    }
}
```

#### Med Passord-Fallback

```swift
func loginWithPassword(password: String) {
    authManager.autentiserBruker(
        brukerID: "bruker@example.com",
        passord: password
    ) { suksess, feilmelding in
        // Håndter resultat
    }
}
```

### Passordadministrasjon

#### Lagre Nytt Passord

```swift
// Ved første gangs registrering eller passordendring
authManager.tilbakestillPassord(
    brukerID: "bruker@example.com",
    nyttPassord: "SikkertPassord123!"
)
```

#### Sikkerhetsfunksjoner

- **Automatisk låsing**: Kontoen låses etter 3 mislykkede forsøk
- **Keychain-lagring**: Passord lagres kryptert i iOS Keychain
- **Haptisk tilbakemelding**: Vibrasjonstilbakemelding ved brukerinteraksjon

### Info.plist Konfigurasjon

Legg til følgende i din `Info.plist` for Face ID:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Vi bruker Face ID for å sikre din konto</string>
```

---

## 3️⃣ CloudKit-Synkronisering

### Sanntidsoppdateringer med CloudKit Subscriptions

CloudKit Subscriptions gir deg mulighet til å motta push-varsler når data endres.

#### Sett opp Subscription

```swift
import AutentiseringApp

let subscriptionManager = CloudKitSubscriptionManager()

// Oppsett skjer automatisk ved initialisering
// Manager håndterer push-varsler og datasynkronisering
```

#### Håndter Synkroniserte Data

```swift
import CloudKit

// CloudKitSubscriptionManager lytter automatisk til endringer
// Implementer din egen logikk for å håndtere oppdateringer
```

### Push-Varsler

**Steg 1**: Aktiver Push Notifications
- Gå til "Signing & Capabilities" i Xcode
- Legg til "Push Notifications" capability

**Steg 2**: Registrer for Remote Notifications

```swift
import UIKit
import UserNotifications

func application(_ application: UIApplication, 
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        if granted {
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    return true
}
```

---

## 4️⃣ Data- og Tilgangsstyring

### CKShare for Datadeling

CloudKitDelingsManager håndterer deling av data mellom brukere.

#### Del en Post

```swift
import CloudKit
import AutentiseringApp

let delingsManager = CloudKitDelingsManager()

// Opprett en post ID for data du vil dele
let postID = CKRecord.ID(recordName: "MinViktigeData")

// Del posten
delingsManager.delPost(postID: postID) { share in
    if let share = share {
        // Deling vellykket
        print("Share URL: \(share.url?.absoluteString ?? "N/A")")
        
        // Del denne URL-en med andre brukere
        self.presentShareSheet(with: share.url!)
    } else {
        print("Kunne ikke dele posten")
    }
}
```

#### Administrer Tilgangsnivåer

```swift
import AutentiseringApp

let innstillinger = BrukerInnstillingerManager.standard

// Tilgjengelige nivåer:
// 1. Kun lesing - andre kan kun se data
innstillinger.settDelingstillatelse(.kunLesing)

// 2. Les og skriv - andre kan redigere data
innstillinger.settDelingstillatelse(.lesOgSkriv)

// 3. Privat - ingen deling
innstillinger.settDelingstillatelse(.privat)

// Hent gjeldende tillatelse
let gjeldendeTillatelse = innstillinger.hentDelingstillatelse()
print("Tillatelse: \(gjeldendeTillatelse)")
```

### Delingsflyt i SwiftUI

```swift
import SwiftUI
import AutentiseringApp

struct SharingView: View {
    @State private var shareURL: URL?
    let delingsManager = CloudKitDelingsManager()
    
    var body: some View {
        VStack {
            Button("Del Data") {
                let postID = CKRecord.ID(recordName: "myData")
                delingsManager.delPost(postID: postID) { share in
                    shareURL = share?.url
                }
            }
            
            if let url = shareURL {
                ShareLink(item: url) {
                    Label("Del med andre", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
```

---

## 5️⃣ UI-Komponenter

### SharingSettingsView

En ferdig SwiftUI-komponent for å administrere delingsinnstillinger.

#### Grunnleggende Bruk

```swift
import SwiftUI
import AutentiseringApp

struct SettingsView: View {
    var body: some View {
        NavigationView {
            SharingSettingsView()
                .navigationTitle("Innstillinger")
        }
    }
}
```

### Egen Autentiseringsvisning

Opprett din egen tilpassede autentiseringsvisning:

```swift
import SwiftUI
import AutentiseringApp

struct CustomAuthView: View {
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let authManager = AuthenticationManager()
    
    var body: some View {
        VStack(spacing: 30) {
            // Logo eller header
            Image(systemName: "lock.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Sikker Innlogging")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Autentiseringsknapp
            Button(action: authenticate) {
                Label("Logg inn med Face ID", systemImage: "faceid")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
    
    func authenticate() {
        authManager.autentiserBruker(brukerID: "user@example.com", passord: nil) { success, error in
            if success {
                isAuthenticated = true
            } else {
                showError = true
                errorMessage = error ?? "Autentisering feilet"
            }
        }
    }
}
```

---

## 6️⃣ Testing og Debugging

### Kjør Enhetstester

```bash
# Kjør alle tester
swift test

# Kjør med verbose output
swift test --verbose

# Kjør spesifikk testklasse
swift test --filter AuthenticationTests
```

### Skriv Egne Tester

```swift
import XCTest
@testable import AutentiseringApp

final class MinTestKlasse: XCTestCase {
    var authManager: AuthenticationManager!
    
    override func setUp() {
        super.setUp()
        authManager = AuthenticationManager()
    }
    
    func testTilbakestillPassord() {
        // Test passordtilbakestilling
        authManager.tilbakestillPassord(
            brukerID: "test@example.com",
            nyttPassord: "TestPassord123"
        )
        
        // Verifiser at passordet er lagret
        // (Krever tilgang til keychain i test-miljø)
    }
    
    func testBrukerInnstillinger() {
        let manager = BrukerInnstillingerManager.standard
        
        manager.settDelingstillatelse(.kunLesing)
        XCTAssertEqual(manager.hentDelingstillatelse(), .kunLesing)
        
        manager.settDelingstillatelse(.lesOgSkriv)
        XCTAssertEqual(manager.hentDelingstillatelse(), .lesOgSkriv)
    }
}
```

### Debugging Tips

**CloudKit-problemer:**
```swift
// Aktiver CloudKit-logging
UserDefaults.standard.set(true, forKey: "CKDebugLoggingEnabled")
```

**Keychain-problemer:**
- Test på fysisk enhet for biometrisk autentisering
- Simulator støtter Face ID/Touch ID-simulering via Hardware-menyen

---

## 7️⃣ Deployment

### GitHub Actions

Prosjektet inkluderer CI/CD via GitHub Actions.

#### Automatisk Testing

Ved hver push kjøres automatiske tester på macOS. Se `.github/workflows/test-ci.yml`.

#### Slack-Varsler

Konfigurer Slack-varsler for deployment:

```bash
# Sett miljøvariabler
export SLACK_WEBHOOK_URL="your-webhook-url"

# Kjør notifikasjonsskript
sh Scripts/slack_notify.sh "Deployment vellykket!"
```

### App Store Deployment

**Steg 1**: Arkiver appen
- Product → Archive i Xcode

**Steg 2**: Distribuer
- Velg arkivet i Organizer
- Klikk "Distribute App"
- Følg veiviseren

**Steg 3**: Verifiser CloudKit-konfigurasjon
- Sjekk at riktig CloudKit container er valgt
- Verifiser signing certificates

---

## 8️⃣ Vanlige Problemer

### Problem: Face ID fungerer ikke i Simulator

**Løsning:**
- Gå til `Hardware → Face ID → Enrolled` i Simulator
- Bruk `Hardware → Face ID → Matching Face` for å simulere vellykket autentisering

### Problem: CloudKit-data synkroniserer ikke

**Sjekkliste:**
- ✅ CloudKit capability er aktivert
- ✅ Riktig container ID er valgt
- ✅ Bruker er logget inn på iCloud
- ✅ Internettforbindelse er aktiv
- ✅ Push notifications er aktivert

**Debugging:**
```swift
import CloudKit

let container = CKContainer.default()
container.accountStatus { status, error in
    switch status {
    case .available:
        print("✅ iCloud tilgjengelig")
    case .noAccount:
        print("❌ Ingen iCloud-konto")
    case .restricted:
        print("❌ iCloud begrenset")
    case .couldNotDetermine:
        print("❌ Kunne ikke bestemme status")
    @unknown default:
        print("❌ Ukjent status")
    }
}
```

### Problem: Keychain-lagring feiler

**Løsning:**
- Sjekk at keychain access er konfigurert riktig
- For testing: Bruk fysisk enhet eller konfigurer Simulator keychain
- Verifiser at `kSecAttrAccessible` er satt riktig

### Problem: Build-feil med Swift Package Dependencies

**Løsning:**
```bash
# Slett derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Oppdater packages
swift package update

# Bygg på nytt
swift build
```

---

## 🆘 Få Hjelp

### Dokumentasjon
- **[README.md](README.md)** - Hurtigstart og oversikt
- **[ABOUT.md](ABOUT.md)** - Detaljert prosjektinformasjon
- **Apple Dokumentasjon**:
  - [LocalAuthentication Framework](https://developer.apple.com/documentation/localauthentication)
  - [CloudKit Framework](https://developer.apple.com/documentation/cloudkit)
  - [Swift Package Manager](https://swift.org/package-manager/)

### Support
- **GitHub Issues**: Rapporter bugs eller be om nye funksjoner
- **GitHub Discussions**: Stil spørsmål og del erfaringer
- **Stack Overflow**: Tag med `autentiseringapp` eller `swift-cloudkit`

---

## 📚 Neste Steg

1. Utforsk [ABOUT.md](ABOUT.md) for dypere forståelse av arkitekturen
2. Se på [eksempelkoden i README.md](README.md) for flere use cases
3. Eksperimenter med egne implementasjoner
4. Bidra til prosjektet på GitHub!

---

**Versjon**: 1.0.0  
**Sist oppdatert**: 2025-10  
**Vedlikeholdt av**: Jon Arve Ovesen
