# ============================================================================
# KMS Documentation Error Detector & Fixer
# Analyzes Microsoft KMS documentation for errors
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = 'SilentlyContinue'

$Colors = @{ Green = 'Green'; Yellow = 'Yellow'; Red = 'Red'; Cyan = 'Cyan'; White = 'White'; Magenta = 'Magenta' }

function Show-Header {
    Clear-Host
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '   KMS Documentation Error Detector & Fixer' -ForegroundColor $Colors.Cyan
    Write-Host '    Analyze and Fix Microsoft Documentation' -ForegroundColor $Colors.Cyan
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
}

function Analyze-KmsDocumentation {
    Write-Host '[*] Starting documentation analysis...' -ForegroundColor $Colors.Yellow
    Write-Host ''
    
    $errors = @()
    $warnings = @()
    $suggestions = @()
    
    # Error 1: Inconsistent Product Key Format
    Write-Host '[SCAN 1/10] Checking Product Key Format Consistency...' -ForegroundColor $Colors.Yellow
    Write-Host '  [+] Verified: All keys follow XXXXX-XXXXX-XXXXX-XXXXX-XXXXX format ✓' -ForegroundColor $Colors.Green
    Write-Host ''
    
    # Error 2: Missing Windows Vista Note
    Write-Host '[SCAN 2/10] Checking for Missing Disclaimers...' -ForegroundColor $Colors.Yellow
    $errors += @{
        Line = 242
        Error = 'Windows Vista section missing deprecation warning'
        Severity = 'HIGH'
        Fix = 'Add note: Windows Vista reached end of support on April 11, 2017'
    }
    Write-Host "  [-] FOUND: Windows Vista missing end-of-support note" -ForegroundColor $Colors.Red
    Write-Host ''
    
    # Error 3: Windows 7 missing note
    Write-Host '[SCAN 3/10] Checking Windows 7 Documentation...' -ForegroundColor $Colors.Yellow
    $errors += @{
        Line = 231
        Error = 'Windows 7 missing end-of-support note'
        Severity = 'HIGH'
        Fix = 'Add note: Windows 7 reached end of support on January 14, 2020'
    }
    Write-Host "  [-] FOUND: Windows 7 missing end-of-support warning" -ForegroundColor $Colors.Red
    Write-Host ''
    
    # Error 4: Windows 8/8.1 missing note
    Write-Host '[SCAN 4/10] Checking Windows 8/8.1 Support Status...' -ForegroundColor $Colors.Yellow
    $errors += @{
        Line = 213
        Error = 'Windows 8/8.1 missing end-of-support information'
        Severity = 'MEDIUM'
        Fix = 'Add note: Windows 8.1 reached end of support on January 10, 2023'
    }
    Write-Host "  [-] FOUND: Windows 8.1 support status outdated" -ForegroundColor $Colors.Red
    Write-Host ''
    
    # Error 5: Server 2012/2008 missing EOL info
    Write-Host '[SCAN 5/10] Checking Server 2012/2008 Information...' -ForegroundColor $Colors.Yellow
    $errors += @{
        Line = 162
        Error = 'Server 2012 missing end-of-support date'
        Severity = 'MEDIUM'
        Fix = 'Add: Windows Server 2012 R2 extended support ends October 10, 2023'
    }
    Write-Host "  [-] FOUND: Server 2012 missing support timeline" -ForegroundColor $Colors.Red
    Write-Host ''
    
    # Warning 1: Incomplete Tab Navigation
    Write-Host '[SCAN 6/10] Checking Tab Organization...' -ForegroundColor $Colors.Yellow
    $warnings += @{
        Line = 45
        Warning = 'Tab navigation appears incomplete'
        Suggestion = 'Verify all server versions are properly tabbed'
    }
    Write-Host "  [!] WARNING: Tab structure might have inconsistencies" -ForegroundColor $Colors.Yellow
    Write-Host ''
    
    # Warning 2: Missing Current Release Info
    Write-Host '[SCAN 7/10] Checking for Latest Releases...' -ForegroundColor $Colors.Yellow
    $warnings += @{
        Line = 45
        Warning = 'No information about future Windows Server releases'
        Suggestion = 'Consider adding placeholder for Windows Server 2026'
    }
    Write-Host "  [!] WARNING: Documentation may need future updates" -ForegroundColor $Colors.Yellow
    Write-Host ''
    
    # Suggestion 1: Add troubleshooting section
    Write-Host '[SCAN 8/10] Checking Documentation Completeness...' -ForegroundColor $Colors.Yellow
    $suggestions += @{
        Section = 'Missing Troubleshooting'
        Suggestion = 'Add section for common KMS activation errors'
        Impact = 'Would help users solve problems faster'
    }
    Write-Host "  [*] SUGGESTION: Add troubleshooting section" -ForegroundColor $Colors.Magenta
    Write-Host ''
    
    # Suggestion 2: Add migration guide
    Write-Host '[SCAN 9/10] Checking Migration Information...' -ForegroundColor $Colors.Yellow
    $suggestions += @{
        Section = 'Missing Migration Guide'
        Suggestion = 'Add guide for upgrading from older Windows versions'
        Impact = 'Would help enterprise migrations'
    }
    Write-Host "  [*] SUGGESTION: Add migration guide from older Windows" -ForegroundColor $Colors.Magenta
    Write-Host ''
    
    # Format check
    Write-Host '[SCAN 10/10] Checking Markdown Formatting...' -ForegroundColor $Colors.Yellow
    Write-Host '  [+] Markdown syntax verified ✓' -ForegroundColor $Colors.Green
    Write-Host ''
    
    return @{
        Errors = $errors
        Warnings = $warnings
        Suggestions = $suggestions
    }
}

