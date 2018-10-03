/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 6: Working with new Tables/Views and Database Security
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
CREATE DATABASE ThirdDatabase;
go

USE ThirdDatabase;
go


/*==============================================================================================
 * 1) CREATE TABLE
 *==============================================================================================*/
-- create a new table to hold records about university students
-- read more about MS SQL Server data types https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql
CREATE TABLE tblStudent(
	StudentID	INT IDENTITY,
	FirstName	VARCHAR(50),
	LastName	VARCHAR(50),
	BirtDate	DATE NOT NULL, --NOT null constraint
	Tuition		MONEY,
	DateUpdated DATETIME,
	CONSTRAINT pk_Student_ID PRIMARY KEY (StudentID)
);
go

-- To quickly check the definition of a table use
-- Select the table and press [ALT] + [F1]
-- or use: sp_help TableName

select * from tblStudent;
sp_help tblStudent;


/*==============================================================================================
 * 2) ALTER TABLE: to add column
 *==============================================================================================*/

-- You've got a new requirement to add a middle initial to the table.

ALTER TABLE tblStudent Add MiddleInitial CHAR(1);
go

/*
 * ALTER TABLE: change column data type
 */

-- You've got a new requirement first and last name should support 
-- unicode or international characters

ALTER TABLE tblStudent ALTER COLUMN FirstName NVARCHAR(50);
ALTER TABLE tblStudent ALTER COLUMN LastName  NVARCHAR(50);
go


/*==============================================================================================
 * 3) ALTER TABLE: change table name using sp_rename
 *==============================================================================================*/
-- You've got a new requirement to rename tblStudent to tblUniversityStudent

EXEC sp_rename 'tblStudent', 'tblUniversityStudent';  
go

-- rename it back to tblStudent
EXEC sp_rename 'tblUniversityStudent', 'tblStudent';  
go


/*==============================================================================================
 * 4) DROP TABLE
 *==============================================================================================*/
-- Be very careful to run this as there is no wat to undo here.
-- You can take a backup of a table or the entire database to be safe

DROP TABLE tblStudent;
go

/*==============================================================================================
 * 5) Creating Temporary Table
 *==============================================================================================*/
-- We could create a temporary tables to hold data such a result of subqueries.
-- There are two types of temporary tables #LOCAL (most commonly used) and ##GLOBAL temporary tables.
-- Local Temporary tables are identified by "#" sign infront of the table name.

CREATE TABLE #Table1
(
	Col1 INT,
	Col2 VARCHAR(20)
);

INSERT INTO #Table1 values(1,'a'),(2,'b');

-- Check data in temp table in this session
-- Try running the same script in a new session or new query window
SELECT * FROM #Table1;

-- If there is a need to access Temporary tables outside of the current execution scope
-- Use global temporary tables using ## in front of a table name

CREATE TABLE ##Table2
(
	Col1 INT,
	Col2 VARCHAR(20)
);

INSERT INTO ##Table2 VALUES(1,'a'),(2,'b');

-- Try running the same script in a new session or new query window
SELECT * FROM ##Table2;

/*==============================================================================================
 * 6) Table Relationship: CREATE FOREIGN KEY Constraint
 *==============================================================================================*/
-- We have a requirment to record student course information.
-- Since there is a many to many relationship between student and course
-- We need Student, Course and StudenCourse (three tables) to create relationship

-- create student table
CREATE TABLE tblStudent(
	StudentID	INT IDENTITY,
	FirstName	VARCHAR(50),
	LastName	VARCHAR(50),
	BirtDate	DATE NOT NULL, --NOT null constraint
	Tuition		MONEY,
	DateUpdated DATETIME,
	CONSTRAINT pk_Student_ID PRIMARY KEY (StudentID)
);
go

-- create two new tables
CREATE TABLE tblCourse(
	CourseNumber VARCHAR(20),
	CourseTitle  VARCHAR(100),
	CONSTRAINT pk_Course PRIMARY KEY (CourseNumber)
);
go

-- DROP TABLE tblStudentCourse;
CREATE TABLE tblStudentCourse(	
	StudentID	 INT,
	CourseNumber VARCHAR(20)
);
go

-- Add FOREIGN KEY
ALTER TABLE tblStudentCourse   
ADD CONSTRAINT FK_StudentCourse_Student FOREIGN KEY (StudentID)     
    REFERENCES tblStudent (StudentID); 

