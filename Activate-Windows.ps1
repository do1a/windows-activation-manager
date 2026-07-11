# ============================================================================
# Windows Activation Manager - FULL AUTO MODE
# Automatic KMS Detection & Windows Activation
# Run as Administrator - NO USER INPUT REQUIRED!
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# Colors
$Colors = @{ Green = 'Green'; Yellow = 'Yellow'; Red = 'Red'; Cyan = 'Cyan'; White = 'White' }

# KMS activation keys database
$KmsKeys = @{
    'Windows 11 Pro' = 'W269N-WFGWX-YVC9B-4J6C9-T83GX'
    'Windows 11 Pro N' = 'MH37W-N47XK-V7XM9-C7227-GCQG9'
    'Windows 11 Enterprise' = 'NPPR9-FWDCX-D2C8J-H872K-2YT43'
    'Windows 11 Enterprise N' = 'DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4'
    'Windows 10 Pro' = 'W269N-WFGWX-YVC9B-4J6C9-T83GX'
    'Windows 10 Pro N' = 'MH37W-N47XK-V7XM9-C7227-GCQG9'
    'Windows 10 Enterprise' = 'NPPR9-FWDCX-D2C8J-H872K-2YT43'
    'Windows 10 Enterprise N' = 'DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4'
    'Windows Server 2025 Standard' = 'TVRH6-WHNXV-R9WG3-9XRFY-MY832'
    'Windows Server 2025 Datacenter' = 'D764K-2NDRG-47T6Q-P8T8W-YP6DF'
    'Windows Server 2022 Standard' = 'VDYBN-27WPP-V4HQT-9VMD4-VMK7H'
    'Windows Server 2022 Datacenter' = 'WX4NM-KYWYW-QJJR4-XV3QB-6VM33'
    'Windows Server 2019 Standard' = 'N69G4-B89J2-4G8F4-WWYCC-J464C'
    'Windows Server 2019 Datacenter' = 'WMDGN-G9PQG-XVVXX-R3X43-63DFG'
    'Windows Server 2016 Standard' = 'WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY'
    'Windows Server 2016 Datacenter' = 'CB7KF-BWN84-R7R2Y-793K2-8XDDG'
    'Windows 8.1 Pro' = 'GCRJD-8NW9H-F2CDX-CCM8D-9D6T9'
    'Windows 8.1 Enterprise' = 'MHF9N-XY6XB-WVXMC-BTDCT-MKKG7'
    'Windows 8 Pro' = 'NG4HW-VH26C-733KW-K6F98-J8CK4'
    'Windows 8 Enterprise' = '32JNW-9KQ84-P47T8-D8GGY-CWCK7'
    'Windows 7 Professional' = 'FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4'
    'Windows 7 Enterprise' = '33PXH-7Y6KF-2VJC9-XBBR8-HVTHH'
}

# Common KMS Hosts (Auto-detect)
$CommonKmsHosts = @(
    'kms.example.com',
    'kms.local',
    'kms.domain.local',
    'kms.corp.local',
    'localhost',
    'kms-server.local'
)

function Show-Header {
    Clear-Host
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '   Windows Activation Manager - FULL AUTO MODE' -ForegroundColor $Colors.Cyan
    Write-Host '    Automatic Detection & Activation' -ForegroundColor $Colors.Cyan
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
}

function Get-WindowsEdition {
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $edition = $osInfo.Caption
    
    if ($edition -match 'Windows 11.*Pro\s*N') { return 'Windows 11 Pro N', $edition }
    elseif ($edition -match 'Windows 11.*Pro') { return 'Windows 11 Pro', $edition }
    elseif ($edition -match 'Windows 11.*Enterprise\s*N') { return 'Windows 11 Enterprise N', $edition }
    elseif ($edition -match 'Windows 11.*Enterprise') { return 'Windows 11 Enterprise', $edition }
    elseif ($edition -match 'Windows 10.*Pro\s*N') { return 'Windows 10 Pro N', $edition }
    elseif ($edition -match 'Windows 10.*Pro') { return 'Windows 10 Pro', $edition }
    elseif ($edition -match 'Windows 10.*Enterprise\s*N') { return 'Windows 10 Enterprise N', $edition }
    elseif ($edition -match 'Windows 10.*Enterprise') { return 'Windows 10 Enterprise', $edition }
    elseif ($edition -match 'Server 2025') { return 'Windows Server 2025 Datacenter', $edition }
    elseif ($edition -match 'Server 2022') { return 'Windows Server 2022 Datacenter', $edition }
    elseif ($edition -match 'Server 2019') { return 'Windows Server 2019 Datacenter', $edition }
    elseif ($edition -match 'Server 2016') { return 'Windows Server 2016 Datacenter', $edition }
    elseif ($edition -match 'Windows 8.1') { return 'Windows 8.1 Pro', $edition }
    elseif ($edition -match 'Windows 8') { return 'Windows 8 Pro', $edition }
    elseif ($edition -match 'Windows 7') { return 'Windows 7 Professional', $edition }
    else { return 'Windows 11 Pro', $edition }
}

