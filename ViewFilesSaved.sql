-- Creating View to Store data for later 
percentagepopulationvaccinatedcreate view percentagepopulationvaccinated as 
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location, 
death.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from coviddeaths death
join covidvaccinations vac
	on death.location = vac.location
    and death.date = vac.date
where death.continent is not null;
-- order by 2,3;


select * from percentagepopulationvaccinated
