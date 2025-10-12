# Om AutentiseringApp 📱

## Prosjektoversikt

AutentiseringApp er en moderne iOS-applikasjon bygget med Swift som tilbyr robust og sikker biometrisk autentisering kombinert med CloudKit-basert datasynkronisering. Prosjektet er designet som et gjenbrukbart Swift Package som enkelt kan integreres i andre iOS-applikasjoner.

## 🎯 Formål

Hovedformålet med AutentiseringApp er å:

1. **Sikre Autentisering**: Tilby robust biometrisk autentisering (Face ID/Touch ID) med fallback til passordbasert autentisering
2. **Datadeling**: Muliggjøre sikker deling av data mellom brukere via CloudKit
3. **Gjenbrukbarhet**: Fungere som et Swift Package som kan integreres i flere applikasjoner
4. **Brukeropplevelse**: Levere en moderne, responsiv og intuitiv brukeropplevelse med animasjoner og haptisk tilbakemelding

## 🏗️ Arkitektur

### Kjernekomponenter

#### 1. AuthenticationManager
Håndterer all autentiseringslogikk:
- Biometrisk autentisering (Face ID/Touch ID)
- Passordbasert fallback-autentisering
- Sikker lagring i iOS Keychain
- Automatisk kontolåsing etter mislykkede forsøk
- Haptisk tilbakemelding for bedre brukeropplevelse

#### 2. CloudKitDelingsManager
Administrerer datadeling via CloudKit:
- Oppretter og administrerer CKShare-objekter
- Støtter ulike tilgangsnivåer (kun lesing, les og skriv, privat)
- Sender push-varsler ved delingsoppdateringer
- Logger all delingsaktivitet

#### 3. CloudKitSubscriptionManager
Håndterer sanntidsoppdateringer:
- Oppretter CloudKit-abonnementer for sanntidsdata
- Håndterer push-varsler fra CloudKit
- Synkroniserer data automatisk ved endringer

#### 4. BrukerInnstillingerManager (UserSettingsManager)
Administrerer brukerspesifikke innstillinger:
- Lagrer delingstillatelser
- Bruker UserDefaults for persistent lagring
- Tilbyr typesikre innstillinger via enums

#### 5. SharingSettingsView
SwiftUI-basert brukergrensesnitt:
- Moderne og intuitivt grensesnitt
- Administrering av delingstillatelser
- Tilgangsstyring for data

### Teknologistakk

- **Språk**: Swift 5.7+
- **Plattformer**: iOS 15+, macOS 10.15+
- **UI-rammeverk**: SwiftUI
- **Backend**: Apple CloudKit
- **Sikkerhet**: iOS Keychain, LocalAuthentication framework
- **Animasjoner**: Lottie (for Face ID-animasjoner)
- **CI/CD**: GitHub Actions
- **Avhengigheter**: 
  - swift-nio (nettverkskommunikasjon)
  - swift-crypto (kryptografiske operasjoner)

## 🔐 Sikkerhet

AutentiseringApp implementerer flere sikkerhetslag:

### Autentisering
- Biometrisk autentisering som primær metode
- Kryptert passordlagring i iOS Keychain
- Automatisk kontolåsing etter 3 mislykkede forsøk
- Ingen sensitiv informasjon lagres i klartekst

### Datahåndtering
- All data synkroniseres via Apples sikre CloudKit-tjeneste
- Støtte for fin-grained tilgangskontroll
- Kryptering i transit og at rest via CloudKit
- Brukerkontrollert deling med eksplisitte tillatelser

## 📦 Pakkehåndtering

Prosjektet er strukturert som et Swift Package Manager (SPM) prosjekt:

```swift
// swift-tools-version:5.7
Package(
    name: "AutentiseringApp",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(name: "AutentiseringApp", targets: ["AutentiseringApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "2.0.0")
    ]
)
```

## 🚀 Bruksområder

AutentiseringApp er ideell for:

1. **Enterprise-applikasjoner**: Sikker autentisering for forretningsapper
2. **Helse- og finans-apper**: Hvor sikkerhet er kritisk
3. **Samarbeidsplattformer**: Med behov for datadeling mellom brukere
4. **Multi-app økosystemer**: Gjenbrukbar autentiseringsløsning på tvers av apper

## 🎨 Brukeropplevelse

### Animasjoner og Tilbakemelding
- Lottie-animasjoner for Face ID-prosessen
- Spring-animasjoner for UI-overganger
- Pulserende indikatorer for lasting
- Haptisk tilbakemelding for brukerhandlinger

### Tilgjengelighet
- Støtte for VoiceOver
- Dynamic Type for lesbarhet
- Kontrastjusterte farger
- Fallback-alternativer for alle funksjoner

## 🔄 CI/CD og Automatisering

Prosjektet benytter moderne DevOps-praksis:

### GitHub Actions
- Automatisk testing på macOS
- Kontinuerlig integrasjon ved hver commit
- Automatiserte byggestadier

### Scripts
- `setup.sh`: Automatisk installasjon av avhengigheter
- `slack_notify.sh`: Slack-varsler etter deployment

## 📊 Ytelse og Skalerbarhet

- **Asynkron datahenting**: Ikke-blokkerende operasjoner
- **Effektiv caching**: Redusert nettverkstrafikk
- **Lazy loading**: Ressurser lastes kun når nødvendig
- **CloudKit-optimalisering**: Batch-operasjoner og delta-synkronisering

## 🌍 Internasjonalisering

Appen er primært utviklet på norsk, men arkitekturen støtter:
- Enkelt lokalisering til flere språk
- Riktig håndtering av locale-spesifikk formatering
- Unicode-støtte for alle tekstfelter

## 📝 Lisens

AutentiseringApp er lisensiert under BSD 3-Clause License.

Copyright (c) 2025, Jon Arve Ovesen

Se [LICENSE](LICENSE) for fullstendige lisensbetingelser.

## 👥 Bidrag

Prosjektet er åpent for bidrag. Vennligst se [HOWTO.md](HOWTO.md) for retningslinjer for utvikling og bruk.

## 🔗 Relaterte Ressurser

- **README.md**: Hurtigstartveiledning og installasjonsinstruksjoner
- **HOWTO.md**: Detaljert brukerveiledning
- **Package.swift**: Swift Package Manager-konfigurasjon
- **GitHub Repository**: [GizzZmo/AutentiseringApp](https://github.com/GizzZmo/AutentiseringApp)

## 📞 Kontakt og Support

For spørsmål, feilrapporter eller forslag til forbedringer:
- Opprett et issue på GitHub
- Konsulter eksisterende dokumentasjon
- Se kodeeksempler i README.md

---

**Versjon**: 1.0.0  
**Sist oppdatert**: 2025-10  
**Vedlikeholdt av**: Jon Arve Ovesen
