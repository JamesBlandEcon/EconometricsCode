// this is a comment. Stata will ignore this

/* This is a comment over multiple lines
Stata ignores everything until this thing below
*/

// clear everything in memory
clear

// change the working directory (default file path)
 cd "C:\Users\jbland\OneDrive - University of Toledo\Classes\Econometrics 1\code2020F\5810"

// import data
import excel "CommuteWithTime.xlsx", sheet("Sheet1") firstrow 

// describe the data
describe

// summarize the variables
summarize

// ...
summarize distance
summarize distance time
summarize *e
summarize distance, detail

/*
Summarize distance, then display its total
(which summarize calculates but doesn't display
by default)
*/
summarize distance
	display r(sum)

// Assign labels to variables (these show up in the plot)
label variable time "time (s)"
label variable distance "distance (miles)"

// produce scatter plot
scatter time distance
// save the plot to working directory
graph export JBCommute.png, replace
//graph export Outputs/JBCommute.png
//graph export ../JBCommute.png
