---
id: setupm365
title: Setting up your Microsoft 365 E5 Sandbox Tenant 
sidebar_label: M365 Developer Tenant
slug: /setupm365
---

# Lab success exit criteria

At the end of this lab you will have joined the **Microsoft Developer Program** and created a new **Microsoft 365 E5 tenant** that is populated with sample users and data that simulates a small corporate environment which will be used as the foundation for the remaining guide.

   ![MISSING ALT TEXT](img/setupm365.001.png)

## Step 1. Join the Microsoft 365 Developer Program

1. Using your Microsoft corporate FTE account log into <https://my.visualstudio.com/benefits> and locate the **Microsoft 365 Developer subscription (E5)** tile and click **Activate**. 

   ![Graphical user interface, text, application Description automatically generated](img/setupm365.002.png)

1. This will take you to a Microsoft 365 Developer Program dashboard where you will need to fill in a few details to complete the sign-up process. 

   ![MISSING ALT TEXT](img/setupm365.003.png) 

1. At the end of this sign-up process, you will be presented with a screen to setup your Microsoft 365 E5 sandbox tenant which we will complete in Step 2.

## Step 2. Create your Microsoft 365 E5 Sandbox tenant

There are two options that you will be presented with when creating your sandbox tenant, **Instant Sandbox** or **Configurable Sandbox**. There are slight nuances between each option that you should be aware of which are:

**Instant Sandbox**
- The tenant’s name is randomly generated for you
- All sample data packs are automatically installed

**Configurable Sandbox**
- You can choose your own tenant’s name
- You can choose what sample data packs to install

Aside from the above points there is no discernible differences between the tenants whichever option you choose. However, my recommendation for this guide is for you to choose the **Configurable Sandbox** option as it gives you slightly more flexibility.

***Note*** that you can still add your own publicly verified domain name to either sandbox option you choose after it has been created. When naming your tenant, I recommend using <https://o365.rocks> to easily search for a desirable tenant name that has not already been used.

1. At the **Set up your Microsoft 365 E5 sandbox** screen select **Configurable sandbox**.

   ![MISSING ALT TEXT](img/setupm365.004.png)

1. At the next screen fill in the required fields, being **Country/Region**, **Username/Password**, and the desired tenant name.

   ![MISSING ALT TEXT](img/setupm365.005.png)

1. Provide a phone number for security purposes and then retrieve the code that is sent to your phone to complete the tenant creation process. After a few seconds you should be taken to the dashboard that shows information about your new tenant and where you can now start to add your sample data packs.

   ![MISSING ALT TEXT](img/setupm365.006.png)

1. From here you can click the **Go to subscription** link to be taken to the Office portal where you will be logged into your new tenant. To make your life easier to consume this lab guide I recommend creating a new Edge profile for the Global Admin account of your new tenant to prevent any browser session headaches and then set <https://entra.microsoft.com> as the home page for that profile. 

   ***Note:*** As [Security Defaults](https://learn.microsoft.com/azure/active-directory/fundamentals/concept-fundamentals-security-defaults) are enabled for all tenants now you will be prompted to secure your Global Admin account with MFA by configuring the Authenticator App and specifying a phone number as a secondary method. I recommend completing this step so your Global Admin account is secured, but we will be turning off Security Defaults later as we will be using Conditional Access for MFA.

   ![MISSING ALT TEXT](img/setupm365.007.png)

1. Now it’s time to add your sample data packs starting with the **Users** pack first.

   ![Graphical user interface Description automatically generated](img/setupm365.008.png)

1. This process will spawn a new window asking you to log into your tenant where you will need to consent and accept the permissions requested by the Sample Data Packs app to proceed.

1. In the **Add sample users** wizard specify a password that will be used for all the new users it will create and then click **Install**. 

   ![Graphical user interface, text, application Description automatically generated with medium confidence](img/setupm365.009.png)

This process **\*should\*** take around anywhere from 5 - 15 minutes to complete but be patient if it drags on longer than that. Once you see the sample Users data pack tile completed verify that you see the 16 new users in your tenant before moving on and adding the remaining sample packs for **Mail & Events** and **SharePoint**. You can follow the detailed steps [here](https://learn.microsoft.com/office/developer-program/install-sample-packs) for installing the remaining sample packs but it’s a pretty straightforward process if you just go with the defaults, but just be aware that the SharePoint sample pack offers 6 individual site templates which can take a long time to install, with that in mind I recommend just installing a single site template that is imaginatively called **“Team site with data”.**

You can now start exploring this tenant via <https://admin.microsoft.com> to see the fictitious users, metadata, photos, and sites that the sample packs created for you that simulate a small corporate environment.
