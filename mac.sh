#!/bin/bash

# Farbcodes für bessere Lesbarkeit
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}--- macOS USB/IP Kamera-Setup ---${NC}"

# 1. Homebrew Check
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew nicht gefunden. Installation wird gestartet...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}[OK] Homebrew ist installiert.${NC}"
fi

# 2. USBIP Client via beriberikix Tap installieren
if ! command -v usbip &> /dev/null; then
    echo -e "${CYAN}Installiere USBIP-Client (beriberikix)...${NC}"
    brew tap beriberikix/usbipd-mac
    brew install usbip
else
    echo -e "${GREEN}[OK] USBIP-Client ist installiert.${NC}"
fi

# 3. System Extension registrieren
echo -e "${YELLOW}Registriere Treiber-Erweiterung (Passwort erforderlich)...${NC}"
sudo usbipd install-system-extension

# 4. Sicherheits-Check (Die Apple-Hürde)
echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"
echo -e "${RED}WICHTIG: Falls macOS 'Systemerweiterung blockiert' anzeigt:${NC}"
echo -e "1. Öffne 'Systemeinstellungen' > 'Datenschutz & Sicherheit'."
echo -e "2. Scrolle ganz nach unten."
echo -e "3. Klicke bei 'Software von Jonathan Beri' auf '${GREEN}Erlauben${NC}'."
echo -e "4. Falls ein Neustart verlangt wird, führe ihn durch und starte das Skript erneut."
echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"

# 5. Verbinden
echo -e "${CYAN}Verbinde Kamera von 192.168.0.231 (Bus 1-1.2)...${NC}"
sudo usbip attach -r 192.168.0.231 -b 1-1.2

if [ $? -eq 0 ]; then
    echo -e "${GREEN}ERFOLG: Die Kamera sollte nun in Zoom verfügbar sein!${NC}"
else
    echo -e "${RED}FEHLER: Verbindung fehlgeschlagen. Prüfe, ob die IP erreichbar ist.${NC}"
fi

echo -e "${YELLOW}Lasse dieses Fenster offen, solange du die Kamera nutzt.${NC}"
read -p "Drücke ENTER zum Trennen und Beenden..."
