1.Write a syntax to create a database user, locally/dictionary managed table space, temporary table space and assign user to table space with verification scripts.
2.Write a syntax to provide default privilege to oracle users to connect database and write an anonymous block to provide all privilege to oracle user and also with admin option privilege.
3.Draw and explain the oracle architecture, which shows the flow of query in oracle database.
4.Write a syntax to drop oracle database in safe mode with defining the oracle data dictionary.
5.Write a syntax to create global temporary table -ON COMMIT DELETE ROWS and describe.
6.Write a syntax to create global temporary table -ON COMMIT PRESERVE ROWS and describe.
7.Write two methods to delete duplicate records from a table in oracle. (Hint: ROWID, ANY)
8.Write a structure query language to show all the aliases (Column level, table level, query level, sub query level and inline query view level) and describe in brief
9.Write a syntax to create a virtual column table and also explain why DML operations cannot be performed in virtual column table.
10.Write a syntax to generate with table using virtual table and also use union, intersection and union all operations in the table.
11.Write an anonymous block to generate number from 1 to 5 and 5 to 1.
12.Write a syntax to create a table using connect by clause.
13.Different between truncate and delete.
14.Different types of Oracle integrity constraints.
15.Basic SQL statements.

16.Write an anonymous block to create a file backup “File_Backup.txt” of source file “File.txt” with all contents of source file from oracle directory and explain.
17.Write a syntax to create a table name “tbl_blobs” and write an anonymous block to load the “File_Name.jpg” into table “tbl_blobs” from oracle directory and elaborate.
18.Write a program to fetch a “File_Name.jpg” image file into an operating system directory from above table name “tbl_blobs” using an anonymous block.
19.Write an anonymous block to convert blob data into varchar2 using above table “tbl_blobs” with data “File_Name.jpg”
20.Write a syntax to load the "size.txt" file contains in oracle table using size delimited.
21.Write a syntax to load the "tab.txt" file contains in oracle table using tab delimited.
22.Write a syntax to load the "comma.csv" file contains in oracle table using comma delimited with separate bad file logs and upload logs.
23.Write an anonymous block to write all records with column name in file “employees.csv” of source the table “hr. employees” and describe.
24.Write a program to dynamically take the input data and oracle query into the oracle variable and describe the mechanism. 
25.Write an anonymous block to fetch the running environment of oracle user sessions and elaborate.(Search from Internet: Oracle sys_context)
26.Write an anonymous block to show the use of global, local and constant variable declaration in oracle and describe.
27.Write an anonymous block to represent the use of character manipulation function with condition over input data and explain. 
28.Difference between TRUNCATE and DELETE
29.Describe on oracle analytic function (RANK and DENSE_RANK) 
30.Brief on aggregate functions




1.Write a syntax to create a database user, locally/dictionary managed table space, temporary table space and assign user to table space with verification scripts.
-- To find the location 
SELECT DISTINCT 
     SUBSTR(b.file_name,1,INSTR(b.file_name,'/',-1)) file_name
FROM (
      SELECT 
           a.file_name 
      FROM dba_data_files a
     ) b ;
/*
FILE_NAME
----------------------------------
C:\APP\ADMINISTRATOR\ORADATA\ORCL\
*/

-- To verify the user 
SELECT Count(*) verification FROM dba_users WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the Permanent tablespace
SELECT Count(*) verification FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the temprory tablespace
SELECT Count(*) verification FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the user's permission on tablespace                               
SELECT Count(*) verification FROM dba_ts_quotas WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

-- Permanent tablespaces
CREATE TABLESPACE u_1
DATAFILE 'C:\APP\ADMINISTRATOR\ORADATA\ORCL\u_1.dbf'
SIZE 500M
AUTOEXTEND ON NEXT 1M MAXSIZE 10G
SEGMENT SPACE MANAGEMENT auto;

-- To verify the Permanent tablespace
SELECT * FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
FILE_NAME                                 FILE_ID TABLESPACE_NAME     BYTES BLOCKS STATUS    RELATIVE_FNO AUTOEXTENSIBLE    MAXBYTES MAXBLOCKS INCREMENT_BY USER_BYTES USER_BLOCKS ONLINE_STATUS
----------------------------------------- ------- --------------- --------- ------ --------- ------------ -------------- ----------- --------- ------------ ---------- ----------- -------------
C:\APP\ADMINISTRATOR\ORADATA\ORCL\U_1.DBF       6 U_1             524288000  64000 AVAILABLE            6 YES            10737418240   1310720          128  523239424       63872 ONLINE       
       
