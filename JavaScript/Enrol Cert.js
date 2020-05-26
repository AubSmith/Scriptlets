<html>

<head>

    <title>Certificate Request test</title>

</head>

<body>

  <object id="objCertEnrollClassFactory" classid="clsid:884e2049-217d-11da-b2a4-000e7bbb2b09"></object>

  <script language="javascript">


  function InstallCert()

  {

    document.write("<br>Installing certificate...");                      

    try {

    // Variables

    var objEnroll = objCertEnrollClassFactory.CreateObject("X509Enrollment.CX509Enrollment")

    var sPKCS7 = "-----BEGIN CERTIFICATE-----" +

    "MIIKFQYJKoZIhvcNAQcCoIIKBjCCCgICAQExADALBgkqhkiG9w0BBwGgggnqMIIF" +

    "QjCCBCqgAwIBAgIKYbzdPwAAAAAAVzANBgkqhkiG9w0BAQUFADBJMRMwEQYKCZIm" +

...

    "h25CSWewZhpgbZkKPATLzidc0EjrWLl74RU32HEqkl2+R7yAdBQjMQA=" +

    "-----END CERTIFICATE-----"

    objEnroll.Initialize(1); // ContextUser

    objEnroll.InstallResponse(0, sPKCS7, 6, ""); // AllowNone = 0, XCN_CRYPT_STRING_BASE64_ANY = 6

    }

    catch (ex) {

      document.write("<br>" + ex.description);

      return false;

    }

    return true;

  }

  InstallCert(); 

  </script>

</body>

</html>