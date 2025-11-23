@echo off
echo ============================================
echo  Recreating RDP Listener Configuration
echo ============================================
echo.
echo This will rebuild the RDP listener from scratch.
echo.
pause

echo.
echo Step 1: Creating RDP-Tcp listener configuration...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 3389 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v fEnableWinStation /t REG_DWORD /d 1 /f

echo.
echo Step 2: Enabling RDP...
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fAllowToGetHelp /t REG_DWORD /d 1 /f

echo.
echo Step 3: Configuring firewall...
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

echo.
echo Step 4: Restarting services...
net stop TermService /y
net stop UmRdpService /y
timeout /t 2 /nobreak >nul
net start TermService
net start UmRdpService

echo.
echo Step 5: Testing...
timeout /t 3 /nobreak >nul
netstat -an | find ":3389"

echo.
echo ============================================
echo  Done!
echo ============================================
echo.
echo If you see ":3389" with "LISTENING" above, RDP is working!
echo If not, your Windows RDP installation may be corrupted.
echo.
pause
