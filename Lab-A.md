# Lab A: Deploy Windows 365 Business Cloud PCs

***
In this lab you will learn how to deploy and use a Windows 365 Business Cloud PC. For this lab it is not necessary to have an Azure Active Directory Connect service in place. With that service you can onyl assign a Cloud PC to a cloud identity. With the AAD Connect service you could assign that licenses also to hybrid identities, as you will see in Lab B.

Content of the lab:
1. Task -
2. Task -
***

   >**Note**: Your trainer guides you through the process.
   <!---
   >+ create an Azure Active Directory tenant
   >+ add a subscription
   >+ create a Globa Administrator account
   >+ grant it all necessary permissions
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

### 3. Task - Assign the Windows 365 Business License
1. 

### to do

10. Add a user and assign a license


11. User win365 to assign a license
12. Change organization defaults
13. connect user to cloud pc
14. remotely manage cloud pc
15. reset users password
16. restore a cpc