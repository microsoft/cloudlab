---
id: linkazuresub
title: Link your Azure subscription with your E5 Sandbox tenant 
sidebar_label: Azure Subscription
slug: /linkazuresub
---
# Lab success exit criteria

By the end of this lab you will have successfully linked your Visual Studio Enterprise Azure Subscription with your Microsoft 365 E5 Sandbox tenant. This step is important as it allows you to leverage specific Microsoft Entra features that are reliant on key Azure services, such as Log Analytics for workbook functionality, and Azure Sentinel, all of which will be configured in later labs. 

   ![Graphical user interface Description automatically generated with medium confidence](img/linkazuresub.001.png)

## Step 1. Add your Global Admin as Owner to your Azure subscription
To be able to link an Azure subscription to a different directory you first need to invite an account from the new target directory into the existing directory that the subscription is currently associated with, and then assign owner rights to the subscription for this invited account. This processes basically leverages the B2B Guest invitation & redemption process.

1. Sign into <https://portal.azure.com> using your personal MSA account (<you@outlook.com>) and click the Subscriptions tile.

   ![Graphical user interface, application Description automatically generated](img/linkazuresub.002.png)

1. Click on your Visual Studio Enterprise Subscription

   ![Graphical user interface, text, application, email Description automatically generated](img/linkazuresub.003.png)

1. In the left-hand navigation pane that opens click **Access Control (IAM)** and then click the **Add** button.

   ![MISSING ALT TEXT](img/linkazuresub.004.png)

   - Select **Add Role Assignment** from the drop-down list.
   - On the **Role** tab under the **Privileged administrator roles** section, select **Owner** and click **Next**. 
   - On the **Members** tab leave **Assign access to** **“User, group, or service principal”**.
   - Click the **+ Select Members** link.
   - In the new right hand side fly-out menu called **Select Members** type the email address of your global admin account from your E5 tenant (e.g. <admin@contoso.onmicrosoft.com>).
   - Click on your global admin account object that was returned from the search result.
   - Click **Select** at the bottom of the page. Click **Next**.
   - On the **Conditions** tab in the **What user can do** section, select **Allow user to assign all roles except privileged administrator roles Owner, UAA, RBAC (Recommended)**. Click **Review + assign.** 

This process invites the global admin as a Guest user into the default directory that is currently associated with your new Azure subscription. You will now need to retrieve the invitation email that was sent to your global admin to complete the redemption process.

## Step 2. Accept and redeem the invitation email

1. Switch to the Edge profile that you created previously for the global admin of your E5 tenant (or start a new in-private session) and then to navigate to <https://outlook.office.com> to access the global admins mailbox where you should see the invitation email from <invites@microsoft.com> sitting in the inbox. Click the **Accept Invitation** link at the bottom of this email.
1. You will be taken to <https://portal.azure.com> where you will need to sign-in using your global admin credentials of your E5 Sandbox tenant and then accept the permissions being requested of you which will complete the Guest invitation/redemption process, and once completed you will now have Owner permissions on the Azure subscription allowing you to change which directory the subscription can be associated with.

## Step 3. Associate the subscription with your E5 sandbox tenant

1. Whilst still logged into the Azure Portal as your E5 sandbox tenant global admin, find the **Subscriptions** tile and then click the **Visual Studio Enterprise Subscription** and** in the next screen click the **Change Directory** link at the top of the page.

   ![MISSING ALT TEXT](img/linkazuresub.005.png)

1. A **Change the directory** flyout window will open on the right-hand side where you should see your E5 Sandbox tenant listed in the drop-down menu. Select your tenant and check the “I understand” box and then click **Change** at the bottom of the window.

   ![MISSING ALT TEXT](img/linkazuresub.006.png)

After a few seconds you should receive a notification that the change was successful.

   ![MISSING ALT TEXT](img/linkazuresub.007.png) 

## Step 4. Change your default startup directory

Whilst we have now changed the directory for the subscription itself, we have one last step to complete which is to set the new directory as the default **“Startup Directory”** for your global admins account when logging into the Azure portal**.** If you don’t do this step, you’ll get a “You do not have any Azure subscriptions” notification every time you log into the Azure portal because the global admin account still defaults to the original tenant that the subscription was previously using. 

To change the startup directory, whilst still logged into the Azure portal as your E5 sandbox tenant global admin, click the account icon in the top right-hand corner and then click the **Switch Directory** link.

   ![MISSING ALT TEXT](img/linkazuresub.008.png)

Then click the Switch button that should be next to your E5 sandbox tenant.

   ![MISSING ALT TEXT](img/linkazuresub.009.png)

Congratulations, you now have your $150 USD Azure subscription linked to your non-expiring E5 sandbox tenant where you can now start building your Zero Trust lab.

**Note:** If you want to access this Azure subscription still via your @outlook.com account then you will need to repeat ***just*** steps 2 & 4 in this guide for that account (i.e. make it an owner and invite/redeem the account into the E5 tenant and then change the startup directory) but for the purposes of this lab we will only be using your global admin account from here on in to access the Azure portal/subscription in order to keep things simple.
