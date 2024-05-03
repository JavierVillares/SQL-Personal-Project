USE carbon_cycle_energy_world;

-- SQL statements to create tables and insert data


CREATE DATABASE IF NOT EXISTS carbon_cycle_energy_world;
USE carbon_cycle_energy_world;

DROP TABLE IF EXISTS average_Mt_CO2_emisions_of_by_country_per_capita;
CREATE TABLE average_Mt_CO2_emisions_of_by_country_per_capita;

DROP TABLE IF EXISTS supercleaned_co2_gwh;
CREATE TABLE supercleaned_co2_gwh ;



-- Drop the table if it exists
DROP TABLE IF EXISTS 2017Co2_Emissions_cleaned;

-- Create the table
CREATE TABLE 2017Co2_Emissions_cleaned (
    country_long VARCHAR(255) ,
    name VARCHAR(255 ),
    capacity_mw FLOAT,
    primary_fuel VARCHAR(255),
    `2017` FLOAT
);

SELECT *
FROM 2017Co2_Emissions_cleaned;


DROP TABLE IF EXISTS Global_Population;
CREATE TABLE Global_Population (
    country_long VARCHAR(255) PRIMARY KEY,
	`2015` FLOAT,
    `2016` FLOAT,
    `2017` FLOAT,
    `2018` FLOAT,
    `2019` FLOAT,
    `2020` FLOAT,
    `2021` FLOAT,
    `2022` FLOAT
);

SELECT * 
FROM Global_Population;

