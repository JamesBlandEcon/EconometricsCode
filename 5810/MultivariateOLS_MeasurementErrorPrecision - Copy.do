clear all
set seed 42
import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

describe

generate female = gender == "female"


// measurement error in Y
// Y = Y* + mu
// mu ~ N(0,sqrt(s))
generate childheight_noisy = childheight+sqrt(2)*rnormal()

eststo col1: regress childheight mother father female, robust
eststo col2: regress childheight_noisy mother father female, robust

// measure error in X
// X = X* + nu
// nu ~ N(0,1)
// V[nu_father + nu_ mother] = 1+1 = 2
generate father_noisy = father +rnormal()*sqrt(1)
generate mother_noisy = mother +rnormal()*sqrt(1)

eststo col3: regress childheight mother_noisy father_noisy female, robust

eststo col4: regress childheight_noisy mother_noisy father_noisy female, robust
esttab col*, se r2

// precision

eststo reg_1: regress childheight mother father female
eststo reg_2: regress childheight        father female
	predict resid_Y, resid
eststo reg_3: regress mother father female
	predict resid_X, resid
eststo reg_4: regress resid_Y resid_X

generate male = 1-female

eststo reg_5: regress childheight mother father female male

summarize mother resid_X

eststo reg_6: regress childheight  midparentheight mother father female

esttab reg_*, r2 se




