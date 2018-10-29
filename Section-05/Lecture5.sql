/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 5: FROM & JOIN(Introduction)
**************************************************************************************************
* Change History
**************************************************************************************************
* Date:			Author:			Description:
* ----------    ---------- 		--------------------------------------------------
* 09/07/2018	BNigatu			initial version created
*************************************************************************************************
* Usage:
*************************************************************************************************
Execute each batch of the script sequentially
*************************************************************************************************/

USE CIA_FACTBOOK_DB;
go

/*==============================================================================================
 * 1) Using a basic FROM clause
 *==============================================================================================*/

SELECT [Name]      
      ,Capital
      ,Province
      ,Area
      ,[Population]
FROM dbo.Country;


/*==============================================================================================
 * 2) Using "AS" table_alias in FROM clause
 *==============================================================================================*/
-- AS can be used to alias the source table to either for convenience or to distinguish 
-- a table or view in a self-join or subquery.

SELECT C.[Name]
      ,C.Code
      ,C.Capital
      ,C.Province
      ,C.Area
      ,C.[Population]
FROM dbo.Country AS C;



/*==============================================================================================
 * 3) Using simple JOIN
 *==============================================================================================*/
-- Using Alias to join tables in FROM clause

SELECT C.[Name] AS Country
      ,D.[Name] Desert    
FROM dbo.Country C 
JOIN dbo.geo_Desert G ON C.Code = G.Country
JOIN dbo.Desert D ON D.Name = G.Desert;


/*==============================================================================================
 * 4) Using Subqueries in FROM clause
 *==============================================================================================*/

-- Using Subqueries in FROM clause
-- Example: for each country, select a religion that has the most followers 
SELECT R1.Country
      ,R1.[Name] AS Religion    
	  ,R1.[Percentage]
FROM dbo.Religion AS R1
JOIN (SELECT MAX([Percentage]) AS [Percentage], Country
	  FROM dbo.Religion					    
	  GROUP BY Country) As R2 ON R1.Country = R2.Country and 
								 R1.[Percentage]=R2.[Percentage]
ORDER BY  R1.Country ASC, 
		  R1.[Percentage] DESC;


-- We had a similar subquery used in WHERE clause in Lecture4.sql
SELECT R1.Country
      ,R1.[Name] AS Religion    
	  ,R1.[Percentage]
FROM dbo.Religion AS R1
WHERE R1.[Percentage] IN (SELECT MAX(R2.[Percentage]) AS [Percentage] -- this sub select is used to as a filter
					      FROM dbo.Religion AS R2
					      WHERE R1.Country = R2.Country
					      GROUP BY R2.Country)
ORDER BY  R1.Country ASC, 
		  R1.[Percentage] DESC;


/*==============================================================================================
 * 5) Execution order in SQL Server
 *==============================================================================================*/

-- This is an execution order that SQL Server follows 
-- FROM ->  ON -> OUTER -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> TOP
-- Why should you care about this?

-- Example: for each country, select a religion that has the most followers 
-- Using subselect/subqueries.

SELECT DISTINCT 
	   C.[Name] Country
      ,R1.[Name] AS Religion    
	  ,R2.[Max_Percentage] as m2
FROM dbo.Country C
JOIN dbo.Religion R1 ON R1.Country = C.Code
JOIN (SELECT Country, MAX([Percentage]) AS [Max_Percentage] -- this sub select is used to as a filter
	  FROM dbo.Religion
	  GROUP BY Country
	) AS R2 ON R2.Country = C.Code AND R2.[Max_Percentage] = R1.[Percentage]
ORDER BY  Country ASC, [Max_Percentage] DESC

 /*==============================================================================================
 * Practice Questions
 *==============================================================================================*/
 -- 1) Assume you are working in the coming election and try to find the total population people 
 --	   who live in the most populated city for every state in the United States. 
 --	   Find the total number of people who live in cities?

SELECT SUM(max_population) AS total_max_population
FROM (
		SELECT province, Max(Population) max_population 
		FROM dbo.City
		GROUP BY province
	) AS Sub1;

--Method 2
WITH CTE AS (
		SELECT province, Max(Population) max_population 
		FROM dbo.City
		GROUP BY province
) 
SELECT SUM(max_population)
FROM CTE;

 -- 2) Find a city with a minimum population size from a State/Province that has at least one city
 --	   with a population greater than 'Denver'

SELECT c2.Province, 
	   c1.Name as CityName,
	   c2.MinPopulation,
	   c2.MaxPopulation
FROM City c1
INNER JOIN (SELECT Province, min(Population) as MinPopulation, max(Population) as MaxPopulation
		    FROM City  			
			GROUP BY Province) AS c2 on C2.Province = c1.Province 
WHERE c1.Country = 'USA'
GROUP BY c2.Province, 
	   c1.Name,
	   c2.MinPopulation,
	   c2.MaxPopulation,
	   C1.Population 
HAVING MinPopulation = C1.Population 
      and c2.MaxPopulation> (SELECT Population
							FROM City c3
							WHERE Name = 'Denver'); 

-- Method 2
SELECT Province, 
	   min(Population) as MinPopulation, 
	   max(Population) as MaxPopulation, 
	  (
		   SELECT NAME 
		   FROM City c2  
		   WHERE c2.Province = City.Province and
				 min(City.Population) = c2.Population	  
	  )
FROM City
WHERE Country = 'USA'
GROUP BY Province
HAVING max(Population) >  (SELECT Population
							FROM City c3
							WHERE Name = 'Denver'); 

-- Find Ten Highest GDP per Capita  
-- Find formula : https://www.thebalance.com/per-capita-what-it-means-calculation-how-to-use-it-3305876
-- More about GDP per Capita https://www.thebalance.com/gdp-per-capita-formula-u-s-compared-to-highest-and-lowest-3305848

SELECT TOP 10 c.Name, 
			  c.Population, 
			  e.GDP*1000 AS GDP, 
			  e.GDP*1000000.0/c.Population AS [GDP-per-Capita]
FROM Country c
INNER JOIN Economy e on e.Country = c.Code
ORDER BY e.GDP*1000.0/c.Population DESC

 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select everything from Desert Table?
  2) Select all Deserts, Area of Desert and Country name?
 	   -- hint JOIN Desert, Country, and geo_Desert tables.
  3) We can use a column name aliases from SELECT clause to filter in HAVING clause? (Ture/False)
*/
