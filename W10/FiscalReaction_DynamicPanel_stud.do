clear all 
set more off
use FiscalReaction.dta, clear
cap log close
log using fiscalreaction_Dynamic.log, replace text 

encode country, gen(country2)
xtset country2 year


****************************************************************
* Estimating a dynamic fiscal reaction function using ordinary linear panel models:
****************************************************************

*Running OLS:

local x gap_e L.debt_e maastricht_e eyear
local d_x D.gap_e D.L.debt_e D.maastricht_e D.eyear

reg capb_e L.capb_e `x'
eststo OLS

xtreg capb_e L.capb_e `x', fe
eststo FE

esttab OLS FE


****************************************************************
* Estimating a dynamic fiscal reaction function using the Anderson-Hsiao estimator:
****************************************************************

*Running an IV estimation, instrumenting D.L.capb_e with L2.capb_e and gap_e with igapusa_e:
ivreg2 D.capb_e (D.L.capb_e D.gap_e =L2.capb_e D.igapusa_e D.L.gap_e) ///
	D.L.debt_e D.maastricht_e D.eyear, robust noconstant



****************************************************************
* Estimating a dynamic fiscal reaction function using the Arellano-Bond estimator:
****************************************************************

*Running an Arellano Bond estimation:
xtabond capb_e L.debt_e maastricht_e eyear, ///
	endogenous(gap_e) inst(igapusa_e L.gap_e) ///
	twostep vce(robust) maxldep(2) maxlag(2)
	
estat abond	

xtabond capb_e L.debt_e maastricht_e eyear, ///
	endogenous(gap_e) inst(igapusa_e L.gap_e) ///
	twostep vce(robust) maxldep(2) maxlag(2)
estat sargan

* Restricting the number of instruments - only up to the fourth lag of the dependent variable is used as instrument:


* Testing for second-order autocorrelation in the first-differenced residuals:


* Testing for exogeneity of the instruments:


****************************************************************


log close
