clear 
use Ch4_Exercise1_Height_and_Wages_US.dta
describe

/* Goal:
produce a regession table, with wage on the LHS
and height on the RHS
Column 1 is for all data
columns 2-5 are for each pairwise combination 
of (black/not black) x (male / not male)

*/	





	local RHSlist = "height85 esteem80 age "
	
foreach vv of local RHSlist {

regress wage96 `vv', robust
	estimates store col_1	
forvalues bb = 0/1 {
	forvalues mm = 0/1 {
		display `bb'
		display `mm'
		display "--"
		local restriction = ""
		local restriction2 = ""
		//if `mm'==1 {}
		if `mm'==1 {
			local restriction = `restriction' "male"
		}
		else {
			local restriction = `restriction' "not male"
		}
		
		if `bb'==1 {
			local restriction2 = `restriction2' "black"
		}
		else {
			local restriction2 = `restriction2' "not black"
		}
		regress wage96 `vv' if black == `bb' & male == `mm', robust
			estimates store col_x`bb'_`mm'
			estadd local restriction = "`restriction'"
			estadd local restriction2 = "`restriction2'"
	}
}



	
// ssc install estout
esttab col_* using `vv'.rtf, replace se r2 scalars(restriction restriction2)
}
