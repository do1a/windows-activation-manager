# ============================================================================
# Advanced System Repair & Optimization Tool
# Comprehensive Error Detection, Auto-Fix, Verification & Retry System
# Run as Administrator - FULLY AUTOMATIC OPERATION
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$VerbosePreference = 'Continue'

# ============================================================================
# CONFIGURATION & COLORS
# ============================================================================

$Colors = @{ 
    Green = 'Green'
    Yellow = 'Yellow'
    Red = 'Red'
    Cyan = 'Cyan'
    White = 'White'
    Magenta = 'Magenta'
    Gray = 'Gray'
}

$Config = @{
    MaxRetries = 5
    RetryDelay = 2
    LogPath = "$env:TEMP\SystemRepair_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    TempPath = "$env:TEMP\SystemRepair_Temp"
    SourceRepositories = @(
        'https://github.com/MicrosoftDocs/windowsserverdocs',
        'https://github.com/MicrosoftDocs/win-cpub-itpro-docs'
    )
    CriticalServices = @('KMS', 'Activation', 'Licensing')
    RequiredPackages = @('KMS-Client-Keys', 'Windows-Activation-Support')
}

# ============================================================================
# GLOBAL STATE TRACKING
# ============================================================================

$Global:SystemState = @{
    StartTime = Get-Date
    IssuesFound = 0
    IssuesFixed = 0
    IssuesFailed = 0
    Operations = @()
    Errors = @()
    Warnings = @()
    Retries = @{}
    LogEntries = @()
}

# ============================================================================
# LOGGING SYSTEM
# ============================================================================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO', 'WARNING', 'ERROR', 'SUCCESS', 'DEBUG')][string]$Level = 'INFO',
        [switch]$Display
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Add to memory
    $Global:SystemState.LogEntries += $logEntry
    
    # Write to file
    Add-Content -Path $Config.LogPath -Value $logEntry -Force
    
    # Display if requested
    if ($Display) {
        $color = switch ($Level) {
            'ERROR' { $Colors.Red }
            'WARNING' { $Colors.Yellow }
            'SUCCESS' { $Colors.Green }
            'DEBUG' { $Colors.Gray }
            default { $Colors.White }
        }
        Write-Host $logEntry -ForegroundColor $color
    }
}

function Initialize-LogFile {
    Write-Log "================================================================================" -Display
    Write-Log "SYSTEM REPAIR & OPTIMIZATION - COMPREHENSIVE AUTO-FIX TOOL" -Display
    Write-Log "================================================================================" -Display
    Write-Log "Start Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Display
    Write-Log "Computer: $env:COMPUTERNAME" -Display
    Write-Log "User: $env:USERNAME" -Display
    Write-Log "OS: $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption)" -Display
    Write-Log "================================================================================" -Display
    Write-Log ""
}

# ============================================================================
# SYSTEM DIAGNOSIS PHASE
# ============================================================================

