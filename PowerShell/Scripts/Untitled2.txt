$def = @"
public class ClientCertWebClient : System.Net.WebClient
{
    System.Net.HttpWebRequest request = null;
    System.Security.Cryptography.X509Certificates.X509CertificateCollection certificates = null;

     protected override System.Net.WebRequest GetWebRequest(System.Uri address)
     {
         request = (System.Net.HttpWebRequest)base.GetWebRequest(address);
         if (certificates != null)
         {
             request.ClientCertificates.AddRange(certificates);
         }
         return request;
     }

     public void AddCerts(System.Security.Cryptography.X509Certificates.X509Certificate[] certs)
     {
         if (certificates == null)
         {
             certificates = new System.Security.Cryptography.X509Certificates.X509CertificateCollection();
         }
         if (request != null)
         {
             request.ClientCertificates.AddRange(certs);
         }
         certificates.AddRange(certs);
     }
 }
"@



Add-Type -TypeDefinition $def



$wc = New-Object ClientCertWebClient
$certs = dir cert:\CurrentUser\My
$wc.AddCerts($certs)
$wc.DownloadString("https://www.facebook.com")