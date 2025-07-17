---
id: defendpoint
title: Defender for Endpoint 
sidebar_label: Defender for Endpoint
slug: /defendpoint
---

Defender for Endpoint helps prevent, detect, investigate, and respond to advanced threats on your endpoints (aka devices). This not only includes Windows devices, but works for Mac, Linux, IOS, and Android as well. The solution is designed to protect against a wide range of threats, including malware, ransomware, and other types of attacks. 

Consider an event where someone sends a Word attachment with embedded malicious code to a user within your organization. The user opens the attachment and enables the content. An elevated privilege attack starts, and an attacker from a remote machine has admin rights to the victim's device. The attacker then remotely accesses the user's other devices and starts to move laterally through the environment. A security breach such as this can impact an entire organization.

Defender for Endpoint can help resolve security events like this scenario where it will detect that the device executed abnormal code, experienced a process privilege escalation, injected malicious code, and issued a suspicious remote shell on another device. Based on these actions from the device, Defender for Endpoint classifies the device as high-risk and includes a detailed report of the suspicious activity. Paired with Intune polices, devices with a *Medium* or *High* level of risk are marked as not compliant based on information from Defender for Endpoint. This classification allows your Microsoft Entra Conditional Access policies to then kick in and block access to your corporate resources from those Medium/High risk devices.

## Lab success exit criteria.

For this lab you will be reusing the Windows 11 Hyper-V virtual machine that we created in the Windows Hello for Business lab. This virtual machine is already “Microsoft Entra Joined” and managed by Intune. You will start by establishing a service-to-service connection between Intune and Defender for Endpoint. This connection lets Defender for Endpoint collect data about machine risk from Intune managed devices.

Using a *device compliance policy* in Intune you will set the level of risk that you want to allow for your devices. Any device over that risk level as reported by Defender for Endpoint will be marked as Not Compliant in Intune. 

A sample script will then be run on the virtual machine to simulate suspicious activity to exceed the defined risk level making it fall into a non-compliant state in Intune. You will then remediate the risk in Defender for Endpoint and bring the device back into a compliant state.

## Estimated lab completion time.

30 minutes

## Step 1. Enable Defender for Endpoint for Intune

The first step you take is to set up the service-to-service connection between Intune and Defender for Endpoint. To do this:

1. Sign into the Intune Portal <https://endpoint.microsoft.com> 

1. Select **Endpoint security** > **Microsoft Defender for Endpoint**, and then select **Open the Microsoft Defender Security Center**.

   ![MISSING ALT TEXT](img/defendpoint.001.png)

