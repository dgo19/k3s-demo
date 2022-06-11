# CA for internal certificates
We are using an internal CA for our certificates. You can find the CA for the internal certificates here.\
!!! DO NOT ADD PRIVATE KEYS OR CREDENTIALS TO A PUBLIC GIT REPO !!!\
## create CA certificate and key
```
$ openssl genrsa -aes256 -out ca.key -passout "pass:k3sdemo" 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
......++++
...................................................................................................................................................................................++++
e is 65537 (0x010001)
$ openssl req -key ca.key -new -x509 -days 3650 -sha512 -extensions v3_ca -out ca.crt -config openssl-ca.conf -passin pass:k3sdemo
```
