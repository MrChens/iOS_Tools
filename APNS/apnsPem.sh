#!/bin/sh
if [ $# -lt 2 ]; then
	echo ""
	echo "\t Usage:"
	echo "\t\t ./apnsPem.sh xxx.p12 xxx.pem"
	echo "\t\t the xxx.p12 is the file which you export from Keychain Access."
	echo "\t\t the xxx.pme is the file name which you generate from xxx.p12."
	exit 0
fi

INAPNSCERTP12=$1
OUTANPSCERTPEM=$2
	echo "\t Please enter your password when the p12 file is generated."
openssl pkcs12 -in $INAPNSCERTP12 -out $OUTANPSCERTPEM -nodes
