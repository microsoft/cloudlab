---
id: pswdlesscba
title: Passwordless with Certificate Based Authentication 
sidebar_label: Certificate Based Auth
slug: /pswdlesscba
---

**Certificate Based Authentication** (CBA) is a new addition to our suite of passwordless offering’s that Microsoft Entra natively supports. It is a phish-resistant credential and is a critical use case for highly regulated industries that need to comply with the Presidential Executive Order on cybersecurity. 

CBA enables customers to authenticate directly against Microsoft Entra ID with an X.509 certificate that is issued from their own Public Key Infrastructure (PKI).

When a user is enabled for CBA the sign in flow works like this.

1. User selects the “Use a certificate or smartcard” link on the login page. 
1. The client is redirected to the endpoint [https://certauth.login.microsoftonline.com](https://certauth.login.microsoftonline.com/).
1. The endpoint performs TLS mutual authentication and requests the client certificate as part of the TLS handshake.
1. The user picks the client certificate to complete the sign-in.

Setting up CBA itself in Microsoft Entra is quite straightforward, but it does have a dependency on an on-premises PKI infrastructure which can be relatively complex to setup, and which of course requires a Hybrid identity environment. For this lab we can drop the PKI requirement and configure and test CBA by using PowerShell to generate a self-signed Certificate Authority and self-signed user certificates. This approach has the added benefit of allowing cloud-only deployments to test out and use CBA (for lab purposes only of course).

# Lab success exit criteria

Using the *New-SelfSignedCertificate* cmdlet you will create a Root Certificate Authority certificate and then upload this to Microsoft Entra ID and then enable the Cert Based Auth method policy. You will then create a User Client certificate that is signed by the same Root Certificate Authority and place this into the certificate store on your host machine allowing you to then test signing in to Microsoft Entra with this user cert.

## Step 1. Create the Root Certificate Authority and User certificate

These steps are performed on your host machine.

1. Open an administrator elevated PowerShell session and copy and paste the following code and run it. 

   **Note:** Do not close this PowerShell session as we need it to create the user certificate in Step 2 using the contents in the *$certprod* variable.

|<p><br/>$certprod = New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN=TestRootCA" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\LocalMachine\My" -KeyUsageProperty Sign -KeyUsage CertSign </p>|
| :- |

This just created a Root Certificate called “TestRootCA” in the *Local Computer Certificate Store* of your machine. You can verify this by running **certlm.msc** from ***Start/Run*** and expanding the **Personal/Certificates** folder.

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesscba.001.png)

1. Whilst still in *Local Computer Certificate Store* we need to export the TestRootCA to a file so it can be uploaded to Microsoft Entra ID. To do this:    
Right click on the TestRootCA object and choose **All Tasks > Export**  
Click **Next** on the **Certificate Export Wizard** page    
Click **Next** on the **Export Private Key** page leave it set to **No**   
On the **Export File Format** page leave it set on *DER encoded binary X.509*    
On the **File to Export** page call the file *TestRootCA.cer* and save it to C:\Temp  
Click **Next**, and **Finish**.

1. We will now create the user certificate which will be signed by the Root CA certificate that we created in the previous step. Return to the PowerShell session and copy and paste the following code and run it.   
**Note:** Before running this script, you will need to change the upn= value to that of your test user. All other parameters can be left alone.

|<p><br/>New-SelfSignedCertificate -Type Custom -Subject "TestUserCertForCBA" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=bobby@ztlabguide.onmicrosoft.com","2.5.29.32={text}OID=1.2.3.4.5&OID=1.2.3.4") -KeyUsage DigitalSignature -KeyAlgorithm ECDSA\_nistP256 -CurveExport CurveName -CertStoreLocation "Cert:\CurrentUser\My" -Signer $certprod -KeyExportPolicy Exportable </p>|
| :- |

This script created a user certificate called “TestUserCertForCBA” located in the *Personal Certificate Store* of your machine. You can verify this by running **certmg.msc** (from an elevated PowerShell session) and then expand the **Personal/Certificates** folder.

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesscba.002.png)

## Step 2. Create your Certificate Authority in Microsoft Entra

1. Log into the <https://entra.microsoft.com>  
1. Click **Azure Active Directory** > **Security** **> Certificate authorities**
1. Click the **Upload** button at the top of the page    
Select the CA file *TestRootCA.cer* that we exported in Step 1    
Select **Yes** for *Is root CA Certificate*  
Leave both the Certificate Revocation List URL’s blank   
Click **Add**

   ![Graphical user interface, text, application, email Description automatically generated](img/pswdlesscba.003.png)

You’re TestRootCA object should now appear as a Certificate Authority

   ![MISSING ALT TEXT](img/pswdlesscba.004.png)

## Step 3. Enable Certificate Based Authentication method

1. Select **Azure Active Directory** > **Security** 
1. Select **Authentication methods** **> Policies >** **Certificate-based Authentication**
1. Under **Basics**, select **Yes** to enable CBA
1. Leave the **Target** to **All Users.**

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesscba.005.png)

1. Click the **Configure** tab
1. Set *Protection Level* to **Multi-factor authentication** and click **Save.**

   ![Graphical user interface, text, application Description automatically generated](img/pswdlesscba.006.png)

As our Conditional Access policies require all users to perform MFA, leaving Certificate-based Authentication set to Single-factor would result in a failure to sign-in for those users who are not in possession of a certificate.

## Step 4. Test signing in with a certificate

1. Open an In-Private Edge session and navigate to <https://myapps.microsoft.com> 
1. Enter in the UPN of the user you created a certificate for in Step 1.
1. After clicking **Next,** you should get a *“Select a certificate for authentication”* prompt and where you should see the certificate that we created in Step 1 presented here as selectable.
1. Select the certificate and the click **OK** to complete the sign-in.

   ![Graphical user interface, application, Teams Description automatically generated](img/pswdlesscba.007.png)

If you are testing with a user that was configured to use Phone sign-in, then you will first have to click the **“Other ways to sign in”** link to then use the certificate.

   ![Graphical user interface, application Description automatically generated](img/pswdlesscba.008.png)
