#cloud-boothook
# JFI, By default, cloud-boothook user data is run at every instance boot.
#!/bin/bash

domain=""   # your domain
name="@"     # name of A record to update
key=""      # key for godaddy developer API
secret=""   # secret for godaddy developer API

headers="Authorization: sso-key $key:$secret"

 echo $headers

 result=$(curl -s -X GET -H "$headers" \
 "https://api.godaddy.com/v1/domains/$domain/records/A/$name")

dnsIp=$(echo $result | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

# Get public ip address. 169.254.169.254 is used in Amazon EC2 and other cloud computing platforms to distribute metadata to cloud instances
res=$(curl -s GET "http://169.254.169.254/latest/meta-data/public-ipv4")
currentIp=$(echo $res | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

if [ $dnsIp != $currentIp ];
 then
	echo "Ips are not equal"
	request='[{"data":"'$currentIp'","ttl":600}]'

	nresult=$(curl -i -s -X PUT \
 -H "$headers" \
 -H "Content-Type: application/json" \
 -d $request "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
fi