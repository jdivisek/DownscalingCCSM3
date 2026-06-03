# Downscaling CCSM3 simulations

Here, I provide R codes for downscaling and debiasing CCSM3 simulations of monthly minimum, mean and maximum temperatures and precipitation amounts for centennial windows up to 21,000 BP. These downscaled simulations were then used to calculate BIOCLIM (Nix, 1986) and ENVIREM (Title & Bemmels, 2018) variables for each window. These grids are provided [here](https://zenodo.org/records/5119958).

Gridded paleoclimate simulations at a resolution of 2.5° used here come from TraCE-21ka experiment, which uses Community Climate System Model version 3 (CCSM3; Collins et al., 2006); a global coupled atmosphere–ocean–sea ice–land general circulation model. The data were accessed through the [PaleoView](https://github.com/GlobalEcologyLab/PaleoView) software version 1.5.1 (Fordham et al., 2017). The data cover European continent and adjacent regions within the following boundaries: 32.5°W–70°E and 32.5°N–82.5°N. The centennial (100-yrs) windows are centered on calendar centuries, with the most recent window, 100–0 BP, corresponding to 1850–1950 CE and centered on 50 BP, i.e. 1900 CE.

Baseline climate data used for downscaling and debiasing CCSM3 simulations come from CHELSA timeseries and CHELSAcruts datasets (Karger et al., 2017), which were used to calculate 50-yrs average for the period from 1940 to 1989 CE.

Downscaling procedure uses the change-factor approach (Ramirez Villejas and Jarvis, 2010) and the resulting grids are at a spatial resolution of 30 arc-seconds (\~1km). BIOCLIM variables were calculated using Bioclimatic Variables tool in [SAGA](https://saga-gis.sourceforge.io/en/index.html) 6.3.0 and ENVIREM variables using custom functions (based on RSAGA package) provided here.

**References**

-   Fordham, D.A., Saltré, F., Haythorne, S., Wigley, T.M.L., Otto‐Bliesner, B.L., Chan, K.C. & Brook, B.W. (2017) PaleoView: a tool for generating continuous climate projections spanning the last 21 000 years at regional and global scales. *Ecography*, 40, 1348–1358.

-   Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E., Linder, H.P. & Kessler, M. (2017) Climatologies at high resolution for the earth’s land surface areas. *Scientific Data*, 4, 170122.

-   Nix, H.A. (1986) A Biogeographic Analysis of Australian Elapid Snakes. *Atlas of Elapid Snakes of Australia Australian Flora and Fauna* Series 7., pp. 4–15. Australian Government Publishing Service, Canberra.

-   Ramirez Villejas, J. & Jarvis, A. (2010) Downscaling Global Circulation Model Outputs: The Delta Method Decision and Policy Analysis Working Paper No. 1. International Center for Tropical Agriculture (CIAT). Cali. CO.

-   Title, P.O. & Bemmels, J.B. (2018) ENVIREM: an expanded set of bioclimatic and topographic variables increases flexibility and improves performance of ecological niche modeling. *Ecography*, 41, 291–307.
