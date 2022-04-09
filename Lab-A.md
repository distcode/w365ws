# Lab A: Deploy Windows 365 Business Cloud PCs

***
In this lab you will learn how to deploy and use a Windows 365 Business Cloud PC. For this lab it is not necessary to have an Azure Active Directory Connect service in place. With that service you can onyl assign a Cloud PC to a cloud identity. With the AAD Connect service you could assign that licenses also to hybrid identities, as you will see in Lab B.

Content of the lab:
1. Task -
2. Task -
***
### 1. Task - Activate Trial Subscription
   >**Note**: Your trainer guides you through the process.
   <!---
   >+ create an Azure Active Directory tenant; Start with a M365 E5 Trial
   >+ create a Globa Administrator account
   >+ add licences (Microsoft 365 E5, only buy licenses, no assignment!!!)
   --->

### 2. Task - Create a user in Azure AD
1. Navigate to the [Microsoft Admin center](https://admin.microsoft.com).
2. To sign in, use your global admin account.
3. In the navigation menu select 'Users' and the 'Active Users'.
4. Click in the command bar '+ Add a user' and create a user with the following settings:
   | Setting | Value
   | --- | ---
   | First name | Sherlock
   | last name | Holmes
   | Username | sherlock@\<yourPublicDomain>
   | Automatically create a password | No
   | Password | Pa$$w0rd1234
   | Require this user to change their password ... | No
   | Send password in email upon completion | yes
   | Email the new password ... | your global admin
   Click 'Next'.
5. Set the location to Austria and assign only the 'Nicrosoft 365 E5' license without any additionl settings.
6. Click 'Next'.
7. On the page 'Optional settings click 'Next'. 
8. Review the information for your new user and click 'Finish and adding'.
9. Click 'Close' to return to the list of your Azure AD users.
10. Now you should check, if users are allowed to join devices to Azure Active Directory. To do so, navigate to the [Azure Active Directory portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview). This [link](https://aad.portal.azure.com) would also work.
11. Click in the resource menu in the section **Manage** the item 'Devices'.
12. Click in the new resource menu 'Device settings' and check the configuration 'Users my join devices to Azure AD'. This must be set to 'All'.
![Device Settings](_images/DevSetting01.png)
      >**Note:** In a real envrionment you could select also a group of users to avoid granting everybody the permissin to join devices. But in the picture you see the default for new tenants.
13. Proceed with the next task to set up a cloup PC.

### 3. Task - Update organization settings
1. In the middle of your webpage, click 'Update organization sttings'.
2. In the left fly-out select 'Local administrator'. This makes the user of a cloud PC to an administrator.
3. To choose the operation system for the cloud PCs select here 'Windows 11'.
4. Click 'Save' and close the fly-out.

### 4. Task - Assign the Windows 365 Business License
To set up a cloup PC for Windows 365 *Business* you have to assign a license. Although it is possible to assign this license in Microsoft Admin center, this guid will show you how to do that in the Windows 365 portal.
1. Open an new tab in your browser and navigate to the [Windows 365 portal](https://windows365.microsoft.com).
2. If needed sign in with your global admin account.
3. Select the user 'Sherlock Holmes' and click in the left fly-out on 'Licenses and apps'.
4. Select 'Windows 365 Business 1 vCPU, 2 GB, 64 GB' and then click the button 'Save changes' at the bottom.
5. Close the fly-out to return to the list of your users.
   >**Note:** A user with the name *Windows 365 BPRT Permanent User* is created automatically in Azure Active Directory. ***Do not change or delete that user***, otherwise your Cloud PCs would not work.

   >**Note:** The provisioning process will take about 30 minutes. In case of running for a longer time, re-assign the license to the user. To see the progress of the process, proceed with the next task.


### 5. Task - Connect user to a cloud PC
In this task you will see how to connect to a cloud pc with your browser but also with the Remote Desktop App.
1. Open a new in-private/incognito windows of your browser.
2. Navigate to [Windows 365](https://windows365.microsoft.com) and sign in as *sherlock@\<yourPublicDomain>*; use the password *Pa$$w0rd1234*.
3. Should you see the welcome wizard, click the button 'Next' until it changes to 'Get started'. Press it once more and you should see 'Welcome, Sherlock Holmes'.
4. Under the text 'Your Cloud PCs' you find a tile for your cloud PC.
5. Click the button 'Open in browser'.
6. A new tab is created. Deselct all local resources (Printer, Microphone and Clipboard). Then click 'Connect'.
7. Provide the password *Pa$$w0rd1234' and click 'Sign In'. After a few moments you are connected to Windows 11 desktop.
8. In the toolbar, upper left corner, your username and Cloud PC configuration is mentioned.
9. In the toolbar, upper right corner, you could set the window to the full screen.
10. Open the crop menu to investigate the sections.
![Toolbar](_images/SessionToolbar.png)
11. Click the section 'In session' and select 'Clipboard'.
12.  Click the button 'Update' and re-sign in to the Cloud PC.  some session settings. To get to your users profile page, click the last icon.
13. Start 'Microsoft Store' app and install the following software: 'Microsoft To Do: Lists, Tasks and Reminders'. It is not necessary to sign in to Microsoft Store. Ensure the sucsessfull installation by starting it from the Start menu.
14. Open a PowerShell console and tpye the following command to check if the cloud PC is joined to local domain and to Azure Active Directory:
      ```powershell
      dsregcmd.exe /status
      ```
      In the section 'Device State', the value *AzureADJoined* should be set to 'Yes'. It is not possible to join a Windws 365 Business to your local AD.
14. Open the start menu again and click the power off button to disconnect from the Cloud PC.
14. If needed, close the current tab and return to the tab 'Windows 365' in the same browser window.
15. Click 'Download Remote Desktop' and chose the option for you operating system.
17. Install the app and start it from your start menu.
18. In the Remote Desktop app click the button 'Subscribe' and sign with the username *'*sherlock@\<yourPublicDomain>* and the password *Pa$$w0rd*.
19. After you signed in successfully you should see an icon for your cloud pc.
20. Double-click it and sing in as *'*sherlock@\<yourPublicDomain>* again.
      >**Note:** You are connected to the *same* Cloud PC as before. You should see the installed Microsoft To Do app in Start menu.





### to do
- [X] connect user to cloud pc via App
- [ ] remotely manage cloud pc
- [ ] reset users password
- [ ] restore a cpc