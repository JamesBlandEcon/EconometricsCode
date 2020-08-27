clear

set obs 60
generate U = runiform()
generate C = 1 if U>=0.5
	replace C = 0 if U<0.5
	
summarize C
	display r(sum)
	