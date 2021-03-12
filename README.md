# Top_4_pct_Titanic_Kaggle
Top 4 % in ***Titanic: Machine Learning from Disaster***, a renowned competition on Kaggle, in 2020/05. 


## 1. Ranking 

![titanicLeaderBoard01](Top_4_pct_Titanic_01.png)
![titanicLeaderBoard02](Top_4_pct_Titanic_02.png)



## 2. Dataset—Titanic: Machine Learning from Disaster

Start here! Predict survival on the Titanic and get familiar with Machine Learning basics

[Kaggle Titanic](https://www.kaggle.com/c/titanic)

## Steps

1. Performing *n*-fold cross-validation on the training data under three-way split to select the best prediction model
2. Reporting the average accuracy of cross-validation (training, validation, test in *n*-fold cross-validation)
3. Applying the selected model on the test data

```R
Rscript hw5_studentID.R --fold n --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance.csv --predict predict.csv
```


![titanicLeaderBoard](titanic.png)

## Score


```R
Rscript hw5_9999.R --fold 5 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance1.csv --predict predict.csv
...
Rscript hw5_9999.R --fold 10 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance6.csv --predict predict.csv
```

Each testing parameters get 15 points.
**Please do not set input/output in your local path or URL.** 
Otherwise, your code will fail due to fixed path problem.

Penalty: without training, calibration, testing answer (-5 points of each answer)
