# Bruk en offisiell Swift-image
FROM swift:latest

# Sett arbeidsdirektivet
WORKDIR /app

# Kopier kildekoden inn i containeren
COPY . .

# Installer avhengigheter
RUN swift package update

# Bygg applikasjonen
RUN swift build

# Kjør applikasjonen
CMD ["swift", "run", "main.swift"]
