/* This file is to identify the gap between the microdataset,
 DHS, and HEFPI. */

/* Note: More indicators are overlapped in non-Afganistan survey: 
for example the hiv data in DHS and adult indicators in HEFPI,
could be adjusted later */

tempfile dhs hefpi

////////////////////////////////////////////////////////////////
///// Crosscheck with the DHS STATcompiler Indicator Result/////
////////////////////////////////////////////////////////////////

****************************************************************
*****Redefine the sample size to consistent with STATcompiler***
****************************************************************

***for variables generated from 1_antenatal_care 2_delivery_care 3_postnatal_care
preserve
	foreach var of var c_anc	c_anc_any	c_anc_bp	c_anc_bp_q	c_anc_bs	c_anc_bs_q ///
	c_anc_ear	c_anc_ear_q	c_anc_eff	c_anc_eff_q	c_anc_eff2	c_anc_eff2_q ///
	c_anc_eff3	c_anc_eff3_q	c_anc_ir	c_anc_ir_q	c_anc_ski	c_anc_ski_q ///
	c_anc_tet	c_anc_tet_q	c_anc_ur	c_anc_ur_q		///
	c_facdel	c_hospdel c_skin2skin	c_pnc_any	c_pnc_eff	c_pnc_eff_q c_pnc_eff2	c_pnc_eff2_q {
    replace `var' = . if !(inrange(hm_age_mon,0,59)& bidx==1)
    }
	
***for delivery the reference population differs
	replace c_earlybreast = . if !(inrange(hm_age_mon,0,23)& bidx==1)

	foreach var of var c_sba c_sba_eff1	c_sba_eff1_q	c_sba_eff2 ///
	c_sba_eff2_q	c_sba_q	{
	replace `var' = . if !(inrange(hm_age_mon,0,59) & hm_live ==1)
	}

	foreach var of var c_caesarean c_facdel{
	replace `var' = . if !(inrange(hm_age_mon,0,59))
	}

	
***for variables generated from 7_child_vaccination
	foreach var of var c_bcg c_dpt1 c_dpt2 c_dpt3 c_fullimm c_measles ///
	c_polio1 c_polio2 c_polio3{
    replace `var' = . if !inrange(hm_age_mon,12,23)
    }

***for variables generated from 8_child_illness	
	foreach var of var c_ari2 c_diarrhea 	c_diarrhea_hmf	c_diarrhea_medfor	c_diarrhea_mof	c_diarrhea_pro	c_diarrheaact ///
	c_diarrheaact_q	c_fever	c_fevertreat	c_illness	c_illtreat	c_sevdiarrhea	c_sevdiarrheatreat ///
	c_sevdiarrheatreat_q	c_treatARI2	c_treatdiarrhea	c_diarrhea_med {
    replace `var' = . if !inrange(hm_age_mon,0,59)
    }
	
***for vriables generated from 9_child_anthropometrics
	foreach var of var c_underweight c_stunted	hc70 hc71 ant_sampleweight{
    replace `var' = . if !inrange(hm_age_mon,0,59)
    }

***keep the relevant variables

keep surveyid hvidx hv001 hv002 mor_ali ant_sampleweight w_sampleweight hh_sampleweight ///
c_anc c_anc_bp	c_anc_bs	c_anc_ir	c_anc_ski c_anc_tet	c_anc_ur c_anc_ear	c_caesarean	c_earlybreast	c_sba  ///
w_CPR	w_unmet_fp	w_need_fp w_metany_fp	w_metmod_fp	w_bmi_1549	w_obese_1549	w_overweight_1549 ///
c_bcg	c_dpt1	c_dpt2	c_dpt3	c_fullimm	c_measles	c_polio1	c_polio2	c_polio3		///
c_ari2 c_diarrhea 	c_diarrhea_hmf	c_diarrhea_mof c_diarrhea_pro	c_fever	c_treatdiarrhea c_treatARI2	c_underweight	c_stunted	c_ITN



*********************************
*****Calculate the indicators****
*********************************
*ssc install _gwtmean   //use this package to calculate the weighted mean. 

gen ispreferred = "1"   //there are dif. definition for same indicator in DHS data. 

*indicators calculate using ant_samplewieght (child sample weight = women sample weight)
foreach var of var c_anc c_anc_bp	c_anc_bs c_anc_ear c_anc_ir c_anc_ski c_anc_tet c_anc_ur c_caesarean c_earlybreast c_sba  ///
c_bcg	c_dpt1	c_dpt2	c_dpt3	c_fullimm	c_measles	c_polio1	c_polio2	c_polio3		///
c_ari2 c_diarrhea 	c_diarrhea_hmf	c_diarrhea_mof	c_fever c_diarrhea_pro c_treatARI2 c_treatdiarrhea  {
egen value_my`var' = wtmean(`var'), weight(w_sampleweight)
}  

*indicators calculate using ant_samplewieght (women sample weight)
foreach var of var w_CPR w_need_fp w_unmet_fp w_metany_fp w_metmod_fp w_bmi_1549 w_obese_1549 w_overweight_1549 {
egen value_my`var' = wtmean(`var'), weight(w_sampleweight)
}  

*indicators calculate using household sample weight
foreach var of var c_ITN {    
egen value_my`var' = wtmean(`var'), weight(hh_sampleweight)
}

*indicators using ant_sampleweight
foreach var of var c_underweight c_stunted{    
egen value_my`var' = wtmean(`var'), weight(ant_sampleweight)
}


keep surveyid ispreferred value*
keep if _n == 1
reshape long value_my,i(surveyid ispreferred)j(varname_my) string
replace value_my = value_my*100

merge 1:1 surveyid varname_my ispreferred using "${SOURCE}/external/DHS"
keep if _merge == 3  //for _merge == 1, missing data to generate the indicator.
drop _merge

