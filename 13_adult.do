********************
*** adult***********
********************

*a_inpatient	18y+ household member hospitalized, recall period as close to 12 months as possible  (1/0)
    gen a_inpatient_1y = . 
	
*a_inpatient_ref	18y+ household member hospitalized recall period (in month), as close to 12 months as possible
    gen a_inpatient_ref = . 
	
*a_bp_treat	18y + being treated for high blood pressure 
    gen a_bp_treat = . 
	
	if inlist(name, "Bangladesh2011") {
		recode sh249 sh250 (9=.)
		gen a_bp_diag=(sh249==1) if sh249!=. 
		
		replace a_bp_treat=0 if sh250!=.  
		replace a_bp_treat=1 if sh250==1 
	}
	
*a_bp_sys & a_bp_dial: 18y+ systolic & diastolic blood pressure (mmHg) in adult population 
	gen a_bp_sys = .
	gen a_bp_dial = .
		
	if inlist(name, "Bangladesh2011") {	
		drop a_bp_sys a_bp_dial
		recode sh246s sh255s sh264s sh246d sh255d sh264d  (994 995 996 998 999 =.) 
		egen a_bp_sys = rowmean(sh246s sh255s sh264s)
		egen a_bp_dial = rowmean(sh246d sh255d sh264d)
    }	

*a_hi_bp140_or_on_med	18y+ with high blood pressure or on treatment for high blood pressure	
	gen a_hi_bp140=.
    replace a_hi_bp140=1 if (a_bp_sys>=140 & a_bp_sys!=.) | (a_bp_dial>=90 & a_bp_dial!=.)
    replace a_hi_bp140=0 if a_bp_sys<140 & a_bp_dial<90 
	
	gen a_hi_bp140_or_on_med = .
	replace a_hi_bp140_or_on_med=1 if a_bp_treat==1 | a_hi_bp140==1
    replace a_hi_bp140_or_on_med=0 if a_bp_treat==0 & a_hi_bp140==0
	
		
*a_bp_meas				18y+ having their blood pressure measured by health professional in the last year  
    gen a_bp_meas = . 
	
*a_bp_meas_ref				18y+ having their blood pressure measured by health professional recall period, as close to last 1 year as possible. String variable. "ever" or "xx" as number of months
    gen a_bp_meas_ref = "" 

*a_diab_treat				18y+ being treated for raised blood glucose or diabetes 
    gen a_diab_treat = .

	if inlist(name, "Bangladesh2011") {	
		gen a_diab_diag=(sh258==1)
		replace a_diab_diag=. if sh257==.|sh257==8|sh257==9|sh258==9

		replace a_diab_treat=(sh259==1)
		replace a_diab_treat=. if  sh257==.|sh257==8|sh257==9|sh259==9
    }		

	* For Brazil1991, the v001/v002 lost 2-3 digits, fix this issue in main.do, 1.do,4.do,12.do & 13.do
	if inlist(name,"Brazil1991"){
		ren hv023 hm_shstruct
		order hhid hv000 hm_shstruct hv001 hv002 hvidx
		isid hm_shstruct hv001 hv002 hvidx
	}		
	if inlist(name,"Cameroon1991"){
		drop hv002
		ren (shstruct shmenage) (hm_shstruct hv002)
		isid hm_shstruct hv001 hv002 hvid
		order hhid hv000 hv001 hm_shstruct hv002
	}	
	if inlist(name,"Colombia1990"){
		drop hv002
		gen hv002 = substr(hhid,10,3)
		order hhid hv000 hv001 hv002 
		isid hv001 hv002 hvid  
		destring hv002,replace 
	}	 
	if inlist(name,"DominicanRepublic1991"){
		ren shvivi hm_shstruct 
		order hhid hv000 hv001 hm_shstruct hv002 hvidx
		isid  hv001 hm_shstruct hv002 hvidx
	}	
	if inlist(name,"Niger1992"){
		ren shstruct hm_shstruct 
		order hhid hv000 hv001 hm_shstruct hv002 hvidx
		isid  hv001 hm_shstruct hv002 hvidx
	}

cap gen hm_shstruct =999
