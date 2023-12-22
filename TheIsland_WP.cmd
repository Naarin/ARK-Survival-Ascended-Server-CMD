mode 105,55 & @echo off & color 05
echo  .d8b.  .d8888.  .d8b.     .d8888. d88888b d8888b. db    db d88888b d8888b.     .o88b. .88b  d88. d8888b.
echo d8' `8b 88'  YP d8' `8b    88'  YP 88'     88  `8D 88    88 88'     88  `8D    d8P  Y8 88'YbdP`88 88  `8D
echo 88ooo88 `8bo.   88ooo88    `8bo.   88ooooo 88oobY' Y8    8P 88ooooo 88oobY'    8P      88  88  88 88   88
echo 88~~~88   `Y8b. 88~~~88      `Y8b. 88~~~~~ 88`8b   `8b  d8' 88~~~~~ 88`8b      8b      88  88  88 88   88
echo 88   88 db   8D 88   88    db   8D 88.     88 `88.  `8bd8'  88.     88 `88.    Y8b  d8 88  88  88 88  .8D
echo YP   YP `8888Y' YP   YP    `8888Y' Y88888P 88   YD    YP    Y88888P 88   YD     `Y88P' YP  YP  YP Y8888D'
echo.
echo                                                                                            BY ZEHN/NAARIN
timeout 1 > nul
echo ---------------------------------------------------------------------------------------------------------
echo BACKUP SAVE FILES ///////////////////////////////////////////////////////////////////////////////////////
echo ---------------------------------------------------------------------------------------------------------
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\
if not exist .\SteamCMD\ (
echo ---------------------------------------------------------------------------------------------------------
echo INSTALL STEAMCMD ////////////////////////////////////////////////////////////////////////////////////////
echo ---------------------------------------------------------------------------------------------------------
mkdir .\SteamCMD > nul
powershell -command "Start-BitsTransfer -Source https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
powershell -command "Expand-Archive steamcmd.zip"
del .\steamcmd.zip
.\SteamCMD\steamcmd.exe +quit
)
echo ---------------------------------------------------------------------------------------------------------
echo INSTALL / UPDATE SERVER /////////////////////////////////////////////////////////////////////////////////
echo ---------------------------------------------------------------------------------------------------------
if not exist .\%~n0\ShooterGame\ (
mkdir .\%~n0\ > nul
)
.\SteamCMD\steamcmd.exe +force_install_dir ..\%~n0\ +login anonymous +app_update 2430930 +quit
if exist .\%~n0\ShooterGame\Content\Movies\ (
rmdir /q /s .\%~n0\ShooterGame\Content\Movies\ > nul
)
echo ---------------------------------------------------------------------------------------------------------
echo START SERVER ////////////////////////////////////////////////////////////////////////////////////////////
echo ---------------------------------------------------------------------------------------------------------
start /min .\%~n0\ShooterGame\Binaries\Win64\ArkAscendedServer.exe %~n0 ?MultiHome=127.0.0.1 ?Port=7777 ?QueryPort=27015 ?SessionName=%~n0 ?ServerAdminPassword=ServerAdminPassword ?ServerPassword=ServerPassword -NoBattlEye -noundermeshchecking & :: start server
timeout 15 > nul & :: let some time to start server
powershell "$Process = Get-Process ArkAscendedServer ; $Process.ProcessorAffinity = 61440" & :: use 13/14 and 15/16 cores/threads (61440 = 0xF000 = 1111000000000000)
echo STARTED!
:Backup
timeout 1800 > nul
echo ---------------------------------------------------------------------------------------------------------
echo BACKUP SAVE FILES ///////////////////////////////////////////////////////////////////////////////////////
echo ---------------------------------------------------------------------------------------------------------
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\
goto Backup
