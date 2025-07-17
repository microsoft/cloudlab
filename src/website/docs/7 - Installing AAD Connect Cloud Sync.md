---
id: cloudsync
title: Installing Microsoft Entra Cloud Sync
sidebar_label: Cloud Sync
slug: /cloudsync
---

Microsoft Entra Cloud Sync is a new approach for the synchronization of users, groups, and contacts to Microsoft Entra ID. It accomplishes this by using a lightweight provisioning agent instead of the old school Microsoft Entra Connect application that is based on MIM. Cloud Sync is not feature complete when compared with Microsoft Entra Connect, namely it is missing the ability to sync devices, custom attributes, and perform device/group writeback. It does however support Password Hash Sync and SSPR + writeback which is more than adequate for the purposes of this lab guide.

Password hash sync (PHS) is a sign-on method used to accomplish hybrid identity. Microsoft Entra Connect syncs a hash of the hash, of a user’s password from on-premises AD to Microsoft Entra ID.

# Lab success exit criteria

After installing the Cloud Sync agent in the on-premises Active Directory, you will configure Cloud Sync to synchronize users and their password hashes to the tenant. As a final step you will enable Self Service Password Reset (SSPR) and enable the password writeback feature. This setup will then be validated by signing into Microsoft Entra with a test on-premises user using their on-premises credentials.

   ![MISSING ALT TEXT](img/cloudsync.001.png)

## Step 1. Turn off IE Security Settings and install Edge on your DC

The basic SKU of Azure Bastion doesn’t allow the copy or pasting of files over a remote session (it does allow the copy/paste of text though). To work around this, one option is to upgrade Azure Bastion to the standard SKU which would increase the monthly Azure credit unnecessarily. The suggested option is to download the required files throughout the lab directly onto the VM itself, to do this we need to turn off the IE Enhanced Security settings on the server and then install Edge to limit the use of Internet Explorer.

1. Log into the DC VM using Azure Bastion.

1. Go to **Start/Server Manager/Local Server** and toggle **IE Enhanced Security Configuration** to **Off** for both Administrators and Users.

   ![MISSING ALT TEXT](img/cloudsync.002.png)

1. Open Internet Explorer from the shortcut on the task bar and go to <https://www.microsoft.com/en-us/edge> and then choose the **Download For Windows Server** option and run through the setup to install Edge. Once installed, pin Edge to the task bar.

## Step 2. Download, install Microsoft Entra Cloud Sync

1. Whilst still connected to the DC VM via Azure Bastion.
1. Go to <https://entra.microsoft.com> and login with the Global Admin account.
1. Click **Azure Active Directory** and in the left pane under **Manage** click **Azure AD Connect**.
1. In the middle pane click the **Manage Azure AD cloud sync** link.

   ![MISSING ALT TEXT](img/cloudsync.003.png)

1. In the new page that opens click the **Download agent** link and accept the Terms of Service.

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.004.png)

1. This will download a file called [AADConnectProvisioningAgentSetup](https://learn.microsoft.com/azure/active-directory/cloud-sync/how-to-install).exe to the Downloads folder. Open the file to start the setup, check the licence box, and click **Install**.

1. This will spawn the agent configuration wizard, click **Next** on the welcome screen.

   ![MISSING ALT TEXT](img/cloudsync.005.png)

1. On the **Connect Azure AD** screen, authenticate to the tenant using the Global Admin credentials. 

   ![MISSING ALT TEXT](img/cloudsync.006.png)

1. On the **Configure Service Account** screen leave the radio button on **Create gMSA** and then enter in the On-Premises AD administrator credentials and then click **Next**.

   ![MISSING ALT TEXT](img/cloudsync.007.png)

1. On the **Connect Active Directory** screen the ADDS domain should automatically appear under **Configured Domains**. Click **Next**.

   ![MISSING ALT TEXT](img/cloudsync.008.png)

1. On the **Agent configuration** screen review the settings and click **Confirm** to complete the installation.

   ![MISSING ALT TEXT](img/cloudsync.009.png)

1. Once the installation has finished successfully go back to the AAD portal and under **Azure Active Directory > Azure AD Connect > Manage Cloud Sync >** **Azure AD Connect Cloud Sync** click **Review all agents.** The new agent will be showing as active.

   ![MISSING ALT TEXT](img/cloudsync.010.png)

   ![Graphical user interface, application Description automatically generated](img/cloudsync.011.png)

## Step 3. Configure Azure AD Connect Cloud Sync

Now that the agent has been successfully installed, provisioning settings will now be configured. Unlike Microsoft Entra Connect, all configuration settings for Cloud Sync are performed from within the Microsoft Entra admin center. 

1. From <https://entra.microsoft.com> navigated to **Azure Active Directory > Azure AD Connect** and select **Manage Cloud Sync.**

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.012.png)

1. Select the **New configuration** option

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.013.png)

1. On the configuration screen, select the domain and tick **Enable password hash sync**. Click **Create**.

   ![Graphical user interface, text, application, email Description automatically generated](img/cloudsync.014.png)

1. On the next screen, **Edit cloud sync configuration**, leave all the settings as default and then move the selector at the bottom to **Enable** then click **Save**.

   ![Graphical user interface, text, application, email Description automatically generated](img/cloudsync.015.png)

1. Once the configuration has been saved successfully click out of the configuration screen to return to the Azure AD Connect Cloud dashboard, verify the status shows as healthy.

   ![MISSING ALT TEXT](img/cloudsync.016.png)

