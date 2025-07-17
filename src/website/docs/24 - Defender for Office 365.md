---
id: defo365
title: Defender for Office 365 
sidebar_label: Defender for Office 365
slug: /defo365
---

Microsoft Defender for Office 365 protects you against advanced threats such as zero-day attacks that involve unknown malware, targeted phishing or spear phishing campaigns, ransomware, and malicious URLs. By using a combination of machine learning, heuristic clustering, activity events and statistical analysis, suspicious attachments are routed through a hypervisor environment where they are detonated and analyzed for malicious behavior. Defender for Office 365 can protect an organization from such attacks (pre-breach), as well as remediate issues after a post-breach incident. It builds on the core protections offered by Exchange Online Protection (EOP) which is present in any subscription where Exchange Online mailboxes can be found.

## Lab success exit criteria.

After enabling the Defender for Office 365 inbuilt Standard Protection policies which provides baseline protection for users from spam, phishing, and malware, you will test the URL blocking feature that quarantines emails when they contain specific domains as links. You will then craft a harmless malware file to test the malware protection in OneDrive. Lastly, using the attack simulation training feature, you will send a phishing email to all your users where you can then track who fell prey to the suspicious email that tricks them into giving up their credentials if they click the link in it.

## Estimated lab completion time.

20 minutes

## Step 1. Activate Defender for Office 365