*/

-- Temporary tablespaces
CREATE TEMPORARY TABLESPACE u_t_1
TEMPFILE 'C:\APP\ADMINISTRATOR\ORADATA\ORCL\u_t_1.dbf'
SIZE 10M
AUTOEXTEND ON;

-- To verify the temprory tablespace
SELECT * FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
FILE_NAME                                   FILE_ID TABLESPACE_NAME    BYTES BLOCKS STATUS RELATIVE_FNO AUTOEXTENSIBLE    MAXBYTES MAXBLOCKS INCREMENT_BY USER_BYTES USER_BLOCKS
------------------------------------------- ------- --------------- -------- ------ ------ ------------ -------------- ----------- --------- ------------ ---------- -----------
C:\APP\ADMINISTRATOR\ORADATA\ORCL\U_T_1.DBF       2 U_T_1           10485760   1280 ONLINE            1 YES            34359721984   4194302            1    9437184        1152
*/

-- To Create a Oracel User with assigning the relevant tableaspace.
CREATE USER u_1 IDENTIFIED BY oracle
DEFAULT TABLESPACE u_1
TEMPORARY TABLESPACE u_t_1
QUOTA UNLIMITED ON u_1;

-- To verify the user 
SELECT * FROM dba_users WHERE username ='U_1';
/*
USERNAME USER_ID PASSWORD ACCOUNT_STATUS LOCK_DATE EXPIRY_DATE         DEFAULT_TABLESPACE TEMPORARY_TABLESPACE CREATED             PROFILE INITIAL_RSRC_CONSUMER_GROUP EXTERNAL_NAME PASSWORD_VERSIONS EDITIONS_ENABLED AUTHENTICATION_TYPE
-------- ------- -------- -------------- --------- ------------------- ------------------ -------------------- ------------------- ------- --------------------------- ------------- ----------------- ---------------- -------------------
U_1          186          OPEN                     10.07.2020 01:51:18 U_1                U_T_1                12.07.2018 22:03:13 DEFAULT DEFAULT_CONSUMER_GROUP                    10G 11G           N                PASSWORD           
*/

-- To verify the user's permission on tablespace.
SELECT * FROM dba_ts_quotas WHERE username ='U_1';
/*
TABLESPACE_NAME USERNAME BYTES MAX_BYTES BLOCKS MAX_BLOCKS DROPPED
--------------- -------- ----- --------- ------ ---------- -------
U_1             U_1          0        -1      0         -1 NO     
*/

2.Write a syntax to provide default privilege to oracle users to connect database and write an anonymous block to provide all privilege to oracle user and also with admin option privilege.
-- To provide defalut roll to user
GRANT CONNECT,RESOURCE TO u_1;

-- Grant all privileges
BEGIN
  FOR i IN (SELECT privilege FROM dba_sys_privs)
  LOOP
     BEGIN
         EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO u_1';
         Dbms_Output.Put_Line('GRANT '||i.privilege||' TO u_1');
     EXCEPTION WHEN OTHERS THEN 
         NULL;
     END;
  END LOOP;
END;
/

SELECT Count(*) privilege FROM DBA_SYS_PRIVS WHERE GRANTEE='U_1' AND ADMIN_OPTION ='NO';
/*
PRIVILEGE
---------
      201
*/

-- Grant SYS/ADMIN privileges
BEGIN
  FOR i IN (SELECT * FROM dba_sys_privs WHERE ADMIN_OPTION = 'YES')
  LOOP
     BEGIN
         EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO u_1 WITH ADMIN OPTION';
         Dbms_Output.Put_Line('GRANT '||i.privilege||' TO u_1 WITH ADMIN OPTION');
     EXCEPTION WHEN OTHERS THEN 
         NULL;
     END;
  END LOOP;
END;
/

-- Login user
SELECT Count(*) privilege FROM DBA_SYS_PRIVS WHERE GRANTEE='U_1' AND ADMIN_OPTION ='YES';
/*
PRIVILEGE
---------
      201
*/

