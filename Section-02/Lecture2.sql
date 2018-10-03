/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 2: SELECT & ORDER BY
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
 * 1) Using basic SELECT clause
 *==============================================================================================*/


USE CIA_FACTBOOK_DB;
go

-- SELECT without a FROM clause
-- Number, String, and Date literal
SELECT 100.98 as this_number;

SELECT 'Text literal needs to be between single quotes';

SELECT 01/01/2010;


/*==============================================================================================
 * 2) Select all columns. SELECT * FROM table_name;
 *==============================================================================================*/

--To select from all columns, use *
SELECT *
FROM Country;

/*==============================================================================================
 * 3) Select some or all columns using column name/s. SELECT column_names FROM table_name;
 *==============================================================================================*/

--To SELECT column1, column2 FROM table_name;
SELECT [Name], [Population]
FROM Country;

/*==============================================================================================
 * 4) Take the top n values in SELECT 
 *==============================================================================================*/

 -- Use the "TOP" function to select the first n rows
SELECT TOP(5) [Name]
      ,River      
      ,[Length]
      ,Area     
FROM dbo.River;


/*==============================================================================================
 * 5) SELECT column headings and calculations
 *==============================================================================================*/

-- You can apply mathematical operations to columns
-- You can use "AS" to change a heading of a column
SELECT [Name], ([Population] + 1000000) AS projected_population
FROM Country;


/*==============================================================================================
 * 6) Mathematical operations in SELECT 
 *==============================================================================================*/

-- To SELECT math_function() FROM table_name;
SELECT SUM(area) total_area, AVG(area) AS avg_area
FROM dbo.Lake;

-- BODMAS in SQL
SELECT (2 + 3 * 4) AS BODMAS1; 
SELECT (2 + 3) * 4 AS BODMAS2; 


/*==============================================================================================
 * 7) Other built in functions in SELECT 
 *==============================================================================================*/

SELECT GETDATE() AS current_date_time;
SELECT ROUND(1.245, 2) AS round_to_two_digits;
SELECT HOST_NAME() AS server_name;
SELECT UPPER('lower letters') AS capitalize;
SELECT REVERSE('straight') AS backward;


/*==============================================================================================
 * 8) Conditional evaluation in SELECT 
 *==============================================================================================*/

 -- Using CASE WHEN
SELECT CASE WHEN 1 > 0 
			THEN 'Greater' 
			ELSE 'Lessor'
	   END AS comparison;

-- Using IIF
SELECT IIF (0>1, 'Greater', 'Lessor') AS comparison;

-- For example we would like to create a new column that shows the economic status of a country
-- This can be done using GDP >300 billion 'Developed' else 'Developing'
SELECT Country
      ,GDP
      ,Agriculture
      ,[Service]
      ,Industry
      ,Inflation
      ,Unemployment
	  ,CASE WHEN GDP > 300000 --If greater than 300 billion
			THEN 'Developed'
			WHEN GDP > 200000 
			THEN 'Developing'
			ELSE 'Under developed'
	   END AS economic_status
FROM dbo.Economy; 


 /*==============================================================================================
 * 9) Filtering duplicate in SELECT 
 *==============================================================================================*/

 -- Using DISTINCT to filter duplicates
 SELECT DISTINCT Mountains      
 FROM dbo.Mountain;

 -- Another way to do this is
  SELECT Mountains      
 FROM dbo.Mountain
 GROUP BY Mountains

 -- See how it is without using distinct
 SELECT Mountains      
 FROM dbo.Mountain
 ORDER BY Mountains DESC;


 /*==============================================================================================
 * 10) Using basic ORDER BY clause
 *==============================================================================================*/

 -- Using ORDER BY AS
 -- ASC = Ascending
 -- DESC = Descending
 SELECT [Name]
       ,Code
       ,Capital
       ,Province
       ,Area
       ,[Population]
FROM dbo.Country
ORDER BY [Population]; -- default is ASC
 
-- Using more than 1 column for order
SELECT [Name]
      ,Mountains
      ,Elevation      
      ,Coordinates
FROM dbo.Mountain
ORDER BY Mountains ASC, Elevation DESC;


 -- You can use a column number in order (but use this only for testing).
SELECT [Name]
      ,Mountains
      ,Elevation      
      ,Coordinates
FROM dbo.Mountain
ORDER BY 2 ASC, 3 DESC;


 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select the top 10 Lakes with the largest area size?
  2) You found an expert prediction that a Sea level will raise six feet at the end of the next five year,
 	   calculate the depth of each Sea five years from now? 
  3) Display unique Rivers for your report?
  4) Calculate the result of the sum of 4 and 5, multiplied by 6 using SQL?
  5) Display all columns from Airport table, in  a descending order of Airport name by state?

*/