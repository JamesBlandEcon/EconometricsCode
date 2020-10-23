clear
use Ch4_Exercise1_Height_and_Wages_US.dta
describe

twoway (scatter wage96 height85, msize(0.2) jitter(5)) (lfit wage96 height85)
regress wage96 height85
dfbeta

histogram _dfbeta_1

regress wage96 height85 if abs(_dfbeta_1)<0.1, robust

kill

regress wage96 height85, robust
predict residuals, resid
generate residuals2 = residuals^2
summarize residuals2
	local SSR = r(sum)
	display `SSR'

summarize wage96
generate YminusMean2 = (wage96-r(mean))^2
summarize YminusMean2
	local TSS = r(sum)
	display `TSS'
	
local R2 = 1-`SSR'/`TSS'
	display `R2'
	
/* Leave-one-out cross-validation

For every observation i
 - Estimate the model without observation i
 - Calculate the prediction for observation i
 Assess R2 using these out-of-sample predictions

*/

generate yhat = .
generate ymean = .

//forvalues ii = 1/12686 {
forvalues ii = 1/200 {
quietly {
	regress wage96 height85 if _n ~=`ii', robust
	predict yii, xb
	replace yhat = yii if _n==`ii'
	
	summarize wage96 if _n ~=`ii'
	replace ymean = r(mean) if _n==`ii'
	drop yii
	
	}
	display `ii'
}

generate DYhat = (yhat-wage96)^2
generate DYmean = (ymean-wage96)^2
summarize DY*
