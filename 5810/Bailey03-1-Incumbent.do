clear all

use Ch3_Exercise1_Incumbent_vote.dta
describe

 twoway (scatter vote rdi4) (lfit vote rdi4)
 
 // constant only model
 
 eststo reg_1: regress vote
 
 // bivariate models
 eststo reg_2: regress vote rdi4
 eststo reg_3: regress vote avgunemployment
 eststo reg_4: regress vote stock
 
 esttab reg_*, se r2
 
 twoway (scatter vote stock) (lfit vote stock)
