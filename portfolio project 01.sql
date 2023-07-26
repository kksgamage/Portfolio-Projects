Select *
From dbo.CovidDeaths
Where continent is not null 
order by 3,4

select *
from dbo.CovidVaccinations
Where continent is not null
order by 3,4 

Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.CovidDeaths
Where continent is not null 
order by 1,2




--**Shows what percentage of covid deths with total cases**

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From dbo.CovidDeaths
--Where location like '%Australia%'
Where continent is not null

order by 1,2




--**Shows what percentage of population got covid**

Select Location, date, total_cases, population, (total_cases/population)*100 as Infected_Percentage
From dbo.CovidDeaths
Where continent is not null
--Where location like '%Australia%'
order by 1,2




--**Shows what countries highest infection rate compared to population**

Select Location, population, Max(total_cases) as Highest_Infection_Count,   Max(total_cases/population)*100 as Highest_Infected_Percentage
From dbo.CovidDeaths
--Where location like '%Australia%'
Where continent is not null
Group by Location, population
order by Highest_Infected_Percentage desc



--**Shows what countries highest death count per population**

Select Location,  Max(cast(total_deaths as int)) as Total_Death_Count
From dbo.CovidDeaths
--Where location like '%australia%'
Where continent is not null
Group by Location
order by Total_Death_Count desc



--**Shows what continent highest death count per population**

Select continent,  Max(cast(total_deaths as int)) as Total_Death_Count
From dbo.CovidDeaths
--Where location like '%australia%'
Where continent is not null
Group by continent
order by Total_Death_Count desc



--**Shows Global Numbers

Select date, Sum(new_cases) as Total_cases , Sum(cast(new_deaths as int)) as Total_deaths,
Sum(cast(new_deaths as int))/Sum(new_cases) *100 as Death_Percentage
From dbo.CovidDeaths
Where continent is not null
Group by date
order by 1,2




--**Shows Total Populaion vs Vaccinations
	--Use CTE


with PopvsVac  (Continent, Location,date,population,new_vaccinations,Rolling_People_Vaccinated)
as(

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
		as Rolling_People_Vaccinated
from dbo.CovidDeaths as dea 
join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--Where dea.location like '%Australia%'
	--order by 2,3
)
select*,(Rolling_People_Vaccinated/population)*100
from PopvsVac



--Temp Table

Drop table if exists #percentpopulationvaccinated
Create table  #percentpopulationvaccinated
(
Continent nvarchar (255),
location nvarchar (255),
Date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)
Insert into #percentpopulationvaccinated

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
		as Rolling_People_Vaccinated
from dbo.CovidDeaths as dea 
join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--Where dea.location like '%Australia%'
	--order by 2,3
	
select*,(Rolling_People_Vaccinated/population)*100 as Percentage_Of_Population_Vaccinated
from #percentpopulationvaccinated


--Creating View For Data Visualizatation

Create view percentpopulationvaccinated as 

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
		as Rolling_People_Vaccinated
from dbo.CovidDeaths as dea 
join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--Where dea.location like '%Australia%'
	--order by 2,3


	select*
	from percentpopulationvaccinated