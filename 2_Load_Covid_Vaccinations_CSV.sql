DROP TABLE IF EXISTS CovidVaccinations;

CREATE TABLE CovidVaccinations (
    continent VARCHAR(50),
    location VARCHAR(100),
    date DATE,
    population BIGINT,
    new_vaccinations DOUBLE,
    people_fully_vaccinated_per_hundred DOUBLE,
    gdp_per_capita DOUBLE,
    hospital_beds_per_thousand DOUBLE,
    median_age DOUBLE,
    diabetes_prevalence DOUBLE
);

LOAD DATA LOCAL INFILE 'D:/Dokumen Kuliah/Pemrograman di luar pembelajaran/Data Analyst/Corono-Virus Project/RealFileFromGithub/CovidVaccinations.csv' 
INTO TABLE CovidVaccinations 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;