/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 1
**************************************************************************************************
* Change History
**************************************************************************************************
* Date:			Author:			Description:
* ----------    ---------- 		--------------------------------------------------
* 08/24/2018	BNigatu			initial version created
*************************************************************************************************
* Usage:
*************************************************************************************************
Execute each batch of the script sequentially
*************************************************************************************************/


/*
 * Create your first database. 
 */

CREATE DATABASE FirstDatabase;
go -- go is used for readability and execution of batches and scripts. 

/*
 * [OPTIONAL]
 * To see all existing databases in your server use
 */
SELECT name, database_id, create_date  
FROM sys.databases ; 


/*
 * Select a database your want to work on
 * for our case FirstDatabase using a key word "USE"
 */
USE FirstDatabase; --before starting your operation, select a database where all your operations will be performed.
go


/*
this is a multi line comment
that I am adding
*/

-- this is a single line comment
-- if I continue to type this is not 
-- going to be commented