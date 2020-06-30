
******************************
*****Household Level Info*****
******************************   

*hh_id	ID (generated)      
    clonevar hh_id = hhid
	
*hh_headed	Head's highest educational attainment (1 = none, 2 = primary, 3 = lower sec or higher)
    recode hv106 (0 = 1) (1 = 2) (2/3 = 3) (8=.) if hv101 == 1,gen(hh_headed)
	
* hh_country_code Country code
	clonevar hh_country_code = hv000 							  
	
*hh_region_num	Region of residence numerical (hv024)
    clonevar hh_region_num = hv024
	
*hh_region_lab	Region of residence label (v024)
    decode hv024,gen(hh_region_lab)

*hh_size # of members   
    clonevar hh_size = hv009
           
*hh_urban Resides in urban area (1/0)
    recode hv025 (2=0),gen(hh_urban)
	
*hh_sampleweight Sample weight (v005/1000000)       
    gen hh_sampleweight = hv005/10e6 
 
*hh_wealth_quintile	Wealth quintile  
    gen hh_wealth_quintile = . 
    capture confirm variable hv270 
    if _rc == 0 {    
    replace hh_wealth_quintile = hv270                          
	}
	
*hh_wealthscore	Wealth index score   
    capture confirm variable hv271
	if _rc == 0 {
	clonevar hhwealthscore_old = hv271
	egen hhwealthscore_oldmin=min(hhwealthscore_old) 
	gen hh_wealthscore=hhwealthscore_old-hhwealthscore_oldmin
	replace hh_wealthscore=hh_wealthscore/10e6 
	}

*hv001 Sampling cluster number (original)
*hv002 Household number (original)
*hv003 Respondent's line number in household roster (original)

duplicates drop hv001 hv002,force
	