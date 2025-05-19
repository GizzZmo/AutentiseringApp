# Bruk offisiell Swift base image
FROM swift:latest AS builder

# Sett arbeidsmappe
WORKDIR /app

# Kopier Package.swift og andre nødvendige filer
COPY Package.swift Package.resolved Sources Tests ./

# Installer avhengigheter
RUN swift package update

# Bygg applikasjonen
RUN swift build -c release

# Opprett et nytt, lettvekts image for runtime
FROM swift:latest AS runtime

WORKDIR /app

# Kopier kun det nødvendige fra builder-steg
COPY --from=builder /app/.build/release /app/build

# Ikke kjør som root for bedre sikkerhet
RUN useradd -m swiftuser
USER swiftuser

EXPOSE 8080

CMD ["/app/build/MyApp"]
