#!env python3
import boto3
import os
import sys

aws_access_key = os.environ.get('ACCESS_KEY')
aws_secret_key = os.environ.get('SECRET_KEY')
bucket_name = os.environ.get('BUCKET_NAME')
aws_region = os.environ.get('AWS_REGION')
local_filename = sys.argv[1]

s3 = boto3.client('s3', aws_access_key_id=aws_access_key, aws_secret_access_key=aws_secret_key, region_name=aws_region)

# Upload the data to S3
s3.upload_file(local_filename, bucket_name, local_filename)

print("Data uploaded to S3.")