-- You can also use SSMS functionality to add relationship   
ALTER TABLE tblStudentCourse   
ADD CONSTRAINT FK_StudentCourse_Course FOREIGN KEY (CourseNumber)     
    REFERENCES tblCourse (CourseNumber)     
    ON DELETE CASCADE  -- optional  
    ON UPDATE CASCADE  -- optional    
;  
go

--* We could also create relationships using SSMS gui


/*==============================================================================================
 * 7) Database diagram
 *==============================================================================================*/
 -- Use SSMS gui to create database diagram
 -- Expand Database Diagram
 -- + Right click on [Database Diagrams]
 -- + Select [New Database Diagrams]
 -- + Add Tables that you want to be in database diagram
 -- + Save the diagram


/*==============================================================================================
 * 8) Constraints in SQL
 *==============================================================================================*/
 -- In SQL Server Constraints help us to maintain integrity of our data by embedding 
 -- those data validation method in the declaration of our table.
/*
 * Primary Key constraint
 * Source: http://blog.reckonedforce.com/primary-key-constraints/
 */
	CREATE TABLE Table1
	(
		Col1 INT IDENTITY,
		Col2 VARCHAR(20),
		CONSTRAINT pk_table1_col1 PRIMARY KEY (Col1)
	);
	go
	--To create a primary key constraint for an existing table
	ALTER TABLE Table1 ADD CONSTRAINT pk_table1_col1 PRIMARY KEY (Col1);

/*
 *Foreign Key constraint
 *Source: http://blog.reckonedforce.com/foreign-key-constraints/
 */
	-- See the previous movie

/*
 * Unique Key constraint
 * Source: http://blog.reckonedforce.com/unique-constraints/
 */
	CREATE TABLE Table5
	(
		Col1 INT,
		Col2 VARCHAR(20),
		CONSTRAINT uq_col1 UNIQUE (col2)
	);

	-- To add unique key constraint on existing table
	ALTER TABLE Table5 ADD CONSTRAINT uq_col1 UNIQUE (Col1);
	go

/*
 * Check constraint
 * Source: http://blog.reckonedforce.com/check-constraints/
 */
	CREATE TABLE Table6 
	( 
		Col1 INT, 
		Col2 VARCHAR(20), 
		CONSTRAINT chk_col1 check (col1>0) 
	); 
	go

	-- To add check constraint on existing table
	ALTER TABLE Table6 ADD CONSTRAINT Chk_Col1 check (Col1>0); 
	go

/*
 * Default constraint
 * Source: http://blog.reckonedforce.com/default-constraints/
 */
	CREATE TABLE Table7
	(
		Col1 INT,
		Col2 VARCHAR(20),
		Col3 BIT NOT NULL
		CONSTRAINT df_col3 DEFAULT (0)
	);

	--To add default constraint on an existing table
	ALTER TABLE Table7 
		ADD CONSTRAINT DF_Col3  DEFAULT (0) FOR Col3;
	go


/*==============================================================================================
 * 9) Indexes
 *==============================================================================================*/

 --There are two major types of Indexes based on on-disk structure (Clustered and Nonclustered).
 --* Clustered indexes sort and store the data rows in the table or view based on their key values. 
 --* Nonclustered index contains key values, and each key-value entry has a pointer to the data row.

 -- A heap is a table without a clustered index. Adding an index to a table optimize a query by reducing I/O operations,
 -- avoiding table scans, 
 --Source: https://docs.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-2017

	-- To create a clustered index
	CREATE CLUSTERED INDEX  table7_cal2_3_idx1 
		ON Table7(Col2, Col3);
	go

	-- To create a clustered index
	CREATE NONCLUSTERED INDEX table7_cal1_idx1 
		ON Table7(Col1);
	go

	-- To drop an index
	DROP INDEX table7_cal1_idx1 
		ON Table7;
	GO

	
/*==============================================================================================
 * 10) Create Virtual Tables or VIEWs
 *==============================================================================================*/
 CREATE VIEW View1
 as 
	  SELECT Table6.Col1,
			 Table7.Col2
	  FROM Table6 
	  JOIN Table7 on Table6.Col1 = Table7.Col1;
GO

-- Select from view same way as a table
SELECT *
FROM View1;



/*==============================================================================================
 * 11) Granting, Revoking and Denying database permission
 *==============================================================================================*/

