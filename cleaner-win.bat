@echo off
title Azukiov - Cleaner Tool Approfondi
color 0A
setlocal enabledelayedexpansion

REM Vérification des droits d'administration
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Droits d'administration accordes.
) else (
    echo Vous devez lancer ce script en tant qu'administrateur.
    echo Faites un clic droit sur ce fichier batch et choisissez "Exécuter en tant qu'administrateur".
    pause
    exit /b
)

REM Fonction pour demander une confirmation
:confirmation
set /p "confirm=Voulez-vous vraiment lancer le nettoyage approfondi du PC ? (O/N): "
if /i "%confirm%"=="O" (
    goto :cleanup
) else (
    echo Annulation de l'operation.
    pause
    exit /b
)

:cleanup
echo Nettoyage en cours...

REM ---- Nettoyage de base ----

REM Suppression des dossiers et fichiers temporaires classiques
set "cleanup_dirs=%WinDir%\Temp %WinDir%\Prefetch %Temp% %AppData%\Local\Temp %LocalAppData%\Temp %USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache %SYSTEMDRIVE%\AMD %SYSTEMDRIVE%\NVIDIA %SYSTEMDRIVE%\INTEL"
for %%d in (%cleanup_dirs%) do (
    if exist "%%d" (
        echo Suppression de %%d...
        del /s /f /q "%%d\*.*" 2>nul
        rd /s /q "%%d" 2>nul
        md "%%d" 2>nul
    )
)

REM Nettoyage du dossier de téléchargement de Windows Update
if exist "%WinDir%\SoftwareDistribution\Download" (
    echo Nettoyage des fichiers de Windows Update...
    del /s /f /q "%WinDir%\SoftwareDistribution\Download\*.*" 2>nul
)

REM Nettoyage de la corbeille
echo Nettoyage de la corbeille...
rd /s /q "%SYSTEMDRIVE%\$Recycle.Bin" 2>nul

REM Nettoyage spécifique pour Fortnite (inspiré de FortniteCleaner.bat)
if exist "%USERPROFILE%\AppData\Local\FortniteGame" (
    echo Nettoyage des fichiers temporaires et logs de Fortnite...
    del /s /f /q "%USERPROFILE%\AppData\Local\FortniteGame\*.log" 2>nul
    for /d %%F in ("%USERPROFILE%\AppData\Local\FortniteGame\*") do (
        rd /s /q "%%F" 2>nul
        md "%%F" 2>nul
    )
)

REM Nettoyage des caches des navigateurs
REM Google Chrome
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" (
    echo Nettoyage du cache de Google Chrome...
    del /s /f /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*" 2>nul
)
REM Mozilla Firefox
if exist "%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles" (
    for /d %%P in ("%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles\*") do (
        if exist "%%P\cache2" (
            echo Nettoyage du cache de Firefox dans %%P...
            del /s /f /q "%%P\cache2\*.*" 2>nul
            rd /s /q "%%P\cache2" 2>nul
            md "%%P\cache2" 2>nul
        )
    )
)

REM ---- Nettoyage approfondi ----

REM Nettoyage des dossiers de logs Windows
if exist "%WinDir%\Logs" (
    echo Nettoyage des dossiers de logs Windows...
    for /d %%L in ("%WinDir%\Logs\*") do (
        del /s /f /q "%%L\*.*" 2>nul
    )
)

REM Nettoyage des rapports d'erreurs Windows (WER)
if exist "C:\ProgramData\Microsoft\Windows\WER" (
    echo Nettoyage des rapports d'erreurs Windows...
    del /s /f /q "C:\ProgramData\Microsoft\Windows\WER\*.*" 2>nul
    for /d %%W in ("C:\ProgramData\Microsoft\Windows\WER\*") do (
        rd /s /q "%%W" 2>nul
    )
)

REM Nettoyage du dossier Delivery Optimization (fichiers de mise à jour en cache)
if exist "%WinDir%\SoftwareDistribution\DeliveryOptimization" (
    echo Nettoyage du dossier Delivery Optimization...
    del /s /f /q "%WinDir%\SoftwareDistribution\DeliveryOptimization\*.*" 2>nul
    for /d %%D in ("%WinDir%\SoftwareDistribution\DeliveryOptimization\*") do (
        rd /s /q "%%D" 2>nul
    )
)

REM Nettoyage complet des dossiers Temp
if exist "%Temp%" (
    echo Nettoyage complet du dossier Temp...
    del /s /f /q "%Temp%\*.*" 2>nul
)
if exist "%AppData%\Local\Temp" (
    echo Nettoyage complet du dossier Local Temp...
    del /s /f /q "%AppData%\Local\Temp\*.*" 2>nul
)

REM Optionnel : Lancement de l'outil de nettoyage de disque Windows (cleanup manager)
REM Pour utiliser cette fonction, configurez préalablement les options via "cleanmgr /sageset:1"
echo Lancement de l'outil de nettoyage de disque Windows...
cleanmgr /sagerun:1

echo Nettoyage approfondi termine.
echo Appuyez sur une touche pour quitter.
pause >nul
exit /b