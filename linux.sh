#!/bin/bash

# 1. Root-Check
if [ "$EUID" -ne 0 ]; then 
    echo "Fehler: Bitte als root ausführen (sudo)."
    exit 1
fi

# 2. Distribution erkennen
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "System konnte nicht identifiziert werden."
    exit 1
fi

echo "Erkannte Distribution: $DISTRO"

# 3. Spezifische Installation je nach System
case $DISTRO in
    ubuntu|debian|raspbian|pop)
        if ! command -v usbip &> /dev/null; then
            apt-get update && apt-get install -y linux-tools-generic hwdata
            ln -s /usr/lib/linux-tools/*/usbip /usr/bin/usbip 2>/dev/null
        fi
        ;;
    arch|manjaro)
        if ! command -v usbip &> /dev/null; then
            pacman -Sy --noconfirm usbutils hwdata
        fi
        ;;
    fedora)
        if ! command -v usbip &> /dev/null; then
            dnf install -y usbip hwdata
        fi
        ;;
    *)
        echo "Dieses Skript unterstützt $DISTRO noch nicht automatisch."
        echo "Bitte usbip manuell installieren."
        ;;
esac

# 4. Kernel-Modul laden
# VHCI-HCD ist der virtuelle Host Controller für USB/IP
if ! lsmod | grep -q "vhci_hcd"; then
    echo "Lade Kernel-Modul vhci-hcd..."
    modprobe vhci-hcd || { echo "Fehler: Modul konnte nicht geladen werden."; exit 1; }
fi

# 5. Gerät einbinden
echo "Versuche Kamera von 192.168.0.231 einzubinden..."
usbip attach -r 192.168.0.231 -b 1-1.2

if [ $? -eq 0 ]; then
    echo "Kamera erfolgreich verbunden!"
else
    echo "Fehler beim Einbinden des Geräts."
fi

echo "Versuche Konferenz-Lautsprecher von 192.168.0.231 einzubinden..."
usbip attach -r 192.168.0.231 -b 1-1.5

if [ $? -eq 0 ]; then
    echo "Konferenz-Lautsprecher erfolgreich verbunden!"
else
    echo "Fehler beim Einbinden des Geräts."
fi

