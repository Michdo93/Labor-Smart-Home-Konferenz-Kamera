#!/bin/bash
# 1. Homebrew Check
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. USBIP via das neue Repo installieren
brew tap beriberikix/usbipd-mac
brew install usbip

# 3. System Extension registrieren (Das ist der kritische Punkt!)
echo "ACHTUNG: Bitte bestätige die Systemerweiterung in den Einstellungen!"
sudo usbipd install-system-extension

# 4. Versuch der Verbindung
sudo usbip attach -r 192.168.0.231 -b 1-1.2
