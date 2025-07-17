---
id: pswdlesspsi
title: Passwordless with Phone Sign-in 
sidebar_label: Phone Sign-in
slug: /pswdlesspsi
---

Microsoft Entra currently offers the following four passwordless methods for users.

**Phone sign-in using the Authenticator App**  
**FIDO2 security keys**
**Windows Hello for Business**   
**Certificate Based Authentication**

   ![Text Description automatically generated](img/pswdlesspsi.001.png)

Users can register themselves for these passwordless methods (as dictated by the authentication methods enabled in the tenant) via various ways depending on the method chosen. In this lab we will start with the easiest method – ***Phone sign-in*** via the Authenticator app.

In the case of phone sign-in, Microsoft Entra detects that the user has a strong credential registered after they input their UPN. This triggers the passwordless authentication flow where the user is presented with a 2-digit number on the login screen, and a corresponding notification is sent to their device where they input the same 2-digit number. From there, they will be asked to provide their device passcode/biometric to complete the authentication approval. This is considered a multi-factor approval in that the user must possess something they have (the Authenticator app), and something they know (the device passcode/biometric).

# Lab success exit criteria

Using the Authenticator App (on IOS or Android), you will enable phone-sign for a test user and then test logging in to Microsoft Entra by performing a number matching sequence via the app instead of using a password.

## Step 1. Enable phone sign-in

1. Sign in to <https://entra.microsoft.com> as your global admin
1. Select *Azure Active Directory*, then browse to **Security** > **Authentication methods** > **Policies**.
1. Under **Microsoft Authenticator**, choose the following options:  
   **Enable** – Yes  
   **Target** - All users  
   **Authentication mode** – Any

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesspsi.002.png)

1. Click **Save** to apply the new policy.

## Step 2. Register and enable phone sign-in as a user

From the previous labs you should already have a test user registered and using the Authenticator App for MFA, and if you are following along with this lab guide then those users are either *Bobby Smith* or *Guy Oz*. For these two users you can skip straight to *Step 2 #5* and simply enable phone sign-in, but for completeness (or if you wanted to test with a fresh new user) then these are the full steps to register and enable phone sign-in.

**Note:** If you are using an IOS device you can now add *and* enable multiple accounts for phone sign-in on the same device which allows for easier testing in this lab. This does require you to register your device against your test tenant.

1. Open an In-Private Edge session and browse to <https://aka.ms/mysecurityinfo>
1. Sign in as your user of choice for testing, then click **Add method** > **Authenticator app** > **Add** to add the Authenticator app.
1. Follow the instructions to install and configure the Authenticator app on your device.
1. Select **Done** to complete the Authenticator configuration.
1. Open **Microsoft Authenticator** on your device and choose **Enable phone sign-in** from the drop-down menu for the account you are testing with.
1. Follow the instructions in the app to finish registering the account for passwordless phone sign-in.

   ![MISSING ALT TEXT](img/pswdlesspsi.003.png)

## Step 3. Sign in with a passwordless credential

The first time a user starts the phone sign-in process, the user performs the following steps:

1. Open an In-Private Edge session and navigate to <https://myapps.microsoft.com> 
1. Enter in the UPN of the user you enabled phone sign-in for in the previous step.
1. After clicking **Next,** you should get a number matching prompt instead of a password screen.

   ![MISSING ALT TEXT](img/pswdlesspsi.004.png)

## Step 4. Enable additional context for Authenticator notifications

To further improve security for phone sign-in and MFA notifications we will now turn on additional context for the Authenticator App which will present the user with richer details about the sign-in that generated the prompt, such as the requesting app and user location.

1. Sign in to <https://entra.microsoft.com> as your global admin
1. Select *Azure Active Directory*, then browse to **Security** > **Authentication methods** > **Policies**.
1. Under **Microsoft Authenticator**, choose **Configure**
1. Under **Configure**, set these three options to *Enabled* targeting *All Users*.    
**Require number matching for push notifications**    
**Show application name in push and passwordless notification**   
**Show geographic location in push and passwordless notifications**
1. Click **Save**.

## Step 5. Test additional context notifications

1. Open an In-Private Edge session and navigate to <https://myapps.microsoft.com>
1. Enter in the UPN of the user you enabled phone sign-in for.
1. After clicking **Next,** you should get a phone-sign notification on your phone.
1. Notice the extra details that now show in the app notification.

   ![Graphical user interface, application Description automatically generated](img/pswdlesspsi.005.png)