3.
4.Write a syntax to drop oracle database in safe mode with defining the oracle data dictionary.
-- Login to SYS
-- To drop Oracle User/Database
DROP USER u_1 CASCADE;
ALTER TABLESPACE u_1 OFFLINE;
DROP TABLESPACE u_1 INCLUDING CONTENTS AND DATAFILES;
ALTER TABLESPACE u_t_1 OFFLINE;
DROP TABLESPACE u_t_1 INCLUDING CONTENTS AND DATAFILES;

-- To verify the user 
SELECT Count(*) verification FROM dba_users WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the Permanent tablespace
SELECT Count(*) verification FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the temprory tablespace
SELECT Count(*) verification FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the user's permission on tablespace
SELECT Count(*) verification FROM dba_ts_quotas WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

5.Write a syntax to create global temporary table -ON COMMIT DELETE ROWS and describe.
-- Global Temporary Table transaction specific
CREATE GLOBAL TEMPORARY TABLE u_1.gtb_table_name_transactional
( 
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) 
ON COMMIT DELETE ROWS;

INSERT INTO u_1.gtb_table_name_transactional
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM u_1.gtb_table_name_transactional;
/*
COL_1 COL_2
----- -----
    1 DATA1
    2 DATA2
    3 DATA3
    5 DATA4
*/
COMMIT;

SELECT Count(*) data FROM u_1.gtb_table_name_transactional;
/*
DATA
----
   0
*/

6.Write a syntax to create global temporary table -ON COMMIT PRESERVE ROWS and describe.
-- Global Temporary Table session specific
CREATE GLOBAL TEMPORARY TABLE u_1.gtb_table_name_session
(  
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) 
ON COMMIT PRESERVE ROWS;

INSERT INTO gtb_table_name_session
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM u_1.gtb_table_name_session;
/*
COL_1 COL_2
----- -----
    1 DATA1
    2 DATA2
    3 DATA3
    5 DATA4
*/
COMMIT;

-- Re-Login with the current session 
SELECT Count(*) data FROM u_1.gtb_table_name_session;
/*
DATA
----
   0
*/

7.Write two methods to delete duplicate records from a table in oracle. (Hint: ROWID, ANY)
--How to delete duplicate rows in a table?
DELETE FROM employees a 
WHERE 
    ROWID != (
              SELECT 
                   MAX(ROWID) 
              FROM 
                   employees b 
              WHERE  
                   a.employee_id=b.employee_id
             );

DELETE FROM employees a 
WHERE 
    ROWID > ANY (
                 SELECT 
                      ROWID 
                 FROM 
                      employees b 
                 WHERE  
                      a.employee_id=b.employee_id
                );

8.Write a structure query language to show all the aliases (Column level, table level, query level, sub query level and inline query view level) and describe in brief
-- Alise and Contatination operatore Example
SELECT
     -- Column levl alise in select
     a.department_id                                        AS  department_id_1,
     a.department_id                                            department_id_2,
     a.department_id                                            "Department_Id_3",
     a.department_id                                            "SELECT",
     a.department_id                                            " ",
     -- Table level alise in select                      
     c.department_id                                            department_id,
     -- Query level alise in select                                
     (SELECT MAX(b.region_id) FROM hr.countries b)              select_query_alise,
     '1'||a.department_id||'Contination Literal Character'      ontination_operator
FROM -- Table level alise
     hr.employees a JOIN (
                         SELECT 
                              d.department_id 
                         FROM hr.departments d
                        ) c
                        -- subquery level alise                        
ON   a.department_id=c.department_id
WHERE a.employee_id =100;

/*
DEPARTMENT_ID_1 DEPARTMENT_ID_2 Department_Id_3 SELECT    DEPARTMENT_ID SELECT_QUERY_ALISE ONTINATION_OPERATOR             
--------------- --------------- --------------- ------ -- ------------- ------------------ --------------------------------
             90              90              90     90 90            90                  4 190Contination Literal Character
*/

9.Write a syntax to create a virtual column table and also explain why DML operations cannot be performed in virtual column table.
DROP TABLE u_1.virtula_column_table purge;
CREATE TABLE u_1.virtula_column_table
(
  id          NUMBER,
  first_name  VARCHAR2(10),
  last_name   VARCHAR2(10),
  salary      NUMBER(9,2),
  comm1       NUMBER(3),
  comm2       NUMBER(3),
  salary1     AS (ROUND(salary*comm1,2)),
  salary2     AS (ROUND(salary+comm2,2)), --<== VIRTUAL
  CONSTRAINT virtula_column_table_pk PRIMARY KEY (id)
);

