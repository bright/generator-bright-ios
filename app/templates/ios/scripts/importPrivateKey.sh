#!/bin/sh

set -e
set -o pipefail

openssl x509 -inform der -in certs/dist.cer -out certs/dist.pem

key4cert certs/dist.cer > certs/private.pem

openssl pkcs12 -export -in certs/dist.pem -inkey certs/private.pem -out certs/certs.p12 -password pass:12345

rm certs/dist.pem
rm certs/private.pem