function Diagnose-System {
    Write-Host ""
    Write-Host "[PHASE 1/4] SYSTEM DIAGNOSIS & ERROR DETECTION" -ForegroundColor $Colors.Cyan -BackgroundColor Black
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Log "[PHASE 1/4] Starting system diagnosis..."
    Write-Host ""
    
    $issues = @()
    $scanIndex = 1
    
    # Scan 1: Windows Activation Status
    Write-Host "[SCAN 1/10] Checking Windows Activation Status..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 1: Checking Windows Activation Status..."
    
    $activationInfo = cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1
    if ($activationInfo -match 'Initial grace period|Unlicensed') {
        $issues += @{
            ID = 'ACT-001'
            Category = 'Activation'
            Severity = 'CRITICAL'
            Description = 'Windows is not activated'
            Details = $activationInfo
            Attempts = 0
            Fixed = $false
            LastError = $null
            Sources = @('KMS-Activation', 'Microsoft-Licensing')
        }
        Write-Host "  [-] ISSUE FOUND: Windows not activated" -ForegroundColor $Colors.Red
        Write-Log "Issue found: Windows not activated" -Level 'WARNING'
        $Global:SystemState.IssuesFound++
    } else {
        Write-Host "  [+] Windows Activation Status: OK" -ForegroundColor $Colors.Green
        Write-Log "Windows Activation Status: OK" -Level 'SUCCESS'
    }
    Write-Host ""
    
    # Scan 2: KMS Host Connectivity
    Write-Host "[SCAN 2/10] Checking KMS Host Availability..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 2: Checking KMS Host Availability..."
    
    $kmsHosts = @('kms.example.com', 'kms.local', 'localhost')
    $kmsConnected = $false
    foreach ($host in $kmsHosts) {
        $test = Test-NetConnection -ComputerName $host -Port 1688 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        if ($test.TcpTestSucceeded -eq $true) {
            $kmsConnected = $true
            Write-Log "KMS Host found: $host"
            break
        }
    }
    
    if (-not $kmsConnected) {
        $issues += @{
            ID = 'KMS-001'
            Category = 'Connectivity'
            Severity = 'HIGH'
            Description = 'No KMS Host found on network'
            Details = "Attempted to connect to: $($kmsHosts -join ', ')"
            Attempts = 0
            Fixed = $false
            LastError = 'All KMS hosts unreachable'
            Sources = @('Network-Config', 'DNS-Settings', 'Firewall-Rules')
        }
        Write-Host "  [-] ISSUE FOUND: KMS Host not reachable" -ForegroundColor $Colors.Red
        Write-Log "Issue found: KMS Host not reachable" -Level 'WARNING'
        $Global:SystemState.IssuesFound++
    } else {
        Write-Host "  [+] KMS Host Connectivity: OK" -ForegroundColor $Colors.Green
        Write-Log "KMS Host Connectivity: OK" -Level 'SUCCESS'
    }
    Write-Host ""
    
    # Scan 3: License File Integrity
    Write-Host "[SCAN 3/10] Checking License File Integrity..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 3: Checking License File Integrity..."
    
    $licenseFile = "$env:SystemRoot\System32\spp\tokens\skus"
    if (Test-Path $licenseFile) {
        $fileCount = (Get-ChildItem $licenseFile -ErrorAction SilentlyContinue | Measure-Object).Count
        Write-Host "  [+] License Files Found: $fileCount" -ForegroundColor $Colors.Green
        Write-Log "License files integrity: OK (Count: $fileCount)"
    } else {
        $issues += @{
            ID = 'LIC-001'
            Category = 'Licensing'
            Severity = 'CRITICAL'
            Description = 'License directory missing or inaccessible'
            Details = "Path: $licenseFile"
            Attempts = 0
            Fixed = $false
            LastError = 'Path not found'
            Sources = @('File-System', 'Licensing-Service')
        }
        Write-Host "  [-] ISSUE FOUND: License directory missing" -ForegroundColor $Colors.Red
        Write-Log "Issue found: License directory missing" -Level 'ERROR'
        $Global:SystemState.IssuesFound++
    }
    Write-Host ""
    
    # Scan 4: System Services Status
    Write-Host "[SCAN 4/10] Checking Critical System Services..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 4: Checking Critical System Services..."
    
    $criticalServices = @('slsvc', 'wlidsvc', 'msiexec')
    $servicesHealthy = $true
    foreach ($service in $criticalServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc.Status -ne 'Running') {
            $servicesHealthy = $false
            $issues += @{
                ID = "SVC-$(Get-Random)"
                Category = 'Services'
                Severity = 'HIGH'
                Description = "Critical service not running: $service"
                Details = "Service: $service, Status: $($svc.Status)"
                Attempts = 0
                Fixed = $false
                LastError = "Service status: $($svc.Status)"
                Sources = @('Service-Manager', 'System-Services')
            }
            Write-Host "  [-] ISSUE FOUND: Service '$service' not running" -ForegroundColor $Colors.Red
            Write-Log "Issue found: Service $service not running" -Level 'WARNING'
            $Global:SystemState.IssuesFound++
        }
    }
    
    if ($servicesHealthy) {
        Write-Host "  [+] System Services: All Critical Services Running" -ForegroundColor $Colors.Green
        Write-Log "System Services: All critical services healthy" -Level 'SUCCESS'
    }
    Write-Host ""
    
    # Scan 5: Windows Update Status
    Write-Host "[SCAN 5/10] Checking Windows Update Status..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 5: Checking Windows Update Status..."
    
    $updateService = Get-Service -Name 'wuauserv' -ErrorAction SilentlyContinue
    if ($updateService.Status -eq 'Running') {
        Write-Host "  [+] Windows Update Service: Running" -ForegroundColor $Colors.Green
        Write-Log "Windows Update Service: Running"
    } else {
        Write-Host "  [!] Windows Update Service: Not Running" -ForegroundColor $Colors.Yellow
        Write-Log "Windows Update Service: Not Running" -Level 'WARNING'
    }
    Write-Host ""
    
    # Scan 6: Registry Keys Validation
    Write-Host "[SCAN 6/10] Validating Critical Registry Keys..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 6: Validating Critical Registry Keys..."
    
    $regKeys = @(
        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    )
    
    $regHealthy = $true
    foreach ($key in $regKeys) {
        if (-not (Test-Path $key)) {
            $regHealthy = $false
            $issues += @{
                ID = "REG-$(Get-Random)"
                Category = 'Registry'
                Severity = 'MEDIUM'
                Description = "Critical registry key missing: $key"
                Details = "Registry path not found"
                Attempts = 0
                Fixed = $false
                LastError = 'Registry path missing'
                Sources = @('Registry', 'System-Config')
            }
            Write-Log "Issue found: Registry key missing - $key" -Level 'WARNING'
        }
    }
    
    if ($regHealthy) {
        Write-Host "  [+] Registry Keys: All Critical Keys Present" -ForegroundColor $Colors.Green
        Write-Log "Critical Registry Keys: All present and valid" -Level 'SUCCESS'
    }
    Write-Host ""
    
    # Scan 7: Disk Space Check
    Write-Host "[SCAN 7/10] Checking Available Disk Space..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 7: Checking Available Disk Space..."
    
    $disk = Get-PSDrive -Name C -ErrorAction SilentlyContinue
    if ($disk) {
        $freePercent = [math]::Round(($disk.Free / $disk.Used) * 100, 2)
        if ($disk.Free -lt 1GB) {
            $issues += @{
                ID = 'DISK-001'
                Category = 'Storage'
                Severity = 'HIGH'
                Description = 'Low disk space'
                Details = "Free space: $([math]::Round($disk.Free/1GB, 2)) GB"
                Attempts = 0
                Fixed = $false
                LastError = 'Insufficient disk space'
                Sources = @('Disk-Cleanup', 'Storage-Manager')
            }
            Write-Host "  [-] ISSUE FOUND: Low disk space (<1GB)" -ForegroundColor $Colors.Red
            Write-Log "Issue found: Low disk space" -Level 'WARNING'
            $Global:SystemState.IssuesFound++
        } else {
            Write-Host "  [+] Disk Space: $([math]::Round($disk.Free/1GB, 2)) GB Free" -ForegroundColor $Colors.Green
            Write-Log "Disk Space: OK ($([math]::Round($disk.Free/1GB, 2)) GB free)"
        }
    }
    Write-Host ""
    
    # Scan 8: Network Connectivity
    Write-Host "[SCAN 8/10] Checking Network Connectivity..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 8: Checking Network Connectivity..."
    
    $netTest = Test-NetConnection -ComputerName 8.8.8.8 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    if ($netTest.PingSucceeded) {
        Write-Host "  [+] Network Connectivity: Online" -ForegroundColor $Colors.Green
        Write-Log "Network Connectivity: Online"
    } else {
        Write-Host "  [!] Network Connectivity: Potentially Offline" -ForegroundColor $Colors.Yellow
        Write-Log "Network Connectivity: Offline or Limited" -Level 'WARNING'
    }
    Write-Host ""
    
    # Scan 9: Windows Defender Status
    Write-Host "[SCAN 9/10] Checking Windows Defender Status..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 9: Checking Windows Defender Status..."
    
    $defender = Get-Service -Name 'WinDefend' -ErrorAction SilentlyContinue
    if ($defender.Status -eq 'Running') {
        Write-Host "  [+] Windows Defender: Active" -ForegroundColor $Colors.Green
        Write-Log "Windows Defender: Active"
    } else {
        Write-Host "  [!] Windows Defender: Not Running" -ForegroundColor $Colors.Yellow
        Write-Log "Windows Defender: Inactive" -Level 'WARNING'
    }
    Write-Host ""
    
    # Scan 10: System File Checker
    Write-Host "[SCAN 10/10] Running System File Integrity Check..." -ForegroundColor $Colors.Yellow
    Write-Log "Scan 10: Running System File Integrity Check..."
    
    Write-Host "  [*] This may take a few minutes..." -ForegroundColor $Colors.Cyan
    $sfc = sfc /scannow 2>&1
    if ($sfc -match 'Windows Resource Protection') {
        Write-Host "  [+] System File Check: Completed" -ForegroundColor $Colors.Green
        Write-Log "System File Integrity: Check completed"
    }
    Write-Host ""
    
    Write-Log ""
    Write-Log "Diagnosis Complete - Total Issues Found: $($Global:SystemState.IssuesFound)"
    
    return $issues
}

