clear all /* Deleting all data in memory */
set more off
capture log close  /* closes the log file if it is open */

log using Wage.log, replace text 
use wagepan, clear  /*opening the data file */
set matsize 800 /*Increasing the maximum allowed dimension of our data matrix */

*******************************
* Data Preparation:
*******************************

xtset nr year

* Running a fixed effects model:
xtreg lwage educ exper union married black hisp, fe
est store fix

* Running a random effects model:
xtreg lwage educ exper union married black hisp, re
est store ran

* Performing a Breusch-Pagan LM test for the existence of random effects:
xttest0 


* Hausman test for fixed vs random effects:
hausman fix ran



* Compare random and fixed effects:
est tab fix ran, star


* You end-up with interpreting the FE estimation results:


log close  /* closes the log file */
