log using analysis_P&P_gendersocialization_final.log,replace

set maxvar 25000
set more off
cd "/Users/user/Desktop"
use master_dataset

macro define controls "age_mombirth Att_Index_1979 ROSENBERG_SCORE_1980_1979 expo15_hgc ch_white ch_black expo15_dregion1 expo15_dregion2 expo15_dregion3 i.religion_1979 age_1979 city_1979 mother_home_1979 father_home_1979 mother_work_1979 mother_educ_1979"
macro define ch_Family_attit_meancontrols "meanagech_Family_attit_ meanyearch_Family_attit_ "
macro define expo15  "expo15_lnfaminc expo15_sd_faminc expo15_marriedworking expo15_marriedbread expo15_notm"
macro define expo5   "expo5_marriedworking expo5_marriedbread expo5_notm"
macro define expo515 "expo15_lnfaminc expo15_sd_faminc expo515_marriedworking expo515_marriedbread expo515_notm"

foreach var in ch_Family_attit_ {

xi:reg `var'mean $expo15 $controls $`var'meancontrols [aw=ch_SAMPWT_1979]
est store re1`var'
xi:reg `var'mean $expo15 Att_Index_1979 expo15_hgc_ if ch_female == 1 [aw=ch_SAMPWT_1979]
est store re2`var'
xi:reg `var'mean $expo15 Att_Index_1979 expo15_hgc_ c.expo15_notm#c.expo15_hgc_ if ch_female == 1 [aw=ch_SAMPWT_1979]
est store re3`var'
outreg2 [re1`var' re2`var' re3`var'] using "/Users/user/Desktop/`var'mean_R1_w.xls",dec(3) tex replace
}

*PLOT
marginsplot, noci x(expo15_hgc_) recast(line) xlabel(0(6)20)
marginsplot, noci x(expo15_hgc_) recast(line) xlabel(0(6)20)

estimates clear

log close
