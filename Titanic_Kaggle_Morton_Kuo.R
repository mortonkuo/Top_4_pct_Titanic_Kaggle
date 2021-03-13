
# Read parameters ---------------------------------------------------------

args = commandArgs(trailingOnly=TRUE)

# args = "Rscript hw5_9999.R --fold 10 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance6.csv --predict predict.csv"
args = strsplit(args, " ")
args = unlist(args)

if (length(args)==0) {
  stop("USAGE: Rscript hw2_yourID.R --target male|female --input file1 file2 ... filen --output out.csv", call.=FALSE)
}

stopifnot(any(args %in% "--fold"))
stopifnot(any(args %in% "--train"))
stopifnot(any(args %in% "--test"))
stopifnot(any(args %in% "--report"))
stopifnot(any(args %in% "--predict"))

# "Rscript hw5_9999.R --fold 10 --train Titanic_Data/train.csv --test Titanic_Data/test.csv --report performance6.csv --predict predict.csv"

fold.filename <-  args[which(args %in% "--fold")+1] 
train.filename <-  args[which(args %in% "--train")+1]
test.filename <-  args[which(args %in% "--test")+1] 
report.filename <-  args[which(args %in% "--report")+1]  
predict.filename <-  args[which(args %in% "--predict")+1] 



# 1. Input data ----------------------------------------------------------


# setwd("D:\\G02_2\\data_sci\\HW05\\Remade")
# Raw_train = read.table(train.filename, sep=",",quote = "\"" ,header = T)
# Raw_test  = read.table(test.filename, sep=",", quote = "\"",header = T)


# setwd("D:\\G02_2\\data_sci\\HW05\\FINAL\\FINAL_test")
# Raw_train = read.table("train.csv",sep=",",quote = "\"" ,header = T)
# Raw_test  = read.table("test.csv",sep=",",quote = "\"" ,header = T)
Raw_train = read.table(train.filename, sep=",",quote = "\"" ,header = T)
Raw_test  = read.table(test.filename, sep=",", quote = "\"",header = T)
Survived_train = Raw_train[,2]
Raw_0 = rbind(Raw_train[,-2],Raw_test)
Raw_del = Raw_0[c(3,8,10)]
Raw = Raw_0[-c(1,3,8,10)]


# 2. Missing value implementation ----------------------------------------------------------------------


Raw$Pclass = as.factor(Raw$Pclass)
Raw$Embarked = as.integer(Raw$Embarked)
Raw$Embarked = as.factor(Raw$Embarked)
Raw$Embarked[which(Raw$Embarked == "1")] = NA
Raw$Embarked = as.integer(Raw$Embarked)
Raw$Embarked = as.factor(Raw$Embarked)


# mice() -- Multivariate Imputation via Chained Equations
# (linear regression, logistic regression, cart, random forest, boostrap……)
library(mice,quietly = T)
mice.data <- mice(Raw,
                  m = 1,           # 
                  maxit = 50,      # max iteration
                  method = "rf", 
                  seed = 188,
                  print=FALSE)      

df <- complete(mice.data, 1)
# View(df) # In Embarked , row 62 & 830 is NA ?? 



# 3. Output the missing value implemented data ---------------------------------------------------------------------

Titanic = cbind(df, Raw_del)
#
# write.csv(Titanic, file = "train_mice.csv",row.names = F)
# row.names = TRUE, col.names = TRUE
# write.csv(Survived_train, file = "Survived_train.csv",row.names = F)


# setwd("D:\\G02_2\\data_sci\\HW05\\Remade")
# Titanic  = read.table("train_mice.csv",sep=",",header = T)
# Survived_train  = read.table("Survived_train.csv",sep=",",header = T)
# str(Titanic)


Titanic_MV = Titanic
#Titanic_temp = Titanic


# 4. Feature engineering ---------------------------------------------------------------------

Titanic = Titanic_MV
Titanic_temp = Titanic

# (1) Ticket ----

