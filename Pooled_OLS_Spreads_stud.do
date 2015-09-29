clear all /* Deleting all data in memory */
cd "C:\Users\m.callaghan\Downloads"  /* Change directory  */
capture log close  /* closes the log file if it is open */
log using pooledOLS_Spreads.log, replace text /*creating a log file, which stores all estimation results. The option `text' makes the log file readable in any editor*/
use Spreads, clear  /*opening the data file */

*******************************
* Data Preparation:
*******************************

* Browsing data
browse country time spread

* displaying the data type of my variables:
describe  

* Getting summary statistics
summarize 
summarize, detail

* Descriptive statistics for data subgroups:
tabulate country, sum(spread)

* Figures:
* Two-way scatterplot with debt to GDP on the x-axis and the interest rate spread on the y-axis:
twoway (scatter spread debt, mlabel(country)), ytitle(Interest Spread) xtitle(Gvmt Debt to GDP) title(Bond yield spreads in relation to debt/GDP)

* Bbar chart with the mean of bond yield spreads for each country:
graph bar (mean) spread, over(country) ytitle(Yield spread) title(Average Yield Spread by Country) subtitle(in Basis Points)



*******************************
* Converting the country variable to numerical format and the time variable to date format:
*******************************

* Converting the country variable to numerical format:
capture encode country, generate(country2)
describe country2

* Converting our time variable from string to date format:
gen time2=quarterly(time,"YQ")
list(time2)

format time2 %tq


*******************************
* Defining the panel- and time-dimension:
*******************************
xtset country2 time2


*******************************
* Generating new variables:
*******************************

* Generating squared debt and deficit variables:
cap gen debt_over_deficit = debt/deficit
replace debt_over_deficit = 100 in 5/10

cap gen sqdebt=debt^2
cap gen sqdeficit=deficit^2


* Generating a dummy variable for the crisis period - taking the `long road':

cap gen crisis=0
replace crisis = 1 if time2>=tq(2008q1)

* Generating a dummy variable for the crisis period - taking the `long road':
cap gen crisis2=time2>=tq(2008q1)


*******************************
* Running pooled OLS regressions:
*******************************


* Running a pooled OLS regression:
reg spread us_bbbspread debt deficit bidask
test debt
est store A
reg spread us_bbbspread debt deficit bidask sqdebt sqdeficit
est store B
reg spread us_bbbspread debt deficit bidask sqdebt sqdeficit crisis
test crisis
est store C

estout A B C
estimates table A B C, stat(N, r2_a) star


* Presenting regression results jointly in a table:




*******************************
* Making use of local macros:
*******************************

local BASIC_REG 



*******************************
* Hypothesis testing
*******************************



log close  /* closes the log file */


