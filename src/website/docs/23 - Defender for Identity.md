---
id: defidentity
title: Defender for Identity 
sidebar_label: Defender for Identity
slug: /defidentity
---

Microsoft Defender for Identity (MDI) is a component of the broader Microsoft 365 Defender suite. It gathers signals from on-premises Active Directory servers and then uses these signals to protect your hybrid identity environment, including protecting against hackers that use compromised accounts to move laterally across workstations in the on-premises environment. It does this through a sensor agent which you install on each domain controller, and over time it learns about your network and end-user behavioural patterns so it can detect anomalies and then warn you of any suspicious activity that needs to be investigated.

   ![MISSING ALT TEXT](img/defidentity.001.png)

## Lab success exit criteria. 

Using your Azure DC virtual machine, you will install the Defender for Identity sonar agent on the DC which will start to collect data and send it to the Defender for Identity service for analysis. You’ll then perform some attack simulations on the DC to generate alerts and events and then view these in the Defender for Identity portal.

## Estimated lab completion time.

25 minutes

## Step 1. Set up the Defender for Identity Instance

***Note:*** These steps all need to be performed from within your Azure VM Domain Controller (adVM).

To begin the deployment, you’ll start via the Microsoft 365 Defender portal at <https://security.microsoft.com>

1. Connect to your Domain Controller VM using Azure Bastion.
1. From within the VM, sign-in to <https://security.microsoft.com>
1. From the left-hand navigation menu, select **Settings** and then select **Identities** to initiate the creation of the Defender for Identity Instance.

   ![Graphical user interface, application  Description automatically generated](img/defidentity.002.png)

1. Provisioning only takes a few seconds before you will be taken to the Defender for Identity portal. 

## Step 2. Create the Directory Service account.

Defender for Identity requires you to create a Directory Service account that is used by the sensor to query the domain controller so data can be tracked and analysed by the service. This account just needs to be a regular user account and does not require domain administrator privileges. To create the account:

1. Connect to the DC VM via Azure Bastion.
1. Go to **Start/Run** and type DSA.msc and hit enter. This will open the **Active Directory Users and Computers** snap-in. Expand the domain object and then right click on the **Users** organizational unit object and select **New** → **User.**

1. Fill in the **New Object – User** wizard with the following details.

   - **First Name:** Defender
   - **Last Name:** Identity Users
   - **User logon name:** DefenderIdentityUser

   ![Graphical user interface, text, application  Description automatically generated](img/defidentity.003.png)

1. Specify a password and ensure to uncheck the **User must change password at next logon** field and click **Next** to finish creating the user.

   ![Graphical user interface, text, application  Description automatically generated](img/defidentity.004.png)

## Step 3. Configure the Directory Service account.

1. Return to the Microsoft 365 Defender portal and go to **Settings > Identities**.
1. Select **Directory Service Accounts**.
1. Select + **Add credentials** and fill in the **Account name**, **Domain**, and **Password** of the account you created in the previous step.

   ***Note:*** The **Account name** must not be in the UPN format and the **Domain** field is the FQDN of your on-premises Active Directory domain (i.e. ztlab.local).

   ![Graphical user interface, text, application  Description automatically generated](img/defidentity.005.png)

1. Click **Save.**

## Step 4. Install the Sensor.
1. Back in the Defender for Identity portal, under **General**, click **Sensors** and then click the **Add sensor** button.

   ![MISSING ALT TEXT](img/defidentity.006.png)

1. On the **Add a new sensor** flyout pane, click the **Download installer** option and ensure to copy and paste the **Access key** into notepad as you will need it again during installation of the sensor.

   ![Graphical user interface, text, application, email  Description automatically generated](img/defidentity.007.png)

If nothing happens when clicking the Download installer link, then Edge is most likely blocking the pop-up. You’ll need to unblock pop-ups from this site by clicking the pop-up blocker notification at the top right of the Edge menu and then ensure the radio button is on “Always allow….” and then click **Done**.

   ![Graphical user interface, text, application, chat or text message  Description automatically generated](img/defidentity.008.png)

1. The installer will download a file called **Azure ATP Sensor Setup.zip** located in your Downloads folder. Extract the zip file and then click the Azure ATP Sensor Setup executable to begin the installation.   
Defender for Identity was previously called “Azure Advanced Thread Protection (ATP)” hence the name of the setup file.

   ![Graphical user interface, text, application Description automatically generated](img/defidentity.009.png)

   ![Graphical user interface, text, application Description automatically generated](img/defidentity.010.png)

1. On the **Configure the Sensor** page copy and paste in the Access key and click **Install**.

   ![Graphical user interface, text, application Description automatically generated](img/defidentity.011.png)

   ![Graphical user interface, application  Description automatically generated](img/defidentity.012.png)

1. Once the sensor is installed go back to the Defender for Identity portal and under **Sensors** you should now see the sensor on the domain controller show up and it should show as “Running”. Refresh the page if you don’t see straight away.

   ![A screenshot of a computer  Description automatically generated](img/defidentity.013.png)

## Step 5. Turn off the learning period feature.

The alerts generated by Defender for Identity are based on various factors such as profiling, deterministic detection, machine learning, and behavioral algorithms that it has learned about your network. The full learning process for Defender for Identity can take up to 30 days per domain controller. To speed up this process we can turn off this learning period for alerts by enabling the **Remove learning period** feature. When enabled, every alert that is based on learning or profiling will be triggered instantly.

1. In the Microsoft 365 Defender portal <https://security.microsoft.com> go to **Settings** > **Identities.** 
1. Go to **Advanced settings** in the left-hand menu.
1. Disable the learning period by toggling the **Remove learning period** button to **On**.

   ![Graphical user interface, application  Description automatically generated](img/defidentity.014.png)

## Step 6. Generate and view alerts.

Defender for Identity has an excellent [Attack simulations](https://learn.microsoft.com/defender-for-identity/playbooks) playbook that outlines how to perform simple suspicious activities to generate alerts. For this lab I’m going to provide the steps on how to perform a simple DNS reconnaissance using nslookup so you can see the resulting alert that is generated in the portal, but I recommend using the playbook to see some other simulations that you can run in order to go deeper in exploring Defender for Identity capabilities.

1. Connect to the DC VM via Azure Bastion.
1. Open a command prompt and type **nslookup**
1. Type **server adVM** (Replace adVM with the name of your DC if it is different)
1. Type **ls -d ztlab.local** (Replace ztlab.local with the FQDN of your internal AD domain)
1. This will attempt a DNS zone transfer which will be refused by the DNS server and will hence trigger an alert in Defender for Identity.

   ![Text  Description automatically generated](img/defidentity.015.png)

1. Go to the Microsoft 365 Defender portal and from the search bar at the top perform a search for the name of your DC “adVM” and then click the device object returned in the result.

   ![Graphical user interface, application, Teams  Description automatically generated](img/defidentity.016.png)

1. Click on the **Open device page**. 

   ![Graphical user interface, application  Description automatically generated](img/defidentity.017.png)

1. On the **Device summary** page then click on **Timeline**.

   ![Graphical user interface, text, application  Description automatically generated](img/defidentity.018.png)

1. Under the **Timeline** you should see the following event logged in red for cmd.exe about the nslookup command we just ran to attempt a DNS zone transfer.

   ![Graphical user interface, text, application, email  Description automatically generated](img/defidentity.019.png)

This completes the Defender for Identity lab.
