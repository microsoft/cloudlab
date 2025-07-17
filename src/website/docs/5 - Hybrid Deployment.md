---
id: hybriddeploy
title: Creating your Hybrid environment 
description: Set up Active Directory and Connect/Cloud sync
sidebar_label: Hybrid Deployment
slug: /hybriddeploy
---

The first thing that we need to do to get our hybrid identity environment up and running is to create a virtual machine that will be used as our on-premises Active Directory server. 

To do this we will be using Azure Infrastructure as a Service (IaaS) to build out a single [Active Directory Domain Services (AD DS) domain controller](https://learn.microsoft.com/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview). This environment will demonstrate [hybrid identity](https://learn.microsoft.com/azure/active-directory/hybrid/whatis-hybrid-identity) and other capabilities that require an on-premises Active Directory.

# Lab success exit criteria

In this lab you will deploy an Azure Quick Start template which will automatically provision a single virtual machine *and* configure Active Directory for you. You will then secure remote access to this server using [Azure Bastion](https://learn.microsoft.com/training/modules/connect-vm-with-azure-bastion/2-what-is-azure-bastion).

   ![MISSING ALT TEXT](img/hybriddeploy.001.png)

## Step 1. Create your virtual machine

To simplify the deployment, an [Azure Resource Manager (ARM)](https://learn.microsoft.com/azure/azure-resource-manager/management/overview) template will be deployed to build out the simulated on-premises environment. This template requires minimal input and will build out a single Windows 2016 server and install and configure a new Active Directory Forest. 

1. To start the deployment, log into <https://portal.azure.com> using a Global Admin account.
1. Open a new Edge tab and navigate to this link which is the Azure QuickStart Template [Create an Azure VM with a new AD Forest](https://github.com/Azure/azure-quickstart-templates/tree/master/application-workloads/active-directory/active-directory-new-domain). 
1. On this Quick Start Template page click the **Deploy to Azure** button.

   ![Graphical user interface, text, application, chat or text message Description automatically generated](img/hybriddeploy.002.png)

1. At the next screen, deployment details will be presented in the template, an option will be provided to customize some of the template details, such as changing the VM size, VM name, AD Domain Name, etc. Again, for simplicity keep the default and input details only into the required fields that are denoted with a red asterix, and which are self-explanatory. 

   >[!TIP]
   >Consider choosing a region that supports the Azure Bastion Developer SKU for free access to securely connect to your VM.
   >For more information, see [Free Azure Bastion Developer SKU](https://learn.microsoft.com/azure/bastion/quickstart-developer-sku).

   ![Graphical user interface, text, application, email Description automatically generated](img/hybriddeploy.003.png)

***Note:*** Make sure to document the **Admin Username** and **Password**, as well as the **Domain Name** that is specified as this will be the name of the Active Directory domain and this information will be required to logon onto the domain controller once the deployment is complete. The **Domain Name** will be not used in the tenant and is not needed to be publicly resolvable in DNS, and so can be anything you like.

1. At the bottom of the template click **Review + Create**.

   ![MISSING ALT TEXT](img/hybriddeploy.004.png)

1. This will perform a quick validation test to ensure there are no problems with the input parameters of the template. Once the validation has passed click the **Create** button to begin the deployment.

   ![A picture containing text Description automatically generated](img/hybriddeploy.005.png)

1. The deployment typically completes in 15 – 20 minutes, once done click the **Go to resource group** button. The next step is to configure remote access to the VM via the Azure Bastion service.

   ![Graphical user interface, text, application Description automatically generated](img/hybriddeploy.006.png)

## Step 2. Configure Azure Bastion for remote access to your VM

This ensures that the level of risk is kept low for the VM we will not be opening RDP as doing so opens the VM  up to RDP brute force attacks. Instead of using RDP to connect to the virtual machine [Azure Bastion](https://learn.microsoft.com/azure/bastion/bastion-overview) allows you to connect to a virtual machine using your browser (via the Azure portal) without having to open any ports to the VM itself, ensuring the VM is kept secure. To enable Azure Bastion:

1. In the Resource Group click on the adVM  virtual machine.

   ![MISSING ALT TEXT](img/hybriddeploy.007.png)

1. At the top of the Virtual Machine page click **Connect** and then select **Bastion** from the drop-down menu.

   ![MISSING ALT TEXT](img/hybriddeploy.008.png)

1. On the Create Bastion page that opens click the **Create Azure Bastion using defaults** button. If your VM is in a region that supports the [Azure Bastion Developer SKU](https://learn.microsoft.com/azure/bastion/quickstart-developer-sku), it will automatically be selected.

   ![MISSING ALT TEXT](img/hybriddeploy.009.png)

1. Bastion will take a few minutes to create and configure itself, and once completed you can enter the required on-premises credentials to log into the VM.

   ![Graphical user interface, application Description automatically generated](img/hybriddeploy.010.png)

   ![Graphical user interface Description automatically generated with medium confidence](img/hybriddeploy.011.png)

Whilst logged into the VM it is worth verifying that Active Directory installed correctly. To quickly do this, go to **Start/Windows Administrative Tools/Active Directory Users and Computers** and if the snap-in opens and displays the domain, it has been successful.

## Step 3. Configure Auto-Shutdown

To assist with conserving your monthly Azure spend, configure the VM to automatically shut down on a schedule.

1. In <https://portal.azure.com> go the properties of the VM and under the **Operations** section click **Auto-shutdown**. 

   ![Graphical user interface, text, application Description automatically generated](img/hybriddeploy.012.png)

1. Select a desired time to shut down the VM and specify an email address to be notified when the machine has been shut down successfully. Click **Save**.

   ![Graphical user interface, text, application, email Description automatically generated](img/hybriddeploy.013.png)

**Note:** There is no automatic restart option by default, the VM will need to be manually started each time it has been auto-shutdown. A restart schedule for the VM can be achieved by using a combination of Azure runbooks and Azure Monitor as detailed [here](https://learn.microsoft.com/azure/automation/automation-solution-vm-management).

Azure Bastion will also consume a decent chunk of your monthly Azure credit, even when using the cheapest basic SKU as there is no option to stop/start the service when you don’t need it. The only way to reduce cost here is to delete the Azure Bastion resource and then recreate it again when you need access to the VM. Azure Bastion only takes a few minutes to provision, but you should factor this into your lab environment when you plan to not access your VM for a while.

Following the successful setup of the Active Directory environment, the next step is to provision users from AD to the tenant. In the spirit of keeping things simple the sync configuration will be through new the [Microsoft Entra Cloud Sync agent](https://learn.microsoft.com/azure/active-directory/cloud-sync/what-is-cloud-sync) as opposed to using [Microsoft Entra Connect.](https://learn.microsoft.com/azure/active-directory/hybrid/how-to-connect-install-express) 