## Step 4. Create a new On-Premises Active Directory user

To validate that Cloud Sync is working we will now create a user in the On-Premises Active Directory and synchronize that user to your Microsoft Entra ID tenant.

1. Connect to the DC VM via Azure Bastion.

1. Go to **Start/Run** and type DSA.msc and hit enter. This will open the **Active Directory Users and Computers** snap-in. 
1. Expand the domain object and then right click on the **Users** organizational unit object and select **New** → **User.**

   ![Graphical user interface, application Description automatically generated](img/cloudsync.017.png)

1. Fill in the **New Object – User** wizard with the following details:

   - **First Name:** Bobby
   - **Last Name:** Smith
   - **Full Name:** Bobby Smith
   - **User logon name:** Bobby

**Note:** The users UPN suffix will be the internal AD Domain (i.e. @domain.local), but as this is not a verified domain in the tenant the sync processes will drop this UPN in Microsoft Entra ID and instead give the user a UPN of @__tenantname__.onmicrosoft.com. This is expected and adequate for our lab use requirements to keep things as simple as possible.

   ![Graphical user interface, text, application, email Description automatically generated](img/cloudsync.018.png)

1. Specify a password and ensure to uncheck the **User must change password at next logon** field and click **Next** to finish creating the user.

   ![Graphical user interface, text, application, email Description automatically generated](img/cloudsync.019.png)

## Step 5. Validate Cloud Sync provisioning 

Cloud provisioning is scheduled to run every 2 mins. Any additions or changes to users, groups, and passwords will be sync’d to Microsoft Entra ID in that scheduled window.

1. To validate that your new user, Bobby Smith, was successfully provisioned into your tenant go to <https://entra.microsoft.com> and click the **Users** icon in the left-hand pane. 

1. In the right-hand blade look under **All users** and you should be able to see the new Bobby Smith user, and where the **On-premises Sync enabled** field will say **Yes**, denoting the Source of Authority for this object is the on-premises Active Directory.

   ![Graphical user interface, application Description automatically generated](img/cloudsync.020.png)

   ***Note*** how the on-premises UPN has been replaced with the tenant@onmicrosoft.com domain.

1. To validate Cloud Sync is working check the provisioning logs. To do this, go to **Azure AD Connect > Manage Azure AD Cloud Sync** and then click the three dots to the far right of the Configuration section which will expose a **View Provisioning Logs** drop down option.

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.021.png)

   ![Graphical user interface, text, application, email Description automatically generated](img/cloudsync.022.png)

## Step 6. Assign a license to Bobby Smith

1. In the **All users** blade click on Bobby Smith to go into the users properties page and then click the **Edit properties** link at the top, then click the **Settings** link and set the **Usage Location** to a desired location of your choice and hit **Save**.

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.023.png)
 
1. Back on the users properties page for Bobby Smith, click on **Licences** in the bottom left pane, then click on the **+ Assignments** button and then select the **Microsoft 365 E5 Developer** license and then click **Save** at the bottom of the page.

## Step 7. Test signing in with your new user

1. Open a new InPrivate Edge session and browse to <https://outlook.office.com>

1. Sign-in with the new user account (Bobby) that was created in the tenant. 
   **Note:** You will need to sign-in using a combination of the tenant provided UPN (bobby@domain.onmicrosoft.com) and the users on-premises password that was sync’d to the tenant via Cloud Sync.
1. Successfully signing in will land you into Bobby’s new (empty) mailbox.

   ![Graphical user interface, text, application Description automatically generated](img/cloudsync.024.png)

## Step 8. Enable cloud sync self-service password reset writeback

The last step of this lab involves one final configuration piece for Cloud Sync, which is to enable writeback for SSPR. 

[Self-service password reset (SSPR)](https://learn.microsoft.com/azure/active-directory/authentication/concept-sspr-howitworks) writeback provides a secure way to send password changes in the cloud back to an on-premises directory and this is something we will be exploring in a later lab but it’s easier to toggle this setting on now whilst we are already on the DC. 

**Note:** Microsoft Entra now enforces a TLS 1.2 connection when connecting to the tenant via PowerShell, we need to enable TLS 1.2 on the DC VM so Microsoft Entra can communicate back to the Cloud Sync agent correctly when writing passwords back.

1. On the DC VM, open a PowerShell windows as an administrator and then copy and paste this [PowerShell script to enable TLS 1.2](https://learn.microsoft.com/azure/active-directory/hybrid/reference-connect-tls-enforcement#powershell-script-to-enable-tls-12) code into the session and then hit Enter to execute it. Once the script has executed successfully restart your DC VM to make the change effective.

   ![Graphical user interface, application Description automatically generated](img/cloudsync.025.png)

1. Once your DC VM has rebooted, log back in and open a PowerShell window again and copy and paste in the following code to enable password writeback.

   ```
   Import-Module 'C:\\Program Files\\Microsoft Azure AD Connect Provisioning Agent\\Microsoft.CloudSync.Powershell.dll'
   Set-AADCloudSyncPasswordWritebackConfiguration -Enable $true -Credential $(Get-Credential)
   ```

1. This will spawn a credential request window. Enter the Global Admin credentials for the tenant here.

   ![MISSING ALT TEXT](img/cloudsync.026.png)

1. Once successfully authenticated you should receive this output response indicating that enabling SSPR writeback was successful.

   ![MISSING ALT TEXT](img/cloudsync.027.png)

Congratulations, you have now successfully set up a hybrid identity environment that forms the foundation of the remaining hybrid portions of this lab guide.
