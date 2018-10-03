/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 3: WHERE
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

/*==============================================================================================
 * 1) Using basic WHERE clause
 *==============================================================================================*/


USE CIA_FACTBOOK_DB;
go

-- Basic WHERE clause
-- Using Number, String, and Date literal
SELECT [Name]
      ,Country
      ,City      
      ,Elevation     
FROM dbo.Airport
WHERE Elevation = 1656;

-- Using a string literal
SELECT [Name]
      ,Country
      ,City      
      ,Elevation     
FROM dbo.Airport
WHERE City = 'Colorado Springs';

-- Using a date literal
SELECT Country
      ,Independence
      ,WasDependent     
      ,Government
FROM dbo.Politics
WHERE Independence = '1776-07-04';


/*==============================================================================================
 * 2) Different conditions in WHERE clause
 *==============================================================================================*/

-- Different comparison operators >, >=, =, <=, <, <> 
-- <>, != is to operator used for different or not equal to
SELECT [Name]
      ,Mountains
      ,Elevation     
      ,Coordinates
FROM dbo.Mountain
WHERE Elevation  >= 8800; 

/*==============================================================================================
 * 3) Using Boolean operators AND, OR, NOT
 *==============================================================================================*/

-- Some cities such as Aurora are shared by more than one city in multiple states
SELECT [Name]
      ,Country
      ,Province      
      ,Elevation
FROM dbo.City
WHERE [Name] = 'Aurora' AND Province='Colorado';


-- Select Aurora Colorado or Denver.
SELECT [Name]
      ,Country
      ,Province      
      ,Elevation
FROM dbo.City
WHERE ([Name] = 'Aurora' AND Province='Colorado') OR [Name] = 'Denver';


-- Select Aurora that is not in Colorado using "NOT" operator.
SELECT [Name]
      ,Country
      ,Province      
      ,Elevation
FROM dbo.City
WHERE ([Name] = 'Aurora' AND NOT Province='Colorado');


/*==============================================================================================
 * 4) Filter rows that contain a value in string
 *==============================================================================================*/

-- Use "LIKE" operator to filter using part of the string
SELECT [Name]
      ,Mountains
      ,Elevation     
      ,Coordinates
FROM dbo.Mountain
WHERE Mountains LIKE 'Rocky%';   -- "%" means any character. You can also use "_" (underscore) to represent a single character

-- Use can also use "NOT LIKE" to filter records that doesn't match any part
SELECT [Name]
      ,Mountains
      ,Elevation     
      ,Coordinates
FROM dbo.Mountain
WHERE Mountains NOT LIKE '%Mountains%';




/*==============================================================================================
 * 5) Filter rows that are in a list of values
 *==============================================================================================*/

-- Use "IN" operator to filter rows that are in the list of string, number, or date literals
-- Find deserts in the USA and Mexico
SELECT Desert
      ,Country
      ,Province
FROM dbo.geo_Desert
WHERE Country IN ('MEX','USA');

-- Find rivers that have a length of 1400,1500, and 1600
SELECT [Name]
      ,River      
      ,[Length]     
      ,SourceElevation      
FROM dbo.River
WHERE [Length] IN (1400,1500, 1600);

-- Using "IN" from Subquery
SELECT [Name],
	   Capital
FROM dbo.Country
WHERE Code IN (SELECT Country  
			   FROM dbo.geo_Desert);


/*==============================================================================================
 * 6) Using BETWEEN in WHERE clause
 *==============================================================================================*/

-- To compare if a column value is in between to values use "BETWEEN" operator
-- Find Countries that gained their independence between 1900 and 1970.
SELECT C.[Name] AS Country
      ,Independence
      ,WasDependent
      ,[Dependent]
      ,Government
FROM dbo.Politics P
JOIN dbo.Country C ON C.Code = P.Country
WHERE Independence BETWEEN '1900-01-01' AND '1970-12-31'

-- Find mountains its elevation between 7,000 and 9,000 feet
SELECT [Name] AS Mountain    
      ,Elevation
FROM dbo.Mountain
WHERE Elevation BETWEEN 7000 AND 9000;


/*==============================================================================================
 * 7) NULL in WHERE clause
 *==============================================================================================*/

-- You cannot compare NULL columns using regular comparison operators
-- Instead use "IS NULL" or "IS NOT NULL"

-- Display cities that has null elevation
SELECT [Name]
      ,Country
      ,Province      
      ,Elevation
FROM dbo.City
WHERE Elevation IS NULL;

-- Display cities that have some value for their elevation
SELECT [Name]
      ,Country
      ,Province      
      ,Elevation
FROM dbo.City
WHERE Elevation IS NOT NULL;


 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select all cities in state of 'New York'?
  2) Find countries that have some part of their region on different continents?
 	   -- hint refer to Encompasses table
  3) Display an Airport in 'USA' that has an elevation of 313?
  4) Select Islands that has an Elevation between 3000 and 4000 feet?
  5) Display all top 5 Lakes in the world that has the largest Area?

*/