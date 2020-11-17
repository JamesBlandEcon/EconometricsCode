clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

generate female = gender == "female"

summarize midparentheight

// bivariate:
eststo col_1: regress childheight midparentheight
	margins , post
	estimates store margins_1

// different intercepts
eststo col_2: regress childheight midparentheight ib0.female
margins i.female , post
	estimates store margins_2
// different slopes
eststo col_3: regress childheight c.midparentheight#ib0.female 
	margins i.female, post
	estimates store margins_3
// different slopes and intercepts
eststo col_4: regress childheight c.midparentheight#ib0.female  ib0.female
	margins i.female, post
	estimates store margins_4
	
eststo col_5: regress childheight c.midparentheight c.midparentheight#1.female  1.female
	margins i.female, post
	estimates store margins_5
esttab col_*, se r2 label

// average prediction by groups
esttab margins_*, se r2 label

// col 5 again
regress childheight c.midparentheight c.midparentheight#1.female  1.female
// individual slopes
margins i.female, dydx(midparentheight)
// average slope over all data
margins , dydx(midparentheight)


// 1- and 2-sided p-values
regress childheight midparentheight
