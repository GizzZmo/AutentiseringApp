# AutentiseringApp 🚀

[![Swift Version](https://img.shields.io/badge/Swift-5.7+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B%20%7C%20macOS%2010.15%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-green.svg)](LICENSE)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub%20Actions-blue.svg)](https://github.com/features/actions)

En moderne iOS-app med **biometrisk autentisering, sanntidssynkronisering, og brukerspesifikke innstillinger** basert på akademiske paradigmer og beste praksis for sikkerhet.

## 📚 Dokumentasjon

- **[📑 DOCS.md](DOCS.md)** - Komplett dokumentasjonsindeks og navigasjonsguide
- **[📖 ABOUT.md](ABOUT.md)** - Detaljert prosjektoversikt, arkitektur og teknisk informasjon
- **[💡 HOWTO.md](HOWTO.md)** - Steg-for-steg brukerveiledning og implementasjonsguide  
- **[🔌 API.md](API.md)** - Komplett API-referansedokumentasjon
- **[🤝 CONTRIBUTING.md](CONTRIBUTING.md)** - Retningslinjer for bidrag til prosjektet
- **[📄 LICENSE](LICENSE)** - BSD 3-Clause lisensinformasjon

## 🔥 Funksjoner

✅ **Biometrisk autentisering** - Face ID/Touch ID med haptisk tilbakemelding  
✅ **Sikker datalagring** - iOS Keychain for sensitiv informasjon  
✅ **Spring-animasjoner** - Moderne UI med Lottie-animasjoner  
✅ **CloudKit-synkronisering** - Sanntidsoppdateringer på tvers av enheter  
✅ **Datadeling** - CKShare for sikker deling mellom brukere  
✅ **Tilgangsstyring** - Fin-grained tillatelseskontroll  
✅ **SwiftUI-komponenter** - Moderne, responsiv brukergrensesnitt  
✅ **CI/CD** - Automatisert testing og deployment med GitHub Actions

## 📋 Innholdsfortegnelse

- [Installering](#-installering)
- [Hurtigstart](#-hurtigstart)
- [Grunnleggende Bruk](#-grunnleggende-bruk)
- [Integrasjon i Egne Prosjekter](#-integrasjon-i-egne-prosjekter)
- [Avanserte Funksjoner](#-avanserte-funksjoner)
- [Testing](#-testing)
- [Bidra](#-bidra)
- [Lisens](#-lisens)

## 🛠 Installering

### Forutsetninger

- macOS 10.15+ (for utvikling)
- Xcode 13.0+
- Swift 5.7+
- iOS 15.0+ (for deployment)
- iCloud-konto (for CloudKit-funksjoner)

### Metode 1: Swift Package Manager (Anbefalt)

1️⃣ **Åpne ditt Xcode-prosjekt**

2️⃣ **Legg til package dependency**
   - Gå til `File > Add Packages...`
   - Lim inn repository URL: `https://github.com/GizzZmo/AutentiseringApp.git`
   - Velg versjon eller branch

3️⃣ **Importer i din kode**
```swift
import AutentiseringApp
```

### Metode 2: Manuell Kloning

```bash
# Klon repositoryet
git clone https://github.com/GizzZmo/AutentiseringApp.git
cd AutentiseringApp

# Installer avhengigheter
sh Scripts/setup.sh

# Åpne i Xcode
open Package.swift
```

## 🚀 Hurtigstart

### 1. Grunnleggende Autentisering

```swift
import AutentiseringApp

let authManager = AuthenticationManager()

// Autentiser med biometri eller passord
authManager.autentiserBruker(brukerID: "bruker123", passord: nil) { suksess, feilmelding in
    if suksess {
        print("✅ Autentisering vellykket!")
    } else {
        print("❌ Autentisering feilet: \(feilmelding ?? "Ukjent feil")")
    }
}
```

### 2. CloudKit Datadeling

```swift
import CloudKit
import AutentiseringApp

let delingsManager = CloudKitDelingsManager()
let postID = CKRecord.ID(recordName: "minPost")

delingsManager.delPost(postID: postID) { share in
    if let share = share {
        print("✅ Data delt: \(share)")
    }
}
```

### 3. Brukerinnstillinger

```swift
import AutentiseringApp

let innstillinger = BrukerInnstillingerManager.standard

// Sett delingstillatelse
innstillinger.settDelingstillatelse(.kunLesing)

// Hent gjeldende tillatelse
let tillatelse = innstillinger.hentDelingstillatelse()
print("Gjeldende tillatelse: \(tillatelse)")
```

## 💡 Grunnleggende Bruk

### Autentisering med Passord-Reset

```swift
let authManager = AuthenticationManager()

// Hvis bruker glemmer passord
authManager.tilbakestillPassord(
    brukerID: "bruker123", 
    nyttPassord: "sikkertPassord123"
)
```

### SwiftUI-Integrasjon

```swift
import SwiftUI
import AutentiseringApp

struct ContentView: View {
    @State private var erAutentisert = false
    let authManager = AuthenticationManager()
    
    var body: some View {
        VStack {
            if erAutentisert {
                Text("Velkommen!")
                    .font(.largeTitle)
            } else {
                Button("Logg inn med Face ID") {
                    authManager.autentiserBruker(brukerID: "bruker123", passord: nil) { suksess, _ in
                        erAutentisert = suksess
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
```

## 🔌 Integrasjon i Egne Prosjekter

### Steg 1: Gjør Autentiseringsmodulen Gjenbrukbar

Du kan pakke **AuthenticationManager** inn som en **Swift Package**, slik at du enkelt kan importere den i dine apper.

#### Opprett en Swift Package

1️⃣ I Xcode, gå til **File > New > Package**  
2️⃣ Gi pakken et navn, for eksempel `AuthKit`  
3️⃣ Kopier `AuthenticationManager.swift` inn i denne pakken  
4️⃣ Legg til en `Package.swift`-fil:

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AuthKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AuthKit", targets: ["AuthKit"]),
    ],
    targets: [
        .target(name: "AuthKit", dependencies: [])
    ]
)
```

### Steg 2: Importer og Bruk Autentisering

Etter at du har **opprettet Swift Package**, kan du bruke den i en annen app:

```swift
import AuthKit

struct LoginView: View {
    let authManager = AuthenticationManager()

    var body: some View {
        VStack {
            Button("Start autentisering") {
                authManager.autentiserBruker(brukerID: "din_bruker_id", passord: nil) { suksess, feil in
                    // Håndter resultat
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
```

### Steg 3: Integrer med CloudKit og Tilgangsstyring

Legg til **sanntidssynkronisering** via CloudKit i dine apper:

```swift
import CloudKit
import AutentiseringApp

let cloudManager = CloudKitDelingsManager()
cloudManager.delPost(postID: CKRecord.ID(recordName: "UserAuthData")) { share in
    print("Deling fullført: \(String(describing: share))")
}
```

### Steg 4: Implementer UI for Autentisering

Opprett en **felles UI-komponent** for autentisering:

```swift
import SwiftUI
import AutentiseringApp

struct AuthView: View {
    let authManager = AuthenticationManager()
    @State private var visStatus = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Autentisering Kreves")
                .font(.title)
                .padding()

            Button("Logg inn med Face ID") {
                authManager.autentiserBruker(brukerID: "bruker123", passord: nil) { suksess, _ in
                    visStatus = true
                }
            }
            .buttonStyle(.borderedProminent)
            
            if visStatus {
                Text("✅ Innlogget")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}
```

## 🎯 Avanserte Funksjoner

### CloudKit Subscriptions

For sanntidsoppdateringer:

```swift
import AutentiseringApp

let subscriptionManager = CloudKitSubscriptionManager()
// Konfigurer abonnementer for push-varsler
```

### Delingstillatelser

```swift
import AutentiseringApp

// Tre tilgangsnivåer:
let innstillinger = BrukerInnstillingerManager.standard

// Kun lesing
innstillinger.settDelingstillatelse(.kunLesing)

// Les og skriv
innstillinger.settDelingstillatelse(.lesOgSkriv)

// Privat (ingen deling)
innstillinger.settDelingstillatelse(.privat)
```

## 🧪 Testing

### Kjør Tester

```bash
# Kjør alle tester
swift test

# Kjør tester med verbose output
swift test --verbose

# Kjør spesifikk test
swift test --filter AutentiseringAppTests
```

### Eksempel Test

```swift
import XCTest
@testable import AutentiseringApp

final class AuthTests: XCTestCase {
    func testBrukerInnstillinger() {
        let manager = BrukerInnstillingerManager.standard
        manager.settDelingstillatelse(.kunLesing)
        XCTAssertEqual(manager.hentDelingstillatelse(), .kunLesing)
    }
}
```

## 🤝 Bidra

Vi setter pris på bidrag! Her er hvordan du kan hjelpe:

1. **Fork** repositoryet
2. **Opprett** en feature branch (`git checkout -b feature/MinNyeFunksjon`)
3. **Commit** endringene dine (`git commit -am 'Legg til ny funksjon'`)
4. **Push** til branchen (`git push origin feature/MinNyeFunksjon`)
5. **Opprett** en Pull Request

### Retningslinjer

- Følg eksisterende kodestil
- Skriv tester for ny funksjonalitet
- Oppdater dokumentasjon ved behov
- Sørg for at alle tester kjører før du sender PR

## 📄 Lisens

Dette prosjektet er lisensiert under BSD 3-Clause License - se [LICENSE](LICENSE) for detaljer.

Copyright (c) 2025, Jon Arve Ovesen

## 🎯 Hva Har Du Nå?

✔ **Swift Package** for enkel gjenbruk av autentisering  
✔ **CloudKit-synkronisering** av brukerdata  
✔ **UI-komponenter** for autentisering i flere apper  
✔ **Fullstendig tilgangsstyring** med CKShare  
✔ **Moderne SwiftUI-grensesnitt**  
✔ **Robust sikkerhet** med Keychain og biometri

## 📞 Support og Spørsmål

- **Dokumentasjon**: Se [ABOUT.md](ABOUT.md) for detaljert prosjektinformasjon
- **Brukerveiledning**: Se [HOWTO.md](HOWTO.md) for implementasjonsguide
- **Issues**: Rapporter feil eller foreslå funksjoner via GitHub Issues
- **Diskusjoner**: Delta i GitHub Discussions for spørsmål og ideer

---

**Laget med ❤️ for iOS-utviklere**

