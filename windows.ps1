# Als Administrator ausführen!
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Bitte die PowerShell als Administrator starten!" -ForegroundColor Red
    exit
}

# Prüfen ob usbipd installiert ist (via winget)
if (!(Get-Command usbipd -ErrorAction SilentlyContinue)) {
    Write-Host "Installiere usbipd-win..."
    winget install --id dorssel.usbipd-win -e --silent
    Write-Host "Installation abgeschlossen. Bitte das Skript erneut starten."
    exit
}

# Gerät einbinden
usbipd attach --remote 192.168.0.231 --busid 1-1.2
Write-Host "Kamera verbunden!"
