--select *
--from PortfolioProject..CovidDeaths
--order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

 
 select location, date, total_cases, new_cases, total_deaths, population
 from PortfolioProject..CovidDeaths
 order by 1,2

 -- Death percentages (2020-2021)
 select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentages
 from PortfolioProject..CovidDeaths
-- where location= 'Greece'
 where continent is not null
 order by 1,2

-- Total cases vs population in 2020-2021
select location, date, population, total_cases, (total_cases/population)* 100 as CovidCasesPercentages
 from PortfolioProject..CovidDeaths
 --where location= 'Greece'
 order by 1,2

 -- Most affected countries by Covid in 2020-2021
 select location, population, max(total_cases) as Total_Cases, max((total_cases/population))*100 as Cases_in_Percentages
  from PortfolioProject..CovidDeaths
   where continent is not null
  group by location, population
  order by Cases_in_Percentages desc

-- Covid Deaths by continent 2020-2021
select continent, max(cast(total_deaths as int)) as TotalDeathcount
  from PortfolioProject..CovidDeaths
  where continent is not null
  group by continent 
  order by TotalDeathcount desc

  -- Covid Deaths by country 2020-2021
  select location, max(cast(total_deaths as int)) as TotalDeathcount
  from PortfolioProject..CovidDeaths
  where continent is not null
  group by location
  order by TotalDeathcount desc

  -- Global numbers 
select sum(new_cases) as global_cases, sum(cast(new_deaths as int)) as global_deaths, sum(cast(new_deaths as int))/ 
sum(new_cases)*100 as DeathPerchentage
from PortfolioProject..CovidDeaths
order by 1, 2
 
 -- Number of people who got vaccinated 2020-2021
 select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
 from PortfolioProject..CovidDeaths death
 join PortfolioProject..CovidVaccinations vaccin
 on death.location=vaccin.location
 and death.date=vaccin.date
 where death.continent is not null
 order by 2,3 desc

 -- Total vaccinations per continent 2020-2021
 select continent, max(cast(total_vaccinations as int)) as TotalVaccinations
  from PortfolioProject..CovidVaccinations
  where continent is not null
  group by continent 
  order by TotalVaccinations desc

 -- Total Numbers of people who got vaccinated daily around the world
 select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
 , sum(convert(int, vaccin.new_vaccinations)) over (partition by death.location order by death.location, death.date) as VaccinationsperLocation
 from PortfolioProject..CovidDeaths death
 join PortfolioProject..CovidVaccinations vaccin
 on death.location=vaccin.location
 and death.date=vaccin.date
 where death.continent is not null
  order by 2,3 



  -- CTE

  With TotvsVac (Continent, location, date, population, new_vaccinations, VaccinationsperLocation)
  as
 (select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
 , sum(convert(int, vaccin.new_vaccinations)) over (partition by death.location order by death.location, death.date) as VaccinationsperLocation
 from PortfolioProject..CovidDeaths death
 join PortfolioProject..CovidVaccinations vaccin
 on death.location=vaccin.location
 and death.date=vaccin.date
 where death.continent is not null )
 SELECT * , (VaccinationsperLocation/population)*100
 FROM TotvsVac 


 -- Temp Table

 DROP TABLE if exists #VaccinatedPopulationPercentages
 Create Table #VaccinatedPopulationPercentages
(Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric, 
 New_vaccinations numeric,
 VaccinatedPopulationPercentages numeric)


 Insert into #VaccinatedPopulationPercentages
 select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
 , sum(convert(int, vaccin.new_vaccinations)) over (partition by death.location order by death.location, death.date) as VaccinationsperLocation
 from PortfolioProject..CovidDeaths death
 join PortfolioProject..CovidVaccinations vaccin
 on death.location=vaccin.location
 and death.date=vaccin.date
 where death.continent is not null

  SELECT *, (VaccinatedPopulationPercentages/population)*100
 FROM #VaccinatedPopulationPercentages


 -- Data visualization

 create view VaccinatedPopulationPercentages as
 select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
 , sum(convert(int, vaccin.new_vaccinations)) over (partition by death.location order by death.location, death.date) as VaccinationsperLocation
 from PortfolioProject..CovidDeaths death
 join PortfolioProject..CovidVaccinations vaccin
 on death.location=vaccin.location
 and death.date=vaccin.date
 where death.continent is not null

 create view TotalVaccinations as
 select continent, max(cast(total_vaccinations as int)) as TotalVaccinations
  from PortfolioProject..CovidVaccinations
  where continent is not null
  group by continent 
  --order by TotalVaccinations desc
