/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 4: GROUP BY & HAVING
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
 * 1) Using a basic GROUP BY clause 
 *==============================================================================================*/

-- Basic GROUP BY clause
-- GROUP BY groups rows mainly to perform one or more aggregations on each group
-- Example: Find total City population per State
SELECT Province
      ,SUM(ISNULL([Population],0)) as total_population
	  ,AVG(ISNULL([Population],0)) as average_population
FROM dbo.City
GROUP BY Province


/*==============================================================================================
 * 2) Using sub queries combined with GROUP BY
 *==============================================================================================*/

-- We can use subquery using "IN" operator we have seen the previous section
-- To get a result of the aggregate function as a filter 
-- Example: for each country, select a religion that has the most followers 

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
 * 3) Using aggregate functions in ORDER BY
 *==============================================================================================*/

-- Result of aggregate function can be used like any other column in ORDER BY clause
SELECT Country 
	  ,[NAME]     
      ,MAX([Percentage]) AS Language_Percentage
FROM dbo.[LANGUAGE]
GROUP BY Country,[NAME]   
ORDER BY Country ASC, Language_Percentage DESC;

/*==============================================================================================
 * 4) Legal aggregates
 *==============================================================================================*/

-- Only aggregate column without group by
SELECT MAX(Elevation)
FROM dbo.Mountain;

-- None aggregates column with a group by clause
SELECT Mountains,MAX(Elevation)
FROM dbo.Mountain
GROUP BY Mountains;

-- Multiple aggregate columns 
SELECT MAX(Elevation),MIN(Elevation),AVG(Elevation),SUM(Elevation),COUNT(Elevation)
FROM dbo.Mountain;

/*==============================================================================================
 * 5) Illegal aggregates
 *==============================================================================================*/
-- Aggregates in a Where clause
SELECT *
FROM dbo.Mountain
WHERE Elevation = MAX(Elevation);

-- None aggregates column without a group by clause
SELECT Mountains,MAX(Elevation)
FROM dbo.Mountain;

-- Neste aggregate columns 
SELECT MAX(AVG(Elevation))
FROM dbo.Mountain;


/*==============================================================================================
 * 6) Statistics in SQL
 *==============================================================================================*/
SELECT COUNT(*) AS Count_Every_Column,
   COUNT(Mountains) AS Count_Mountains,
   COUNT(DISTINCT Mountains) AS Count_Distinct_Mountains
FROM dbo.Mountain;


-- Distinct another form
SELECT Mountains
FROM dbo.Mountain
GROUP BY Mountains;

SELECT DISTINCT Mountains
FROM dbo.Mountain;


/*==============================================================================================
 * 7) Using basic HAVING clause 
 *==============================================================================================*/

-- Unlike ORDER BY clause we cannot use WHERE clause to filter aggregate functions
-- Instead, we need to use HAVING clause
-- Example: Let us use the previous example to filter countries that have religion followed by more than 70% of the population
SELECT C.[Name] AS Country
      ,R.[Name] AS Religion    
	  ,MAX(R.[Percentage]) AS [Percentage]
FROM dbo.Religion R
JOIN dbo.Country C ON C.Code = R.Country
GROUP BY C.[Name]
        ,R.[Name]
HAVING MAX(R.[Percentage]) > 70;


 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select a country that has the smallest GDP in the world?
  2) Find the population growth rate for each city?
 	   -- hint refer to Citypops table and https://pages.uoregon.edu/rgp/PPPM613/class8a.htm for population growth rate
  3) Display the most widely spoken language for each country, using a subquery?
  4) Display the most widely spoken language in the continent Europe?
       -- hint refer to Encompasses table
  5) Display all top 5 Countries that have the largest area of Lakes combined?

*/