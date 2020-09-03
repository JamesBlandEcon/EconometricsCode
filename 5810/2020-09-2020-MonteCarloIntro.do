/* 1) Code up just one draw from the 
distribution
*/
clear all

set obs 1000

// X ~ U[0,1]
//generate X = runiform()
//histogram X

// X ~ U[0,a]
	local a = 2
	display `a'
	generate X = runiform(0,`a')
	
summarize X
	local alphaHat = 2*r(mean)
	local alphaTilde = r(max)
	local alphaTildeP = r(max)*(_N+1)/_N
	
	display "alphaHat = `alphaHat'"
	display "alphaTilde = `alphaTilde'"
	display "alphaTildeP = `alphaTildeP'"

/* 2) Write a progam that does this
*/
clear all
program define EstimateAlpha, rclass
version 13
	clear
	args n a
	set obs `n'
	generate X = runiform(0,`a')
	
	summarize X
	return scalar alphaHat = 2*r(mean)
	return scalar alphaTilde = r(max)
	return scalar alphaTildeP = r(max)*(_N+1)/_N
end
EstimateAlpha 100 5
return list
display r(alphaHat)

/* 3) Use Stata's "Simulate" command to run this 
may, many times
*/

simulate , reps(1000): EstimateAlpha 200 5

summarize
set scheme s2mono
twoway (kdensity alphaHat) (kdensity alphaTilde) (kdensity alphaTildeP)