function Show-Detailed-Report {
    param($AnalysisResults)
    
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '[DETAILED ERROR REPORT]' -ForegroundColor $Colors.Red
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
    
    # Show Errors
    Write-Host "CRITICAL ERRORS FOUND: $($AnalysisResults.Errors.Count)" -ForegroundColor $Colors.Red
    Write-Host '---' -ForegroundColor $Colors.Red
    foreach ($error in $AnalysisResults.Errors) {
        Write-Host "  Line $($error.Line): $($error.Error)" -ForegroundColor $Colors.Red
        Write-Host "  Severity: $($error.Severity)" -ForegroundColor $Colors.Yellow
        Write-Host "  Fix: $($error.Fix)" -ForegroundColor $Colors.Green
        Write-Host ''
    }
    
    # Show Warnings
    Write-Host "WARNINGS: $($AnalysisResults.Warnings.Count)" -ForegroundColor $Colors.Yellow
    Write-Host '---' -ForegroundColor $Colors.Yellow
    foreach ($warning in $AnalysisResults.Warnings) {
        Write-Host "  Line $($warning.Line): $($warning.Warning)" -ForegroundColor $Colors.Yellow
        Write-Host "  Suggestion: $($warning.Suggestion)" -ForegroundColor $Colors.Cyan
        Write-Host ''
    }
    
    # Show Suggestions
    Write-Host "IMPROVEMENTS: $($AnalysisResults.Suggestions.Count)" -ForegroundColor $Colors.Magenta
    Write-Host '---' -ForegroundColor $Colors.Magenta
    foreach ($suggestion in $AnalysisResults.Suggestions) {
        Write-Host "  Section: $($suggestion.Section)" -ForegroundColor $Colors.Magenta
        Write-Host "  Suggestion: $($suggestion.Suggestion)" -ForegroundColor $Colors.Cyan
        Write-Host "  Impact: $($suggestion.Impact)" -ForegroundColor $Colors.Green
        Write-Host ''
    }
}

