clear
use Ch4_Exercise1_Height_and_Wages_US.dta
describe

eststo col_1: regress wage96 height81
	estadd local SE "standard"
// can we "diagnose" heteroskedasticity?
predict residuals, resid

generate residuals2 = residuals^2
generate lresiduals2 = log(residuals2)

// twoway (scatter lresiduals2 height81, msize(0.01) jitter(5)) (lfit lresiduals2 height81)

eststo col_2: regress lresiduals2 height81
	estadd local SE "standard"
	
eststo col_3: regress wage96 height81, robust
	estadd local SE "Heteroskedasticity-robust"
esttab col_*, se r2 scalars(SE)

/* Simulate data where the true model
is : Y = X + e (b0 = 0, b1 = 1)
 - change the specification of the 
 error term

*/
clear all
set seed 42
set obs 1000
// X ~ N(0,1)
generate X = rnormal()

// 1) e ~ iidN(0,1) - homoskedasticity
generate Y1 = X+rnormal()
// 2) e ~ iid U[-0.5,0.5]*sqrt(12)
generate Y2 = X + (runiform()-0.5)*sqrt(12)
//twoway  (scatter Y2 X, msize(0.2))

// 3) e | X ~ N(0,c(0.1+X^2))
generate e3 = rnormal()*sqrt(0.1+X^2)
summarize e3
generate Y3 = X + e3/r(sd)

twoway (scatter Y3 X, msize(0.2))  (lfit Y3 X) 

// 3) e | X ~ N(0,c(1+I(n is even)))
generate e4 = rnormal()*(1+(floor(_n/2)==(_n/2)))
summarize e4
generate Y4 = X + e4/r(sd)

twoway (scatter Y4 X, msize(0.2))  (lfit Y4 X) 

forvalues ii = 1/4 {
	eststo col_`ii': regress Y`ii' X
		estadd local SE "standard"
		
		predict residuals, resid
		generate residuals2 = residuals^2
		regress residuals2 X
		local br= _b[X]
		
		
		drop residuals residuals2 
		
	eststo col_`ii'h: regress Y`ii' X, robust
		estadd local SE "h-robust"
		estadd scalar ResidSlope = `br'
}
esttab col_*, se compress nogaps scalars(SE ResidSlope)


