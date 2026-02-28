-- LOAD MANUAL FILE CSV COVIDDEATHS

CREATE TABLE CovidDeaths(
	continent VARCHAR(100),
    location VARCHAR(100),
    date DATE,
    population DOUBLE,
    total_cases DOUBLE,
    new_cases DOUBLE,
    total_deaths DOUBLE,
    new_deaths DOUBLE,
    reproduction_rate DOUBLE,
	stringency_index DOUBLE
);
SET GLOBAL local_infile='ON';

LOAD DATA LOCAL INFILE 'D:/Dokumen Kuliah/Pemrograman di luar pembelajaran/Data Analyst/Corono-Virus Project/RealFileFromGithub/CovidDeaths.csv'
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;