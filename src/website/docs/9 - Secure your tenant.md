---
id: securetenant
title: Secure your tenant 
sidebar_label: Secure Your Tenant
slug: /securetenant
---

In the previous lab we focused on securing our privileged accounts, and we will extend and build upon that concept by using Conditional Access to provide coverage to all users by implementing a persona-based Conditional Access architecture as recommend by the [Conditional Access Framework & Policies](https://learn.microsoft.com/azure/architecture/guide/security/conditional-access-framework) guidance. This approach provides base protection for users that spans data, apps, and devices, as well as catering for various business scenarios such as securely collaborating with guests.

# Lab success exit criteria

At the completion of this lab, you will have created these six additional Conditional Access policies using the built-in Conditional Access policy templates that use these naming conventions.

``CA002: Securing security info registration``   
``CA003: Block legacy authentication``  
``CA004: Require multi-factor authentication for all users``    
``CA005: Require multi-factor authentication for guest access``  
``CA006: Require multi-factor authentication for Azure management``   
``CA008: Require password change for high-risk users`` 

These six new policies will complement our two existing policies that we created in the previous lab, being:

``CA001: Require multifactor authentication for admins``   
``CA007: Require multifactor authentication for risky sign-ins``

## Step 1. Create a trusted named network location

Before we create the remaining Conditional Access policies, we need to first create a trusted network location that users must come from to successfully register their security information (MFA & SSPR) as will be dictated by the Conditional Access policy CA002. There are various ways to do this, such as specifying a public IP (or range), or by country. Here will we be using a public IP range derived from your own public IP. To find your current public IP address use <https://myip.com> and write it down.

1. Click **Azure Active Directory > Security > Conditional Access**.
1. Under **Named locations** select **+ IP ranges location** and in the **New location (IP ranges)** menu on the right provide these details:   
   - **Name:** Corp Network  
   - Check the box for **Mark as trusted location**  
   - Click the **+** and under **Enter a new IPv4…** add your IP range.
   (e.g. If your IP address was 119.18.0.166 add the range 119.18.0.166/30)   
1. Click **Add** and then click **Create**.

   ![MISSING ALT TEXT](img/securetenant.001.png)

## Step 2. Create the Conditional Access policies

1. Click **Azure Active Directory > Security > Conditional Access**.
1. In the **Conditional Access – Policies** pane, select **+ New policy from template (Preview).**
1. Under **Customize your build** select **Identities** and click **Next.**
1. Under **Select template** choose the **Securing security info registration** template, leave the policy name as is, and put the **Policy state** to **On** then click **Next**.
1. Under **Review + Create** click **Create Policy**.

Repeat steps **1-5** to create the other five Conditional Access policies using the templates as numbered below.

   ![MISSING ALT TEXT](img/securetenant.002.png)

Verify that you now have all 8 Conditional Access policies present in your tenant and all are in an **ON** state.

   ![Graphical user interface, text, application, email Description automatically generated](img/securetenant.003.png)

**Important!** If you have a Hybrid environment setup you will need to make an adjustment to the policy “**CA004: Require multifactor authentication** **for all users”** by excluding the Cloud Sync account from this policy. This account is called “On-Premises Directory Synchronization Service Account”. If you do not exclude this account Cloud Sync will stop functioning.

   ![MISSING ALT TEXT](img/securetenant.004.png)

## Step 3. Testing the “CA002: Securing security info registration” policy

The purpose of this policy is to protect the MFA & SSPR registration process by only allowing users to proof-up and register a method for the first time when coming from a trusted location. If you are already registered for MFA then this policy allows access to the <https://aka.ms/mysecurityinfo> portal (to update or change a method) from outside of the trusted network, but MFA is required. To invoke this policy, you need to be coming from an IP not within the range that we defined as the *trusted network* in Step 1. This can be achieved in a few of the following ways.

- If you are on your Microsoft corporate device, simply activate the VPN before testing.
- Perform the test from an Azure based VM
- Install the Opera browser and use it’s built in VPN capability

Once you have chosen your method to change the IP that you are appearing to come from (as Microsoft Entra ID sees it), perform the following steps.

1. Create a new user or choose an existing user that has not registered for MFA yet.
1. Open an In-Private Edge session and navigate to <https://aka.ms/mysecurityinfo>
1. Login, and after authenticating successfully you should be presented with a “More information required” message which is the proof-up process kicking in to register for MFA, click **Next**. You should be blocked from being able to “proof-up” at this point and presented with this message that states, “Your organization requires this information to be set from specific locations or devices.”

   ![MISSING ALT TEXT](img/securetenant.005.png)

1. Now repeat steps 1-3, but this time ensure you are now coming from your trusted IP range (i.e. turn off your VPN). The proof-up process should be successful this time allowing you into the portal to register for MFA.


## Step 4. Testing the “CA003: Block legacy authentication” policy
Using the Microsoft Remote Connectivity Analyzer we will simulate an Exchange ActiveSync client that uses basic authentication in order to verify the Conditional Access policy that blocks legacy authentication is working.

1. Navigate to <https://testconnectivity.microsoft.com/tests/o365> and select the “Exchange ActiveSync test.

   ![Graphical user interface, text, application, email Description automatically generated](img/securetenant.006.png)

1. On the next screen fill in the required details for the user in your tenant that is licensed for Exchange (these would have been created for you via the User sample pack, but if not create and license a new user or just use your existing Global Admin account) and ensure to leave the radio button on **“Use Autodiscover…”** and set the **Authentication type** drop down to **Basic authentication**.

   ![Graphical user interface, text, application, email Description automatically generated](img/securetenant.007.png)

1. Complete the required **CAPTCHA** and tick the **“I understand..”** box to then perform the test.

1. The connectivity test will fail on the AutoDiscover test (as expected due to blocking legacy auth) and if we delve into the results of this test, you’ll see this mentioned in the 401 response.

   ![Graphical user interface, text, application Description automatically generated](img/securetenant.008.png)

If you also check the sign-in logs for the corresponding failed sign-in attempt you’ll see that policy **CA003: Block legacy authentication** was responsible for the block.

   ![Graphical user interface, text, application, email Description automatically generated](img/securetenant.009.png)
