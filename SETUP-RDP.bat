@echo off
echo ============================================
echo  Safe Exam Browser - RDP Setup
echo ============================================
echo.
echo This will enable Remote Desktop on this PC.
echo You MUST run this as Administrator!
echo.
pause

echo.
echo Enabling RDP...
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

echo.
echo Enabling firewall rules...
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

echo.
echo Setting password for user PC...
net user PC Vlada.Misici2002

echo.
echo Restarting Terminal Services...
net stop TermService /y
net start TermService

echo.
echo ============================================
echo  Setup Complete!
echo ============================================
echo.
echo Your Tailscale IP: 100.103.127.23
echo Username: PC
echo Password: Vlada.Misici2002
echo.
echo Connect from your Mac using Microsoft Remote Desktop
echo.
pause
