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

	#Generate private key + CSR file
	openssl req -new -nodes -out tmp/certreq.pem -keyout tmp/privkeyreq.pem -config ./openssl.cnf -subj /CN=$name

	#Sign certificate
	openssl ca -batch -extensions v3_req -outdir ./tmp/ -out ./tmp/cert.pem  -config ./openssl.cnf -cert `echo $caCertFolder`ca-public.pem -keyfile `echo $caCertFolder`ca-private.pem -infiles tmp/certreq.pem

	#Move newly generated certificate
	targetDir=`echo $destination``echo $name`
	mkdir -p $targetDir
	mv ./tmp/cert.pem `echo $targetDir`/public.pem
	mv ./tmp/certreq.pem `echo $targetDir`/request.pem
	mv ./tmp/privkeyreq.pem `echo $targetDir`/private.pem
	cp `echo $caCertFolder`ca-chain.pem  `echo $targetDir`/chain.pem

	#Empty temporary directory
	rm `echo $opensslConfigDir`tmp/*.pem
done;

#Empty database
rm `echo $opensslConfigDir`index.tx*
touch `echo $opensslConfigDir`index.txt
