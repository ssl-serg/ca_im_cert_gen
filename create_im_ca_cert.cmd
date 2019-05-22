setlocal

rem Basic settings

set PUB_PATH=pub\
set TMP_PATH=tmp\

set CRT_CA_NAME=ca_cert
set CRT_IM_NAME=ca_im_cert

set CRT_CA_DAYS=3650
set CRT_CA_IM_DAYS=3650

set CRT_CA_SUBJ="/CN=My CA"
set CRT_CA_IM_SUBJ="/CN=My IM CA"

set CRT_PKCS12_PWD=1234

mkdir %PUB_PATH%
mkdir %TMP_PATH%

mkdir %TMP_PATH%srv_db
mkdir %TMP_PATH%srv_db\\certs
mkdir %TMP_PATH%srv_db\\newcerts
echo. 2>%TMP_PATH%srv_db\\index.txt
echo 01 > %TMP_PATH%srv_db\\serial

rem Root self signed server certificate

openssl req -new -newkey rsa:2048 -nodes -keyout %TMP_PATH%%CRT_CA_NAME%.key -x509 -days %CRT_CA_DAYS% -subj %CRT_CA_SUBJ% -out %TMP_PATH%%CRT_CA_NAME%.crt -config conf_ca.config

openssl rsa  -noout -text -in %TMP_PATH%%CRT_CA_NAME%.key
openssl x509 -noout -text -in %TMP_PATH%%CRT_CA_NAME%.crt

rem Converting to pem format

openssl x509 -in %TMP_PATH%%CRT_CA_NAME%.crt -out %TMP_PATH%%CRT_CA_NAME%.der -outform DER
openssl x509 -in %TMP_PATH%%CRT_CA_NAME%.der -inform DER -out %TMP_PATH%%CRT_CA_NAME%.pem -outform PEM

rem IM's private key and Certificate Signing Request

openssl req -new -newkey rsa:2048 -nodes -keyout %TMP_PATH%%CRT_IM_NAME%.key -subj %CRT_CA_IM_SUBJ% -out %TMP_PATH%%CRT_IM_NAME%.csr -config conf_ca.config

openssl rsa -noout -text -in %TMP_PATH%%CRT_IM_NAME%.key
openssl req -noout -text -in %TMP_PATH%%CRT_IM_NAME%.csr

rem Signing a IM's Certificate Signing Request

openssl ca -in %TMP_PATH%%CRT_IM_NAME%.csr -days %CRT_CA_IM_DAYS% -cert %TMP_PATH%%CRT_CA_NAME%.pem -keyfile %TMP_PATH%%CRT_CA_NAME%.key -out %TMP_PATH%%CRT_IM_NAME%.crt -batch -config conf_ca_im.config

openssl x509 -noout -text -in %TMP_PATH%%CRT_IM_NAME%.crt

rem Converting to pem format

openssl x509 -in %TMP_PATH%%CRT_IM_NAME%.crt -out %TMP_PATH%%CRT_IM_NAME%.der -outform DER
openssl x509 -in %TMP_PATH%%CRT_IM_NAME%.der -inform DER -out %TMP_PATH%%CRT_IM_NAME%.pem -outform PEM

rem Copy certificates to public directory
type  %TMP_PATH%%CRT_CA_NAME%.pem > %PUB_PATH%%CRT_CA_NAME%.pem
type  %TMP_PATH%%CRT_IM_NAME%.key > %PUB_PATH%%CRT_IM_NAME%.key
type  %TMP_PATH%%CRT_IM_NAME%.pem > %PUB_PATH%%CRT_IM_NAME%.pem

openssl pkcs12 -export -in %TMP_PATH%%CRT_IM_NAME%.pem -inkey %TMP_PATH%%CRT_IM_NAME%.key -certfile %TMP_PATH%%CRT_CA_NAME%.pem -out %PUB_PATH%%CRT_IM_NAME%.p12 -passout pass:%CRT_PKCS12_PWD%

endlocal
