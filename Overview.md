##### 1. Task - Create Azure Subscription
   >**Note**: Your trainer guides you through the process. You will
   >- create an Azure Active Directory tenant
   >- add a subscription
   >- create a Globa Administrator account
   >- grant it all necessary permissions
   >- add licences (Phryne Business, Sherlock Enterprise)

#####2. Task - Create the simulated on-premise environment
   1. In the Azure portal, open **Cloud Shell** pane by selecting on the toolbar icon directly to the right of the search textbox.
   2. If prompted to select either Bash or PowerShell, select **PowerShell**.
    >Note: If this is the first time you are starting Cloud Shell and you are presented with the You have no storage mounted message, select the subscription you are using in this lab, and select Create storage.
   3. To create a resource group, type the following command and press Enter:
   ```powershell
    $location = 'westeurope';
    $rgname = 'RG-W365Env';
    New-AzResourceGroup -Name $rgname -Location $location;
   ```
   4. To create a virtual network, type the following command and press Enter:
   ```powershell
   New-AzVirtualNetwork -Name 'VNet-Hub' -ResourceGroupName $rgname -Location $location -AddressPrefix '10.100.0.0/16';
   $vnet = Get-AzVirtualNetwork -Name 'VNet-Hub' -ResourceGroupName $rgname;
   Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'sn-CloudPCs' -AddressPrefix '10.100.10.0/24';
   Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'sn-OnPremSim' -AddressPrefix '10.100.20.0/24';
   Set-AzVirtualNetwork -VirtualNetwork $vnet;
   ```
   5. To create a VM acting as domain controller, type the following and press Enter:
   ```powershell
   $cred = New-Object -TypeName PSCredential -ArgumentList ('localadmin',(ConvertTo-SecureString 'Pa$$w0rd1234' -AsPlainText -Force));
   New-AzVM -ResourceGroupName $rgname -Location $location -Name opDC -VirtualNetworkName $VNet.Name -SubnetName 'sn-OnPremSim' -Credential $cred -Size 'Standard_D2as_v5' -PublicIpAddressName 'opDC-PupIP' -Image 'Win2019Datacenter' -OpenPorts @(3389,5986);
   ```
   >**Note**: If the VM chosen size does not allow you to create a VM search with the following command for an available size in your subscription and location:
   >`az vm list-skus --location westeurope --size Standard_D --output table`

   >**Note**: At the moment of writing this guide, a lot of VM sizes were not available and the Az.Compute had a bug. Since that it could be the command above would leads to an error. In this case use the following step to create a VM manually.

   6. *This step is only necessary if you should see error messages in Cloud Shell.* Create a VM manually:
   
      | Setting | Value |
      | ------- | ----- |
      | VM Name | opDC |
      | Region/Location | West Europe |
      | Image | [smalldisk] Windows Server 2019 Datacenter - Gen1 |
      | Size | Standard_D2as_v5 or available size |
      | Username | localadmin |
      | Password | Pa$$w0rd1234 |
      | Inbound Port Rules | RDP (3389) |
      | Licensing | use an existing Windows Server license yes |
      | *Disks* | 
      | OS disk type | Standard SSD |
      | *Networking* |
      | Virtual Network | VNet-Hub |
      | Subnet | sn-OnPremSim |
      | Public IP | Create new |
    
   7. After the VM is created successfully, select it and click 'Networking' in the resource menu.
   8. Next to **Network Interface:** click the name of the NIC 'opDC'.
   9. In the resource menu under *Settings* click the item 'IP configurations' and in the list click the line 'opDC - IPv4 - Primary - ...'
   10. Under '**Private** IP address settings' set the assignment to 'Static' and type the IP address: '10.100.20.100'.
   11. Click 'Save' and wait until the deployment has finished.
   12. Navigate to the resource group 'RG-W365Env' and click the vnet 'VNet-Hub'.
   13. In the resource menu under *Settings*'* select 'DNS servers' and set the IP Address '10.100.20.100' for a custom DNS server. Click 'Save'.
   14. Navigate to your VM 'opDC' and connect to it via RDP.
   