# ============================================================================
# AUTOMATIC REPAIR PHASE
# ============================================================================

function Repair-Issue {
    param(
        [hashtable]$Issue
    )
    
    Write-Log "Attempting to repair issue: $($Issue.ID) - $($Issue.Description)" -Level 'INFO'
    
    $Issue.Attempts++
    $Global:SystemState.Retries[$Issue.ID] = $Issue.Attempts
    
    # Apply different fix strategies based on category
    $fixApplied = $false
    
    switch ($Issue.Category) {
        'Activation' {
            Write-Log "Applying Activation Fix for issue $($Issue.ID)..." -Level 'INFO'
            # Fix 1: Reset licensing service
            try {
                Stop-Service -Name 'slsvc' -Force -ErrorAction Stop
                Start-Sleep -Seconds 2
                Start-Service -Name 'slsvc' -ErrorAction Stop
                $fixApplied = $true
                Write-Log "Licensing service reset successfully" -Level 'SUCCESS'
            } catch {
                Write-Log "Failed to reset licensing service: $_" -Level 'ERROR'
            }
        }
        
        'Connectivity' {
            Write-Log "Applying Connectivity Fix for issue $($Issue.ID)..." -Level 'INFO'
            # Fix 1: Flush DNS
            try {
                ipconfig /flushdns | Out-Null
                $fixApplied = $true
                Write-Log "DNS cache flushed" -Level 'SUCCESS'
            } catch {
                Write-Log "Failed to flush DNS: $_" -Level 'ERROR'
            }
        }
        
        'Services' {
            Write-Log "Applying Services Fix for issue $($Issue.ID)..." -Level 'INFO'
            # Fix: Start the service
            try {
                $serviceName = $Issue.Details -match 'Service: (\w+)' | Out-Null
                $serviceName = $matches[1]
                Start-Service -Name $serviceName -ErrorAction Stop
                $fixApplied = $true
                Write-Log "Service $serviceName started successfully" -Level 'SUCCESS'
            } catch {
                Write-Log "Failed to start service: $_" -Level 'ERROR'
            }
        }
        
        'Storage' {
            Write-Log "Applying Storage Cleanup for issue $($Issue.ID)..." -Level 'INFO'
            # Fix: Clean temp files
            try {
                Remove-Item "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item "$env:WINDIR\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
                $fixApplied = $true
                Write-Log "Temporary files cleaned" -Level 'SUCCESS'
            } catch {
                Write-Log "Failed to clean temp files: $_" -Level 'ERROR'
            }
        }
    }
    
    return $fixApplied
}

