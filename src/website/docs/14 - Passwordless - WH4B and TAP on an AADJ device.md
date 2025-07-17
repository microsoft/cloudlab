---
id: pswdlesswhfb
title: Bootstrapping Windows Hello for Business using Temporary Access Pass 
sidebar_label: Windows Hello for Business 
slug: /pswdlesswhfb
---

<a name="_int_oy56knxe"></a>

Authentication methods, such as WH4B, FIDO2 and Phone Sign-in via the Authenticator app, enable users to sign in securely without requiring a password. These passwordless methods are considered a strong-auth credential, and as such users need to securely bootstrap into these methods which can be achieved in one of two ways:

- Using an existing registered MFA method
- Using a Temporary Access Pass (TAP)

Temporary Access Pass is a time-limited passcode that can be configured for multi or single use to allow users to onboard other authentication methods including passwordless methods. It also makes recovery easier when a user has lost or forgotten their strong authentication factor like a FIDO2 security key or their phone with the Authenticator app installed on it.

## Lab success exit criteria.

Using your own Windows host machine, you will first install Hyper-V and then create a Windows 11 virtual machine that we will use to test WH4B on. This lab will also introduce you to the Intune portal and basic Intune device management concepts for the first time. Via Intune you will create a WH4B policy which will apply to your virtual machine during the *Out-Of-Box Setup Experience* (OOBE) of Windows 11, and then using a Temporary Access Pass issued to your test user, you will experience securely bootstrapping directly to WH4B without a password being involved in any of the steps, and from which point on you can unlock the device via WH4B, in this case using a PIN as biometrics don’t work for virtual machines. The completion of this lab will also leave you with a Microsoft Entra joined machine that will be used in future labs to test out device based Conditional Access policies.

## Step 1. Enable Intune enrollment for your tenant

Automatic enrollment lets users enroll their Windows devices into Intune. To enroll, users add their work account to their personally owned devices or join corporate-owned devices. In the background, the device registers and joins Azure Active Directory. Once registered, the device is then managed with Intune where policies and settings can be applied.

1. Sign into the Microsoft Entra admin center <https://entra.microsoft.com>
1. Select **Azure Active Directory** > **Mobility (MDM and MAM)** > **Microsoft Intune**

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesswhfb.001.png)

1. Under **MDM User scope** change the setting from **None** to **All** and click **Save**.

   ![Graphical user interface, application, email Description automatically generated](img/pswdlesswhfb.002.png)

## Step 2. Enable the Windows Hello for Business policy in Intune

Using Intune you can create a tenant-wide policy that configures the use of Windows Hello for Business on Windows 10/11 devices at the time those devices register and enroll with Intune. 

1. Sign into the *Microsoft Endpoint Manager admin center* <https://endpoint.microsoft.com> 
1. Go to **Devices** > **Enroll devices** > **Windows enrollment** > **Windows Hello for Business**. 
1. In the *Windows Hello for Business pane* that opens, set the **Configure Windows Hello for Business** policy to **Enabled.** Leave all other settings as default.

   ![Graphical user interface, application Description automatically generated](img/pswdlesswhfb.003.png)

1. Click **Save**.

## Step 3. Install Hyper-V

To test Windows Hello for Business we need console access to the virtual machine which prohibits using an Azure based VM. Hyper-V does allow console access to a VM, so we will install Hyper-V on your work machine and then create a virtual machine locally that will be used to test Windows Hello for Business on.

1. On your Windows 11 host machine go to **Settings/Apps/Option Features** and scroll to the bottom of the page and under **Related Settings** click **More Windows Features**.

1. In the **Turn Windows features on or off** window, tick the **Hyper-V** option and click **OK** to begin the installation.** 

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesswhfb.004.png) 

1. You will need to perform a reboot after the installation of Hyper-V completes.

## Step 4. Create your Windows 11 virtual machine 

1. On your Windows 11 host machine, open Hyper-V and in the **Hyper-V Manager** select the **Quick Create** option in the right hand pane.

   ![MISSING ALT TEXT](img/pswdlesswhfb.005.png)

1. In the **Select an operating system** screen, select the **Windows 11 dev environment** option, and then click the **Create Virtual Machine** button.

   ![MISSING ALT TEXT](img/pswdlesswhfb.006.png)

This process will download a 20GB Windows 11 VM image to your host machine and then configures the VM for you. The VM will be configured on a default network switch that provides the VM with internet connectivity through your host machine.

   ![MISSING ALT TEXT](img/pswdlesswhfb.007.png)

Once completed, start your new Windows 11 virtual machine, and click Sign in. You’ll notice that you went straight to the desktop without providing a password. This is specific to this Windows 11 Dev environment VM which is already preconfigured with a user account that has no password set. We need to get this VM back to the Out-Of-Box-Experience (OOBE) for our testing, to do this we need to perform a reset of the VM. To do this:

1. Whilst logged into the VM, go to **System > Recovery > Reset this PC**
1. Select **Remove Everything**
1. On the **How would you like to reinstall Windows**? screen choose **Local Reinstall**
1. On the **Ready to reset this PC** choose **Reset**

The reset process takes around roughly 20 minutes to complete. I recommend moving onto the next steps while you wait for it to finish resetting itself in the background. Once it has reset itself just though run through the setup wizard to choose your language/keyboard and then stop at the **“Let’s set things up for your work or school”** screen.

   ![MISSING ALT TEXT](img/pswdlesswhfb.008.png)

## Step 5. Enable the Temporary Access Pass policy

A Temporary Access Pass policy defines the settings such as the lifetime of passes created in the tenant, or the users and groups who can use a Temporary Access Pass to sign-in. Before anyone can sign-in with a Temporary Access Pass you need to first enable the Temporary Access Pass authentication method policy.

