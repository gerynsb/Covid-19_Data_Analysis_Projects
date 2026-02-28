/*
=========================================================
Kumpulan Query untuk Project Tableau (Versi MySQL)
=========================================================
*/

-- 1. Global Numbers (Kasus dan Kematian Global)
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, 
    SUM(CAST(new_deaths AS DECIMAL)) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM Portfolio_Project.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 1, 2;


-- 2. Total Kematian Berdasarkan Benua
SELECT 
    continent, 
    SUM(CAST(new_deaths AS SIGNED)) AS TotalDeathCount
FROM Portfolio_Project.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- 3. Persentase Populasi Terinfeksi (Tertinggi per Negara)
SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 1.0 / population)) * 100 AS PercentPopulationInfected
FROM Portfolio_Project.CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;


-- 4. Persentase Populasi Terinfeksi Berdasarkan Tanggal (Time Series)
SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 1.0 / population)) * 100 AS PercentPopulationInfected
FROM Portfolio_Project.CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;


/*
=========================================================
Query Ekstra (Untuk eksplorasi lanjutan)
=========================================================
*/

-- (Opsional) Menampilkan Total Kasus dan Kematian beserta Populasi
SELECT 
    Location, 
    date, 
    population, 
    total_cases, 
    total_deaths
FROM Portfolio_Project.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 1, 2;


-- 5. CTE: Persentase Populasi yang Divaksinasi (Rolling Vaccinations)
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM Portfolio_Project.CovidDeaths dea
    JOIN Portfolio_Project.CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL AND dea.continent != ''
)
SELECT 
    *, 
    (RollingPeopleVaccinated * 1.0 / Population) * 100 AS PercentPeopleVaccinated
FROM PopvsVac;


-- 6. Infrastruktur Ekonomi vs Tingkat Kematian 
SELECT dea.location, 
	MAX(vac.gdp_per_capita) AS gdp_per_capita, 
    MAX(vac.hospital_beds_per_thousand) AS hospital_beds_per_thousand,
    (MAX(dea.total_deaths)/ MAX(dea.population)) * 1000000 AS total_deaths_per_million
FROM Portfolio_Project.CovidDeaths dea
JOIN portfolio_project.CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
GROUP BY dea.location
ORDER BY gdp_per_capita DESC;

-- 7 Kerentanan Demografis 
SELECT dea.location,
	MAX(vac.median_age) AS median_age,
    MAX(vac.diabetes_prevalence) AS diabetes_prevalence,
    (MAX(dea.total_deaths)/ MAX(dea.population)) * 100 AS PercentPopulationDied
FROM Portfolio_Project.CovidDeaths dea
JOIN Portfolio_Project.CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
GROUP BY dea.location
ORDER BY PercentPopulationDied DESC;

-- 8. Lockdown & Infection Rate
SELECT 
    location,
    date,
    stringency_index,
    reproduction_rate,
    new_cases
FROM Portfolio_Project.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
AND stringency_index > 0 
ORDER BY location, date;

-- 9. Timeline Dampak Vaksinasi terhadap kematian 
SELECT 
    dea.location,
    dea.date,
    vac.people_fully_vaccinated_per_hundred,
    dea.new_deaths
FROM Portfolio_Project.CovidDeaths dea
JOIN Portfolio_Project.CovidVaccinations vac
    ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
ORDER BY dea.location, dea.date;