-- Perbaiki Data yang tipenya tidak sesuai 

DESCRIBE coviddeaths;

ALTER TABLE coviddeaths
MODIFY COLUMN total_cases DOUBLE,
MODIFY COLUMN new_cases DOUBLE,
MODIFY COLUMN new_cases_per_million DOUBLE,
MODIFY COLUMN stringency_index DOUBLE,
MODIFY column population double,
MODIFY COLUMN population_density DOUBLE,
MODIFY COLUMN median_age DOUBLE,
MODIFY COLUMN aged_65_older DOUBLE,
MODIFY COLUMN aged_70_older DOUBLE,
MODIFY COLUMN gdp_per_capita DOUBLE,
MODIFY COLUMN extreme_poverty DOUBLE,
MODIFY COLUMN cardiovasc_death_rate DOUBLE,
MODIFY COLUMN diabetes_prevalence DOUBLE,
MODIFY COLUMN handwashing_facilities DOUBLE,
MODIFY COLUMN hospital_beds_per_thousand DOUBLE,
MODIFY COLUMN life_expectancy DOUBLE,
MODIFY COLUMN human_development_index DOUBLE;

-- Hasilnya sudah sesuai 
DESCRIBE coviddeaths;

