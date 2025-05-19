# AutentiseringApp 🚀
En moderne iOS-app med **biometrisk autentisering, sanntidssynkronisering, og brukerspesifikke innstillinger** basert på akademiske paradigmer.

## 🔥 Funksjoner
✅ **Biometrisk autentisering med haptisk tilbakemelding**  
✅ **Spring-animasjoner og pulserende indikatorer**  
✅ **CloudKit-synkronisering og sanntidsoppdateringer**  
✅ **Deling av data mellom brukere med CKShare**  
✅ **Administrasjon av delingstillatelser med UI-komponenter**  
✅ **Slack-varsler etter deploy for team-kommunikasjon**  

## 🚀 Kom i gang
### 📦 Installer avhengigheter
```sh
sh Scripts/setup.sh

//**  

##Her er en oppsummering av hva prosjektet ser ut til å handle om og hvilke teknologier som brukes:

**Hovedformål og Funksjonalitet:**

Prosjektet "AutentiseringApp" ser ut til å være en applikasjon designet for å håndtere:

* **Autentisering:** Spesielt biometrisk autentisering (som Face ID eller Touch ID), antydet av `AuthenticationManager.swift` og `face_id_animation.json`.
* **Datadeling og Synkronisering via CloudKit:** Appen bruker CloudKit for å dele data (`CloudKitSharingManager.swift` med `CKShare`) og for å motta sanntidsoppdateringer (`CloudKitSubscriptionManager.swift`).
* **Brukerinnstillinger:** Den lagrer og henter brukerspesifikke innstillinger (`UserSettingsManager.swift`).
* **Administrasjon av Tilgang:** Det finnes en UI-komponent bygget med SwiftUI (`SharingSettingsView.swift`) for å administrere deling og tilgang.

**Kjernekomponenter og Teknologier:**

* **Programmeringsspråk:** Swift er hovedspråket, med `index.swift` og `main.swift` som sannsynlige inngangspunkter for applikasjonen.
* **Brukergrensesnitt:** SwiftUI brukes for minst deler av brukergrensesnittet (`SharingSettingsView.swift`).
* **Backend og Databehandling:** Apple CloudKit brukes for skytjenester som datalagring, deling og sanntidsoppdateringer.
* **Automatisering og CI/CD:**
    * **Scripts (`📁 Scripts`):** Inneholder shell-scripts for å installere avhengigheter (`setup.sh`), automatisere GitHub-deployeringer (`deploy.sh`), sende Slack-varsler (`slack_notify.sh`), og bygge Docker-containere (`docker_build.sh`).
    * **GitHub Actions (`📁 .github/workflows`):** Brukes for kontinuerlig integrasjon og leveranse (CI/CD) med filer for automatisk deployering (`deploy.yml`) og Docker-bygg/testing (`docker-ci.yml`).
* **Containerisering (`📁 Docker`):**
    * Prosjektet benytter Docker for å lage og administrere containere, med en `Dockerfile` for å bygge et image og en `docker-compose.yml` for å automatisere oppsett av flere containere.
* **Ressurser (`📁 Assets`):** Inkluderer grafiske elementer som Lottie-animasjoner (for eksempel `face_id_animation.json` for autentisering) og ikoner.
* **Dokumentasjon:**
    * `README.md`: Gir en generell beskrivelse av prosjektet.
    * `HOWTO.md`: Tilbyr en trinnvis brukerveiledning.

**Oppsummert:**

"AutentiseringApp" er et Swift-basert prosjekt som ser ut til å tilby robuste autentiseringsmekanismer, inkludert biometri, og benytter CloudKit for skytjenester. Det har et tydelig fokus på moderne utviklingspraksis med bruk av CI/CD via GitHub Actions, containerisering med Docker, og automatiseringsskript. Filstrukturen indikerer et velorganisert prosjekt.

Dette gir en mye klarere innsikt enn det var mulig å få fra GitHub-lenkene alene!