destring(value_my value_dhs),replace
gen gap_dhs = (value_my-value_dhs)/value_dhs*100
replace gap_dhs = value_my-value_dhs if value_dhs>20
gen flag_dhs = ((gap_dhs > 10 | gap_dhs < -10 )& value_dhs<=20) | ((gap_dhs>2|gap_dhs< -2 )&value_dhs>20)
tab varname_my if flag_dhs == 1

keep surveyid varname_my value* flag_dhs
save `dhs',replace

restore

////////////////////////////////////
///// Crosscheck with the HEFPI/////
////////////////////////////////////


*********************************************************
*****Redefine the sample size to consistent with HEFPI***
*********************************************************
/* 
The bidx is nt used in the hefpi indicator caluclation  
*/


***for variables generated from 1_antenatal_care 2_delivery_care 3_postnatal_care
	foreach var of var c_anc_any	c_anc_bp	c_anc_bp_q	c_anc_bs	c_anc_bs_q ///
	c_anc_ear	c_anc_ear_q	c_anc_eff	c_anc_eff_q	c_anc_eff2	c_anc_eff2_q ///
	c_anc_eff3	c_anc_eff3_q	c_anc_ir	c_anc_ir_q	c_anc_ski	c_anc_ski_q ///
	c_anc_tet	c_anc_tet_q	c_anc_ur	c_anc_ur_q	c_caesarean	c_earlybreast ///
	c_facdel	c_hospdel	c_sba_eff1	c_sba_eff1_q	c_sba_eff2 ///
	c_sba_eff2_q	c_sba_q	c_skin2skin	c_pnc_any	c_pnc_eff	c_pnc_eff_q c_pnc_eff2	c_pnc_eff2_q {
    replace `var' = . if !(inrange(hm_age_mon,0,59))   //bidx is not considered
    }
	
	foreach var of var c_anc c_sba {
	replace `var' = . if !(inrange(hm_age_mon,0,23)& bidx ==1) //bidx is considered
	}
	
	***for women, reference population differs.
    if inlist(name,"Armenia2010"){
    replace w_papsmear=. if hm_age_yrs<20|hm_age_yrs>49
	replace w_mammogram=. if hm_age_yrs<40|hm_age_yrs>49
	}	
	
	
***for variables generated from 7_child_vaccination
	foreach var of var c_bcg c_dpt1 c_dpt2 c_dpt3 c_fullimm c_measles ///
	c_polio1 c_polio2 c_polio3{
    replace `var' = . if !inrange(hm_age_mon,15,23)
    }

***for variables generated from 8_child_illness	
	foreach var of var 	c_diarrhea 	c_diarrhea_hmf	c_diarrhea_medfor	c_diarrhea_mof	c_diarrhea_pro	c_diarrheaact ///
	c_diarrheaact_q	c_fever	c_fevertreat	c_illness	c_illtreat	c_sevdiarrhea	c_sevdiarrheatreat ///
	c_sevdiarrheatreat_q	c_treatARI2	c_treatdiarrhea	c_diarrhea_med {
    replace `var' = . if !inrange(hm_age_mon,0,59)
    }
	
***for vriables generated from 9_child_anthropometrics
	foreach var of var c_underweight c_stunted	hc70 hc71 ant_sampleweight{
    replace `var' = . if !inrange(hm_age_mon,0,59)
    }

***for hive indicators from 13_adult
	foreach var of var a_hiv*{
	replace `var'=. if hm_age_yrs<15 | (hm_age_yrs>49 & hm_age_yrs!=.)
    }
	
***for hive indicators from 12_hiv
	foreach var of var a_diab_treat	a_inpatient_1y a_bp_treat a_bp_sys a_bp_dial a_hi_bp140_or_on_med a_bp_meas{
    replace `var'=. if hm_age_yrs<18
    }

*********************************
*****Calculate the indicators****
*********************************
*indicators calculate using w_samplewieght (women sample weight)
foreach var of var w_CPR w_bmi_1549 w_condom_conc w_height_1549 w_mammogram w_obese_1549 ///
w_overweight_1549 w_papsmear w_unmet_fp c_anc	c_fullimm c_measles c_sba  c_treatARI2	///
c_treatdiarrhea	{
egen value_my`var' = wtmean(`var'), weight(w_sampleweight)
}   

*indicator caculate at adult level (using individual sample weight）
foreach var of var a_bp_dial a_bp_sys a_bp_treat a_diab_treat c_ITN {
egen value_my`var' = wtmean(`var'),weight(hh_sampleweight)
}

*indicator caculate for child_anthropometrics (using ant_sampleweight）
foreach var of var c_underweight c_stunted {
egen value_my`var' = wtmean(`var'),weight(ant_sampleweight)
}


keep surveyid value*
keep if _n == 1
reshape long value_my,i(surveyid)j(varname_my) string
replace value_my = value_my*100

merge 1:1 surveyid varname_my using "${SOURCE}/external/HEFPI_DHS"
keep if _merge== 3
drop _merge

destring(value_my value_hefpi),replace
gen gap_hefpi = (value_my-value_hefpi)/value_hefpi*100
replace gap_hefpi = value_my-value_hefpi if value_hefpi>20
gen flag_hefpi = ((gap_hefpi > 10 | gap_hefpi < -10 )& value_hefpi<=20) | ((gap_hefpi>2| gap_hefpi< -2 )&value_hefpi>20)
tab varname_my if flag_hefpi == 1



keep surveyid varname_my value* flag_hefpi
save `hefpi',replace
/////////////////////////////////
/////Crosscheck results all/////
///////////////////////////////
use `dhs',clear
merge 1:1 surveyid varname_my using `hefpi',nogen


