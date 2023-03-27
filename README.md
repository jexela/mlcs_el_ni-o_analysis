<!-- Title -->
## Evolution of ENSO Precipitation Teleconnections
<!-- Description -->
This repository contains the code and data used in my Bachelor's thesis titled "Evolution of ENSO Precipitation Teleconnections: A Causal Discovery Approach". The thesis was submitted on 3rd March 2022 and was part of the Independent Research Group "Machine Learning in Climate Sciences" (MLCS) at the Excellence Cluster "Machine Learning" in Tübingen. The thesis is structured like a scientific paper and can be found at the following link: [Bachelor's Thesis PDF](https://machineclimate.de/files/bachelors_thesis_onken_alexej.pdf)

<!-- Badges -->
License: MIT

<!-- Table of Contents -->
## Table of Contents
Abstract
Conclusion
Dependencies
License
<!-- Abstract -->
## Abstract
The El Niño Southern Oscillation (ENSO) is a paramount climate phenomenon affecting global precipitation patterns due to aperiodic changes in ocean currents and sea surface temperatures (SSTs) in the equatorial Pacific Ocean. To scrutinize the global impact of ENSO on rainfall and establish cause-effect relationships, we employ the PCMCI+CEN causal discovery approach alongside standard correlation analysis. By disentangling confounding effects of different Niño regions, we discern causal relationships with lags up to 12 months, elucidating the distinct impacts of individual Niño regions. Additionally, we investigate trends in spatial correlation fields between the Oceanic Niño Index (ONI) and global precipitation anomalies. Our findings reveal that although various El Niño SST indices exhibit strong intercorrelations, regions manifesting unique ENSO event characteristics can be identified. The study's outcomes contribute to understanding driving forces as univariate time series affecting regional climates and evaluating the role of anthropogenic climate change in global teleconnections' alterations over recent years or decades. The analysis also highlights the importance of considering ENSO diversity for improved precipitation forecasts and better understanding of regional climate impacts.

<!-- Conclusion -->
## Conclusion
Our analysis uncovers teleconnection patterns for rainfall and drought across different Niño regions, comparing them to the current knowledge of ENSO, and identifying the evolution of ENSO-specific precipitation patterns. By employing correlation analysis and the PCMCI+CEN approach, we detect stable and less stable regions, as well as comparing the predictive power of distinct Niño regions. The most stable regions include the Maritime Continent & Southwest Pacific and the Central Pacific in the tropics. Furthermore, we observe a decreasing trend in significant ENSO anticorrelation areas, particularly in the Maritime Continent & Southwest Pacific region. PCMCI+CEN results may enhance the comprehension of causal relationships between SST values in the Central Pacific and global precipitation anomalies, especially concerning ENSO diversity. Further research should explore the causal links between Niño regions and areas affected by teleconnections to improve precipitation or drought forecasts during ENSO and better grasp the influence of anthropogenic climate change on the dynamics of ENSO teleconnections.

<!-- Dependencies -->
## Dependencies
The following Python libraries are required:

netCDF4
numpy
pandas
matplotlib
mpl_toolkits.basemap
scipy
sklearn
tigramite
Additionally, Relational Database Management System (RMBDS) PostgreSQL is used in this project.

The repository also includes PDF plots, which are free to use.

<!-- License -->
## License
This project is licensed under the MIT License - see the LICENSE file for details.

The MIT License is a permissive free software license that allows for reuse within proprietary software, provided that all copies of the licensed software include a copy of the MIT License terms. It is widely used and is recognized as a standard license for open-source software.
