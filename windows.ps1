# 1. Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "!!! BITTE ALS ADMINISTRATOR STARTEN !!!" -ForegroundColor Red -BackgroundColor Black
    pause
    exit
}

# TLS 1.2 erzwingen
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$workDir = "$env:TEMP\usbip-client"
if (!(Test-Path $workDir)) { New-Item -ItemType Directory -Path $workDir | Out-Null }
cd $workDir

# 2. Download der spezifischen DEV-Version
$zipUrl = "https://github.com/cezanne/usbip-win/releases/download/v0.3.6-dev/usbip-win-0.3.6-dev.zip"
$zipFile = "$workDir\usbip.zip"

if (!(Test-Path "$workDir\usbip-win-0.3.6-dev")) {
    Write-Host "Lade USBIP-Client (v0.3.6-dev) herunter..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -ErrorAction Stop
        Write-Host "Entpacke Dateien..." -ForegroundColor Cyan
        Expand-Archive -Path $zipFile -DestinationPath $workDir -Force
        Remove-Item $zipFile
    } catch {
        Write-Host "Fehler beim Download oder Entpacken: $($_.Exception.Message)" -ForegroundColor Red
        pause
        exit
    }
}

# 3. In den x64 Ordner navigieren
# Wir suchen rekursiv nach usbip.exe, um flexibel auf die Ordnerstruktur zu reagieren
$exeFile = Get-ChildItem -Path $workDir -Filter "usbip.exe" -Recurse | Where-Object { $_.FullName -like "*x64*" } | Select-Object -First 1

if (!$exeFile) {
    Write-Host "FEHLER: usbip.exe im x64-Ordner nicht gefunden!" -ForegroundColor Red
    pause
    exit
}

cd $exeFile.Directory.FullName
Write-Host "Arbeitsverzeichnis: $(Get-Location)" -ForegroundColor Gray

# 4. Treiber-Setup
Write-Host "Installiere Treiber-Zertifikat..." -ForegroundColor Cyan
if (Test-Path ".\usbip_test.pfx") {
    Import-Certificate -FilePath .\usbip_test.pfx -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue
}

Write-Host "Registriere virtuellen USB-Hub..." -ForegroundColor Cyan
# Dieser Befehl öffnet ggf. ein Windows-Sicherheits-Popup!
.\usbip.exe install

# 5. Verbinden
Write-Host "Verbinde Kamera von 192.168.0.231 (Bus 1-1.2)..." -ForegroundColor Green
.\usbip.exe attach -r 192.168.0.231 -b 1-1.2

Write-Host "`nERFOLG: Die Kamera ist jetzt verbunden." -ForegroundColor Green
Write-Host "WICHTIG: Dieses Fenster nicht schließen!" -ForegroundColor Yellow
pause
