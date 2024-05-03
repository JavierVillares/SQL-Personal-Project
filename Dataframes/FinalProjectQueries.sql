USE carbon_cycle_energy_world;

-- Growth percentage of CO2 emissions from 2015-2018 Top 5 most polluting countries
SELECT country_long,
       ((`2018` - `2015`) / `2015`) * 100 AS growth_percentage
FROM CO2_Emissions
WHERE country_long IN ('China', 'United States of America', 'Japan','India', 'European Union','World')
ORDER BY growth_percentage DESC;

SELECT country_long,
       ((`2018` - `2015`) / `2015`) * 100 AS growth_percentage
FROM CO2_Emissions
ORDER BY growth_percentage DESC;
/* 
China	3,3 % 	Total pollution growth from 2015-2018 (per capita)
USA		-1,9% 	Total pollution growth from 2015-2018 (per capita)
EU		-1.4%	Total pollution growth from 2015-2018 (per capita)
India	9,7%	Total pollution growth from 2015-2018 (per capita)
Japan	-5,9%	Total pollution growth from 2015-2018 (per capita)
*/

-- Growth rate in population 
SELECT country_long,
       ((`2018` - `2015`) / `2015`) * 100 AS growth_percentage
FROM Global_Population;


-- Comparing population growth vs CO2 emissions per capita
SELECT CO2.country_long,
       ((CO2.`2018` - CO2.`2015`) / CO2.`2015`) * 100 AS co2_growth_percentage,
       ((POP.`2018` - POP.`2015`) / POP.`2015`) * 100 AS population_growth_percentage
FROM CO2_Emissions AS CO2
JOIN Global_Population AS POP ON CO2.country_long = POP.country_long
WHERE CO2.country_long IN ('China', 'United States of America', 'Japan', 'European Union', 'India','World');
/*
China	1.67% 	Population Growth
USA		1.9%	Population Growth
EU		0.5%	Population Growth
India	3.5%	Population Growth
Japan	-0.3%	Population Decline
*/


-- Which countries have both a negative pop groth and negavtive co2 growth
SELECT country_long, co2_growth_percentage, population_growth_percentage
FROM (
    SELECT CO2.country_long,
           ((CO2.`2018` - CO2.`2015`) / CO2.`2015`) * 100 AS co2_growth_percentage,
           ((POP.`2018` - POP.`2015`) / POP.`2015`) * 100 AS population_growth_percentage
    FROM CO2_Emissions AS CO2
    JOIN Global_Population AS POP ON CO2.country_long = POP.country_long
) AS growth_rates
HAVING co2_growth_percentage < 0 AND population_growth_percentage < 0;



-- Joining CO2 emissions per fuel type and 2017 GWH produced 
CREATE OR REPLACE VIEW PowerplantCO2Emissions2017 AS
SELECT
    c.name AS powerplant_name,
    c.country_long AS country,
    c.capacity_mw,
    c.primary_fuel,
    c.`2017` AS gwh_2017,
    ROUND(c.`2017` * s.CO2e_GWh, 2) AS total_co2_emissions_2017
FROM
    2017Co2_GWH c
JOIN
    supercleaned_co2_gwh s ON c.primary_fuel = s.primary_fuel
WHERE
    c.`2017` IS NOT NULL
    AND
    s.CO2e_GWh IS NOT NULL;



-- What is the % of the top polluting countries of 2017 to world population
SELECT 
    SUM(
        CASE 
            WHEN country_long = 'European Union' THEN `2017`
            WHEN country_long = 'China' THEN `2017`
            WHEN country_long = 'India' THEN `2017`
            WHEN country_long = 'Japan' THEN `2017`
            WHEN country_long = 'United States' THEN `2017`
        END
    ) AS total_population,
    (SUM(
        CASE 
            WHEN country_long = 'European Union' THEN `2017`
            WHEN country_long = 'China' THEN `2017`
            WHEN country_long = 'India' THEN `2017`
            WHEN country_long = 'Japan' THEN `2017`
            WHEN country_long = 'United States' THEN `2017`
        END
    ) / 
    (SELECT `2017` FROM Global_Population WHERE country_long = 'World')) * 100 AS percentage_of_world_population
