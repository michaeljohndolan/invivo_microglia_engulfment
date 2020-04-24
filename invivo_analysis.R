#Code to process the single microglial cell data 
#Read in the data and load required libraries  
library(ggplot2)
library(dplyr)
library(tiff)
library(rmngb)
library(reshape2)
library(PMCMR)
library(car)
library(FSA)

data<-read.csv("/Volumes/Samsung_T5/Ccr5KO_P5_CD68_dLGN_21Oct2019/Results_x_area.csv")

#Extract the well id and experimental condition 
data$animal.id<-sapply(strsplit(x = as.character(data$Label), "_"), "[", 2) 

data$Condition<-data$animal.id
data$Condition<-gsub(data$Condition, pattern = "M30", replacement = "B6")
data$Condition<-gsub(data$Condition, pattern = "M31", replacement = "B6")
data$Condition<-gsub(data$Condition, pattern = "M32", replacement = "Ccr5KO")
data$Condition<-gsub(data$Condition, pattern = "M36", replacement = "Ccr5KO")
data$Condition<-gsub(data$Condition, pattern = "M38", replacement = "B6")
data$Condition<-gsub(data$Condition, pattern = "M33", replacement = "Ccr5KO")

#Need to fix the fragment analysis. It is splitting up individual microglia...Seems to be a 
#ImageJ problem. 


#Plot mean intensity per cell, can also plot %area which seems to be more of an effect 
g<-ggplot(data, aes(x=Condition, y=X.Area))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = F, fill="magenta", col="magenta")
g<-g+geom_jitter(width = 0.3, alpha=0.3, size=1)
g

#Run a statistical test
data$Condition<-as.factor(data$Condition)
kruskal.test(X.Area ~Condition, data)
dunnTest(X.Area ~ Condition, data, method="bonferroni")

##PLOT DATA BY ANIMAL  
#Plot the data by animal to aggregate analysis 
ag.data<-aggregate(data$X.Area, by = list(data$animal.id), FUN = mean)
colnames(ag.data)<-c("animal.id", "Mean")
ag.data$Condition<-as.character(ag.data$animal.id)

#Port the names to this aggregated dataset 
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M30", replacement = "B6")
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M31", replacement = "B6")
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M32", replacement = "Ccr5KO")
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M36", replacement = "Ccr5KO")
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M38", replacement = "B6")
ag.data$Condition<-gsub(ag.data$Condition, pattern = "M33", replacement = "Ccr5KO")

g<-ggplot(ag.data, aes(x=reorder(Condition, Mean), y=Mean))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = F, fill="magenta", col="magenta")
g<-g+geom_jitter(width = 0.3, alpha=0.3, size=2)
g

#Run a statistical test
ag.data$Condition<-as.factor(ag.data$Condition)
kruskal.test(Mean ~Condition, ag.data)
dunnTest(Mean ~ Condition, ag.data, method="bonferroni")







