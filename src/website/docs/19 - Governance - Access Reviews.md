---
id: govaccrev
title: Access Reviews 
sidebar_label: Access Reviews
slug: /govaccrev
---

Access reviews work by asking a user, a decision maker, or both, to review and recertify to continued access to a given resource. Reviewers can make decisions on each user's need for continued access based either on suggestions from Microsoft Entra or their own input. When an access review is completed, it can then act on the required changes automatically for you. This works equally well for both members of the tenant, and for guests.

## Lab success exit criteria.

Building on the previous Entitlement Management lab, we will create an access review that will target the guest user (your Microsoft FTE account) and request that you confirm that you still need access to the Partner Collaboration Team. We will choose NO to needing continued access to show how access reviews can then remove permissions and group membership to the resource.

## Step 1. Create the access review. 

1. Navigate to **Azure Active Directory > Identity Governance > Access Reviews**.
1. Select + **New access review** button.
1. Under **Review type** set the following:
   -  **Select what to review:** Teams + Groups
   - **Review scope:** Select Tams + groups
   - **Group:** Find and add the *Partner Collaboration* group
   - **Scope:** Guest users only
   - **Inactive users (on tenant level) only**: Leave unchecked
   - Click **Next: Reviews** 
1. Under **Reviews** set the following:
   - **Multi-state review:** Leave unchecked
   - **Specify reviewers** > **Select reviewers:** Users review their own access
   - **Specific recurrence of review**
      - **Duration (in days):** 1
      - **Review recurrence:** One time
      - **Start date:** Todays date
1. Click **Next: Settings**. Under **Settings** set the following:
   -  **Auto apply results to resource:** Check this box
   - **If reviewers don’t respond:** Remove access
   - **Action to apply on denied guest user:** Remove user’s membership from the resource
   - **At the end of the review, send notifications to:** Add your Global Admin
   - Leave the remaining settings as default.
1. Click Next: **Review + Create.**
1. Name the review **“Review Guest Access”** and then click the **Create** button at the bottom of the page.
1. After the access review has been created you’ll be returned to the Access reviews dashboard where the review should show up and the status should move from **Not Started** to **Active**.

   ![Graphical user interface, text, application Description automatically generated](img/govaccrev.001.png)

## Step 2. Complete the access review as the Guest.

1. In your Microsoft FTE Outlook inbox should be a mail from Microsoft Azure with the subject line **Action required: Review access by __date__**

   ![Graphical user interface, text, application, email Description automatically generated](img/govaccrev.002.png)**

1. Click the **Review access** button to begin the access review process. 
1. This will take you to the My Access portal/Access reviews after you perform MFA.
1. You’ll then be asked if you still need access to the Partner Collaboration group.
1. Select **No** and provide a reason and then click **Submit**.

   ![Graphical user interface, text, application Description automatically generated](img/govaccrev.003.png)

## Step 3. Verify and stop the access review to apply the changes.

1. As your Global Admin, return to the **Azure Active Directory > Identity Governance > Access Reviews** and click on the **Review Guest Access** review that we created in Step 1.
1. In the **Access review details** page, under **Manage**, click the **Results** and you should see the response to your completion of the review that you performed using your Microsoft FTE account, with the outcome showing as Denied

   ![Graphical user interface, application, Word Description automatically generated](img/govaccrev.004.png)

1. Return to the **Overview** section and then click the Stop button at the top.

   ![Graphical user interface, application Description automatically generated](img/govaccrev.005.png)

Stopping the review applies the changes captured by the review, which in this case removes your Microsoft FTE Guest account from the *Partner Collaboration* group as you responded that you no longer needed access.    
You can validate this by going to **Groups > All Groups > Partner Collaboration** and in the **Members** section your @microsoft.com account should no longer be present. 

## Step 4. Leave the inviting Organization.

Using your Microsoft FTE account, you will now initiate removing yourself as a Guest from the test tenant by using the *Leave* feature from the My Account portal.

1. Log onto <https://myaccount.microsoft.com/organizations>
1. Under **Other organizations you collaborate with**, click the **Leave** button next to your test tenant to initiate the leave process.

   ![Graphical user interface, text, application, email Description automatically generated](img/govaccrev.006.png)

1. At the next screen confirm the removal by clicking the **Leave** button.

   ![Graphical user interface, text, application Description automatically generated](img/govaccrev.007.png)

   ![Graphical user interface, text, application Description automatically generated](img/govaccrev.008.png)

1. This process also deletes your Guest account from the test tenant.
