// clear the memory
clear

// import our data
import excel "C:\Users\jbland\OneDrive - University of Toledo\Classes\Econometrics 1\code2020F\4810\CommuteWithTime.xlsx", sheet("Sheet1") firstrow

// tell us a bit about what is in the data and how it is stored
describe

// show some summary statistics of the data
summarize

summarize distance
summarize distance time
summarize *e

/* A comment over a few lines
Problem: we don't see the total, but we do see Obs & mean
mean = total / Obs
total = mean * Obs

"help summarize"
Note at the bottom, in "stored results", it stores "r(sum)"
*/
summarize distance
display r(sum)

generate distance_km = distance * 1.61
summarize distance_km
display r(sum)

label variable time "time (seconds)"
label variable distance "distance (miles)"
describe

twoway (scatter time distance) (lfit time distance) 
graph export DrBCommute.png, replace
