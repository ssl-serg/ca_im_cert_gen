# IM CA test certificate generator (Windows Batch Script)

## Description

It creates IM CA certificate: 
<pre>CA -> IM CA</pre>

**openssl.exe** tool required to launch script !

## Settings

Look at **create_im_ca_cert.cmd** for configuration details:
<pre>
  set CRT_CA_DAYS=3650
  set CRT_CA_IM_DAYS=3650

  set CRT_CA_SUBJ="/CN=My CA"
  set CRT_CA_IM_SUBJ="/CN=My IM CA"

  set CRT_PKCS12_PWD=1234
</pre>

## Result

As result, the IM CA certificate will be created at "pub" directory:

- **ca_im_cert.key** - IM CA certificate's unencrypted key

- **ca_im_cert.p12** - pkcs#12 IM CA certificate's container with root certificate (CA) included

- **ca_im_cert.pem** - IM CA certificate in PEM form

- **ca_cert.pem** - CA certificate im PEM form