INSERT INTO u_1.virtula_column_table
(
 id, first_name, last_name, salary, comm1, comm2
)
VALUES
(
 1, 'JOHN', 'DOE', 100, 5, 10
);

INSERT INTO u_1.virtula_column_table
(
 id, first_name, last_name, salary, comm1, comm2
)
VALUES
(
 2, 'JAYNE', 'DOE', 200, 10, 20
);
COMMIT;

SELECT * FROM u_1.virtula_column_table;
/*
ID FIRST_NAME LAST_NAME SALARY COMM1 COMM2 SALARY1 SALARY2
-- ---------- --------- ------ ----- ----- ------- -------
 1 JOHN       DOE          100     5    10     500     110
 2 JAYNE      DOE          200    10    20    2000     220
*/

INSERT INTO u_1.virtula_column_table
(
 id, first_name, last_name, salary, comm1, comm2, salary1, salary2
)
VALUES
(
 3, 'JAYNE', 'DOE', 200, 10, 20 , 100, 200
);
/*                                                   
ORA-54013: INSERT operation disallowed on virtual columns
*/

10.Write a syntax to generate with table using virtual table and also use union, intersection and union all operations in the table.
-- Using With clause
WITH with_table
AS
  (
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 2 col_1, 'b' col_2, sysdate col_3 FROM DUAL
  )
SELECT
     col_1,
     col_2,
     col_3
FROM 
     with_table
WHERE
     1 = 1;
/*
COL_1 COL_2 COL_3
----- ----- -------------------              
    1 a     13.01.2020 01:02:54
    1 a     13.01.2020 01:02:54
    2 b     13.01.2020 01:02:54
*/

11.Write an anonymous block to generate number from 1 to 5 and 5 to 1.
-- To Understand the Oracle Implicit Loop
BEGIN
    FOR i IN 1..5
    LOOP
       Dbms_Output.Put_Line(i);
    END LOOP;
END;
/
/*
1
2
3
4
5
*/

BEGIN
    FOR i IN REVERSE 1..5
    LOOP
       Dbms_Output.Put_Line(i);
    END LOOP;
END;
/
/*
5
4
3
2
1
*/

12.Write a syntax to create a table using connect by clause.
DROP TABLE tbl_data PURGE;
CREATE TABLE tbl_data
AS
SELECT 
     LEVEL          sn,
     SYSDATE        created_on,
     'First Name'   first_name,
     'Middle Name'  middle_name,
     'Last Name'    last_name,
     SYSDATE -1     dateofbirth
FROM dual
CONNECT BY LEVEL <= 4;

SELECT * FROM tbl_data;
/*
SN CREATED_ON          FIRST_NAME MIDDLE_NAME LAST_NAME DATEOFBIRTH
-- ------------------- ---------- ----------- --------- -------------------        
 1 05.03.2020 23:32:21 First Name Middle Name Last Name 04.03.2020 23:32:21
 2 05.03.2020 23:32:21 First Name Middle Name Last Name 04.03.2020 23:32:21
 3 05.03.2020 23:32:21 First Name Middle Name Last Name 04.03.2020 23:32:21
 4 05.03.2020 23:32:21 First Name Middle Name Last Name 04.03.2020 23:32:21
*/


16.Write an anonymous block to create a file backup “File_Backup.txt” of source file “File.txt” with all contents of source file from oracle directory and explain.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
DECLARE
    l_infile   utl_file.file_type;
    l_outfile  utl_file.file_type;
    l_newLine  VARCHAR2(4000);
    l_i        PLS_INTEGER;
    l_j        PLS_INTEGER := 0;
    l_seekflag BOOLEAN := TRUE;
BEGIN
    -- open a file to read
    l_infile := utl_file.fopen('DIRECTORY_NAME', 'File.txt','R');
    -- open a file to write
    l_outfile := utl_file.fopen('DIRECTORY_NAME', 'File_Backup.txt', 'W');
    
    -- if the file to read was successfully opened
    IF utl_file.is_open(l_infile) THEN
      -- LOOP through each line IN the file
      LOOP
         BEGIN
             utl_file.get_line(l_infile, l_newLine);
             l_i := utl_file.fgetpos(l_infile);
             utl_file.put_line(l_outfile, l_newLine, FALSE);
         EXCEPTION WHEN NO_DATA_FOUND THEN
             EXIT;
         END;
      END LOOP;
      COMMIT;
    END IF;
    -- Close a file
    utl_file.fclose(l_infile);
    utl_file.fclose(l_outfile);
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20099, 'Unknown UTL_FILE Error');
END;
/

