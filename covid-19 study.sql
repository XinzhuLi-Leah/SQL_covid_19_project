-- select data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from covid_19.CovidDeaths
where continent is not null
order by location, dateCovidDeaths

-- looking at total cases vs total deaths
-- shows likelihood of dying if you get covid in your country

select location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100,2) as death_percentage
from covid_19.CovidDeaths
where location like '%china%'
order by date 

-- looking at total cases vs populaition
-- shows what % of population got Covid
select location, date, total_cases, population, round((total_cases/population) * 100,2) as  percentage_population_infencted
from covid_19.CovidDeaths
where location like '%china%'
order by date 

select location, date, total_cases, population, round((total_cases/population) * 100,2) as   percentage_population_infencted
from covid_19.CovidDeaths
where location like '%states%'
order by date 

-- looking at countires with highest infection rate  compared to population
select 
		location, 
		population,
		max(total_cases) as highest_cases,
		max(round((total_cases/population) * 100,2)) as  highest_percentage_population_infencted
from covid_19.CovidDeaths
group by location, population
order by highest_percentage_population_infencted desc

-- showing the countires with highest death rate compared to population
select 
		location, 
		population,
		max(total_deaths) as highest_deaths,
		max(round((total_deaths/population) * 100,2)) as highest_percentage_population_dead
from covid_19.CovidDeaths
group by location, population
order by highest_percentage_population_dead desc

-- showing the countires with highest deaths count 
select location ,max(total_deaths) as highest_deaths_count
from covid_19.CovidDeaths
where continent is not null
group by location
order by highest_deaths_count desc

-- let us break things down by continent
-- showing us the highest deaths count per continent 
select location,max(total_deaths) as highest_deaths_count_continent
from covid_19.CovidDeaths
where continent is null
group by location
order by highest_deaths_count_continent desc

-- global nubers
-- total  daily new cases and new deaths in the world
select date, sum(new_cases) as total_newcases_global, sum(new_deaths) as total_newdeaths_global
from covid_19.CovidDeaths
where continent is not null
group by date
order by date

-- total numebrs in the world
select max(total_cases),max(total_deaths)
from covid_19.CovidDeaths
where location like '%world%'


-- looking at dalily new vaccinations
select *,  round(rolling_people_vaccinated/population ,4) as rolling_vaccination_rate
from
(select  
		dea.continent, 
		dea.location, 
		dea.date,
		dea.population,
		vac.new_vaccinations,
        sum(vac.new_vaccinations) over(partition by dea.location order by dea.date) as rolling_people_vaccinated
from covid_19.CovidDeaths as dea
join covid_19.CovidVaccinations as vac
on dea.date = vac.date and dea.location =vac.location
where dea.continent is not null
order by dea.location, dea.date)
as tmp1


-- creating views to store data for later visualizations
rolling_population_vaccinatedcreate  view rolling_population_vaccinated as
select  
		dea.continent, 
		dea.location, 
		dea.date,
		dea.population,
		vac.new_vaccinations,
        sum(vac.new_vaccinations) over(partition by dea.location order by dea.date) as rolling_people_vaccinated
from covid_19.CovidDeaths as dea
join covid_19.CovidVaccinations as vac
on dea.date = vac.date and dea.location =vac.location
where dea.continent is not null
order by dea.location, dea.date

-- fetch things from views
SELECT * FROM covid_19.rolling_population_vaccinated;





