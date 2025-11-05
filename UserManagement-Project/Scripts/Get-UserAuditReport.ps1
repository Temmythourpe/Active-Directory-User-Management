# User Audit Report Script for MyLab
# Generates a comprehensive report of all domain users

Import-Module ActiveDirectory

Write-Host "Generating User Audit Report..." -ForegroundColor Cyan

# Get users from MyLab_Users OU
   $ActiveUsers = Get-ADUser -Filter * -SearchBase "OU=MyLab_Users,DC=mylab,DC=com" -Properties Department, Title, Enabled, whenCreated, LastLogonDate, MemberOf, HomeDirectory
   
   # Get users from Disabled_Users OU
   $DisabledUsersOU = Get-ADUser -Filter * -SearchBase "OU=Disabled_Users,DC=mylab,DC=com" -Properties Department, Title, Enabled, whenCreated, LastLogonDate, MemberOf, HomeDirectory -ErrorAction SilentlyContinue
   
   # Combine both
   $Users = $ActiveUsers + $DisabledUsersOU

# Create report header
$Report = @()
$Report += "=" * 100
$Report += "MYLAB DOMAIN USER AUDIT REPORT"
$Report += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$Report += "=" * 100
$Report += ""

# Summary statistics
$TotalUsers = $Users.Count
   $EnabledUsers = @($Users | Where-Object {$_.Enabled -eq $true}).Count
   $DisabledUsers = @($Users | Where-Object {$_.Enabled -eq $false}).Count
   
   # Handle null counts
   if ($null -eq $EnabledUsers) { $EnabledUsers = 0 }
   if ($null -eq $DisabledUsers) { $DisabledUsers = 0 }

$Report += "SUMMARY STATISTICS:"
$Report += "-------------------"
$Report += "Total Users: $TotalUsers"
$Report += "Enabled Users: $EnabledUsers"
$Report += "Disabled Users: $DisabledUsers"
$Report += ""

# Users by department
$Report += "USERS BY DEPARTMENT:"
$Report += "--------------------"
$Departments = $Users | Group-Object Department | Sort-Object Name
foreach ($Dept in $Departments) {
    $Report += "$($Dept.Name): $($Dept.Count) users"
}
$Report += ""

# Detailed user list
$Report += "DETAILED USER LIST:"
$Report += "=" * 100
$Report += ""

foreach ($User in $Users | Sort-Object Department, Name) {
    $Groups = ($User.MemberOf | ForEach-Object {($_ -split ',')[0] -replace 'CN='}) -join ', '
    $LastLogon = if ($User.LastLogonDate) { $User.LastLogonDate.ToString('yyyy-MM-dd') } else { "Never" }
    
    $Report += "Username: $($User.SamAccountName)"
    $Report += "Full Name: $($User.Name)"
    $Report += "Department: $($User.Department)"
    $Report += "Job Title: $($User.Title)"
    $Report += "Status: $(if ($User.Enabled) {'Enabled'} else {'Disabled'})"
    $Report += "Created: $($User.whenCreated.ToString('yyyy-MM-dd'))"
    $Report += "Last Logon: $LastLogon"
    $Report += "Home Directory: $($User.HomeDirectory)"
    $Report += "Security Groups: $Groups"
    $Report += "-" * 100
    $Report += ""
}

# Save report to file
$ReportPath = "C:\Scripts\UserAuditReport-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "✓ Report generated successfully!" -ForegroundColor Green
Write-Host "✓ Report saved to: $ReportPath" -ForegroundColor Green
Write-Host ""
Write-Host "Opening report..." -ForegroundColor Yellow

# Open the report
Start-Process notepad.exe $ReportPath