1. Go to the Microsoft 365 Defender portal [https://security.microsoft.com](https://security.microsoft.com/) 
1. Expand **Email & collaboration > Policies & rules > Threat policies > Preset Security Policies.**

   ![MISSING ALT TEXT](img/defo365.001.png)

1. On the **Preset security policies** page, click **Manage** in the **Standard protection**.

1. The **Apply Standard protection** wizard will start.

   ![Graphical user interface, text, application Description automatically generated](img/defo365.002.png)

1. On the **Apply Exchange Online Protection** wizard, configure the following:

   - **Exchange Online Protection:** *All Recipients*
   - **Defender for Office 365 Protection:** *All Recipients*
   - **Impersonation Protection:** *(leave these blank for users/domains/Trusted senders)*
   - **Policy Mode:** *Turn on the policy after I finish.*

1. Click **Confirm** and **Done** to apply the policy and you’ll then see the **Standard Protection** policy is now enabled.

   ![Graphical user interface, text, application, email Description automatically generated](img/defo365.003.png)

The Standard Protection policy created all the relevant policies (over the default ones) which you can validate under each policy on the **Threat Policies > Policies** page.

   ![Graphical user interface, application Description automatically generated](img/defo365.004.png)

   ![MISSING ALT TEXT](img/defo365.005.png)

## Step 2. Block a URL that cannot be used in email.

Here we will test out the ability to block specific URL’s that appear in emails. This can help protect the organisation from targeted phishing attacks that send users to suspicious websites that can trick the user into giving up their credentials. Email messages that contain these blocked URLs are blocked as *high confidence phishing* and quarantined instead of being delivered to the users Inbox.

1. In the Microsoft 365 Defender portal, go to **Email & collaboration > Policies & rules**, then **Threat policies**. 
1. Under **Rules**, click **Tenant Allow/Block Lists.** 
1. At the top of the page click **URLs**, and then click **+ Block**

   ![Graphical user interface, application, Word Description automatically generated](img/defo365.006.png)

1. In **Block URLs** list, add the following URL: tailspintoys.com 
1. Click **Add

   ![Graphical user interface, text, application, email Description automatically generated](img/defo365.007.png)**

1. From your Microsoft email account, compose a new message with Bobby Smith as the recipient, and provide a subject. Within this email put in the link [www.tailspintoys.com](http://www.tailspintoys.com) and send it.

1. Bobby should ***not*** receive this email as it contains the blocked URL which will cause it to be quarantined instead. 
1. To view the quarantined email go to the Microsoft 365 Defender portal, expand **Email & collaboration > Explorer.** 
1. In the **Threat Explorer** window under the **All email** section you should see the email you sent to Bobby which will show the Delivery location as “Quarantine”.

   ![MISSING ALT TEXT](img/defo365.008.png)

## Step 3. Upload a test malware file to OneDrive for Business.
To demonstrate the safe attachment policy in action for OneDrive we will create and upload an anti-virus test file. While this is merely a benign text file, its contents are created to emulate a malware payload. I recommend you delete the file from your PC once you have completed the steps below. ***Note:*** If you are creating this file on your Microsoft corporate laptop it is likely to get picked up as malware and deleted quickly. You can still do these steps safely on a Microsoft corporate laptop, but you’ll need to be quick before the file is removed automatically. An alternative is to use the Azure VM instead. 

1. Navigate to <https://portal.office.com> and log in as user Bobby Smith.

1. Click the OneDrive app from the App Launcher in the top left corner.
1. Using notepad, create a new file with the following text in it

   ``X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H\*``
1. Save the file to your desktop and provide a name (e.g. **MalwareTest.txt**)
1. Immediately, upload the file to Bobby’s OneDrive for Business where it will be detected as malware.

   ![MISSING ALT TEXT](img/defo365.009.png)

## Step 4.  Attack simulation training.

Besides defining custom policies to prevent common attacks, another powerful technique is to simply educate users so they learn to avoid common mistakes that attackers hope to exploit. Microsoft Defender for Office 365 provides a useful tool to test policies and educate end users about attacks via **attack simulation training**. Attack simulation training can be used to safely identify vulnerable users in an organization before a real attack happens.

To set up an attack simulation:

1. Under **Email & collaboration**, click **Attack Simulation training**. 
1. Click the **Simulations** tab and click the **+ Launch a simulation** button.

   ![Graphical user interface, text, application Description automatically generated](img/defo365.010.png)
1. In the Create a simulation window that opens choose these options:

   - **Select Technique:** *Credential Harvest* 
   - **Simulation Name:** *Credential Harvest Attack Simulation*
   - **Select payload and login page:** *American Express password reset*
   - **Target users:** *Include all users in my organization*
   - **Exclude users:** *Leave unchecked*
   - **Assign Training:** *Leave as default (Microsoft recommended)*
   - **Select Phish landing page:** *Select Microsoft Landing Page Template 1*
   - **Select end user notification:** *Do not deliver notifications*
   - **Launch Details:** *Launch this simulation as soon as I’m done* 

At this point you can choose to **“Send a test”** which will go to just your mailbox (the Global Admin), or just click **Submit** to kick it off the simulation for everyone. 

***Note:*** It might take 30 seconds to submit the simulation before you can click **Done**.

## Step 5. Participate in the attack simulation.

Using the account Bobby Smith you will interact with the attack simulation email and then view the reporting results in the Microsoft 365 Defender portal.

1. Go to <https://outlook.office365.com> and log into Bobby Smith’s mailbox.

1. In the Inbox should be the attack simulation email masquerading as American Express.

   ![Graphical user interface, text, application Description automatically generated](img/defo365.011.png)

1. Open the email and follow the “click here” link to reset your password.

1. This will render a page that mimics the Microsoft Entra login page, go ahead and login. ***Note:*** You don’t need to enter in valid credentials for Bobby Smith here as this is a phishing page.
1. Once you have pretended to login you should be greeted with the message that you were just phished.

   ![Graphical user interface, text Description automatically generated](img/defo365.012.png)

1. Return to the Microsoft 365 Defender portal, and under **Email & collaboration** > **Attack Simulation training** **> Simulation** click the “Credential Harvest Attack Simulation” to bring up the progress report where you should see 1 compromised user, poor Bobby Smith.

   ![Graphical user interface, text, application, email Description automatically generated](img/defo365.013.png)

This completes the Microsoft Defender for Office 365 lab.
