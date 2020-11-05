
clear all

set obs 1000
// true model: Y = e
generate X = rnormal()
generate error = (X^2+0.3)*rnormal()
summarize error
generate Y = error/r(sd)
//summarize Y
regress Y X
	test X = 0
	local pHomoskedasticity = r(p)
regress Y X, robust
	test X = 0
	local pHeteroskedasticity = r(p)
	
	display `pHomoskedasticity'
	display `pHeteroskedasticity'
	
clear all

program define Heteroskedasticity, rclass
	set obs 1000
	// true model: Y = e
	generate X = rnormal()
	generate error = (X^2+0.3)*rnormal()
	summarize error
	generate Y = error/r(sd)
	//summarize Y
	regress Y X
		test X = 0
		return scalar pHomoskedasticity = `r(p)'
	regress Y X, robust
		test X = 0
		return scalar pHeteroskedasticity = `r(p)'
		
		clear
end

Heteroskedasticity

simulate pHomoskedasticity=r(pHomoskedasticity) pHeteroskedasticity=r(pHeteroskedasticity), reps(1000): Heteroskedasticity

local plotOptions "xline(0.05)"

histogram pHeteroskedasticity, `plotOptions' name(p1)
histogram pHomoskedasticity, `plotOptions' name(p2)

graph combine p1 p2

generate rejectHeteroskedasticity = pHeteroskedasticity<0.05
generate rejectHomroskedasticity = pHomoskedasticity<0.05

summarize reject*

