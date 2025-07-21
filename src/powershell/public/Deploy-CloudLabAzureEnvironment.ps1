#Requires -Version 5.1
#Requires -Modules AutomatedLab, Az.Accounts, Az.Resources, Az.Network, Az.Compute, Az.Storage, Az.Websites, Az.Security
<#
.SYNOPSIS
    Deploys a comprehensive lab environment in Azure using AutomatedLab framework.

.DESCRIPTION
    This script creates a complete lab environment in Azure consisting of:
    - Windows Server 2022 Domain Controller (DC01)
    - Windows 11 Enterprise Client (CLIENT01)
    - Virtual network with proper DNS configuration
    - Active Directory Domain Services setup
    - Automatic domain join for client machine

.PARAMETER CleanupOnly
    If specified, only performs cleanup operations to remove the lab environment.

.PARAMETER SkipPrerequisiteCheck
    If specified, skips the prerequisite validation checks.

.PARAMETER AdminPassword
    Specifies the administrator password. If not provided, a secure password will be generated.

.EXAMPLE
    .\Deploy-CloudLabAzureEnvironment.ps1
    Deploys the complete lab environment with generated password.

.EXAMPLE
    .\Deploy-CloudLabAzureEnvironment.ps1 -AdminPassword "P@ssw0rd123!"
    Deploys the lab environment with specified password.

.EXAMPLE
    .\Deploy-CloudLabAzureEnvironment.ps1 -CleanupOnly
    Removes the existing lab environment.

.NOTES
    Author: CloudLab Team
    Version: 1.0
    Date: July 19, 2025
    Requires: AutomatedLab, Azure PowerShell modules
#>

[CmdletBinding()]
param(
    [switch]$CleanupOnly,
    [switch]$SkipPrerequisiteCheck,
    [SecureString]$AdminPassword
)

#region Configuration Constants
$script:Config = @{
    # Lab Configuration
    LabName = "CloudLab-Environment"
    DomainName = "lab.local"
    NetBiosName = "LAB"
    
    # Azure Configuration
    AzureRegion = "Australia East"
    ResourceGroup = "CloudLab"
    VmSize = "Standard_D2s_v3"
    
    # Network Configuration
    VirtualNetworkName = "CloudLab-VNet"
    SubnetName = "CloudLab-Subnet"
    AddressSpace = "10.0.0.0/16"
    SubnetRange = "10.0.1.0/24"
    
    # Credentials
    AdminUsername = "admin"
    
    # VM Configuration
    DomainController = @{
        Name = "DC01"
        OS = "Windows Server 2022 Datacenter"
        IP = "10.0.1.10"
        Roles = @("RootDC")
    }
    
    Client = @{
        Name = "CLIENT01"
        OS = "Windows 11 Enterprise"
        IP = "DHCP"
    }
}

# Global variables
$script:LogFile = "CloudLab-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$script:AdminCredential = $null
#endregion

#region Logging Functions
function Write-LogMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Success')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console with appropriate color
    switch ($Level) {
        'Info' { Write-Host $logMessage -ForegroundColor White }
        'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
        'Error' { Write-Host $logMessage -ForegroundColor Red }
        'Success' { Write-Host $logMessage -ForegroundColor Green }
    }
    
    # Write to log file
    Add-Content -Path $script:LogFile -Value $logMessage -ErrorAction SilentlyContinue
}

function Write-Progress-Custom {
    [CmdletBinding()]
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete = 0
    )
    
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    Write-LogMessage -Message "$Activity - $Status" -Level Info
}
#endregion

