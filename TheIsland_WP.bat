@echo off

color 05

echo --------------------------------------------------
echo BACKUP SAVE FILES
echo --------------------------------------------------
echo.
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\

if not exist .\SteamCMD\ (
	echo.
	echo --------------------------------------------------
	echo INSTALL STEAMCMD
	echo --------------------------------------------------
	echo.
	mkdir .\SteamCMD > nul
	powershell -command "Start-BitsTransfer -Source https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
	powershell -command "Expand-Archive steamcmd.zip"
	del .\steamcmd.zip
	.\SteamCMD\steamcmd.exe +quit
	echo SteamCMD Installed!
)

if not exist .\%~n0\ (
	echo.
	echo --------------------------------------------------
	echo INSTALL SERVER
	echo --------------------------------------------------
	echo.
	mkdir .\%~n0\ > nul
	.\SteamCMD\steamcmd.exe +force_install_dir ..\%~n0\ +login anonymous +app_update 2430930 +quit
) else (
	echo.
	echo --------------------------------------------------
	echo UPDATE SERVER
	echo --------------------------------------------------
	echo.
	.\SteamCMD\steamcmd.exe +force_install_dir ..\%~n0\ +login anonymous +app_update 2430930 +quit
)

if exist .\%~n0\ShooterGame\Content\Movies\ (
	rmdir /q /s .\%~n0\ShooterGame\Content\Movies\ > nul
)

echo.
echo --------------------------------------------------
echo START SERVER
echo --------------------------------------------------
@echo on
start /min .\%~n0\ShooterGame\Binaries\Win64\ArkAscendedServer.exe %~n0 ?MultiHome=127.0.0.1 ?Port=7777 ?QueryPort=27015 ?SessionName=%~n0 ?ServerAdminPassword=ServerAdminPassword ?ServerPassword=ServerPassword -NoBattlEye -noundermeshchecking & :: start server
@echo off
timeout 5 > nul
powershell "$Process = Get-Process ArkAscendedServer ; $Process.ProcessorAffinity = 61440" & :: use 13/14 and 15/16 cores/threads (61440 = 0xF000 = 1111000000000000)

:Backup
timeout 1800 > nul
echo.
echo --------------------------------------------------
echo BACKUP SAVE FILES
echo --------------------------------------------------
echo.
set BackupName=%~n0_%Date:~-4%%Date:~3,2%%Date:~0,2%%Time:~0,2%%Time:~3,2%%Time:~6,2%
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\Game.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini .\Backup\%BackupName%\ShooterGame\Saved\Config\WindowsServer\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.arkprofile .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\*.profilebak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0.ark .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SavedArks\%~n0\%~n0_AntiCorruptionBackup.bak .\Backup\%BackupName%\ShooterGame\Saved\SavedArks\%~n0\
xcopy  /e /q .\%~n0\ShooterGame\Saved\SaveGames\* .\Backup\%BackupName%\ShooterGame\Saved\SaveGames\
goto Backup