# ============================================================================
# VERIFICATION PHASE
# ============================================================================

function Verify-Fix {
    param(
        [hashtable]$Issue,
        [bool]$FixApplied
    )
    
    Write-Log "Verifying fix for issue $($Issue.ID)..." -Level 'INFO'
    
    # Re-check the specific issue
    switch ($Issue.ID) {
        { $_ -match 'ACT-' } {
            $activationInfo = cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1
            if ($activationInfo -match 'Licensed|Activated') {
                Write-Log "Issue $($Issue.ID) - VERIFIED AS FIXED" -Level 'SUCCESS'
                return $true
            }
        }
        
        { $_ -match 'SVC-' } {
            $serviceName = $Issue.Details -match 'Service: (\w+)' | Out-Null
            if ($matches) {
                $svc = Get-Service -Name $matches[1] -ErrorAction SilentlyContinue
                if ($svc.Status -eq 'Running') {
                    Write-Log "Issue $($Issue.ID) - Service is running - VERIFIED AS FIXED" -Level 'SUCCESS'
                    return $true
                }
            }
        }
        
        { $_ -match 'DISK-' } {
            $disk = Get-PSDrive -Name C
            if ($disk.Free -gt 1GB) {
                Write-Log "Issue $($Issue.ID) - Disk space freed - VERIFIED AS FIXED" -Level 'SUCCESS'
                return $true
            }
        }
    }
    
    Write-Log "Issue $($Issue.ID) - Verification inconclusive" -Level 'WARNING'
    return $false
}

