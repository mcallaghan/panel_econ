clear all 
cd "H:\Teaching\Hertie School\Teaching\Panel Econometrics_SS2014\Exercises\Exercise 3\
use FiscalReaction.dta, clear
log using fiscalreaction.log, replace text 

encode country, gen(country2)
tsset country2 year

gen ldebt_e=L.debt_e
gen ldebt_0=L.debt_0


********************
* Estimating the fiscal reaction function with OLS:
********************



********************
* Testing for the validity of the instruments:
********************

*** Testing, whether my instrument is relevant:***

* Running the reduced-form regression:



********************
* Testing for the endogeneity of gap_e: 
********************

***
* Hausman Test:
***

xtivreg capb_e (gap_e=igapusa_e L2.gap_e) ldebt_e maastricht_e eyear, fe
est store FE_IV

xtreg capb_e gap_e ldebt_e maastricht_e eyear, fe
est store FE

hausman FE_IV FE


***
* Durbin-Wu Hausman Test:
***

* Estimating the reduced-form equation


* Obtaining the resdiduals of this regression, calling tem res_red:


* Adding these residuals to the regression equation:




log close
