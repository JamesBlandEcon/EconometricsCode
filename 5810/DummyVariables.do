clear all
import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

generate Female = gender=="female"

// two-sample t-tests
	// bivariate OLS, homoskedasticity
	eststo reg_1: regress childheight Female
		ttest childheight, by(Female)
		estadd local t=r(t)
	
	// bivariate OLS, heterokedasticity
	eststo reg_2: regress childheight Female, robust
		ttest childheight, by(Female) unequal
		estadd scalar t=r(t)
	// Bivariate test, difference has same sign
	generate Male = 1-Female
	eststo reg_3: regress childheight Male, robust
	
	esttab reg_*, t(5) scalars(t) 
	
// Multivariate OLS with dummy variable
	eststo m_0: regress childheight  Female, robust
	eststo m_1: regress childheight mother father Female, robust
	
	
	esttab m_*, se


// interactions
	eststo i_1: regress childheight midparentheight, robust
	
	// different intercepts based on male or female
	eststo i_2: regress childheight midparentheight i.Female, robust
	eststo i_3: regress childheight midparentheight Female, robust
	
	// different slopes for sons and daughters (but same intercept)
	eststo i_4: regress childheight c.midparentheight#i.Female
	
	// different slopes and intercepts
	eststo i_5: regress childheight i.Female c.midparentheight#i.Female
	
	esttab i_*, se compress nogaps label
	
	
	
	
//regress childheight i.X