1. Sign into the Microsoft Entra admin center <https://entra.microsoft.com>
1. Select **Azure Active Directory** > **Security** > **Authentication Methods** > **Policies.**
1. From the list of available authentication methods, select **Temporary Access Pass**.
1. Under the **Basic** tab set **Enable** to **Yes** and set the **Target** to **All Users**.
1. Under **Configure** you can leave all settings as default.
1. Click **Save** at the bottom of the page to enable the policy.

## Step 6. Create a Temporary Access Pass

1. In the **Microsoft Entra admin center**, navigate to the **Users** blade and select an existing user you would like to test out using Temporary Access Pass and Windows Hello for Business with. This can be either an existing on-premises user (if you have a Hybrid Identity lab setup), or a cloud user, or you can create a new test user if you prefer.
1. On the particular user’s properties page, select **Authentication methods** and then select the option to **Try the new user authentication methods experience**.
1. Select the option **+ Add authentication method** and in the **Choose method** drop down list select **Temporary Access Pass**.

   ![MISSING ALT TEXT](img/pswdlesswhfb.009.png)

1. Leave all the settings as default.
1. Once added, the details of the Temporary Access Pass are shown.   

   **Note:** Make sure to copy down the TAP value as you will not be able to view this again after you select **Ok**. You can always create another TAP for the user if you happen to forget what it is though.

   ![MISSING ALT TEXT](img/pswdlesswhfb.010.png)

1. We will now use this Temporary Access Pass to bootstrap Windows Hello for Business on our freshly reset Windows 11 Hyper-V virtual machine.

## Step 7. Bootstrap to Windows Hello for Business

The AMicrosoft Entra join setup process has been improved recently so that users can now authenticate with a TAP to first join a device and then flow through and register for Windows Hello for Business, all without being prompted for a password.

1. On your host machine, go into the **Hyper-V Manager** and click on **Hyper-V settings** in the right-hand **Actions** pane.

1. In the **Hyper-V settings** window, click on **Enhanced Session Mode Policy** and uncheck **Allow enhanced session mode** and then click **Apply** and **OK**.

   ![MISSING ALT TEXT](img/pswdlesswhfb.011.png)

   **Important!** If you don’t turn off enhanced session mode, you will not see the WH4B registration experience on the VM after signing in with the TAP.

1. Now return to the Windows 11 Hyper-V VM which should be sitting on the **“Let’s set things up for your work or school”** sign-in page.
1. Input the UPN of the user you just created a Temporary Access Pass for and click **Next**.
1. It should prompt you to enter in the Temporary Access Pass instead or a password.

   ![MISSING ALT TEXT](img/pswdlesswhfb.012.png)

1. Enter in the TAP that you created in Step 6 and click **Sign in**.

1. After the TAP has been accepted, move through the Windows setup wizard and accept the privacy settings to complete the configuration.
1. Once the device has finished the setup you should be presented with the Windows Hello setup page.

   ![MISSING ALT TEXT](img/pswdlesswhfb.013.png)

1. Click **OK** to begin the setup.
1. You will only be prompted to set up a PIN as we cannot use biometrics on a VM

   ![Graphical user interface, application, Teams Description automatically generated](img/pswdlesswhfb.014.png)

1. Input a PIN that meets the requirements (6 digits long, etc) and click **OK**.

   ![Graphical user interface, text, application, chat or text message, Teams Description automatically generated](img/pswdlesswhfb.015.png)

1. After clicking **OK** you should be taken to the desktop. The PIN is your WH4B credential that is used to unlock the private key in the software Trusted Protection Module of the VM.
1. You can test this by signing out and where you will be presented to sign-in with a PIN from the desktop.

   ![Graphical user interface, application Description automatically generated](img/pswdlesswhfb.016.png)

1. You can also validate that Windows Hello for Business is setup and being used on the device by going to a command prompt and running DSREGCMD /STATUS

In the output, scroll to the **User State** section and you’ll see that the **NgcSet** is set to **YES**

   ![MISSING ALT TEXT](img/pswdlesswhfb.017.png)

**Ngc** stands for Next Generation Credentials which was the internal name for WH4B.

Under the **SSO State** section you will also see the all-important PRT artefact that underpins the core benefits of a Microsoft Entra joined device, being user SSO and a device identity that allows it to pass through any device based access Conditional Access policies.

   ![Text Description automatically generated](img/pswdlesswhfb.018.png)

Now scroll to the **Device State** section where you can see the device is also Microsoft Entra joined.

   ![Graphical user interface, text Description automatically generated](img/pswdlesswhfb.019.png)

You can correlate this device information against the **Azure AD** > **Devices** > **All Devices** blade where the device should appear as well.

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesswhfb.020.png)

1. Lastly, we can test the SSO experience on this device now that it is Microsoft Entra joined. 
1. To do so, simply open Edge and navigate to <https://myapps.microsoft.com> and where you should go straight in without any prompts whatsoever. An interesting observation to note here is that we have a Conditional Access policy that requires MFA for all users yet the user received no MFA prompt. Why? If you look at the corresponding entry in the sign-in logs you will see that Microsoft Entra did prompt for MFA but the MFA requirement was satisfied by the existence of an MFA claim in the token. This is because the Primary Refresh Token (PRT) that is used to provide SSO was enriched with an MFA claim as the user is using Windows Hello for Business, which in turn was bootstrapped through a strong credential that satisfies MFA, the Temporary Access Pass.

   ![MISSING ALT TEXT](img/pswdlesswhfb.021.png)

**Note:** Now that you have completed this lab you can safely shut down the virtual machine, but please retain the VM itself as we will be using it in later labs that involve Intune and Defender.
