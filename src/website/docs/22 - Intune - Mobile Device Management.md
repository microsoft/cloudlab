---
id: intmdm
title: Mobile Device Management with Intune 
sidebar_label: Mobile Device Management
slug: /intmdm
---

Device enrolment secures the device so that it aligns with your organization's policies. Intune deploys and enforces policies through a management profile, which is installed on the device during the enrolment process. You can set up user-initiated enrolment for people who want to use their personal devices at work and users initiate enrolment by signing into the Company Portal app with their work or school account.

From a zero trust perspective, device management with Intune allows you to build Conditional Access policies around the concept of device trust where your organization can then enforce device compliance before allowing the device to connect to applications. This is done via the “Require device to be marked as compliant” Grant control in Conditional Access.

## Lab success exit criteria.

This lab is a continuation of the Intune App Protection policy lab where you allowed unmanaged devices to used approved apps that were protected by Intune. Using the same device, we will now take this from unmanaged to managed via enrolment into Intune MDM.

You will do this by creating an Android device compliance policy in Intune that will set the conditions that a device must first meet to be considered compliant. You will then create an Microsoft Entra Conditional Access policy that requires devices to enrol in Intune and comply with the Intune policies to use the approved Outlook mobile app to access Exchange Online.

## Step 1. Enable Android enrolment.

Before Android devices can enrol into Intune you need to enable an enrolment prerequisite. There are a few choices here depending on the specific customer requirements, but for the purposes of this lab we are going to choose the easiest option called Android Device Administrator. 

1. Sign into the Intune portal <https://endpoint.microsoft.com>
1. Select **Devices > Android > Android enrolment.**
1. Scroll to the bottom of the page and click the **prerequisites** tile under **Android device administrator** option.

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.001.png)

1. Under the **Personal and corporate-owned devices with device administrator privileges** page check the box next to **Use device administer to manage devices** and click **Ok.**

   ![A picture containing text Description automatically generated](img/intmdm.002.png)

## Step 2. Create an Android device compliance policy.

1. Still in the Intune portal <https://endpoint.microsoft.com>
1. Select **Devices > Compliance policies > + Create policy.** 
1. In the **Create a policy** pane select the following options:
   - **Platform:** Android device administrator
   - **Profile type:** Android compliance policy (this should be greyed out)

   ![Graphical user interface, application Description automatically generated](img/intmdm.003.png)

1. Click **Create.**

1. On the **Basics** page, add the following value: 
   - **Name:** Android Device Compliance Policy

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.004.png)

1. Click **Next** to display the **Compliance settings** page. Expand the **Device Health** section and set the following:

   - **Rooted devices:** Block

   ![Graphical user interface, website Description automatically generated](img/intmdm.005.png)

1. Click **Next** to display the **Actions for noncompliance** page. 
   Under the **Action** column for **Mark device noncompliant** select the **Send push notification** option.

   ![Graphical user interface, text, application, email Description automatically generated](img/intmdm.006.png)

1. Click **Next** to display the **Assignments** page. Under **Included groups** click **Add all users**.

   ![Graphical user interface, text, application, chat or text message Description automatically generated](img/intmdm.007.png)


1. Click **Next** to go to the **Review + create** page and then click the **Create** button to finish creating the policy.

## Step 2. Create a device based Conditional Access policy.

1. In the Microsoft Entra admin center select **Security > Conditional Access > + New policy.**
1. For the **Name**, prefix the name of the policy with the recommended naming framework we used in previous labs (i.e., *“CA012: Android Device Compliance Policy For Email”*).
1. Under **Assignments**, select **Users and groups**. On the **Include** tab, select **All users**.
1. Under **Cloud apps or actions**. Because we want to protect Microsoft 365 Exchange Online email, we'll select it by following these steps:
   - On the **Include** tab, choose **Select apps**. Choose **Select**.
   -  In the applications list, select **Office 365 Exchange Online**, and then choose **Select**.
1. Under **Conditions** > **Device platforms**.
   - Under **Configure**, select **Yes**.
   - On the **Include** tab, choose **Select device platforms**, and tick **Android**.
   - Select **Done**.
1. Under **Conditions** > **Client apps**.
   - Under **Configure**, select **Yes**.
   - For this lab, select **Mobile apps and desktop clients** (which refers to apps like Outlook for iOS and Outlook for Android). Clear all other check boxes.
   - Select **Done**.

1. Under **Access controls**, select **Grant**.
   - On the **Grant** pane, select **Grant access**.
   - Select **Require device to be marked as compliant**.
   - Select **Require approved client app**.
   - Under **For multiple controls**, select **Require all the selected controls**. This setting ensures that both requirements you selected are enforced when a device tries to access email.
   - Choose **Select**.
1. Under **Enable policy**, select **On**. Click **Create**.

## Step 3. Testing the device compliance policy.

With these policies created any Android device that now attempts to sign in to Exchange Online will first need to enrol into Intune and then use the Outlook mobile app. 

1. Start the Android device emulator that we created in the previous App Protection lab. 
1. Open the Outlook app and you should be asked to sign-in. After authenticating you should be presented with a message that tells you that you need to setup your device to get access.

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.008.png)

1. Click **Continue**. This will take you through the process of enrolling your device and will inform you that you need to install the Intune Company Portal app. As we already have this app installed from the previous lab, we can just launch the Intune Company Portal app to begin the process.

1. Click the Sign In option and authenticate as your test user that you have been using on the device.

   ![MISSING ALT TEXT](img/intmdm.009.png)

1. Once in the app click the **Devices** tab and click on the exclamation mark next to your “My Android” device object to begin enrolment.

   ![MISSING ALT TEXT](img/intmdm.010.png)

1. On the next screen click on the **This device is not managed** option.

   ![Graphical user interface, application Description automatically generated](img/intmdm.011.png)

1. On the next screen click on the **Begin** button at the bottom.

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.012.png)

1. Click through the next few screens until you reach the **Activate this device admin app** option and click on the **Activate this device admin app**.

   ![MISSING ALT TEXT](img/intmdm.013.png)

1. This will complete the Device Registration process and push the management profile to the device.

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.014.png)

1. You should now see the Android device appear in the Intune portal under **Devices > Android > Android Devices** and where it’s compliance state should show as “Compliant”.

   ![Graphical user interface, text, application, email Description automatically generated](img/intmdm.015.png)

1. Back on the emulator, switch back to the Outlook app and you should now have access to email once again.

1. Given the device is now controlled by Intune, you can explore some of the MDM capabilities such as Remote Lock, or wiping a device.
1. In the Intune portal select **Devices** > **All devices**.
1. In the list of devices, select the Android device, and then select the **Remote lock** action.

   ![Graphical user interface, text, application Description automatically generated](img/intmdm.016.png)
