# 1. Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Bitte die PowerShell als ADMINISTRATOR starten!" -ForegroundColor Red
    exit
}

$workDir = "$env:TEMP\usbip-client"
if (!(Test-Path $workDir)) { New-Item -ItemType Directory -Path $workDir }

# 2. Download cezanne/usbip-win
$zipUrl = "https://github.com/cezanne/usbip-win/releases/download/v0.3.6/usbip-win-0.3.6.zip"
$zipFile = "$workDir\usbip.zip"

if (!(Test-Path "$workDir\usbip-win-0.3.6")) {
    Write-Host "Lade USBIP-Client herunter..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $workDir -Force
}

# 3. In den x64 Ordner wechseln (Wichtig!)
$exeDir = "$workDir\usbip-win-0.3.6\x64"
if (!(Test-Path $exeDir)) {
    Write-Host "Fehler: x64 Ordner nicht gefunden!" -ForegroundColor Red
    exit
}
cd $exeDir

# 4. Treiber-Zertifikat importieren & Hub installieren
Write-Host "Bereite Treiber vor..." -ForegroundColor Cyan
# Importiert das Test-Zertifikat, damit Windows den Treiber akzeptiert
Import-Certificate -FilePath .\usbip_test.pfx -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue

# Installiert den virtuellen USB-Hub (Falls noch nicht geschehen)
.\usbip.exe install

# 5. Kamera verbinden
Write-Host "Verbinde Kamera von 192.168.0.231..." -ForegroundColor Green
.\usbip.exe attach -r 192.168.0.231 -b 1-1.2

Write-Host "ERFOLG: Die Kamera sollte nun in Zoom erscheinen." -ForegroundColor Green
Write-Host "Lasse dieses Fenster offen, solange du die Kamera brauchst!"
pause
