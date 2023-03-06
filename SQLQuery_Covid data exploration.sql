--selecting the database
use portfolio_v2;


-- Selecting the data
--select * from dbo.CovidDeaths;
Select location,date, population, total_cases,new_cases, total_deaths
from dbo.CovidDeaths
order by 1,2

--Calculating the death percentage


Select location,date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from dbo.CovidDeaths
--where location like '%ndia'         -- use this if want for particular location
order by 1,2

-- Calculating the infected population percentage

Select location,date, population, total_cases, (total_cases/population)*100 as PercentageInfectedPopulation
from dbo.CovidDeaths
where location like '%ndia'         -- use this if want for particular location
order by 1,2

--Top 10 location that have highest infection percentage

Select top 10 location, population, max(total_cases), max((total_cases/population))*100 as PercentageInfectedPopulation
from dbo.CovidDeaths

group by location, population       -- use this if want for particular location
order by 4 desc



-- location that have highest death count and  percentage by population

Select top 10 location, population, max(total_deaths), max((total_deaths/population))*100 as PercentagedeathPopulation
from dbo.CovidDeaths

group by location, population       -- use this if want for particular location
order by 4 desc


-- Death count by continents

Select continent, max(total_deaths) as total_deaths
from dbo.coviddeaths
where continent is not NULL
group by continent
order by total_deaths desc


-- GLOBAL NUMBERS by DATE

Select date,sum(total_cases) as total_cases, sum(total_deaths) as total_deaths, (sum(total_deaths)/sum(total_cases)) *100 as percentage_death
from dbo.CovidDeaths
where continent is not null
group by date
order by date asc;



-- Total Wordwide cases


Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases)) *100 as percentage_death
from dbo.CovidDeaths
where continent is not null;



-- VACCINATION STATUSES

-- Total vaccination by population

select * from dbo.covidvaccinaion;   -- table with vaccination info
 
 --- New vaccination everyday and total rolling sum of vaccination by country


select continent, location, date, population,new_vaccinations,
sum(new_vaccinations) over(partition by location order by location, date) as rolling_vaccinationsum
from dbo.covidvaccinaion
where continent is not NULL
order by 2,3


 --- New vaccination everyday and total rolling sum of vaccination for India

select  location, date, population ,new_vaccinations,
sum(new_vaccinations) over(partition by location order by date )
from dbo.covidvaccinaion
where location = 'India'
order by 2



--Using CTE to find total vaccination per population


with temp_table (continent,location,date,population,new_vacciantion,rolling_vaccinationsum)
as
(
select continent, location, date, population,new_vaccinations,
sum(new_vaccinations) over(partition by location order by location, date) as rolling_vaccinationsum
from portfolio_v2.dbo.covidvaccinaion
where continent is not NULL
)
select *,(rolling_vaccinationsum/population)*100
from temp_table