# AutentiseringApp 🚀
En moderne iOS-app med **biometrisk autentisering, sanntidssynkronisering, og brukerspesifikke innstillinger** basert på akademiske paradigmer.

## 🔥 Funksjoner
✅ **Biometrisk autentisering med haptisk tilbakemelding**  
✅ **Spring-animasjoner og pulserende indikatorer**  
✅ **CloudKit-synkronisering og sanntidsoppdateringer**  
✅ **Deling av data mellom brukere med CKShare**  
✅ **Administrasjon av delingstillatelser med UI-komponenter**  
✅ **Slack-varsler etter deploy for team-kommunikasjon**

## **🛠 Installering**
### 📦 **Legg til Swift Package i ditt Xcode-prosjekt**
1️⃣ **Åpne Xcode**  
2️⃣ **Gå til** `File > Swift Packages > Add Package Dependency`  
3️⃣ **Skriv inn repo-URLen**:


Her er en oppsummering av hva prosjektet ser ut til å handle om og hvilke teknologier som brukes:

**Hovedformål og Funksjonalitet:**

Prosjektet "AutentiseringApp" er en applikasjon designet for å håndtere:

* **Autentisering:** Spesielt biometrisk autentisering (som Face ID eller Touch ID), antydet av `AuthenticationManager.swift` og `face_id_animation.json`.
* **Datadeling og Synkronisering via CloudKit:** Appen bruker CloudKit for å dele data (`CloudKitSharingManager.swift` med `CKShare`) og for å motta sanntidsoppdateringer (`CloudKitSubscriptionManager.swift`).
* **Brukerinnstillinger:** Den lagrer og henter brukerspesifikke innstillinger (`UserSettingsManager.swift`).
* **Administrasjon av Tilgang:** Det finnes en UI-komponent bygget med SwiftUI (`SharingSettingsView.swift`) for å administrere deling og tilgang.

**Kjernekomponenter og Teknologier:**

* **Programmeringsspråk:** Swift er hovedspråket, med `index.swift` og `main.swift` som sannsynlige inngangspunkter for applikasjonen.
* **Brukergrensesnitt:** SwiftUI brukes for minst deler av brukergrensesnittet (`SharingSettingsView.swift`).
* **Backend og Databehandling:** Apple CloudKit brukes for skytjenester som datalagring, deling og sanntidsoppdateringer.
* **Automatisering og CI/CD:**
    * **Scripts (`📁 Scripts`):** Inneholder shell-scripts for å installere avhengigheter (`setup.sh`) og sende Slack-varsler (`slack_notify.sh`).
    * **GitHub Actions (`📁 .github/workflows`):** Brukes for kontinuerlig integrasjon og leveranse (CI/CD) med testing på macOS (`test-ci.yml`).
* **Ressurser (`📁 Assets`):** Inkluderer grafiske elementer som Lottie-animasjoner (for eksempel `face_id_animation.json` for autentisering) og ikoner.
* **Dokumentasjon:**
    * `README.md`: Gir en generell beskrivelse av prosjektet.
    * `HOWTO.md`: Tilbyr en trinnvis brukerveiledning.

**Oppsummert:**

"AutentiseringApp" er et Swift-basert prosjekt som tilbyr robuste autentiseringsmekanismer, inkludert biometri, og benytter CloudKit for skytjenester. Det har et tydelig fokus på moderne utviklingspraksis med bruk av CI/CD via GitHub Actions og automatiseringsskript. Filstrukturen indikerer et velorganisert prosjekt.



## For å **integrere autentiseringsappen** i dine egne applikasjoner, kan du følge disse stegene:  

---

## **🔹 Steg 1: Gjør autentiseringsmodulen gjenbrukbar**
Du kan pakke **AuthenticationManager** inn som en **Swift Package**, slik at du enkelt kan importere den i dine apper.

### **Opprett en Swift Package**
1️⃣ I Xcode, gå til **File > New > Package**  
2️⃣ Gi pakken et navn, for eksempel `AuthKit`  
3️⃣ Kopier `AuthenticationManager.swift` inn i denne pakken  
4️⃣ Legg til en `Package.swift`-fil:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AuthKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "AuthKit", targets: ["AuthKit"]),
    ],
    targets: [
        .target(name: "AuthKit", dependencies: [])
    ]
)
```

Nå kan du bruke denne pakken i **alle dine applikasjoner** ved å legge til denne avhengigheten i Xcode!

---

## **🔹 Steg 2: Importer og bruk autentisering i dine apper**
Etter at du har **opprettet Swift Package**, kan du bruke den i en annen app ved å importere `AuthKit`:

```swift
import AuthKit

struct ContentView: View {
    let authManager = AuthenticationManager()

    var body: some View {
        VStack {
            Button("Start autentisering") {
                authManager.authenticateUser(userID: "din_bruker_id")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
```

---

## **🔹 Steg 3: Integrer med CloudKit og tilgangsstyring**
Du kan også **legge til sanntidssynkronisering** via CloudKit i dine apper. Bare sørg for at `CloudKitSharingManager.swift` også er inkludert i **Swift Package**, slik at du kan dele data på tvers av brukere.

```swift
import CloudKit

let cloudManager = CloudKitSharingManager()
cloudManager.shareRecord(recordID: CKRecord.ID(recordName: "UserAuthData")) { share in
    print("Deling fullført: \(String(describing: share))")
}
```

---

## **🔹 Steg 4: Implementer UI for autentisering i alle apper**
Hvis du vil ha en **felles UI-komponent** for autentisering, kan du lage en SwiftUI-modul:

```swift
struct AuthView: View {
    let authManager = AuthenticationManager()

    var body: some View {
        VStack {
            Text("Autentisering Kreves")
                .font(.title)
                .padding()

            Button("Logg inn med Face ID") {
                authManager.authenticateUser(userID: "bruker123")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
```

Nå kan du **bruke AuthView i alle dine apper** ved å inkludere denne som en egen SwiftUI-modul!

---

## **🎯 Nå har du:**
✔ **Swift Package for enkel gjenbruk av autentisering**  
✔ **CloudKit-synkronisering av brukerdata**  
✔ **UI-komponent for autentisering i flere apper**  
✔ **Fullstendig tilgangsstyring med CKShare**  

Vil du også ha en **GitHub-README for integrasjonsdokumentasjon**? 😊🚀
# 🚀 Kom i gang
### 📦 Installer avhengigheter
```sh
sh Scripts/setup.sh

