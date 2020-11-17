// sheep

clear all

set obs 48

generate treatment = _n<=24
generate Death_actual = (_n==1) | (_n>=28)

generate Death_a = (_n==1) | (_n>=25) 

tab Death_a treatment

eststo col_a: regress Death_a treatment
eststo col_ah: regress Death_a treatment, robust

esttab col_*, se


/*
clear all

use Ch4_Exercise1_Height_and_Wages_US

describe
