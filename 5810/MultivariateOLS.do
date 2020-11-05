clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

twoway (scatter childheight midparentheight if gender=="male", msize(0.2) jitter(5)) (scatter childheight midparentheight if gender=="female", msize(0.2) jitter(5) mcolor(red)) (lfit childheight midparentheight) (lfit childheight midparentheight if gender=="male") (lfit childheight midparentheight if gender=="female"), legend(label(1 "sons") label(2 "duaghters")) name(rawData)

sort gender

by gender: egen meanheight = mean(childheight)
by gender: egen meanheightP = mean(midparentheight)
generate DeMeanChildHeight = childheight -meanheight
generate DeMeanParent = midparentheight -meanheightP

twoway (scatter DeMeanChildHeight DeMeanParent if gender=="male", msize(0.2) jitter(5)) (scatter DeMeanChildHeight DeMeanParent if gender=="female", msize(0.2) jitter(5) mcolor(red)) (lfit DeMeanChildHeight DeMeanParent), name(DeMean)

graph combine rawData DeMean

eststo col1: regress childheight midparentheight

eststo col2: regress DeMeanChildHeight DeMeanParent

encode gender, generate(G)

eststo col3: regress childheight midparentheight G

esttab col*, se


kill

// Bivariate OLS

eststo col1: regress childheight midparentheight

eststo col1a: regress childheight midparentheight if gender == "male"
estadd local restriction = "sons"

eststo col1b: regress childheight midparentheight if gender == "female"
estadd local restriction = "daughters"

eststo col2: regress childheight mother father
	predict cook, cooksd, if e(sample)
	histogram cook, name(cook)
	
eststo col3: regress childheight mother father if gender == "male"
estadd local restriction = "sons"

eststo col4: regress childheight mother father if gender == "female"
estadd local restriction = "daughters"



esttab col*, se scalars(restriction) r2
kill
 regress childheight mother father
 dfbeta
 
  
 
 generate keepThese = sqrt(_dfbeta_1^2+_dfbeta_2^2)<0.1
 
 twoway (scatter _dfbeta_1 _dfbeta_2 if keepThese==1, msize(0.5)) (scatter _dfbeta_1 _dfbeta_2 if keepThese==0, msize(0.5) mcolor(red)), name(full)

 eststo colRestricted: regress childheight mother father if keepThese == 1
 
 esttab col2 colRestricted, se
 
 
 drop if _n>30
 drop _dfbeta_*
 
 regress childheight mother father
 dfbeta
 
 twoway (scatter _dfbeta_1 _dfbeta_2, msize(0.5)), name(restricted)
 
 graph combine full restricted cook
 
 
 
 