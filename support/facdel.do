*This file is to generate the list of value label for m15 (delivery of birth)
*Etract the survey name and the lables and identify whether they are skilled or not.

global root "C:\Users\wb500886\WBG\Sven Neelsen - World Bank\MEASURE UHC DATA"

* Define path for data sources
global SOURCE "${root}/RAW DATA/Recode VI"

* Define path for output data
global OUT "${root}/STATA/DATA/SC/FINAL"

* Define path for INTERMEDIATE
global INTER "${root}/STATA/DATA/SC/INTER"

* Define path for do-files
global DO "${root}/STATA/DO/SC/DHS/Recode VI"

* Define the country names (in globals) in by Recode
do "${DO}/0_GLOBAL.do"

//please define your global here. 

foreach name in $DHScountries_Recode_VI{	
use "${SOURCE}/DHS-`name'/DHS-`name'birth.dta", clear	
	decode m15, gen(m15_lab)
	replace m15_lab = lower(m15_lab)
	
	gen c_hospdel = 0 if !mi(m15)
	replace c_hospdel = 1 if ///
    regexm(m15_lab,"medical college|surgical") | ///
	regexm(m15_lab,"hospital") & !regexm(m15_lab,"center|sub-center|post|clinic")
	replace c_hospdel = . if mi(m15) | m15 == 99 | mi(m15_lab)	
	
	gen c_facdel = 0 if !mi(m15)
	replace c_facdel = 1 if regexm(m15_lab,"hospital") | ///
	!regexm(m15_lab,"home|other private|other$|pharmacy|non medical|private nurse|religious|abroad")
	replace c_facdel = . if mi(m15) | m15 == 99 | mi(m15_lab)
	
	gen name = "`name'"
	keep m15_lab m15 c_hospdel c_facdel name
	duplicates drop m15 name,force

	save "${INTER}/`name'_hspt.dta", replace  
	}
	
//ssc install fs (use this if fs is not installed	
cd "${INTER}"	
fs  *_hspt.dta
local firstfile: word 1 of `r(files)'
use `firstfile', clear
foreach f in `r(files)' {
 if "`f'" ~= "`firstfile'" append using `f'
}

export excel using "C:\Users\wb500886\OneDrive - WBG\10_Health\UHC\regulate_var\varlist_hspt_full.xlsx", sheet("full") firstrow(var) replace

keep m15_lab c_hospdel c_facdel
duplicates drop

export excel using "C:\Users\wb500886\OneDrive - WBG\10_Health\UHC\regulate_var\varlist_hspt.xlsx", sheet("label_only") firstrow(var) replace
