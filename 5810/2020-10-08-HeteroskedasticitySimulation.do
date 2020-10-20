/* 1) Code up just one draw from the 
distribution
*/
clear all

set obs 1000
set seed 42

generate X = rnormal()

/*
Homoskedastic:
	V[e_i] does not depend on i
	(it is a constant across rows of data)
*/

/* True model: Y = X + e
B0 = 0, B1 = 1
*/

//	1) e ~ iid N(0,1) (homoskedastic)
		generate Y1 = X + rnormal()
		//twoway (scatter Y1 X, msize(0.2)) (lfit Y1 X)
		
//	2) e ~ iid U[-0.5,+0.5] (homoskedastic)
		generate Y2 = X + (runiform()-0.5)*sqrt(12)
		//twoway (scatter Y2 X, msize(0.2)) (lfit Y2 X)
		
//  3) e ~ ind N(0,c*abs(X)+d) (but not identical)
		generate e3 = rnormal()*sqrt(9*abs(X)+1)
		// normalize so V[e3] = 1
		summarize e3
		generate Y3 = X + e3/`r(sd)'
		//twoway (scatter Y3 X, msize(0.2)) (lfit Y3 X)
		
//	4) e ~ ind N(0,V)
	// V[e_i] = a if i is odd, 2a otherwise
	generate e4 = rnormal()
	replace e4 = e4*2 if (floor(_n/2)-_n/2)==0
	summarize e4
	generate Y4 = X + e4/`r(sd)'
	//twoway (scatter Y4 X, msize(0.2)) (lfit Y4 X)

forvalues yy = 1/4 {	
	
	// homoskedastic se
	regress Y`yy' X
	estimates store reg_`yy'
	estadd local Heteroskedastic = "-"
	
	// heteroskedastic se
	regress Y`yy' X, robust
	estimates store reg_`yy'_heteroskedastic
	estadd local Heteroskedastic = "Y"
}

// ssc install estout
esttab reg_* using HeteroskedasticityTable.rtf, se replace compress scalars(Heteroskedastic)



