clear

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv


generate fortyfive = midparentheight
#delimit ;
twoway (scatter  childheight midparentheight,
				msize(0.5) jitter(10))
		(lfit childheight midparentheight)
		(line fortyfive  midparentheight)

;

regress childheight midparentheight
