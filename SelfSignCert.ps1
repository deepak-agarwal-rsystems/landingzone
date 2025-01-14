$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=APIM-Root" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign

# New-SelfSignedCertificate -Type Custom -DnsName REBELCLIENT -KeySpec Signature `
# -Subject "CN=COPELANDCLIENT" -KeyExportPolicy Exportable `
# -HashAlgorithm sha256 -KeyLength 2048 `
# -CertStoreLocation "Cert:\CurrentUser\My" `
# -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

New-SelfSignedCertificate -Type Custom -DnsName "*.dns-z-cplugw-p.com","dns-z-cplugw-p.com" -KeySpec Signature `
-Subject "CN=APIM-Prod" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

New-SelfSignedCertificate -Type Custom -DnsName "*.dns-z-cplugw-p.com","dns-z-cplugw-p.com" -KeySpec Signature `
-Subject "CN=APIM-Developer-Prod" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")