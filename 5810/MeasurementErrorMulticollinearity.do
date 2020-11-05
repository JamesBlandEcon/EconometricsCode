clear all
 use Ch4_Exercise1_Height_and_Wages_US
 describe
 
 eststo col_1: regress wage96 height81 height85 esteem
 
 eststo col_2: regress height81 height85 esteem
 eststo col_3: regress  height85 esteem height81
 eststo col_4: regress  esteem height81 height85
 
 generate Z = rnormal()*2+esteem
 
 eststo col_5: regress wage96 height81 height85 esteem Z
 
 esttab col_*, se r2 label
 
 graph matrix height81 height85 esteem, msize(0.05) jitter(2)
