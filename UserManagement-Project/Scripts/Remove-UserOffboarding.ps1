# User Offboarding Script for MyLab
# This script disables users, moves them to a disabled OU, and backs up their home folder

Import-Module ActiveDirectory

# Get username to offboard
$Username = Read-Host "Enter username to offboard (e.g., john.smith)"

# Check if user exists
try {
    $User = Get-ADUser -Identity $Username -Properties HomeDirectory
    
    Write-Host "Found user: $($User.Name)" -ForegroundColor Yellow
    Write-Host "Current OU: $($User.DistinguishedName)" -ForegroundColor Yellow
    
    # Confirm offboarding
    $Confirm = Read-Host "Are you sure you want to offboard this user? (yes/no)"
    
    if ($Confirm -eq "yes") {
        
        # Create Disabled Users OU if it doesn't exist
        $DisabledOU = "OU=Disabled_Users,DC=mylab,DC=com"
        try {
            Get-ADOrganizationalUnit -Identity $DisabledOU -ErrorAction Stop
        } catch {
            New-ADOrganizationalUnit -Name "Disabled_Users" -Path "DC=mylab,DC=com"
            Write-Host "✓ Created Disabled_Users OU" -ForegroundColor Green
        }
        
        # Disable the account
        Disable-ADAccount -Identity $Username
        Write-Host "✓ Account disabled" -ForegroundColor Green
        
        # Move to Disabled Users OU
        Move-ADObject -Identity $User.DistinguishedName -TargetPath $DisabledOU
        Write-Host "✓ Moved to Disabled_Users OU" -ForegroundColor Green
        
        # Backup home folder
        if ($User.HomeDirectory) {
            $HomePath = $User.HomeDirectory -replace '\\\\LAB-Server-01\\UserHome\$\\', 'C:\DC-Server\UserHome\'
            $BackupPath = "C:\DC-Server\UserBackups\$Username-$(Get-Date -Format 'yyyyMMdd')"
            
            if (Test-Path $HomePath) {
                # Create backup directory
                New-Item -Path "C:\DC-Server\UserBackups" -ItemType Directory -Force | Out-Null
                
                # Copy home folder to backup
                Copy-Item -Path $HomePath -Destination $BackupPath -Recurse -Force
                Write-Host "✓ Home folder backed up to: $BackupPath" -ForegroundColor Green
            }
        }
        
        # Remove from all groups except Domain Users
        $Groups = Get-ADPrincipalGroupMembership -Identity $Username | Where-Object {$_.Name -ne "Domain Users"}
        foreach ($Group in $Groups) {
            Remove-ADGroupMember -Identity $Group -Members $Username -Confirm:$false
            Write-Host "✓ Removed from group: $($Group.Name)" -ForegroundColor Green
        }
        
        # Set description
        Set-ADUser -Identity $Username -Description "Offboarded on $(Get-Date -Format 'yyyy-MM-dd')"
        
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "Offboarding completed successfully!" -ForegroundColor Green
        Write-Host "User: $Username" -ForegroundColor Yellow
        Write-Host "Status: Disabled and moved to Disabled_Users OU" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Cyan
        
    } else {
        Write-Host "Offboarding cancelled." -ForegroundColor Red
    }
    
} catch {
    Write-Host "Error: User '$Username' not found or error occurred: $_" -ForegroundColor Red
}