library(datasets)
library(dplyr)
library(ggplot2)
library(corrplot)
library(tsoutliers)
library(scales)
library(NbClust)
library(purrr)
library(scales)

#Part 1: Regression analysis


# 1. Load and study the dataset:
#Data set is downloaded to the computer and dataArrests is imported by File --> Import Dataset --> From text(base) --> dataArrests
#First data set contains 1000 observations and 10 variables. 

#Observations containing NA values are removed 
Arrests = dataArrests[complete.cases(dataArrests),] 

#2.exploratory data analysis:

#min,max and mean values:
str(Arrests)
summary(Arrests)

#Lets plot the variables and see the results:
ggplot(Arrests,(aes(x=Assault)))+geom_histogram(bins=30,col='black',fill='lightblue')
ggplot(Arrests,(aes(x=UrbanPop)))+geom_histogram(bins=30,col='black',fill='red')
ggplot(Arrests,(aes(x=Traffic)))+geom_histogram(bins=30,col='black',fill='green')
ggplot(Arrests,(aes(x=CarAccidents)))+geom_histogram(bins=30,col='black',fill='yellow')
ggplot(Arrests,(aes(x=Murder)))+geom_histogram(bins=30,col='black',fill='orange') 

#3.a correlation analysis between all variables

correlation = cor(Arrests[,c(1,2,3,4,5,6,7,8,9,10)], method="pearson")


# 4.Correlation visualization

corrplot(cor(Arrests[,c(1:10)]), "number")

corrplot(cor(Arrests[,c(1:10)]), "ellipse")


#5. Remove explanatory variables that have high absolute correlation 


#Lets first divide dependent and explonatory variables from the dataset. 

dep = Arrests$Murder #dependent variable
ex = Arrests[,2:10] #explanatory variables

# Lets look at the highly correlated explanatory variables:
par(mfrow = c(1,1))
corrplot(cor(ex),"number") 
cormatrix = abs(cor(ex))
diag(cormatrix)=0 

#Lets remove highly correlated variables
while (max(cormatrix)>=0.8){
  maxvar = which(cormatrix==max(cormatrix),arr.ind=TRUE) # Command finds explanatory variables with highest absolute correlation
  maxavg = which.max(rowMeans(cormatrix[maxvar[,1],])) # Command selects the variable with the highest average correlation
  print(rownames(maxvar)[maxvar[,1]==maxvar[maxavg,1]])
  ex=ex[,-maxvar[maxavg,1]] #removal
  cormatrix = cormatrix[-maxvar[maxavg,1],-maxvar[maxavg,1]]
}
# Variable CarAccidents is removed.

# 6. Implement linear regression with all explanatory variables (Except variable CarAccidents)

my_data = cbind('Murder'=dep,ex)
linregmodel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Kidnapping+Domestic+Alcohol, data = my_data)
summary(linregmodel)


# 7. Lets improve the model:

## model at the beginning:
linregmodel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Kidnapping+Domestic+Alcohol, data = my_data)
summary(linregmodel)

## remove: Kidnapping

linregmodel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Domestic+Alcohol, data = my_data)
summary(linregmodel)

## remove: Alcohol

linregmodel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Domestic, data = my_data)
summary(linregmodel)

## remove: Domestic

linregmodel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber, data = my_data)
summary(linregmodel)

## remove : Drug
linregmodel = lm(Murder~Assault+UrbanPop+Traffic+Cyber, data = my_data)
summary(linregmodel)

## remove : Traffic

linregmodel = lm(Murder~Assault+UrbanPop+Cyber, data = my_data)
summary(linregmodel)

# --> optimal model

#8.

# 9. 5 properties of linear regression (OLS):


#2. The residuals (=errors) have zero mean: closer to zero the better it is: now it's good!
mean(residuals(linregmodel))

#3. The variance of the residuals is constant (and finite) → Homoskedasticity 
#& 
#4. Residuals linearly independent
plot(residuals(linregmodel),type="p",col="pink",ylim=c(-20,20),pch=16, ylab="Residuals",main="Residuals over time")
abline(a=3*sd(residuals(linregmodel)),b=0,col="orange",lty=2)
abline(a=-3*sd(residuals(linregmodel)),b=0,col="orange",lty=2)
abline(a=0,b=0,col="black",lty=2)


plot(fitted.values(linregmodel),residuals(linregmodel),type="p",col="orange",ylim=c(-20,20),pch=16, ylab="Residuals",main="Residuals over time")
abline(a=3*sd(residuals(linregmodel)),b=0,col="green",lty=2)
abline(a=-3*sd(residuals(linregmodel)),b=0,col="green",lty=2)
abline(a=0,b=0,col="black",lty=2)

#5.There is no relationship between the residuals and each of the explanatory variables 
cor(residuals(linregmodel),Arrests$Assault)
cor(residuals(linregmodel),Arrests$UrbanPop)
cor(residuals(linregmodel),Arrests$Cyber)

