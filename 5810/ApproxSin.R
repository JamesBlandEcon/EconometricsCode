library(ggplot2)
library(gganimate)
# approximate sin(x)
# sin(0) = 0
# sin'(x) = cos(x)
# sin''(x) = -sin(x)
# sin'''(x) = -cos(x)
# sin''''(x) = sin(x)

# at x=0:
  # derivative = 0 for k=0, 4, 8
  #            = 1 for k=1, 5, 9
  #            = 0 for k=2, 6, 10
  #            = -1 for k=3, 7, 11

# e^x: derivative @x=0 is 1 for all derivatives

x<-seq(-pi*4,pi*4,length=101)

K<-seq(0,20)
PlotThis<-data.frame()
approxSin<-rep(0,length(x))
approxExp<-rep(0,length(x))
for (kk in K) {
  
  if ((kk %% 4)==0) {
    d<-  0
  }
  else if ((kk %% 4)==1) {
    d<-  1
  }
  else if ((kk %% 4)==2) {
    d<- 0
  }
  else {
    d<- -1
  }
  
  approxSin<-approxSin+d/factorial(kk)*(x-0)^kk
  
  temp<-data.frame(x)
  temp$approx<-approxSin
  temp$k<- kk
  temp$fun <-"sin(x)"
  
  PlotThis<-rbind(PlotThis,temp)
  
  approxExp<-approxExp+(1/factorial(kk)*(x-0)^kk)*exp(-12)
  temp<-data.frame(x)
  temp$approx<-approxExp
  temp$k<- kk
  temp$fun <-"exp(x)*exp(-12)"
  
  PlotThis<-rbind(PlotThis,temp)
  

  
  
}


plt<-(ggplot(data=PlotThis,aes(x=x,y=approx,color=fun))
      +geom_line(size=2)
      +geom_line(aes(x=x,y=sin(x)),color="black",size=1)
      +geom_line(aes(x=x,y=exp(x)*exp(-12)),color="black",size=1)
      +theme_bw()
      #+facet_wrap( ~ fun)
      +ylim(-2,2)
      +transition_states(k)
      +labs(title="polynomial order: {next_state}")
  
)
plt
