// ssc install estout
clear all
import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

generate female = gender =="female"

//eststo col_1: regress childheight mother father female, robust
eststo col_1: regress childheight mother father female, robust beta
eststo col_2: regress childheight midparentheight female, robust beta
	summarize childheight
	generate S_CH = (childheight -r(mean))/r(sd)
	summarize midparentheight
	generate S_MPH = (midparentheight -r(mean))/r(sd)
eststo col_3: regress S_CH S_MPH female, robust beta
esttab col_*, se r2

eststo clear

eststo col_1: regress childheight mother father   female, robust
eststo col_2: regress childheight                 female, robust
eststo col_3: regress childheight midparentheight female, robust
esttab col_*, se r2

// Test H0: coefficients on mother and father height both equal to zero
regress childheight mother father   female, robust
test mother=0
test father=0, accumulate

//Test H0: coefficients on mother and father height are equal
regress childheight mother father   female, robust
test mother = father
regress childheight mother father   female, 
test mother = father
