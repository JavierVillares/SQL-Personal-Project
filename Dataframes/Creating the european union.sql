

SELECT *
FROM 2017Co2_GWH;

SELECT * 
FROM CO2_Emissions;

SELECT * 
FROM Global_Population;

SELECT *
FROM supercleaned_co2_gwh;

SET SQL_SAFE_UPDATES = 0;

UPDATE 2017Co2_GWH
SET country_long = 'European Union'
WHERE country_long IN ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czech Republic', 
                       'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 
                       'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Netherlands', 'Poland', 
                       'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden');
SET SQL_SAFE_UPDATES = 1;

