
******************************
*** Child mortality***********
******************************   

*c_ITN	Child slept under insecticide-treated-bednet (ITN) last night.
    gen c_ITN = .
	
	capture confirm variable ml0
	if _rc == 0 {
	replace c_ITN=inlist(ml0,1,2,4) 								
	replace c_ITN=. if ml0==. | ml0==9                  //Children under 5 in country where malaria is endemic (only in countries with endemic)
	}

*c_mateduclvl_raw mother's highest educational level - raw
	clonevar c_mateduclvl_raw =  v106    
	
*c_mateduc Mother's highest educational level ever attended (1 = none, 2 = primary, 3 = lower sec or higher)
    recode v106 (0 = 1) (1 = 2) (2/3 = 3) (8/9 = .),gen(c_mateduc)
	  label define w_label 1 "none" 2 "primary" 3 "lower sec or higher"
      label values c_mateduc w_label

*c_maleduclvl_raw husband/partner highest educational levels - raw
	rename v701 c_maleduclvl_raw