#region Prerequisite Functions
function Test-Prerequisites {
    [CmdletBinding()]
    param()
    
    Write-Progress-Custom -Activity "Checking Prerequisites" -Status "Validating environment" -PercentComplete 10
    
    $prerequisites = @()
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        $prerequisites += "PowerShell 5.1 or higher is required"
    }
    
    # Check AutomatedLab module
    try {
        Import-Module AutomatedLab -ErrorAction Stop
        Write-LogMessage -Message "AutomatedLab module loaded successfully" -Level Success
    }
    catch {
        $prerequisites += "AutomatedLab module is not installed. Install with: Install-Module AutomatedLab -Scope CurrentUser"
    }
    
    # Check Azure PowerShell modules
    $requiredAzModules = @('Az.Accounts', 'Az.Resources', 'Az.Network', 'Az.Compute', 'Az.Storage')
    foreach ($module in $requiredAzModules) {
        try {
            Import-Module $module -ErrorAction Stop
            Write-LogMessage -Message "$module module loaded successfully" -Level Success
        }
        catch {
            $prerequisites += "$module module is not installed. Install with: Install-Module $module -Scope CurrentUser"
        }
    }
    
    # Check Azure authentication
    try {
        $context = Get-AzContext
        if (-not $context) {
            $prerequisites += "Not authenticated to Azure. Run Connect-AzAccount first"
        }
        else {
            Write-LogMessage -Message "Azure authentication verified for subscription: $($context.Subscription.Name)" -Level Success
        }
    }
    catch {
        $prerequisites += "Azure PowerShell context not available. Run Connect-AzAccount"
    }
    
    # Check Azure subscription quotas (basic check)
    if (-not $prerequisites) {
        try {
            $location = $script:Config.AzureRegion
            $vmSizes = Get-AzComputeResourceSku -Location $location | Where-Object { $_.ResourceType -eq "virtualMachines" -and $_.Name -eq $script:Config.VmSize }
            if (-not $vmSizes) {
                $prerequisites += "VM size $($script:Config.VmSize) is not available in region $location"
            }
            else {
                Write-LogMessage -Message "VM size $($script:Config.VmSize) is available in $location" -Level Success
            }
        }
        catch {
            Write-LogMessage -Message "Could not verify VM size availability: $($_.Exception.Message)" -Level Warning
        }
    }
    
    if ($prerequisites.Count -gt 0) {
        Write-LogMessage -Message "Prerequisites check failed:" -Level Error
        foreach ($prereq in $prerequisites) {
            Write-LogMessage -Message "  - $prereq" -Level Error
        }
        throw "Prerequisites not met. Please resolve the above issues and try again."
    }
    
    Write-LogMessage -Message "All prerequisites check passed" -Level Success
}

function Initialize-Credentials {
    [CmdletBinding()]
    param()
    
    if ($AdminPassword) {
        $script:AdminCredential = New-Object System.Management.Automation.PSCredential($script:Config.AdminUsername, $AdminPassword)
        Write-LogMessage -Message "Using provided administrator password" -Level Info
    }
    else {
        # Generate secure random password
        $passwordLength = 16
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        $password = ""
        for ($i = 0; $i -lt $passwordLength; $i++) {
            $password += $chars[(Get-Random -Maximum $chars.Length)]
        }
        
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        $script:AdminCredential = New-Object System.Management.Automation.PSCredential($script:Config.AdminUsername, $securePassword)
        
        Write-LogMessage -Message "Generated secure administrator password: $password" -Level Success
        Write-Host "`n" -NoNewline
        Write-Host "IMPORTANT: Save this password - " -ForegroundColor Yellow -NoNewline
        Write-Host "$password" -ForegroundColor Red -BackgroundColor Yellow
        Write-Host "`n" -NoNewline
    }
}
#endregion

