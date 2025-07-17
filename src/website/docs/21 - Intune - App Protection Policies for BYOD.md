---
id: intappprot
title: Intune App Protection Policies for BYO Devices
sidebar_label: App Protection Policies
slug: /intappprot
---

Intune App Protection policies (commonly referred to as “MAM” Mobile Application Management) helps protect corporate data on unmanaged devices by allowing for a bring-your-own (BYO) scenario for those users who may be reluctant to enroll their personal device into being Mobile Device Managed (MDM) by their organization. 

The distinction here is that MAM is about managing/protecting the apps and their associated data and MDM is about managing/protecting the device itself.

App Protection policies ensure corporate data in the apps you specify cannot be copied and pasted into other apps on the same device. These apps can also be protected further by requiring a PIN to access them even if the device itself is not protected by a PIN.

Intune App Protection policies are most effective when paired with an app-based Conditional Access policy that restricts the user to only being able to use approved client apps that support both modern auth and app protection policies when accessing company data.

To test out App Protection policies (and other Intune capabilities in later labs) you will need access to either an IOS or Android device. A physical device is preferred for performance reasons, but an Android emulator can be used if you do not have a spare device to test with. Unfortunately, you cannot emulate IOS. This lab will start by stepping you through setting up an Android emulator so you can use this over a physical device if required.

## Lab success exit criteria.

Using an App Protection policy in Intune you’ll limit what the user can do with the core suite of Microsoft apps by preventing "Save As" and restricting cut, copy, and paste actions between approved apps that are used for work, and personal “unmanaged” ones, and require a 4-digit pin when accessing these apps. You’ll then create a Conditional Access policy that enforces the use of the Outlook app to access company email in Exchange Online. 

## Step 1. Android Emulator Setup

Use these steps to install Android Studio and the Android Virtual Device (AVD) feature. 

1. Download Android Studio (Electric Eel) from <https://developer.android.com/studio> (915MB)
1. Run the setup and make sure that the **Android Virtual Device** component is selected.
1. Launch **‘Android Studio’** and select **Start setup**, select **Standard install**, select **UI theme**, and select **Finish** to begin component installation. Once complete, select **Finish**.
1. From the **Welcome to Android Studio** page, select **More actions** and then from the drop-down list select **Virtual Device Manager**.
1. From the **Device Manager**, select **Create Device**.
1. Select a device that has the Play Store logo in the Play Store column (e.g. the Pixel 4)

   ![Table Description automatically generated with low confidence](img/intappprot.001.png)

1. Select **Next** and then choose an Android version from the x86 Images tab. I would recommend using the latest **Tiramisu (Android 13.0)**. Select the Download link and follow the steps to install the image. Each image is approximately 1GB in size.

   ![Graphical user interface Description automatically generated with medium confidence](img/intappprot.002.png)

1. Select **Next** and give your device a descriptive name.
1. Select **Finish** to complete the AVD build.
1. Launch the virtual device you created by double-clicking or selecting the Play button.

   ![Graphical user interface Description automatically generated with medium confidence](img/intappprot.003.png)

1. If prompted by Windows Defender Firewall, choose to allow access to the ***Public networks*** option in order to provide the device with internet access.
1. Once the device has booted, you’ll need to sign-in to the Google Play store on the device using your gmail account so you can download the required apps that we will be using in subsequent steps.

## Step 2. Create an App Protection Policy

1. Sign into the Intune portal <https://endpoint.microsoft.com>

1. Select **Apps > App protection policies**.
1. Select **+ Create policy** and select either **iOS/iPadOS** or **Android** depending on the device you are using. ***Note:*** The following steps use Android as the example, but these are interchangeable if you happen to be using IOS instead.
1. In the **Create policy** pane, on the **Basics** page, add the following value:

   - **Name:** Android App Protection Policy

   ![Graphical user interface, text, application, email Description automatically generated](img/intappprot.004.png)

1. Click **Next** to display the **Apps** page and set the following:
   - **Target to apps on all device types**: No
   - **Device types:** Unmanaged
   - **Target policy to:** Core Microsoft Apps

   ![Graphical user interface, application Description automatically generated](img/intappprot.005.png)

