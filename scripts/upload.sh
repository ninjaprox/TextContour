#!/bin/bash

FOLDER=ios-images

objectName=$1
file=$1
bucket=$S3_BUCKET
resource="/${bucket}/${FOLDER}/${objectName}"
contentType=$2
dateValue=$(date +"%a, %d %b %Y %T %z")
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=$S3_ACCESS_ID
s3Secret=$S3_ACCESS_SECRET
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -v -i -X PUT -T "${file}" \
          -H "Host: ${bucket}.s3.amazonaws.com" \
          -H "Date: ${dateValue}" \
          -H "Content-Type: ${contentType}" \
          -H "Authorization: AWS ${s3Key}:${signature}" \
          "https://${bucket}.s3.amazonaws.com/${FOLDER}/${objectName}"
