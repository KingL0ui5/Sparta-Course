"""
Note: If you cannot create your own bucket, use the "data-eng-resources" bucket. Make sure to use the naming convention "se-data-folder/..." when you upload data.

Do not try to delete the bucket!

- Create a bucket with boto3
- Read data from the "data-eng-resources" bucket
- Upload data to your bucket
- Delete data from your bucket
- Delete your bucket (if you were able to make your own)
"""
import boto3
import pprint as pp 
from botocore.exceptions import ClientError



class BucketManager: 
    def __init__(self, region = 'eu-west-1', bucket_name = 'se-louis-bucket'):
        self.s3_client = boto3.client('s3', region_name=region)
        self.s3_resource = boto3.resource('s3', region_name=region)
        self.location = {'LocationConstraint': region}
        self.bucket_name = bucket_name

    def create_bucket(self):
        try:
            self.s3_client.create_bucket(
                Bucket=self.bucket_name,
                CreateBucketConfiguration=self.location
            )
            return True

        except ClientError as e:
            print(f"Error: {e}")
            return False

        
    def upload_object(self, key, path): 
        try: 
            self.s3_client.upload_file(
                Filename=path, 
                Bucket=self.bucket_name, 
                Key=key
            )

            return True 
        
        except ClientError as e:
            print(f"Error: {e}")
            return False
    
    
    def read_object(self, key): 
        try: 
            response = self.s3_client.get_object(Bucket=self.bucket_name, Key=key)
            content = response['Body'].read().decode('utf-8')
            return content
        
        except ClientError as e:
            print(f"Error: {e}")
            return False
    
    def put_object(self, key, body):
        try:
            self.s3_client.put_object(Bucket=self.bucket_name, 
                Key=key, 
                Body=body
                )
            
            return True
        
        except ClientError as e:
            print(f"Error: {e}")
            return False
        

    def delete_object(self, key):
        try: 
            self.s3_client.delete_object(
            Bucket=self.bucket_name,
            Key=key
            )

            return True
        
        except ClientError as e:
            print(f"Error: {e}")
            return False

    def delete_bucket(self):
        """
        reminder: all objects must be deleted first
        """
        try:
            self.s3_client.delete_bucket(
                Bucket=self.bucket_name
            )
            return True 

        except ClientError as e:
            print(f"Error: {e}")
            return False
        

if __name__ == '__main__': 
    server = BucketManager()
    server.delete_bucket()

    