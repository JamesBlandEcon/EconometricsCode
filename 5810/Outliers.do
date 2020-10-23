clear
use Ch4_Exercise1_Height_and_Wages_US.dta
describe

//twoway (scatter wage96 height85, msize(0.2) jitter(5)) (lfit wage96 height85)


// the beasic regression
eststo col_1: regress wage96 height85, robust
	local bHatAll = _b[height85]
	display `bHatAll'

generate Manual_dfbeta = .
// try to diagnose outliers with undue influence
forvalues ii = 1/10 {
	regress wage96 height85 if _n ~=`ii'
	replace Manual_dfbeta = _[height85]-`bHatAll' if _n ==`ii'
}

regress wage96 height85
dfbeta

histogram _dfbeta_1

summarize _dfbeta_1, detail

generate keepThis = (_dfbeta_1>r(p1) & _dfbeta_1<r(p99))


//histogram _dfbeta_1 if keepThis

eststo col_2: regress wage96 height85 if keepThis, robust
esttab col_*, se r2


twoway (scatter wage96 height85, msize(0.2) jitter(5)) (lfit wage96 height85)


