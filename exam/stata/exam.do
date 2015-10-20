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

sum cagdp
hist cagdp

cap gen abs_cagdp = abs(cagdp)
