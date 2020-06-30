/* 	Stata program to create Revised unmet need variable as described in
	Analytical Study 25: Revising Unmet Need for Family Planing
	by Bradley, Croft, Fishel, and Westoff, 2012, published by ICF International
	measuredhs.com/pubs/pdf/AS25/AS25.pdf
** 	Program written by Sarah Bradley and edited by Trevor Croft, last updated 23 January 2011
	SBradley@icfi.com
**  Corrections 19 March 2013 for Cambodia 2010 - Trevor Croft.
**  Correction 25 May 2013 (updated 7 July 2013) for Tanzania 2010 - Trevor Croft.
** 	This program includes survey-specific code for the following surveys:
	Brazil 1996
	Cambodia 2010
	Colombia 2010
	Cote D'Ivoire 1994
	Gabon 2000
	Guatemala 1998-99
	Guatemala 1995
	Haiti 1994-95
	India 1992-93
	India 1998-99
	India 2005-06
	Jordan 2002
	Kazakhstan 1999
	Lesotho 2009
	Madagascar 1992
	Maldives 2009
	Mauritania 2000
	Morocco 2003-04
	Nepal 2006
	Niger 1992
	Tanzania 1996
	Tanzania 1999
	Tanzania 2010
	Turkey 1993
	Turkey 1998
	Turkey 2003
	Uganda 1995
	Yemen 1991 */
**  Correction 10 May 2017 to work with DHS7 datasets.  
**  Two changes: checks for v000 now look for "7", and tsinceb now calculated using v222 which is based on century day codes in DHS7

g unmet=.
**Set unmet need to NA for unmarried women if survey only included ever-married women or only collected necessary data for married women
* includes DHS II survey (v605 only asked to married women),
* Morocco 2003-04, Turkey 1998 (no sexual activity data for unmarried women),
* Cote D'Ivoire 1994, Haiti 1994-95 (v605 only asked to married women)
* India 2005-06 (v605 only asked to ever-married women), Nepal 2006 (v605 not asked to unmarried and "married, guana not performed" women)
replace unmet=98 if v502!=1 & (v020==1 | substr(v000,3,1)=="2" | ///
	v000=="MA4" | v000=="TR2" | (v000=="CI3" & v007==94) | ///
	v000=="HT3" | v000=="IA5" | v000=="NP5")

** CONTRACEPTIVE USERS - GROUP 1
* using to limit if wants no more, sterilized, or declared infecund
recode unmet .=4 if v313==3 & (v605>=5 & v605<=7)

* using to space - all other contraceptive users
recode unmet .=3 if v313==3

* women using traditional methods
recode unmet .=2 if v312!=0 & inlist(v313,1,2) 
recode unmet .=1 if v312!=0 & inlist(v313,1,2)  


**PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2
* Determine who should be in Group 2
* generate time since last birth
g tsinceb=v222
* generate time since last period in months from v215
g tsincep	=	int((v215-100)/30) 	if v215>=100 & v215<=190
replace tsincep =   int((v215-200)/4.3) if v215>=200 & v215<=290
replace tsincep =   (v215-300) 			if v215>=300 & v215<=390
replace tsincep =	(v215-400)*12 		if v215>=400 & v215<=490
* initialize pregnant or postpartum amenorrheic (PPA) women
g pregPPA=1 if v213==1 | m6_1==96
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period
* 	if last period is before last birth in last 5 years
replace pregPPA=1 if (m6_1==. | m6_1==99 | m6_1==97) & tsincep>tsinceb & tsinceb<60 & tsincep!=. & tsinceb!=.
* 	or if said "before last birth" to time since last period in the last 5 years
replace pregPPA=1 if (m6_1==. | m6_1==99 | m6_1==97) & v215==995 & tsinceb<60 & tsinceb!=.
* select only women who are pregnant or PPA for <24 months
g pregPPA24=1 if v213==1 | (pregPPA==1 & tsinceb<24)

* Classify based on wantedness of current pregnancy/last birth
* current pregnancy
g wantedlast = v225
* recode 'God's will' (survey-specific response) as not in need for Niger 1992
recode wantedlast (4 = 1) if v000=="NI2"
* last birth
replace wantedlast = m10_1 if (wantedlast==. | wantedlast==9) & v213!=1
* recode 'not sure' and 'don't know' (survey-specific responses) as unmet need for spacing for Cote D'Ivoire 1994 and Madagascar 1992
recode wantedlast (4 8 = 2)
* no unmet need if wanted current pregnancy/last birth then/at that time
recode unmet .=7  if pregPPA24==1 & wantedlast==1
* unmet need for spacing if wanted current pregnancy/last birth later
recode unmet .=1  if pregPPA24==1 & wantedlast==2
* unmet need for limiting if wanted current pregnancy/last birth not at all
recode unmet .=2  if pregPPA24==1 & wantedlast==3
* missing=missing
recode unmet .=99 if pregPPA24==1 & (wantedlast==. | wantedlast==9)

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE
* determine if sexually active in last 30 days
g sexact=1 if v528>=0 & v528<=30
* older surveys used code 95 for sex in the last 4 weeks (Tanzania 1996)
recode sexact .=1 if v528==95
* if unmarried and not sexually active in last 30 days, assume no need
recode unmet .=97 if v502!=1 & sexact!=1

