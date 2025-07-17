---
id: govlcw
title: Lifecycle Workflows 
sidebar_label: Lifecycle Workflows
slug: /govlcw
---

Lifecycle Workflows (LCW) is a new Identity Governance service that enables organizations to manage users by automating these three basic lifecycle processes – Joiner, Mover, Leaver.

***Joiner*** - A new employee joining a company or organization who will need access to resources.

***Mover*** - An individual moving between boundaries within an organization who may require more (or less) access or authorization. An example would be a user who was in marketing is now a member of the sales organization.

***Leaver*** - An individual leaves the scope of needing access, access may need to be removed. Examples would be an employee who is retiring or an employee who has been terminated.

Lifecycle workflows automatically execute configured tasks when users join or leave your org and provide insights for easy troubleshooting.

## Lab success exit criteria.

In this lab we will test the **Leaver** scenario and execute a real-time employee termination with Lifecycle workflows using the Azure portal. This off-boarding scenario will run a workflow on-demand that will remove the user from all groups and Teams, and then delete the user account.

## Step 1. Create the Lifecycle Workflow

1. Sign-in to the Microsoft Entra admin center as your Global Admin <https://entra.microsoft.com>
1. In the left menu browse to **Identity Governance** > **Lifecycle Workflows (Preview)**.
1. On the **Overview (Preview)** page, select **+ Create workflow.**
1. Under the **Choose a template** tab select **Real-time employee termination.**
1. Under **Basic tab** leave the defaults and select **Next: Review tasks.**
1. Under the **Review tasks** tab inspect the three predefined tasks but no additional configuration is needed here. 

   ![Graphical user interface, text, application, email Description automatically generated](img/govlcw.001.png)

1. Select **Next: Select users**.

1. Under the **Select users** tab click **+ Add users** and select a user that you will apply this workflow to.    
I recommend choosing one of the cloud users that was created by the user pack during the hydration of the tenant, such as *Grady Archie*.

   ![MISSING ALT TEXT](img/govlcw.002.png)

1. Click **Next: Review + create**.

1. On the review blade, verify the information is correct and select **Create**. 
1. After it has been created the workflow will automatically run.

## Step 2. Verify the workflow results.

1. Return to the **Lifecycle Workflows (Preview)** left hand pane and select **Workflows (Preview).**

1. In the right pane select the *Real-time employee termination* workflow you created in step 1.

   ![Graphical user interface, application Description automatically generated](img/govlcw.003.png)

1. In the **Overview (Preview)** page you should see that the **Total processed users** tile shows a value of 1.

   ![Graphical user interface, application Description automatically generated](img/govlcw.004.png)

1. Click the **View users** link in the **Total process users** tile to bring up the workflow history where you should see the details about the actions performed against the user you chose.

   ![MISSING ALT TEXT](img/govlcw.005.png)

1. Now verify the user has been deleted by going to the **Users > All Users blade**.

1. In the **Users** blade, click **Audit Logs** in the left-hand menu where you should see an audit entry for the deletion of the user that was performed by the **AAD Lifecycle Management** actor.

   ![Graphical user interface, text Description automatically generated](img/govlcw.006.png)
