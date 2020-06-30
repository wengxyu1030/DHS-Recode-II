
******************
*** hiv***********
******************

/* Note: Don't use the cap but use gen and optional replace 
(change later when encounter hiv data available ones)/optional on 
the existance of the hiv data */

    ren hivclust hv001
    ren hivnumb hv002
    ren hivline hvidx
    ren hiv03 a_hiv_cat

    *a_hiv	15-49 household member (female or male) tested positive for HIV1 or HIV2 (1/0)
    gen a_hiv=.
    replace a_hiv=1 if a_hiv_cat==1|a_hiv_cat==2|a_hiv_cat==3
    replace a_hiv=0 if a_hiv_cat==0
	
	
    *hiv_sampleweight Sample weight for hiv prevalence estimates
    gen a_hiv_sampleweight = hiv05/10e6
	
	

