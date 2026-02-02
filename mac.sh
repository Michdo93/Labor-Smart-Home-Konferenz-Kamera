#!/bin/bash
# Prüfen auf Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew nicht gefunden. Installation startet..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Tap hinzufügen und usbip-client installieren
brew tap clover/usbip-macos
brew install usbip-client

# Laden der Kernel-Extension (erfordert ggf. Freigabe in Systemeinstellungen)
sudo kextload /usr/local/lib/usbip-client.kext 2>/dev/null

# Verbinden
sudo usbip attach -r 192.168.0.231 -b 1-1.2
