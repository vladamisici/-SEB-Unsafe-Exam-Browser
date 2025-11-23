# Enable RDP Setup Script
# Run this as Administrator

Write-Host "Enabling Remote Desktop..." -ForegroundColor Cyan

# Enable RDP in registry
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
Write-Host "✓ RDP enabled in registry" -ForegroundColor Green

# Enable RDP firewall rules
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Host "✓ Firewall rules enabled" -ForegroundColor Green

# Restart the Terminal Services
Restart-Service TermService -Force
Write-Host "✓ Terminal Service restarted" -ForegroundColor Green

# Set user password
Write-Host "`nSetting password for user 'PC'..." -ForegroundColor Cyan
net user PC Vlada.Misici2002
Write-Host "✓ Password set" -ForegroundColor Green

# Test if RDP is listening
Start-Sleep -Seconds 2
$rdpTest = Test-NetConnection -ComputerName localhost -Port 3389 -WarningAction SilentlyContinue

if ($rdpTest.TcpTestSucceeded) {
    Write-Host "`n✓ RDP is now listening on port 3389!" -ForegroundColor Green
} else {
    Write-Host "`n✗ RDP port 3389 is not responding. Check Windows Firewall." -ForegroundColor Red
}

Write-Host "`n=== Connection Info ===" -ForegroundColor Yellow
Write-Host "Public IP: 78.96.87.96"
Write-Host "Local IP: 192.168.0.235"
Write-Host "Username: PC"
Write-Host "Password: Vlada.Misici2002"
Write-Host "`nDon't forget to forward port 3389 on your router to 192.168.0.235!" -ForegroundColor Yellow
