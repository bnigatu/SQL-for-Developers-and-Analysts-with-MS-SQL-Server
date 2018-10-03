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
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select everything from Desert Table?
  2) Select all Deserts, Area of Desert and Country name?
 	   -- hint JOIN Desert, Country, and geo_Desert tables.
  3) We can use a column name aliases from SELECT clause to filter in HAVING clause? (Ture/False)
*/
