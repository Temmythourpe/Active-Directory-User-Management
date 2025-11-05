# User Onboarding Script for MyLab
# Import Active Directory Module
Import-Module ActiveDirectory

# Import CSV file
$Users = Import-Csv -Path "C:\Scripts\NewUsers.csv"

# Set default password
$DefaultPassword = ConvertTo-SecureString "Welcome@2024" -AsPlainText -Force

# Process each user
foreach ($User in $Users) {
    $FirstName = $User.FirstName
    $LastName = $User.LastName
    $Department = $User.Department
    $JobTitle = $User.JobTitle
    $Username = "$FirstName.$LastName".ToLower()
    $OU = "OU=$Department,OU=MyLab_Users,DC=mylab,DC=com"
    $HomeDirectory = "\\LAB-Server-01\UserHome$\$Username"
    $HomeDrive = "H:"
    
    # Create user account
    try {
        New-ADUser `
            -Name "$FirstName $LastName" `
            -GivenName $FirstName `
            -Surname $LastName `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@mylab.com" `
            -Path $OU `
            -AccountPassword $DefaultPassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -Department $Department `
            -Title $JobTitle `
            -HomeDirectory $HomeDirectory `
            -HomeDrive $HomeDrive
        
        Write-Host "✓ Created user: $Username" -ForegroundColor Green
        
        # Create home folder
        $FolderPath = "C:\DC-Server\UserHome\$Username"
        New-Item -Path $FolderPath -ItemType Directory -Force
        
        # Set permissions on home folder
        $Acl = Get-Acl $FolderPath
        $Permission = "$env:USERDOMAIN\$Username","FullControl","ContainerInherit,ObjectInherit","None","Allow"
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $Permission
        $Acl.SetAccessRule($AccessRule)
        Set-Acl $FolderPath $Acl
        
        Write-Host "✓ Created home folder: $FolderPath" -ForegroundColor Green
        
        # Add user to department security group
        $GroupName = "GRP_$Department"
        Add-ADGroupMember -Identity $GroupName -Members $Username
        Write-Host "✓ Added to group: $GroupName" -ForegroundColor Green
        Write-Host "----------------------------------------" -ForegroundColor Cyan
        
    } catch {
        Write-Host "✗ Error creating user $Username : $_" -ForegroundColor Red
    }
}

Write-Host "User onboarding complete!" -ForegroundColor Yellow