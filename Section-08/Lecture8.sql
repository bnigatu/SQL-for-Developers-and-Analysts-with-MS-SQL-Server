/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 8: INSERT, UPDATE & DELETE data to Tables
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
CREATE DATABASE FifthDatabase;
GO

USE FifthDatabase;
GO

-- Setup some tables for this section
IF OBJECT_ID('Student') IS NULL
CREATE TABLE Student(
	ID INT IDENTITY,
	FirstName VARCHAR(50),
	LastName  VARCHAR(50)
	);
GO

IF OBJECT_ID('Section2_Student') IS NULL
CREATE TABLE Section2_Student(
	ID INT IDENTITY,
	FirstName VARCHAR(50),
	LastName  VARCHAR(50)
	);
GO

IF OBJECT_ID('CSV_Student') IS NULL
CREATE TABLE CSV_Student(
	FirstName VARCHAR(50),
	LastName  VARCHAR(50)
	);
GO


IF OBJECT_ID('Log_Student') IS NULL
CREATE TABLE Log_Student(
	FirstName VARCHAR(50),
	LastName  VARCHAR(50),
	Operation VARCHAR(50),
	UserName  VARCHAR(50)
	);
GO


/*==============================================================================================
 * 1) Using basic INSERT INTO, to insert data to a table
 *==============================================================================================*/

-- Insert a single record;
INSERT INTO Student(FirstName, LastName) VALUES ('Lino', 'Koon');

-- Insert multiple records;
INSERT INTO Student VALUES ('Halley', 'Porcaro'),
						   ('Tobie', 'Waggener'),
						   ('Seema', 'Chamlee'),
						   ('Audria', 'Goodpasture');

-- Check what's in the table
SELECT * FROM Student;

/*==============================================================================================
 * 2) Using INSERT SELECT
 *==============================================================================================*/

-- Insert data from Student table to Section2_Student table.
INSERT INTO Section2_Student(FirstName, LastName)
SELECT FirstName, LastName
FROM Student;

-- Check what's in the table
SELECT * FROM Section2_Student;

/*==============================================================================================
 * 3) Using SELECT INTO to create and insert data to a new table
 *==============================================================================================*/

-- Create and insert data from Student table to Section3_Student (a new table) table.
SELECT FirstName, LastName INTO Section3_Student
FROM Student;


-- Check what's in the table
SELECT * FROM Section3_Student;


/*==============================================================================================
 * 4) Import data from external file
 *==============================================================================================*/
BULK INSERT FifthDatabase.dbo.CSV_Student 
   FROM 'f:\section-8\Students.csv' -- this needs to be a full path where you have your Students.csv file
   WITH   
      (  
         FIELDTERMINATOR =',',  
         ROWTERMINATOR ='\n'
      );  

-- Check what's in the table
SELECT * FROM CSV_Student;


/*==============================================================================================
 * 5) Using basic UPDATE clause
 *==============================================================================================*/
UPDATE Section2_Student SET FirstName = 'UNKOWN', 
							LastName = NULL;

-- Check what's in the table
SELECT * FROM Section2_Student;


 /*==============================================================================================
  * 6) Using UPDATE with WHERE clause to target only few rows to delete
  *==============================================================================================*/


UPDATE Student SET FirstName = 'Andrew'
WHERE LastName = 'Goodpasture';

-- Check what's in the table
SELECT * FROM Student;


/*==============================================================================================
 * 7) Using basic DELETE clause
 *==============================================================================================*/

 -- DELETE all records from Section2_Student
 DELETE 
 FROM Section2_Student;  
 
 -- Be very careful you don't run the above query in production as it will wipe all your data!
 -- Another way faster way to remove all data (this is also in test environment).
 
 TRUNCATE TABLE Section2_Student;  


 -- Check what's in the table
SELECT * FROM Section2_Student;

 /*==============================================================================================
  * 8) Using DELETE with WHERE clause to target only few rows to delete
  *==============================================================================================*/
 -- DELETE all records from Student table whoes last name starts with 'C'
 DELETE 
 FROM Student
 WHERE LastName LIKE 'W%';

-- Check what's in the table
SELECT * FROM Student;



