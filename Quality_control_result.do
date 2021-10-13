
*****************************************
*** Combine the quality control result **
*****************************************
capture which fs  
	if _rc!=0{
		ssc install fs,replace  
	}
fs  *.dta
local firstfile: word 1 of `r(files)'
use `firstfile', clear
foreach f in `r(files)' {
 if "`f'" ~= "`firstfile'" append using `f'
}

*keep if flag_dhs == 1| flag_hefpi == 1
