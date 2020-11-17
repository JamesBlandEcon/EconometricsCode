clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

generate female = gender=="female"

eststo reg_1: regress childheight i.female, robust
eststo reg_2: regress childheight 0.female, robust

	ttest childheight, by(female)

// paralell lines, different intercepts	
eststo reg_3: regress childheight midparentheight i.female, robust
	predict yhat, xb
	
//twoway (scatter yhat midparentheight)
	
// different slopes for each group
eststo reg_4: regress childheight c.midparentheight c.midparentheight#1.female
// could also estimate column 4 like this:
			generate midparentheightXfemale = midparentheight*female
			regress childheight midparentheight midparentheightXfemale, robust

// different slopes and different intercepts
eststo reg_5: regress childheight c.midparentheight##i.female, robust

eststo reg_6: regress childheight 1.female c.midparentheight#i.female, robust
// column (6) usoing bivariate OLS:
eststo reg_7: regress childheight midparentheight if female ==1, robust
eststo reg_8: regress childheight midparentheight if female ==0, robust
	esttab reg_* , se nogaps compress label replace r2
	
//esttab reg_* using DummyVariables.rtf, se nogaps compress label replace


regress childheight c.midparentheight##i.female, robust
	margins 
	margins i.female
	
	display _b[midparentheight]
	display _b[midparentheight]+_b[1.female#c.midparentheight]
	margins i.female, dydx(midparentheight)
	predict yhat2, xb
	summarize yhat
