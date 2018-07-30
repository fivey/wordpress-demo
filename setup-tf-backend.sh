#!/bin/bash

S3_BUCKET_EXISTS=$(aws s3api head-bucket --bucket ${1} > /dev/null 2>&1)$?
if [ ${S3_BUCKET_EXISTS} -ne 0 ]; then
    echo "Creating S3 bucket ${1} for Terraform backend"
    aws s3api create-bucket --bucket ${1} --region us-east-1
else
    echo "S3 bucket for Terraform backend already exists"
fi