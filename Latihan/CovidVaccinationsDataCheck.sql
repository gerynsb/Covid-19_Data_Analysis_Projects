-- Cek tipe data apakah sudah sesuai 

DESCRIBE covidvaccinations;

SHOW VARIABLES LIKE "secure_file_priv";
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/Dokumen Kuliah/Data Analyst/Corono-Virus Project/RealFileFromGithub/CovidVaccinations.csv'
INTO TABLE covidvaccinations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;

UPDATE covidvaccinations 
SET date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE date LIKE '%/%/%';

-- 1. Hapus tabel lama
DROP TABLE IF EXISTS covidvaccinations;

-- 2. Buat tabel baru dengan tipe TEXT semua agar data "mentah" bisa masuk
CREATE TABLE covidvaccinations (
    iso_code TEXT, continent TEXT, location TEXT, date TEXT,
    new_tests DOUBLE, total_tests double, total_tests_per_thousand double,
    new_tests_per_thousand double, new_tests_smoothed double,
    new_tests_smoothed_per_thousand double, positive_rate double,
    tests_per_case double, tests_units TEXT, total_vaccinations double,
    people_vaccinated double, people_fully_vaccinated double,
    new_vaccinations double, new_vaccinations_smoothed double,
    total_vaccinations_per_hundred double, people_vaccinated_per_hundred double,
    people_fully_vaccinated_per_hundred double, new_vaccinations_smoothed_per_million double,
    stringency_index double, population_density double, median_age double,
    aged_65_older double, aged_70_older double, gdp_per_capita double,
    extreme_poverty double, cardiovasc_death_rate double, diabetes_prevalence double,
    female_smokers double, male_smokers double, handwashing_facilities double,
    hospital_beds_per_thousand double, life_expectancy double, human_development_index double
);

-- 3. Load data kembali
LOAD DATA LOCAL INFILE 'D:/Dokumen Kuliah/Data Analyst/Corono-Virus Project/RealFileFromGithub/CovidVaccinations.csv'
INTO TABLE covidvaccinations
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT location, LENGTH(location) 
FROM covidvaccinations 
WHERE iso_code = 'CAN' 
LIMIT 1;

-- Bersihkan data dengan spasi dan kurang baik 
SET SQL_SAFE_UPDATES = 0;

-- Menghapus spasi di depan dan belakang pada kolom-kolom utama
UPDATE covidvaccinations 
SET location = TRIM(location),
    continent = TRIM(continent),
    iso_code = TRIM(iso_code);

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

-- Membersihkan Enter (\r), Baris Baru (\n), dan Tab (\t) sekaligus
UPDATE covidvaccinations 
SET location = TRIM(REPLACE(REPLACE(REPLACE(location, '\r', ''), '\n', ''), '\t', '')),
    continent = TRIM(REPLACE(REPLACE(REPLACE(continent, '\r', ''), '\n', ''), '\t', '')),
    iso_code = TRIM(REPLACE(REPLACE(REPLACE(iso_code, '\r', ''), '\n', ''), '\t', ''));

SET SQL_SAFE_UPDATES = 1;

SELECT location, LENGTH(location) as jumlah_karakter
FROM covidvaccinations 
WHERE location LIKE '%Canada%'
LIMIT 5;
