clear all

import delimited "DieRolls.csv", delimiter(comma) case(preserve) 

describe

// calculate sample mean
summarize

// Problem: we want to split things up by Type

by Type, sort: summarize Count
// note that now Stata understands that we have sorted by Type:
describe

// Suppose you only cared about Type = 4
summarize Count if Type == 4

//sort Count
