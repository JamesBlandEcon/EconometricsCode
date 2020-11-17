clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

twoway (scatter childheight midparentheight, msize(0.2) jitter(5)) (lfit childheight midparentheight), name(Bivariate)

twoway (kdensity childheight if gender =="female") (kdensity childheight if gender =="male"), legend(label(1 "Daughters") label(2 "Sons")) name(distributions)



// problem: a lot of the variation in child height is due to "gender"

eststo reg_1: regress childheight midparentheight, robust

generate female = gender=="female"

eststo reg_2: regress childheight female, robust

eststo reg_3: regress midparentheight female, robust
esttab reg_*, se r2

// How much of childheight can we "explain" using "gender"?
eststo col_1: regress childheight female, robust
	predict resid1, resid
// How much of midparentheight can we "explain" using "gender"
eststo col_2: regress midparentheight female, robust
	predict resid2, resid
// How much of the component of childheight that is *not* "explained" by "gender" can be "explained" by the component of "midparentheight" that is not "explained" by gender?
eststo col_3: regress resid1 resid2, robust

eststo col_4: regress childheight female midparentheight, robust
	predict yhat, xb
	
	coefplot

esttab col_*, se r2

twoway (scatter resid1 resid2, msize(0.2)) (lfit resid1 resid2), name(residuals)

twoway (scatter childheight midparentheight if female==1,msize(0.2) jitter(5)) (scatter childheight midparentheight if female==0,msize(0.2) jitter(5)) (line yhat midparentheight if female==0) (line yhat midparentheight if female==1), name(multivariate)

graph combine Bivariate distributions residuals multivariate

