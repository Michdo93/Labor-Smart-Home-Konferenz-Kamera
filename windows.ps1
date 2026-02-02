# 1. Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "!!! BITTE ALS ADMINISTRATOR STARTEN !!!" -ForegroundColor Red -BackgroundColor Black
    pause
    exit
}

# TLS 1.2 erzwingen (Wichtig für Downloads von GitHub)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$workDir = "$env:TEMP\usbip-client"
if (!(Test-Path $workDir)) { New-Item -ItemType Directory -Path $workDir | Out-Null }
cd $workDir

# 2. Download mit Fehlerprüfung
$zipUrl = "https://github.com/cezanne/usbip-win/releases/download/v0.3.6/usbip-win-0.3.6.zip"
$zipFile = "$workDir\usbip.zip"

if (!(Test-Path "$workDir\usbip-win-0.3.6")) {
    Write-Host "Lade USBIP-Client von GitHub herunter..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -ErrorAction Stop
        Write-Host "Entpacke Dateien..." -ForegroundColor Cyan
        Expand-Archive -Path $zipFile -DestinationPath $workDir -Force
    } catch {
        Write-Host "Fehler beim Download: $($_.Exception.Message)" -ForegroundColor Red
        pause
        exit
    }
}

# 3. In den x64 Ordner wechseln
$exeDir = Get-ChildItem -Path $workDir -Filter "x64" -Recurse | Select-Object -First 1
if ($exeDir -eq $null) {
    Write-Host "Fehler: x64 Ordner wurde im ZIP nicht gefunden!" -ForegroundColor Red
    dir $workDir
    pause
    exit
}

cd $exeDir.FullName
Write-Host "Arbeitsverzeichnis: $(Get-Location)" -ForegroundColor Gray

# 4. Treiber-Setup
Write-Host "Installiere Treiber-Zertifikat..." -ForegroundColor Cyan
# Das Zertifikat ist im selben Ordner wie die usbip.exe
if (Test-Path ".\usbip_test.pfx") {
    Import-Certificate -FilePath .\usbip_test.pfx -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue
}

Write-Host "Registriere virtuellen USB-Hub..." -ForegroundColor Cyan
.\usbip.exe install

# 5. Verbinden
Write-Host "Verbinde Kamera von 192.168.0.231 (Bus 1-1.2)..." -ForegroundColor Green
.\usbip.exe attach -r 192.168.0.231 -b 1-1.2

Write-Host "`nERFOLG: Die Kamera ist jetzt verbunden." -ForegroundColor Green
Write-Host "WICHTIG: Dieses Fenster nicht schließen!" -ForegroundColor Yellow
pause
