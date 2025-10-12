# Bidra til AutentiseringApp 🤝

Takk for din interesse i å bidra til AutentiseringApp! Dette dokumentet gir retningslinjer for hvordan du kan bidra til prosjektet.

## 📋 Innholdsfortegnelse

- [Oppførselsregler](#oppførselsregler)
- [Hvordan kan jeg bidra?](#hvordan-kan-jeg-bidra)
- [Utviklingsoppsett](#utviklingsoppsett)
- [Kodestil](#kodestil)
- [Testing](#testing)
- [Pull Request-prosess](#pull-request-prosess)
- [Rapportere Bugs](#rapportere-bugs)
- [Foreslå Nye Funksjoner](#foreslå-nye-funksjoner)

## Oppførselsregler

### Vår Forpliktelse

Vi er forpliktet til å gjøre deltakelse i prosjektet til en trakasseringsfri opplevelse for alle, uavhengig av alder, kroppstype, funksjonshemming, etnisitet, kjønn, erfaring, nasjonalitet, utseende, rase, religion eller seksuell identitet og orientering.

### Våre Standarder

**Eksempler på oppførsel som bidrar til et positivt miljø:**

- Bruk av velkommen og inkluderende språk
- Respekt for ulike synspunkter og erfaringer
- Aksept av konstruktiv kritikk
- Fokus på hva som er best for fellesskapet
- Empati overfor andre medlemmer

**Eksempler på uakseptabel oppførsel:**

- Bruk av seksualisert språk eller bilder
- Trolling, fornærmende kommentarer eller personangrep
- Offentlig eller privat trakassering
- Publisering av andres private informasjon
- Annen uetisk eller uprofesjonell oppførsel

## Hvordan kan jeg bidra?

### Rapportere Bugs 🐛

Bugs rapporteres via GitHub Issues. Når du rapporterer en bug:

1. **Sjekk først** om problemet allerede er rapportert
2. **Bruk en beskrivende tittel** for å identifisere problemet
3. **Beskriv nøyaktig** trinnene for å reprodusere problemet
4. **Gi eksempler** med kodesamples hvis mulig
5. **Beskriv observert oppførsel** og hva du forventet skulle skje
6. **Inkluder miljøinformasjon**:
   - iOS-versjon
   - Xcode-versjon
   - Swift-versjon
   - Enhetstype (simulator/fysisk enhet)

### Foreslå Nye Funksjoner 💡

Nye funksjoner foreslås også via GitHub Issues:

1. **Bruk en klar og beskrivende tittel**
2. **Beskriv detaljert** den foreslåtte funksjonaliteten
3. **Forklar hvorfor** denne funksjonen ville være nyttig
4. **Gi eksempler** på brukstilfeller
5. **List eventuelle alternativer** du har vurdert

### Bidra med Kode 💻

1. **Fork repositoryet** og opprett en branch fra `main`
2. **Gjør dine endringer** og test grundig
3. **Følg kodestilen** beskrevet nedenfor
4. **Skriv eller oppdater tester** for din funksjonalitet
5. **Oppdater dokumentasjon** hvis nødvendig
6. **Send en Pull Request**

## Utviklingsoppsett

### Forutsetninger

- macOS 10.15 eller nyere
- Xcode 13.0 eller nyere
- Swift 5.7 eller nyere
- Git

### Oppsett

```bash
# 1. Fork repositoryet på GitHub

# 2. Klon din fork
git clone https://github.com/DIN-BRUKER/AutentiseringApp.git
cd AutentiseringApp

# 3. Legg til upstream remote
git remote add upstream https://github.com/GizzZmo/AutentiseringApp.git

# 4. Installer avhengigheter
sh Scripts/setup.sh

# 5. Opprett en feature branch
git checkout -b feature/min-nye-funksjon

# 6. Åpne i Xcode
open Package.swift
```

### Holde din Fork Oppdatert

```bash
# Hent endringer fra upstream
git fetch upstream

# Merge med main
git checkout main
git merge upstream/main

# Push til din fork
git push origin main
```

## Kodestil

### Swift Style Guide

Vi følger [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

#### Nøkkelprinsipper

**Navngivning:**
```swift
// ✅ Bra: Tydelige, beskrivende navn
func autentiserBruker(brukerID: String, passord: String?)

// ❌ Dårlig: Uklar, forkortet navngivning
func auth(id: String, pwd: String?)
```

**Innrykk:**
- Bruk 4 spaces (ikke tabs)
- Xcode skal konfigureres til 4 spaces

**Linjebegrensning:**
- Maks 120 tegn per linje
- Bryt lange linjer på logiske steder

**Kommentarer:**
```swift
// Enkeltlinjekommentarer for korte forklaringer

/// Dokumentasjonskommentarer for public API
/// - Parameter brukerID: Unik identifikator for brukeren
/// - Returns: True hvis autentisering er vellykket
func autentiserBruker(brukerID: String) -> Bool {
    // Implementasjon
}
```

**Konstanter og Variabler:**
```swift
// ✅ Bra: let for immutable verdier
let maxFeilForsøk = 3

// ❌ Dårlig: var når verdi ikke endres
var maxFeilForsøk = 3
```

**Guard Statements:**
```swift
// ✅ Bra: Bruk guard for early exit
guard let data = optionalData else {
    return
}

// ❌ Dårlig: Nested if-statements
if let data = optionalData {
    // Lang kodeblokk
}
```

### SwiftUI Spesifikke Retningslinjer

```swift
// ✅ Bra: Strukturert og lesbar
struct MinView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        VStack {
            headerView
            authenticationButton
        }
    }
    
    private var headerView: some View {
        Text("Velkommen")
            .font(.title)
    }
    
    private var authenticationButton: some View {
        Button("Logg inn", action: authenticate)
    }
    
    private func authenticate() {
        // Autentiseringslogikk
    }
}
```

### Dokumentasjon

Alle public API-er skal ha dokumentasjonskommentarer:

```swift
/// Autentiserer en bruker med biometriske data eller passord.
///
/// Denne metoden forsøker først biometrisk autentisering. Hvis det feiler,
/// faller den tilbake til passordautentisering.
///
/// - Parameters:
///   - brukerID: Unik identifikator for brukeren som skal autentiseres
///   - passord: Valgfritt passord for fallback-autentisering
///   - ferdig: Closure som kalles når autentisering er fullført
///
/// - Note: Kontoen låses automatisk etter 3 mislykkede forsøk
///
/// - Example:
///   ```swift
///   authManager.autentiserBruker(brukerID: "user@example.com", passord: nil) { suksess, feil in
///       if suksess {
///           print("Innlogget!")
///       }
///   }
///   ```
func autentiserBruker(brukerID: String, passord: String?, ferdig: @escaping (Bool, String?) -> Void)
```

## Testing

### Kjøre Tester

```bash
# Kjør alle tester
swift test

# Kjør med coverage
swift test --enable-code-coverage

# Kjør spesifikk test
swift test --filter AutentiseringAppTests.AuthenticationTests
```

### Skrive Tester

**Alle nye funksjoner skal ha tester:**

```swift
import XCTest
@testable import AutentiseringApp

final class MinNyeFunksjonTests: XCTestCase {
    var sut: MinKlasse!
    
    override func setUp() {
        super.setUp()
        sut = MinKlasse()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFunksjonalitet() {
        // Given
        let forventet = "resultat"
        
        // When
        let faktisk = sut.minFunksjon()
        
        // Then
        XCTAssertEqual(faktisk, forventet)
    }
}
```

### Test Coverage

- Streb etter minst 80% test coverage
- All business logic skal ha tester
- Edge cases skal dekkes

## Pull Request-prosess

### Før du sender PR

**Sjekkliste:**
- [ ] Koden bygger uten warnings
- [ ] Alle tester kjører (og nye tester er lagt til)
- [ ] Kodestilen følger retningslinjene
- [ ] Dokumentasjon er oppdatert
- [ ] Commit messages er klare og beskrivende
- [ ] Branch er oppdatert med siste `main`

### Commit Messages

Bruk klare, beskrivende commit messages:

```bash
# ✅ Bra
git commit -m "Legg til Face ID-støtte for autentisering"
git commit -m "Fiks crash ved CloudKit-synkronisering"
git commit -m "Oppdater dokumentasjon for BrukerInnstillingerManager"

# ❌ Dårlig
git commit -m "Fix stuff"
git commit -m "WIP"
git commit -m "Update"
```

**Format:**
```
Kort beskrivelse (maks 50 tegn)

Lengre forklaring hvis nødvendig (wrap på 72 tegn).
Forklar hva og hvorfor, ikke hvordan.

- Bullet points er OK
- Bruk bindestreker for lister
```

### PR-mal

Når du oppretter en PR, inkluder:

```markdown
## Beskrivelse
Kort beskrivelse av endringene

## Type endring
- [ ] Bug fix
- [ ] Ny funksjon
- [ ] Breaking change
- [ ] Dokumentasjon

## Hvordan er dette testet?
Beskriv testene du har kjørt

## Sjekkliste
- [ ] Koden følger kodestilen
- [ ] Jeg har kommentert kompleks kode
- [ ] Dokumentasjon er oppdatert
- [ ] Ingen nye warnings
- [ ] Jeg har lagt til tester
- [ ] Alle tester kjører
```

### Review-prosess

1. **Minst én godkjenning** kreves fra maintainers
2. **CI må være grønn** - alle tester må kjøre
3. **Alle kommentarer må addresseres**
4. **Squash og merge** brukes vanligvis for å holde historikk ren

## Ytterligere Ressurser

### Dokumentasjon

- [README.md](README.md) - Prosjektoversikt
- [ABOUT.md](ABOUT.md) - Detaljert arkitektur
- [HOWTO.md](HOWTO.md) - Brukerveiledning

### Eksterne Ressurser

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [LocalAuthentication Framework](https://developer.apple.com/documentation/localauthentication)

## Spørsmål?

Hvis du har spørsmål som ikke er dekket her:

- Opprett et GitHub Issue med labelen "question"
- Start en diskusjon i GitHub Discussions
- Sjekk eksisterende dokumentasjon

## Takk! 🙏

Ditt bidrag, stort eller lite, er verdsatt og gjør AutentiseringApp bedre for alle!

---

**Sist oppdatert**: 2025-10  
**Vedlikeholdt av**: Jon Arve Ovesen
