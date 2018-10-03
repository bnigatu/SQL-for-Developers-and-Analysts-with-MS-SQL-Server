/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 9: Advanced Topics
**************************************************************************************************
* Change History
**************************************************************************************************
* Date:			Author:			Description:
* ----------    ---------- 		--------------------------------------------------
* 09/03/2018	BNigatu			initial version created
*************************************************************************************************
* Usage:
*************************************************************************************************
Execute each batch of the script sequentially
*************************************************************************************************/

/*==============================================================================================
 * 1) The purpose of using WITH(NOLOCK) in SQL Server
 *==============================================================================================*/

CREATE DATABASE SixthDatabase;
GO

Use SixthDatabase;
go

--create a test_table
IF OBJECT_ID('TEST_TABLE') IS NOT NULL
	DROP TABLE TEST_TABLE;
GO
CREATE TABLE TEST_TABLE(
	ID INT IDENTITY,
	AGE INT
);
GO

--insert a tousand records
begin transaction
INSERT INTO TEST_TABLE(AGE)
	SELECT ROUND(RAND()*100,0) RANDOM_AGE
GO 1000



/*
 * Session 2: Open a new query window and run it a different session.
 */

-- select from the test table
SELECT *
FROM TEST_TABLE;

/*
 * The script above will not work as the table is locked by the former session
 * To make the slect to work use WITH(NOLOCK)
 */
 
SELECT *
FROM TEST_TABLE WITH(NOLOCK);


-- finally, execute the blow script on session 1 to clear transaction locks.
COMMIT transaction

/*==============================================================================================
 * 2) Difference B/N UNION and UNION ALL in SQL Server
 *==============================================================================================*/

 --create sample tables
 CREATE TABLE TABLE1(
 NUMBER INT
 );

 CREATE TABLE TABLE2(
 NUMBER INT
 );
 GO

 INSERT INTO TABLE1 VALUES(1),(2),(4),(5);
 INSERT INTO TABLE2 VALUES(1),(2),(3),(6);
 GO

 -- UNION removes duplicate and gives result 1,2,3,4,5,6
 SELECT NUMBER
 FROM TABLE1
 UNION 
 SELECT NUMBER
 FROM TABLE2;

 -- UNION ALL keeps duplicate and gives result 1,1,2,2,3,4,5,6
 SELECT NUMBER
 FROM TABLE1
 UNION ALL
 SELECT NUMBER
 FROM TABLE2;
 go

 DROP TABLE TABLE1;
 DROP TABLE TABLE2;
 GO

/*==============================================================================================
 * 3) Variables in SQL Server
 *==============================================================================================*/

 -- To create variables in SQL Server you can use DECLARE
 DECLARE @N1 INT;
 DECLARE @N2 INT;

 -- To assign a value to a variable use SET

 SET @N1 = 23;
 SELECT @N2 = 2;

 SELECT @N1 + @N2 AS TOTAL;
 go


 /*==============================================================================================
 * 4) Table Variables in SQL Server
 *==============================================================================================*/
 -- same way as temporary tables, table variables could hold data for the execution of a sql batch.
 -- unlike temporary tables, table variables would not force to recomiple stored procedure when we recreate.

 DECLARE @TBL_VARIABLE AS TABLE(
	 ID INT,
	 fNAME VARCHAR(50)
 );

 INSERT INTO @TBL_VARIABLE VALUES(1,'John');

 SELECT *
 FROM @TBL_VARIABLE;
 GO


/*==============================================================================================
 * 5) The purpose of using CURSORS in SQL Server
 *==============================================================================================*/

/*
 * Here is how your declare cursors
 * SOURCE: https://docs.microsoft.com/en-us/sql/t-sql/language-elements/declare-cursor-transact-sql?view=sql-server-2017
 
DECLARE cursor_name [ INSENSITIVE ] [ SCROLL ] CURSOR   
     FOR select_statement   
     [ FOR { READ ONLY | UPDATE [ OF column_name [ ,...n ] ] } ]  
[;]  
Transact-SQL Extended Syntax  
DECLARE cursor_name CURSOR [ LOCAL | GLOBAL ]   
     [ FORWARD_ONLY | SCROLL ]   
     [ STATIC | KEYSET | DYNAMIC | FAST_FORWARD ]   
     [ READ_ONLY | SCROLL_LOCKS | OPTIMISTIC ]   
     [ TYPE_WARNING ]   
     FOR select_statement   
     [ FOR UPDATE [ OF column_name [ ,...n ] ] ]  
[;]  
*/

Use CIA_Factbook_DB;
go

SET NOCOUNT ON;  

DECLARE @Country_Name varchar(50),		
		@GDP varchar(50),
		@Agriculture varchar(50),
		@Service varchar(50),
		@Industry varchar(50),
		@Inflation varchar(50),
		@Unemployment varchar(50),
		@message varchar(255);  

PRINT '-------- Country Economic Report --------';  

DECLARE country_cursor CURSOR LOCAL FOR   
	SELECT c.[Name] Country_Name
		  ,ISNULL(e.GDP,0)
		  ,ISNULL(e.Agriculture,0)
		  ,ISNULL(e.[Service],0)
		  ,ISNULL(e.Industry,0)
		  ,ISNULL(e.Inflation,0)
		  ,ISNULL(e.Unemployment,0) 
	FROM dbo.Country c  
	INNER JOIN dbo.Economy e ON c.Code = e.Country
	ORDER BY Country_Name;  

OPEN country_cursor;  

