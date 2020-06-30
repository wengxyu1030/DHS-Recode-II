/************************************************************************************************************************************************
*** THIS FILE USES THE DHS ADEPT-READY DATASETS TO RENAME THE VARIABLES
*************************************************************************************************************************************************/
global data "Adeptmegafile"
*Adept
foreach name in $DHScountries  {
foreach d in $data {

use "${OUT}/ADePT READY/DHS/`d'/DHS-`name'`d'.dta", clear	



cap ren childdata c_data
cap ren womandata w_data
cap ren childid c_id
cap ren womanid w_id
cap ren hhid hh_id
cap ren sampweight sampleweight
cap ren dateinterview doi
cap ren agey hm_age_yrs

cap ren cage c_age_mths
cap ren cagem c_age_mths
cap ren calive c_alive
cap ren callvacc c_fullimm
cap ren cantcare c_anc
cap ren cantcare_skilled c_anc_skilled
cap ren cantcare_measure c_anc_5y_effective
cap ren cARI c_ARI
cap ren cbcg c_bcg_vacc
cap ren cbirthatt_doctor c_birth_doctor
cap ren cbirthatt_nurse c_birth_nurse
cap ren cbirthatt_skilled c_sba
cap ren cbord c_birthorder
cap ren cbreast c_bf_duration
cap ren cbreastnow c_bf_current
cap ren cbw c_birthweight 
cap ren cbwrecall c_recall
cap ren ccough c_cough
cap ren cdiarrhea c_diarrhea
cap ren cdob c_dob
cap ren cdpt1 c_dtp1_vacc
cap ren cdpt2 c_dtp2_vacc
cap ren cdpt3 c_dtp3_vacc
cap ren cfever c_fever
cap ren cheight c_height
cap ren chfa c_haz
cap ren chomesol c_homesolution
cap ren cintb c_birthinterval
cap ren cITN c_ITN
cap ren cmale c_male
cap ren male hm_male
cap ren cmeasles c_measles_vacc
cap ren cmeasure c_measure
cap ren cnumvisit c_numvisit
cap ren cORS c_ORS
cap ren cplacedeliv c_placebirth
cap ren cpolio0 c_polio0_vacc
cap ren cpolio1 c_polio1_vacc
cap ren cpolio2 c_polio2_vacc
cap ren cpolio3 c_polio3_vacc
cap ren criskintb c_riskyinterval
cap ren cstunted c_stunted
cap ren cstunted3 c_stunted_severe
cap ren ctetanus c_tetanus_vacc_m
cap ren ctreatmentdiarrhea c_treatdiarrhea
cap ren ctreatmentARI c_treatARI
cap ren cu1yrd c_u1mr
cap ren cu5yrd c_u5mr
cap ren cunderweight c_underweight
cap ren cunderweight3 c_underweight_severe
cap ren cvitA c_vitA
cap ren cwage c_age_mother_mths
cap ren cwasted c_wasted
cap ren cwasted3 c_wasted_severe
cap ren cweight c_weight
cap ren cwfa c_waz
cap ren cwfh c_whz
cap ren cwvitA c_vitA_mother

cap ren hhPSU hh_PSU
cap ren hhregion hh_region
cap ren hhsanitation hh_sanitation_cat
cap ren hhsize hh_size
cap ren hhurban hh_urban
cap ren hhwater hh_water_cat
cap ren hhwealthscore hh_wealthscore

cap ren wBMI w_BMI
cap ren wconc_partnerships w_concurrent
cap ren wcondom w_condom1
cap ren wcondom2 w_condom2
cap ren wCPR w_CPR
cap ren wdob w_dob
cap ren wdoblastchild w_dob_lastchild
cap ren weduc w_educ_cat
cap ren weducY w_educ
cap ren wethnicity w_ethnicity
cap ren wheight w_height_1849
cap ren wITN w_ITN
cap ren wITN_pregnant w_ITN_pregnant
cap ren wknowscontraception w_knowscontraception
cap ren wmarital w_maritalstatus
cap ren wmarried w_married
cap ren wnormal_weight w_normalweight_1849
cap ren wobesity w_obese_1849 
cap ren wocc w_occupation_cat
cap ren woverweight w_overweight_1849
cap ren wpeduc w_educ_partner_cat
cap ren wpocc w_occupation_partner_cat
cap ren wpregnant w_pregnant
cap ren wreligion w_religion
cap ren wsmoke w_smoke
cap ren wtotalchild w_totalchildren
cap ren wunderweight w_underweight_1849
cap ren wusedcontraception w_usedcontraception
cap ren wweight w_weight_1849

cap ren wCPR_all w_CPR_all 
cap ren wCPR_all_married w_CPR_all_married
cap ren wCPR_all_married_notpreg w_CPR_all_married_notpreg

cap label var hh_q1 "hh_quintile_cat==poorest"
cap label var hh_q2 "hh_quintile_cat==poorer"
cap label var hh_q3 "hh_quintile_cat==middle"
cap label var hh_q4 "hh_quintile_cat==richer"
cap label var hh_q5 "hh_quintile_cat==richest"

save "${OUT}/ADePT READY/DHS/`d'/DHS-`name'`d'.dta", replace   
	}
}
