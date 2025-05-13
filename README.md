# Data Use Agreement

Please email [hyesung_oh@brown.edu](mailto:hyesung_oh@brown.edu) before downloading data from this repository. Please state your name, affiliation, and what you plan to use the data for. When using these data, please cite:

> Oh, H., Mor, V., Kim, D., Foster, A. and Rahman, M. (2025), Hospital Mergers and Acquisitions From 2010 to 2019: Creating a Valid Public Use Database. Health Serv Res e14642. https://doi.org/10.1111/1475-6773.14642

---

# Description of Files (v1)

**(Use v2 described below for the latest version)** v1 contains the data used to implement the analyses in Oh et al. (2025). The original dataset was constructed at the hospital/year/quarter level BEFORE the widespread use of generative AI tools. Post-publication, we expanded and refined the dataset to the hospital/year/month level, incorporating AI-assisted validation and corrections. Please read the description of v2 below.

---

# Description of Files (v2 -- post-publication improvements)

This version provides data on hospital mergers and acquisitions from 2010 to 2019. We expanded and refined the dataset to the hospital/year/month level, incorporating AI-assisted validation and corrections. ChatGPT 4o helped by disambiguating sources that were unclear in their deal descriptions. You can use the do file `collapse_strat_to_quarter.do` to collapse the data to the hospital/year/quarter level.

To collapse to the hospital/year level, first check whether your hospitals of interest were involved in multiple deals in a single year. If so, choose which deal(s) to retain based on the purpose of your analysis.

---

# Update (as of 05/12/2025)

- Expanded quarterly dataset to hospital/year granularity  
- Validated each consolidation record using generative AI to enhance source coverage  
- Corrected and standardized the system ID variable  
- Added or revised internet-based sources for deal documentation  
- Reconciled redundant or ambiguous system ID changes
- Please see the .do file `v2_db_generation.do` to view the code used to implement these enhancements

---

# Generating the `acquirer` variable
 By every system ID/time combination, generate the `max()` of the `target` variable.

---

# Citation

> Oh, H., Mor, V., Kim, D., Foster, A. and Rahman, M. (2025), Hospital Mergers and Acquisitions From 2010 to 2019: Creating a Valid Public Use Database. Health Serv Res e14642. https://doi.org/10.1111/1475-6773.14642