FETCH NEXT FROM country_cursor   
INTO @Country_Name,
	 @GDP,
	 @Agriculture,
	 @Service,
	 @Industry,
	 @Inflation,
	 @Unemployment;

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		PRINT ' '  
		SELECT @message = '----- Economy of : ' +  @Country_Name + char(13) +
			   ' GDP = '+	 @GDP  +' '+
			   ', Agriculture = '+	 @Agriculture  +' '+
			   ', Service = '+	 @Service  +' '+
			   ', Industry = '+	 @Industry  +' '+
			   ', Inflation = '+	 @Inflation  +' '+
			   ', Unemployment = '+	 @Unemployment + char(13)

		PRINT @message 
   
			-- Get the next vendor.  
		FETCH NEXT FROM country_cursor   
		INTO @Country_Name,
			 @GDP,
			 @Agriculture,
			 @Service,
			 @Industry,
			 @Inflation,
			 @Unemployment
	END   
CLOSE country_cursor;  
DEALLOCATE country_cursor;


/*==============================================================================================
 * 6) How to use Transaction and safe DELETE/UPDATE in SQL Server
 *==============================================================================================*/
Use SixthDatabase;
go

-- UPDATE All employees VationHous by 2 hours
BEGIN TRAN
-- Accidentally we updated all TEST_TABLE records
UPDATE t SET AGE +=2
FROM TEST_TABLE t;

-- check it is update
SELECT * FROM TEST_TABLE WITH(NOLOCK);

-- Undo changes
ROLLBACK TRAN;


-- The same method works for delete as well
BEGIN TRANSACTION
DELETE FROM TEST_TABLE;
go

-- check it is deleted
SELECT * FROM TEST_TABLE WITH(NOLOCK);

-- Undo changes
ROLLBACK TRAN;
go

/*==============================================================================================
 * 7) User defined Functions in SQL Server
 *==============================================================================================*/
-- There are table valued and scalar functions

-- example: create a function that converts Celsius to Fahrenheit
CREATE TABLE STATION 
(	ID INTEGER , 
	CITY CHAR(20), 
	STATE CHAR(2), 
    TEMP_C	FLOAT
);
go

INSERT INTO STATION VALUES (1, 'LA', 'CA', 33); 
INSERT INTO STATION VALUES (2, 'Denver', 'CO', 14); 
INSERT INTO STATION VALUES (3, 'New York', 'NY', 22);
go

CREATE FUNCTION dbo.Celsius2Fahrenheit (@c float)
RETURNS float
AS
BEGIN
	RETURN (@c * 9.0/5.0)+32;
END
GO

SELECT * FROM STATION;
-- Using function to add TEMP_F (Fahrenheit) value
SELECT ID, 
	   CITY,
	   STATE,
	   TEMP_C,
	   dbo.Celsius2Fahrenheit(TEMP_C) AS TEMP_F
FROM STATION;
GO

/*==============================================================================================
 * 8) Stored Procedures in SQL Server
 *==============================================================================================*/

-- Stored procedure can give us more flexibility compared to views as we can 
-- have data manupliation task in side SP.
-- Unlike a view we can not join stored procedures to a table

IF OBJECT_ID('FIRST_PROCEDURE','P') IS NOT NULL
	DROP PROCEDURE FIRST_PROCEDURE;
GO
CREATE PROCEDURE FIRST_PROCEDURE (@Country varchar(50), @RecordNumber int=0 output)
as
	SET NOCOUNT ON;
	CREATE TABLE #Temp (
		City_Name VARCHAR(50)
	);

	BEGIN TRY
		INSERT INTO #Temp (City_Name)
			SELECT Name as City_Name
			FROM CIA_Factbook_DB.dbo.City
			WHERE Country = @Country;
		SET @RecordNumber = @@ROWCOUNT;

		SELECT City_Name
		FROM #Temp;
	END TRY
	BEGIN CATCH
		RETURN 1;
	END CATCH

	RETURN 0;
GO

-- Execute stored procedure
DECLARE @Country varchar(50), 
		@RecordNumber   int=0;

SET @Country='USA';

EXEC FIRST_PROCEDURE @Country, @RecordNumber OUTPUT;

PRINT @RecordNumber;



 /*==============================================================================================
 * 8) Working with some of SQL Server built-in Functions
 *==============================================================================================*/
 -- Row number
 SELECT ROW_NUMBER() OVER(ORDER BY Name) as RowNum, 
		Name as Country_Name
 FROM CIA_Factbook_DB.dbo.Country;
 
 -- Rank
 SELECT Name as Country, 
		Rank() OVER(ORDER BY GDP DESC) as Gdp_Rank,
		GDP
 FROM CIA_Factbook_DB.dbo.Economy
 JOIN CIA_Factbook_DB.dbo.Country ON Country = Code
 ORDER BY 2 ASC;

 -- Concat function
 SELECT  ISNULL([Name],'')+' - '+Mountain as Concat1,
		 CONCAT([Name],' - ', Mountain) as Concat2
 FROM CIA_Factbook_DB.dbo.geo_Mountain
JOIN CIA_Factbook_DB.dbo.Country ON Country = Code;




/*==============================================================================================
 * 9) Database Backup/Restore in SQL Server
 *==============================================================================================*/

/* Backup with script */
BACKUP DATABASE [SixthDatabase] TO  DISK = N'D:\Backup\SixthDatabase.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'SixthDatabase - Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

/* Backup using SSMS gui */

 /*==============================================================================================
 * 10) How to create Reports using data in SQL Server
 *==============================================================================================*/

 
 /*
  * 1) Excel 
  */

 -- Checkout in resources folder for this section
 -- Country-GDP.xlsx
 

 /*
  * 2) SSRS 
  */

 -- Checkout in resources folder for this section
 -- Country-GDP-SSRS.zip project

 /*
  * 3) Tableau 
  */

 -- Checkout in resources folder for this section
 -- Country-GDP.twbx


