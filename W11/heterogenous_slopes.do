clear
set more off

use ..\spreads.dta

encode country, generate(country2) /*Converting the country variable to a numerical type and storing it under new variable name country2. */

* Converting our time variable from string to date format:

gen time2=quarterly(time,"YQ") /* Converting my variable "time" to a date type. See `help dates and time' for more details */

format time2 %tq /* Converting my date variable to a comprehensible date format. */

*******************************
* Defining the panel- and time-dimension:
*******************************

xtset country2 time2


local countries Austria Belgium Finland France ///
	Greece Ireland Italy Netherlands Portugal Spain

foreach x in debt deficit bidask us_bbbspread {
	foreach z in `countries' {
		cap gen `x'_`z' = 0
		replace `x'_`z' = `x' if country=="`z'"
	}
}

foreach z in Austria Belgium Finland France ///
	Greece Ireland Italy Netherlands Portugal Spain {
 reg bidask debt deficit bidask us_bbbspread if country == "`z'"
 eststo `z'
}

esttab Austria Belgium Finland France ///
	Greece Ireland Italy Netherlands Portugal Spain, mtitle

	
xtreg bidask debt_* deficit_* bidask_* us_bbbspread_*, fe

sureg (spread *_Austria) (spread *_Belgium) (spread *_Finland) ///
	(spread *_France) (spread *_Greece) (spread *_Ireland) (spread *_Italy) ///
	(spread *_Netherlands) (spread *_Portugal) (spread *_Spain), corr

test debt_Austria = debt_Belgium = debt_Finland = debt_France = debt_Greece ///
	debt_Ireland = debt_Italy = debt_Netherlands = debt_Portugal = debt_Spain
