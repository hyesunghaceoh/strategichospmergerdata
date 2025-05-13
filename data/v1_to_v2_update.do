/*
Author: Hyesung (Hace) Oh
Date: 05/05/2025

The purpose of this .do file is to update the v1 Strategic Hospital M&A Database to v2.
*/

********************************************************************************

set more off
clear all
global sourcedir "P:\gsh2o\h2o\dissertation\Stata\source"
cd $sourcedir
********************************************************************************
********************************************************************************



capture program drop main
program define main

	gen_variables
	merge_aha_months
	manual_clean

end


	capture program drop gen_variables
	program define gen_variables
	
	
	*Variables to retain:
		* medicare_ccn
		* id
		* cah
		* general
		* month_merged_complete
		* year_merged_complete
		* year
		* year_qtr
		* sysid_fixed
		
		use ..\source\ch1_processed_panel.dta, clear
		capture drop cah
		capture drop general
			gen cah = (prvdr_ctgry_sbtyp_cd_num == 11)
			gen general = (prvdr_ctgry_sbtyp_cd_num == 1)
		keep fac_name hrrcode system_change_type medicare_ccn id cah general month_merged_complete year_merged_complete year year_qtr sysid_fixed consolidation_ind acquirer acquirer_target merger bankruptcy system_exit system_split source_complete
		drop if missing(month_merged_complete)
		sort id year_merged_complete month_merged_complete
		save ..\temp\year_month_data.dta, replace
			
	
	end
	
	
	capture program drop merge_aha_months
	program define merge_aha_months
	
		use ..\source\ch1_processed_panel.dta, clear
		keep if year != 2009
		keep id fac_name hrrcode year year_qtr mcrnum medicare_ccn sysid_fixed2 eff_sysid2 sysname
		sort id year year_qtr
		expand 3
		sort id year year_qtr
		by id year: gen month = _n
		gen month_merged_complete = month
		gen year_merged_complete = year
		sort id year month
		merge 1:1 id month_merged_complete year_merged_complete using "..\temp\year_month_data.dta"
		sort id year month
		rename acquirer_target target
		save ..\temp\pre_final_manual_clean.dta, replace
	
	end
	
	
	capture program drop manual_clean
	program define manual_clean
	
		use ..\temp\pre_final_manual_clean.dta, clear
		
		replace source_completed = "https://www.healthcarefinancenews.com/news/north-country-healthcare-affiliates-four-critical-access-hospitals-new-hampshire" in 4405
		
		forvalues n = 4405(1)4452 {
			replace sysid_fixed2 = 111111 in `n'
		}

		forvalues n = 4645(1)4692 {
			replace sysid_fixed2 = 111111 in `n'
		}
		
		forvalues n = 5749(1)5796 {
			replace sysid_fixed2 = 111111 in `n'
		}
		
		forvalues n = 6109(1)6156 {
			replace sysid_fixed2 = 111111 in `n'
		}
		
		capture drop notes
		gen notes = ""
		* Define the full note as a local macro
		local note `"The new arrangement maintains the four independently governed North Country hospitals as critical access hospitals providing care in their local communities. The four hospitals retain their names, their individual boards of trustees, and control of their assets and charitable endowments, the association said. Warren West, CEO of Littleton Healthcare, will be CEO of the new system."'

		* Apply the note to the listed observations
		replace notes = "`note'" in 4645
		replace notes = "`note'" in 5749
		replace notes = "`note'" in 6109
		replace notes = "`note'" in 4405
			
		replace sysid_fixed2 = 411 in 6256
		replace sysid_fixed2 = 412 in 6376
		replace sysid_fixed2 = 440 in 10153
		replace sysid_fixed2 = 440 in 10154
		replace sysid_fixed2 = 442 in 10312
		replace sysid_fixed2 = 2837 in 10393
		replace sysid_fixed2 = 2837 in 10394
		
		replace source_completed = "https://web.archive.org/web/20240423231850/https://www.heywood.org/news/final-approval-of-strategic-alliance-between-heywood-and-athol-memorial-hospitals" in 10465

		forvalues n = 10429(1)10464 {
			replace sysid_fixed2 = 221303 in `n'
		}
		
		replace sysid_fixed2 = 177 in 10678
		replace sysid_fixed2 = 177 in 10679
		replace sysid_fixed2 = 447 in 11713
		replace sysid_fixed2 = 447 in 11714
		replace sysid_fixed2 = 2837 in 12313
		replace sysid_fixed2 = 2837 in 12314
		replace sysid_fixed2 = 451 in 12433
		replace sysid_fixed2 = 451 in 12434
		
		forvalues n = 13261(1)13276 {
			replace sysid_fixed2 = 220174 in `n'
		}
		
		replace sysid_fixed2 = 459 in 14437
		replace sysid_fixed2 = 459 in 14438
		replace sysid_fixed2 = 460 in 14617
		replace sysid_fixed2 = 460 in 14618
		replace sysid_fixed2 = 461 in 14737
		replace sysid_fixed2 = 461 in 14738
		replace sysid_fixed2 = 158 in 15319
		replace sysid_fixed2 = 158 in 15320
		replace sysid_fixed2 = 464 in 15613
		replace sysid_fixed2 = 464 in 15614
		replace sysid_fixed2 = 465 in 15643
		replace sysid_fixed2 = 465 in 15644
		replace sysid_fixed2 = 71 in 15952
		replace sysid_fixed2 = 468 in 16171
		replace sysid_fixed2 = 468 in 16172
		replace sysid_fixed2 = 2837 in 16561
		replace sysid_fixed2 = 2837 in 16562
		replace sysid_fixed2 = 472 in 16855
		replace sysid_fixed2 = 472 in 16856
		replace sysid_fixed2 = 2875 in 17092
		replace sysid_fixed2 = 2875 in 17093
		replace source_completed     = "" in 17093
		replace system_change_type   = "" in 17093
		replace bankruptcy           = . in 17093
		replace system_exit          = . in 17093
		replace system_split         = . in 17093
		replace merger               = . in 17093
		replace target               = . in 17093
		replace consolidation_ind    = . in 17093
		replace sysid_fixed          = . in 17093
		replace acquirer             = . in 17093
		replace cah                  = . in 17093
		replace general              = . in 17093
		replace source_completed = "https://www.valleybreeze.com/news/chartercare-health-and-prospect-medical-launch-partnership/article_c8a279d3-049a-549e-9f61-7b227fea686f.html" in 17094
		replace system_change_type = "acquisition" in 17094
		replace bankruptcy        = 0 in 17094
		replace system_exit       = 0 in 17094
		replace system_split      = 0 in 17094
		replace merger            = 0 in 17094
		replace target            = 1 in 17094
		replace consolidation_ind = 1 in 17094
		replace sysid_fixed       = 20 in 17094
		replace acquirer          = 0 in 17094
		replace cah               = 0 in 17094
		replace general           = 1 in 17094
		replace source_completed     = "" in 17095
		replace system_change_type   = "" in 17095

		replace bankruptcy           = . in 17095
		replace system_exit          = . in 17095
		replace system_split         = . in 17095
		replace merger               = . in 17095
		replace target               = . in 17095
		replace consolidation_ind    = . in 17095
		replace sysid_fixed          = . in 17095
		replace acquirer             = . in 17095
		replace cah                  = . in 17095
		replace general              = . in 17095
		
		replace source_completed     = "" in 17573
		replace system_change_type   = "" in 17573
		replace bankruptcy           = . in 17573
		replace system_exit          = . in 17573
		replace system_split         = . in 17573
		replace merger               = . in 17573
		replace target               = . in 17573
		replace consolidation_ind    = . in 17573
		replace sysid_fixed          = . in 17573
		replace acquirer             = . in 17573
		replace cah                  = . in 17573
		replace general              = . in 17573
		
 		replace source_completed     = "https://www.valleybreeze.com/news/chartercare-health-and-prospect-medical-launch-partnership/article_c8a279d3-049a-549e-9f61-7b227fea686f.html" in 17573
		replace system_change_type   = "acquisition" in 17574
		replace bankruptcy           = 0 in 17574
		replace system_exit          = 0 in 17574
		replace system_split         = 0 in 17574
		replace merger               = 0 in 17574
		replace target               = 1 in 17574
		replace consolidation_ind    = 1 in 17574
		replace sysid_fixed          = 20 in 17574
		replace acquirer             = 0 in 17574
		replace cah                  = 0 in 17574
		replace general              = 1 in 17574
		
		replace source_completed     = "" in 17575
		replace system_change_type   = "" in 17575

		replace bankruptcy           = . in 17575
		replace system_exit          = . in 17575
		replace system_split         = . in 17575
		replace merger               = . in 17575
		replace target               = . in 17575
		replace consolidation_ind    = . in 17575
		replace sysid_fixed          = . in 17575
		replace acquirer             = . in 17575
		replace cah                  = . in 17575
		replace general              = . in 17575
	    replace sysid_fixed2 = 476 in 18160
		replace sysid_fixed2 = 476 in 18161
		replace sysid_fixed  = 92 in 18201
		replace sysid_fixed2 = 92 in 18201
		
		forvalues i = 18202/18240 {
			replace sysid_fixed2 = 92 in `i'
		}
		forvalues i = 19441/19449 {
			replace sysid_fixed2 = 70033 in `i'
		}	
		forvalues i = 20613/20652 {
			replace sysid_fixed2 = 92 in `i'
		}
		forvalues i = 20653/20661 {
			replace sysid_fixed2 = 70015 in `i'
		}
		
		replace sysid_fixed2 = 177 in 21202
		replace sysid_fixed2 = 611 in 21256
		
		forvalues i = 21257/21271 {
			replace sysid_fixed2 = 2923 in `i'
		}		
		
		replace source_completed = "" in 21370
		replace system_change_type = "" in 21370

		replace bankruptcy = . in 21370
		replace system_exit = . in 21370
		replace system_split = . in 21370
		replace merger = . in 21370
		replace target = . in 21370
		replace consolidation_ind = . in 21370
		replace sysid_fixed = . in 21370
		replace acquirer = . in 21370
		replace cah = . in 21370
		replace general = . in 21370
		replace sysid_fixed2 = 491 in 21514
		replace sysid_fixed2 = 491 in 21515
		replace sysid_fixed2 = 132 in 22525
		replace sysid_fixed2 = 71 in 22540
		
		replace source_completed = "https://news.sphp.com/news/merger-creates-st-peters-health-partners-regions-most-comprehensive-health-care-provider/" in 23818
		
		replace source_completed = "https://www.chausa.org/news-and-publications/publications/catholic-health-world/archives/may-15-2013/trinity-health-catholic-health-east-merge-into-one-of-nation's-largest-health-systems" in 23837

		replace source_completed = "None" in 23929	
		replace sysid_fixed2 = 71 in 24100
		replace target = 1 in 25953
		replace acquirer = 0 in 25953
		
		forvalues i = 25953(1)26016 {
			replace sysid_fixed2 = 562 in `i'
		}
	
		replace sysid_fixed2 = 524 in 26098
		replace sysid_fixed2 = 524 in 26099
		replace sysid_fixed2 = 75 in 26100 //This is not needed with a re-run, but here just in case
		replace sysid_fixed2 = 537 in 27856
		replace sysid_fixed2 = 537 in 27857
		replace sysid_fixed2 = 538 in 27994
		replace sysid_fixed2 = 538 in 27995
		*Back at 28549
		replace notes = "While this is a false signal, Bassett acquired an asset this quarter" in 28549
		replace sysid_fixed2 = 544 in 29098
		replace acquirer = 1 in 29671
		replace target = 0 in 29671
		
		forvalues i = 29773(1)29784 {
			replace sysid_fixed2 = 330108 in `i'
		}

		replace source_completed = "None" in 30289
		replace sysid_fixed2 = 553 in 31066
		replace sysid_fixed2 = 553 in 31067
		replace sysid_fixed2 = 71 in 31516
		replace notes = "First as administrative services agreement" in 31537
		replace sysid_fixed2 = 2848 in 31573
		replace sysid_fixed2 = 2848 in 31574
		
		* Start from 31774
		
		* Cayuga merges with Schuyler
		forvalues i = 31717(1)31773 {
			replace sysid_fixed2 = 330307 in `i'
		}

		replace source_completed = "None" in 31885
		replace sysid_fixed2 = 559 in 32158
		replace sysid_fixed2 = 559 in 32159
		replace notes = "This sytem made an acquisition during this month" in 32605
		replace sysid_fixed2 = 350 in 33337
		replace sysid_fixed2 = 350 in 33338
		replace sysid_fixed2 = 565 in 33502
		replace sysid_fixed2 = 565 in 33503

		forvalues i = 33778(1)33840 {
			replace sysid_fixed2 = 557 in `i'
		}
		
		replace sysid_fixed2 = 276 in 34006
		replace sysid_fixed2 = 276 in 34246
		replace sysid_fixed2 = 62 in 34519
		replace sysid_fixed2 = 62 in 34520
		replace sysid_fixed2 = 575 in 35959
		replace sysid_fixed2 = 575 in 35960
		replace sysid_fixed2 = 62 in 36199
		replace sysid_fixed2 = 62 in 36200
		replace sysid_fixed2 = 62 in 36319
		replace sysid_fixed2 = 62 in 36320
		
		replace notes = "merger announcement" in 37051

		replace source_completed     = "" in 37050
		replace system_change_type   = "" in 37050
		replace bankruptcy           = .  in 37050
		replace system_exit          = .  in 37050
		replace system_split         = .  in 37050
		replace merger               = .  in 37050
		replace target               = .  in 37050
		replace consolidation_ind    = .  in 37050
		replace sysid_fixed          = .  in 37050
		replace acquirer             = .  in 37050
		replace cah                  = .  in 37050
		replace general              = .  in 37050		
		
		replace sysid_fixed2 = 329 in 38644
		replace sysid_fixed2 = 591 in 40192
		replace sysid_fixed2 = 329 in 41008

		* Updates for observation 22522
		replace system_change_type   = "merger of equals" in 22522
		replace bankruptcy           = 0 in 22522
		replace system_exit          = 0 in 22522
		replace system_split         = 0 in 22522
		replace merger               = 1 in 22522
		replace target               = 0 in 22522
		replace consolidation_ind    = 1 in 22522
		replace sysid_fixed          = 71 in 22522
		replace acquirer             = 0 in 22522
		replace cah                  = 0 in 22522
		replace general              = 1 in 22522
		replace source_completed     = "https://news.sphp.com/news/merger-creates-st-peters-health-partners-regions-most-comprehensive-health-care-provider/" in 22522

		* Clear observation 22526
		replace general              = . in 22526
		replace cah                  = . in 22526
		replace acquirer             = . in 22526
		replace sysid_fixed          = . in 22526
		replace consolidation_ind    = . in 22526
		replace target               = . in 22526
		replace merger               = . in 22526
		replace system_split         = . in 22526
		replace system_exit          = . in 22526
		replace bankruptcy           = . in 22526
		replace system_change_type   = "" in 22526
		replace source_completed     = "" in 22526
		
		replace system_change_type = "merger of equals" in 23818
		replace merger = 1 in 23818
		replace target = 0 in 23818
		replace sysid_fixed2 = 71 in 41824
		replace sysid_fixed2 = 71 in 23836
		replace sysid_fixed2 = 603 in 42088
		replace sysid_fixed2 = 606 in 42754
		replace sysid_fixed2 = 220 in 44047
		replace sysid_fixed2 = 220 in 44048
		replace sysid_fixed2 = 614 in 44140
		replace sysid_fixed2 = 71 in 44740
		replace sysid_fixed2 = 618 in 45013
		replace sysid_fixed2 = 618 in 45014
		replace sysid_fixed2 = 622 in 45940
		replace sysid_fixed2 = 623 in 46027
		replace sysid_fixed2 = 623 in 46028
		replace sysid_fixed2 = 625 in 46333
		replace sysid_fixed2 = 626 in 46432
		replace sysid_fixed2 = 626 in 46433
		
		* Clear fields for observation 46447
		replace source_completed     = "" in 46447
		replace system_change_type   = "" in 46447
		replace bankruptcy           = . in 46447
		replace system_exit          = . in 46447
		replace system_split         = . in 46447
		replace merger               = . in 46447
		replace target               = . in 46447
		replace consolidation_ind    = . in 46447
		replace sysid_fixed          = . in 46447
		replace acquirer             = . in 46447
		replace cah                  = . in 46447
		replace general              = . in 46447

		* Populate merger info for observation 46456
		replace source_completed     = "https://www.prnewswire.com/news-releases/barnabas-health-robert-wood-johnson-health-system-complete-merger-combine-to-form-most-comprehensive-health-system-in-new-jersey--rwjbarnabas-health-300244265.html" in 46456
		replace system_change_type   = "merger of equals" in 46456
		replace bankruptcy           = 0 in 46456
		replace system_exit          = 0 in 46456
		replace system_split         = 0 in 46456
		replace merger               = 1 in 46456
		replace target               = 0 in 46456
		replace consolidation_ind    = 1 in 46456
		replace sysid_fixed          = 2921 in 46456
		replace acquirer             = 0 in 46456
		replace cah                  = 0 in 46456
		replace general              = 1 in 46456

		* Assign sysid_fixed2 = 54 to affected rows
		foreach obs in 46447 46448 46449 46450 46451 46452 46453 46454 46455 {
			replace sysid_fixed2 = 54 in `obs'
		}
		
		replace sysid_fixed2 = 71 in 46660
		replace sysid_fixed2 = 299 in 47185
		replace sysid_fixed2 = 299 in 47186
		replace sysid_fixed2 = 192 in 47536
		replace sysid_fixed2 = 192 in 47537
		replace sysid_fixed2 = 71 in 48148
		replace sysid_fixed2 = 2848 in 48184
		replace sysid_fixed2 = 629 in 48481
		replace sysid_fixed2 = 629 in 48482
		replace sysid_fixed2 = 630 in 48643
		replace sysid_fixed2 = 633 in 48973
		replace sysid_fixed2 = 192 in 49144
		replace sysid_fixed2 = 192 in 49145
		replace sysid_fixed2 = 203 in 49501
		replace sysid_fixed2 = 203 in 49502
		replace sysid_fixed2 = 192 in 49624
		replace sysid_fixed2 = 192 in 49625
		replace sysid_fixed2 = 203 in 50329
		replace sysid_fixed2 = 203 in 50330
		replace sysid_fixed2 = 641 in 50467
		replace sysid_fixed2 = 641 in 50468
		replace sysid_fixed2 = 54 in 50833
		replace sysid_fixed2 = 54 in 50834
		replace sysid_fixed2 = 203 in 51193
		replace sysid_fixed2 = 203 in 51194
		replace sysid_fixed2 = 299 in 51529
		replace sysid_fixed2 = 299 in 51530
		replace sysid_fixed2 = 643 in 51598
		replace sysid_fixed2 = 172 in 51748
		replace sysid_fixed2 = 646 in 52951
		replace sysid_fixed2 = 646 in 52952
		replace sysid_fixed2 = 647 in 53077
		replace sysid_fixed2 = 647 in 53078
		replace sysid_fixed2 = 257 in 53875
		replace sysid_fixed2 = 257 in 53876
		replace sysid_fixed2 = 122 in 56470
		replace sysid_fixed2 = 71 in 58420
		replace sysid_fixed2 = 2802 in 59068
		replace sysid_fixed2 = 679 in 59581
		replace sysid_fixed2 = 683 in 60739
		replace sysid_fixed2 = 683 in 60740
		replace sysid_fixed2 = 685 in 60925
		replace sysid_fixed2 = 685 in 60926
		replace sysid_fixed2 = 691 in 61795
		replace sysid_fixed2 = 71 in 61888
		
		*starting from after 61888
		replace sysid_fixed2 = 172      in 62128
		replace sysid_fixed2 = 224      in 62518
		replace sysid_fixed2 = 224      in 62519
		replace sysid_fixed2 = 693      in 62710
		replace sysid_fixed2 = 257      in 63919
		replace sysid_fixed2 = 257      in 63920
		replace sysid_fixed2 = 2802     in 64225
		replace sysid_fixed2 = 2802     in 64226
		replace sysid_fixed2 = 9999999  in 62860
		replace sysid_fixed2 = 9999999  in 62861
		replace sysid_fixed2 = 9999999  in 62862
		replace sysid_fixed2 = 9999999  in 62863
		replace sysid_fixed2 = 9999999  in 62864
		replace sysid_fixed2 = 9999999  in 62865
		replace sysid_fixed2 = 9999999  in 69328  // overriding earlier 99999999 assignment
		replace sysid_fixed2 = 9999999  in 69329
		replace sysid_fixed2 = 9999999  in 69330
		replace sysid_fixed2 = 9999999  in 69331
		replace sysid_fixed2 = 9999999  in 69332
		replace sysid_fixed2 = 9999999  in 69333
		
		*starting from after 69333
