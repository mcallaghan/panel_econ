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


* S3 Q1 (a) (i) - OLS and hettest
log using exam_2_q3_1_a_1.log, replace text
*@*lstart
local x regime trade_openness gdpgrowth finance
reg abs_cagdp `x'
estat hettest
est store ols
*@*lend
cap log close

* S3 Q1 (a) (ii) - FE and Ftest
log using exam_2_q3_1_a_2.log, replace text
*@*lstart
xtreg abs_cagdp `x', fe
est store fe
*@*lend
cap log close

* S3 Q1 (a) (iii) - RE and Hausman
log using exam_2_q3_1_a_3.log, replace text
*@*lstart
quietly xtreg abs_cagdp `x', re
est store re
hausman fe re
*@*lend
cap log close

* S3 Q1 (b) (i) - Panel Het
log using exam_2_q3_1_b_ph.log, replace text
*@*lstart
quietly xtreg abs_cagdp `x', fe
xttest3
*@*lend
cap log close

* S3 Q1 (b) (ii) - Cross Sectional Dependence
log using exam_2_q3_1_b_cd.log, replace text
*@*lstart
xtcsd, pesaran
xtcsd, frees
xtcsd, friedman
*@*lend
cap log close

* S3 Q1 (b) (iii) - Serial Correlation
log using exam_2_q3_1_b_sc.log, replace text
*@*lstart
xtserial abs_cagdp `x', output 
*@*lend
cap log close

* S3 Q1 (d) (i) - Panel Corrected Standard Errors
log using exam_2_q3_1_d.log, replace text
*@*lstart
xi: quietly xtpcse abs_cagdp `x' i.country2, corr(ar1)
est store pcse
esttab fe re pcse, drop(_*) mtitle
*@*lend
cap log close


* S3 Q2 (a) (i) - Interaction Term
log using exam_2_q3_2_a.log, replace text
*@*lstart
cap gen reg_x_id = regime*id
local x_inter regime trade_openness gdpgrowth finance id reg_x_id
xi: quietly xtpcse abs_cagdp `x_inter' i.country2, corr(ar1)
est store pcse_inter
esttab fe re pcse_inter, drop(_*) mtitle
*@*lend
cap log close

* S3 Q2 (b) (i) - Test countrytype
log using exam_2_q3_2_b.log, replace text
*@*lstart
test id 
*@*lend
cap log close

* S3 Q2 (c) (i) - Test regime
log using exam_2_q3_2_c.log, replace text
*@*lstart
test regime
*@*lend
cap log close

* S3 Q2 (d) (i) - Test interaction
log using exam_2_summary.log, replace text
*@*lstart
esttab ols fe re pcse pcse_inter, drop(_*) mtitle
*@*lend
cap log close

