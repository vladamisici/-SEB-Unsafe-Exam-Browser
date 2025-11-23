@echo off
echo Fixing RDP Listener...
echo.

REM Delete and recreate the RDP listener
echo Removing old RDP configuration...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /f

echo.
echo Restarting Terminal Services...
net stop TermService /y
net stop UmRdpService /y
net start TermService
net start UmRdpService

echo.
echo Re-enabling RDP...
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

echo.
echo Testing RDP port...
timeout /t 3 /nobreak >nul
netstat -an | find ":3389"

echo.
echo Done! If you see ":3389" above with LISTENING, RDP is working.
echo.
pause
