"""
Using Python and Boto3

- Extract: Read raw fish market data from "python" area of the bucket (https://eu-central-1.console.aws.amazon.com/s3/buckets/data-eng-resources?region=eu-central-1&prefix=python/&showversions=false)

- Transform: Aggregate the dataset by fish species and compute average values for: weight, length, height, width

Load: Save the transformed dataset back into S3 under the path:
"data-eng-resources/se-data-folder/fish/your-name"
"""
import boto3
import pandas as pd
import io 
from botocore.exceptions import ClientError

BUCKET_NAME = 'data-eng-resources'
REGION = 'eu-central-1'
SOURCE_KEY = 'python/fish-market.csv' 
DESTINATION_KEY = 'se-data-folder/fish/louis/aggregated_fish_data.csv'
    

class ETLPipeline:
    def __init__(self):
        self.s3_client = boto3.client('s3', region_name=REGION)
        self.s3_resource = boto3.resource('s3', region_name=REGION)

    def read_fish(self):
        try: 
            response = self.s3_client.get_object(Bucket=BUCKET_NAME, Key=SOURCE_KEY)
            raw_data = response['Body'].read()
            df = pd.read_csv(io.BytesIO(raw_data))
            return df 
        
        except ClientError as e:
            print(f"Error: {e}")
            return
        
    def transform_fish(self, raw_df): 
        transformed_df = raw_df.groupby('Species', as_index=False)[['Weight', 'Length1', 'Length2', 'Length3', 'Height', 'Width']].mean()
        return transformed_df
    
    def load_fish(self, transformed_df):
        try:
            csv_buffer = io.StringIO()
            transformed_df.to_csv(csv_buffer, index=False)

            self.s3_client.put_object(Bucket=BUCKET_NAME, 
                Key=DESTINATION_KEY, 
                Body=csv_buffer.getvalue()
                )
            
            return True
        
        except ClientError as e:
            print(f"Error: {e}")
            return False
        
        
    def run(self):
        try:
            raw_df = self.read_fish()
            
            processed_df = self.transform_fish(raw_df)
            
            success = self.load_fish(processed_df)

            return success

        except Exception as e:
            print(f"Pipeline aborted early: {e}")
            return False
        
if __name__=='__main__':
    pipeline = ETLPipeline()
    pipeline.run()