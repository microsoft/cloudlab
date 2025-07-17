---
id: goventmgmt
title: Onboard external users to Microsoft Entra with Entitlement Management
sidebar_label: Entitlement Management
slug: /goventmgmt
---

Entitlement management is an Identity Governance feature that enables the automation and management of the identity and access lifecycle through access request workflows, access assignments, reviews, and expiration. Entitlement management uses the concept of an access package which is a bundle of all the resources with the required access a user needs to work on a project or perform their tasks. Access packages are used to govern access for both your internal employees, and also those external (B2B) users outside your organization.

## Lab success exit criteria.

This lab will involve inviting an external user into your tenant for collaboration. The external user will be your own Microsoft FTE account (<you@microsoft.com>). You will start by creating a new Team, and then using an access package you will onboard this external user and grant them access to the Team, and where approval will be needed by an internal sponsor to complete the onboarding flow. You’ll also be using the MyAccess portal (<https://myaccess.microsoft.com>) to experience the end user request & approval process.

## Step 1. Create a new team used for partner collaboration.

1. Sign-in to <https://admin.teams.microsoft.com> using your Global Admin.
1. In the left menu brows to **Teams** > **Manage teams.**
1. Click the **+ Add** button to create a new team.
1. In the **Add a new team** fly-out window fill in the following details:
   - **Name:** Partner Collaboration
   - **Description:** Team for working with external partners
   - **Team owners:** Leave yourself (Global Admin) which should already be added
   - **Privacy:** Private
1. Click **Apply** to create the team.

## Step 2. Create the access package.

1. Sign-in to the Microsoft Entra admin center as your Global Admin <https://entra.microsoft.com>
1. In the left menu browse to **Identity Governance** and then click **Access packages**.
1. Click + **New access package**.
1. On the **Basics** tab fill in the following details:

   - **Name:** Partner Access
   - **Description:** Access for external partners pending approval.
   - **Catalog:** Leave this set to General.

1. Click **Next: Resources roles**
1. On the **Resource roles** tab. 
   - Click on + **Groups and Teams**
   - In the **Select groups** right-hand menu check the box next to **See all Group and Team(s) not in the ‘General’ catalog** and then find the *Partner Collaboration* team that you created in Step 1 and then click the **Select** button to add it to the access package.
   - Once added, go to the **Role** column and select **Member** from the drop-down list.

   ![MISSING ALT TEXT](img/goventmgmt.001.png)

1. Click **Next: Requests**
1. On the **Requests** tab.
   - In the **Users who can request access** section, click **For users not in your directory** and then click **All users (All connected organizations + any new external users)**.
   - Set **Enable new requests** to **Yes.** 
   - For **Require requestor justification**, leave this as **Yes**.
   - For **How many stages** leave this as **1**.
   - For **Approver** scenario select **Choose specific approvers** and click **+ Add approvers** and then add yourself (the Global Admin).
   - For **Decision must be made in how many days?** leave this as **14.**
   - For **Require approver justification** leave this as **Yes**.
   - Set **Enable new requests** to **Yes** to enable this access package to be requested as soon as it's created.

1. Click **Next: Requestor Information**
   - Here you can ask additional questions to collect more information from your requestor. These questions are shown on their request form and can be set to required or optional. For now you can leave these as empty.

1. Click **Next: Lifecycle**
   - In the **Expiration** section, set **Access package assignment expire** to **Number of days**.
   - Set **Assignment expire after** to **30** days. This field determines when your guest users will have to renew their access.
   - Leave **Require access reviews** to **No**.

1. Click **Review + Create,** review the configuration, and then click **Create**.
1. Once created, you’ll be brought back to the **Overview** page for your access package.    
Find the **My Access portal link** on this page and then copy the value. We will now use this link to request access to this package to start collaborating.

   ![Graphical user interface, text, application Description automatically generated](img/goventmgmt.002.png)

## Step 3. Request access to the Access Package.

1. Open an Edge session on your laptop using your own Microsoft corporate account (<you@microsoft.com>) and paste in the My Access portal link that you copied from the previous step. 
1. This will redirect you to the My Access portal of the inviting tenant where you can submit your request to the *Partner Access* package. Complete the form and then click **Request access**.

   ![Graphical user interface, text, application, email Description automatically generated](img/goventmgmt.003.png)

1. This submits the request and kicks off the approver process which now needs to be completed by the Global Admin (whom we set as the approver in Step 2.) 

## Step 4. Approve the request.
1. Go back to the Edge profile of your Global Admin and login to <https://outlook.office.com>

1. In your mailbox should be an email about the access request for your Microsoft FTE account waiting for you to approve.

   ![Graphical user interface, text, application, email Description automatically generated](img/goventmgmt.004.png)

1. Click the **Approve or deny request** link. This will take you to the My Access portal to action the request.

   ![MISSING ALT TEXT](img/goventmgmt.005.png)

1. Click the radio button next to the requestors name and then click **Approve**.

1. An **Access request** fly-out window will appear where you need to provide a reason and then click **Approve**.

   ![Graphical user interface, text, application, email Description automatically generated](img/goventmgmt.006.png)

1. This completes the request and now grants access to your Microsoft FTE account to the Partner Collaboration team/group in your test tenant.  
You should receive an email to your @microsoft.com account confirming access has been granted. 

   ![MISSING ALT TEXT](img/goventmgmt.007.png)

This process also created a Guest user in your test tenant for your Microsoft FTE account which we will now validate.

## Step 5. Check the new guest object.

1. Return to the **Microsoft Entra admin center** and navigate to the **Users** blade.
1. Here you should be able to pick out your Microsoft FTE account which will have the **User Type** set to a value of *Guest* and will be in the format of alias\_microsoft.com#EXT#.

   ![Graphical user interface, text, application Description automatically generated](img/goventmgmt.008.png)

1. Go to the **All Groups** blade and open the *Partner Collaboration group* (this was created with the Team from Step 1).
1. Click **Members** in the left-hand menu and confirm your Microsoft FTE account appears as a member of this group.

## Step 6. Testing your guest access

1. Using your Microsoft FTE account, go back to your Outlook client and open the email that you received from **Microsoft Azure** that confirmed your access was granted to the *Partner Access* team. In that email click on the **Get Started** link.
1. This will take you to <https://invitations.microsoft.com/> where you need to consent to sharing your profile data and activity with the inviting organization.

   ![MISSING ALT TEXT](img/goventmgmt.009.png)

1. Click Accept to complete the consent/redeem process.
1. You will then be presented with a **More information required** screen which will take you through registering for MFA in the test tenant as stipulated by our Conditional Access policy **CA005: Require multifactor authentication for guest access**. Complete this process using the Authenticator App.
1. After successfully registering for MFA you will land in the My Access portal where you will see the *Partner Access* package.
1. No go to your Teams client and in the top right hand corner click your profile picture to bring the drop down menu up. From here you should see the test tenant appear below the Microsoft tenant.

   ![Graphical user interface, text, application, chat or text message Description automatically generated](img/goventmgmt.010.png)

1. Click the test tenant to initiate Teams switching context to this tenant. You’ll be challenged for MFA, and once completed you’ll land in the *Partner Collaboration Team* that we created in Step 1.

   ![Graphical user interface, application Description automatically generated](img/goventmgmt.011.png)

Context switching in Teams as a Guest can be removed completely through the use of a feature called [Teams Shared Channel](https://learn.microsoft.com/MicrosoftTeams/shared-channels). This requires setting up [B2B Direct Connect](https://learn.microsoft.com/azure/active-directory/external-identities/b2b-direct-connect-overview) and [Cross-Tenant Access](https://learn.microsoft.com/azure/active-directory/external-identities/cross-tenant-access-settings-b2b-collaboration) which is beyond the scope of this guide.
