clear all

import delimited https://vincentarelbundock.github.io/Rdatasets/csv/HistData/GaltonFamilies.csv

desc

encode gender, generate(MF)

generate av_parent = 0.5*(father+mother)


#delimit ;
twoway (scatter  childheight av_parent if MF==2, msize(0.5) jitter(5) )
(scatter  childheight av_parent if MF==1, msize(0.5) jitter(5) )
(lfit  childheight av_parent if MF==2 )
(lfit  childheight av_parent if MF==1 ),
legend(label(1 "sons")
		label(2 "daughters")
		label(3 "sons - linear fit")
		label(4 "daughters - linear fit")
		)
;
#delimit cr


// line of best fit for all data
regress childheight av_parent

// line of best fit for daughters
regress childheight av_parent if MF==1

// line of best fit for sons
regress childheight av_parent if MF==2
