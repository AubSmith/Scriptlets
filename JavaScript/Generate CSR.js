<html>

<head>

    <title>Certificate Request test</title>

</head>

<body>

  <object id="objCertEnrollClassFactory" classid="clsid:884e2049-217d-11da-b2a4-000e7bbb2b09"></object>

  <script language="javascript">


    function CreateRequest()

    {

      document.write("<br>Create Request...");                      

      try {

        // Variables

        var objCSP = objCertEnrollClassFactory.CreateObject("X509Enrollment.CCspInformation");

        var objCSPs = objCertEnrollClassFactory.CreateObject("X509Enrollment.CCspInformations");

        var objPrivateKey = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509PrivateKey");

        var objRequest = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509CertificateRequestPkcs10")

        var objObjectIds = objCertEnrollClassFactory.CreateObject("X509Enrollment.CObjectIds");

        var objObjectId = objCertEnrollClassFactory.CreateObject("X509Enrollment.CObjectId");

        var objX509ExtensionEnhancedKeyUsage = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509ExtensionEnhancedKeyUsage");

        var objExtensionTemplate = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509ExtensionTemplateName")

        var objDn = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX500DistinguishedName")

        var objEnroll = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509Enrollment")

        //  Initialize the csp object using the desired Cryptograhic Service Provider (CSP)

        objCSP.InitializeFromName("Microsoft Enhanced Cryptographic Provider v1.0");

        //  Add this CSP object to the CSP collection object

        objCSPs.Add(objCSP);

        //  Provide key container name, key length and key spec to the private key object

        //objPrivateKey.ContainerName = "AlejaCMa";

        objPrivateKey.Length = 1024;

        objPrivateKey.KeySpec = 1; // AT_KEYEXCHANGE = 1

        //  Provide the CSP collection object (in this case containing only 1 CSP object)

        //  to the private key object

        objPrivateKey.CspInformations = objCSPs;

        // Initialize P10 based on private key

        objRequest.InitializeFromPrivateKey(1, objPrivateKey, ""); // context user = 1

        // 1.3.6.1.5.5.7.3.2 Oid - Extension

        objObjectId.InitializeFromValue("1.3.6.1.5.5.7.3.2");

        objObjectIds.Add(objObjectId);

        objX509ExtensionEnhancedKeyUsage.InitializeEncode(objObjectIds);

        objRequest.X509Extensions.Add(objX509ExtensionEnhancedKeyUsage);

        // 1.3.6.1.5.5.7.3.3 Oid - Extension

        //objExtensionTemplate.InitializeEncode("1.3.6.1.5.5.7.3.3");

        //objRequest.X509Extensions.Add(objExtensionTemplate);

        // DN related stuff

        objDn.Encode("CN=alejacma", 0); // XCN_CERT_NAME_STR_NONE = 0

        objRequest.Subject = objDn;

        // Enroll

        objEnroll.InitializeFromRequest(objRequest);

        var pkcs10 = objEnroll.CreateRequest(3); // XCN_CRYPT_STRING_BASE64REQUESTHEADER = 3

        document.write("<br>" + pkcs10);

        document.write("<br>The end!");

      }

      catch (ex) {

        document.write("<br>" + ex.description);

        return false;

      }

      return true;

    }       

    CreateRequest();

  </script>

</body>

</html>