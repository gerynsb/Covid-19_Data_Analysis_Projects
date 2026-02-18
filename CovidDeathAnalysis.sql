-- TAHAPAN EKSPLORASI DATA
-- 1. Cek Apakah Table sudah Terload
SHOW TABLES;

-- SELECT * FROM coviddeaths ORDER BY 3,4; -- urutkan berdasarkan kolom diurutkan dari kolom ke-3 lalu ke-4
-- SELECT * FROM covidvaccinations ORDER BY 3,4;

-- Memilih data yang akan digunakan 
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
order by 1,2;

-- Melihat negara - negara unik atau lokasi yang ada
SELECT DISTINCT Location
FROM coviddeaths
ORDER BY Location;

-- Melihat total cases vs total death (berapa total case dalam negara dan total deathnya)
-- Melihat persentase kemungkinan kematian pada suatu negara 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE Location LIKE '%Algeria%' AND total_cases > 0 AND total_deaths > 0
order by 1,2;

-- Melihat Total Cases vs Total Deaths 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE Location LIKE '%Indonesia%' AND total_cases > 0 AND total_deaths > 0
order by 1,2;

-- Melihat Total Cases vs Population
-- Melihat berapa persentase dari populasi yang terkena covid
SELECT Location, date, population, total_cases, (total_cases/population)	*100 as PopulationPercentage
FROM coviddeaths
WHERE Location LIKE '%Indonesia%' AND total_cases > 0 AND total_deaths > 0
order by 1,2;

-- cek persentase kematian berdasarkan continent
SELECT continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE total_cases > 0 AND total_deaths > 0 AND continent is not null
GROUP BY continent, date, total_cases, total_deaths, DeathPercentage
order by 1,2;

-- Melihat negara dengan infection rate tertinggi dan dibandingkan dengan populasinya
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PopulationInfectedPercentage
FROM coviddeaths GROUP BY location,population order by PopulationInfectedPercentage desc;



-- Memperlihatkan negara dengan Death Count paling tertinggi berdasarkan populasi
-- Mengubah data tipe langsung cast(kolom as int)
SELECT Location,  MAX(total_deaths) as totaldeathscount
FROM coviddeaths 
where continent is not null
GROUP BY location
order by totaldeathscount desc;

-- LET'S BREAK DOWN BY CONTINENT

-- Showing continents with the highest death count per population
SELECT continent,  MAX(total_deaths) as totaldeathscount
FROM coviddeaths 
where continent is not null
GROUP BY continent
order by totaldeathscount ;

-- GLOBAL NUMBERS
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
FROM coviddeaths 
WHERE continent is not null
GROUP BY date 
order by 1,2;

-- Total cases Global 
SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
FROM coviddeaths 
WHERE continent is not null
-- GROUP BY date 
order by 1,2;
