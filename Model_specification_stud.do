clear all /* Deleting all data in memory */
capture log close  /* closes the log file if it is open */
log using Spreads_Model_Specification.log, replace text 
use Spreads, clear  /*opening the data file */


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
cap gen ctime = country + time2


* Defining the panel- and time-dimension:
tsset country2 time2 

reg spread us_bbbspread debt deficit bidask sqdebt sqdeficit crisis


*******************************
* Detecting multicollinearity:
*******************************

* Display correlation matrix by explanatory variables: 

corr(debt deficit bidask us_bbbspread gdpgrowth vstoxx)


* Calculating the `variance inflation factor':




*******************************
* Detecting misspecification of the functional form:
*******************************
* Calculate the `residual-versus fitted plot':


* Calculate the `residual-versus predictor plot' for debt and deficit:
reg debt deficit bidask us_bbbspread gdpgrowth vstoxx

reg spread debt deficit us_bbbspread bidask gdpgrowth vstoxx
estat vif
rvfplot, yline(0) mlabel(country time2)
estat hettest
*rvfplot debt, yline(0) mlabel(country time2) 
*rvfplot deficit, yline(0) mlabel(country time2) 


* Repeating the regression with sqdebt and sqdeficit and calculate the `residual-versus fitted plot':
reg spread debt deficit us_bbbspread bidask gdpgrowth vstoxx sqdeficit sqdebt
estat vif
rvfplot, yline(0) mlabel(country time2)



*******************************
* Heteroscedasticity:
*******************************

* Running a Breusch-Pagan test for heteroscedasticity:
estat hettest


* Running OLS with and without heteroscedastic-robust standard-errors:
reg spread debt deficit us_bbbspread bidask gdpgrowth vstoxx sqdeficit sqdebt
rvfplot, yline(0)
est store A
reg spread debt deficit us_bbbspread bidask gdpgrowth vstoxx sqdeficit sqdebt, robust
rvfplot, yline(0)
est store B

esttab A B




log close  /* closes the log file */
