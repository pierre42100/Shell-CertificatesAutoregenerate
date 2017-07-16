#!/bin/bash

#File configuration (define paths)
destination="/home/pierre/Documents/projets_shell/auto-regenerate/certificates/"
domainsList="/home/pierre/Documents/projets_shell/auto-regenerate/certificates.txt"
caCertFolder="/home/pierre/Documents/projets_shell/auto-regenerate/config/ca-cert/"
opensslConfigDir="/home/pierre/Documents/projets_shell/auto-regenerate/config/"

#Change current folder to avoid errors
cd $opensslConfigDir

#Process each domain
for name in $(cat $domainsList) ; do

	#Inform user about what's happening
	echo "Generate certificate for domain: " $name;

	#Create temporary openssl configuration file
	cp openssl.cnf tmp/openssl.tmp.cnf

	#Complete temporary OpenSSL configuration file
	echo "DNS.1 = "`echo $name` >> tmp/openssl.tmp.cnf

	#Generate private key + CSR file
	openssl req -new -nodes -out tmp/certreq.pem -keyout tmp/privkeyreq.pem -config ./tmp/openssl.tmp.cnf -subj /CN=$name

	#Sign certificate
	openssl ca -batch -extensions v3_req -outdir ./tmp/ -out ./tmp/cert.pem  -config ./tmp/openssl.tmp.cnf -cert `echo $caCertFolder`ca-public.pem -keyfile `echo $caCertFolder`ca-private.pem -infiles tmp/certreq.pem

	#Move newly generated certificate
	targetDir=`echo $destination``echo $name`
	mkdir -p $targetDir
	mv ./tmp/cert.pem `echo $targetDir`/public.pem
	mv ./tmp/certreq.pem `echo $targetDir`/request.pem
	mv ./tmp/privkeyreq.pem `echo $targetDir`/private.pem
	cp `echo $caCertFolder`ca-chain.pem  `echo $targetDir`/intermediate.pem

	#Empty temporary directory
	rm `echo $opensslConfigDir`tmp/*.pem

	#Remove temporary configuration
	rm tmp/openssl.tmp.cnf
done;

#Empty database
rm `echo $opensslConfigDir`index.tx*
touch `echo $opensslConfigDir`index.txt

#Done message
echo "Certificates successfully generated !"