#region Lab Setup Functions
function New-AzureStorageAccountForLab {
    [CmdletBinding()]
    param()
    
    try {
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Creating compliant storage account" -PercentComplete 15
        
        # Create AutomatedLabSources resource group if it doesn't exist
        $labSourcesRG = "AutomatedLabSources"
        $resourceGroup = Get-AzResourceGroup -Name $labSourcesRG -ErrorAction SilentlyContinue
        if (-not $resourceGroup) {
            New-AzResourceGroup -Name $labSourcesRG -Location $script:Config.AzureRegion
            Write-LogMessage -Message "Created resource group: $labSourcesRG" -Level Success
        }
        
        # Generate unique storage account name (AutomatedLab uses specific naming convention)
        $storageAccountName = "automatedlabsources" + (Get-Random -Maximum 99999).ToString().PadLeft(5, '0')
        
        # Create storage account with Azure AD authentication only (compliant with policy)
        $storageAccountParams = @{
            ResourceGroupName = $labSourcesRG
            Name = $storageAccountName
            Location = $script:Config.AzureRegion
            SkuName = "Standard_LRS"
            Kind = "StorageV2"
            AllowBlobPublicAccess = $false
            EnableHttpsTrafficOnly = $true
            RequireInfrastructureEncryption = $true
            AllowSharedKeyAccess = $false  # This disables local authentication
            PublicNetworkAccess = "Enabled"
            MinimumTlsVersion = "TLS1_2"
        }
        
        $storageAccount = New-AzStorageAccount @storageAccountParams
        Write-LogMessage -Message "Created compliant storage account: $storageAccountName" -Level Success
        
        # Get the storage account context using Azure AD authentication
        $ctx = $storageAccount.Context
        
        # Set the current subscription's default storage account
        Set-AzCurrentStorageAccount -ResourceGroupName $labSourcesRG -AccountName $storageAccountName
        Write-LogMessage -Message "Set current storage account for subscription" -Level Success
        
        # Create the labsources file share that AutomatedLab expects
        try {
            $fileShare = New-AzStorageShare -Name "labsources" -Context $ctx -ErrorAction SilentlyContinue
            if ($fileShare) {
                Write-LogMessage -Message "Created 'labsources' file share" -Level Success
            }
        }
        catch {
            Write-LogMessage -Message "Note: File share creation may be handled by AutomatedLab: $($_.Exception.Message)" -Level Warning
        }
        
        # Also create lab resource group if it doesn't exist
        $labResourceGroup = Get-AzResourceGroup -Name $script:Config.ResourceGroup -ErrorAction SilentlyContinue
        if (-not $labResourceGroup) {
            New-AzResourceGroup -Name $script:Config.ResourceGroup -Location $script:Config.AzureRegion
            Write-LogMessage -Message "Created lab resource group: $($script:Config.ResourceGroup)" -Level Success
        }
        
        return $storageAccount
    }
    catch {
        Write-LogMessage -Message "Failed to create storage account: $($_.Exception.Message)" -Level Error
        throw
    }
}

