Select *
From PortfolioProject..CovidDeaths
Where Continent is not Null
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we will be using

Select Location, date, total_cases,	new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where Continent is not Null
order by 1,2

-- Looking at the Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in the US

Select Location, date, total_cases, total_deaths, (Total_Deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Where Continent is not Null
order by 1,2


-- Looking at the total cases vs population

Select Location, date, total_cases,Population, (total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
order by 1,2


-- Looking at Countries with highest infection rate compared to Population

Select Location,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as 
PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Group by location, population
order by PercentPopulationInfected desc


-- Showing the Countries with the Highest Death Count per Population

-- LET'S BREAK THINGS DONE BY CONTINENT
Select CONTINENT, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Where Continent is not Null
Group by CONTINENT
order by TotalDeathCount desc





Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Where Continent is not Null
Group by location
order by TotalDeathCount desc


-- Showing the Continents with the Highest death counts (View)

Select Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Where Continent is not Null
	Group by Continent
	order by TotalDeathCount desc

-- Global Numbers

Select SUM(new_cases) as Total_New_Cases, sum(cast(new_deaths as int)) as Total_New_Deaths, SUM(cast(New_deaths as int))/Sum(New_cases)
* 100 as DeathPercentage
	From PortfolioProject..CovidDeaths
	--Where Location like '%states%'
	Where Continent is not Null
	--Group by Date
	order by 1,2

-- Global Numbers by Date

Select date, SUM(new_cases) as Total_New_Cases, sum(cast(new_deaths as int)) as Total_New_Deaths, SUM(cast(New_deaths as int))/Sum(New_cases)
* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
	--Where Location like '%states%'
Where Continent is not Null
	Group by Date
	order by 1,2

-- Looking at Total population vs Vaccinations by Location

Create View TotalPopulation_vs_VaccinationsByLocation as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--order by 2,3

Select *
From TotalPopulation_vs_VaccinationsByLocation


-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not Null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as Percentage_RollingPeopleVaccinated
From #PercentPopulationVaccinated
--Order by 2,3


--Creating a view to store data visualizations

DROP VIEW PercentPopulationVaccinated


Create View PercentPopulationVaccinated01 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--order by 2,3


Select *
From PercentPopulationVaccinated
order by 1,2