-- A Login is used for authentication into a SQL Instance while 
-- a User is used for authorization into a SQL Database.  
-- Logins are used at the Instance level and Users are used at the Database level.  

/* 
 * Create a Login 
 */

USE MASTER;
GO

CREATE LOGIN SQLTester WITH PASSWORD=N'SuperSecure#8!', 
	   DEFAULT_DATABASE = MASTER, 
	   DEFAULT_LANGUAGE = US_ENGLISH;
GO

ALTER LOGIN SQLTester ENABLE;
GO

/* 
 * Create a User 
 */
-- Create a user after creating a login then add the user to the Login.

USE ThirdDatabase;
GO

CREATE USER SQLTester FOR LOGIN SQLTester 
	WITH DEFAULT_SCHEMA = [dbo];
GO

/* 
 * We can create both Logins and Users using SSMS gui
 */
-- demo 



/*
 * Granting permission to Users
 */

	CREATE TABLE Table8
	(
		Col1 INT,
		Col2 VARCHAR(20)
	);
	go

	INSERT INTO Table8 values(1,'a'),(2,'b');
	go

	
	-- Execute the sql sttement under the context of SQLTester
	EXECUTE AS USER = 'SQLTester';
	GO 

	SELECT * 
	FROM dbo.Table8;
	GO
	
	-- Revert to the original login context 
	REVERT;
	GO 

/*
 * Granting permission using Roles
 */
	-- Create role
	CREATE ROLE ReadDBRole;
	GO

	-- Grant read/select permission to the new role
	GRANT SELECT ON dbo.Table8 TO ReadDBRole;
	GO 

	-- Add SQLTester as a memeber of ReadDBRole
	EXEC sp_addrolemember @rolename = 'ReadDBRole', @membername = 'SQLTester';
	GO 

	-- Execute the sql sttement under the context of SQLTester
	EXECUTE AS USER = 'SQLTester';
	GO 

	SELECT * 
	FROM dbo.Table8;
	GO

	-- Revert to the original login context 
	REVERT;
	GO  

/* 
 * Revoking access to a table 
 * REVOKE does not cancel or block a GRANT. It only removes permission at the level specified.
 */
 
	-- Revoke access from User
	REVOKE SELECT ON dbo.Table8 FROM SQLTester;

	-- Revoke access from Role
	REVOKE SELECT ON dbo.Table8 FROM ReadDBRole;

/* 
 * Granting access to table using views
 */
	create table Table9(
		id int not null identity,
		StudentName varchar(20),
		SSN varchar(11)
	);
	go
	
	insert into Table9
		select 'John', '111-00-2222'
		union
		select 'Doe', '222-33-5555'
	go

	create view View2
	as 
		select id,
			   StudentName		   
		from table9;
	go

	--Create role
	CREATE ROLE ViewOnly_Role;
	go
 
	--Grant select on all views in dbo
	GRANT SELECT ON dbo.View2 TO ViewOnly_Role; 

	--Add users be a member of that role
	EXEC sp_addrolemember 'ViewOnly_Role', 'SQLTester';
	Go

	-- Execute the sql sttement under the context of SQLTester
	EXECUTE AS USER = 'SQLTester';
	GO 
	-- Select from the table directly
	SELECT * 
	FROM dbo.Table9;
	
	-- Select using a view
	SELECT * 
	FROM dbo.View2;	

	-- Revert to the original login context 
	REVERT;
	GO
	
	-- Revoke access from User
	REVOKE SELECT ON dbo.Table9 FROM SQLTester; 

/* 
 * Deny access to a table 
 * DENY cancels or blocks a GRANT. It completely removes a permission at all levels.
 */

	-- Deny access from User
	DENY SELECT ON SCHEMA::dbo TO SQLTester;

	-- Deny access from Role
	DENY SELECT ON SCHEMA::dbo TO ViewOnly_Role;


 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Select a country that has the smallest GDP in the world?
  2) Find the population growth rate for each city?
 	   -- hint refer to Citypops table and https://pages.uoregon.edu/rgp/PPPM613/class8a.htm for population growth rate
  3) Display the most widely spoken language for each country, using a subquery?
  4) Display the most widely spoken language for continent Europe?
    -- hint refer to Encompasses table
  5) Display all top 5 Countries that has the largest area of Lakes combined?

*/

