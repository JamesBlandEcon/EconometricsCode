library(ggplot2)
library(tidyr)
d4<-data.frame(c(12,8,13,9,10,9,6,8,13,8,6,9))
d5<-data.frame(c(7,5,11,10,8,8,6,5,5,6,8,9))

colnames(d4)<-"count"
colnames(d5)<-"count"
mean(d4$count)
mean(d5$count)

d4$type = "greater than 4"
d5$type = "greter than 5"

d<-rbind(d4,d5)
ggplot(data=d,aes(x=count))+geom_histogram()+facet_wrap(~type)