# ============================================================================
# MAIN EXECUTION PHASE
# ============================================================================

function Main {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Cyan
    Write-Host "║   ADVANCED SYSTEM REPAIR & OPTIMIZATION TOOL              ║" -ForegroundColor $Colors.Cyan
    Write-Host "║   Full Automatic: Detect → Fix → Verify → Retry          ║" -ForegroundColor $Colors.Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Cyan
    Write-Host ""
    
    Initialize-LogFile
    
    # Phase 1: Diagnosis
    $issues = Diagnose-System
    
    if ($Global:SystemState.IssuesFound -eq 0) {
        Write-Host ""
        Write-Host "✓ SYSTEM SCAN COMPLETE - NO ISSUES FOUND" -ForegroundColor $Colors.Green
        Write-Log "System scan complete - No issues found"
        
        Generate-FinalReport -Issues $issues
        return
    }
    
    # Phase 2: Auto-Repair Loop
    Write-Host ""
    Write-Host "[PHASE 2/4] AUTOMATIC REPAIR EXECUTION" -ForegroundColor $Colors.Cyan -BackgroundColor Black
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Log "[PHASE 2/4] Starting automatic repair sequence..."
    Write-Host ""
    
    foreach ($issue in $issues) {
        $repairAttempt = 0
        $fixed = $false
        
        while ($repairAttempt -lt $Config.MaxRetries -and -not $fixed) {
            $repairAttempt++
            Write-Host "[Issue $($issue.ID)] Repair Attempt $repairAttempt/$($Config.MaxRetries)" -ForegroundColor $Colors.Yellow
            Write-Log "Issue $($issue.ID) - Repair attempt $repairAttempt of $($Config.MaxRetries)"
            
            # Apply fix
            $fixApplied = Repair-Issue -Issue $issue
            
            Start-Sleep -Seconds $Config.RetryDelay
            
            # Verify fix
            $fixed = Verify-Fix -Issue $issue -FixApplied $fixApplied
            
            if ($fixed) {
                Write-Host "  [✓] Issue $($issue.ID) FIXED" -ForegroundColor $Colors.Green
                Write-Log "Issue $($issue.ID) - FIXED on attempt $repairAttempt" -Level 'SUCCESS'
                $Global:SystemState.IssuesFixed++
                $issue.Fixed = $true
            } else {
                if ($repairAttempt -lt $Config.MaxRetries) {
                    Write-Host "  [!] Fix verification failed, retrying..." -ForegroundColor $Colors.Yellow
                    Write-Log "Fix verification failed, retrying..." -Level 'WARNING'
                } else {
                    Write-Host "  [✗] Could not fix issue after $($Config.MaxRetries) attempts" -ForegroundColor $Colors.Red
                    Write-Log "Failed to fix issue after $($Config.MaxRetries) attempts" -Level 'ERROR'
                    $Global:SystemState.IssuesFailed++
                    $issue.Fixed = $false
                }
            }
            
            Write-Host ""
        }
    }
    
    # Phase 3: Verification Report
    Write-Host ""
    Write-Host "[PHASE 3/4] COMPREHENSIVE VERIFICATION REPORT" -ForegroundColor $Colors.Cyan -BackgroundColor Black
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Log "[PHASE 3/4] Generating verification report..."
    Write-Host ""
    
    Write-Host "Summary Statistics:" -ForegroundColor $Colors.White
    Write-Host "  Total Issues Detected: $($Global:SystemState.IssuesFound)" -ForegroundColor $Colors.White
    Write-Host "  Successfully Fixed: $($Global:SystemState.IssuesFixed)" -ForegroundColor $Colors.Green
    Write-Host "  Still Unresolved: $($Global:SystemState.IssuesFailed)" -ForegroundColor $Colors.Red
    Write-Host ""
    
    # Phase 4: Final Report
    Write-Host ""
    Write-Host "[PHASE 4/4] GENERATING FINAL REPORT" -ForegroundColor $Colors.Cyan -BackgroundColor Black
    Write-Host "============================================================" -ForegroundColor $Colors.Cyan
    Write-Log "[PHASE 4/4] Generating final comprehensive report..."
    Write-Host ""
    
    Generate-FinalReport -Issues $issues
    
    # Save detailed logs
    Save-DetailedLogs -Issues $issues
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Green
    Write-Host "║           REPAIR PROCESS COMPLETED                        ║" -ForegroundColor $Colors.Green
    Write-Host "║  Detailed log saved to: $($Config.LogPath)" -ForegroundColor $Colors.White
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Green
    Write-Host ""
    
    Write-Log "Repair process completed. Duration: $((Get-Date) - $Global:SystemState.StartTime)"
    
    # Auto-close after 10 seconds
    Write-Host "Window will close in 10 seconds..." -ForegroundColor $Colors.Yellow
    Start-Sleep -Seconds 10
}

