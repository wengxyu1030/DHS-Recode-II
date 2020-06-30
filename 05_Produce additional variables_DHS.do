
********************************************************************************************************
******THIS DO-FILE CREATES ADDITIONAL VARIABLES BASED ON THE ADePT READY DATASETS***********************
********************************************************************************************************

global data "Adeptmegafile"
*Adept
foreach name in $DHScountries  {
foreach d in $data {

use "${OUT}/ADePT READY/DHS/`d'/DHS-`name'`d'.dta", clear

cap gen w_CPR_married=w_CPR if w_married==1
cap gen w_CPR_married_notpreg=w_CPR if w_married==1&w_pregnant==0

cap ren c_anc c_anc_skilled_5y

cap gen c_anc_5y=1 if c_numvisit>=4 & c_numvisit!=.
cap replace c_anc_5y=0 if c_numvisit<4

cap gen c_anc=c_anc_5y if c_age_mths<24
cap gen c_anc_skilled=c_anc_skilled_5y if c_age_mths<24
cap ren c_anc_5y_effective c_anc_skilled_5y_effective 
cap gen c_anc_skilled_5y_effective=.
cap gen c_anc_skilled_effective=c_anc_skilled_5y_effective if c_age_mths<24

cap ren c_sba c_sba_5y
cap gen c_sba=c_sba_5y if c_age_mths<24

* Ensure that unmet need for fp variable is consistently shown for only women married or living in union
replace w_unmet_fp = . if w_married!=1

*Availability of type of water source
cap ren hv201 hh_water_cat
cap replace hh_water_cat=. if hh_water_cat==96 | hh_water_cat==99

*Availability of improved water source (country-specific codes)
cap gen hh_water_improved=(hh_water_cat==11|hh_water_cat==12|hh_water_cat==13|hh_water_cat==21|hh_water_cat==31|hh_water_cat==41|hh_water_cat==51)
cap replace hh_water_improved=. if hh_water_cat==.|hh_water_cat==96|hh_water_cat==97|hh_water_cat==99

*Availability of type of sanitation facility
cap ren hv205 hh_sanitation_cat
cap replace hh_sanitation_cat=. if hh_sanitation_cat==96 | hh_sanitation_cat==99

*Availability of improved sanitation facilities (country-specific codes)
cap gen hh_sanitation_improved=(hh_sanitation_cat==11|hh_sanitation_cat==12|hh_sanitation_cat==13|hh_sanitation_cat==14|hh_sanitation_cat==15|hh_sanitation_cat==21|hh_sanitation_cat==22|hh_sanitation_cat==41)
cap replace hh_sanitation_improved=. if hh_sanitation_cat==.|hh_sanitation_cat==96|hh_sanitation_cat==97|hh_sanitation_cat==99

*Generate w_mammogram2 (adjust recall period later on in append do-files)
cap gen w_mammogram2=w_mammogram

/*DHS sample is women aged 15-49, replace to women aged 18-49*/
foreach var in w_condom2 {
/*foreach var of varlist w_BMI w_underweight w_normalweight w_overweight w_obese w_weight w_height {*/
cap confirm variable `var'
if !_rc {
replace `var'=. if hm_age_yrs<18
}
}

* Drop implausible women and child anthropometrics

foreach var of varlist w_underweight w_normalweight w_overweight w_obese w_weight w_height {
cap confirm variable `var'
if !_rc {
replace `var' = . if w_BMI<9 | w_BMI>70
}
}
cap replace w_BMI = . if w_BMI<9 | w_BMI>70


/*Adjust sample of adults for HIV prevalence to adults aged 15-49*/
cap replace a_hiv=. if hm_age_yrs<15 | (hm_age_yrs>49 & hm_age_yrs!=.)