# combine_df['High_Survival_Ticket'] = np.where(combine_df['Ticket_Lett'].isin(['1', '2', 'P']),1,0)
# combine_df['Low_Survival_Ticket'] = np.where(combine_df['Ticket_Lett'].isin(['A','W','3','7']),1,0)
Titanic$Ticket = as.character(Titanic$Ticket)
Titanic$Ticket_02 = Titanic$Ticket
split01 = strsplit(Titanic$Ticket_02, "")

split02 = rep(NA,1309)
for (i in 1:1309){
  temp = unlist(split01[i])[1]; temp
  temp02 = strsplit(temp, " "); temp02
  split02[i] = unlist(temp02)[1]
} 
split03 = as.factor(split02)
#  Factor w/ 16 levels "1","2","3","4",..: 10 14 15 1 3 3 1 3 3 2 ...
# Levels: 1 2 3 4 5 6 7 8 9 A C F L P S W

Titanic$Ticket_02 = as.character(split03)
# table(Survived_train)
# dead / alive = 1.605
# table(Survived_train,  (Titanic$Ticket_02)[1:891])

Titanic$Ticket_02[ Titanic$Ticket_02 == "A"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "W"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "C"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "S"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "F"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "L"] <- "E"
Titanic$Ticket_02[ Titanic$Ticket_02 == "P"] <- "E"

Titanic$Ticket_02[ Titanic$Ticket_02 == "3"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "1"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "2"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "4"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "5"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "6"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "7"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "8"] <- "N"
Titanic$Ticket_02[ Titanic$Ticket_02 == "9"] <- "N"

# table(Survived_train,  (Titanic$Ticket_02)[1:891])
Titanic_temp$Ticket_02 = Titanic$Ticket_02
#


# (2) SibSp & Parch  ----
Titanic_temp$Family_size = (Titanic_temp$SibSp + Titanic_temp$Parch +1 )
# table(Survived_train, Titanic_temp$Family_size[1:891])
Titanic_temp$Family_size [ Titanic_temp$Family_size == 11 ] = "D"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 8 ] = "D"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 7 ] = "C"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 6 ] = "C"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 5 ] = "C"

Titanic_temp$Family_size [ Titanic_temp$Family_size == 4 ] = "B"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 3 ] = "B"
Titanic_temp$Family_size [ Titanic_temp$Family_size == 2 ] = "B"

Titanic_temp$Family_size [ Titanic_temp$Family_size == 1 ] = "A"


# (3) Name  ----
Titanic$Title = Titanic$Name

split01 = strsplit(as.character(Titanic$Name), ",")

split02 = rep(NA,1309)
for (i in 1:1309){
  temp = unlist(split01[i])[2]; temp
  temp02 = strsplit(temp, " "); temp02
  split02[i] = unlist(temp02)[2]
} 
split03 = as.factor(split02)
# Levels: Capt. Col. Don. Dona. Dr. Jonkheer. Lady. Major. Master. Miss. Mlle. Mme. Mr. Mrs. Ms. Rev. Sir. the
# Factor w/ 18 levels "Capt.","Col.",..: 13 14 10 14 13 13 13 9 14 14 ...

Titanic$Title = as.character(split03)
# table(Survived_train , Titanic$Title[1:891])

split04 = rep(NA,1309)
for (i in 1:1309){
  temp = unlist(split01[i])[1]; temp
  
  if ( Titanic_temp$Family_size[i] >= 2 ){
    split04[i] = unlist(temp)
  } else { split04[i] = "N"}
}
# split04

# str(as.factor(split04))

# any(split04 == "Thayer")

Titanic_temp$Family_name = split04
# table(Survived_train, split04[1:891])
# as.integer(as.factor(split04))

# Titanic_MV$Sex
# Survived_train
# Titanic_temp$Family_size
# Titanic_temp$Family_size[1] != "A"