function Generate-FinalReport {
    param([array]$Issues)
    
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Magenta
    Write-Host "║              FINAL COMPREHENSIVE REPORT                   ║" -ForegroundColor $Colors.Magenta
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Magenta
    Write-Host ""
    
    if ($Issues.Count -gt 0) {
        Write-Host "ISSUES ANALYSIS:" -ForegroundColor $Colors.White
        Write-Host ""
        
        foreach ($issue in $Issues) {
            $status = if ($issue.Fixed) { "✓ FIXED" } else { "✗ UNRESOLVED" }
            $statusColor = if ($issue.Fixed) { $Colors.Green } else { $Colors.Red }
            
            Write-Host "[$($issue.ID)] $($issue.Description)" -ForegroundColor $Colors.White
            Write-Host "  Status: $status" -ForegroundColor $statusColor
            Write-Host "  Severity: $($issue.Severity)" -ForegroundColor $Colors.Yellow
            Write-Host "  Category: $($issue.Category)" -ForegroundColor $Colors.Cyan
            Write-Host "  Repair Attempts: $($issue.Attempts)/$($Config.MaxRetries)" -ForegroundColor $Colors.Gray
            
            if (-not $issue.Fixed) {
                Write-Host "  Last Error: $($issue.LastError)" -ForegroundColor $Colors.Red
                Write-Host "  Suggested Sources:" -ForegroundColor $Colors.Magenta
                foreach ($source in $issue.Sources) {
                    Write-Host "    • $source" -ForegroundColor $Colors.Cyan
                }
            }
            Write-Host ""
        }
    }
    
    Write-Host "EXECUTION SUMMARY:" -ForegroundColor $Colors.White
    Write-Host "  Start Time: $($Global:SystemState.StartTime)" -ForegroundColor $Colors.White
    Write-Host "  End Time: $(Get-Date)" -ForegroundColor $Colors.White
    Write-Host "  Total Duration: $((Get-Date) - $Global:SystemState.StartTime)" -ForegroundColor $Colors.White
    Write-Host "  Total Log Entries: $($Global:SystemState.LogEntries.Count)" -ForegroundColor $Colors.White
    Write-Host ""
    
    Write-Log "Final report generated - Report execution completed"
}

function Save-DetailedLogs {
    param([array]$Issues)
    
    Write-Log ""
    Write-Log "═══════════════════════════════════════════════════════════════"
    Write-Log "DETAILED ISSUE ANALYSIS & FIX HISTORY"
    Write-Log "═══════════════════════════════════════════════════════════════"
    Write-Log ""
    
    foreach ($issue in $Issues) {
        Write-Log "Issue ID: $($issue.ID)"
        Write-Log "  Description: $($issue.Description)"
        Write-Log "  Category: $($issue.Category)"
        Write-Log "  Severity: $($issue.Severity)"
        Write-Log "  Status: $(if ($issue.Fixed) { 'FIXED' } else { 'UNRESOLVED' })"
        Write-Log "  Total Attempts: $($issue.Attempts)"
        Write-Log "  Details: $($issue.Details)"
        
        if (-not $issue.Fixed) {
            Write-Log "  Last Error: $($issue.LastError)" -Level 'ERROR'
            Write-Log "  Alternative Sources for Manual Resolution:"
            foreach ($source in $issue.Sources) {
                Write-Log "    → $source" -Level 'WARNING'
            }
            Write-Log "  Manual Resolution Steps:"
            Write-Log "    1. Review the issue details above"
            Write-Log "    2. Check the suggested sources for solutions"
            Write-Log "    3. Download and apply fixes from official sources"
            Write-Log "    4. Run verification after manual fix"
        }
        
        Write-Log ""
    }
    
    Write-Log "═══════════════════════════════════════════════════════════════"
    Write-Log "END OF DETAILED REPORT"
    Write-Log "═══════════════════════════════════════════════════════════════"
}

# ============================================================================
# START
# ============================================================================

Main
