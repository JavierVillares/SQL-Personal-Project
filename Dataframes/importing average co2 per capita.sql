2017Co2_GWHUSE carbon_cycle_energy_world;
-- Drop the table if it exists
DROP TABLE IF EXISTS CO2_Emissions;

-- Create the table
CREATE TABLE CO2_Emissions (
    country_long VARCHAR(255) PRIMARY KEY,
    `2001` FLOAT,
    `2002` FLOAT,
    `2003` FLOAT,
    `2004` FLOAT,
    `2005` FLOAT,
    `2006` FLOAT,
    `2007` FLOAT,
    `2008` FLOAT,
    `2009` FLOAT,
    `2010` FLOAT,
    `2011` FLOAT,
    `2012` FLOAT,
    `2013` FLOAT,
    `2014` FLOAT,
    `2015` FLOAT,
    `2016` FLOAT,
    `2017` FLOAT,
    `2018` FLOAT
);

select* 
from Global_Population;

select * from CO2_Emissions;

SELECT
    ((SUM(CASE 
            WHEN country_long IN ('China', 'European Union', 'India', 'United States of America', 'Japan') 
            THEN `2017` 
            ELSE 0 
        END) / 
        (SELECT SUM(`2017`) FROM CO2_Emissions WHERE country_long = 'World')) * 
        (SELECT `2017` FROM Global_Population WHERE country_long = 'World')) 
    / 
    (SELECT SUM(`2017`) FROM Global_Population WHERE country_long NOT IN ('China', 'European Union', 'India', 'United States of America', 'Japan'))
    AS percentage_of_world_emissions;


