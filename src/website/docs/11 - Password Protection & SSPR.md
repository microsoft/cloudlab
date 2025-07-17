---
id: pswdprotect
title: Deploy and manage password protection 
sidebar_label: Password Protection
slug: /pswdprotect
---

Users often create passwords that leverage common words or phrases that are generally aligned to their workplace, sports team, celebrity, or season/year. These passwords are easy to guess and susceptible to brute force and password spray attacks. To enforce strong passwords in your organization, Microsoft Entra Password Protection provides a global and custom banned password list. A password change request fails if there's a match found in the banned passwords list.

   ![MISSING ALT TEXT](img/pswdprotect.001.png)

# Lab success exit criteria

At the end of this lab, you will have enabled self-service password reset, deployed the Microsoft Entra password protection agents to your on-premises AD environment, and configured a custom banned password list that contains words that users will be prevented from using during a password change/reset event.

## Step 1. Enable self-service password reset.

1. In the Azure Active Directory portal, click on **Password reset** in the left-hand menu.
1. From the **Properties** page, under the option ***Self service password reset enabled***, choose **All** and then select **Save**.

   ![Graphical user interface, application, Teams Description automatically generated](img/pswdprotect.002.png)**

## Step 2. Select authentication methods and registration options

Before users can reset a password, they must first register their required authentication methods which are then used to provide an extra layer of security during SSPR and account unlock activities. As MFA/SSPR combined registration is now on by default for new tenants, any users registered for MFA with the Authenticator App can use SSPR without any further steps required.

1. Whilst still in the **Password reset** blade, select **Authentication methods** from the left and set the **Number of methods required to reset** to 1. 
1. Under **Methods available to users** select **Mobile app code** and hit **Save**.

   ![MISSING ALT TEXT](img/pswdprotect.003.png)

## Step 3. Deploy the password protection agents (Hybrid Lab Only)

If you chose the Cloud Only lab then you can skip this step and proceed straight to [Step 4](#_step_4._enable).

Two installers are required for an on-premises Microsoft Entra Password Protection deployment:

- Microsoft Entra Password Protection DC agent ``AzureADPasswordProtectionDCAgentSetup.msi``
- Microsoft Entra Password Protection proxy ``AzureADPasswordProtectionProxySetup.exe``

**Note:** It is not supported to install these two agents on the same machine as doing so can prevent the agent updater service from contacting Azure for future software updates. For the purposes of this lab however we are going to install both agents on the same machine (as we only have 1 VM), and whist not recommended, it will allow us to test the feature out.

1. Log into your DC VM using Azure Bastion from <https://portal.azure.com>
1. On the DC, navigate to <https://www.microsoft.com/en-us/download/details.aspx?id=57071> and download the two password protection agents.
1. The Microsoft Entra Password Protection DC agent needs to be installed first, to do this run the ***AzureADPasswordProtectionDCAgentSetup.msi*** package. There is no input required during the installation of this agent. 

   **Note:** After the installation a reboot is required because the password filter dlls are only loaded or unloaded by a restart.

1. Reboot.
1. Log back into your DC VM after it has restarted and install the Microsoft Entra Password Protection Proxy agent by running the ***AzureADPasswordProtectionProxySetup.exe*** software installer. You ***do not*** need to reboot after installing the proxy agent.
1. The proxy service is now running on the machine, but it does not yet have any credentials to communicate with Microsoft Entra ID. To configure this, you need to register the Microsoft Entra Password Protection proxy agent with your tenant using PowerShell:

   ```
   Import-Module AzureADPasswordProtection
   Register-AzureADPasswordProtectionProxy -AccountUpn yourGA@tenant.onmicrosoft.com
   Register-AzureADPasswordProtectionForest -AccountUpn yourGA@tenant.onmicrosoft.com
   ```

## <a name="_step_4._enable"></a>Step 4. Enable password protection and configure the banned password list

1. In the Microsoft Entra admin center browse to **Azure Active Directory** > **Security** > **Authentication methods** > **Password protection**.

1. Under **Custom banned passwords** set the **Enforce custom list** to *Yes*.
1. Under **Custom banned password** **list** add the word *Unicorn*.
1. Verify that the option for **Enable password protection on Windows Server Active Directory** is set to *Yes*.
1. Set the **Mode** to *Enforced* and click **Save**

   ![Graphical user interface, application Description automatically generated](img/pswdprotect.004.png)

## Step 5. Testing the custom banned password list

If you chose the **Cloud Only** option of this lab guide then you can use any user in your tenant to perform the banned password test with. For the **Hybrid Identity** option you will want to be testing with an on-premises user, in which case I recommend using the previous user we created – **Bobby Smith**. The following steps align to using that specific user.

**Note:** It can take several hours for updates to the custom banned password list to be applied so if the steps below don’t work initially then try again at a later stage.

1. Open a new InPrivate Edge session and navigate to <https://myaccount.microsoft.com> and log in as Bobby Smith.
1. You’ll be prompted to register for MFA (due to the Conditional Access policies we created previously), so complete the registration and then continue the sign-in. This step will also register the Auth App for SSPR use.
1. In the **My Account** portal click the **Change Password** link in Password tile.
1. In the **Change Password** page enter in the current password for Bobby and then for the new password try setting it to something that contains the word Unicorn in it to trip the banned password list and then hit **Submit**. You should be prevented from changing the password and be presented with this message.

   ![MISSING ALT TEXT](img/pswdprotect.005.png)

## Step 6. Test Self-Service Password Reset with Password Writeback

Now let’s validate SSPR.

1. Browse to <https://aka.ms/sspr> and enter in the UPN for Bobby Smith
1. Complete the CAPTCHA and hit **Next**.

   ![Graphical user interface, text, application Description automatically generated](img/pswdprotect.006.png)

1. Enter in the code from the Authenticator App

   ![Graphical user interface, text, application Description automatically generated](img/pswdprotect.007.png)

1. Enter in a new password (something doesn’t trip the banned password list) and click **Finish**.

   ![Graphical user interface, text, application Description automatically generated](img/pswdprotect.008.png)

1. This just successfully reset the user’s password and wrote that new password into the on-premises Active Directory through the Password Writeback feature via the Cloud Sync agent.

## Bonus Lab

In your on-premises Active Directory you can explore Password Protection by using PowerShell to output a summary report of failed password rejections/errors/failures.

```
Import-Module AzureADPasswordProtection
Get-AzureADPasswordProtectionSummaryReport
```

   ![A picture containing text Description automatically generated](img/pswdprotect.009.png)
