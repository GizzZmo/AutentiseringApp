## AutentiseringApp

## **📁 Prosjektfilstruktur**
```
📦 AutentiseringApp
 ├── 📁 Source
 │   ├── AuthenticationManager.swift
 │   ├── CloudKitSharingManager.swift
 │   ├── CloudKitSubscriptionManager.swift
 │   ├── UserSettingsManager.swift
 │   ├── SharingSettingsView.swift
 ├── 📁 Assets
 │   ├── face_id_animation.json (Lottie-animasjon)
 │   ├── icons (Mappe med grafiske ikoner)
 ├── 📁 Scripts
 │   ├── setup.sh (Automatisk installasjonsscript)
 │   ├── deploy.sh (Script for å laste opp til GitHub)
 ├── index.swift
 ├── main.swift
 ├── README.md
 ├── HOWTO.md
```

---

## **📜 README.md**
```markdown
# AutentiseringApp 🚀
En kraftig iOS-app for biometrisk autentisering med **haptisk tilbakemelding, spring-animasjoner, CloudKit-synkronisering og brukerspesifikke innstillinger**.

## 🔥 Funksjoner
✅ **Haptisk tilbakemelding** for en bedre brukeropplevelse  
✅ **Spring-animasjoner** for en jevn visuell effekt  
✅ **Pulserende Face ID-ikon** for intuitiv autentisering  
✅ **Lottie-animasjon** for en profesjonell touch  
✅ **Adaptiv mørk/lys-modus**  
✅ **CloudKit-synkronisering og sanntidsoppdateringer**  
✅ **Sikkerhetslogging og håndtering av flere brukere**  
✅ **Deling av data mellom brukere med CKShare**  
✅ **Administrasjon av delingstillatelser med UI-komponenter**  

## 🚀 Kom i gang
### 📦 Installer avhengigheter
```sh
sh Scripts/setup.sh
```

### ▶️ Kjør applikasjonen
```sh
swift run main.swift
```

### 📤 Deploy til GitHub
```sh
sh Scripts/deploy.sh
```

---
## **📖 HOWTO.md**
```markdown
# 💡 Hvordan bruke denne appen?
## 1️⃣ **Autentisering**
- Biometrisk autentisering med **Face ID**
- Alternativ fallback med **passkode**
- **Spring-animasjoner** og **Lottie-effekter**

## 2️⃣ **CloudKit-synkronisering**
- Sanntidsoppdatering av brukerspesifikke innstillinger.
- **UserDefaults + iCloud Key-Value Storage + CloudKit Subscriptions**

## 3️⃣ **Deling av data**
- **CKShare** for samarbeid mellom brukere.
- **Visuell UI-komponent** for administrasjon av tillatelser.

## 4️⃣ **Deployment til GitHub**
Bruk **deploy.sh** for å automatisk laste opp koden til GitHub.
```

---

## **📜 setup.sh (Installasjonsscript)**
```sh
#!/bin/bash
echo "🔧 Installerer avhengigheter..."
swift package update
echo "✅ Ferdig!"
```

---

## **📜 deploy.sh (GitHub-deploy)**
```sh
#!/bin/bash
echo "🚀 Initialiserer GitHub-repo..."
git init
git add .
git commit -m "Initial commit"
echo "📤 Skyver til GitHub..."
git remote add origin <DIN_GITHUB_URL>
git push -u origin main
echo "✅ Ferdig!"
```

---

Med denne strukturen kan du enkelt **installere, kjøre, synkronisere og dele** prosjektet ditt på GitHub! 🚀 **Vil du ha hjelp med GitHub-repo-setup også?** 😊
