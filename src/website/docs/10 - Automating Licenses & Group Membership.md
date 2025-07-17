---
id: license
title: Automating Group Membership & License Assignment 
sidebar_label: Automate License Assignment
slug: /license
---

Group-based licensing automatically assigns or removes licenses for a user account based on group membership. Dynamic group membership adds or removes members to a group based on user account attribute properties, such as Department or Country. 

# Lab success exit criteria

Using the Department attribute of a user, we will test automatically assigning users to a group called Sales. Group Based Licensing will then be configured to assign users an M365 license automatically if this attribute is set to a value of “Sales” on their user account. 

## Step 1. Create a new user

If you added the sample user pack after you created your sandbox tenant then these users automatically had a license assigned to them when they were created, so in order to experience group based licensing and dynamic group membership we will be creating a new user to work with instead.

1. In the **Azure Active Directory dashboard** click **Users** in the left pane.
1. Click **+ New user** and choose the **Create a new user** option.
1. In the **New user** pane, create a user called **Guy Oz**.
1. Under **Password**, select **Let me create the password**, and then enter a strong password. ***Note:*** You will be asked to change this password the first time you login with this account.
1. Under **Groups and roles** leave everything blank.
1. Under **Settings**, set the appropriate **Usage Location** relevant to you.
1. Under **Job info** add the word **Sales** to the **Department** field.
1. Click **Create** at the bottom of the page to finish creating the new user.
1. Back on the **Users** page, find Guy Oz (use the search if he doesn’t show up) and then go into the properties of the user object.
1. Click on **Groups** and verify that he is not a member of any groups.
1. Click on **Licences** and verify that he *does not* have a license assigned.

## Step 2. Create a new group

Create a new group called **Sales Team** and add a dynamic group membership rule so that user accounts with the **Department** set to **Sales** automatically become members of the Sales Team group.

1. In the Azure Active Directory dashboard click **Groups.**
1. In the **All groups** pane, select **New group**.
1. In **Group type**, select **Microsoft 365**.
1. In **Group name**, enter **Sales Team**.
1. In **Membership type**, select **Dynamic user**.
1. Click the **Add dynamic query** link under the **Dynamic user members**.
1. In the **Dynamic membership rules** pane:  
Select the **department** property.    
Select the **Equals** operator.  
1. In the **Value** box, enter **Sales** and then click **+ Add expression**.

   ![MISSING ALT TEXT](img/license.001.png)

1. Select **Save** then select **Create**.
1. Find and click on the new Sales Team group from the **All Groups** blade and then click on **Members** in the left-hand pane.
1. Under **Members** you should now see Guy Oz listed as a member of this group. Wait a few seconds and refresh if he doesn’t show up straight away.

## Step 3. Configure automatic license assignment

1. Whilst still in the properties of the **Sales Team** group that you created in Step 2, click the **Licenses** in the left-hand pane.
1. In the next pane click the **+ Assignments** button at the top and then select the **Microsoft 365 E5 Developer license** and click **Save**.

## Step 4. Validate group membership and license assignment for Guy Oz

1. Back in the **Users** pane, go into the properties of the user Guy Oz and under **Groups** you will see the Sales Team listed with **Membership Type** of “Dynamic”.
1. Under **Licenses** confirm that the Microsoft 365 E5 Developer license is assigned and note the **Assignment Paths** will show as **“Inherited (Sales Team)**” which was performed by Group Based Licensing.

**Bonus lab:** You can test setting the Department attribute to “Sales” for existing users in your tenant to add more users to the Sales Team group. If you also have a Hybrid environment setup you can test creating users in your Active Directory and setting the Department attribute to “Sales” there which Cloud Sync will then sync, and they will also then get automatically added to the Sales Team group for you. 