#6. The residuals are normally distributed
JarqueBera.test(residuals(linregmodel))

################################################################################################################################
################################################################################################################################
################################################################################################################################

#Part 2: Clustering


#1. Load and study the dataset
#Loading the dataset: File --> Import Dataset --> From text(base) --> wholesale

#Lets see if there is NA values:
any(is.na(wholesale)) 
# -> there is no NA values

#2- Exploratory data analysis for all variables
#Numerically:

#First look at all
str(wholesale) 
summary(wholesale)


#Lets count the number of observations in variable Channel 1 and 2.
wholesale %>%
  count(Channel)

#Lets count the number of observations in variable Region 1, 2 and 3.
wholesale %>%
  count(Region)

#Lets see what is the sum of all categories grouped by Channel and Region.
#Channel:
wholesale %>%
  group_by(Channel) %>%
  summarise_at(c("Fresh","Milk","Grocery","Frozen","Detergents_Paper","Delicassen"), sum, nan.rm = FALSE)
#Region:
wholesale %>%
  group_by(Region) %>%
  summarise_at(c("Fresh","Milk","Grocery","Frozen","Detergents_Paper","Delicassen"), sum, nan.rm = FALSE)


#Visually:
par(mfrow = c(1,2))
barplot(table(wholesale$Channel),main="Count of Channel",col="Lightblue",xlab="Channels", ylab="Count",xlim=c(0,3),ylim=c(0,400))
barplot(table(wholesale$Region),main="Count of Region",col="Pink", xlab="Regions", ylab="Count",xlim=c(0,4),ylim=c(0,400))

ggplot(wholesale, aes(x=Fresh)) + geom_histogram(bins=20,col='red',fill='green')  
ggplot(wholesale, aes(x=Milk)) + geom_histogram(bins=20,col='orange',fill='blue') 
ggplot(wholesale, aes(x=Grocery)) + geom_histogram(bins=20,col='pink',fill='yellow')  
ggplot(wholesale, aes(x=Frozen)) + geom_histogram(bins=20,col='blue',fill='black')  
ggplot(wholesale, aes(x=Detergents_Paper)) + geom_histogram(bins=20,col='lightblue',fill='orange')  
ggplot(wholesale, aes(x=Delicassen)) + geom_histogram(bins=20,col='purple',fill='pink')  

#3 A correlation analysis of the variables
par(mfrow = c(1,1))
corrplot(cor(wholesale[,c(1:8)]), "number")
cor(wholesale[,c(1:8)], method="pearson")


#4 a new data frame that contains the original data normalized

#Scaling:

data = apply(wholesale,2,rescale,to=c(0,1))



#5 K-means clustering
kmeansmdl = kmeans(data, centers = 4, nstart = 25)

kmeansmdl$cluster
kmeansmdl$centers
par(mfrow = c(1,1))
plot(data[,1], data[,8],col=kmeansmdl$cluster, pch=16, main="K-means clustering result")


kmeansmdl$size
kmeansmdl$withinss
kmeansmdl$tot.withinss

# Lets determine the optimal number of clusters

# Elbow method:

tot_within_ss=map_dbl(1:10, function(k){
  model = kmeans(data, centers=k,nstart=25)
  model$tot.withinss
})

#Silhouette method:
silhouette = NbClust(data,distance="euclidean", min.nc=2,max.nc=10, method="kmeans",index="silhouette")
#Gap statistic method:
gap = NbClust(data,distance="euclidean", min.nc=2,max.nc=10, method="kmeans",index="gap")
#Calinski-Harabasz Index:
ch = NbClust(data,distance="euclidean", min.nc=2,max.nc=10, method="kmeans",index="ch")


# Plotting the methods: 
par(mfrow = c(1,4))
plot(1:10,tot_within_ss, type="o",xlab="number of clusters", ylab="total WSS",main="Elbow method", panel.first=grid())

plot(2:10,silhouette$All.index,type="o",xlab="number of clusters", ylab="Silhouette Score",main="Silhouette method",panel.fist=grid())

plot(2:10,gap$All.index,type="o",xlab="number of clusters", ylab="Gap statistics",main="Gap statistic method",panel.fist=grid())

plot(2:10,ch$All.index,type="o",xlab="number of clusters", ylab="Calinski-Harabasz index",main="Calinski-Harabasz Index",panel.fist=grid())


#6 Using the optimal number of clusters

par(mfrow = c(1,1))
kmeansmdl = kmeans(wholesale, centers = 3, nstart = 25) 


kmeansmdl$cluster
kmeansmdl$centers
par(mfrow = c(1,1))
plot(wholesale[,1], wholesale[,8],col=kmeansmdl$cluster, pch=16, main="K-means clustering result")

