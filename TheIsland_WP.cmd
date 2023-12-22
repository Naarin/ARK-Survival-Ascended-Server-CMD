@echo off & color 05
echo  .d8b.  .d8888.  .d8b.    .d8888. d88888b d8888b. db    db d88888b d8888b.    .o88b. .88b  d88. d8888b.
echo d8' `8b 88'  YP d8' `8b   88'  YP 88'     88  `8D 88    88 88'     88  `8D   d8P  Y8 88'YbdP`88 88  `8D
echo 88ooo88 `8bo.   88ooo88   `8bo.   88ooooo 88oobY' Y8    8P 88ooooo 88oobY'   8P      88  88  88 88   88
echo 88~~~88   `Y8b. 88~~~88     `Y8b. 88~~~~~ 88`8b   `8b  d8' 88~~~~~ 88`8b     8b      88  88  88 88   88
echo 88   88 db   8D 88   88   db   8D 88.     88 `88.  `8bd8'  88.     88 `88.   Y8b  d8 88  88  88 88  .8D
echo YP   YP `8888Y' YP   YP   `8888Y' Y88888P 88   YD    YP    Y88888P 88   YD    `Y88P' YP  YP  YP Y8888D'
echo.
echo                                                                                          BY ZEHN/NAARIN
timeout 3 > nul
echo -------------------------------------------------------------------------------------------------------
echo SERVER INFORMATIONS ///////////////////////////////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
set MapName=%~n0
set MultiHome=127.0.0.1
set Port=7777
set QueryPort=27015
set SessionName=%~n0
set ServerPassword=
set ServerAdminPassword=
set Options=-NoBattlEye -noundermeshchecking
set ProcessorAffinity=   & :: | Core/Thread | 16 | 15 | 14 | 13 | 12 | 11 | 10 | 09 | 08 | 07 | 06 | 05 | 04 | 03 | 02 | 01 |
set ProcessorAffinity=15 & :: |    15 = BIN |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 |  1 |  1 |  1 |
echo SESSION NAME (MAP NAME) = %SessionName% (%MapName%)
echo IP ADRESS:PORT          = %MultiHome%:%QueryPort%
echo PASSWORD                = %ServerPassword%
echo ADMIN PASSWORD          = %ServerAdminPassword%
echo OPTIONS                 = %Options%
echo PROCESSOR AFFINITY      = %ProcessorAffinity%
timeout 2 > nul
echo -------------------------------------------------------------------------------------------------------
echo COPY FILES FROM SAVED FOLDER TO BACKUP FOLDER /////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\
if not exist .\INI\%~n0\ (
mkdir .\INI\%~n0\ > nul
)
echo -------------------------------------------------------------------------------------------------------
echo COPY FILES FROM INI FOLDER TO SAVED FOLDER ////////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
xcopy /e /q /y .\INI\%~n0\*.ini .\%~n0\ShooterGame\Saved\Config\WindowsServer\
if not exist .\SteamCMD\ (
echo -------------------------------------------------------------------------------------------------------
echo INSTALL STEAMCMD //////////////////////////////////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
mkdir .\SteamCMD > nul
powershell -command "Start-BitsTransfer -Source https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
powershell -command "Expand-Archive steamcmd.zip"
del .\steamcmd.zip
.\SteamCMD\steamcmd.exe +quit
)
echo -------------------------------------------------------------------------------------------------------
echo INSTALL/UPDATE SERVER /////////////////////////////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
if not exist .\%~n0\ShooterGame\ (
mkdir .\%~n0\ > nul
)
.\SteamCMD\steamcmd.exe +force_install_dir ..\%~n0\ +login anonymous +app_update 2430930 +quit
if exist .\%~n0\ShooterGame\Content\Movies\ (
rmdir /q /s .\%~n0\ShooterGame\Content\Movies\ > nul
)
echo -------------------------------------------------------------------------------------------------------
echo START SERVER //////////////////////////////////////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
start /min .\%~n0\ShooterGame\Binaries\Win64\ArkAscendedServer.exe %MapName%?MultiHome=%MultiHome%?Port=%Port%?QueryPort=%QueryPort%?SessionName=%SessionName%?ServerPassword=%ServerPassword%?ServerAdminPassword=%ServerAdminPassword% %Options% & :: start server
timeout 15 > nul & :: let some time to start server
powershell "$Process = Get-Process ArkAscendedServer ; $Process.ProcessorAffinity = %ProcessorAffinity%"
echo STARTED! DON'T CLOSE THIS WINDOW IF YOU WANT REGULAR BACKUP (EVERY 15 MIN). 
echo YOU CAN FORCE BACKUP BY PRESSING ANY KEYS.
:Backup
timeout 1800 > nul
echo -------------------------------------------------------------------------------------------------------
echo COPY FILES FROM SAVED FOLDER TO BACKUP FOLDER /////////////////////////////////////////////////////////
echo -------------------------------------------------------------------------------------------------------
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q /y .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\
goto Backup