17.Write a syntax to create a table name “tbl_blobs” and write an anonymous block to load the “File_Name.jpg” into table “tbl_blobs” from oracle directory and elaborate.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
-- Create table with blob data type
CREATE TABLE tbl_blobs
(
  id        VARCHAR2(255),
  blob_col  BLOB
);

-- To Load the *.* into oracle table
DECLARE
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    INSERT INTO tbl_blobs VALUES ( 'File_Name', empty_blob() )
    RETURN blob_col INTO l_b_lob;

    l_f_lob := bfilename( 'DIRECTORY_NAME', 'File_Name.jpg' );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END;
/

-- To Verify the Data
SELECT * FROM tbl_blobs;
/*
ID        BLOB_COL
--------- --------------------------------
File_Name ffd8ffe000104a46494600010201012c
          012c0000ffe110634578696600004949
          2a00080000000a000f01020006000000
*/

18.Write a program to fetch a “File_Name.jpg” image file into an operating system directory from above table name “tbl_blobs” using an anonymous block.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
-- To Get the *.* File from Oracle Table
DECLARE
     l_t_blob         BLOB;
     l_t_len          NUMBER;
     l_t_file_name    VARCHAR2(32767);
     l_t_output       utl_file.file_type;
     l_t_totalsize    NUMBER;
     l_t_l_position   NUMBER := 1;
     l_l_t_chucklen   NUMBER := 4096;
     l_t_chuck        RAW(4096);
     l_t_remain       NUMBER;
BEGIN
     SELECT 
          dbms_lob.getlength (blob_col), 
          id||'.jpg' 
          INTO l_t_totalsize, l_t_file_name 
     FROM 
          tbl_blobs 
     WHERE 
          id = 'File_Name';
     l_t_remain := l_t_totalsize;
     l_t_output := utl_file.fopen ('DIRECTORY_NAME', l_t_file_name, 'wb', 32760);
     
     SELECT 
          blob_col INTO l_t_blob 
     FROM 
          tbl_blobs 
     WHERE 
          id = 'File_Name';
          
     WHILE l_t_l_position < l_t_totalsize
     LOOP
         dbms_lob.read (l_t_blob, l_l_t_chucklen, l_t_l_position, l_t_chuck);
         utl_file.put_raw (l_t_output, l_t_chuck);
         utl_file.fflush (l_t_output);
         l_t_l_position := l_t_l_position + l_l_t_chucklen;
         l_t_remain := l_t_remain - l_l_t_chucklen;

         IF l_t_remain < 4096 THEN
            l_l_t_chucklen := l_t_remain;
         END IF;
     END LOOP;
END;
/

19.Write an anonymous block to convert blob data into varchar2 using above table “tbl_blobs” with data “File_Name.jpg”
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
-- Convertion of Blob into Varchar2
DECLARE 
   l_column_blob_loop   NUMBER;
   l_column_blob_length NUMBER;
   l_blob_col           BLOB;
   l_i                  NUMBER;
   l_query              VARCHAR2(32767) := 'SELECT ';
BEGIN
   SELECT 
        blob_col,
        trunc((DBMS_LOB.GETLENGTH(blob_col)/2000))+1,
        trunc((DBMS_LOB.GETLENGTH(blob_col)))+1 
        INTO l_blob_col,l_column_blob_loop,l_column_blob_length 
   FROM tbl_blobs WHERE id = 'File_Name';

   FOR i IN 1..l_column_blob_loop
   LOOP
       IF i = 1 THEN
          l_query := l_query ||' UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(blob_col,2000,'||i||')) column_'||i||',';
       ELSIF i = 2 THEN
          l_i := 2001;
          l_query := l_query ||' UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(blob_col,2000,'||l_i||')) column_'||i||',';
       ELSIF ( l_i <= l_column_blob_length) THEN  
          l_i := l_i  - 1;
          l_query := l_query ||' UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(blob_col,2000,'||l_i||')) column_'||i||',';
       END IF;
       l_i := l_i * 2;
   END LOOP;
   l_query :=  l_query ||' UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(blob_col,2000,'||l_column_blob_length||')) column_number';
   l_query :=  l_query ||' FROM tbl_blobs WHERE id = ''File_Name''';

   BEGIN 
       EXECUTE IMMEDIATE 'DROP TABLE tbl_blob_cast_to_varchar PURGE';
   EXCEPTION WHEN OTHERS THEN
       NULL;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE tbl_blob_cast_to_varchar AS '||l_query||'';
