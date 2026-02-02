#!/bin/bash
# Prüfen auf Root-Rechte
if [ "$EUID" -ne 0 ]; then echo "Bitte als root ausführen (sudo)" ; exit ; fi

# Installiere usbip falls nicht vorhanden
if ! command -v usbip &> /dev/null; then
    apt-get update && apt-get install -y linux-tools-generic hwdata
    # Verlinkung fixen, da der Pfad oft versionsabhängig ist
    ln -s /usr/lib/linux-tools/*/usbip /usr/bin/usbip 2>/dev/null
fi

# Kernel-Modul laden
modprobe vhci-hcd

# Gerät einbinden
usbip attach -r 192.168.0.231 -b 1-1.2
echo "Kamera erfolgreich verbunden!"