split05 = rep("normal",1309)
family_name_dead = c()
family_name_alive = c()
# Woman / dead / family_size > 1
for (i in 1:891){
  if (Titanic_MV$Sex[i] == "female" && Survived_train[i] == 0 && Titanic_temp$Family_size[i] != "A" ){
    split05[i] = "Dead"; family_name_dead = c(family_name_dead, Titanic_temp$Family_name[i])
  } else if (Titanic_MV$Sex[i] == "male" && Survived_train[i] == 1 && Titanic_temp$Family_size[i] != "A")
  { split05[i] = "Alive"; family_name_alive = c(family_name_alive, Titanic_temp$Family_name[i])}
  else{  }
}

for (i in 892:1309){
  if (Titanic_temp$Family_size[i] != "A" && (sum(Titanic_temp$Family_name[i] %in% family_name_dead ))){
    split05[i] = "Dead"
  } else if (Titanic_temp$Family_size[i] != "A" && (sum(Titanic_temp$Family_name[i] %in% family_name_alive)))
  { split05[i] = "Alive"}
  else{  }
}
# View(split05)

Titanic_temp$Sex_Survival = as.factor(split05)



#  12 terms
Titanic$Title[ Titanic$Title == "Jonkheer."] <- "RARE"
Titanic$Title[ Titanic$Title == "the"] <- "RARE"
Titanic$Title[ Titanic$Title == "Don."] <- "RARE"
Titanic$Title[ Titanic$Title == "Dona."] <- "RARE"
Titanic$Title[ Titanic$Title == "Sir."] <- "RARE"
Titanic$Title[ Titanic$Title == "Lady."] <- "RARE"
Titanic$Title[ Titanic$Title == "Mme."] <- "RARE"

Titanic$Title[ Titanic$Title == "Dr."] <- "Prof"

Titanic$Title[ Titanic$Title == "Rev."] <- "Prof"
Titanic$Title[ Titanic$Title == "Capt."] <- "Prof"

Titanic$Title[ Titanic$Title == "Major."] <- "Prof"
Titanic$Title[ Titanic$Title == "Col."] <- "Prof"

# Nomral_man (3)
Titanic$Title[ Titanic$Title == "Mr."] <- "Mr"
Titanic$Title[ Titanic$Title == "Master."] <- "Master"

# Normal_woman (3)
Titanic$Title[ Titanic$Title == "Mrs."] <- "Mrs"
Titanic$Title[ Titanic$Title == "Ms."] <- "Mrs"
Titanic$Title[ Titanic$Title == "Miss."] <- "Miss"
Titanic$Title[ Titanic$Title == "Mlle."] <- "Miss"

#
# table(Survived_train , Titanic$Title[1:891])
Titanic_temp$Title = Titanic$Title
# as.factor(Titanic$Title)



# (4) Cabin  ----
cabin01 = strsplit(as.character(Titanic$Cabin), "")
cabin02 = rep(NA,1309)
# str(cabin01[2]) 

for (i in 1:1309){
  temp01 = cabin01[[i]]
  if ( !identical(temp01,character(0))){
    cabin02[i] = temp01[1]
  } else {
    cabin02[i] = "None"
  }
}
# cabin02
# as.factor(cabin02)
# A B C D E F G NA T

# table(Survived_train, cabin02[1:891])
# BCDE/ AFGT/ NA

cabin02[ cabin02 == "B"] <- "Alive"
cabin02[ cabin02 == "C"] <- "Alive"
cabin02[ cabin02 == "D"] <- "Alive"
cabin02[ cabin02 == "E"] <- "Alive"

cabin02[ cabin02 == "A"] <- "Alive"
cabin02[ cabin02 == "F"] <- "Alive"
cabin02[ cabin02 == "G"] <- "Alive"
cabin02[ cabin02 == "T"] <- "Alive"

# table(Survived_train , cabin02[1:891])
Titanic_temp$Cabin = cabin02


# (5) Age  ----
Titanic_temp$Age = Titanic_MV$Age ** 1


# (6) Fare  ----
Titanic_temp$Fare_2 = Titanic_MV$Fare ** 1



# 5. Random Forest -------------------------------------------------------

# (1) Preparation  ---- split the 891 row data into "train / test"

Survived = as.factor(Survived_train)
#str(Titanic_temp)
Titanic = cbind( Titanic_temp[-c(8,9)][1:891,], Survived)
# str(Titanic)

