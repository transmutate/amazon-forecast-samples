########################################################
## 1. CREATE THE FORECAST
## 2. RETRIEVE SOME FORECAST RESULTS
## 3. EXPORT THE WHOLE FORECAST RESULT TO S3



########################################################
## 1. CREATE THE FORECAST
aws forecast create-forecast \
--forecast-name electricityforecast \
--predictor-arn arn:aws:forecast:ap-northeast-2:414501109622:predictor/electricitypredictor
## OUTPUT:
{
    "ForecastArn": "arn:aws:forecast:ap-northeast-2:414501109622:forecast/electricityforecast"
}

## 1.a) CHECK CREATION PROCESS
aws forecast describe-forecast \
--forecast-arn arn:aws:forecast:ap-northeast-2:414501109622:forecast/electricityforecast \






########################################################
## 2. RETRIEVE SOME FORECAST RESULTS
aws forecastquery query-forecast \
--forecast-arn arn:aws:forecast:ap-northeast-2:414501109622:forecast/electricityforecast \
--start-date 2014-10-31T00:00:00 \
--end-date   2014-10-31T02:00:00 \
--filters '{"item_id":"client_111"}'






########################################################
## 3. EXPORT THE WHOLE FORECAST RESULT TO S3
aws forecast create-forecast-export-job \
--forecast-export-job-name electricityforecast_exportjob \
--forecast-arn arn:aws:forecast:ap-northeast-2:414501109622:forecast/electricityforecast \
--destination S3Config="{Path='s3://randombucketname',RoleArn='arn:aws:iam::414501109622:role/ForecastRole'}"
## OUTPUT:
{
    "ForecastExportJobArn": "arn:aws:forecast:ap-northeast-2:414501109622:forecast-export-job/electricityforecast/electricityforecast_exportjob"
}


