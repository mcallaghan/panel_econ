clear all /* Deleting all data in memory */
set more off
capture log close  /* closes the log file if it is open */

cd "C:\Users\m.callaghan\Documents\Github\panel_econ\exam2\stata"

import excel CA_FX_DATA2.xlsx, firstrow



set matsize 800 /*Increasing the maximum allowed dimension of our data matrix */

*******************************
* Data Preparation:
*******************************

* Set up panel
cap encode country, gen(country2)
xtset country2 year

* Create new variables
cap gen abs_cagdp = abs(cagdp)
cap gen trade_openness = importsgdp + exportsgdp


log using exam_2_q3_1_a.log, replace text
*@*lstart
local x regime trade_openness gdpgrowth finance

reg abs_cagdp `x'
estat hettest
est store ols

xtreg abs_cagdp `x', fe

est store fe

xtreg abs_cagdp `x', re
est store re

hausman fe re
*@*lend
cap log close

log using exam_2_q3_1_a.log, replace text
*@*lstart
xtreg abs_cagdp `x', re
xttest3
*@*lend
cap log close

*esttab ols fe re, mtitle