**DETERMINE FECUNDITY - GROUP 3 (Boxes refer to Figure 2 flowchart in report)
**Box 1 - applicable only to currently married
* married 5+ years ago, no children in past 5 years, never used contraception, excluding pregnant and PPA <24 months
g infec=1 			if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & v302==0  & pregPPA24!=1
* in DHS VI, v302 replaced by v302a
cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & v302a==0 & pregPPA24!=1 & (substr(v000,3,1)=="6" | substr(v000,3,1)=="7")
* survey-specific code for Cambodia 2010
cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & s313==0  & pregPPA24!=1 & v000=="KH5" & (v007==2010 | v007==2011)
* survey-specific code for Tanzania 2010
cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & s309b==0 & pregPPA24!=1 & v000=="TZ5" & (v007==2009 | v007==2010)
**Box 2
* declared infecund on future desires for children
replace infec=1 if v605==7
**Box 3
* menopausal/hysterectomy on reason not using contraception - slightly different recoding in DHS III and IV+
* DHS IV+ surveys
cap replace infec=1 if 	v3a08d==1 & (substr(v000,3,1)=="4" | substr(v000,3,1)=="5" | substr(v000,3,1)=="6" | substr(v000,3,1)=="7")
* DHSIII surveys
cap replace infec=1 if  v375a==23 & (substr(v000,3,1)=="3" | substr(v000,3,1)=="T")
* special code for hysterectomy for Brazil 1996, Guatemala 1995 and 1998-9  (code 23 = menopausal only)
cap replace infec=1 if 	v375a==28 & (v000=="BR3" | v000=="GU3")
* reason not using did not exist in DHSII, use reason not intending to use in future
cap replace infec=1 if  v376==14 & substr(v000,3,1)=="2"
* below set of codes are all survey-specific replacements for reason not using contraception.
* survey-specific code for Cote D'Ivoire 1994
cap replace infec=1 if     v000== "CI3" & v007==94 & v376==23
* survey-specific code for Gabon 2000
cap replace infec=1 if     v000== "GA3" & s607d==1
* survey-specific code for Haiti 1994/95
cap replace infec=1 if     v000== "HT3" & v376==23
* survey-specific code for Jordan 2002
cap replace infec=1 if     v000== "JO4" & (v376==23 | v376==24)
* survey-specific code for Kazakhstan 1999
cap replace infec=1 if     v000== "KK3" & v007==99 & s607d==1
* survey-specific code for Maldives 2009
cap replace infec=1 if     v000== "MV5" & v376==23
* survey-specific code for Mauritania 2000
cap replace infec=1 if     v000== "MR3" & s607c==1
* survey-specific code for Tanzania 1999
cap replace infec=1 if     v000== "TZ3" & v007==99 & s607d==1
* survey-specific code for Turkey 2003
cap replace infec=1 if     v000== "TR4" & v375a==23
**Box 4
* Time since last period is >=6 months and not PPA
replace infec=1 if tsincep>=6 & tsincep!=. & pregPPA!=1
**Box 5
* menopausal/hysterectomy on time since last period
replace infec=1 if v215==994
* hysterectomy has different code for some surveys, but in 3 surveys it means "currently pregnant" - Yemen 1991, Turkey 1998, Uganda 1995)
replace infec=1 if v215==993 & v000!="TR3" & v000!="UG3" & v000!="YE2"
* never menstruated on time since last period, unless had a birth in the last 5 years
replace infec=1 if v215==996 & (tsinceb>59 | tsinceb==.)
**Box 6
*time since last birth>= 60 months and last period was before last birth
replace infec=1 if v215==995 & tsinceb>=60 & tsinceb!=.
* Never had a birth, but last period reported as before last birth - assume code should have been 994 or 996
replace infec=1 if v215==995 & tsinceb==.
* exclude pregnant and PP amenorrheic < 24 months
replace infec=. if pregPPA24==1
recode unmet .=9 if infec==1

**FECUND WOMEN - GROUP 4
* wants within 2 years
recode unmet .=7 if v605==1
* survey-specific code: treat 'up to god' as not in need for India (different codes for 1992-3 and 1998-9)
recode unmet .=7 if v605==9 & v000=="IA3"
recode unmet .=7 if v602==6 & v000=="IA2"
* wants in 2+ years, wants undecided timing, or unsure if wants
* survey-specific code for Lesotho 2009
recode v605  .=4 if v000=="LS5"
recode unmet .=1 if v605>=2 & v605<=4
* wants no more
recode unmet .=2 if v605==5
recode unmet .=99



  la def unmet2 ///
    1 "unmet need for spacing" ///
	2 "unmet need for limiting" ///
	3 "using for spacing" ///
	4 "using for limiting" ///
	7 "no unmet need" ///
	9 "infecund or menopausal" ///
	97 "not sexually active" ///
	98 "unmarried - EM sample or no data" ///
	99 "missing"
  la val unmet unmet2
recode unmet (1/2=1 "unmet need") (else=0 "no unmet need"), g(unmettot)

**Turkey 2003 -  section 6 only used if cluster even, household number even or cluster odd, household number odd
drop if v000=="TR4" & (mod(v001,2) != mod(v002,2))

/**TABULATE RESULTS
* generate sampling weight
g wgt=v005/1000000
* tabulate for currently married women
ta unmet if v502==1 [iw=wgt], m
ta unmettot if v502==1 [iw=wgt]
* all women
ta unmet [iw=wgt]
ta unmettot [iw=wgt]
* sexually active unmarried
ta unmet if v502!=1 & sexact==1 [iw=wgt]
ta unmettot if v502!=1 & sexact==1 [iw=wgt]
*/

**ADDED TO STANDARD CODE - 29 DEC 2015
** Unmet need for family planning (revised definition)
/* 	gen w_unmet_fp=1 if unmet==1|unmet==2
	replace w_unmet_fp=0 if unmet==3|unmet==4|unmet==7|unmet==9|unmet==97     */
/*	
	gen w_unmet_fp_active=1 if unmet==1|unmet==2
	replace w_unmet_fp_active=0 if unmet==3|unmet==4|unmet==7|unmet==9
