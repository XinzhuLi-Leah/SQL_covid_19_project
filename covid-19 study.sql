-- looking at total cases vs total deaths 总感染人数中的死亡率
-- shows likelihood of dying if you get covid in your country 如果你得了新冠 你的死亡率是多大
select location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100,2) as death_percentage
from covid_19.CovidDeaths
where location like '%china%'
order by date 

-- looking at total cases vs populaition 总国民人数的感染率
-- shows what percent of population got Covid 在你的国家你有多大几率被感染
select location, date, total_cases, population, round((total_cases/population) * 100,2) as   percentage_population_infected
from covid_19.CovidDeaths
where location like '%china%'
order by date 

select location, date, total_cases, population, round((total_cases/population) * 100,2) as   percentage_population_infected
from covid_19.CovidDeaths
where location like '%states%'
order by date 

-- looking at countires with highest infection rate  compared to population.  最高峰国家感染占比
-- need to aggregate because of max
select 
			location, 
			population,
			max(total_cases) as highest_cases,
			max(round((total_cases/population) * 100,4)) as  highest_percentage_population_infected
	from covid_19.CovidDeaths
	group by location, population
	order by highest_percentage_population_infected desc
    
    
-- looking at countires from the point of infection_rate along with time    最高峰国家感染占比随时间变换
-- no need to aggregate just calculating the daily infec_rate
select 
    location,
    date,
    round((total_cases/population), 6) as infection_rate
from covid_19.CovidDeaths
where continent is not null
order by location,date


-- showing the countires with highest death rate compared to population.   最高峰国家死亡占比
select 
		location, 
		population,
		max(total_deaths) as highest_deaths,
		max(round((total_deaths/population) * 100,2)) as highest_percentage_population_dead
from covid_19.CovidDeaths
group by location, population
order by highest_percentage_population_dead desc

-- showing the countires with highest deaths count       死亡人数绝对值
select location ,max(total_deaths) as highest_deaths_count
from covid_19.CovidDeaths
where continent is not null
group by location
order by highest_deaths_count desc

-- let us break things down by continent
-- showing us the highest deaths count per continent 
select location,max(total_deaths) as highest_deaths_count_continent
from covid_19.CovidDeaths
where continent is null and location not in('European Union','world','international')
group by location
order by highest_deaths_count_continent desc

-- global numbers
-- total  daily new cases and new deaths in the world    每日全球新增病例 每日全球新增死亡
select date, sum(new_cases) as total_newcases_global, sum(new_deaths) as total_newdeaths_global
from covid_19.CovidDeaths
where continent is not null
group by date
order by date

-- total numebrs in the world
select max(total_cases) as world_cases,max(total_deaths) as world_deaths,max(total_deaths)/max(total_cases) as world_death_rate
from covid_19.CovidDeaths
where location like '%world%'