1. Click **Next** to display the **Data Protection** page. 
   There are a lot of settings on this page that determine how users interact with data in the apps that this app protection policy applies. Below **Data Transfer**, configure the following settings, leaving all other settings at their default values:

   - **Send org data to other apps**, select ***None***.
   - **Receive data from other apps**, select ***None***.
   - **Restrict cut, copy, and paste between other apps**, select ***Blocked***.

   ![Graphical user interface, application Description automatically generated](img/intappprot.006.png)

1. Click **Next** to display the **Access requirements** page. This page provides settings to allow you to configure the PIN and credential requirements that users must meet to access apps in a work context. Configure the following settings, leaving all other settings at their default values:

   - **PIN for access**, select ***Require***.
   - **Work or school account credentials for access**, select ***Require.***

   ![Graphical user interface Description automatically generated with medium confidence](img/intappprot.007.png)

1. Click **Next** to display the **Conditional launch** page. 
   This page provides settings to set the sign-in security requirements for your app protection policy such as max PIN attempts, and blocking access if the device is jailbroken. Leave everything as default here under **App conditions** and **Device conditions**.

1. Click **Next** to display the **Assignments page**. 
   Under included groups click the **Add groups** link and select a group that contains the user(s) you wish to target. You can use the existing **Sales Group** that contains the user Bobby Smith that we created in a previous lab, or create a new group containing specific users if you like.

   ![Graphical user interface, text Description automatically generated](img/intappprot.008.png)

1. Click **Next** to display the **Review + create** page. Review the configuration and then click **Create** at the bottom of this page to finish creating the policy.

## Step 3. Create the app-based Conditional Access policy.

1. In the Microsoft Entra admin center select **Security > Conditional Access > + New policy from template (Preview)**
1. In the **Select a template** page click the **Zero Trust** and then click the **Show More** link at the bottom of the page and then select the **Require approved client apps and app protection** template and then click **Review + create**.

   ![MISSING ALT TEXT](img/intappprot.009.png)

1. Prefix the name of the policy with the recommended naming framework we used in previous labs (i.e., *CA011: Require approved client apps and app protection”*). You can leave all the remaining settings as default in this template but ensure to change the **Policy state** to **On** before clicking **Create**.

## Step 4. Test the App Protection policy.

1. On your Android device, find the Gmail app and attempt to set it up against the Exchange Online mailbox for your user Bobby Smith by selecting the **+ Add another email address** option and then selecting **Exchange and Office 365**.

   ![Graphical user interface, text, application Description automatically generated](img/intappprot.010.png)

1. After stepping through the process and authenticating you should be blocked by the Conditional Access policy (that requires an approved client app) with this message.

   ![MISSING ALT TEXT](img/intappprot.011.png)

1. Now log into the Play Store and download the Microsoft Outlook app.

1. Once installed, open the Outlook app and step through adding the account for Bobby Smith.
1. Once successfully signed into Outlook you should receive a message that tells you to install the Intune Company Portal app.

   ![Graphical user interface, text, application, email Description automatically generated](img/intappprot.012.png)

For App Protection policies to work they need a broker app. On Android this can either be the Authenticator App or the Company Portal. On IOS, just the Authenticator App is required.

1. Click the **Get the app** link which will take you to the download location for the Intune Company Portal app in the Play Store. Install the app. Once the Intune Company Portal is installed return to Outlook and sign-in again by clicking on **Add Account**. This time you will be asked to register your device. Click **Register**.

   ![Graphical user interface, text, application, chat or text message Description automatically generated](img/intappprot.013.png)

1. Once the registration of the device is complete the App Protection policy will kick in and you will be presented with this screen which is where the PIN policy will now be enforced. Click **Continue** to set a 4-digit PIN and click **OK**.

   ![Graphical user interface, application Description automatically generated](img/intappprot.014.png)

1. After setting the PIN you’ll finally be taken to your Inbox!

1. Now that you are in the Inbox you can try out the copy & paste restrictions that we set in the App Protection policy. To do this either open an existing email in this test user’s mailbox (if one exits) or send a new email from your @microsoft.com account to this test user and put an attachment in it. Open the email and try and save the attachment. You should be restricted from doing so with this message.

   ![Graphical user interface, application Description automatically generated](img/intappprot.015.png)

1. Now try and copy some text from an email and attempt to paste that into another application on the device. This should result in a message that states, **“Your organization’s data cannot be pasted here.”.**
