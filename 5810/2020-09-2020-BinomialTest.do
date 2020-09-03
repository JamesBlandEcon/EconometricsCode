clear all

set obs 21
generate t = _n-1
generate F = binomial(20,t,0.5)

twoway (line F t)
