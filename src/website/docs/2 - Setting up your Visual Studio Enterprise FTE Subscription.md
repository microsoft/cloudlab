---
id: vssub
title: Setting up your Visual Studio FTE subscription 
sidebar_label: Visual Studio Subscription
slug: /vssub
---

# Lab success exit criteria

At the end of this lab guide you will have successfully activated your Visual Studio Enterprise benefit using your corporate Microsoft account (@microsoft.com) ***and*** created a new Azure Subscription that is linked to your personal MSA account (@outlook.com).

## Step 1. Visual Studio Subscription Activation 

1. To activate your Visual Studio Enterprise Subscription, you first need to login to <https://my.visualstudio.com> using your corporate Microsoft FTE account (<you@microsoft.com>).

1. Next you will need to link your personal MSA account to this newly activated Visual studio subscription. This step is necessary so you can then access your Azure subscription benefit via <https://portal.azure.com> with an account other your FTE one.

1. To add an alternate account, navigate to the **Subscriptions** tab.

   ![MISSING ALT TEXT](img/vssub.001.png)

1. Then find the **Alternate account** section at the bottom of the page and enter your personal MSA account (<you@outlook.com>). 

   ![Graphical user interface, textDescription automatically generated](img/vssub.002.png)

1. Navigate back to the **Benefits** tab and ensure that you see a small note indicating that your account has been linked. 

   ![MISSING ALT TEXT](img/vssub.003.png)

1. Whilst still on the **Benefits** tab you should see an **Azure** featured benefit tile with the **Activate** button in it like below. Click **Activate**.

   ![MISSING ALT TEXT](img/vssub.004.png)

1. This should pop-up a new window indicating that you will need to activate the monthly credit with your personal MSA account that you added in Step 2. Click **Next**.

   ![Graphical user interface, applicationDescription automatically generated](img/vssub.005.png)

1. **Copy** the **activation URL** and **save** it to a temporary location.

   ![Graphical user interface, text, application, emailDescription automatically generated](img/vssub.006.png)

1. Next open an **incognito** or **InPrivate** browser session and sign-in to <https://my.visualstudio.com/> with your linked personal account from Step 2.
1. **Copy and paste** the saved **activation URL** into this new browser session to activate your Azure subscription benefit against your personal MSA account.
1. After the activation has been completed you should now see a new Visual Studio Enterprise Subscription showing from within <https://portal.azure.com> when logged in with your personal MSA account.

   ![Graphical user interface, text, application, emailDescription automatically generated](img/vssub.007.png)

**Tip:**
If you don’t use an in-private session when navigating to <https://portal.azure.com> you will always be logged into the Azure portal with your corporate you@microsoft.com account which means landing into your default FTE Azure subscription, which is obviously cumbersome and undesirable for this lab. To rectify this, I highly recommend setting up a new profile in Edge for your personal account (that you used in Step 3) so that you can easily switch between accounts to use the Azure portal without having to resort to in-private browser sessions, with the added benefit that your credentials are also saved for each Edge profile so you can get SSO when you switch between profiles. 

See [Sign in and create multiple profiles in Microsoft Edge](https://support.microsoft.com/en-us/topic/sign-in-and-create-multiple-profiles-in-microsoft-edge-df94e622-2061-49ae-ad1d-6f0e43ce6435#:~:text=With%20the%20Edge%20browser%20launched%2C%20select%20Profile%20%3E,extensions.%20Select%20Profile%2C%20then%20choose%20Manage%20profile%20settings.) for more details.