*Generate variables that are missing with missing values
foreach var in $DHSvars {
cap gen `var'=. 
}

cap label var w_CPR_married "woman (married/in union) is currently using a modern method of contraception (1/0)"
cap label var w_CPR_married_notpreg "woman (married/in union/not pregnant) is currently using a modern method of contraception (1/0)"
cap label var c_anc_skilled_5y "mother received valid antenatal care (skilled & 4 visits)-children<5y (1/0)"
cap label var c_sba_5y "skilled birth attendance-children<5y (1/0)"
cap label var c_ancskilled_ "mother received valid antenatal care (skilled & 4 visits)-children<2y (1/0)"
cap label var c_sba "skilled birth attendance-children<2y (1/0)"
cap label var c_anc "mother received at least 4 antenatal care visits-children<2y (1/0)"
cap label var c_anc_5y "mother received at least 4 antenatal care visits-children<5y (1/0)"
cap label var c_anc_skilled_effective "mother received valid and effective ANC (skilled&4 visits&measured)<2y (1/0)"
cap label var c_anc_skilled_5y_effective "mother received valid and effective ANC (skilled&4 visits&measured)<5y (1/0)"
cap label var w_unmet_fp "women (15-49) married or in union with unmet need for family planning (1/0)"
cap label var w_papsmear "woman(18-49) had PAP smear test (1/0)"
cap label var w_papsmear2 "woman(30-49) had PAP smear test (1/0)"
cap label var w_mammogram "woman(40-49) received a mammogram (1/0)"
cap label var w_mammogram2 "woman(40-49) received a mammogram (1/0)"
cap label var a_inpatient_1yr "household member was hospitalized in last 12 months (1/0)"
cap label var hh_water_improved "availability of improved water source (1/0)"
cap label var hh_sanitation_improved "availability of improved sanitation facility (1/0)"
cap label var w_BMI "BMI of woman(not currently pregnant&not in last 3 months)"
cap label var w_underweight "woman with BMI below 18.5(not currently pregnant&not in last 3 months)(1/0)"
cap label var w_normalweight "woman with BMI between 18.5 and 25(not cur. pregnant&not in last 3 months)(1/0)"
cap label var w_overweight "woman with BMI above 25 (not currently pregnant&not in last 3 months)(1/0)"
cap label var w_obese "woman with BMI above 30 (not currently pregnant&not in last 3 months)(1/0)"
cap label var w_weight "woman's weight (in kilos)"
cap label var w_height "woman's height (in meters)"

cap order hh_id sampleweight /*
*/ a_inpatient_1yr c_age_mths c_age_mother_mths c_alive c_anc c_anc_5y c_anc_skilled c_anc_skilled_5y c_anc_skilled_effective c_anc_skilled_5y_effective c_ARI c_bcg_vacc c_birth_doctor /*
*/ c_birth_nurse c_birthorder c_birthweight c_bf_current c_bf_duration c_birthinterval c_cough c_data c_diarrhea c_dob c_dtp1_vacc c_dtp2_vacc /*
*/ c_dtp3_vacc c_fever c_fullimm c_haz c_height c_homesolution c_id c_ITN c_male c_measles_vacc c_measure c_numvisit c_ORS c_placebirth c_polio0_vacc /*
*/ c_polio1_vacc c_polio2_vacc c_polio3_vacc c_recall c_riskyinterval c_sba c_sba_5y c_stunted c_stunted_severe c_tetanus_vacc_m c_treatARI c_treatdiarrhea /*
*/ c_u1mr c_u5mr c_underweight c_underweight_severe c_vitA c_vitA_mother c_wasted c_wasted_severe c_waz c_weight c_whz doi hh_PSU hh_quintile_cat hh_q1 /*
*/ hh_q2 hh_q3 hh_q4 hh_q5 hh_region hh_sanitation_cat hh_sanitation_improved hh_size hh_urban hh_water_cat hh_water_improved hh_wealthscore hm_age_yrs w_BMI w_concurrent w_condom1 w_condom2 w_CPR* w_data w_dob /*
*/ w_dob_lastchild w_educ w_educ_cat w_educ_partner_cat w_ethnicity w_height w_id w_ITN w_ITN_pregnant w_knowscontraception w_mammogram* w_maritalstatus w_married /*
*/ w_normalweight w_obese w_occupation_cat w_occupation_partner_cat w_overweight w_papsmear* w_pregnant w_religion w_smoke w_totalchildren w_underweight w_unmet_fp /*
*/ w_usedcontraception w_weight hv001 hv002 hv003

save "${OUT}/ADePT READY/DHS/`d'/DHS-`name'`d'.dta", replace  
}
}
/*
use "${OUT}/ADePT READY/DHS/Adept/DHS-`name'Adept.dta", clear

keep hh_id sampleweight hv001 hv002 hv003 hh_PSU hh_q* hh_region hh_size hh_urban hh_wealthscore hm_age_yrs c_u1mr c_u5mr c_male c_age_mths c_age_mother_mths c_alive c_data w_data
	
save "${OUT}/ADePT READY/DHS/Adept/DHS-`name'Adept.dta", replace
*/