Titanic$Title <- as.factor(Titanic$Title)
Titanic$Cabin <- as.factor(Titanic$Cabin)
Titanic$Ticket_02 <- as.factor(Titanic$Ticket_02)
# Titanic$Parch <- as.factor(Titanic$Parch)
Titanic$Family_size <- as.factor(Titanic$Family_size)

#Titanic$Family_size
#Titanic$Sex_FamilySize <- as.factor(Titanic$Sex_FamilySize)
# Titanic$Family_name <- as.factor(Titanic$Family_name)
#str(Titanic)

library(randomForest, quietly = T)
library(rBayesianOptimization)


if (fold.filename == "5"){
  
# k = 5 ----
# KFold(target, nfolds = 10, stratified = FALSE, seed = 0)
kfold01 = KFold(1:891, nfolds = 5, stratified = F, seed = 666) # sample(1:100000,1)
# kfold02 = KFold(Titanic, nfolds = 10, stratified = T, seed = 0); kfold02

result_rf_train = rep(NA, 5)
result_rf_valid = rep(NA, 5)
result_rf_test = rep(NA, 5)

for (i in 1:5){
  Survived = as.factor(Survived_train)
  Titanic_test <- Titanic[unlist(kfold01[i]),]
  
  if( i == 5 ) { t = 1 }else{ t = i+1 } 
  
  Titanic_valid <- Titanic[unlist(kfold01[t]),]
  
  index = unlist(c(kfold01[i],kfold01[t])); # index; str(index)
  Titanic_train <- Titanic[ (1:891)[-index], ]; #Titanic_train
  
  # str(Titanic_train)
  #
  
  # RF  model ----
  
  fold1_rf01 = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare + Embarked , data=Titanic_train , ntree = 1000, importance = F)
  fold1_rf02 = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare:Age + Embarked + Ticket_02 , data=Titanic_train , ntree = 1000, importance = F)
  
  f1_valid_predict = factor(predict(fold1_rf01, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid01 = f1_correct_valid
  
  f1_valid_predict = factor(predict(fold1_rf02, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid02 = f1_correct_valid
  
  valid_all = c(result_rf_valid01,result_rf_valid02)
  best = which(valid_all == max(valid_all))
  
  if (length(best)>1){ best = best[1] }
  # Final model 
  
  
  model_best = function (x, y){
    if (x==1){
      fold1_rf = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare + Embarked , data=y , ntree = 1000, importance = F)
    } else if (x==2){
      fold1_rf = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare:Age + Embarked + Ticket_02 , data=y , ntree = 1000, importance = F)}
    
    return (fold1_rf)
  }
  
  
  fold1_rf =  model_best(best, Titanic_train)
  
  
  f1_train_predict = factor(predict(fold1_rf, newdata = Titanic_train , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_train_confusion = table(Titanic_train$Survived, f1_train_predict) 
  f1_correct_train = sum(f1_train_confusion[row(f1_train_confusion) == col(f1_train_confusion)]) / sum(f1_train_confusion) 
  result_rf_train[i] = f1_correct_train
  
  # even the level  !!!
  common <- intersect(names(Titanic_train), names(Titanic_valid)) 
  for (p in common) { 
    if (class(Titanic_train[[p]]) == "factor") { 
      levels(Titanic_valid[[p]]) <- levels(Titanic_train[[p]]) } }
  
  f1_valid_predict = factor(predict(fold1_rf, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid[i] = f1_correct_valid
  
  
  # even the level  !!!
  common <- intersect(names(Titanic_train), names(Titanic_test)) 
  for (p in common) { 
    if (class(Titanic_train[[p]]) == "factor") { 
      levels(Titanic_test[[p]]) <- levels(Titanic_train[[p]])} }
  
  f1_test_predict = factor(predict(fold1_rf, newdata = Titanic_test , type = 'class', levels = levels(Titanic_test$Survived)))
  f1_test_confusion = table(Titanic_test$Survived, f1_test_predict) ; f1_test_confusion
  f1_correct_test = sum(f1_test_confusion[row(f1_test_confusion) == col(f1_test_confusion)]) / sum(f1_test_confusion) ; f1_correct_test
  result_rf_test[i] = f1_correct_test
  #print(f1_correct_test)
  #print(result_rf_test)
}

#result_rf_train
#result_rf_valid
#result_rf_test
#mean(result_rf_train) ; mean(result_rf_valid) ; mean(result_rf_test)
#

#
#
result_rf_train02 = c(result_rf_train, mean(result_rf_train))
result_rf_valid02 = c(result_rf_valid, mean(result_rf_valid))
result_rf_test02 = c(result_rf_test, mean(result_rf_test))

#
set = c("fold1","fold2","fold3","fold4","fold5","ave.")
out_data = data.frame(set = set, training = round(result_rf_train02 , digits = 2) , 
                      validation= round(result_rf_valid02, digits = 2) ,	test= round(result_rf_test02, digits = 2))
#getwd()
write.table(out_data, report.filename , row.names = F ,  quote = F, sep =",") #output.filename



} else {

# k = 10 ----

# KFold(target, nfolds = 10, stratified = FALSE, seed = 0)
kfold01 = KFold(1:891, nfolds = 10, stratified = F, seed = 666) # sample(1:100000,1)
# kfold02 = KFold(Titanic, nfolds = 10, stratified = T, seed = 0); kfold02

result_rf_train = rep(NA, 10)
result_rf_valid = rep(NA, 10)
result_rf_test = rep(NA, 10)

for (i in 1:10){
  Survived = as.factor(Survived_train)
  Titanic_test <- Titanic[unlist(kfold01[i]),]
  
  if( i == 10 ) { t = 1 }else{ t = i+1 } 
  
  Titanic_valid <- Titanic[unlist(kfold01[t]),]
  
  index = unlist(c(kfold01[i],kfold01[t])); # index; str(index)
  Titanic_train <- Titanic[ (1:891)[-index], ]; #Titanic_train
  
  # str(Titanic_train)
  #
  
  # RF  model ----
  
  fold1_rf01 = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare + Embarked , data=Titanic_train , ntree = 1000, importance = F)
  fold1_rf02 = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare:Age + Embarked + Ticket_02 , data=Titanic_train , ntree = 1000, importance = F)
  
  f1_valid_predict = factor(predict(fold1_rf01, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid01 = f1_correct_valid
  
  f1_valid_predict = factor(predict(fold1_rf02, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid02 = f1_correct_valid
  
  valid_all = c(result_rf_valid01,result_rf_valid02)
  best = which(valid_all == max(valid_all))
  
  if (length(best)>1){ best = best[1] }
  # Final model 
  
  
  model_best = function (x, y){
    if (x==1){
      fold1_rf = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare + Embarked , data=y , ntree = 1000, importance = F)
    } else if (x==2){
      fold1_rf = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare:Age + Embarked + Ticket_02 , data=y , ntree = 1000, importance = F)}
    
    return (fold1_rf)
  }
  
  
  fold1_rf =  model_best(best, Titanic_train)
  
  
  f1_train_predict = factor(predict(fold1_rf, newdata = Titanic_train , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_train_confusion = table(Titanic_train$Survived, f1_train_predict) 
  f1_correct_train = sum(f1_train_confusion[row(f1_train_confusion) == col(f1_train_confusion)]) / sum(f1_train_confusion) 
  result_rf_train[i] = f1_correct_train
  
  # even the level  !!!
  common <- intersect(names(Titanic_train), names(Titanic_valid)) 
  for (p in common) { 
    if (class(Titanic_train[[p]]) == "factor") { 
      levels(Titanic_valid[[p]]) <- levels(Titanic_train[[p]]) } }
  
  f1_valid_predict = factor(predict(fold1_rf, newdata = Titanic_valid , type = 'class', levels = levels(Titanic_train$Survived)))
  f1_valid_confusion = table(Titanic_valid$Survived, f1_valid_predict) ; f1_valid_confusion
  f1_correct_valid = sum(f1_valid_confusion[row(f1_valid_confusion) == col(f1_valid_confusion)]) / sum(f1_valid_confusion) ; f1_correct_valid
  result_rf_valid[i] = f1_correct_valid
  
  
  # even the level  !!!
  common <- intersect(names(Titanic_train), names(Titanic_test)) 
  for (p in common) { 
    if (class(Titanic_train[[p]]) == "factor") { 
      levels(Titanic_test[[p]]) <- levels(Titanic_train[[p]])} }
  
  f1_test_predict = factor(predict(fold1_rf, newdata = Titanic_test , type = 'class', levels = levels(Titanic_test$Survived)))
  f1_test_confusion = table(Titanic_test$Survived, f1_test_predict) ; f1_test_confusion
  f1_correct_test = sum(f1_test_confusion[row(f1_test_confusion) == col(f1_test_confusion)]) / sum(f1_test_confusion) ; f1_correct_test
  result_rf_test[i] = f1_correct_test
  #print(f1_correct_test)
  #print(result_rf_test)
}




#
#
result_rf_train02 = c(result_rf_train, mean(result_rf_train))
result_rf_valid02 = c(result_rf_valid, mean(result_rf_valid))
result_rf_test02 = c(result_rf_test, mean(result_rf_test))

#
set = c("fold1","fold2","fold3","fold4","fold5","fold6","fold7","fold8","fold9","fold10","ave.")
out_data = data.frame(set = set, training = round(result_rf_train02 , digits = 2) , 
                      validation= round(result_rf_valid02, digits = 2) ,	test= round(result_rf_test02, digits = 2))
#getwd()
write.table(out_data, report.filename , row.names = F ,  quote = F, sep =",") #output.filename

}



# ** Kaggle ** ------------------------------------------------------------------


# (1) Preparation  ---- split the 891 row data into "train / test"

Survived = as.factor(Survived_train)
#str(Titanic_temp)
Titanic = Titanic_temp[-c(8,9)]

Titanic$Title <- as.factor(Titanic$Title)
Titanic$Cabin <- as.factor(Titanic$Cabin)
Titanic$Ticket_02 <- as.factor(Titanic$Ticket_02)
Titanic$Family_size <- as.factor(Titanic$Family_size)


library(randomForest)
library(rBayesianOptimization)

result_rf_train = rep(NA, 5)
result_rf_test = rep(NA, 5)

Survived = as.factor(Survived_train)
Titanic_train <- cbind(Titanic[1:891,], Survived)
Titanic_test <- Titanic[892:1309,]
#str(Titanic_train)
#str(Titanic_test)
#

# RF  ----
# 
fold1_rf = randomForest( Survived ~ Title + Family_size:Sex_Survival + Fare + Embarked , data= Titanic_train , ntree = 1000, importance = F)


f1_train_predict = factor(predict(fold1_rf, newdata = Titanic_train , type = 'class', levels = levels(Titanic_train$Survived)))
f1_train_confusion = table(Titanic_train$Survived, f1_train_predict) 
f1_correct_train = sum(f1_train_confusion[row(f1_train_confusion) == col(f1_train_confusion)]) / sum(f1_train_confusion) 

# even the level  !!!
common <- intersect(names(Titanic_train), names(Titanic_test)) 
for (p in common) { 
  if (class(Titanic_train[[p]]) == "factor") { 
    levels(Titanic_test[[p]]) <- levels(Titanic_train[[p]]) 
  } 
}

f1_test_predict = factor(predict(fold1_rf, newdata = Titanic_test , type = 'class', levels = levels(Titanic$Survived)))

# f1_train_confusion = table(Survived_test, f1_test_predict) ; f1_train_confusion
# f1_correct_train = sum(f1_train_confusion[row(f1_train_confusion) == col(f1_train_confusion)]) / sum(f1_train_confusion) ; f1_correct_train
#
#
kaggle = data.frame( PassengerId = 892:1309 , Survived = f1_test_predict)
write.csv(kaggle, predict.filename,  row.names = F)

