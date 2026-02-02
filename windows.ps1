# 3. Den Pfad zur usbip.exe dynamisch finden
Write-Object "Suche nach usbip.exe in $workDir..."
$exeFile = Get-ChildItem -Path $workDir -Filter "usbip.exe" -Recurse | Where-Object { $_.FullName -like "*x64*" } | Select-Object -First 1

if (!$exeFile) {
    Write-Host "FEHLER: usbip.exe wurde nicht gefunden!" -ForegroundColor Red
    Write-Host "Inhalt von $workDir :"
    Get-ChildItem -Path $workDir -Recurse | Select-Object FullName
    pause
    exit
}

# Wechsle in das Verzeichnis der gefundenen .exe
$exeDir = $exeFile.Directory.FullName
cd $exeDir
Write-Host "Gefunden in: $exeDir" -ForegroundColor Gray

# 4. Treiber-Setup
Write-Host "Installiere Treiber-Zertifikat..." -ForegroundColor Cyan
$certFile = Get-ChildItem -Path $exeDir -Filter "usbip_test.pfx" | Select-Object -First 1
if ($certFile) {
    Import-Certificate -FilePath $certFile.FullName -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -ErrorAction SilentlyContinue
}

Write-Host "Registriere virtuellen USB-Hub..." -ForegroundColor Cyan
.\usbip.exe install
