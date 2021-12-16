
log using analysis_P&P_gendersocialization_final.log,replace

set maxvar 25000
set more off
cd "/Users/sam/Documents/Stata"
use master_dataset

macro define controls "age_mombirth Att_Index_1979 ROSENBERG_SCORE_1980_1979 expo15_hgc ch_white ch_black expo15_dregion1 expo15_dregion2 expo15_dregion3 i.religion_1979 age_1979 city_1979 mother_home_1979 father_home_1979 mother_work_1979 mother_educ_1979"
macro define ch_Family_attit_meancontrols "meanagech_Family_attit_ meanyearch_Family_attit_ "
macro define expo15  "expo15_lnfaminc expo15_sd_faminc expo15_marriedworking expo15_marriedbread expo15_notm"
macro define expo5   "expo5_marriedworking expo5_marriedbread expo5_notm"
macro define expo515 "expo15_lnfaminc expo15_sd_faminc expo515_marriedworking expo515_marriedbread expo515_notm"


********************
*summary statistics
********************



table ch_female  [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean mean meanagech_Family_attit_ mean meanyearch_Family_attit_)
table ch_female  if  Att_Index_1979<=16 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean mean meanagech_Family_attit_ mean meanyearch_Family_attit_)  
table ch_female  if  Att_Index_1979>=17 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean mean meanagech_Family_attit_ mean meanyearch_Family_attit_)  

sum $expo15 age_mombirth Att_Index_1979 ROSENBERG_SCORE_1980_1979 expo15_hgc ch_white ch_black expo15_dregion1 expo15_dregion2 expo15_dregion3 age_1979 city_1979 mother_home_1979 father_home_1979 mother_work_1979 mother_educ_1979 [aw=ch_SAMPWT_1979]
sum $expo15 age_mombirth Att_Index_1979 ROSENBERG_SCORE_1980_1979 expo15_hgc ch_white ch_black expo15_dregion1 expo15_dregion2 expo15_dregion3 age_1979 city_1979 mother_home_1979 father_home_1979 mother_work_1979 mother_educ_1979 if  Att_Index_1979<=16 [aw=ch_SAMPWT_1979]
sum $expo15 age_mombirth Att_Index_1979 ROSENBERG_SCORE_1980_1979 expo15_hgc ch_white ch_black expo15_dregion1 expo15_dregion2 expo15_dregion3 age_1979 city_1979 mother_home_1979 father_home_1979 mother_work_1979 mother_educ_1979 if  Att_Index_1979>=17 [aw=ch_SAMPWT_1979]

table ch_female if  expo515_marriedbread==1 & Att_Index_1979<=16 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean)
table ch_female if  expo515_marriedbread==1 & Att_Index_1979>=17 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean)

table ch_female if  expo515_marriedbread==0 & Att_Index_1979<=16 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean)
table ch_female if  expo515_marriedbread==0 & Att_Index_1979>=17 [aw=ch_SAMPWT_1979],c(mean ch_Family_attit_mean)

*TABLE 1
ssc install outreg2

foreach var in ch_Family_attit_ {
* gender-norm index of females with exposure from age 0 to 15
xi:reg `var'mean $expo15 $controls $`var'meancontrols if ch_female==1 [aw=ch_SAMPWT_1979]
est store r1`var'
* gender-norm index of males with exposure from age 0 to 15
xi:reg `var'mean $expo15 $controls $`var'meancontrols if  ch_female==0 [aw=ch_SAMPWT_1979]
est store r2`var'
* gender-norm index of females with exposure from age 0 to 5 and from age 6 to 15
xi:reg `var'mean $expo5  $expo515 $controls $`var'meancontrols if  ch_female==1 [aw=ch_SAMPWT_1979]
est store r3`var'
* gender-norm index of males with exposure from age 0 to 5 from age 6 to 15
xi:reg `var'mean $expo5  $expo515 $controls $`var'meancontrols if ch_female==0 [aw=ch_SAMPWT_1979]
est store r4`var'

outreg2 [r1`var' r2`var' r3`var' r4`var'] using "/Users/sam/Documents/Stata/`var'mean_T1_w.tex",dec(3) tex replace
outreg2 [r1`var' r2`var' r3`var' r4`var'] using "/Users/sam/Documents/Stata/`var'mean_T1_w.xls",dec(3) tex replace
}

estimates clear

*TABLE 2

foreach var in ch_Family_attit_ {

* gender-norm index of females with mothers' gender-norm index less than 16 and with exposure from age 6 to 15
xi:reg `var'mean $expo515 $controls $`var'meancontrols if  ch_female==1 & Att_Index_1979<=16 [aw=ch_SAMPWT_1979]
est store r1`var'
* gender-norm index of males with mothers' gender-norm index less than 16 and with exposure from age 6 to 15
xi:reg `var'mean $expo515 $controls $`var'meancontrols if  ch_female==0 & Att_Index_1979<=16 [aw=ch_SAMPWT_1979]
est store r2`var'
* gender-norm index of females with mothers' gender-norm index larger than 17 and with exposure from age 6 to 15
xi:reg `var'mean $expo515 $controls $`var'meancontrols if  ch_female==1 & Att_Index_1979>=17  [aw=ch_SAMPWT_1979]
est store r3`var'
* gender-norm index of males with mothers' gender-norm index larger than 17 and with exposure from age 6 to 15
xi:reg `var'mean $expo515 $controls $`var'meancontrols if  ch_female==0 & Att_Index_1979>=17 [aw=ch_SAMPWT_1979]
est store r4`var'

outreg2 [r1`var' r2`var' r3`var' r4`var'] using "/Users/sam/Documents/Stata/`var'mean_T2_w.tex",dec(3) tex replace
outreg2 [r1`var' r2`var' r3`var' r4`var'] using "/Users/sam/Documents/Stata/`var'mean_T2_w.xls",dec(3) tex replace

}


estimates clear


log close