*******************************************************
		// Direct sysid_fixed2 replacements
		replace sysid_fixed2 = 122 in 70426
		replace sysid_fixed2 = 177 in 70462
		replace sysid_fixed2 = 723 in 70591
		replace sysid_fixed2 = 723 in 70592

		// Fix 1: Updates for observation 69345
		replace source_completed = "https://www.healthcarefinancenews.com/news/upmc-susquehanna-buying-two-pennsylvania-hospitals-quorum-health-corp" in 69345
		replace system_change_type = "acquisition" in 69345
		replace bankruptcy = 0 in 69345
		replace system_exit = 0 in 69345
		replace system_split = 0 in 69345
		replace merger = 0 in 69345
		replace target = 1 in 69345
		replace consolidation_ind = 1 in 69345
		replace sysid_fixed = 2911 in 69345
		replace acquirer = 0 in 69345
		replace cah = 0 in 69345
		replace general = 1 in 69345

		// Clear and recode obs 69334
		replace source_completed = "" in 69334
		replace system_change_type = "" in 69334
		replace bankruptcy = . in 69334
		replace system_exit = . in 69334
		replace system_split = . in 69334
		replace merger = . in 69334
		replace target = . in 69334
		replace consolidation_ind = . in 69334
		replace sysid_fixed = . in 69334
		replace acquirer = . in 69334
		replace cah = . in 69334
		replace general = . in 69334
		replace sysid_fixed2 = 9999999 in 69334

		// Batch replace sysid_fixed2 (69335–69344)
		foreach i in 69335 69336 69337 69338 69339 69340 69341 69342 69343 69344 {
			replace sysid_fixed2 = 9999999 in `i'
		}

		// Fix 2: Updates for observation 62877
		replace source_completed = "https://www.healthcarefinancenews.com/news/upmc-susquehanna-buying-two-pennsylvania-hospitals-quorum-health-corp" in 62877
		replace system_change_type = "acquisition" in 62877
		replace bankruptcy = 0 in 62877
		replace system_exit = 0 in 62877
		replace system_split = 0 in 62877
		replace merger = 0 in 62877
		replace target = 1 in 62877
		replace consolidation_ind = 1 in 62877
		replace sysid_fixed = 2911 in 62877
		replace acquirer = 0 in 62877
		replace cah = 0 in 62877
		replace general = 1 in 62877

		// Clear and recode obs 62866
		replace source_completed = "" in 62866
		replace system_change_type = "" in 62866
		replace bankruptcy = . in 62866
		replace system_exit = . in 62866
		replace system_split = . in 62866
		replace merger = . in 62866
		replace target = . in 62866
		replace consolidation_ind = . in 62866
		replace sysid_fixed = . in 62866
		replace acquirer = . in 62866
		replace cah = . in 62866
		replace general = . in 62866
		replace sysid_fixed2 = 9999999 in 62866

		// Batch replace sysid_fixed2 (62867–62876)
		foreach i in 62867 62868 62869 62870 62871 62872 62873 62874 62875 62876 {
			replace sysid_fixed2 = 9999999 in `i'
		}
				
		forvalues i = 70642/70680 {
			replace sysid_fixed2 = 2911 in `i'
		}
		
		*Starting from 70723:
		replace sysid_fixed2 = 724 in 70723
		replace sysid_fixed2 = 724 in 70724

		replace sysid_fixed  = 2911 in 71362
		replace sysid_fixed2 = 2911 in 71362
		replace sysid_fixed2 = 2911 in 71363
		replace sysid_fixed2 = 2911 in 71364
		
		forvalues i = 71362/71400 {
			replace sysid_fixed2 = 2911 in `i'
		}
		
				// Assign sysid_fixed2 = 2802 for observations 71545–71612 (except 71611 and 71612 are later updated)
		forvalues i = 71545/71612 {
			replace sysid_fixed2 = 2802 in `i'
		}

		// Override sysid_fixed2 for 71611 and 71612 to 888888
		replace sysid_fixed2 = 888888 in 71611
		replace sysid_fixed2 = 888888 in 71612

		// Set sysname for 71611 and 71612
		replace sysname = "PinnacleHealth" in 71611
		replace sysname = "PinnacleHealth" in 71612

		// Update metadata and system details for 71613
		replace source_completed     = "https://www.healthcarefinancenews.com/news/upmc-susquehanna-buying-two-pennsylvania-hospitals-quorum-health-corp" in 71613
		replace system_change_type   = "acquisition" in 71613
		replace bankruptcy           = 0 in 71613
		replace system_exit          = 0 in 71613
		replace system_split         = 0 in 71613
		replace merger               = 0 in 71613
		replace target               = 1 in 71613
		replace consolidation_ind    = 1 in 71613
		replace sysid_fixed          = 2911 in 71613
		replace acquirer             = 0 in 71613
		replace cah                  = 0 in 71613
		replace general              = 1 in 71613

		// Assign sysid_fixed = 888888 to 71611 (likely representing PinnacleHealth system)
		replace sysid_fixed = 888888 in 71611
		
		forvalues i = 71613/71640 {
			replace sysid_fixed2 = 2911 in `i'
		}
		
		replace sysid_fixed2 = 728 in 71878
		replace sysid_fixed2 = 728 in 71879
		
		*Start from 71971:
		replace sysid_fixed2 = 888888 in 71971
		replace sysid_fixed2 = 888888 in 71972
		replace source_completed    = "https://www.healthcarefinancenews.com/news/upmc-susquehanna-buying-two-pennsylvania-hospitals-quorum-health-corp" in 71973
		replace system_change_type  = "acquisition" in 71973
		replace bankruptcy          = 0 in 71973
		replace system_exit         = 0 in 71973
		replace system_split        = 0 in 71973
		replace merger              = 0 in 71973
		replace target              = 1 in 71973
		replace consolidation_ind   = 1 in 71973
		replace sysid_fixed2        = 2911 in 71973
		
		forvalues i = 71973/72000 {
			replace sysid_fixed2 = 2911 in `i'
		}

		*Start from 72520
		replace sysid_fixed2 = 71 in 72520
		replace sysid_fixed2 = 329 in 73318

		*Start from 74542
		replace sysid_fixed2 = 2862 in 74542
		
		*Starting from 76546
		replace sysid_fixed2 = 287 in 76546
		replace sysid_fixed2 = 287 in 76547
		replace sysid_fixed2 = 287 in 77026
		replace sysid_fixed2 = 287 in 77027

		replace sysid_fixed2 = 218 in 77191
		replace sysid_fixed2 = 218 in 77192
		replace sysid_fixed2 = 218 in 77551
		replace sysid_fixed2 = 218 in 77552

		replace sysid_fixed2 = 153 in 78436

		replace sysid_fixed2 = 755 in 79330

		replace sysid_fixed2 = 100 in 80017
		replace sysid_fixed2 = 100 in 80377

		replace sysid_fixed2 = 121 in 81445

		replace sysid_fixed2 = 760 in 81724
		replace sysid_fixed2 = 760 in 81725
		
		forvalues i = 82501/82548 {
			replace sysid_fixed2 = 73 in `i'
		}
		
		*Starting from 82501
		replace sysid_fixed = 73 in 82501

		replace sysid_fixed2 = 765 in 83908
		replace sysid_fixed2 = 100 in 84589

		replace source_completed = "https://www.novanthealth.org/newsroom/novant-health-and-uva-health-system-close-on-partnership" in 85129

		replace sysid_fixed2 = 100 in 85357
		replace sysid_fixed2 = 100 in 86701
		replace sysid_fixed2 = 121 in 86821
		replace sysid_fixed2 = 772 in 89530

		replace sysid_fixed2 = 63 in 91321
		replace sysid_fixed2 = 63 in 91322
		replace sysid_fixed2 = 63 in 91323
		replace sysid_fixed2 = 63 in 91324
		replace sysid_fixed2 = 63 in 91325
		replace sysid_fixed2 = 63 in 91326
		replace sysid_fixed2 = 63 in 91327
		replace sysid_fixed2 = 63 in 91328

		forvalues i = 92325/92376 {
			replace sysid_fixed2 = 27 in `i'
		}
		
		*Starting from 93076
		replace sysid_fixed2 = 342 in 93076

		replace sysid_fixed2 = 141 in 93313
		replace sysid_fixed2 = 141 in 93314

		replace sysid_fixed2 = 784 in 93433

		replace sysid_fixed2 = 789 in 94597
		replace sysid_fixed2 = 789 in 94598

		replace sysid_fixed2 = 251 in 96592
		replace sysid_fixed2 = 251 in 96593
		
		forvalues i = 97081/97109 {
			replace sysid_fixed2 = 2888 in `i'
		}
		
		forvalues i = 97110/97200 {
			replace sysid_fixed2 = 2795 in `i'
		}
		
		replace sysid_fixed = 2795 in 97110

		replace system_change_type = "" in 97153
		replace bankruptcy = . in 97153
		replace system_exit = . in 97153
		replace system_split = . in 97153
		replace merger = . in 97153
		replace target = . in 97153
		replace consolidation_ind = . in 97153
		replace sysid_fixed = . in 97153
		replace cah = . in 97153
		replace acquirer = . in 97153
		replace general = . in 97153	
		
		forvalues i = 97441/97480 {
			replace sysid_fixed2 = 340070 in `i'
		}
		
		*Starting from 97909
		replace sysid_fixed2 = 76 in 97909

		replace sysid_fixed2 = 807 in 98800
		replace sysid_fixed2 = 807 in 98801

		replace source_completed = "None" in 97933
		replace source_completed = "None" in 98905
		replace source_completed = "None" in 98941
		
		forvalues i = 99049/99060 {
			replace sysid_fixed2 = 341319 in `i'
		}
		
		*Starting from 99157
		* Individual replacements
		replace sysid_fixed2 = 76 in 99157
		replace sysid_fixed2 = 245 in 99223
		replace sysid_fixed2 = 266 in 100453
		replace sysid_fixed2 = 266 in 100454

		replace source_completed = "" in 100455
		replace system_change_type = "" in 100455
		replace bankruptcy = . in 100455
		replace system_exit = . in 100455
		replace system_split = . in 100455
		replace merger = . in 100455
		replace target = . in 100455
		replace consolidation_ind = . in 100455
		replace sysid_fixed = . in 100455
		replace acquirer = . in 100455
		replace cah = . in 100455
		replace general = . in 100455

		replace sysid_fixed2 = 1919 in 100618

		replace source_completed = "None" in 101197
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 101197
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 101029
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 102277

		* Grouped replacements: sysid_fixed2 = 7777777

		* Group 1: 98245 to 98268
		forvalues i = 98245/98268 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 2: 101005 to 101027
		forvalues i = 101005/101027 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 3: 101028 to 101029
		forvalues i = 101028/101029 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 4: 101173 to 101196
		forvalues i = 101173/101196 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 5: 102253 to 102276
		forvalues i = 102253/102276 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 6: 103297 to 103320
		forvalues i = 103297/103320 {
			replace sysid_fixed2 = 7777777 in `i'
		}

		* Group 7: 101197 (already in earlier replacements), but included here just in case
		replace sysid_fixed2 = 7777777 in 101197

		* Final changes for 102277
		replace system_change_type = "acquisition" in 102277
		replace target = 1 in 102277
		replace consolidation_ind = 1 in 102277
		replace sysid_fixed = 149 in 102277
		replace acquirer = 0 in 102277
		replace cah = 1 in 102277
		replace general = 0 in 102277
		replace bankruptcy = 0 in 102277
		replace system_exit = 0 in 102277
		replace system_split = 0 in 102277
		replace merger = 0 in 102277
		
		forvalues i = 97201/97224 {
			replace sysid_fixed2 = 7777777 in `i'
		}
		
		* Assign sysid_fixed2 = 73 to multiple observations
		forvalues i = 106492/106493 {
			replace sysid_fixed2 = 73 in `i'
		}

		* Block: Replacements for ID = 97225
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 97225
		replace system_change_type = "acquisition" in 97225
		replace bankruptcy = 0 in 97225
		replace system_exit = 0 in 97225
		replace system_split = 0 in 97225
		replace merger = 0 in 97225
		replace target = 1 in 97225
		replace consolidation_ind = 1 in 97225
		replace sysid_fixed = 149 in 97225
		replace acquirer = 0 in 97225
		replace cah = 1 in 97225
		replace general = 0 in 97225

		* Block: Replacements for ID = 101029
		replace system_change_type = "acquisition" in 101029
		replace bankruptcy = 0 in 101029
		replace system_exit = 0 in 101029
		replace system_split = 0 in 101029
		replace merger = 0 in 101029
		replace target = 1 in 101029
		replace consolidation_ind = 1 in 101029
		replace sysid_fixed = 149 in 101029
		replace acquirer = 0 in 101029
		replace cah = 1 in 101029
		replace general = 0 in 101029

		* Block: Replacements for ID = 108505
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 108505
		replace system_change_type = "acquisition" in 108505
		replace bankruptcy = 0 in 108505
		replace system_exit = 0 in 108505
		replace system_split = 0 in 108505
		replace merger = 0 in 108505
		replace target = 1 in 108505
		replace consolidation_ind = 1 in 108505
		replace sysid_fixed = 149 in 108505
		replace acquirer = 0 in 108505
		replace cah = 0 in 108505
		replace general = 1 in 108505

		forvalues i = 108481/108504 {
			replace sysid_fixed2 = 7777777 in `i'
		}
		
		forvalues i = 109117/109140 {
			replace sysid_fixed2 = 7777777 in `i'
		}
		
		forvalues i = 109837/109860 {
			replace sysid_fixed2 = 7777777 in `i'
		}
		
		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 109861

		* Overwriting prior value of system_change_type with correct classification
		replace system_change_type = "0" in 109861
		replace system_change_type = "acquisition" in 109861

		* Main attributes
		replace bankruptcy = 0 in 109861
		replace system_exit = 0 in 109861
		replace system_split = 0 in 109861
		replace merger = 0 in 109861
		replace target = 1 in 109861
		replace consolidation_ind = 1 in 109861
		replace sysid_fixed = 149 in 109861
		replace acquirer = 0 in 109861
		replace cah = 1 in 109861
		replace general = 0 in 109861
		
		replace cah = 1 in 98269
		replace general = 0 in 98269

		replace source_completed = "https://www.prnewswire.com/news-releases/university-health-systems-to-become-vidant-health-134768078.html" in 98269
		replace system_change_type = "acquisition" in 98269

		replace bankruptcy = 0 in 98269
		replace system_exit = 0 in 98269
		replace system_split = 0 in 98269
		replace merger = 0 in 98269
		replace target = 1 in 98269
		replace consolidation_ind = 1 in 98269

		replace sysid_fixed = 149 in 98269
		replace acquirer = 0 in 98269
		
		*Start from: . replace sysid_fixed2 = 266 in 100455
		* Grouped replacements: sysid_fixed2 = 266
		forvalues i = 100455/100459 {
			replace sysid_fixed2 = 266 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 149
		forvalues i = 101221/101222 {
			replace sysid_fixed2 = 149 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 817
		forvalues i = 102202/102203 {
			replace sysid_fixed2 = 817 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 2802
		foreach i in 102454 102455 110965 110966 {
			replace sysid_fixed2 = 2802 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 819
		forvalues i = 102592/102593 {
			replace sysid_fixed2 = 819 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 822
		forvalues i = 102973/102974 {
			replace sysid_fixed2 = 822 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 2844
		forvalues i = 103039/103040 {
			replace sysid_fixed2 = 2844 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 836
		forvalues i = 106429/106430 {
			replace sysid_fixed2 = 836 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 838
		forvalues i = 106888/106889 {
			replace sysid_fixed2 = 838 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 846
		forvalues i = 109765/109766 {
			replace sysid_fixed2 = 846 in `i'
		}

		* Grouped replacements: sysid_fixed2 = 245
		foreach i in 108415 109291 {
			replace sysid_fixed2 = 245 in `i'
		}

		* Manual replacements (non-contiguous sysid_fixed2 assignments)
		replace sysid_fixed2 = 76 in 101881
		replace sysid_fixed2 = 76 in 102925
		replace sysid_fixed2 = 76 in 104533
		replace sysid_fixed2 = 76 in 108109

		replace sysid_fixed2 = 821 in 102865
		replace sysid_fixed2 = 135 in 103219
		replace sysid_fixed2 = 825 in 103600
		replace sysid_fixed2 = 827 in 103924
		replace sysid_fixed2 = 841 in 107689
		replace sysid_fixed2 = 90 in 110470

		* Notes and source_completed field edits
		replace source_completed = "https://www.beckershospitalreview.com/hospital-transactions-and-valuation/cape-fear-valley-health-in-north-carolina-acquires-bladen-county-hospital" in 101319
		replace notes = "leased since 2008" in 101319

		replace source_completed = "https://www.beckershospitalreview.com/hospital-transactions-and-valuation/mission-health-finalizes-angel-medical-center-deal/" in 101789
		replace notes = "management agreement since May 2011" in 101789

		replace source_completed = "https://investor.hcahealthcare.com/news/news-details/2019/HCA-Healthcare-Completes-Purchase-of-Mission-Health/default.aspx" in 101882
		
		*Starting from 111085
		replace sysid_fixed2 = 2802 in 111085
		replace sysid_fixed2 = 2802 in 111086
		
		*Starting from 112271
		//Palmetto: 317
		//Greenville: 90
		//Prisma: 444444
		
		replace sysid_fixed2 = 444444 if regexm(sysname, "Prisma Health")
		
		*Start from 110471
		replace sysid_fixed2 = 444444 in 110471
		replace sysid_fixed2 = 444444 in 110472
		replace sysid_fixed2 = 444444 in 112271
		replace sysid_fixed2 = 444444 in 112272
		replace sysid_fixed = 444444 in 112271
		replace sysid_fixed = 444444 in 110471
		replace sysid_fixed2 = 2923 in 112882
		replace sysid_fixed2 = 2802 in 113365
		replace sysid_fixed2 = 2802 in 113366
		replace sysid_fixed2 = 332 in 113569
		replace sysid_fixed2 = 317 in 114382
		replace sysid_fixed2 = 73 in 114586
		replace sysid_fixed2 = 2802 in 114634
		replace sysid_fixed2 = 2802 in 114635
		replace sysid_fixed2 = 444444 in 114863
		replace sysid_fixed2 = 444444 in 114864
		replace sysid_fixed2 = 444444 in 115223
		replace sysid_fixed2 = 444444 in 115224
		replace sysid_fixed = 444444 in 115223
		replace sysid_fixed = 444444 in 114863
		replace sysid_fixed2 = 2802 in 115297
		replace sysid_fixed = 2802 in 115297
		replace sysid_fixed2 = 2802 in 115298
		replace sysid_fixed2 = 2802 in 115299
		replace sysid_fixed2 = 2802 in 115300
		replace sysid_fixed2 = 2802 in 115301
		replace sysid_fixed2 = 2802 in 115302
		replace sysid_fixed2 = 2802 in 115303
		replace sysid_fixed2 = 2802 in 115304
		replace sysid_fixed2 = 2802 in 115305
		replace sysid_fixed2 = 2802 in 115306
		replace sysid_fixed2 = 2802 in 115307
		replace sysid_fixed2 = 2802 in 115308
		replace sysid_fixed2 = 256 in 115324
		replace sysid_fixed2 = 2923 in 115354
		replace sysid_fixed2 = 2802 in 115861
		replace sysid_fixed2 = 2802 in 115862
		replace sysid_fixed2 = 860 in 115906
		replace sysid_fixed2 = 2802 in 116428
		replace sysid_fixed2 = 90 in 117058
		replace sysid_fixed2 = 444444 in 117059
		replace sysid_fixed2 = 444444 in 117060
		replace sysid_fixed = 444444 in 117059
		replace sysid_fixed2 = 444444 in 117179
		replace sysid_fixed2 = 444444 in 117180
		replace sysid_fixed = 444444 in 117179
		replace sysid_fixed2 = 2802 in 117310
		replace sysid_fixed2 = 2802 in 117311

		replace consolidation_ind = 1 in 117539
		replace target = 1 in 117539
		replace sysid_fixed2 = 444444 in 117539
		replace sysid_fixed2 = 444444 in 117540
		replace source_completed = "https://www.greenvilleonline.com/story/news/2017/11/21/ghs-completes-blockbuster-partnership-palmetto-health/886874001/" in 117539
		replace system_change_type = "merger of equals" in 117539
		replace bankruptcy = 0 in 117539
		replace system_exit = 0 in 117539
		replace system_split = 0 in 117539
		replace merger = 1 in 117539
		replace target = 0 in 117539
		replace sysid_fixed = 444444 in 117539
		replace acquirer = 0 in 117539
		replace cah = 0 in 117539
		replace general = 1 in 117539
		
		*Starting from 117631
		replace sysid_fixed2 = 866 in 117631
		replace sysid_fixed2 = 866 in 117632
		replace sysid_fixed2 = 873 in 118990
		replace sysid_fixed2 = 873 in 118991
		replace sysid_fixed2 = 250 in 119191
		replace sysid_fixed2 = 250 in 119192
		replace sysid_fixed2 = 71 in 119368
		replace sysid_fixed2 = 2860 in 119761
		replace sysid_fixed2 = 2860 in 119762
		replace sysid_fixed2 = 111314 in 121125
		replace sysid_fixed2 = 111314 in 121117
		replace sysid_fixed2 = 111314 in 121118
		replace sysid_fixed2 = 111314 in 121119
		replace sysid_fixed2 = 111314 in 121120
		replace sysid_fixed2 = 111314 in 121121
		replace sysid_fixed2 = 11131 in 121122
		replace sysid_fixed2 = 111314 in 121122
		replace sysid_fixed2 = 111314 in 121123
		replace sysid_fixed2 = 111314 in 121124
		replace sysid_fixed2 = 247 in 121210
		replace sysid_fixed2 = 881 in 121471
		replace sysid_fixed2 = 96 in 123133
		replace sysid_fixed2 = 96 in 123134
		replace sysid_fixed2 = 96 in 123613
		replace sysid_fixed2 = 96 in 123614
		replace sysid_fixed2 = 250 in 124987
		replace sysid_fixed2 = 250 in 124988
		replace sysid_fixed2 = 902 in 126484
		replace sysid_fixed2 = 343 in 126565
		replace sysid_fixed2 = 2862 in 126577

		replace source_completed = "https://www.stmaryshealthcaresystem.org/about-us/history" in 126769
		replace notes = "Jan. 1 – St. Mary's acquires Saint Joseph at East Georgia in Greensboro from Saint Joseph Health System of Atlanta and changed its name to St. Mary's Good Samaritan Hospital." in 126769
		replace notes = `"Jan. 1 – St. Mary's acquires Saint Joseph at East Georgia in Greensboro from Saint Joseph Health System of Atlanta and changed its name to St. Mary's Good Samaritan Hospital." (From Source URL)"' in 126769

		replace sysid_fixed2 = 71 in 126784
		replace sysid_fixed2 = 2860 in 126937
		replace sysid_fixed2 = 2860 in 126938
				
		forvalues i = 128153/128220 {
			replace sysid_fixed2 = 39 in `i'
		}
		
		*Start from 128153
		replace sysid_fixed = 39 in 128153
		replace sysid_fixed2 = 922 in 129997
		replace sysid_fixed2 = 2860 in 130741
		replace sysid_fixed2 = 2860 in 130742
		replace sysid_fixed2 = 925 in 130885
		replace sysid_fixed2 = 938 in 133381
		replace sysid_fixed2 = 938 in 133382
		replace sysid_fixed2 = 120 in 133444
		replace sysid_fixed2 = 173 in 134500
		replace sysid_fixed2 = 173 in 134501
		replace sysid_fixed2 = 946 in 135835
		replace sysid_fixed2 = 946 in 135836
		replace sysid_fixed2 = 71 in 137080
		replace sysid_fixed2 = 954 in 138163
		replace sysid_fixed2 = 2802 in 138808
		replace source_completed = "None" in 140929
		replace sysid_fixed2 = 71 in 142120
		replace sysid_fixed2 = 2802 in 143023
		replace sysid_fixed2 = 2802 in 143024
		replace sysid_fixed2 = 958 in 143221
		replace sysid_fixed2 = 959 in 143566
		replace sysid_fixed2 = 49 in 145273
		replace sysid_fixed2 = 49 in 145274
		replace sysid_fixed2 = 49 in 145275
		replace sysid_fixed2 = 49 in 145276
		replace sysid_fixed2 = 49 in 145277
		replace sysid_fixed2 = 49 in 145278
		replace sysname = "Shands Healthcare" in 145273
		replace sysname = "Shands Healthcare" in 145274
		replace sysname = "Shands Healthcare" in 145275
		replace sysname = "Shands Healthcare" in 145276
		replace sysname = "Shands Healthcare" in 145277
		replace sysname = "Shands Healthcare" in 145278
		replace sysid_fixed2 = 254 in 145723
		replace sysid_fixed2 = 254 in 145724
		replace sysid_fixed2 = 2802 in 145855
		replace sysid_fixed2 = 2802 in 145856
		replace sysid_fixed2 = 2802 in 145969
		replace sysname = "Shands Healthcare" in 146185
		replace sysname = "Shands Healthcare" in 146186
		replace sysname = "Shands Healthcare" in 146187
		replace sysname = "Shands Healthcare" in 146188
		replace sysname = "Shands Healthcare" in 146189
		replace sysname = "Shands Healthcare" in 146190
		replace sysname = "Shands Healthcare" in 146191
		replace sysid_fixed2 = 49 in 146185
		replace sysid_fixed2 = 49 in 146186
		replace sysid_fixed2 = 49 in 146187
		replace sysid_fixed2 = 49 in 146188
		replace sysid_fixed2 = 49 in 146189
		replace sysid_fixed2 = 49 in 146190
		replace sysid_fixed2 = 49 in 146191
		replace sysid_fixed2 = 109 in 146191
		replace source_completed = "" in 148209
		replace system_change_type = "" in 148209
		replace bankruptcy = . in 148209
		replace system_exit = . in 148209
		replace system_split = . in 148209
		replace merger = . in 148209
		replace target = . in 148209
		replace consolidation_ind = . in 148209
		replace sysid_fixed = . in 148209
		replace acquirer = . in 148209
		replace cah = . in 148209
		replace general = . in 148209
		replace sysid_fixed2 = 2802 in 148555
		replace sysid_fixed2 = 112 in 149884
		replace sysid_fixed2 = 299 in 150385
		replace sysid_fixed2 = 299 in 150386
		replace sysid_fixed2 = 2572 in 150409
		replace sysid_fixed2 = 2572 in 150410
		replace sysid_fixed2 = 71 in 151300
		replace sysid_fixed2 = 2802 in 152068
		replace source_completed = "" in 152217
		replace system_change_type = "" in 152217
		replace bankruptcy = . in 152217
		replace system_exit = . in 152217
		replace system_split = . in 152217
		replace merger = . in 152217
		replace target = . in 152217
		replace consolidation_ind = . in 152217
		replace sysid_fixed = . in 152217
		replace acquirer = . in 152217
		replace cah = . in 152217
		replace general = . in 152217
		replace sysid_fixed2 = 138 in 152551
		replace sysid_fixed2 = 138 in 152552
		replace sysid_fixed2 = 71 in 152668
		replace sysid_fixed2 = 2802 in 153196
		replace sysname = "Shands Healthcare" in 153589
		replace sysname = "Shands Healthcare" in 153590
		replace sysname = "Shands Healthcare" in 153591
		replace sysname = "Shands Healthcare" in 153592
		replace sysname = "Shands Healthcare" in 153593
		replace sysname = "Shands Healthcare" in 153594
		replace sysname = "Shands Healthcare" in 153595
		replace sysid_fixed2 = 49 in 153589
		replace sysid_fixed2 = 49 in 153590
		replace sysid_fixed2 = 49 in 153591
		replace sysid_fixed2 = 49 in 153592
		replace sysid_fixed2 = 49 in 153593
		replace sysid_fixed2 = 49 in 153594
		replace sysid_fixed2 = 49 in 153595
		replace sysid_fixed = 49 in 153595
		replace sysid_fixed2 = 109 in 153595
		replace sysid_fixed = 109 in 153595
		replace sysname = "Health Management Associates" in 153595
		replace sysid_fixed2 = 138 in 154459
		replace sysid_fixed2 = 138 in 154460
		replace sysid_fixed2 = 181 in 154639
		replace sysid_fixed2 = 181 in 154640
		replace sysid_fixed2 = 181 in 154759
		replace sysid_fixed2 = 181 in 154760
		replace source_completed = "" in 155229
		replace system_change_type = "" in 155229
		replace bankruptcy = . in 155229
		replace system_exit = . in 155229
		replace system_split = . in 155229
		replace merger = . in 155229
		replace target = . in 155229
		replace consolidation_ind = . in 155229
		replace sysid_fixed = . in 155229
		replace acquirer = . in 155229
		replace cah = . in 155229
		replace general = . in 155229
		replace sysid_fixed2 = 181 in 157123
		replace sysid_fixed2 = 181 in 157124
		replace sysid_fixed2 = 182 in 157546
		
		*Starting from 157726
		replace source_completed      = ""      in 157726
		replace system_change_type    = ""      in 157726
		replace bankruptcy            = .       in 157726
		replace system_exit           = .       in 157726
		replace system_split          = .       in 157726
		replace merger                = .       in 157726
		replace target                = .       in 157726
		replace consolidation_ind     = .       in 157726
		replace sysid_fixed           = .       in 157726
		replace acquirer              = .       in 157726
		replace cah                   = .       in 157726
		replace general               = .       in 157726

		replace sysid_fixed2          = 2802    in 157804
		replace sysid_fixed2          = 297     in 158101
		replace sysid_fixed2          = 297     in 158102
		replace sysid_fixed2          = 353     in 158470
		replace sysid_fixed2          = 2862    in 158521
		replace sysid_fixed2          = 153     in 159412
		replace sysid_fixed2          = 1002    in 160435
		replace sysid_fixed2          = 1004    in 160612
		
		*Starting from 162325
		* Assign sysid_fixed2 values across observations
		replace sysid_fixed2 = 361316 in 162325
		replace sysid_fixed2 = 361316 in 162326
		replace sysid_fixed2 = 361316 in 162327
		replace sysid_fixed2 = 361316 in 162328
		replace sysid_fixed2 = 361316 in 162329
		replace sysid_fixed2 = 361316 in 162330
		replace sysid_fixed2 = 361316 in 162331
		replace sysid_fixed2 = 361316 in 162332
		replace sysid_fixed2 = 361316 in 162333
		replace sysid_fixed2 = 361316 in 162334
		replace sysid_fixed2 = 361316 in 162335
		replace sysid_fixed2 = 361316 in 162336

		replace sysid_fixed2 = 2862 in 164017
		replace sysid_fixed2 = 153 in 166516
		replace sysid_fixed2 = 153 in 166636
		replace sysid_fixed2 = 1029 in 167158
		replace sysid_fixed2 = 2862 in 167374
		replace sysid_fixed2 = 2862 in 167375

		forvalues i = 168121/168137 {
			replace sysid_fixed2 = 361302 in `i'
		}

		replace sysid_fixed2 = 353 in 168178
		replace sysid_fixed2 = 2862 in 168229
		replace sysid_fixed2 = 1031 in 168433

		forvalues i = 168841/168852 {
			replace sysid_fixed2 = 361325 in `i'
		}

		replace notes = "Belonged to Brown County (public)" in 169338

		forvalues i = 169321/169337 {
			replace sysid_fixed2 = 360116 in `i'
		}

		replace source_completed = ///
		"https://www.beckershospitalreview.com/hospital-transactions-and-valuation/ohios-pike-community-hospital-in-talks-to-affiliate-with-adena-health/" ///
		in 169388

		forvalues i = 169369/169386 {
			replace sysid_fixed2 = 361304 in `i'
		}

		* These lines are separate assignments
		replace sysid_fixed2 = 361304 in 169387
		replace sysid_fixed2 = 182 in 170698
		replace sysid_fixed2 = 251 in 171316
		replace sysid_fixed2 = 251 in 171317
		replace sysid_fixed2 = 1045 in 171715
		replace sysid_fixed2 = 1045 in 171716
		replace sysid_fixed2 = 303 in 173452
		replace sysid_fixed2 = 303 in 173453
		replace sysid_fixed2 = 297 in 173917
		replace sysid_fixed2 = 297 in 173918
		replace sysid_fixed2 = 2802 in 175792
		replace sysid_fixed2 = 153 in 175864
		replace sysid_fixed2 = 1067 in 176089
		replace sysid_fixed2 = 1067 in 176090
		
		forvalues i = 169388/169488 {
			replace sysid_fixed2 = 2838 in `i'
		}
		
		*Starting from 176428
		replace sysid_fixed2 = 611  in 176500
replace sysid_fixed2 = 2923 in 176530
		replace sysid_fixed2 = 332  in 176974
		replace sysid_fixed2 = 50   in 177025
		replace sysid_fixed2 = 50   in 177026
		replace sysid_fixed2 = 1080 in 179938
		
		forvalues i = 181122/181140 {
			replace sysid_fixed2 = 2880 in `i'
		}
		
		*Starting from 182734
		replace sysid_fixed2        = 1092     in 182734
		replace sysid_fixed2        = 132      in 183718
		replace sysid_fixed2        = 150026   in 184234
		replace sysid_fixed         = 150026   in 184234
		replace acquirer            = .        in 184234
		replace acquirer            = 0        in 184234
		replace consolidation_ind   = 0        in 184234
		
		forvalues i = 184234/184272 {
			replace sysid_fixed2 = 150026 in `i'
		}
		
		*Starting from 185368
		replace sysid_fixed2 = 1102 in 185368
		replace sysid_fixed2 = 1102 in 185369
		replace sysid_fixed2 = 337 in 185884

		forvalues i = 185885/185947 {
			replace sysid_fixed2 = 150009 in `i'
		}
		
		*Starting from 185947
		* Batch sysid_fixed2 replacements
		replace sysid_fixed2 = 167      in 186193
		replace sysid_fixed2 = 167      in 186194
		replace sysid_fixed2 = 167      in 186673
		replace sysid_fixed2 = 167      in 186674

		foreach i in 187501 187502 187503 187504 187505 187506 187507 187508 187509 187510 187511 187512 187513 187514 187515 {
			replace sysid_fixed2 = 151312 in `i'
		}

		replace sysid_fixed2 = 153      in 188740
		replace sysid_fixed2 = 239      in 189022
		replace sysid_fixed2 = 239      in 189023
		replace sysid_fixed2 = 1114     in 189127
		replace sysid_fixed2 = 1114     in 189128
		replace sysid_fixed2 = 1121     in 190090
		replace sysid_fixed2 = 153      in 190228
		replace sysid_fixed2 = 67       in 192109
		replace sysid_fixed2 = 2814     in 192181
		replace sysid_fixed2 = 1126     in 192241
		replace sysid_fixed2 = 2806     in 192699
		replace sysid_fixed2 = 2806     in 192739
		replace sysid_fixed2 = 1129     in 193462
		replace sysid_fixed2 = 67       in 193909
		replace sysid_fixed2 = 2814     in 193981
		replace sysid_fixed2 = 2814     in 193982
		replace sysid_fixed2 = 2860     in 194581
		replace sysid_fixed2 = 2860     in 194582
		replace sysid_fixed2 = 1132     in 194869
		replace sysid_fixed2 = 1132     in 194870
		replace sysid_fixed2 = 331      in 196429
		replace sysid_fixed2 = 153      in 197452
		replace sysid_fixed2 = 153      in 197572
		replace sysid_fixed2 = 105      in 197797
		replace sysid_fixed2 = 105      in 198274
		replace sysid_fixed2 = 2814     in 198349
		replace sysid_fixed2 = 2814     in 198350
		replace sysid_fixed2 = 105      in 198757
		replace sysid_fixed2 = 2814     in 198829
		replace sysid_fixed2 = 2814     in 198830
		replace sysid_fixed2 = 105      in 198877
		replace sysid_fixed2 = 2814     in 198949
		replace sysid_fixed2 = 2814     in 198950
		replace sysid_fixed2 = 67       in 199477
		replace sysid_fixed2 = 2814     in 199549
		replace sysid_fixed2 = 82       in 200122
		replace sysid_fixed2 = 82       in 200123
		replace sysid_fixed2 = 67       in 201274
		replace sysid_fixed2 = 2814     in 201346
		replace sysid_fixed2 = 2814     in 201347
		replace sysid_fixed2 = 1160     in 201409
		replace sysid_fixed2 = 1160     in 201410
		replace sysid_fixed2 = 105      in 201874
		replace sysid_fixed2 = 2814     in 201946
		replace sysid_fixed2 = 2814     in 201947
		replace sysid_fixed2 = 2806     in 202944
		replace sysid_fixed2 = 2806     in 202984
		replace sysid_fixed2 = 1169     in 203485
		replace sysid_fixed2 = 135      in 205003
		replace sysid_fixed2 = 67       in 205354
		replace sysid_fixed2 = 2814     in 205426
		replace sysid_fixed2 = 2814     in 205427
		replace sysid_fixed2 = 67       in 205711
		replace sysid_fixed2 = 2814     in 205786
		replace sysid_fixed2 = 2814     in 205787
		replace sysid_fixed2 = 318      in 206170
		replace sysid_fixed2 = 222      in 206872
		replace sysid_fixed2 = 222      in 206873
		
		*Starting from 209018
		* Replacements for sysid_fixed2 and sysid_fixed
		forvalues i = 209018/209037 {
			replace sysid_fixed2 = 361 in `i'
		}
		replace sysid_fixed = 361 in 209018

		replace sysid_fixed2 = 153   in 209449
		replace sysid_fixed2 = 1194  in 209677
		replace sysid_fixed2 = 1199  in 210415
		replace sysid_fixed2 = 82    in 212239
		replace sysid_fixed2 = 82    in 212240
		replace sysid_fixed2 = 52    in 214204
		replace sysid_fixed2 = 52    in 214205
		replace sysid_fixed2 = 153   in 215269
		replace sysid_fixed2 = 135   in 215644
		replace sysid_fixed2 = 135   in 215645
		replace sysid_fixed2 = 153   in 216169
		replace sysid_fixed2 = 1221  in 216589
		replace sysid_fixed2 = 153   in 217369
		replace sysid_fixed2 = 2848  in 217390
		replace sysid_fixed2 = 1223  in 217543
		replace sysid_fixed2 = 1223  in 217544
		replace sysid_fixed2 = 1224  in 217630
		replace sysid_fixed2 = 1226  in 217879
		replace sysid_fixed2 = 1226  in 217880
		replace sysid_fixed2 = 153   in 218101
		replace sysid_fixed2 = 52    in 218476
		replace sysid_fixed2 = 52    in 218477
		replace sysid_fixed2 = 1235  in 220156
		replace sysid_fixed2 = 1235  in 220157
		replace sysid_fixed2 = 1238  in 220921
		replace sysid_fixed2 = 1238  in 220922
		replace sysid_fixed2 = 153   in 221221
		replace sysid_fixed2 = 153   in 221461
		replace sysid_fixed2 = 2848  in 221482
		replace sysid_fixed2 = 2895  in 221596
		replace sysid_fixed2 = 2895  in 221597
		replace sysid_fixed2 = 1241  in 221707
		replace sysid_fixed2 = 1241  in 221708
		replace sysid_fixed2 = 153   in 222301
		
		*Starting from 222631
// 		capture drop id_year_month_counter
// 		by id year: gen id_year_month_counter = _n
//		
//		
// 		forvalues n = 1/12 {
// 			capture drop sysid_fixed2_mo`n'
// 			gen sysid_fixed2_mo`n' = sysid_fixed2 if id_year_month_counter == `n'
// 			capture drop sysid_fixed2_month`n'
// 			bys id year: egen sysid_fixed2_month`n' = min(sysid_fixed2_mo`n')
// 			drop sysid_fixed2_mo`n'
//
// 		}
//		
		
		capture drop consol_in_quarter
		bys id year_qtr: egen consol_in_quarter = min(consolidation_ind)
		
		capture drop consol_in_quarter_month
		gen consol_in_quarter_month = month * consol_in_quarter if consolidation_ind == 1
		
		capture drop consol_month
		bys id year_qtr: egen consol_month = min(consol_in_quarter_month)
		
		sort id year month
		capture drop sysid_fixed2_m_1
		by id (year): gen sysid_fixed2_m_1 = sysid_fixed2[_n-1]
		capture drop sysid_fixed2_m_2
		by id (year): gen sysid_fixed2_m_2 = sysid_fixed2[_n-2]
		capture drop sysid_fixed2_m_3
		by id (year): gen sysid_fixed2_m_3 = sysid_fixed2[_n-3]
		
		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 1 & consol_month == 2 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 1 & consol_month == 3 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_2 if consolidation_ind == . & month == 2 & consol_month == 3 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 4 & consol_month == 5 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 4 & consol_month == 6 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_2 if consolidation_ind == . & month == 5 & consol_month == 6 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 7 & consol_month == 8 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 7 & consol_month == 9 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_2 if consolidation_ind == . & month == 8 & consol_month == 9 & consol_in_quarter == 1
		
		sort id year month
		
		*Reset from 4405
		* Assign sysid_fixed
		foreach obs in 4405 4645 5749 6109 {
			replace sysid_fixed = 111111 in `obs'
		}

		replace sysid_fixed = 92    in 20613
		replace sysid_fixed = 2923  in 21257
		replace sysid_fixed = 562   in 25953
		replace sysid_fixed = 557   in 33778
		replace sysid_fixed = .     in 47113
		replace sysid_fixed = 2911  in 64306

		* Assign sysid_fixed2
		foreach obs in 17572 17573 {
			replace sysid_fixed2 = 2875 in `obs'
		}

		foreach obs in 22522 22523 22524 22525 {
			replace sysid_fixed2 = 71 in `obs'
		}

		foreach obs in 32413 32414 32533 32534 {
			replace sysid_fixed2 = 350 in `obs'
		}

		foreach obs in 37048 37049 37050 {
			replace sysid_fixed2 = 75 in `obs'
		}

		replace sysid_fixed2 = 329 in 42508
		replace sysid_fixed2 = 71  in 51040
		replace sysid_fixed2 = 699 in 64420

		* Assign sysid_fixed2 = 2911 across sequential observations
		replace sysid_fixed2 = 2911 in 64306
		forvalues i = 64307/64344 {
			replace sysid_fixed2 = 2911 in `i'
		}

		* Clear source_completed fields and update with URL
		replace source_completed = "" in 17573
		replace source_completed = ///
		"https://www.valleybreeze.com/news/chartercare-health-and-prospect-medical-launch-partnership/article_c8a279d3-049a-549e-9f61-7b227fea686f.html" ///
		in 17574

		* Clear and overwrite fields for record 47113
		replace notes                = "announced" in 47113
		replace system_change_type   = ""          in 47113
		foreach var in bankruptcy system_exit system_split target merger consolidation_ind ///
						sysid_fixed acquirer cah general {
			replace `var' = . in 47113
		}

		* Add note
		replace notes = "Now as affiliate agreement" in 31575
		
		* Assign sysid_fixed
		replace sysid_fixed = 9999999 in 62860
		replace sysid_fixed = 9999999 in 69328
		replace sysid_fixed = 2911     in 70642
		replace sysid_fixed = 2911     in 71973
		replace sysid_fixed = 27       in 92325

		* Assign sysid_fixed2 initially to 222222
		foreach obs in 64465 64466 64467 64468 {
			replace sysid_fixed2 = 222222 in `obs'
		}

		* Then overwrite those and more with sysid_fixed2 = 390108
		foreach obs in 64465/64479 {
			replace sysid_fixed2 = 390108 in `obs'
		}

		* Final sysid_fixed2 updates
		replace sysid_fixed2 = 149 in 101029
		replace sysid_fixed2 = 149 in 101197

		* Additional attribute flags
		replace acquirer = 0 in 71973
		replace cah      = 0 in 71973
		replace general  = 1 in 71973
		
		forvalues i = 101293/101318 {
			replace sysid_fixed2 = 341315 in `i'
		}
				
		forvalues i = 101773/101788{
			replace sysid_fixed2 = 341326 in `i'
		}
				
	* Assign sysid_fixed2 = 111330 to sequential observations
		foreach obs in 122941 122942 122943 {
			replace sysid_fixed2 = 111330 in `obs'
		}

		* Individual sysid_fixed and sysid_fixed2 assignments
		replace sysid_fixed  = 2838   in 169388
		replace sysid_fixed2 = 360016 in 177025
		replace sysid_fixed2 = 360016 in 177026
		replace sysid_fixed  = 2880   in 181122
		replace sysid_fixed2 = 112    in 185885
				
		forvalues i = 185886/185947 {
			replace sysid_fixed2 = 112 in `i'
		}
		
		forvalues i = 222742/222788 {
			replace sysid_fixed2 = 231321 in `i'
		}
		
		forvalues i = 222789/222861 {
			replace sysid_fixed2 = 112 in `i'
		}
		
		
		replace sysid_fixed2 = 1254 in 224290
		replace sysid_fixed2 = 1254 in 224291
		replace sysid_fixed2 = 1254 in 224292
		replace sysid_fixed2 = 275 in 226664

		forvalues i = 226664/226725 {
			replace sysid_fixed2 = 275 in `i' 
		}
		
		* Assign sysid_fixed2 = 1274
		foreach obs in 229651 229652 {
			replace sysid_fixed2 = 1274 in `obs'
		}

		* Assign sysid_fixed2 = 230003 across sequential records
		forvalues i = 230026/230037 {
			replace sysid_fixed2 = 230003 in `i'
		}

		* Final individual assignment
		
		forvalues i = 231973/232005 {
			replace sysid_fixed2 = 29 in `i'
		}
		
		forvalues i = 238777/238809 {
			replace sysid_fixed2 = 29 in `i'
		}
		
		replace sysid_fixed2	=	1313 in 240115

		replace sysid_fixed2	=	1313 in 240116

		replace sysid_fixed2	=	521346 in 242530

		forvalues i = 242530/242541 {
			replace sysid_fixed2 = 521346 in `i'
		}
		
		replace sysid_fixed2 = 132 in 243571

		replace sysid_fixed2 = 239 in 249475

		replace sysid_fixed2 = 239 in 249476
		
		* Assign sysid_fixed2 = 1234321
		foreach obs in 251936 251937 255374 255375 {
			replace sysid_fixed2 = 1234321 in `obs'
		}

		* Individual sysid_fixed2 assignments
		replace sysid_fixed2 = 1353 in 251971
		replace sysid_fixed2 = 1354 in 252349
		replace sysid_fixed2 = 1378 in 261685
		
		forvalues i = 263092/263107 {
			replace sysid_fixed2 = 440231 in `i'
		}

		*Start from 264136
		* Clear or reset fields for observation 264556
		replace source_completed      = "" in 264556
		replace system_change_type    = "" in 264556

		foreach var in bankruptcy system_exit system_split merger target consolidation_ind ///
						sysid_fixed acquirer cah general {
			replace `var' = . in 264556
		}

		* Update sysid_fixed2
		replace sysid_fixed2 = 109 in 267648
		
		forvalues i = 267648/267675 {
			replace sysid_fixed2 = 109 in `i'
		}
		
		forvalues i = 270226/270274 {
			replace sysid_fixed2 = 256 in `i'
		}
		
		forvalues i = 271996/272081 {
			replace sysid_fixed2 = 2802 in `i'
		}
		
		. replace sysid_fixed2 = 10006 in 276100

		replace sysid_fixed2 = 10006 in 276101

		replace sysid_fixed2 = 10006 in 276102

		replace sysid_fixed2 = 10006 in 276103

		replace sysid_fixed2 = 10006 in 276104

		replace sysid_fixed2 = 10006 in 276105

		replace sysid_fixed2 = 2923 in 276205

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 10 & consol_month == 11 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_1 if consolidation_ind == . & month == 10 & consol_month == 12 & consol_in_quarter == 1

		replace sysid_fixed2 = sysid_fixed2_m_2 if consolidation_ind == . & month == 11 & consol_month == 12 & consol_in_quarter == 1
		
		replace source_completed = "" in 276388
		replace system_change_type = "" in 276388
		replace bankruptcy = . in 276388
		replace system_exit = . in 276388
		replace system_split = . in 276388
		replace merger = . in 276388
		replace target = . in 276388
		replace consolidation_ind = . in 276388
		replace sysid_fixed = . in 276388
		replace acquirer = . in 276388
		replace cah = . in 276388
		replace general = . in 276388

		foreach obs in 281776 281777 281778 281779 281780 281781 281782 281783 281784 281785 {
			replace sysid_fixed2 = 11302 in `obs'
		}

		foreach obs in 285621 285622 285623 285624 285625 285626 {
			replace sysid_fixed2 = 2802 in `obs'
		}

		replace sysid_fixed2 = 802 in 285627
		replace sysid_fixed2 = 2802 in 285627
		replace sysid_fixed = 2802 in 285621

		replace sysid_fixed2 = 241360 in 298127
		replace sysid_fixed2 = 1533 in 298127
		
		forvalues i = 298128/298215 {
			replace sysid_fixed2 = 300 in `i'
		}
		
		forvalues i = 299388/299499 {
			replace sysid_fixed2 = 300 in `i'
		}
		
		forvalues i = 312400/312467 {
			replace sysid_fixed2 = 161341 in `i'
		}
		
		forvalues i = 312805/312879 {
			replace sysid_fixed2 = 1585 in `i'
		}
		
		forvalues i = 312880/312934 {
			replace sysid_fixed2 = 161352 in `i'
		}
		
		forvalues i = 318144/318159 {
			replace sysid_fixed2 = 2881 in `i'
		}
		
		* Set sysid_fixed2 = 161329 for a sequence of observations
		foreach obs in 318760 318761 318762 318763 318764 318765 {
			replace sysid_fixed2 = 161329 in `obs'
		}

		* Clear system change info for obs 327265
		replace source_completed = "" in 327265
		replace system_change_type = "" in 327265
		replace bankruptcy = . in 327265
		replace system_exit = . in 327265
		replace system_split = . in 327265
		replace merger = . in 327265
		replace target = . in 327265
		replace consolidation_ind = . in 327265
		replace sysid_fixed = . in 327265
		replace acquirer = . in 327265
		replace cah = . in 327265
		replace general = . in 327265

		* Set sysid_fixed2 = 260080 for a block of obs
		foreach obs in 328936 328937 328938 328939 328940 328941 328942 328943 328944 328945 {
			replace sysid_fixed2 = 260080 in `obs'
		}

		* Clear system change info for obs 329221
		replace source_completed = "" in 329221
		replace system_change_type = "" in 329221
		replace bankruptcy = . in 329221
		replace system_exit = . in 329221
		replace system_split = . in 329221
		replace merger = . in 329221
		replace target = . in 329221
		replace consolidation_ind = . in 329221
		replace sysid_fixed = . in 329221
		replace acquirer = . in 329221
		replace cah = . in 329221
		replace general = . in 329221

		* Set sysid_fixed2 = 171 for three observations
		foreach obs in 329221 329222 329223 {
			replace sysid_fixed2 = 171 in `obs'
		}

		* Set sysid_fixed2 = 361 for two observations
		forvalues obs = 333666/333747 {
			replace sysid_fixed2 = 361 in `obs'
		}
		
		forvalues i = 346523/346635 {
			replace sysid_fixed2 = 344 in `i'
		}
		
		* Set sysid_fixed2 = 281331 for a block of observations
		foreach obs in 357004 357005 357006 357007 357008 357009 357010 357011 357012 357013 357014 357015 357016 357017 {
			replace sysid_fixed2 = 281331 in `obs'
		}

		* Clear system change info for obs 362322
		replace system_change_type = "" in 362322
		replace bankruptcy = . in 362322
		replace system_exit = . in 362322
		replace system_split = . in 362322
		replace merger = . in 362322
		replace target = . in 362322
		replace consolidation_ind = . in 362322
		replace sysid_fixed = . in 362322
		replace acquirer = . in 362322
		replace cah = . in 362322
		replace general = . in 362322

		* Add source link for CHI-Alegent acquisition
		replace source_completed = "https://www.modernhealthcare.com/article/20121101/NEWS/311019954/chi-completes-alegent-acquisition" in 362330

		* Set sysid_fixed2 = 1801 for observations 362322 through 362329
		foreach obs in 362322 362323 362324 362325 362326 362327 362328 362329 {
			replace sysid_fixed2 = 1801 in `obs'
		}

		* Set sysid_fixed2 = 208 in observation 362296
		replace sysid_fixed2 = 208 in 362296
		
		forvalues i = 362296/362329 {
			replace sysid_fixed2 = 208 in `i'
		}
		
		forvalues i = 378296/378375 {
			replace sysid_fixed2 = 132 in `i'
		}
		

			* Update system change details for observation 64421
			replace sysid_fixed2 = 2911 in 64421
			replace system_change_type = "acquisition" in 64421
			replace merger = 0 in 64421
			replace target = 1 in 64421
			
		forvalues i = 64421/64464 {
			replace sysid_fixed2 = 2911 in `i'
		}
			
		forvalues i = 384427/384471 {
			replace sysid_fixed2 = 2345432 in `i'
		}
				
		* Bulk replace based on condition
		replace sysid_fixed2 = 2345432 if eff_sysid2 == "981"

		* Individual sysid_fixed and sysid_fixed2 replacements
		replace sysid_fixed2 = 2345432 in 277129
		replace sysid_fixed = 2345432 in 276415
		replace sysid_fixed = 2345432 in 264583

		* Replace sysid_fixed2 = 2911 for a block of observations
		foreach obs in 274146 274147 274148 274149 274150 274152 274153 274154 274155 274156 274157 274158 {
			replace sysid_fixed2 = 2911 in `obs'
		}
		* Double replace for 274151
		replace sysid_fixed2 = 291 in 274151
		replace sysid_fixed2 = 2911 in 274151

		* Replace sysid_fixed2 = 2345432 for a block of 2026xx
		foreach obs in 202678 202679 202680 202681 202682 202683 202684 202685 202686 202687 202688 202689 {
			replace sysid_fixed2 = 2345432 in `obs'
		}

		* Replace sysid_fixed2 = 2345432 for a block of 5782xx
		foreach obs in 578243 578244 578245 578246 578247 578248 578249 578250 578251 {
			replace sysid_fixed2 = 2345432 in `obs'
		}

		* Replace sysid_fixed2 = 50194 for remaining 5782xx
		foreach obs in 578252 578253 578254 {
			replace sysid_fixed2 = 50194 in `obs'
		}

		* Clear system change info for 384988
		replace source_completed = "" in 384988
		replace system_change_type = "" in 384988
		replace bankruptcy = . in 384988
		replace system_exit = . in 384988
		replace system_split = . in 384988
		replace merger = . in 384988
		replace target = . in 384988
		replace consolidation_ind = . in 384988
		replace sysid_fixed = . in 384988
		replace acquirer = . in 384988
		replace cah = . in 384988
		replace general = . in 384988

		* Replace sysid_fixed2 = 41311 for 38758x range
		foreach obs in 387580 387581 387582 387583 387584 387585 {
			replace sysid_fixed2 = 41311 in `obs'
		}

		* Replace sysid_fixed2 = 335 for 38758x–38760x
		foreach obs in 387586 387587 387588 387589 387590 387591 387592 387593 387594 387595 387596 387597 387598 387599 387600 387601 387602 387603 {
			replace sysid_fixed2 = 335 in `obs'
		}
				
							
		forvalues i = 387604/387699 {
			replace sysid_fixed2 = 41311 in `i'
		}
		
		
		forvalues i = 401617/401655 {
			replace sysid_fixed2 = 277 in `i'
		}
			
		* Replace sysid_fixed2 = 190313 for three observations
		foreach obs in 401656 401657 401658 {
			replace sysid_fixed2 = 190313 in `obs'
		}

		* Clear acquirer and consolidation_ind, and update sysid_fixed2 for 405581
		replace acquirer = . in 405581
		replace consolidation_ind = . in 405581
		replace sysid_fixed2 = 370093 in 405581
		
		forvalues i = 405581/405603 {
			replace sysid_fixed2 = 370093 in `i'
		}
		
		* Clear system change information for observation 411000
		replace source_completed = "" in 411000
		replace system_change_type = "" in 411000
		replace bankruptcy = . in 411000
		replace system_exit = . in 411000
		replace system_split = . in 411000
		replace merger = . in 411000
		replace target = . in 411000
		replace consolidation_ind = . in 411000
		replace sysid_fixed = . in 411000
		replace acquirer = . in 411000
		replace cah = . in 411000
		replace general = . in 411000

		* Update sysid_fixed2 for observation 416071
		replace sysid_fixed2 = 132 in 416071
		
		forvalues i = 416071/416151 {
			replace sysid_fixed2 = 132 in `i'
		}
		
		* Update values for acquisition case in observation 416720
		replace source_completed = "https://www.sec.gov/Archives/edgar/data/1756655/000119312518342132/d658879ds1.htm" in 416720
		replace system_change_type = "acquisition" in 416720
		replace bankruptcy = 0 in 416720
		replace system_exit = 0 in 416720
		replace system_split = 0 in 416720
		replace merger = 0 in 416720
		replace target = 1 in 416720
		replace consolidation_ind = 1 in 416720
		replace notes = "lease agreement" in 416720
		replace acquirer = 0 in 416720
		replace general = 1 in 416720
		replace cah = 0 in 416720
		replace sysid_fixed2 = 2572 in 416720

		* Clear system change information for observation 416704
		replace general = . in 416704
		replace cah = . in 416704
		replace acquirer = . in 416704
		replace sysid_fixed = . in 416704
		replace consolidation_ind = . in 416704
		replace target = . in 416704
		replace merger = . in 416704
		replace system_split = . in 416704
		replace system_exit = . in 416704
		replace bankruptcy = . in 416704
		replace system_change_type = "" in 416704
		
		forvalues i = 416720/416751 {
			replace sysid_fixed2 = 2572  in `i'
		}
		
		
		replace sysid_fixed = 132 in 416071

		replace sysid_fixed = 2572 in 416720
		
		forvalues i = 417028/417051 {
			replace sysid_fixed2 = 370103 in `i'
		}
		
		* Replace sysid_fixed2 = 371304 for observations 418360 to 418371
		foreach obs in 418360 418361 418362 418363 418364 418365 418366 418367 418368 418369 418370 418371 {
			replace sysid_fixed2 = 371304 in `obs'
		}

		* Replace sysid_fixed2 = 361 for observations 419419 to 419439
		foreach obs in 419419 419420 419421 419422 419423 419424 419425 419426 419427 419428 419429 419430 ///
					   419431 419432 419433 419434 419435 419436 419437 419438 419439 {
			replace sysid_fixed2 = 361 in `obs'
		}

		* Update fields for observation 426040
		replace mcrnum = 450832 in 426040
		replace sysname = "Houston Methodist" in 426040
		replace eff_sysid2 = "7235" in 426040
		replace sysid_fixed2 = 2797 in 426040
		replace month = 2 in 426040

		* Update system identifiers for observation 455575
		replace sysid_fixed2 = 3022887 in 455575
		replace sysid_fixed = 3022887 in 455575

		*Might what to re-confirm Baylor Scott White Healthcare (433218)
		forvalues i = 455575/455650 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		*Might what to re-confirm Baylor Scott White Healthcare (433218)
		forvalues i = 435403/435478 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		forvalues i = 433210/433285 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		forvalues i = 464407/464482 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		forvalues i = 464527/464602 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		* Replace sysid_fixed2 = 451374 for observations 464363 to 464370
		foreach obs in 464363 464364 464365 464366 464367 464368 464369 464370 {
			replace sysid_fixed2 = 451374 in `obs'
		}

		* Update system identifiers for observation 464527
		replace sysid_fixed2 = 3022887 in 464527
		replace sysid_fixed = 3022887 in 464527
		
		replace sysid_fixed = 3022887 in 466063

		replace sysid_fixed2 = 3022887 in 466063
		
		forvalues i = 466063/466138 {
			replace sysid_fixed2 = 3022887 in `i'
		}
		
		forvalues i = 468869/468910 {
			replace sysid_fixed2 = 15 in `i'
		}

		forvalues i = 478499/478519 {
			replace sysid_fixed2 = 131310 in `i'
		}
		
		* Replace sysid_fixed2 = 61326 for observations 486239 to 486247
		foreach obs in 486239 486240 486241 486242 486243 486244 486245 486246 486247 {
			replace sysid_fixed2 = 61326 in `obs'
		}

		* Clear system change information for observation 501973
		replace source_completed     = "" in 501973
		replace system_change_type   = "" in 501973
		replace bankruptcy           = . in 501973
		replace system_exit          = . in 501973
		replace system_split         = . in 501973
		replace merger               = . in 501973
		replace target               = . in 501973
		replace consolidation_ind    = . in 501973
		replace sysid_fixed          = . in 501973
		replace acquirer             = . in 501973
		replace cah                  = . in 501973
		replace general              = . in 501973

		* Update sysid_fixed and sysid_fixed2 to 2900 in observation 501956
		replace sysid_fixed  = 2900 in 501956
		replace sysid_fixed2 = 2900 in 501956

		* Replace sysid_fixed2 = 2900 for observations 501957 to 501972
		foreach obs in 501957 501958 501959 501960 501961 501962 501963 501964 501965 501966 ///
					   501967 501968 501969 501970 501971 501972 {
			replace sysid_fixed2 = 2900 in `obs'
		}

		* Replace sysid_fixed2 for final block
		replace sysid_fixed2 = 2900 in 504068
		replace sysid_fixed2 = 290 in 504069
		replace sysid_fixed2 = 2900 in 504069
		
		forvalues i = 504068/504142 {
			replace sysid_fixed2 = 2900 in `i'
		}
		
		forvalues i = 505424/505498 {
			replace sysid_fixed2 = 2900 in `i'
		}
		
		forvalues i = 506384/506458 {
			replace sysid_fixed2 = 2900 in `i'
		}
		
		forvalues i = 506744/506818 {
			replace sysid_fixed2 = 2900 in `i'
		}
		
		keep if !missing(mcrnum)
		
		capture drop sysid_clean
		egen sysid_clean = group(sysid_fixed2)
		
		sort id year_qtr month
		
		capture drop sysid_clean_qtrend
			by id year_qtr: gen sysid_clean_qtrend = sysid_clean[_N]
			
		save ..\temp\pre_strat_ma_db_monthly.dta, replace
		
		use ..\temp\pre_strat_ma_db_monthly.dta, clear
			
		rename sysid_clean system_id
		
		rename sysid_clean_qtrend system_id_qtr
		
		rename medicare_ccn medicare_ccn_str
		
		rename mcrnum medicare_ccn
		
		rename merger merger_of_equals
		
		sort id year year_qtr month
		
		capture drop system_id_yr
			by id year: gen system_id_yr = system_id[_N]
		
		keep fac_name hrrcode year year_qtr month medicare_ccn medicare_ccn_str source_completed bankruptcy system_exit system_split merger_of_equals target notes system_id system_id_qtr system_id_yr
		
		foreach var in bankruptcy system_exit system_split merger_of_equals target {
			replace `var' = 0 if missing(`var')
		}
		
		replace notes = "announced" in 35611
		
		save ..\to_github\strategic_ma_db_v2.dta, replace
		export delimited using ..\to_github\strategic_ma_db_v2.csv, replace
		save ..\source\strategic_ma_db_v2.dta, replace

	end
	
	
*********************************
	main
	
	
	
	
	
	
	
	
	
	
