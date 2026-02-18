-- COVID VACCINATION 
select * from covidvaccinations;
select location from covidvaccinations;
SELECT COUNT(location) FROM covidvaccinations;

SELECT DISTINCT location 
FROM covidvaccinations 
ORDER BY location;

SELECT * FROM covidvaccinations 
WHERE location LIKE '%Canada%' 
   OR continent LIKE '%Canada%' 
   OR iso_code LIKE '%Canada%';

-- Melihat total populasi vs vaccination
SELECT * 
from coviddeaths death
join covidvaccinations vac
	on death.location = vac.location
    and death.date = vac.date;
    
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
from coviddeaths death
join covidvaccinations vac
	on death.location = vac.location
    and death.date = vac.date
where death.continent is not null
order by 2,3 desc
limit 20000;

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location, 
death.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from coviddeaths death
join covidvaccinations vac
	on death.location = vac.location
    and death.date = vac.date
where death.continent is not null
order by 2,3;

-- Karena table yang kita buat tidak dipakai bisa menggunakan CTE 
With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location, 
death.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from coviddeaths death
join covidvaccinations vac
	on death.location = vac.location
    and death.date = vac.date
where death.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


-- TEMP TABLE 


-- 1. Hapus tabel dulu jika sudah ada (biar tidak error saat run ulang)
DROP TEMPORARY TABLE IF EXISTS percentpopulationvaccinated;

-- 2. Buat Tabel Sementara (Tanpa tanda #, dan nama kolom disambung)
CREATE TEMPORARY TABLE percentpopulationvaccinated (
    continent text,
    location text,
    date text,           -- Gunakan text dulu agar aman, atau datetime jika data sudah bersih
    population double,
    new_vaccinations double,
    RollingPeopleVaccinated double -- Spasi dihapus
);

-- 3. Masukkan Data (INSERT)
INSERT INTO percentpopulationvaccinated
SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vac.new_vaccinations, 
    SUM(vac.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.date) as RollingPeopleVaccinated
FROM coviddeaths death 
JOIN covidvaccinations vac 
    ON death.location = vac.location 
    AND death.date = vac.date
WHERE death.continent IS NOT NULL;

-- 4. Tampilkan Hasil
SELECT *, (RollingPeopleVaccinated/population)*100 as Percentage
FROM percentpopulationvaccinated;


