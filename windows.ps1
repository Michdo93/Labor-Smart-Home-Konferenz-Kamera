# 1. Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Bitte die PowerShell als ADMINISTRATOR starten!" -ForegroundColor Red
    exit
}

$workDir = "$env:TEMP\usbip-client"
if (!(Test-Path $workDir)) { New-Item -ItemType Directory -Path $workDir }

# 2. Download cezanne/usbip-win (v0.3.6 ist die stabilste portable Version)
$zipUrl = "https://github.com/cezanne/usbip-win/releases/download/v0.3.6/usbip-win-0.3.6.zip"
$zipFile = "$workDir\usbip.zip"

if (!(Test-Path "$workDir\usbip.exe")) {
    Write-Host "Lade USBIP-Client herunter..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $workDir -Force
}

# 3. Treiber-Zertifikat importieren & Treiber installieren
# Das ist nötig, damit Windows den Treiber ohne Warnung akzeptiert
Write-Host "Installiere Treiber..." -ForegroundColor Cyan
cd $workDir
# Zertifikat installieren (falls vorhanden)
Import-Certificate -FilePath .\usbip_test.pfx -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue

# Den virtuellen USB-Hub-Treiber installieren (einmalig nötig)
.\usbip.exe install

# 4. Kamera vom Raspberry Pi einbinden
Write-Host "Verbinde Kamera von 192.168.0.231..." -ForegroundColor Green
.\usbip.exe attach -r 192.168.0.231 -b 1-1.2

Write-Host "Fertig! Die Kamera sollte nun in Zoom erscheinen." -ForegroundColor Green
Write-Host "Dieses Fenster nicht schließen, solange die Kamera genutzt wird!"
pause