#####3. Task - Configure Azure Active Directory Connect and Device settings
   1.  Sign In as localadmin with the password Pa$$w0rd1234.
   2.  Open a PowerShell Console as administrator and type the following commands:
   ```powershell
   Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools;
   Install-ADDSForest -DomainName localAD.com -DomainNetbiosName localAD -SafeModeAdministratorPassword (ConvertTo-SecureString -String 'Pa$$w0rd1234' -AsPlainText -Force ) -InstallDns -Force;
   ```
   3. Wait until the VM restarted.
   4. Connect to the VM again and sign in again as localadmin. 
   5. Use the administrative tool 'Active Directory Domains and Trust' to add a domain suffix. This suffix must be your tenants primary domain.
   6. Use the tool 'Active Directory Users and Computers' and create an organizatinal Unit named 'W365Users'.
   7. Create two users in the newly create OU:

         | Name | UPN | Password |
         | ---- | -------- | --- |
         | Mike Hammer | mike@\<yourPrimaryDomain> | Pa$$w0rd |
         | Salvo Montalbano | salvo@\<yourPrimaryDomain> | Pa$$w0rd |

   8. Open a PowerShell console and install chocolatey:
   ```powershell
   Set-ExecutionPolicy Bypass -Force;
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
   ```  
   1.  Install Microsoft Edge Browser:
   ```powershell
   choco install microsoft-edge -y;
   ```  
   10. Download Azure Active Directory Connect from https://www.microsoft.com/en-us/download/details.aspx?id=47594 and install the tool with the following settings:
      
         | Setting | Value |
         | ------- | ----- |
         | Use custom settings | yes |
         | Install required components | Accexpt defaults and click Install |
         | User Sign-in | Password Hash Sync, Enable Single Sign On |
         | Connect to Azure AD | use your Azure Admin |
         | Select your Directory | use your local Admin (localadmin, Pa$$w0rd1234)
         | Azure AD sign-in configuration | Check 'Continue without matching ...'
         | Domain and OU filtering | Select Computers and OU W365Users
         | Optional features | Select 'Password writeback'  
         | Enable single sign-on | reenter your local Admin credentials
   11. Wait for the installation and the synchronization succeeded successfully. (Check the users in Azure Active Directory)
   12. Open the 'Azure AD Connect' tool and click the button 'Configure'.
   13. Then select the item 'Configure device options' and click twice 'Next'.
   14. In the window 'Connect to Azure AD' provide the credentials of your AAD admin.
   15. Select 'Configure Hybrid Azure AD join' and click 'Next'.
   16. Select 'Windows 10 or later domain-joined devices' and click 'Next'.
   17. Select the checkbox next to 'localAD.com'. As Authentication Service select 'Azure Active Directory' and click the button 'Add' to sign in as enterprise administrator to the local AD. Use 'localad\localadmin' and Pa$$w0rd1234 as password.
          
#####4. Task - Prepare Windows 365
   1. Switch to your browser on your workstation.
   2. Open a browser and navigate to 'https://portal.azure.com' and sign in with your global administator credentials, if not already done.
   3. Search for Azure Active Directory and create a security group:
   
         | Setting | Value |
         | --- | --- |
         | Group type | Security
         | Group name | W365EnterpriseUsers
         | Membership type | Assigned
         | Members | Mike Hammer
   4. Open a new tab in your browser and navigate to 'https://endpoint.microsoft.com'. If required sign in with you global administrator credentials.
   5. In the navigation pane select 'Devices' and then click the item 'Windows 365' in section *Provisioning* in the resource menu.
   6. Select the tab 'Azure network connection', click '+ Create' and then 'Hybrid Azure AD Join'.
   7. Provide the following settings and wait until the network is created successfully:
         | Setting | Value |
         | --- | --- 
         | Name | Hybrid Join Network
         | Subscription | *your subscription*
         | Resource Group | RG-W365Env 
         | Virtual network | VNet-Hub
         | Subnet | sn-CloudPCs
         | AD DNS domain name | localAD.com
         | Organizational Unit | W365Users
         | AD username UPN | localadmin@localad.com
         | AD domain password | Pa$$w0rd1234
      >**Note:** You created a connection from the Windows 365 service to your on premises environment. In real you have to create a VPN Gateway connection between your on premises network and the Azure virtual network. In that case ensure you could resolve DNS names for local resources in Azure.
   8. Select 'Provisioning policies' and then click '+ Creat Policy'.
   9. Use the following settings to create the Provisioning policy:
         | Setting | Value |
         | --- | ---
         | Name | Hybrid Join Policy
         | Join type | Hybrid Azure AD Join
         | Network | Hybrid Join Network
         | Image type | Gallery image; click 'Select' and choose *Windows 10 Enterprise + OS Optimizatin, 21H2, 1vCPU/2GB/64GB*
         | Language & Region | English (United States)
         | Assignment | Click ' +Add groups' to add the group *'*W365EnterpriseUsers*
      >**Note:** You created a provisioning policy to control how the cloud pcs are deployed. You selected the hybrid join option which requires an Azure AD Connect plus Device Settings configuration.
   10. <mark>User settings
   11. <mark> assign license to user
   12. <mark> wait
   13. connect user to cpc
       1.  web
       2.  client app
   14. Remote Managment
   15. Client downloaden, konfigurieren und verwenden (Client und Browser)
   17. 
   18. Images bauen To create a custom image for cloud pcs you could create a VM in Azure or upload your own on premises prepared image. The following steps show you how to create an image of an Azure VM. Create a new Azure VM in your subscription with the following command in cloud shell:
   ```powershell
      Invoke-WebRequest -Uri 'https://github.com/distcode/w365ws/raw/main/Labfiles/OnPremWin10Sim.json' -OutFile .\OnPremWin10Sim.json;
      New-AzResourceGroupDeployment -ResourceGroupName RG-W365EnvEUS -TemplateFile ./OnPremWin10Sim.json -ShutdownNotificationMail 'admin@<yourPrimaryDomain>';
   ```

   19. 
#####5. Task - Assign Licences

