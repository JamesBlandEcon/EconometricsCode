clear
use Ch4_Exercise1_Height_and_Wages_US.dta
describe

//twoway (scatter wage96 height85, msize(0.2) jitter(5)) (lfit wage96 height85)


// the basic regression
/*
test 	H0: b1 == 0.3
		HA: b1 ~= 0.3
*/

regress wage96 height85, robust
	local b  = _b[height85]
	local se = 0.0809117
	local t = (`b'-0.3)/`se'
	display `t'
// (so we would fail to reject H0)	

// Power: if b1 = a, what is the probability 
// we would reject H0?

local a = 0.1
local tc = invnormal(1-0.1/2)

local power = normal(-`tc'-(`a'-0.3)/`se')+1-normal(`tc'-(`a'-0.3)/`se')

display `power'

generate a = -1 +2*_n/_N

generate power = normal(-`tc'-(a-0.3)/`se')+1-normal(`tc'-(a-0.3)/`se')

twoway (line power a)
	


//test height85=0.3

clear

// Binomial test

local N = 100

local testsize = binomial(`N', 40, 0.5)+1-binomial(`N', 60, 0.5)
display `testsize'

// rejection rule: reject H0 if <5 Heads, or >96 heads

set obs 1001
generate p = (_n-1)/_N
generate power = binomial(`N', 40, p)+1-binomial(`N', 60, p)

twoway (line power p), xline(0.5) yline(`testsize')
