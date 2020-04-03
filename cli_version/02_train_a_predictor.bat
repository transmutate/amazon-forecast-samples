########################################################
## 1. CREATE DA PREDICTOR
## 2. GET THE PREDICTOR STATUS
## 3. GET THE ACCURACY METRIC FOR THE PREDICTOR
 





########################################################
## 1. CREATE DA PREDICTOR
aws forecast create-predictor \
--predictor-name electricitypredictor \
--algorithm-arn arn:aws:forecast:::algorithm/Deep_AR_Plus \
--input-data-config DatasetGroupArn="arn:aws:forecast:ap-northeast-2:414501109622:dataset-group/electricity_ds_group" \
--forecast-horizon 20 \
--featurization-config '{
    "ForecastFrequency": "H"
  }'
## OUTPUT:
{
    "PredictorArn": "arn:aws:forecast:ap-northeast-2:414501109622:predictor/electricitypredictor"
}



########################################################
## 2. GET THE PREDICTOR STATUS
aws forecast describe-predictor \
--predictor-arn arn:aws:forecast:ap-northeast-2:414501109622:predictor/electricitypredictor
## OUTPUT:

{
    "PredictorArn": "arn:aws:forecast:ap-northeast-2:414501109622:predictor/electricitypredictor",
    "PredictorName": "electricitypredictor",
    "AlgorithmArn": "arn:aws:forecast:::algorithm/Deep_AR_Plus",
    "ForecastHorizon": 20,
    "PerformAutoML": false,
    "PerformHPO": false,
    "TrainingParameters": {
        "context_length": "40",
        "epochs": "500",
        "learning_rate": "1E-3",
        "learning_rate_decay": "0.5",
        "likelihood": "student-t",
        "max_learning_rate_decays": "0",
        "num_averaged_models": "1",
        "num_cells": "40",
        "num_layers": "2",
        "prediction_length": "20"
    },
    "EvaluationParameters": {
        "NumberOfBacktestWindows": 1,
        "BackTestWindowOffset": 20
    },
    "InputDataConfig": {
        "DatasetGroupArn": "arn:aws:forecast:ap-northeast-2:414501109622:dataset-group/electricity_ds_group"
    },
    "FeaturizationConfig": {
        "ForecastFrequency": "H",
        "Featurizations": [
            {
                "AttributeName": "target_value",
                "FeaturizationPipeline": [
                    {
                        "FeaturizationMethodName": "filling",
                        "FeaturizationMethodParameters": {
                            "aggregation": "sum",
                            "backfill": "zero",
                            "frontfill": "none",
                            "middlefill": "zero"
                        }
                    }
                ]
            }
        ]
    },
    "PredictorExecutionDetails": {
        "PredictorExecutions": [
            {
                "AlgorithmArn": "arn:aws:forecast:::algorithm/Deep_AR_Plus",
                "TestWindows": [
                    {
                        "TestWindowStart": 1414641600.0,
                        "TestWindowEnd": 1414713600.0,
                        "Status": "ACTIVE"
                    }
                ]
            }
        ]
    },
    "DatasetImportJobArns": [
        "arn:aws:forecast:ap-northeast-2:414501109622:dataset-import-job/electricity_demand_ds2/electricity_ds_import_job"
    ],
    "AutoMLAlgorithmArns": [
        "arn:aws:forecast:::algorithm/Deep_AR_Plus"
    ],
    "Status": "ACTIVE",
    "CreationTime": 1585708206.263,
    "LastModificationTime": 1585710113.107
}





########################################################
## 3. GET THE ACCURACY METRIC FOR THE PREDICTOR
aws forecast get-accuracy-metrics \
--predictor-arn arn:aws:forecast:ap-northeast-2:414501109622:predictor/electricitypredictor
## OUTPUT:
{
    "PredictorEvaluationResults": [
        {
            "AlgorithmArn": "arn:aws:forecast:::algorithm/Deep_AR_Plus",
            "TestWindows": [
                {
                    "EvaluationType": "SUMMARY",
                    "Metrics": {
                        "RMSE": 9.229642931281711,
                        "WeightedQuantileLosses": [
                            {
                                "Quantile": 0.9,
                                "LossValue": 0.07092915035540824
                            },
                            {
                                "Quantile": 0.5,
                                "LossValue": 0.12248383004411037
                            },
                            {
                                "Quantile": 0.1,
                                "LossValue": 0.050581299758104645
                            }
                        ]
                    }
                },
                {
                    "TestWindowStart": 1414641600.0,
                    "TestWindowEnd": 1414713600.0,
                    "ItemCount": 3,
                    "EvaluationType": "COMPUTED",
                    "Metrics": {
                        "RMSE": 9.229642931281711,
                        "WeightedQuantileLosses": [
                            {
                                "Quantile": 0.9,
                                "LossValue": 0.07092915035540824
                            },
                            {
                                "Quantile": 0.5,
                                "LossValue": 0.12248383004411037
                            },
                            {
                                "Quantile": 0.1,
                                "LossValue": 0.050581299758104645
                            }
                        ]
                    }
                }
            ]
        }
    ]
}