/*==============================================================================================
 * 9) Using OUTPUT operator to log inserted/deleted data to a different table
 *==============================================================================================*/

-- Log inserted data to Log_Student.
INSERT INTO Section2_Student(FirstName, LastName)
	OUTPUT inserted.FirstName, inserted.LastName, 'Insert',SYSTEM_USER INTO Log_Student
SELECT FirstName, LastName
FROM CSV_Student;

-- Log deleted data to Log_Student.
DELETE FROM Section2_Student
	OUTPUT deleted.FirstName, deleted.LastName, 'Deleted',SYSTEM_USER INTO Log_Student
WHERE FirstName LIKE 'H%'; -- students whose first name start with 'M'


-- Check what's in the table
SELECT * FROM Log_Student;
SELECT * FROM Section2_Student;

 /*==============================================================================================
  * Exercise Questions
  *==============================================================================================*/

/*
  1) Download the class Roster as CSV and create a new table to import the CSV to a new table Roster?
  2) Update sales to the same Sales agent to USASales table if the same agent has sales on both USA and Canada?
	 -- Configure the Excercise database first to answer this question.
 	 -- hint FROM, and JOIN are allowed in DELETE AND UPDATE queries.
  3) After completing Question 2, Delete all sales from SalesCanada if the sales agent in CanadaSales has any sales in USASales?
  4) Insert a new sales agent ('20','YourName','YourLastName','123 Some Address','100','CASH') to USASales?
  5) We can be able to undo deleted records in SQL Server. (Ture/False)?
*/



/*==============================================================================================
 * Exercise Database
 *==============================================================================================*/
CREATE DATABASE SalesDatabase;
GO

USE SalesDatabase
GO  

IF OBJECT_ID ('USASales','U') IS NOT NULL
    DROP TABLE USASales;
GO

CREATE TABLE [dbo].[USASales](
            [AgentID] [int],
            [LastName] [nvarchar](255),
            [FirstName] [nvarchar](255),
            [Address] [nvarchar](255),
            [Amount] [float],
            [Payment_Method] [nvarchar](255)
) ;
GO

IF OBJECT_ID ('CanadaSales','U') IS NOT NULL
    DROP TABLE CanadaSales;
GO
CREATE TABLE [dbo].[CanadaSales](
             [AgentID] [int],
             [LastName] [nvarchar](255),
             [FirstName] [nvarchar](255),
             [Address] [nvarchar](255),
             [Amount] [float],
             [Payment_Method] [nvarchar](255)
);
GO
 
INSERT INTO [dbo].[USASales]
           ([AgentID]
           ,[LastName]
           ,[FirstName]
           ,[Address]
           ,[Amount]
           ,[Payment_Method])
Values
	('11','James','Smith','388 Beechwood Dr. New Milford, CT 06776','11','CASH'),
	('12','Michael','Brown','287 James Dr. Dekalb, IL 60115','12','CASH'),
	('13','Robert','Lee','9641 South St. Orange, NJ 07050','13','CASH'),
	('14','Maria','Garcia','7586 South Virginia Street Hixson, TN 37343','14','CASH'),
	('15','David','Hill','82 East Livingston Street Southampton, PA 18966','15','CASH');
 
INSERT INTO [dbo].[CanadaSales]
           ([AgentID]
           ,[LastName]
           ,[FirstName]
           ,[Address]
           ,[Amount]
           ,[Payment_Method])
Values
	('1','Maria','Rodriguez:','1528 110th Avenue, Dawson Creek British Columbia, Canada','11','CASH'),
	('2','Mary','Johnson','930 Seymour Street, Vancouver British Columbia, Canada','12','CASH'),
	('3','Paul','Gonzalez','8727 Brooke Road, Delta British Columbia, Canada','13','CASH'),
	('4','Daniel','Williams','315 Agnes Street, New Westminster British Columbia, Canada','14','CASH'),
	('5','Chris','Jones','1430 Summit Drive, Kamloops British Columbia, Canada','15','CASH'),
	('11','James','Smith','388 Beechwood Dr. New Milford, CT 06776','11','CASH');

GO
-- End of exercise database
