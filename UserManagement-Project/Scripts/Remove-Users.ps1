# User Cleanup/Rollback Script for MyLab
Import-Module ActiveDirectory

# List of usernames to remove (from our CSV)
$Usernames = @(
    "john.smith",
    "sarah.johnson",
    "michael.williams",
    "emily.brown",
    "david.jones",
    "lisa.garcia",
    "robert.martinez",
    "jessica.davis"
)

foreach ($Username in $Usernames) {
    try {
        # Remove user from AD
        Remove-ADUser -Identity $Username -Confirm:$false
        Write-Host "✓ Removed user: $Username" -ForegroundColor Yellow
        
        # Remove home folder
        $FolderPath = "C:\DC-Server\UserHome\$Username"
        if (Test-Path $FolderPath) {
            Remove-Item -Path $FolderPath -Recurse -Force
            Write-Host "✓ Removed folder: $FolderPath" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "✗ Could not remove $Username (may not exist)" -ForegroundColor Gray
    }
}

Write-Host "Cleanup complete! Ready to run onboarding again." -ForegroundColor Green