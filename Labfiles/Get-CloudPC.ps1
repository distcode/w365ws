
Select-MgProfile -Name "beta"
Connect-MgGraph -Scopes 'Cloudpc.Read.All' # for changing use 'CloudPC.ReadWrite.All'

Get-MgDeviceManagementVirtualEndpointCloudPC

Get-MgDeviceManagementVirtualEndpointCloudPC `
    | Format-Table Status,managedDevicename,ServiceplanType,ServicePlanName,ImageDisplayname,ManagedDeviceID

(Get-MgDeviceManagementVirtualEndpointCloudPC)[0] | Format-List -Property *
