---
id: pswdlessfido2
title: Passwordless sign-in using a FIDO2 security key 
sidebar_label: FIDO2 Security Keys
slug: /pswdlessfido2
---

FIDO **(F**ast **ID**entity **O**nline) is an open standard for passwordless authentication. Any security key that adopts the FIDO2 standard can be used to authenticate into Microsoft Entra, and Windows.** Where Windows Hello for Business provides a personal and passwordless way to sign into Windows 10 & 11 devices, it is only really designed for employees to use on their dedicated computer and where the biometrics are enrolled onto the device.** While this works great for users with a dedicated device, it is not ideal for users in **Shared PC environments**. In these scenarios, workers move through many computing “stations” throughout the day, and where a portable passwordless method is required. This is where the primary benefit of using FIDO2 security keys for passwordless come into play.

## Lab success exit criteria

After enabling the FIDO2 Security Key authentication methods policy, you will register a FIDO2 key as a user and then test signing in via this passwordless method. To complete this lab, you will need a physical FIDO2 security key.

## Step 1. Enable the FIDO2 security key authentication method policy

1. Sign-in to the Microsoft Entra admin center <https://entra.microsoft.com>

1. Browse to **Azure Active Directory** > **Security** > **Authentication methods** > **Policies**
1. Click the **FIDO2 Security Key** method and choose the following options
   - **Enable** - Yes or No
   - **Target** - All users
   -  **Save** the configuration

## Step 2. User registration of a FIDO2 key

Select a test user for whom you would like to register the key against and then perform the following steps as this user.

1. Open an In-Private Edge session and browse to [https://myprofile.microsoft.com](https://myprofile.microsoft.com/) and sign in as your chosen test user.

1. Click the **Update Info** link in **Security Info** tile.
1. Add a FIDO2 Security key by clicking + **Add sign-in method** and choosing **Security key**.

   ![Graphical user interface, text, application Description automatically generated](img/pswdlessfido2.001.png)

   ![Graphical user interface, application Description automatically generated](img/pswdlessfido2.002.png)

1. Choose the **USB device** or **NFC device** option that is applicable to your FIDO2 device.

1. Have your key ready and choose **Next**.
1. A box will appear and will ask the user to create/enter a PIN for the security key, then perform the required gesture for the key, either biometric or touch.
1. The user will then be asked to provide a meaningful name for the key so the user can identify which one if they happen to have multiple. Click **Next**.
1. Click **Done** to complete the process and close the browser.

## Step 3. Sign in with a FIDO2 security

1. Open an In-Private Edge session and browse to <https://myapps.microsoft.com>

1. Input the UPN of the user that you registered the FIDO2 key against in step 2 and click the **Sign-in Options** tile at the bottom of the page and select **Sign in with a security key.**

   ![Graphical user interface, text, application Description automatically generated](img/pswdlessfido2.003.png)

1. Ensure your FIDO2 key is inserted into your device and then select **Security key** and click **OK**

1. Enter the PIN that you created during registration, click **OK** and then perform the required gesture (biometric or touch) to complete the sign-in. 
