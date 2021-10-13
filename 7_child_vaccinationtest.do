
******************************
*** Child vaccination ********
******************************   

*c_measles	child			Child received measles1/MMR1 vaccination
        gen c_measles  =. 
		replace c_measles = 1 if (h9 ==1 | h9 ==2 | h9 ==3)  
     	replace c_measles = 0 if (h9 ==0 | h9 ==8 | h9 ==9)   	

if inlist(name,"Azerbaijan2006"){
		replace c_measles = 1 if (h9 ==1 | h9 ==2 | h9 ==3 | inrange(s506mr,1,3))  
     	replace c_measles = 0 if h9 ==0 & s506mr == 0  
		}
	
*c_dpt1	child	Child received DPT1/Pentavalent 1 vaccination	
        gen c_dpt1  = . 
		replace c_dpt1  = 1 if (h3 ==1 | h3 ==2 | h3 ==3)  
		replace c_dpt1  = 0 if (h3 ==0 | h3 ==8 | h3 ==9)   
		
*c_dpt2	child			Child received DPT2/Pentavalent2 vaccination				
		gen c_dpt2  = . 
		replace c_dpt2  = 1 if (h5 ==1 | h5 ==2 | h5 ==3)  
		replace c_dpt2  = 0 if (h5 ==0 | h5 ==8 | h5 ==9)  
		
*c_dpt3	child			Child received DPT3/Pentavalent3 vaccination				
		gen c_dpt3  = . 
		replace c_dpt3  = 1 if (h7 ==1 | h7 ==2 | h7 ==3)  
		replace c_dpt3  = 0 if (h7 ==0 | h7 ==8 | h7 ==9)  
	
*c_bcg	child			Child received BCG vaccination
		gen c_bcg  = . 
		replace c_bcg  = 1 if (h2 ==1 | h2 ==2 | h2 ==3)  
		replace c_bcg  = 0 if (h2 ==0 | h2 ==8 | h2 ==9)  		

 		gen cpolio0  = .  //No Polio at birth information in Recode II. 
	/*	replace cpolio0  = 1 if (h0 ==1 | h0 ==2 | h0 ==3)  
		replace cpolio0  = 0 if h0 ==0   */
		
*c_polio1	child			Child received polio1/OPV1 vaccination
		gen c_polio1  = .  
		replace c_polio1  = 1 if (h4 ==1 | h4 ==2 | h4 ==3)  
		replace c_polio1  = 0 if (h4 ==0 | h4 ==8 | h4 ==9)  
		
*c_polio2	child			Child received polio2/OPV2 vaccination				
		gen c_polio2  = .  
		replace c_polio2  = 1 if (h6 ==1 | h6 ==2 | h6 ==3)  
		replace c_polio2  = 0 if (h6 ==0 | h6 ==8 | h6 ==9)  
		
*c_polio3	child			Child received polio3/OPV3 vaccination				
		gen c_polio3  = .  
		replace c_polio3  = 1 if (h8 ==1 | h8 ==2 | h8 ==3)  
		replace c_polio3  = 0 if (h8 ==0 | h8 ==8 | h8 ==9)  
		
	if inlist(name,"BurkinaFaso1993"){
		drop c_bcg c_measles c_polio1 c_polio2 c_polio3 c_dpt1 c_dpt2 c_dpt3
		
		gen c_bcg  = . 
		replace c_bcg  = 1 if inrange(h2,1,3)|inrange(s4b,1,3)  
		replace c_bcg  = 0 if h2 ==0  & s4b == 0  	
		
		gen c_measles  =. 
		replace c_measles = 1 if inrange(h9,1,3) | inrange(s4m,1,3)  
		replace c_measles = 0 if h9 ==0 & s4m==0

		gen c_polio1  = .  
		replace c_polio1  = 1 if inrange(h4,1,3) | inrange(s4p1,1,3)  
		replace c_polio1  = 0 if h4 ==0 & s4p1==0
		gen c_polio2  = .  
		replace c_polio2  = 1 if inrange(h6,1,3) | inrange(s4p2,1,3)  
		replace c_polio2  = 0 if h6 ==0  & s4p2==0
		gen c_polio3  = .  
		replace c_polio3  = 1 if inrange(h8,1,3) | inrange(s4p3,1,3)  
		replace c_polio3  = 0 if h8 ==0  & s4p3==0

		gen c_dpt1 =.
		replace c_dpt1  = 1 if inrange(h3,1,3)|inrange(s4d1,1,3)
		replace c_dpt1  = 0 if h3 == 0 & s4d1 == 0  
		gen c_dpt2 =.
		replace c_dpt2  = 1 if inrange(h5,1,3)|inrange(s4d2,1,3)
		replace c_dpt2  = 0 if h5 == 0 & s4d2 == 0  
		gen c_dpt3 =.
		replace c_dpt3  = 1 if inrange(h7,1,3)|inrange(s4d3,1,3)
		replace c_dpt3  = 0 if h7 == 0 & s4d3 == 0  
	}
		
*c_fullimm	child			Child fully vaccinated						
		gen c_fullimm =.  										/*Note: polio0 is not part of allvacc- see DHS final report*/
		replace c_fullimm =1 if (c_measles==1 & c_dpt1 ==1 & c_dpt2 ==1 & c_dpt3 ==1 & c_bcg ==1 & c_polio1 ==1 & c_polio2 ==1 & c_polio3 ==1)  
		replace c_fullimm =0 if (c_measles==0 | c_dpt1 ==0 | c_dpt2 ==0 | c_dpt3 ==0 | c_bcg ==0 | c_polio1 ==0 | c_polio2 ==0 | c_polio3 ==0)  
		replace c_fullimm =. if b5 ==0  
						