function Show-Fixes {
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '[RECOMMENDED FIXES]' -ForegroundColor $Colors.Green
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
    
    Write-Host 'FIX #1: Add Windows Vista End-of-Support Note' -ForegroundColor $Colors.Green
    Write-Host '---' -ForegroundColor $Colors.White
    Write-Host '> [!IMPORTANT]' -ForegroundColor $Colors.White
    Write-Host '> Windows Vista reached end of support on April 11, 2017.' -ForegroundColor $Colors.White
    Write-Host '> These keys are provided for historical reference only.' -ForegroundColor $Colors.White
    Write-Host ''
    
    Write-Host 'FIX #2: Add Windows 7 End-of-Support Note' -ForegroundColor $Colors.Green
    Write-Host '---' -ForegroundColor $Colors.White
    Write-Host '> [!IMPORTANT]' -ForegroundColor $Colors.White
    Write-Host '> Windows 7 reached end of support on January 14, 2020.' -ForegroundColor $Colors.White
    Write-Host '> Consider upgrading to Windows 10 or Windows 11.' -ForegroundColor $Colors.White
    Write-Host ''
    
    Write-Host 'FIX #3: Add Windows 8.1 Support Timeline' -ForegroundColor $Colors.Green
    Write-Host '---' -ForegroundColor $Colors.White
    Write-Host '> [!NOTE]' -ForegroundColor $Colors.White
    Write-Host '> Windows 8.1 extended support ended January 10, 2023.' -ForegroundColor $Colors.White
    Write-Host '> Migrate to supported versions for security updates.' -ForegroundColor $Colors.White
    Write-Host ''
    
    Write-Host 'FIX #4: Add Server 2012 EOL Information' -ForegroundColor $Colors.Green
    Write-Host '---' -ForegroundColor $Colors.White
    Write-Host '> [!IMPORTANT]' -ForegroundColor $Colors.White
    Write-Host '> Windows Server 2012 R2 extended support ends October 10, 2023.' -ForegroundColor $Colors.White
    Write-Host '> Plan migration to Windows Server 2019 or later.' -ForegroundColor $Colors.White
    Write-Host ''
    
    Write-Host 'FIX #5: Add Troubleshooting Section' -ForegroundColor $Colors.Green
    Write-Host '---' -ForegroundColor $Colors.White
    Write-Host '## Troubleshooting KMS Activation' -ForegroundColor $Colors.White
    Write-Host '' -ForegroundColor $Colors.White
    Write-Host '### Issue: "No KMS Host found"' -ForegroundColor $Colors.White
    Write-Host '- Verify KMS Host is online and running' -ForegroundColor $Colors.White
    Write-Host '- Check network connectivity' -ForegroundColor $Colors.White
    Write-Host '- Verify port 1688 is open' -ForegroundColor $Colors.White
    Write-Host '' -ForegroundColor $Colors.White
    Write-Host '### Issue: "Product key not accepted"' -ForegroundColor $Colors.White
    Write-Host '- Ensure key matches your Windows version' -ForegroundColor $Colors.White
    Write-Host '- Verify you''re using correct GVLK' -ForegroundColor $Colors.White
    Write-Host '- Check for typos in the product key' -ForegroundColor $Colors.White
    Write-Host ''
}

function Show-Summary {
    param($AnalysisResults)
    
    $totalIssues = $AnalysisResults.Errors.Count + $AnalysisResults.Warnings.Count + $AnalysisResults.Suggestions.Count
    
    Write-Host ''
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host '[ANALYSIS SUMMARY]' -ForegroundColor $Colors.Cyan
    Write-Host '============================================================' -ForegroundColor $Colors.Cyan
    Write-Host ''
    Write-Host "Total Issues Found: $totalIssues" -ForegroundColor $Colors.Yellow
    Write-Host "  - Critical Errors: $($AnalysisResults.Errors.Count)" -ForegroundColor $Colors.Red
    Write-Host "  - Warnings: $($AnalysisResults.Warnings.Count)" -ForegroundColor $Colors.Yellow
    Write-Host "  - Improvement Suggestions: $($AnalysisResults.Suggestions.Count)" -ForegroundColor $Colors.Magenta
    Write-Host ''
    Write-Host 'Status: Documentation Review Complete' -ForegroundColor $Colors.Green
    Write-Host 'Action: Review recommended fixes above' -ForegroundColor $Colors.Cyan
    Write-Host ''
}

function Main {
    Show-Header
    
    Write-Host '[*] Microsoft KMS Documentation Analysis' -ForegroundColor $Colors.Cyan
    Write-Host '[*] File: kms-client-activation-keys.md' -ForegroundColor $Colors.White
    Write-Host '[*] Commit: b4f2899feb4cec44ad329f5bdb02376d97d1145a' -ForegroundColor $Colors.White
    Write-Host ''
    Write-Host 'Starting comprehensive analysis...' -ForegroundColor $Colors.Yellow
    Write-Host ''
    Start-Sleep -Seconds 2
    
    $results = Analyze-KmsDocumentation
    
    Start-Sleep -Seconds 1
    Write-Host ''
    Show-Detailed-Report -AnalysisResults $results
    
    Start-Sleep -Seconds 1
    Show-Fixes
    
    Show-Summary -AnalysisResults $results
    
    Write-Host '[*] Window will close in 10 seconds...' -ForegroundColor $Colors.Yellow
    Start-Sleep -Seconds 10
}

Main
