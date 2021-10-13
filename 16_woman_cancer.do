
***********************
*** Woman Cancer*******
***********************
	
*w_papsmear	Women received a pap smear  (1/0) 
*w_mammogram	Women received a mammogram (1/0)

gen w_papsmear = .
gen w_mammogram = .

if inlist(name, "Brazil1996"){
    ren v012 wage	
    replace w_papsmear=0 if s239!=.
    replace w_papsmear=1 if s242==1
    replace w_papsmear=. if s242==. & s239!=0
    tab wage if w_papsmear!=. /*DHS sample is women aged 15-49*/
    replace w_papsmear=. if wage<20|wage>49
	
	replace w_mammogram=0 if s239!=.
	replace w_mammogram=1 if s243==1
    replace w_mammogram=. if inlist(s243,.,8) & s239!=0
    tab wage if w_mammogram!=. /*DHS sample is women aged 15-49*/
    replace w_mammogram=. if wage<40|wage>49
}
// They may be country specific in surveys.


*Add reference period.
//if not in adeptfile, please generate value, otherwise keep it missing. 
//if the preferred recall is not available (3 years for pap, 2 years for mam) use shortest other available recall 

gen w_mammogram_ref = ""  //use string in the list: "1yr","2yr","5yr","ever"; or missing as ""
gen w_papsmear_ref = ""   //use string in the list: "1yr","2yr","3yr","5yr","ever"; or missing as ""

* Add Age Group.
//if not in adeptfile, please generate value, otherwise keep it missing. 

gen w_mammogram_age = "" //use string in the list: "20-49","20-59"; or missing as ""
gen w_papsmear_age = ""  //use string in the list: "40-49","20-59"; or missing as ""


if inlist(name, "Brazil1996"){
    replace w_papsmear_age = "20-49"
    replace w_mammogram_age = "40-49"

}


