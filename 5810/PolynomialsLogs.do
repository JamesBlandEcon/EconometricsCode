// ssc install estout
clear

cd ..
cd ..
use WVS_Cross-National_Wave_7_stata_v1_4
cd EconometricsCode/5810

//twoway ( scatter Q49 incomeindexHDI, msize(0.01) jitter(5))

// bivariate OLS:
eststo col_1: regress Q49 c.incomeindexHDI, robust

eststo col_2: regress Q49 c.incomeindexHDI c.incomeindexHDI#c.incomeindexHDI, robust
	predict yhat, xb
	predict yhatSE, stdp

// b2 <0 ==> hill-shaped parabola

// at what income (index) is satisfaction maximized?

local HDImax =  -_b[incomeindexHDI]/(2*_b[c.incomeindexHDI#c.incomeindexHDI])

estadd scalar HDImax = `HDImax'

//histogram incomeindexHDI, xline(`HDImax')

// put a CI around the index that maximizes life satisfaction
nlcom maxHDI: -_b[incomeindexHDI]/(2*_b[c.incomeindexHDI#c.incomeindexHDI])
esttab col_*, se r2 label scalars(HDImax)

sort incomeindexHDI

// put a CI around the parabola (condirtional mean)
generate yhat_LB = yhat-1.96*yhatSE
generate yhat_UB = yhat+1.96*yhatSE

// put a CI around the derivative of the parabola
margins , dydx(incomeindexHDI)

margins , dydx(incomeindexHDI) at(incomeindexHDI=(0.5 0.6 0.7 0.8 0.9))

// to replicate the point estimate
generate dydx = _b[incomeindexHDI]+2*_b[c.incomeindexHDI#c.incomeindexHDI]*incomeindexHDI



summarize dydx

 
twoway  (line yhat yhat_* incomeindexHDI) // ( scatter Q49 incomeindexHDI, msize(0.01) jitter(2))

clear

import delimited "https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv"

generate female = gender=="female"

regress childheight mother father female

// relative infuence of mother height
nlcom _b[mother]/(_b[mother]+_b[father])