function New-CloudLabEnvironment {
    [CmdletBinding()]
    param()
    
    try {
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Initializing AutomatedLab" -PercentComplete 20
        
        # Pre-create compliant storage account before AutomatedLab tries to create one
        $storageAccount = New-AzureStorageAccountForLab
        
        # Initialize AutomatedLab
        New-LabDefinition -Name $script:Config.LabName -DefaultVirtualizationEngine Azure
        
        # Set Azure subscription and location with the pre-created storage account
        Add-LabAzureSubscription -DefaultLocationName $script:Config.AzureRegion -verbose
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Configuring virtual network" -PercentComplete 25
        
        # Add virtual network
        Add-LabVirtualNetworkDefinition -Name $script:Config.VirtualNetworkName -AddressSpace $script:Config.AddressSpace -AzureProperties @{
            ResourceGroupName = $script:Config.ResourceGroup
            Subnets = @(
                @{
                    Name = $script:Config.SubnetName
                    AddressPrefix = $script:Config.SubnetRange
                }
            )
        }
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Adding domain definition" -PercentComplete 30
        
        # Add domain
        Add-LabDomainDefinition -Name $script:Config.DomainName -AdminUser $script:Config.AdminUsername -AdminPassword $script:AdminCredential.Password
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Configuring domain controller" -PercentComplete 35
        
        # Add Domain Controller
        $dcProps = @{
            Name = $script:Config.DomainController.Name
            Memory = 2GB
            OperatingSystem = $script:Config.DomainController.OS
            Roles = $script:Config.DomainController.Roles
            IpAddress = $script:Config.DomainController.IP
            DomainName = $script:Config.DomainName
            AzureProperties = @{
                ResourceGroupName = $script:Config.ResourceGroup
                RoleSize = $script:Config.VmSize
                VirtualNetwork = $script:Config.VirtualNetworkName
                SubnetName = $script:Config.SubnetName
                UseAllRoleSizes = $true
            }
        }
        
        Add-LabMachineDefinition @dcProps
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Configuring Windows 11 client" -PercentComplete 40
        
        # Add Windows 11 Client
        $clientProps = @{
            Name = $script:Config.Client.Name
            Memory = 4GB
            OperatingSystem = $script:Config.Client.OS
            DomainName = $script:Config.DomainName
            AzureProperties = @{
                ResourceGroupName = $script:Config.ResourceGroup
                RoleSize = $script:Config.VmSize
                VirtualNetwork = $script:Config.VirtualNetworkName
                SubnetName = $script:Config.SubnetName
                UseAllRoleSizes = $true
            }
        }
        
        Add-LabMachineDefinition @clientProps
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Installing lab environment" -PercentComplete 45
        
        # Install the lab
        Install-Lab
        
        Write-LogMessage -Message "Lab environment created successfully" -Level Success
        
        # Configure post-deployment settings
        Invoke-PostDeploymentConfiguration
        
        Write-Progress-Custom -Activity "Creating Lab Environment" -Status "Completed" -PercentComplete 100
        
    }
    catch {
        Write-LogMessage -Message "Failed to create lab environment: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Invoke-PostDeploymentConfiguration {
    [CmdletBinding()]
    param()
    
    Write-Progress-Custom -Activity "Post-Deployment Configuration" -Status "Configuring domain controller" -PercentComplete 60
    
    try {
        # Wait for DC to be ready
        Wait-LabVM -ComputerName $script:Config.DomainController.Name -PostInstallationActivity
        
        # Configure DNS settings on DC
        $dcName = $script:Config.DomainController.Name
        Invoke-LabCommand -ActivityName "Configuring DNS on DC" -ComputerName $dcName -ScriptBlock {
            # Set DNS forwarders
            Add-DnsServerForwarder -IPAddress "8.8.8.8", "1.1.1.1" -PassThru
            
            # Restart DNS service
            Restart-Service -Name DNS -Force
            
            Write-Host "DNS configuration completed on $env:COMPUTERNAME"
        }
        
        Write-Progress-Custom -Activity "Post-Deployment Configuration" -Status "Configuring Windows 11 client" -PercentComplete 80
        
        # Wait for client to be ready and joined to domain
        Wait-LabVM -ComputerName $script:Config.Client.Name -PostInstallationActivity
        
        # Configure client DNS settings
        $clientName = $script:Config.Client.Name
        Invoke-LabCommand -ActivityName "Configuring DNS on Client" -ComputerName $clientName -ScriptBlock {
            param($DcIp)
            
            # Set DNS server to domain controller
            $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
            if ($adapter) {
                Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $DcIp
                Write-Host "DNS server set to $DcIp on $env:COMPUTERNAME"
            }
            
            # Test domain connectivity
            $domain = $env:USERDNSDOMAIN
            if ($domain) {
                Write-Host "$env:COMPUTERNAME successfully joined to domain: $domain"
            }
            
        } -ArgumentList $script:Config.DomainController.IP
        
        Write-LogMessage -Message "Post-deployment configuration completed successfully" -Level Success
    }
    catch {
        Write-LogMessage -Message "Post-deployment configuration failed: $($_.Exception.Message)" -Level Warning
    }
}
#endregion

#region Validation Functions
function Test-LabDeployment {
    [CmdletBinding()]
    param()
    
    Write-Progress-Custom -Activity "Validating Lab Deployment" -Status "Starting validation tests" -PercentComplete 85
    
    $validationResults = @{
        DomainControllerRunning = $false
        DnsWorking = $false
        ClientJoinedDomain = $false
        NetworkConnectivity = $false
        ActiveDirectoryServices = $false
    }
    
    try {
        # Test Domain Controller
        Write-LogMessage -Message "Testing domain controller availability..." -Level Info
        $dcTest = Test-LabVMInternetConnectivity -ComputerName $script:Config.DomainController.Name
        if ($dcTest) {
            $validationResults.DomainControllerRunning = $true
            Write-LogMessage -Message "Domain controller is responding" -Level Success
        }
        
        # Test DNS resolution
        Write-LogMessage -Message "Testing DNS resolution..." -Level Info
        $dnsTest = Invoke-LabCommand -ComputerName $script:Config.DomainController.Name -ScriptBlock {
            param($DomainName)
            try {
                $result = Resolve-DnsName -Name $DomainName -ErrorAction Stop
                return $result -ne $null
            }
            catch {
                return $false
            }
        } -ArgumentList $script:Config.DomainName -PassThru
        
        if ($dnsTest) {
            $validationResults.DnsWorking = $true
            Write-LogMessage -Message "DNS resolution is working correctly" -Level Success
        }
        
        # Test client domain join
        Write-LogMessage -Message "Testing client domain membership..." -Level Info
        $domainTest = Invoke-LabCommand -ComputerName $script:Config.Client.Name -ScriptBlock {
            try {
                $computerSystem = Get-WmiObject -Class Win32_ComputerSystem
                return $computerSystem.PartOfDomain
            }
            catch {
                return $false
            }
        } -PassThru
        
        if ($domainTest) {
            $validationResults.ClientJoinedDomain = $true
            Write-LogMessage -Message "Client successfully joined to domain" -Level Success
        }
        
        # Test network connectivity between machines
        Write-LogMessage -Message "Testing network connectivity..." -Level Info
        $connectivityTest = Invoke-LabCommand -ComputerName $script:Config.Client.Name -ScriptBlock {
            param($DcIp)
            try {
                $pingResult = Test-Connection -ComputerName $DcIp -Count 2 -Quiet
                return $pingResult
            }
            catch {
                return $false
            }
        } -ArgumentList $script:Config.DomainController.IP -PassThru
        
        if ($connectivityTest) {
            $validationResults.NetworkConnectivity = $true
            Write-LogMessage -Message "Network connectivity between machines is working" -Level Success
        }
        
        # Test Active Directory services
        Write-LogMessage -Message "Testing Active Directory services..." -Level Info
        $adTest = Invoke-LabCommand -ComputerName $script:Config.DomainController.Name -ScriptBlock {
            try {
                $services = @('ADWS', 'DNS', 'KDC', 'NETLOGON')
                $runningServices = 0
                
                foreach ($service in $services) {
                    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
                    if ($serviceStatus -and $serviceStatus.Status -eq 'Running') {
                        $runningServices++
                    }
                }
                
                return $runningServices -eq $services.Count
            }
            catch {
                return $false
            }
        } -PassThru
        
        if ($adTest) {
            $validationResults.ActiveDirectoryServices = $true
            Write-LogMessage -Message "Active Directory services are running correctly" -Level Success
        }
        
        # Generate validation report
        Write-LogMessage -Message "`n=== LAB VALIDATION REPORT ===" -Level Info
        foreach ($test in $validationResults.GetEnumerator()) {
            $status = if ($test.Value) { "PASS" } else { "FAIL" }
            $level = if ($test.Value) { "Success" } else { "Error" }
            Write-LogMessage -Message "$($test.Key): $status" -Level $level
        }
        
        $passedTests = ($validationResults.Values | Where-Object { $_ -eq $true }).Count
        $totalTests = $validationResults.Count
        
        Write-LogMessage -Message "Validation completed: $passedTests/$totalTests tests passed" -Level Info
        
        if ($passedTests -eq $totalTests) {
            Write-LogMessage -Message "All validation tests passed! Lab deployment is successful." -Level Success
            return $true
        }
        else {
            Write-LogMessage -Message "Some validation tests failed. Please check the configuration." -Level Warning
            return $false
        }
    }
    catch {
        Write-LogMessage -Message "Validation failed with error: $($_.Exception.Message)" -Level Error
        return $false
    }
    finally {
        Write-Progress-Custom -Activity "Validating Lab Deployment" -Status "Validation completed" -PercentComplete 100
    }
}
#endregion

#region Cleanup Functions
function Remove-CloudLabEnvironment {
    [CmdletBinding()]
    param()
    
    Write-Progress-Custom -Activity "Removing Lab Environment" -Status "Starting cleanup process" -PercentComplete 10
    
    try {
        # Check if lab exists
        $existingLab = Get-Lab -Name $script:Config.LabName -ErrorAction SilentlyContinue
        if (-not $existingLab) {
            Write-LogMessage -Message "Lab '$($script:Config.LabName)' not found" -Level Warning
            return
        }
        
        Write-Progress-Custom -Activity "Removing Lab Environment" -Status "Removing lab machines" -PercentComplete 30
        
        # Import lab definition if needed
        Import-Lab -Name $script:Config.LabName
        
        # Remove lab
        Remove-Lab -Name $script:Config.LabName -Confirm:$false
        
        Write-Progress-Custom -Activity "Removing Lab Environment" -Status "Cleaning up Azure resources" -PercentComplete 60
        
        # Additional cleanup of Azure resources
        try {
            $resourceGroup = Get-AzResourceGroup -Name $script:Config.ResourceGroup -ErrorAction SilentlyContinue
            if ($resourceGroup) {
                Write-LogMessage -Message "Removing resource group: $($script:Config.ResourceGroup)" -Level Info
                Remove-AzResourceGroup -Name $script:Config.ResourceGroup -Force -AsJob | Out-Null
                Write-LogMessage -Message "Resource group removal initiated (running in background)" -Level Success
            }
        }
        catch {
            Write-LogMessage -Message "Could not remove resource group: $($_.Exception.Message)" -Level Warning
        }
        
        Write-Progress-Custom -Activity "Removing Lab Environment" -Status "Cleanup completed" -PercentComplete 100
        Write-LogMessage -Message "Lab environment cleanup completed successfully" -Level Success
    }
    catch {
        Write-LogMessage -Message "Failed to remove lab environment: $($_.Exception.Message)" -Level Error
        throw
    }
}
#endregion

#region Main Function
function Invoke-CloudLabDeployment {
    [CmdletBinding()]
    param()
    
    $startTime = Get-Date
    
    try {
        Write-LogMessage -Message "Starting CloudLab deployment process" -Level Info
        Write-LogMessage -Message "Log file: $script:LogFile" -Level Info
        
        # Perform cleanup if requested
        if ($CleanupOnly) {
            Remove-CloudLabEnvironment
            return
        }
        
        # Check prerequisites
        if (-not $SkipPrerequisiteCheck) {
            Test-Prerequisites
        }
        
        # Initialize credentials
        Initialize-Credentials
        
        # Create lab environment
        New-CloudLabEnvironment
        
        # Validate deployment
        $validationResult = Test-LabDeployment
        
        $endTime = Get-Date
        $duration = $endTime - $startTime
        
        Write-LogMessage -Message "`n=== DEPLOYMENT SUMMARY ===" -Level Info
        Write-LogMessage -Message "Lab Name: $($script:Config.LabName)" -Level Info
        Write-LogMessage -Message "Domain: $($script:Config.DomainName)" -Level Info
        Write-LogMessage -Message "Resource Group: $($script:Config.ResourceGroup)" -Level Info
        Write-LogMessage -Message "Region: $($script:Config.AzureRegion)" -Level Info
        Write-LogMessage -Message "Administrator Username: $($script:Config.AdminUsername)" -Level Info
        Write-LogMessage -Message "Deployment Duration: $($duration.ToString('hh\:mm\:ss'))" -Level Info
        Write-LogMessage -Message "Validation Status: $(if ($validationResult) { 'PASSED' } else { 'FAILED' })" -Level $(if ($validationResult) { 'Success' } else { 'Warning' })
        
        if ($validationResult) {
            Write-LogMessage -Message "`nCloudLab environment deployed successfully!" -Level Success
            Write-LogMessage -Message "You can now connect to your lab machines using the provided credentials." -Level Info
            Write-LogMessage -Message "To remove the lab, run: .\Deploy-CloudLabAzureEnvironment.ps1 -CleanupOnly" -Level Info
        }
        else {
            Write-LogMessage -Message "`nCloudLab environment was deployed but some validation tests failed." -Level Warning
            Write-LogMessage -Message "Please review the validation results above and troubleshoot any issues." -Level Warning
        }
    }
    catch {
        $endTime = Get-Date
        $duration = $endTime - $startTime
        
        Write-LogMessage -Message "CloudLab deployment failed after $($duration.ToString('hh\:mm\:ss'))" -Level Error
        Write-LogMessage -Message "Error: $($_.Exception.Message)" -Level Error
        Write-LogMessage -Message "Please check the log file for detailed error information: $script:LogFile" -Level Error
        
        throw
    }
}
#endregion

# Execute main function
if ($MyInvocation.InvocationName -ne '.') {
    Invoke-CloudLabDeployment
}
