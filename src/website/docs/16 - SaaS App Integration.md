---
id: saasapp
title: SaaS App Integration for Single Sign-on
sidebar_label: SaaS App Integration
slug: /saasapp
---

Single sign-on is an authentication method that allows users to sign-in to multiple independent software systems using one set of credentials. Microsoft Entra facilitates this through federated SSO, where the user first signs into Microsoft Entra ID, and then they are seamlessly signed into the target SaaS application. SaaS application integration in Microsoft Entra is performed by adding the application as an Enterprise App, either manually, or through the Application Gallery which contains thousands of 3rd party applications that can be added and configured with Microsoft Entra via a few simple steps.

   ![A picture containing diagram Description automatically generated](img/saasapp.001.png)

There are many thorough [tutorials](https://learn.microsoft.com/azure/active-directory/saas-apps/tutorial-list) on how to integrate SaaS applications with Microsoft Entra, but all of them require a subscription for each SaaS application which can complicate getting things setup and maintained. The notable exceptions are [ServiceNow](https://learn.microsoft.com/azure/active-directory/saas-apps/servicenow-tutorial) and [AWS](https://learn.microsoft.com/azure/active-directory/saas-apps/amazon-web-service-tutorial), where you can setup and create free subscriptions to each service and then wire those up to your tenant. For this lab however I’m going to provide guidance on setting up SSO using a simple service called Claims X-Ray from the <https://adfshelp.microsoft.com/> website. This site was created to assist in debugging and troubleshooting problems with claims issuance with AD FS. The app allows you to view the output of the claims emitted in the token for the user and will simulate the SSO experience.

## Lab success exit criteria

After adding the test application “Claims X-Ray” to your tenant via the Application Gallery, your Microsoft Entra users will be able to SSO to this application using the MyApps portal, and you will be able to view the detailed claims contained in the token that was issued by Microsoft Entra.

## Step 1.  Add the Microsoft Entra SAML Toolkit application to your tenant

1. Sign-in to the Microsoft Entra admin center <https://entra.microsoft.com>
1. Browse to **Azure Active Directory** > **Enterprise Applications** > **All applications**
1. Click the **+ New application** link at the top of the page.
1. On the next screen search choose the **+ Create your own application**
1. In the right-hand **Create your own application** flyout pane, call your app “Claims X-Ray” and select the radio button **Integrate any other application you don't find in the gallery (Non-gallery).** Click** the **Create** button at the bottom of the page to add the app to your tenant.

   ![MISSING ALT TEXT](img/saasapp.002.png)

1. The app will be created and you will be taken to the new apps configuration page.
1. Under the **Manage** section in the left menu for the new app, select **Single sign-on** to open the **Single sign-on** pane for editing.
1. Under **Select a Single Sign-On Method** select the **SAML** tile** to open the SSO configuration page. 
1. On the **Set up Single Sign-On with SAML** page you will need to edit the 2 required fields in the **Basic SAML Configuration** tile.

   ![Graphical user interface, text Description automatically generated with medium confidence](img/saasapp.003.png)

1. In the **Identifier (Entity ID)** text box, click **Add Identifier** and then type ClaimsXRay 
1. In the **Reply URL** text box, click **Add Reply URL** and then type <https://adfshelp.microsoft.com/ClaimsXray/TokenResponse>
1. Leave **Sign on URL**, **Relay State** and **Logout URL** blank
1. Click **Save**.

   ![Graphical user interface, text, application Description automatically generated](img/saasapp.004.png)

## Step 2. Assign a user to the app.

1. Whilst still in the properties of the new Claims X-Ray app in the portal.
1. In the left-hand pane under the **Manage** section, select **Users and groups**.
1. Select **Add user**, then select **Users and groups** in the **Add Assignment** dialog.
1. In the **Users and groups** dialog, select either a user or a group that you would like to use to grant access to the application and then click the **Select** button at the bottom of the screen.
1. Under **Select a role** leave it as "User"
1. Click the **Assign** button.

## Step 3. Test single sign-on to the app.

1. Open a new In-Private Edge session and brows to <https://myapps.microsoft.com> and login as the user you just assigned to the Claims X-Ray app in Step 2.

1. In the MyApps portal you should see the new Claims X-Ray app, click on it to initiate the SSO experience.

   ![Graphical user interface, application Description automatically generated](img/saasapp.005.png)

1. This will redirect you to <https://adfshelp.microsoft.com/ClaimsXray/TokenResponse> where you can see the token claims that Microsoft Entra emitted for the user.

   ![Graphical user interface, text, application, email Description automatically generated](img/saasapp.006.png)

## Step 4. Add a new claim to issue

Microsoft Entra allows you to customise the claims that can be included in the token that is used by SaaS applications. In this lab we will configure a new group claim which will include the user’s group membership in the token. We will view the output of this new claim via the Claims X-Ray app.

1. In the Microsoft Entra admin center <https://entra.microsoft.com>
1. Browse to **Azure Active Directory** > **Enterprise Applications** > **All applications**
1. Find the Claims X-Ray you just added and click on it.
1. Under the **Manage** section in the left menu, select **Single sign-on** to open the **Single sign-on** pane for editing.
1. Click on the edit button in the **Attributes & Claims** tile.
1. Click the **+ Add a group claim** button at the top
1. In the right-hand pane that opened select **All Groups** radio button
1. In the Source attribute drop down list leave it on Group ID** and click **Save.**

**Note:** You will need to ensure that your test user is a member of at least one group for this to work. If they are not a member of any groups then go to the **Azure Active Directory** > **Groups** blade and add them to a group.

## Step 5. Testing the group claim

1. Open a new In-Private Edge session and browse to <https://myapps.microsoft.com> and login as the user you are testing with (that is a member of a group).
1. In the MyApps portal click on the Claims X-Ray app to SSO to the app.
1. In the Token Claims output at <https://adfshelp.microsoft.com/ClaimsXray/TokenResponse> you should now see the Groups included in the token.

   ![MISSING ALT TEXT](img/saasapp.007.png)
