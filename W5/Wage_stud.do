clear all /* Deleting all data in memory */
set more off
capture log close  /* closes the log file if it is open */
use wagepan, clear  /*opening the data file */
set matsize 800 /*Increasing the maximum allowed dimension of our data matrix */

*Running pooled OLS and testing then for heteroscedasticity:

reg lwage educ exper union married black hisp
estat hettest

*******************************
* Data Preparation:
*******************************
xtset nr year






*******************************
* Fixed-effects regressions:
*******************************




************
*** Estimating Least Squares Dummy Variable (LSDV) estimator:***
************



*Creating instead a loop to create a dummy the panel observations:
forvalues z=1/545 {
	cap gen dum_`z'=nr==`z'
}

reg lwage educ exper union married black hisp dum_*


*Dropping all fixed-effects dummies to reduce data complexity again:
drop dum_*


* Alternative way and in our case more efficient way to create fixed effects dummies:
xi: reg lwage educ exper union married black hisp i.nr
testparm *Inr*

* Adding these dummies to the OLS regression to estimate the LSDV:



*Dropping all fixed-effects dummies to reduce data complexity again:
drop *Inr*


* Estimating the LSDV with the xi-command instead:



* Testing for the presence of fixed effects:



*-> We cannot reject the presence of fixed effects. THus, we prefer fixed-effects estimators over pooled OLS.
 


************
*** Estimating the Within estimator:***
************



*For the other variables construct a loop to save time:
sort nr

foreach z in lwage educ exper black married union hisp {

	by nr: egen mean`z'=mean(`z')
	cap gen `z'_adj=`z' - mean`z'
	
}

* Running OLS on the adjusted variables: 

reg lwage_adj educ_adj exper_adj union_adj married_adj black_adj hisp_adj
est store A
* Of course, all these steps are already programmed by Stata, we should get the same results, when we type:

xtreg lwage educ exper union married black hisp, fe
est store B

esttab A B
* We get in both regressions the same results:




************
*** Estimating the First-difference estimator:***
************
xtset nr year
reg D.lwage D.educ D.exper D.union D.married D.black D.hisp

log close  /* closes the log file */