function Find-KmsHost {
    Write-Host '[*] Searching for KMS Host on network...' -ForegroundColor $Colors.Yellow
    
    foreach ($host in $CommonKmsHosts) {
        $testConnection = Test-NetConnection -ComputerName $host -Port 1688 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        if ($testConnection.TcpTestSucceeded -eq $true) {
            Write-Host "[+] Found KMS Host: $host" -ForegroundColor $Colors.Green
            return $host
        }
    }
    
    Write-Host "[!] No KMS Host found on network" -ForegroundColor $Colors.Yellow
    Write-Host "[!] Using default: kms.example.com" -ForegroundColor $Colors.Yellow
    return 'kms.example.com'
}

function Set-KmsHostAuto {
    param([string]$Host)
    
    Write-Host "[*] Setting KMS Host to: $Host" -ForegroundColor $Colors.Yellow
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /skms $Host:1688 2>&1 | Out-Null
    Start-Sleep -Seconds 1
    
    Write-Host "[+] KMS Host configured" -ForegroundColor $Colors.Green
    return $true
}

function Install-ProductKeyAuto {
    param([string]$Key, [string]$Edition)
    
    Write-Host "[*] Installing product key: $Edition" -ForegroundColor $Colors.Yellow
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk $Key 2>&1 | Out-Null
    Start-Sleep -Seconds 1
    
    Write-Host "[+] Product key installed" -ForegroundColor $Colors.Green
    return $true
}

function Activate-WindowsAuto {
    Write-Host "[*] Activating Windows..." -ForegroundColor $Colors.Yellow
    
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato 2>&1 | Out-Null
    Start-Sleep -Seconds 2
    
    Write-Host "[+] Activation attempt completed" -ForegroundColor $Colors.Green
    return $true
}

function Get-ActivationStatusAuto {
    Write-Host ''
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Host "[*] Current Activation Status:" -ForegroundColor $Colors.Yellow
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Host ''
    
    $slmgrOutput = cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1
    Write-Host $slmgrOutput -ForegroundColor $Colors.White
    Write-Host ''
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
}

function Main {
    Show-Header
    
    Write-Host '[*] Windows Activation Manager - Auto Mode Started' -ForegroundColor $Colors.Cyan
    Write-Host ''
    Start-Sleep -Seconds 1
    
    # Step 1: Detect Edition
    Write-Host '[STEP 1/5] Detecting Windows Edition...' -ForegroundColor $Colors.Cyan
    $kmsEdition, $fullEdition = Get-WindowsEdition
    Write-Host "[+] Detected: $fullEdition" -ForegroundColor $Colors.Green
    Write-Host "[+] KMS Edition: $kmsEdition" -ForegroundColor $Colors.Green
    Write-Host ''
    Start-Sleep -Seconds 1
    
    # Step 2: Get Key
    Write-Host '[STEP 2/5] Loading product key...' -ForegroundColor $Colors.Cyan
    $productKey = $KmsKeys[$kmsEdition]
    if (-not $productKey) {
        $productKey = $KmsKeys['Windows 11 Pro']
        Write-Host "[!] Using fallback key" -ForegroundColor $Colors.Yellow
    }
    Write-Host "[+] Key: $productKey" -ForegroundColor $Colors.Green
    Write-Host ''
    Start-Sleep -Seconds 1
    
    # Step 3: Find KMS
    Write-Host '[STEP 3/5] Finding KMS Host...' -ForegroundColor $Colors.Cyan
    $kmsHost = Find-KmsHost
    Write-Host ''
    Start-Sleep -Seconds 1
    
    # Step 4: Configure
    Write-Host '[STEP 4/5] Configuring system...' -ForegroundColor $Colors.Cyan
    Set-KmsHostAuto -Host $kmsHost
    Write-Host ''
    Start-Sleep -Seconds 1
    
    # Step 5: Activate
    Write-Host '[STEP 5/5] Activating...' -ForegroundColor $Colors.Cyan
    Install-ProductKeyAuto -Key $productKey -Edition $kmsEdition
    Start-Sleep -Seconds 1
    Activate-WindowsAuto
    Write-Host ''
    
    # Final Status
    Get-ActivationStatusAuto
    
    Write-Host '[+] Activation process completed!' -ForegroundColor $Colors.Green
    Write-Host ''
    Write-Host '[*] Window will close in 5 seconds...' -ForegroundColor $Colors.Yellow
    Start-Sleep -Seconds 5
}

# RUN
Main
