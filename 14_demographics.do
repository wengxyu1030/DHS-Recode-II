
********************
***Demographics*****
********************

*hm_live Alive (1/0)
    gen hm_live = 1          
   
*hm_male Male (1/0)         
    recode hv104 (2 = 0),gen(hm_male)  
	
*hm_age_yrs	Age in years       
    clonevar hm_age_yrs = hv105
	replace hm_age_yrs = . if inlist(hv105,98)
	
*hm_age_mon	Age in months (children only)
    gen hm_age_mon = . 
	capture confirm variable hc1 
	if _rc == 0 {
	replace hm_age_mon = hc1 
	}

*hm_headrel	Relationship with HH head
	clonevar hm_headrel = hv101
	
*hm_stay Stayed in the HH the night before the survey (1/0)
    gen hm_stay = .  //vary by survey, afg is missing.
	
*hm_dob	date of birth (cmc)
    gen hm_dob = . 
	capture confirm variable hc32
	if _rc == 0 {
    clonevar hm_dob = hc32  
	}
	
*hm_doi	date of interview (cmc)
    clonevar hm_doi = hv008

*ln	Original line number of household member
    clonevar ln = hvidx
	

//if b16 is missing in the birth.dta, the demographics indicators should be generated using the birth.dta and ind.dta