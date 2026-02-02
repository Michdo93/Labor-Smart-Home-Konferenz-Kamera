# 1. Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "!!! BITTE ALS ADMINISTRATOR STARTEN !!!" -ForegroundColor Red -BackgroundColor Black
    pause
    exit
}

# TLS 1.2 für sichere Verbindung zu GitHub erzwingen
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$workDir = "$env:TEMP\usbip-client"
if (!(Test-Path $workDir)) { New-Item -ItemType Directory -Path $workDir | Out-Null }
cd $workDir

# 2. Dynamisch die aktuellste Download-URL von GitHub holen
Write-Host "Suche aktuellste Version von usbip-win..." -ForegroundColor Cyan
$repo = "cezanne/usbip-win"
$releases = "https://api.github.com/repos/$repo/releases/latest"
try {
    $json = Invoke-RestMethod -Uri $releases
    $zipUrl = ($json.assets | Where-Object { $_.name -like "*.zip" }).browser_download_url
    if (!$zipUrl) { throw "Keine ZIP-Datei gefunden." }
} catch {
    Write-Host "Fehler beim Abrufen der Release-Infos: $($_.Exception.Message)" -ForegroundColor Red
    pause
    exit
}

$zipFile = "$workDir\usbip.zip"

# 3. Download und Entpacken
if (!(Test-Path "$workDir\x64")) {
    Write-Host "Lade herunter: $zipUrl" -ForegroundColor Cyan
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    
    Write-Host "Entpacke Dateien..." -ForegroundColor Cyan
    Expand-Archive -Path $zipFile -DestinationPath $workDir -Force
    Remove-Item $zipFile
}

# 4. In den x64 Ordner navigieren (Sucht rekursiv, falls Struktur abweicht)
$exePath = Get-ChildItem -Path $workDir -Filter "usbip.exe" -Recurse | Select-Object -First 1
if (!$exePath) {
    Write-Host "FEHLER: usbip.exe wurde nicht gefunden!" -ForegroundColor Red
    pause
    exit
}
cd $exePath.Directory.FullName

# 5. Treiber-Setup & Zertifikat
Write-Host "Installiere Treiber-Zertifikat..." -ForegroundColor Cyan
if (Test-Path ".\usbip_test.pfx") {
    Import-Certificate -FilePath .\usbip_test.pfx -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue
}

Write-Host "Registriere virtuellen USB-Hub (Bestätigen Sie das Windows-Popup!)..." -ForegroundColor Cyan
.\usbip.exe install

# 6. Kamera binden
Write-Host "Verbinde Kamera von 192.168.0.231..." -ForegroundColor Green
.\usbip.exe attach -r 192.168.0.231 -b 1-1.2

Write-Host "`nERFOLG: Die Kamera ist jetzt in Zoom/Teams sichtbar." -ForegroundColor Green
Write-Host "WICHTIG: Dieses Fenster offen lassen!" -ForegroundColor Yellow
pause
