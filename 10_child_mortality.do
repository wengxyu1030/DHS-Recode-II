
******************************
*** Child mortality***********
******************************   

*mor_dob				Child date of birth (cmc)
    clonevar mor_dob = v011
	
*mor_wln				Woman line number in HH to match child with mother (original)
    clonevar mor_wln = v003
	
*mor_ali				Child still alive (1/0)
   	ge mnths_born_bef_int = v008 - b3 /* months born before interview  */ 
	clonevar mor_ali =  b5

*mor_ade				Child age at death in months
    clonevar mor_ade = b7
	replace mor_ade = . if b13~=0
	
	ge age_alive_mnths = mnths_born_bef_int 
	
	ge time = mor_ade
	replace time = age_alive_mnths if mor_ali==0
	replace time = 0 if time<0
	
*mor_afl				Child age at death imputation flag
    clonevar mor_afl = b13
	