1. This will open the In **Microsoft 365 Defender** portal (<https://security.microsoft.com>)

1. Select **Settings** > **Endpoints** >**Advanced features**.

1. For **Microsoft Intune connection**, choose **On** 

   ![MISSING ALT TEXT](img/defendpoint.002.png)

1. Click **Save preferences**.

1. Now return to **Microsoft Defender for Endpoint** page back in the Intune portal.

1. Under **Compliance policy evaluation**, configure the following:
   -  **Connect Android devices** to Microsoft Defender for Endpoint: **On**
   - **Connect iOS devices** to Microsoft Defender for Endpoint: **On**
   - **Connect Windows devices** to Microsoft Defender for Endpoint: **On** 

1. Click **Save.**

## Step 2. Create a device configuration profile to onboard devices.

After you connect Intune and Defender for Endpoint, Intune receives an onboarding configuration package from Defender for Endpoint. You then use a device configuration profile to deploy the package to your Windows devices. This configuration package configures devices to communicate with Microsoft Defender for Endpoint services to scan files and detect threats so a risk level can be determined that Intune can action.

1. In the Intune portal <https://endpoint.microsoft.com> 

1. Select **Endpoint security** > **Endpoint detection and response** > **Create Policy**.
   * For **Platform**, select **Windows 10 and later**.
   * For **Profile type**, select **Endpoint detection and response**, and then select **Create**.
1. This brings up the **Create profile** page.

1. On the **Basics** page, enter “Defender for Endpoint Windows Configuration Profile” for the *Name* then click **Next**.

1. On the **Configuration settings** page, configure the following options for **Endpoint Detection and Response**.

   ![Graphical user interface, text, application Description automatically generated](img/defendpoint.003.png)

1. Select **Next** to open the **Scope tags** page. Scope tags are optional, so we won’t add anything here. Select **Next** to continue.

1. On the **Assignments** page, select both the **Add all users** and **Add all devices** options and then click **Next**.

   ![Graphical user interface, text, email Description automatically generated](img/defendpoint.004.png)

1. On the **Review + create** page choose **Create** to create the profile.

## Step 3. Create a compliance policy to set device risk score.

The compliance policy determines the level of risk that you consider acceptable for a device to remain compliant. We will be setting the machine risk score to *Low* which means that any device marked as Medium or High will be determined to be noncompliant.

1. In the Intune portal select **Devices > Compliance policies > Policies > Create Policy**.
1. For **Platform**, use the drop-down box to select **Windows 10 and later** and then click **Create**.
1. This opens a **Windows 10/11 compliance policy** page.
1. Under **Basics**, enter *“Defender for Endpoint Windows Compliance Policy*” for the *Name* and then click **Next**.
1. On the **Compliance settings** tab, expand the **Microsoft Defender for Endpoint group** and set the **Require the device to be at or under the machine risk score** to “Low”.

   ![Graphical user interface, text, application, email Description automatically generated](img/defendpoint.005.png)

1. Click **Next**, on the **Actions for noncompliance** tab, leave this section blank and click **Next**.
1. On the **Assignments** tab, choose both the **Add all users** and **Add all devices** and click **Next**.
1. Select **Create** to finish creating the policy.
1. Lastly, very the current compliant state of the Hyper-V virtual machine under **Devices > Windows Devices.** It should be showing as **Compliant**.

   ![Graphical user interface, text, application, email Description automatically generated](img/defendpoint.006.png)

## Step 4. Enable network protection on devices.

Network protection helps to prevent employees from using any application to access dangerous domains that may host phishing scams, exploits, and other malicious content on the internet. This will allow us to block specific SaaS apps on device in the subsequent Defender for Cloud Apps lab.

1. Go to **Endpoint security > Security baselines > Microsoft Defender for Endpoint Baseline**.
1. Select **Create a profile**, and name the profile “Windows Network Protection” and then select **Next**.
1. In the **Configuration settings** section, go to **Attack Surface Reduction Rules >** and ensure **Enable Network Protection** is set to **Enable.** Click **Next.

   ![MISSING ALT TEXT](img/defendpoint.007.png)**

1. On **Scope tags** you can leave this empty. Click **Next.**

1. On the **Assignments** tab, choose both the **Add all users** and **Add all devices** and click **Next**.
1. Select **Create** to finish creating the policy Review all the information, and then select Create.

## Step 5. Run a detection test to verify the device is properly onboarded.

To verify that the device has been properly onboarded to Defender for Endpoint and is reporting to the service correctly we will now run a detection script on the Windows 11 Hyper-V VM. This script simulates a [“Mitre Attack”](https://attack.mitre.org/techniques/T1059/001/) that Defender for Endpoint will alert on, which in turn will be picked up by Intune, which will then mark the device as “Not Compliant”.

1. Log into your Microsoft Entra Joined Hyper-V virtual machine as a test user.
1. Go to **Start** and type **cmd** and then right-click **Command Prompt** and select **Run as administrator**.
1. From the elevated Command Prompt window copy and paste the command below. The Command Prompt window will close automatically once it runs.

   `powershell.exe -NoExit -ExecutionPolicy Bypass -WindowStyle Hidden $ErrorActionPreference= 'silentlycontinue';(New-Object System.Net.WebClient).DownloadFile('http://127.0.0.1/1.exe', 'C:\\test-WDATP-test\\invoice.exe');Start-Process 'C:\\test-WDATP-test\\invoice.exe'`

1. After a few minutes a new alert against the device with a severity of Medium will appear in the Microsoft 365 Defender portal (<https://security.microsoft.com>) under **Incidents & alerts > Alerts**.

   ![Graphical user interface, text, application, email Description automatically generated](img/defendpoint.008.png)

1. Click on the **Suspicious PowerShell command line** alert to view more details about the suspicious activity.

   ![MISSING ALT TEXT](img/defendpoint.009.png)

1. Now go to the Intune portal and under **Devices > Windows Devices** you should see the device marked as Not Compliant.

   ![MISSING ALT TEXT](img/defendpoint.010.png)

1. Any Conditional Access policy with a Grant control that “Require device to be marked as compliant” will now block this device from accessing any resources protected by the Conditional Access policy.
1. To bring the device back into compliance you can mark the incident as resolved via the M365 Defender portal. 
1. To do this go to **Incidents & alerts > Incidents** and select the *“Execution incident on one endpoint”* incident and under **Manage incident** and set the **Status** to **Resolved** and save the changes.

   ![Graphical user interface, application, Teams Description automatically generated](img/defendpoint.011.png)

1. In the Intune portal you should see the device now marked as Compliant again.

   ![Graphical user interface, text, application, email Description automatically generated](img/defendpoint.006.png)

If you are interested in running further simulation tests you can explore the built in Simulation gallery from the M365 Defender portal under **Endpoints > Evaluation & tutorials > Tutorials & simulations** where a list of supported third-party threat simulation agents are listed, and specific types of simulations along with detailed descriptions are provided in the catalog.

This completes the **Defender for Endpoint** lab.
