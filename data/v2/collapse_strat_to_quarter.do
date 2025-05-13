/*
Author: Hyesung Oh, PhD
Date: 05/12/2025
Email: hyesung_oh@brown.edu

	This do file collapses the hospital/year/month-level Strategic Hospital
	M&A Database to the hospital/year/quarter level.
	
	Directions:
	1) Set up a data source folder and place "strategic_ma_db.dta" into this folder
	2) Set up a data output folder 
	3) Change the source and output globals to your directory
	4) Run do file
*/

global source = "..\source" //Change, if needed
global output = "..\source" //Change, if needed
global version = "v2" //Change, if needed
********************************************************************************

use $source\strategic_ma_db_$version.dta, clear
gsort medicare_ccn year_qtr -source_completed
collapse (mean) system_id = system_id_qtr (first) year hrrcode medicare_ccn_str source_completed notes (max) bankruptcy system_exit system_split merger_of_equals target, by(medicare_ccn year_qtr)
save $output\strat_ma_db_quarterly_$version.dta, replace
