# Automated User Onboarding & Offboarding System

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?logo=powershell&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?logo=windows&logoColor=white)
![Group Policy](https://img.shields.io/badge/Group_Policy-0078D4?logo=windows&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows_Server-0078D4?logo=windows&logoColor=white)
![Automation](https://img.shields.io/badge/Automation-FF6B6B?logo=azuredevops&logoColor=white)
![Documentation](https://img.shields.io/badge/Documentation-4CAF50?logo=readthedocs&logoColor=white)

## Project Overview

An enterprise-level Active Directory user lifecycle management system built with PowerShell automation, demonstrating professional IT administration skills for user provisioning, deprovisioning, and auditing.

<img width="508" height="634" alt="AD_User_Manage,ment_Architecture-Page-2 drawio (1)" src="https://github.com/user-attachments/assets/adda40d1-5500-4083-9b5b-97f3597ac016" />


## Infrastructure

- **Domain:** mylab.com
- **Domain Controller:** Windows Server with Active Directory Domain Services
- **Client Machine:** Windows 11 Pro (domain-joined)
- **Company Structure:** 7 departments (IT, HR, Sales, Finance, Legal, Communication, Engineering)

## Key Features

### 1. Automated User Onboarding
- CSV-driven bulk user creation
- Standardized naming convention (firstname.lastname)
- Automatic OU placement by department
- Home directory provisioning with proper NTFS permissions
- Network drive mapping (H: drive)
- Security group assignment
- Password policy enforcement (change on first login)
<img width="906" height="909" alt="Screenshot 2025-11-04 164052" src="https://github.com/user-attachments/assets/6361209b-b502-4636-a7e5-4bd1e5c8b46d" />

### 2. Secure User Offboarding
- Interactive offboarding workflow
- Account disabling (not deletion)
- Movement to Disabled_Users OU
- Automated home folder backup with timestamps
- Security group removal
- Audit trail creation
<img width="854" height="792" alt="Screenshot 2025-11-04 233738" src="https://github.com/user-attachments/assets/ed604834-a323-4e22-b3fe-596fd50662c4" />

### 3. Comprehensive Auditing
- Automated user report generation
- Statistics dashboard (enabled/disabled counts)
- Department-based user breakdown
- Detailed user information export
- Timestamped audit logs
<img width="730" height="881" alt="Screenshot 2025-11-04 235842" src="https://github.com/user-attachments/assets/07b972f9-b409-4414-8d84-655c8c47ceda" />

### 4. Group Policy Management
- Department-specific GPOs
- Role-based access control
- Differentiated security policies
<img width="751" height="507" alt="Screenshot 2025-11-05 015823" src="https://github.com/user-attachments/assets/03487d1c-66c7-432f-8b4a-82c3375949db" />

## Project Structure
```
UserManagement-Project/
├── Scripts/
│   ├── New-UserOnboarding.ps1          # Main onboarding automation
│   ├── Remove-UserOffboarding.ps1      # Offboarding workflow
│   ├── Remove-Users.ps1                # Cleanup utility (testing)
│   └── Get-UserAuditReport.ps1         # Audit report generator
├── Documentation/
│   ├── PROJECT-SUMMARY.txt             # Complete project documentation
│   ├── QUICK-REFERENCE.txt             # Operational guide
│   └── Ticket-Template.txt             # IT ticketing template
├── SampleData/
│   └── NewUsers.csv                    # Sample employee data
└── Screenshots/
    └── [Project implementation screenshots]
|___ README.md
|___ UserAuditReport.txt
```

## How to Use

### Prerequisites
- Windows Server with Active Directory installed
- PowerShell 5.1 or higher
- Domain Administrator privileges

### Onboarding New Users

1. Prepare your CSV file with format:
```csv
   FirstName,LastName,Department,JobTitle
   John,Smith,IT,System Administrator
```

2. Run the onboarding script:
```powershell
   .\Scripts\New-UserOnboarding.ps1
```

3. Verify users in Active Directory Users and Computers

### Offboarding Users

1. Run the offboarding script:
```powershell
   .\Scripts\Remove-UserOffboarding.ps1
```

2. Enter username when prompted
3. Confirm action
4. Check backup in C:\DC-Server\UserBackups\

### Generate Audit Reports
```powershell
.\Scripts\Get-UserAuditReport.ps1
```

Reports are saved with timestamps in the Scripts folder.

## Challenges & Solutions

### Challenge 1: Security Group Naming Consistency
**Problem:** Inconsistent naming caused script failures  
**Solution:** Implemented standardized naming convention (GRP_Department) and created cleanup procedures

### Challenge 2: Network Path Resolution
**Problem:** Home drives not mapping due to incorrect server hostname  
**Solution:** Diagnosed DNS issues and updated scripts with correct server references

### Challenge 3: OU Visibility
**Problem:** Users not visible in standard AD view  
**Solution:** Enabled Advanced Features in ADUC to display all organizational units

### Challenge 4: PowerShell Array Handling
**Problem:** Disabled user count displaying incorrectly  
**Solution:** Implemented proper array syntax (@()) and null checking

### Challenge 5: Multi-OU User Management
**Problem:** Audit script only searched active users  
**Solution:** Expanded search scope to include Disabled_Users OU

## Testing Results

✅ Successfully onboarded 8 test users across 7 departments  
✅ All users correctly placed in departmental OUs  
✅ Home directories created with proper permissions  
✅ Drive mapping functional on client machines  
✅ Group policies applying correctly  
✅ Offboarding process verified with data backup  
✅ Audit reporting accurate and comprehensive  

## Business Value

- **Time Savings:** Reduces onboarding from hours to minutes
- **Consistency:** Zero manual provisioning errors
- **Compliance:** Complete audit trails for regulatory requirements
- **Security:** Proper offboarding with data retention
- **Scalability:** Easy to maintain and expand
- **Professional:** Enterprise-grade IT service management

## Future Enhancements

- Email notification integration
- Automated ticket creation in ServiceNow/JIRA
- Self-service password reset portal
- Multi-domain support
- Exchange mailbox provisioning
- Azure AD synchronization

## Contributing

This is a learning project. Feedback and suggestions are welcome!

## License

This project is for educational and portfolio purposes.


---

**Note:** This project was developed in a lab environment for learning purposes. All scripts should be tested thoroughly before use in production environments.
