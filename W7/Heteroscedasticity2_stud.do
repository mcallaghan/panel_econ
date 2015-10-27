clear all /* Deleting all data in memory */
cap log close
set more off

log using fx_regime.log, replace text 

use ..\Spreads.dta, clear

*******************************
* Data Preparation:
*******************************

*Converting the country variable to numerical format and the time variable to date format
encode country, generate(country2) /*Converting the country variable to a numerical type and storing it under new variable name country2. */
gen time2=quarterly(time,"YQ") /* Converting my variable "time" to a date type. See `help dates and time' for more details */
format time2 %tq 

* Generating squared debt and deficit variables:
gen sqdebt = debt^2
gen sqdeficit = deficit^2

* Generating a dummy variable for the crisis period:
gen crisis=time2>=tq(2008q3)


* Defining the panel- and time-dimension:
xtset country2 time2 


********************
* Performing a Hausman test:
********************

xtreg spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx, fe
est store fixed

xttest3

*large t small n
xttest2

*large n small t
xtcsd, pesaran
xtcsd, frees
xtcsd, friedman

xtreg spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx, re
est store random

hausman fixed random


********************
* Testing for panel heteroscedasticity:
********************




********************
* Testing for cross sectional:
********************

* Since T is larger than N, we prefer the xttest2 command to test for cross-sectional dependence:

* Nevertheless, try also the xtcsd test:


********************
* Testing for serial correlation:
********************

* Programming the Wooldrige test manually:

reg D.spread D.debt D.sqdebt D.deficit D.sqdeficit D.us_bbbspread D.bidask D.gdpgrowth D.vstoxx, noconstant cluster(country)
cap predict res, residuals
cap predict fitted, xb

twoway scatter res fitted

reg res L.res, robust noconstant
test L.res=-0.5

reg res L.res, cluster(country) noconstant
test L.res=-0.5

* Using the Stata program xtserial:
xtserial spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx, output


********************
* Estimations:
********************

* Estimate the FE regression without corrected s.e., with robust s.e. and with pcse:
xi: xtpcse spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx i.country, corr(ar1)

xtpcse spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx, corr(ar1)

* Estimate the FE regression with GLS:
xi: xtgls spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx i.country, panels(correlated) corr(ar1) 
xtgls spread debt sqdebt deficit sqdeficit us_bbbspread bidask gdpgrowth vstoxx, panels(correlated) corr(ar1) 


log close
