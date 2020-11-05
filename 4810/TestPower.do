
clear all

use Ch4_Exercise1_Height_and_Wages_US

describe

generate B1A = -0.5+1*((_n-1)/(_N-1))

eststo reg_1: regress wage96 height81
eststo reg_2: regress wage96 height81, robust

esttab reg_*, se
	local se = 0.082851
	local seH = 0.0864
	local B1H0 = 0
	local tc = 1.96 // 5% test
	
generate power = normal(-`tc'-(B1A-`B1H0')/`se') + 1 - normal(`tc'-(B1A-`B1H0')/`se')
generate powerH = normal(-`tc'-(B1A-`B1H0')/`seH') + 1 - normal(`tc'-(B1A-`B1H0')/`seH')
twoway (line power powerH B1A )

