clear all

set obs 101
local N = _N-1
generate h = _n-1
generate cdf_exact =  binomial(`N',h,0.5)

generate teststat = 2*sqrt(`N')*(h/`N'-0.5)
generate cdf_approx = normal(teststat)

label variable cdf_exact "Exact distribution of Z"
label variable cdf_approx "Aproximate distribution of Z"

twoway (line cdf_exact cdf_approx teststat), yline(0.975)

