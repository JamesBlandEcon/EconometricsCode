clear 
set obs 101
generate t = _n-1
generate F = binomial(100,t,0.5)

twoway (line F t)
