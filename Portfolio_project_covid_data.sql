create database portfolio_project_covid_data;
use portfolio_project_covid_data;
select* from coviddeaths;
select* from covidvaccinations;

 select location, date, total_cases, total_deaths
 from coviddeaths;
 
 -- Total Cases vs Total Deaths
  select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
 from coviddeaths
 where location like '%India%'
 order by death_percentage desc ;
 
 -- Total Cases vs Population 
select location, date, total_cases, population, (total_cases/population)*100 as infected_population_percentage
 from coviddeaths
 where location like '%India%'
 order by infected_population_percentage desc ;
 
 -- Countries with highest infection rate compared to population 
 select location, max(total_cases) as Highest_infection_count, population, max((total_cases/population))*100 as infected_population_percentage
 from coviddeaths
  where continent is not null 
 group by location, population
 order by 1,2 ;
 
 -- Countries with highest death count as per population 
 select location, max(total_deaths) as Highest_death_count, population, max((total_deaths/population))*100 as deceased_population_percentage
 from coviddeaths
 where continent is not null 
 group by location, population
 order by 2,1 ;
 
 --  Breaking down by continent 
 -- Highest death count per population 
select continent,  max(total_deaths ) as Highest_death_count
 from coviddeaths
 where continent is not null 
 group by continent;
 
 -- Global Numbers 
 select date, sum(new_cases) as Total_new_cases, sum(new_deaths) as Total_new_deaths, (sum(new_deaths)/ sum(new_cases)*100) as Death_percentage
 from coviddeaths
 where continent is not null 
 group by date 
 order by Death_percentage desc;
 
 -- Total population vs vaccination 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over ( partition by dea.location 
									order by dea.location, dea.date ) as People_vaccinationed_continious
 from coviddeaths dea 
 join covidvaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
where dea.continent is not null 
order by 2,3 ;

-- Using CTE 

With popvsvac (continent, location, date, population, new_vaccinations, people_vaccinated_continious)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over ( partition by dea.location 
									order by dea.location, dea.date ) as People_vaccinationed_continious
 from coviddeaths dea 
 join covidvaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
where dea.continent is not null 
)
select*, (people_vaccinated_continious/population)*100 as  percentpopulationvaccinated 
from popvsvac ;

-- Creating view to store data for later visualisation 

Create View  percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over ( partition by dea.location 
									order by dea.location, dea.date ) as People_vaccinationed_continious
 from coviddeaths dea 
 join covidvaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
where dea.continent is not null; 


 
 

