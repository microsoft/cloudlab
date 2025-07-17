---
id: pim
title: Protect Your Global Admins & Enforce Least Privileged With PIM
sidebar_label: Enforce Least Privilege with PIM
slug: /pim
---

In this lab we will begin the process of securing the tenant beginning with members of the highly privileged [Global administrator role.](https://learn.microsoft.com/azure/active-directory/roles/permissions-reference) The first step in protecting accounts that are members of this role is to enable MFA via Conditional Access, and then use [Privileged Identity Management](https://learn.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure#:~:text=Privileged%20Identity%20Management%20\(PIM\)%20is,Microsoft%20365%20or%20Microsoft%20Intune.) (PIM) to provide [Just-In-Time](https://learn.microsoft.com/azure/azure-resource-manager/managed-applications/approve-just-in-time-access) (JIT) elevation into this powerful role.

# Lab success exit criteria

By the end of this lab, you will have created a new baseline MFA Conditional Access policy that targets any user that holds the Global Administrator role, and which challenges for MFA at sign-in across all apps, no exceptions. Lastly, you will configure PIM, and then create a new account to test requesting access to the Global Administrator role via the PIM JIT elevation workflow.

## Step 1. Turn off Security Defaults

[Security Defaults](https://learn.microsoft.com/azure/active-directory/fundamentals/concept-fundamentals-security-defaults) provide baseline protection for a tenant out of the box (require MFA for all users, block legacy auth) but its functionality is superseded by Conditional Access with the ownership of Microsoft Entra ID P1 licenses. We will now turn this off.

1. Sign-in to <https://entra.microsoft.com>
1. Go to **Azure Active Directory > Properties** and select **Manage security defaults**.
1. Set the **Enable security defaults** toggle to **No** and hit **Save**.

   ![Graphical user interface, application Description automatically generated](img/pim.001.png)

## Step 2.  Create a new user to be used for permanent Global Admin purposes

This user will have permanent standing membership to the Global administrator role.

1. In the Azure Active Directory dashboard click **Users** in the left pane.
1. Click **+ New user** and choose the **Create a new user** option.
1. In the **New user** pane, enter **DedicatedAdmin** in the **User name**, **Name**, & **First name** boxes.
1. Under **Password**, select **Let me create the password**, and then enter a strong password. ***Note:*** You will be asked to change this password the first time you login with this account.
1. Under **Groups and roles** click on the **User** link to the right of **Roles** to bring up the Directory roles blade and then find and select the **Global administrator** role and then hit **Select** at the bottom of the page to assign this role to the user.
1. Under **Settings**, set the appropriate **Usage Location** relevant to you.
1. Click **Create** at the bottom of the page to finish creating the new user.
1. Back on the **Users** page, find and click on the new **DedicatedAdmin** user to go into the properties of the user object.
1. Click on **Licences** in the left pane and then click on the **+ Assignments** button and then select the **Microsoft 365 E5 Developer** license and then click **Save** at the bottom of the page.
1. The final setup is to now login as this new user, change the password, and register for MFA. Open a new InPrivate Edge session and browse to <https://aka.ms/mfasetup> to complete the MFA registration process using the Authenticator App.

## Step 3. Create a new user to be used for temporary Global Admin purposes

This user will ***not*** have permanent membership to the Global administrator role, and instead will request access via PIM to just-in-time into the role.

1. In the Azure Active Directory dashboard click **Users.**
1. Click **+ New user** and choose the **Create a new user** option.
1. In the **New user** pane, enter **TemporaryAdmin** in the **User name**, **Name**, & **First name** boxes.
1. Under **Password**, select **Let me create the password**, and then enter a strong password. 
1. Under **Groups and roles** ensure to leave **Roles** set to **User.**
1. Under **Settings**, set the appropriate **Usage Location** relevant to you.
1. Click **Create** at the bottom of the page.
1. Now assign a **Microsoft 365 E5 Developer** license to this new user as well.
1. Login, change the password, and register for MFA using an InPrivate Edge session via <https://aka.ms/mfasetup> for this new user as well.

To recap, at this point you now have these two new users that we will begin testing with.    

***DedicatedAdmin*** (Is a member of the Global Administrator role)    
***TemporaryAdmin*** (Is not a member of any privileged roles)

## Step 4. Create the Conditional Access policies

#### We will now create two new Conditional Access policies that will:

***Require MFA for accounts that hold membership to privileged admin directory roles.***    
***Require MFA if the sign-in risk is determined to be medium or high.***

Conditional Access policies can become very detailed and cumbersome to manage overtime, so to continue with the ***keeping it simple*** mantra of this lab guide we will be using the new [Conditional Access Templates](https://learn.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policy-common#conditional-access-templates-preview) feature that provide a convenient way to deploy new Conditional Access policies aligned with Microsoft recommendations and naming policies, and which are designed to provide maximum protection for the tenant.

1. Click **Azure Active Directory > Security > Conditional Access**.
1. In the **Conditional Access – Policies** pane, select **+ New policy from template (Preview).**
1. Under **Customize your build** select **Identities** and click **Next.**
1. Under **Select template** choose the **Require multifactor authentication for admins.** template, leave the policy name as is, and put the **Policy state** to **On** then click **Next**.
   *Note how your current Global admin account is automatically excluded from this policy in order to avoid a potential lockout issue.*
1. Under **Review + Create** click **Create Policy**.
1. Back on the **Conditional Access – Policies** pane, select **+ New policy from template (Preview)** again.
1. Under **Customize your build** select **Identities** and click **Next.**
1. Under **Select template** choose the **Require multifactor authentication for risky sign-ins** template, leave the policy name as is, and put the **Policy state** to **On** then click **Next**.
1. Under **Review + Create** click **Create Policy**.

You should now have these two Conditional Access policies in your tenant prefixed with ***CA001*** & ***CA007***.

   ![Graphical user interface, text, application, chat or text message Description automatically generated](img/pim.002.png)

## Step 5. Testing the Conditional Access policies

To test the first MFA policy, **CA001: Require multifactor authentication for admins**

1. Open a new InPrivate Edge session.
1. Browse <https://portal.azure.com> (or any portal of your choice)
1. Sign in with the **DedicatedAdmin** account.  **Result →** You should be prompted for MFA.  
1. Open a new InPrivate Edge session. 
1. Browse <https://portal.azure.com> (or any portal of your choice)
1. This time sign in with the **TemporaryAdmin** account. 
   **Result →**  You should ***not*** be prompted for MFA as this user is not a member of any privileged directory roles that are targeted by the CA001 policy

This is also a good opportunity to explore the **Conditional Access > Sign-in Logs** where you can look at the sign-ins for these two accounts and view the **Conditional Access** tab to see which policies are applying.

   ![MISSING ALT TEXT](img/pim.003.png)

Testing the sign-in risk policy **CA007: Require multifactor authentication for risky sign-ins** is a little more difficult as you’ll need to use a TOR browser to trigger the Anonymous IP detection in ID Protection which is detailed here [Simulating risk detections in Microsoft Entra ID Protection](https://learn.microsoft.com/azure/active-directory/identity-protection/howto-identity-protection-simulate-risk). 

An alternative approach is to use the Conditional Access [What If](https://learn.microsoft.com/azure/active-directory/conditional-access/troubleshoot-conditional-access-what-if) tool that can be found in the Conditional Access dashboard. The ***What If*** tool allows you to specify a user and designate a Sign-in risk level and the output will show you what policies would have been triggered and applied.

   ![MISSING ALT TEXT](img/pim.004.png)

   ![MISSING ALT TEXT](img/pim.005.png)

## Step 6. Configure Privileged Identity Management

Rather than having privileged accounts permanently assigned the Global administrator role, it is recommended to use PIM to enable on-demand, JIT assignment of the role when it's needed. To gain access to the role complete an activation workflow to add the account to the administrator role for a predetermined amount of time. When the time expires, PIM removes the account from the role.

In this lab we will be using the **TemporaryAdmin** account. We will assign this account as ***“Eligible”*** to the Global administrator role and configure PIM to require approval ***and*** MFA to be completed before this account can activate into the role.

To configure PIM in the tenant:

1. In the Microsoft Entra admin center go to **All Services** in the top left-hand navigation pane.
1. In the right-hand pane click on **Azure AD Privileged Identity Management**.
1. In the PIM dashboard left-hand pane under **Manage** click **Azure AD roles**.
1. In the right-hand pane click the **Assign Eligibility button**.
1. Find and select the **Global administrator role**.
1. Click the **+ Add assignments** button at the top of the page
1. On the **Membership** page add the TemporaryAdmin account as a member and hit **Next.**
1. On the **Setting** page set **Assignment type** as **Eligible** and leave **Permanently eligible** checked and then click **Assign.**
1. Click on **Role settings** in the left pane to see the Activation requirements and notice that:

    *Activation maximum duration (hours)* – *8 hours*    
    *Require justification on activation* – *Yes*    
    *On activation, require Azure MFA* – *Yes*

## Step 7. Activate the role via Privileged Identity Management

Sign in in using the TemporaryAdmin account and activate the new role assignment.

1. Open a new InPrivate Edge session and browse <https://entra.microsoft.com>.
1. Sign in with the **TemporaryAdmin** account.
1. In the Microsoft Entra admin center go to **All Services** in the top left-hand navigation pane.
1. In the right-hand pane click on **Azure AD Privileged Identity Management**.
1. In the PIM dashboard left-hand pane under **Tasks** click **My roles**.
1. Under **Eligible assignments** you should see the Global Administrator role listed with an option to Activate the role. Click **Activate**.

   ![Graphical user interface, text, application, email Description automatically generated](img/pim.006.png)

1. You will be prompted to provide additional verification (MFA), click continue.

   ![MISSING ALT TEXT](img/pim.007.png)

1. Once you successfully complete MFA you will then need to provide a reason for the activation in the text box and then click **Activate**

   ![Graphical user interface, text, application Description automatically generated](img/pim.008.png)

   ![Graphical user interface, text, application, email Description automatically generated](img/pim.009.png)

1. Once the page refreshes automatically you’ll receive a banner message stating that **Your roles have changed** and if you click the Active assignments tab you will see the Global Administrator role state shows as **Activated.** 

   ![Graphical user interface, text, application Description automatically generated](img/pim.010.png)

   ![Graphical user interface, text, application, email Description automatically generated](img/pim.011.png)

You now have full privileged access to the tenant that is time bound for 8 hours.