END;
/

SELECT table_name,column_name,data_type,data_length FROM dba_tab_cols WHERE table_name ='TBL_BLOB_CAST_TO_VARCHAR' ORDER BY column_id;
/*
TABLE_NAME               COLUMN_NAME   DATA_TYPE DATA_LENGTH
------------------------ ------------- --------- -----------
TBL_BLOB_CAST_TO_VARCHAR COLUMN_1      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_2      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_3      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_4      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_5      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_6      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_7      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_8      VARCHAR2         4000
TBL_BLOB_CAST_TO_VARCHAR COLUMN_NUMBER VARCHAR2         4000
*/

SELECT Count(*) total_records_count FROM tbl_blob_cast_to_varchar;
/*
TOTAL_RECORDS_COUNT
-------------------
                  1
*/

20.Write a syntax to load the "size.txt" file contains in oracle table using size delimited.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
-- Size Delimited
-- Drop the table permanently
DROP TABLE ZZZ_SIZE PURGE;
CREATE TABLE ZZZ_SIZE
(
  COL_1        char(5),
  COL_2        char(5),
  COL_3        char(5),
  COL_4        char(5),
  COL_5        char(5),
  COL_6        char(5),
  COL_7        char(5),
  COL_8        char(5),
  COL_9        char(5)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIRECTORY_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS
    (
      COL_1     position(1:5)   char(5),
      COL_2     position(6:11)  char(5),
      COL_3     position(12:17) char(5),
      COL_4     position(18:23) char(5),
      COL_5     position(24:29) char(5),
      COL_6     position(30:35) char(5),
      COL_7     position(36:41) char(5),
      COL_8     position(42:47) char(5),
      COL_9     position(48:53) char(5)
    )

  )
  LOCATION ('size.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_SIZE;
/*
COL_1 COL_2 COL_3 COL_4 COL_5 COL_6 COL_7 COL_8 COL_9 
----- ----- ----- ----- ----- ----- ----- ----- ----- 
12345 12345 12345 12345 12345 12345 12345 12345 12345 
12345 12345 12345 12345 12345 12345 12345 12345 12345 
*/

21.Write a syntax to load the "tab.txt" file contains in oracle table using tab delimited.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
-- Tab Delimited
DROP TABLE ZZZ_TAB PURGE;
CREATE TABLE ZZZ_TAB
(
    COL_1      NUMBER(20),
    COL_2      NUMBER(20),
    COL_3      NUMBER(20),
    COL_4      NUMBER(20),
    COL_5      NUMBER(20),
    COL_6      NUMBER(20),
    COL_7      NUMBER(20),
    COL_8      NUMBER(20),
    COL_9      NUMBER(20),
    COL_10     NUMBER(20)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIRECTORY_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 2
    READSIZE 1048576
    FIELDS TERMINATED BY '\t'
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    MISSING FIELD VALUES ARE NULL
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('tab.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_TAB;
/*
COL_1 COL_2 COL_3 COL_4 COL_5 COL_6 COL_7 COL_8 COL_9 COL_10
----- ----- ----- ----- ----- ----- ----- ----- ----- ------
33333 33333 33333 33333 33333 33333 33333 33333 33333 33333
44444 44444 44444 44444 44444 44444 44444 44444 44444 44444
*/

22.Write a syntax to load the "comma.csv" file contains in oracle table using comma delimited with separate bad file logs and upload logs.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO SOURCE FILE DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

CREATE OR REPLACE DIRECTORY LOG_DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\logfile\';
-- GRANT TO SOURCE UPLOAD FILE LOGS DIRECTORY' --
GRANT READ,WRITE ON DIRECTORY LOG_DIRECTORY_NAME TO PUBLIC;

CREATE OR REPLACE DIRECTORY BAD_DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\badfile\';
-- GRANT TO SOURCE BAD FILE LOGS DIRECTORY' --
GRANT READ,WRITE ON DIRECTORY BAD_DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
DROP TABLE zzz_comma PURGE;
CREATE TABLE zzz_comma
(
  col_1      VARCHAR2(255),
  col_2      VARCHAR2(255)
)
ORGANIZATION EXTERNAL               --defination of external table.
(
  TYPE ORACLE_LOADER                --type of oracle loader to load the data from csv in external table.
  DEFAULT DIRECTORY DIRECTORY_NAME  --defined directory.
  ACCESS PARAMETERS                 -- defined parameters.
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    logfile LOG_DIRECTORY_NAME :'Log_File.Log'
    badfile BAD_DIRECTORY_NAME :'Bad_File.bad'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION('comma.csv')
)REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM zzz_comma;
/*
COL_1 COL_2
----- -----
AAAAA BBBBB
CCCCC DDDDD
*/

23.Write an anonymous block to write all records with column name in file “employees.csv” of source the table “hr. employees” and describe.
-- Connect as sysdba
-- Create A Directory and Grant on DIRECTORY
CREATE DIRECTORY DIRECTORY_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';
-- GRANT TO SOURCE FILE DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Connect as UserName/UserPassword
DECLARE
    l_inhandler utl_file.file_type;
    l_outhandle VARCHAR2(32767);
BEGIN
    l_inhandler := utl_file.fopen('DIRECTORY_NAME','employees.csv','W');
    l_outhandle := 'employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id';
    utl_file.put_line(l_inhandler,l_outhandle);
    FOR l_i IN (SELECT * FROM hr.employees ORDER BY 1)
    LOOP
        utl_file.put_line(l_inhandler,l_i.employee_id||','||l_i.first_name||','||l_i.last_name||','||l_i.email||','||l_i.phone_number||','||l_i.hire_date||','||l_i.job_id||','||l_i.salary||','||l_i.commission_pct||','||l_i.manager_id||','||l_i.department_id);
    END LOOP;
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_inhandler);
END;
/

24.Write a program to dynamically take the input data and oracle query into the oracle variable and describe the mechanism. 
DROP TABLE t1 PURGE;
CREATE TABLE t1
(
col_1 VARCHAR2(10)
);

DECLARE
     l_data    VARCHAR2(200) := 'asdf';
     l_query   VARCHAR2(200);
BEGIN
    -- To drop the table if exists
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE t1 PURGE';
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;

    -- To Create table
    l_query := 'CREATE TABLE t1
                (
                col_1 VARCHAR2(10)
                )';

    EXECUTE IMMEDIATE (l_query);

    -- To Load the same data 10 times
    FOR i IN 1..10
    loop
       EXECUTE IMMEDIATE 'INSERT INTO t1 values ('''||l_data||''')';
    END loop;

    -- To print the data
    FOR i IN (SELECT col_1 FROM t1)
    LOOP
       Dbms_Output.Put_Line(i.col_1);
    END LOOP;

EXCEPTION WHEN No_Data_Found THEN
dbms_output.put_line(SQLERRM);
END;
/

25.Write an anonymous block to fetch the running environment of oracle user sessions and elaborate.(Search from Internet: Oracle sys_context)
DECLARE
    l_sql                  VARCHAR2(32767);
    l_operation_time       VARCHAR2(500);
    l_session_user         VARCHAR2(500);
    l_current_schema       VARCHAR2(500);
    l_instance_name        VARCHAR2(500);
    l_db_name              VARCHAR2(500);
    l_sid                  VARCHAR2(500);
    l_identification_type  VARCHAR2(500);
    l_instance             VARCHAR2(500);
    l_isdba                VARCHAR2(500);
    l_server_host          VARCHAR2(500);
    l_hosts                VARCHAR2(500);
    l_ip_address           VARCHAR2(500);
    l_os_user              VARCHAR2(500);
BEGIN
    l_sql := 'SELECT 
                   SYSTIMESTAMP                                      operation_time,
                   SYS_CONTEXT(''USERENV'', ''SESSION_USER'')        session_user,
                   SYS_CONTEXT(''USERENV'', ''CURRENT_SCHEMA'')      current_schema,
                   SYS_CONTEXT(''USERENV'', ''INSTANCE_NAME'')       instance_name,
                   SYS_CONTEXT(''USERENV'', ''DB_NAME'')             db_name,
                   SYS_CONTEXT(''USERENV'', ''SID'')                 sid,
                   SYS_CONTEXT(''USERENV'', ''IDENTIFICATION_TYPE'') identification_type,
                   SYS_CONTEXT(''USERENV'', ''INSTANCE'')            instance,
                   SYS_CONTEXT(''USERENV'', ''ISDBA'')               isdba,
                   SYS_CONTEXT(''USERENV'', ''SERVER_HOST'')         server_host,
                   SYS_CONTEXT(''USERENV'', ''HOST'')                hosts,
                   SYS_CONTEXT(''USERENV'', ''IP_ADDRESS'')          ip_address,
                   SYS_CONTEXT(''USERENV'', ''OS_USER'')             os_user
              FROM
                  dual';
    EXECUTE IMMEDIATE l_sql INTO l_operation_time,
                                 l_session_user,
                                 l_current_schema,
                                 l_instance_name,
                                 l_db_name,
                                 l_sid,
                                 l_identification_type,
                                 l_instance,
                                 l_isdba,
                                 l_server_host,
                                 l_hosts,
                                 l_ip_address,
                                 l_os_user;
   dbms_output.put_line(l_operation_time||', '||l_session_user||', '||l_current_schema||', '||l_instance_name||', '||l_db_name||', '||l_sid||', '
                        ||l_identification_type||', '||l_instance||', '||l_isdba||', '||l_server_host||', '||l_hosts||', '||l_ip_address||', '||l_os_user);
END;
/
-- Out Put
/*                                                                                                                    
05-MAR-20 03.36.04.097000 AM -08:00, SYS, SYS, orcl, orcl, 24, LOCAL, 1, TRUE, win-75ffjisu2h9, WORKGROUP\WIN-75FFJISU2H9, 127.0.0.1, Administrator
*/

26.Write an anonymous block to show the use of global, local and constant variable declaration in oracle and describe.
DECLARE
    -- Global Variable Declaration
    g_message      VARCHAR2(100) := 'a' ;
BEGIN
    dbms_output.put_line(g_message);

    DECLARE 
       -- Local Variable Declaration
       l_message VARCHAR2(100) := 'b';
    BEGIN
        dbms_output.put_line(l_message);
    END;
    
    dbms_output.put_line(g_message);
END;
/

/*
a                             
b                             
a                               
*/

DECLARE
      l_message  CONSTANT VARCHAR2(5) := 'PASS';
BEGIN
    l_message  :=  'FAIL';
    dbms_output.put_line(l_message);
END;
/
/*
ORA-06550: line 4, column 5:
PLS-00363: expression 'l_message' cannot be used as an assignment target
ORA-06550: line 4, column 5:
PL/SQL: Statement ignored
*/

27.Write an anonymous block to represent the use of character manipulation function with condition over input data and explain. 
DECLARE
    l_string      VARCHAR2 (100) :='First_Name Middle_Name Last_Name';
    l_first_name  VARCHAR2(30);
    l_middle_name VARCHAR2(30);
    l_last_name   VARCHAR2(30);
BEGIN
    dbms_output.put_line('Input Name:          '||l_string);
    l_first_name  := SubStr(l_string,1,InStr(l_string,' ',1,1)-1);
    l_middle_name := SubStr(SubStr(l_string,InStr(l_string,' ',1,1)+1),1,InStr(SubStr(l_string,InStr(l_string,' ',1,1)+1),' ')-1);
    l_last_name   := SUBSTR(l_string,INSTR(l_string,' ',1,2)+1);

    IF (l_first_name ='First_Name') THEN 
        Dbms_Output.Put_Line('Input First_Name: '||l_first_name);
    END IF;
    IF (l_middle_name='Middle_Name') THEN
        Dbms_Output.Put_Line('Input Middle_Name: '||l_middle_name);
    END IF;
    IF (l_last_name='Last_Name') THEN 
       Dbms_Output.Put_Line('Input LastName:   '||l_last_name);
    END IF;
END;
/

/*
Input Name:       First_Name Middle_Name Last_Name
Input First_Name: First_Name
Input Middle_Name: Middle_Name
Input LastName:   Last_Name
*/