*This file is to tag the reference period and year for w_papsmear and w_mamogram
*utilizing the infomraiton from 15_Append_Aggregate.do
*this file is only to tagging the previous adeptile generated woman-cancer related indicators. no modification is needed.  

************************************
*identify the non-missing indicator*
************************************

mdesc w_papsmear //identify the case where there is no papsmear info 
gen miss_p = 1 if r(percent) == 1 

mdesc w_mamogram //identify the case where there is no mamogram info
gen miss_m = 1 if r(percent) == 1

**************************
*recall period by country*
**************************
*tag the micro-data accordingly for w_papsmear reference period
replace w_papsmear_ref  = "3yr" if miss_p ! = 1 

if inlist(name,"DominicanRepublic1996","DominicanRepublic1999","DominicanRepublic2002","DominicanRepublic2007","Nicaragua1998","Nicaragua2001") {
replace w_papsmear_ref  = "1yr" if country_year=="`y'"
}
if inlist(name,"DominicanRepublic2013","Honduras2011") {
replace w_papsmear_ref = "2yr" if country_year=="`y'"
}
if inlist(name,"Philippines1998","Philippines2003","Peru1996","Peru2000","Peru2004","Peru2009","Peru2010","Peru2011","Peru2012") {
replace w_papsmear_ref = "5yr" if country_year=="`y'"
}
if inlist(name,"CotedIvoire2011","Jordan2007","Jordan2012","Namibia2013","Kenya2014") {
replace w_papsmear_ref = "ever" if country_year=="`y'"
}

*tag the micro-data accordingly for w_mamogram reference period
replace w_mamogram_ref  = "2yr" if miss_m ! = 1 

if inlist(name,"DominicanRepublic1996","DominicanRepublic1999","DominicanRepublic2002","DominicanRepublic2007","Nicaragua1998","Nicaragua2001") {
replace w_mamogram_ref  = "1yr" if country_year=="`y'"
}
if inlist(name, "Colombia2005","Colombia201","Colombia2015") {
replace w_mamogram_ref = "5yr" if country_year=="`y'"
}
if inlist(name,"Honduras2005","Honduras2011") {
replace w_mamogram_ref = "ever" if country_year=="`y'"
}

**********************
*age group by country*
**********************
*tag the micro-data accordingly for w_papsmear
replace w_papsmear_age = "20-49"  if miss_p ! = 1 

if inlist(name,"Peru2013","Peru2014","Peru2015","Peru2016") {
replace w_papsmear_age = "20-59" if country_year=="`y'"
}

*tag the micro-data accordingly for w_mamogram_ref
replace w_mamogram_age = "40-49" if miss_m ! = 1 

if inlist(name,"Peru2013","Peru2014","Peru2015","Peru2016" ) {
replace w_mamogram_age = "50-69" if country_year=="`y'"
}



