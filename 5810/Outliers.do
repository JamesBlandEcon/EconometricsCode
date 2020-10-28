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
	predict yhat, xb
esttab col_*, se r2

generate LogWage = log(wage96)
generate logYhat = log(yhat)

sort logYhat

twoway (scatter LogWage height85 if keepThis==1, msize(0.01) jitter(5)) (scatter LogWage height85 if keepThis==0, msize(0.5) jitter(5)) (line logYhat height85 if keepThis==1), ytitle("log-hourly wages") legend(label(1 "Data we kept") label(2 "Data we dropped") label(3 "Model after dropping data"))


