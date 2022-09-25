

Select* 
From [portfolio project]..CovidDeaths
order by 3,4


--Select* 
--From [portfolio project]..CovidVaccinations
--order by 3,4

--select data that we are going to using

Select Location, Date, total_cases, new_cases, total_deaths, population 
From [portfolio project]..CovidDeaths
order by 1,2

--looking at the total cases vs deaths
--shows the liklihood of dying if you contract covid in your country

Select Location, Date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercantage 
From [portfolio project]..CovidDeaths
Where location like '%states%'
order by 1,2

--looking at the total cases vs population

Select Location, Date, population, total_cases, total_deaths,(total_cases/population)*100 as PercentPopulationInfected 
From [portfolio project]..CovidDeaths
--Where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population

--3

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

-- showing countries with the highest death count per population


Select Location, SUM(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- lets break things down by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--showing continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- global numbers

--1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Deathpercantage
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group By Date 
order by 1,2 



-- looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
order by 2,3

-- use cte

With PopvsVac (Continent, Location, DAte, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
--order by 2,3




--4

Select Location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Group by location, population, date
order by PercentPopulationInfected desc

--2

Select Location, SUM(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--3

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc





