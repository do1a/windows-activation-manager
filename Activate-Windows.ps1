# ============================================================================
# Windows Activation Manager
# Automatic KMS Client Activation Tool
# Run as Administrator
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

# Colors for output
$Colors = @{
    Green  = 'Green'
    Yellow = 'Yellow'
    Red    = 'Red'
    Cyan   = 'Cyan'
    White  = 'White'
}

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
}

function Show-Header {
    Clear-Host
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '     Windows Activation Manager - KMS Activator' -ForegroundColor $Colors.Cyan
    Write-Host '          Run as Administrator' -ForegroundColor $Colors.Cyan
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
}

function Show-Menu {
    Write-Host 'Select Windows Version to Activate:' -ForegroundColor $Colors.Yellow
    Write-Host ''
    
    $options = @(
        'Windows 11 Pro',
        'Windows 11 Pro N',
        'Windows 11 Enterprise',
        'Windows 11 Enterprise N',
        'Windows 10 Pro',
        'Windows 10 Pro N',
        'Windows 10 Enterprise',
        'Windows 10 Enterprise N',
        'Windows Server 2025 Standard',
        'Windows Server 2025 Datacenter',
        'Windows Server 2022 Standard',
        'Windows Server 2022 Datacenter',
        'Windows Server 2019 Standard',
        'Windows Server 2019 Datacenter',
        'Windows Server 2016 Standard',
        'Windows Server 2016 Datacenter'
    )
    
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "  [$($i + 1)] $($options[$i])"
    }
    
    Write-Host '  [0] Exit'
    Write-Host ''
    
    return $options
}

function Get-UserSelection {
    param([int]$MaxOption)
    
    do {
        $choice = Read-Host 'Enter your choice'
        if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $MaxOption) {
            return [int]$choice
        }
        Write-Host 'Invalid choice. Please try again.' -ForegroundColor $Colors.Red
    } while ($true)
}

function Get-KmsHost {
    Write-Host ''
    $kmsHost = Read-Host 'Enter KMS Host address (e.g., kms.example.com)'
    if ([string]::IsNullOrWhiteSpace($kmsHost)) {
        Write-Host 'KMS Host is required for activation.' -ForegroundColor $Colors.Red
        return Get-KmsHost
    }
    return $kmsHost
}

function Set-KmsHost {
    param([string]$Host)
    
    Write-Host "Setting KMS Host to: $Host" -ForegroundColor $Colors.Yellow
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /skms $Host | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'KMS Host set successfully' -ForegroundColor $Colors.Green
        return $true
    }
    else {
        Write-Host 'Failed to set KMS Host' -ForegroundColor $Colors.Red
        return $false
    }
}

function Install-ProductKey {
    param(
        [string]$Key,
        [string]$Edition
    )
    
    Write-Host "Installing product key for: $Edition" -ForegroundColor $Colors.Yellow
    Write-Host "Key: $Key" -ForegroundColor $Colors.White
    
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk $Key | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Product key installed successfully' -ForegroundColor $Colors.Green
        return $true
    }
    else {
        Write-Host 'Failed to install product key' -ForegroundColor $Colors.Red
        return $false
    }
}

function Activate-Windows {
    Write-Host 'Attempting to activate Windows...' -ForegroundColor $Colors.Yellow
    
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Windows activated successfully!' -ForegroundColor $Colors.Green
        return $true
    }
    else {
        Write-Host 'Activation failed' -ForegroundColor $Colors.Red
        return $false
    }
}

function Get-ActivationStatus {
    Write-Host 'Current Activation Status:' -ForegroundColor $Colors.Yellow
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli
}

function Main {
    Show-Header
    
    $options = Show-Menu
    $choice = Get-UserSelection -MaxOption $options.Count
    
    if ($choice -eq 0) {
        Write-Host 'Exiting...'
        exit
    }
    
    $selectedEdition = $options[$choice - 1]
    $productKey = $KmsKeys[$selectedEdition]
    
    Write-Host "`nYou selected: $selectedEdition" -ForegroundColor $Colors.Green
    Write-Host "Product Key: $productKey" -ForegroundColor $Colors.White
    
    $kmsHost = Get-KmsHost
    
    Write-Host ''
    Write-Host 'Starting activation process...' -ForegroundColor $Colors.Cyan
    Write-Host ''
    
    # Step 1: Set KMS Host
    if (-not (Set-KmsHost -Host $kmsHost)) {
        Write-Host 'Error: Could not set KMS Host' -ForegroundColor $Colors.Red
        pause
        exit 1
    }
    
    Start-Sleep -Seconds 2
    
    # Step 2: Install Product Key
    if (-not (Install-ProductKey -Key $productKey -Edition $selectedEdition)) {
        Write-Host 'Error: Could not install product key' -ForegroundColor $Colors.Red
        pause
        exit 1
    }
    
    Start-Sleep -Seconds 2
    
    # Step 3: Activate Windows
    if (-not (Activate-Windows)) {
        Write-Host 'Warning: Activation may require additional configuration' -ForegroundColor $Colors.Yellow
    }
    
    Write-Host ''
    Write-Host 'Checking final activation status...' -ForegroundColor $Colors.Yellow
    Write-Host ''
    Get-ActivationStatus
    
    Write-Host ''
    Write-Host 'Process completed!' -ForegroundColor $Colors.Green
    Write-Host 'Press any key to exit...'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# Run main function
Main
