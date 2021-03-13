# Top_4_pct_Titanic_Kaggle
Top 4 % in ***Titanic: Machine Learning from Disaster***, a renowned competition on Kaggle, in 2020/05. 


## 1. Ranking 

![titanicLeaderBoard01](Top_4_pct_Titanic_01.png)
![titanicLeaderBoard02](Top_4_pct_Titanic_02.png)

## 2. Steps

1. Performing *n*-fold cross-validation on the training data under three-way split to select the best prediction model.
2. Reporting the average accuracy of cross-validation (training, validation, test in *n*-fold cross-validation).
3. Applying the selected model on the test data.

## 3. Reproducing outcome on training & validation data

```R
Rscript Titanic_Kaggle_Morton_Kuo.R --fold 5 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance1.csv --predict predict.csv
...
Rscript Titanic_Kaggle_Morton_Kuo.R --fold 10 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance6.csv --predict predict.csv
```

## 4. Reproducing outcome on test data

