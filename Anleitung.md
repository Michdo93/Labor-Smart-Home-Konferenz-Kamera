# 🎥 Anleitung: Top-Down Kamera verbinden

In diesem Raum befindet sich eine Überkopf-Kamera für den Konferenztisch. Du kannst diese Kamera direkt über das Netzwerk mit deinem Laptop verbinden, sodass sie in **Zoom, Teams oder Webex** als lokale Webcam erscheint.

## 🚀 Schnellstart

1. Öffne das **Terminal** (Mac/Linux) oder die **PowerShell** (Windows).
2. Kopiere den passenden Befehl für dein Betriebssystem und drücke **Enter**.
3. Wähle in deiner Videokonferenz-App die Kamera **"USB Camera"** aus.

### 💻 Befehle zum Kopieren

| Betriebssystem | Befehl (Kopieren & Einfügen) |
| --- | --- |
| **Windows** | `irm https://bit.ly/4ttNGds | iex` |
| **macOS** | `curl -sSL https://bit.ly/4khnFK6 | bash` |
| **Linux** | `curl -sSL https://bit.ly/4q9fGQv | sudo bash` |

---

## ⚠️ Wichtige Hinweise für die Erstnutzung

### 🪟 Windows Nutzer

* Das Terminal muss **als Administrator** gestartet werden (Rechtsklick auf Start -> Terminal/PowerShell (Administrator)).
* Beim ersten Start wird ein Treiber-Zertifikat installiert. Bestätige das Windows-Sicherheits-Popup mit **"Installieren"**.
* **Lasse das Fenster offen**, solange du die Kamera nutzt!

### 🍎 macOS Nutzer

* Beim ersten Mal blockiert Apple den Treiber. Öffne **Systemeinstellungen > Datenschutz & Sicherheit**.
* Scrolle nach unten und klicke bei "Systemsoftware von Jonathan Beri wurde blockiert" auf **Erlauben**.
* Starte das Skript danach erneut.

### 🐧 Linux Nutzer

* Das Skript benötigt `sudo`-Rechte, um das Kernel-Modul `vhci-hcd` zu laden.

---

## 🛑 Verbindung trennen

Wenn du fertig bist, drücke im Terminal einfach **STRG + C** oder schließe das Fenster. Dadurch wird die Kamera für den nächsten Nutzer am Tisch wieder freigegeben.

---

**Projekt-Repository:** [GitHub: Michdo93/Labor-Smart-Home-Konferenz-Kamera](https://www.google.com/search?q=https://github.com/Michdo93/Labor-Smart-Home-Konferenz-Kamera)

---
### Was ich noch für dich tun kann:

Soll ich dir ein kurzes **HTML-Snippet** erstellen, falls du diese Befehle auf einer schicken internen Webseite mit "Klick-to-Copy"-Buttons anzeigen möchtest?
