@echo off
title Maintenance du PC
echo ========================================
echo          Maintenance du PC
echo ========================================
echo.

:: Mise à jour de Windows via PSWindowsUpdate
echo Mise a jour de Windows...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Install-Module -Name PSWindowsUpdate -Force"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-WindowsUpdate -Install -AcceptAll -AutoReboot"

echo.

:: Mise à jour Windows via UsoClient
echo Recherche et installation des mises a jour de Windows...
UsoClient StartScan
UsoClient StartDownload
UsoClient StartInstall
UsoClient ScanInstallWait
UsoClient RestartDevice

echo.

:: Mise à jour des applications via winget
echo Mise a jour des applications via winget...
winget upgrade --all

echo.

:: Installation et mise à jour des logiciels via Chocolatey
echo Mise a jour des logiciels via Chocolatey...
:: Vérifie si Chocolatey est installé, sinon l'installe
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "if (!(Get-Command choco -ErrorAction SilentlyContinue)) { Set-ExecutionPolicy Bypass -Scope Process; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) }"
choco upgrade all -y

echo.

:: Suppression des fichiers temporaires
echo Suppression des fichiers temporaires...
del /q /s "%temp%\*"
del /q /s "C:\Windows\Temp\*"

echo.

:: Nettoyage du disque via cleanmgr
echo Nettoyage du disque...
cleanmgr /sagerun:1

echo.

:: Défragmentation du disque (facultatif)
echo Defragmentation du disque...
defrag C: /O

echo.

:: Demande de scan pour les logiciels malveillants
set /p scan="Voulez-vous scanner pour les logiciels malveillants ? (o/n) : "
if /i "%scan%"=="o" (
    echo Demarrage de la verification des logiciels malveillants...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    echo Veuillez patienter, le scan est en cours...
    timeout /t 5 >nul
) else (
    echo Scan de logiciels malveillants ignore.
)

cls
echo.
echo ========================================
echo        Maintenance terminée !
echo ========================================
echo.

echo Votre PC va redémarrer...
timeout /t 5

shutdown /r /t 10 /c "Maintenance terminée"
