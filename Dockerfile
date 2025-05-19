# Bruk offisiell Swift base image
FROM swift:latest AS builder

# Sett arbeidsmappe
WORKDIR /app

# Kopier kildekoden
COPY . .

# Installer avhengigheter og oppdater pakker
RUN swift package update

# Bygg applikasjonen
RUN swift build -c release

# Opprett et nytt, lettvekts image for runtime
FROM swift:latest AS runtime

# Sett arbeidsmappe for runtime
WORKDIR /app

# Kopier kun det nødvendige fra builder-steg
COPY --from=builder /app/.build/release /app/build

# Ikke kjør som root for bedre sikkerhet
RUN useradd -m swiftuser
USER swiftuser

# Eksponer porten som applikasjonen kjører på
EXPOSE 8080

# Start applikasjonen
CMD ["/app/build/MyApp"]
