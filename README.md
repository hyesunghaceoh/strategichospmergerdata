# Data Use Agreement

Please email [hyesung_oh@brown.edu](mailto:hyesung_oh@brown.edu) before downloading any data from this repository. When using these data, please cite:

> Oh, Hyesung, Vincent Mor, Daeho Kim, Andrew Foster, and Momotazur Rahman. *"Hospital Mergers and Acquisitions from 2010–2019: Creating a Valid Public Use Database."* Health Services Research, Volume #, No. # (2025): page#s.

---

# Description of Files (v1)

This version contains the data used to implement the analyses in Oh et al. (2025). The original dataset was constructed at the hospital/year/quarter level prior to the widespread use of generative AI tools. Post-publication, we expanded and refined the dataset to the hospital/year/month level, incorporating AI-assisted validation and corrections.

---

# Description of Files (v2)

This version provides data on hospital mergers and acquisitions from 2010–2019. Use the script `collapse_strat_to_quarter.do` to collapse the data to the hospital/year/quarter level.

To collapse to the hospital/year level, first check whether your hospitals of interest were involved in multiple deals in a single year. If so, determine which deal(s) to retain based on the purpose of your analysis.

---

# Update (as of 05/05/2025)

- Expanded quarterly dataset to hospital/year granularity  
- Validated each consolidation record using generative AI to enhance source coverage  
- Corrected and standardized the system ID variable  
- Added or revised internet-based sources for deal documentation  
- Reconciled redundant or ambiguous system ID changes
- Please see the .do file "v2_db_generation.do" for the code used to implement these enhancements

---

# Citation

> Oh, Hyesung, Vincent Mor, Daeho Kim, Andrew Foster, and Momotazur Rahman. *"Hospital Mergers and Acquisitions from 2010–2019: Creating a Valid Public Use Database."* Health Services Research, Volume #, No. # (2025): page#s.
