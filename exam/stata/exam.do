clear all /* Deleting all data in memory */
set more off
capture log close  /* closes the log file if it is open */

cd "C:\Users\m.callaghan\Documents\Github\panel_econ\exam\stata"

log using exam_1.log, replace text


use CA_FX_DATA_STUD, clear  /*opening the data file */
set matsize 800 /*Increasing the maximum allowed dimension of our data matrix */

*******************************
* Data Preparation:
*******************************



* Create new variables
cap gen abs_cagdp = abs(cagdp)
cap gen trade_openness = importsgdp + exportsgdp

hist abs_cagdp
hist trade_openness

*Drop non-industrial countries
drop if ind == 0

*run a pooled OLS regression
reg abs_cagdp regime exportsgdp trade_openness finance gdpgrowth
estat vif

reg abs_cagdp regime trade_openness finance gdpgrowth
outtex, file(pooled.tex) labels level detail ///
	legend key(stab) replace
estat hettest
rvfplot
graph export rvfplot_pooled.png, replace

*Fixed effects regression
cap encode country, gen(country2)
xtset country2 year

xtreg abs_cagdp regime trade_openness finance gdpgrowth, fe
*rvfplot (Doesn't work! too tired to workaround)
outtex, file(fe.tex) labels level detail ///
	legend key(stab) replace
	

