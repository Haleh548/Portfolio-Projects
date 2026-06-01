SELECT *
FROM usa_county_wise;

SELECT *
FROM worldometer_data; 

SELECT `Country/Region`,Continent, Population,TotalCases,TotalDeaths
FROM worldometer_data;

-- looking at total cases vs total deaths
-- Rank countries from highest to lowest DeathPercentage 

SELECT `Country/Region`,Continent, Population,TotalCases,TotalDeaths, DeathPercentage,
        RANK() OVER(ORDER BY DeathPercentage DESC) AS DeathRank
FROM(
    SELECT `Country/Region`, Continent,Population,TotalCases,TotalDeaths, ROUND((TotalDeaths/TotalCases)*100,3) AS DeathPercentage
    FROM worldometer_data
  ) AS t1
ORDER BY DeathPercentage DESC;

-- Looking at countries with highest infection rate compared to population

SELECT `Country/Region`, Continent,Population,
         MAX(TotalCases) AS HighestInfectionCount,
       ROUND( MAX((TotalCases/Population)*100),3) AS PopulationInfectedPercentage
FROM worldometer_data
GROUP BY `Country/Region`,Continent,Population
ORDER BY PopulationInfectedPercentage DESC;

--  Looking at countries with highest death rate per population

SELECT `Country/Region`, Continent,Population,
        MAX(TotalDeaths) AS TotalDeathCount
       FROM worldometer_data
GROUP BY  `Country/Region`, Continent,Population
ORDER BY TotalDeathCount DESC;     

-- Looking at total death per continent
SELECT Continent, 
        MAX(TotalDeaths) AS TotalDeathCount
       FROM worldometer_data
GROUP BY Continent
ORDER BY TotalDeathCount DESC;  
   

-- Looking at global death

SELECT SUM(TotalCases) AS GlobalCases, SUM(TotalDeaths) AS GlobalDeath, ((SUM(TotalDeaths)/SUM(TotalCases))*100 ) AS GlobalDeathPercentage
FROM worldometer_data;
