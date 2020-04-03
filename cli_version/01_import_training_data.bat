########################################################
## A. SET UP IAM RELATED 
##      1. CREATE IAM ROLE FOR Forecast
##      2. CREATE IAM POLICY FOR S3 AND ATTACH TO ABOVE IAM ROLE
## B. IMPORT TRAINING DATA
##      1. CREATE THE DATASET
##      2. GET THE DESCRIPTION OF THE DATASET
##      3. CREATE A DATASET GROUP AND ADD DATASET INTO IT
##      4. GET THE DESCRIPTION OF THE DATASET GROUP
##      5. IMPORT CSV FROM S3
##      6. CHECK THE IMPORT STATUS UNTIL STATUS IS "Active"
## C. TRAIN A PREDICTOR
##      1. 
## 
## 



########################################################
## A1 CREATE IAM ROLE FOR Forecast
aws iam create-role \
 --role-name ForecastRole \
 --assume-role-policy-document '{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":"forecast.amazonaws.com"
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
## OUTPUT:
{
    "Role": {
        "Path": "/",
        "RoleName": "ForecastRole",
        "RoleId": "AROAWBARQ753MBGAIZXFD",
        "Arn": "arn:aws:iam::414501109622:role/ForecastRole",
        "CreateDate": "2020-03-31T04:40:05Z",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "forecast.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}



########################################################
## A2 CREATE IAM POLICY FOR S3 AND ATTACH TO ABOVE IAM ROLE
aws iam put-role-policy \
  --role-name ForecastRole \
  --policy-name ForecastBucketAccessPolicy \
  --policy-document '{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "s3:Get*",
            "s3:List*",
            "s3:PutObject"
         ],
         "Resource":[
            "arn:aws:s3:::randombucketname",
            "arn:aws:s3:::randombucketname/*"
         ]
      }
   ]
}'
## OUTPUT:
{
    "Role": {
        "Path": "/",
        "RoleName": "ForecastRole",
        "RoleId": "AROAWBARQ753MBGAIZXFD",
        "Arn": "arn:aws:iam::414501109622:role/ForecastRole",
        "CreateDate": "2020-03-31T04:40:05Z",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "forecast.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}


########################################################
## B1 CREATE THE DATASET
aws forecast create-dataset \
--dataset-name electricity_demand_ds2 \
--domain CUSTOM \
--dataset-type TARGET_TIME_SERIES \
--data-frequency H \
--schema '{
  "Attributes": [
    {
      "AttributeName": "timestamp",
      "AttributeType": "timestamp"
    },
    {
      "AttributeName": "target_value",
      "AttributeType": "float"
    },
    {
      "AttributeName": "item_id",
      "AttributeType": "string"
    }
  ]
}'
## OUTPUT:
{
    "DatasetArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2"
}





########################################################
## B2 GET THE DESCRIPTION OF THE DATASET
aws forecast describe-dataset \
--dataset-arn arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2
## OUTPUT:
{
    "DatasetArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2",
    "DatasetName": "electricity_demand_ds2",
    "Domain": "CUSTOM",
    "DatasetType": "TARGET_TIME_SERIES",
    "DataFrequency": "H",
    "Schema": {
        "Attributes": [
            {
                "AttributeName": "timestamp",
                "AttributeType": "timestamp"
            },
            {
                "AttributeName": "target_value",
                "AttributeType": "float"
            },
            {
                "AttributeName": "item_id",
                "AttributeType": "string"
            }
        ]
    },
    "EncryptionConfig": {},
    "Status": "ACTIVE",
    "CreationTime": 1585631343.42,
    "LastModificationTime": 1585631343.42
}




########################################################
## B3 CREATE A DATASET GROUP AND ADD DATASET INTO IT
aws forecast create-dataset-group \
--dataset-group-name electricity_ds_group \
--dataset-arns arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2 \
--domain CUSTOM
## OUTPUT:
{
    "DatasetGroupArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-group/electricity_ds_group"
}



########################################################
## B4 GET THE DESCRIPTION OF THE DATASET GROUP
aws forecast describe-dataset-group \
--dataset-group-arn arn:aws:forecast:ap-northeast-2:414501109622:dataset-group/electricity_ds_group
## OUTPUT:
{
    "DatasetGroupName": "electricity_ds_group",
    "DatasetGroupArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-group/electricity_ds_group",
    "DatasetArns": [
        "arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2"
    ],
    "Domain": "CUSTOM",
    "Status": "ACTIVE",
    "CreationTime": 1585634803.666,
    "LastModificationTime": 1585634803.666
}





########################################################
## B5 IMPORT CSV FROM S3
aws forecast create-dataset-import-job \
--dataset-arn arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2 \
--dataset-import-job-name electricity_ds_import_job \
--data-source '{
    "S3Config": {
      "Path": "s3://randombucketname/item-demand-time-train.csv",
      "RoleArn": "arn:aws:iam::414501109622:role/ForecastRole"
    }
  }'
## OUTPUT:
{
    "DatasetImportJobArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-import-job/electricity_demand_ds2/electricity_ds_import_job"
}





########################################################
## B6 CHECK THE IMPORT STATUS UNTIL STATUS IS "Active"
aws forecast describe-dataset-import-job \
--dataset-import-job-arn arn:aws:forecast:ap-northeast-2:414501109622:dataset-import-job/electricity_demand_ds2/electricity_ds_import_job

## OUTPUT:
{
    "DatasetImportJobName": "electricity_ds_import_job",
    "DatasetImportJobArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-import-job/electricity_demand_ds2/electricity_ds_import_job",
    "DatasetArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2",
    "TimestampFormat": "yyyy-MM-dd HH:mm:ss",
    "DataSource": {
        "S3Config": {
            "Path": "s3://randombucketname/item-demand-time-train.csv",
            "RoleArn": "arn:aws:iam::414501109622:role/ForecastRole"
        }
    },
    "DataSize": 0.0009916936978697777,
    "Status": "CREATE_IN_PROGRESS",
    "CreationTime": 1585632297.026,
    "LastModificationTime": 1585632322.36
}
## OUTPUT:
{
    "DatasetImportJobName": "electricity_ds_import_job",
    "DatasetImportJobArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-import-job/electricity_demand_ds2/electricity_ds_import_job",
    "DatasetArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset/electricity_demand_ds2",
    "TimestampFormat": "yyyy-MM-dd HH:mm:ss",
    "DataSource": {
        "S3Config": {
            "Path": "s3://randombucketname/item-demand-time-train.csv",
            "RoleArn": "arn:aws:iam::414501109622:role/ForecastRole"
        }
    },
    "FieldStatistics": {
        "item_id": {
            "Count": 21813,
            "CountDistinct": 3,
            "CountNull": 0
        },
        "target_value": {
            "Count": 21813,
            "CountDistinct": 4630,
            "CountNull": 0,
            "CountNan": 0,
            "Min": "0.0",
            "Max": "209.99170812603649",
            "Avg": 50.080595324644186,
            "Stddev": 38.443862007108834
        },
        "timestamp": {
            "Count": 21813,
            "CountDistinct": 7271,
            "CountNull": 0,
            "Min": "2014-01-01T01:00:00Z",
            "Max": "2014-10-30T23:00:00Z"
        }
    },
    "DataSize": 0.0009916936978697777,
    "Status": "ACTIVE",
    "CreationTime": 1585632297.026,
    "LastModificationTime": 1585632601.142
}




