FROM Global_Population
WHERE country_long IN ('European Union', 'China', 'India', 'Japan', 'United States');
-- 44% of the world poulation is responsible for 76% of polution 


-- CO2 per capita of top 5 compared to the world
SELECT 
    SUM(
        CASE 
            WHEN country_long = 'China' THEN `2017`
            WHEN country_long = 'European Union' THEN `2017`
            WHEN country_long = 'United States' THEN `2017`
            WHEN country_long = 'India' THEN `2017`
            WHEN country_long = 'Japan' THEN `2017`
        END
    ) AS total_emissions,
    (SUM(
        CASE 
            WHEN country_long = 'China' THEN `2017`
            WHEN country_long = 'European Union' THEN `2017`
            WHEN country_long = 'United States' THEN `2017`
            WHEN country_long = 'India' THEN `2017`
            WHEN country_long = 'Japan' THEN `2017`
        END
    ) / 
    (SELECT `2017` FROM CO2_Emissions WHERE country_long = 'World')) * 100 AS percentage_of_world_emissions
FROM CO2_Emissions
WHERE country_long IN ('China', 'European Union', 'United States', 'India', 'Japan');
-- These top 5 countries are 5.5 times more polluting than the rest of the 56% of the world





-- Top 10 most polluting countries per capita. 
SELECT 
    max_emissions.country_long,
    max_emissions.`2015` AS max_emissions_2015,
    max_emissions.`2016` AS max_emissions_2016,
    max_emissions.`2017` AS max_emissions_2017,
    max_emissions.`2018` AS max_emissions_2018
FROM (
    SELECT 
        country_long,
        MAX(`2015`) AS `2015`,
        MAX(`2016`) AS `2016`,
        MAX(`2017`) AS `2017`,
        MAX(`2018`) AS `2018`
    FROM CO2_Emissions
    GROUP BY country_long
    ORDER BY `2015` DESC
    LIMIT 15
) AS max_emissions;
-- Qatar, Kuwait, Bahrain, United Arab Emirates, Saudi Arabia, Luxembourg, Oman, Australia, Canada



-- for potential future projects
CREATE OR REPLACE VIEW co2_emissions_powerplants AS
SELECT
    sg.primary_fuel_id,
    sg.primary_fuel,
    sg.CO2e_GWh,
    c.country_long,
    ROUND(sg.CO2e_GWh * c.`2017`, 2) AS total_CO2_emissions,
    c.`2017` AS total_generation
FROM
    supercleaned_co2_gwh AS sg
JOIN
    2017Co2_GWH c ON sg.primary_fuel = c.primary_fuel;

-- Create a view to map fuel types to categories
CREATE OR REPLACE VIEW fuel_type_categories AS
SELECT
    primary_fuel,
    CASE
        WHEN primary_fuel IN ('Coal', 'Gas', 'Oil') THEN 'Dirty'
        WHEN primary_fuel IN ('Hydro', 'Solar', 'Geothermal', 'Wind') THEN 'Green'
        WHEN primary_fuel = 'Nuclear' THEN 'Nuclear'
        WHEN primary_fuel = 'Biomass' THEN 'Biomass'
        ELSE 'Rest'
    END AS fuel_category
FROM
    co2_emissions_powerplants;

-- Create a view to calculate total power generated by each country and fuel category
CREATE OR REPLACE VIEW country_fuel_power AS
SELECT
    2017Co2_GWH.country_long,
    2017Co2_GWH.primary_fuel,
    SUM(`2017Co2_GWH`.`2017` * supercleaned_co2_gwh.CO2e_GWh) AS total_power_generated,
    2017Co2_GWH.`2017` AS total_generation
FROM
    2017Co2_GWH
JOIN
    supercleaned_co2_gwh ON 2017Co2_GWH.primary_fuel = supercleaned_co2_gwh.primary_fuel
GROUP BY
    2017Co2_GWH.country_long, 2017Co2_GWH.primary_fuel, 2017Co2_GWH.`2017`;
    
SELECT * 
FROM fuel_type_categories;