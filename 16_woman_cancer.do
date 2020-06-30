
***********************
*** Woman Cancer*******
***********************
	
*w_papsmear	Women received a pap smear  (1/0) 
*w_mammogram	Women received a mammogram (1/0)

gen w_papsmear = .
gen w_mammogram = .

capture confirm variable s714dd s714ee 
if _rc==0 {
    replace w_papsmear=1 if s714dd==1 & s714ee==1
	replace w_papsmear=0 if s714dd==0 | s714ee==0
	replace w_papsmear=. if s714dd==9 | s714ee==9
}

capture confirm variable s1011a s1011 s1012c s1012b
if _rc == 0 {
    ren v012 wage	
	replace s1011a=. if s1011a==98|s1011a==99
    replace w_papsmear=1 if (s1011==1&s1011a<=23)
    replace w_papsmear=0 if s1011==0
    replace w_papsmear=0 if w_papsmear == . & s1011a>35 & s1011a<100
    replace w_papsmear=. if s1011==.
    tab wage if w_papsmear!=. /*DHS sample is women aged 15-49*/
    replace w_papsmear=. if wage<20|wage>49
	
	replace w_mammogram=1 if s1012c==1
    replace w_mammogram=0 if s1012c==0|s1012b==0
    tab wage if w_mammogram!=. /*DHS sample is women aged 15-49*/
    replace w_mammogram=. if wage<40|wage>49
}


capture confirm variable qs415 qs416u 
if _rc==0 {
    ren qs23 wage
    replace w_mammogram=(qs415==1&qs416u==1)
    replace w_mammogram=. if qs415==.|qs415==8|qs415==9|qs416u==9
    tab wage if w_mammogram!=. /*DHS sample is women aged 15-49*/
    replace w_mammogram=. if wage<50|wage>69
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





