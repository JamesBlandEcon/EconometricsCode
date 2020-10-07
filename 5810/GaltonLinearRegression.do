clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

desc

encode gender, generate(MF)

generate av_parent = 0.5*(father+mother)

/*
#delimit ;
twoway (scatter  childheight av_parent if MF==2, msize(0.5) jitter(5) )
(scatter  childheight av_parent if MF==1, msize(0.5) jitter(5) )
(lfit  childheight av_parent if MF==2 )
(lfit  childheight av_parent if MF==1 ),
legend(label(1 "sons")
		label(2 "daughters")
		label(3 "sons - linear fit")
		label(4 "daughters - linear fit")
		)
;
#delimit cr
*/

// line of best fit for all data
regress childheight av_parent
predict yhat, xb
generate residuals = childheight-yhat
generate residuals2 = residuals^2
summarize residuals2
local s2hat = r(mean)
display `s2hat'

summarize av_parent
generate denominator = (av_parent-r(mean))^2
summarize denominator

local den = r(sum)
display `den'

local Vb1 = `s2hat'/`den'
display `Vb1'
display sqrt(`Vb1')
regress childheight av_parent

/* Does it lokk like the variance of e changes 
with parent height?
*/
generate diffParent = (father-mother)
generate diffparent2 = diffParent^2
twoway (scatter residuals2 diffParent) (lfit residuals2 diffParent)

by MF, sort: summarize residuals2

// Heteroskedasticity-robust SEs

generate Xe = denominator*residuals2
summarize Xe
local q = r(sum)
local RobustV = `den'^(-2)*`q'
disp sqrt(`RobustV')
regress childheight av_parent, robust
regress childheight av_parent
