/* 
Below script contains the following
1. Create a table which holds the newly created object name.
2. Create a Trigger in PSADMN schema to schedule a job which calls a procedure to grant permissions on newly created tables in PSADMN schema.
3. Create a procedure which is being called in trigger created in step 2.


*/ 
set echo on 
spool new_object_auto_grant.log

accept connect_env prompt 'Enter the login for the DB the script should run. Example:- DBADMIN/password@environment:'

connect &connect_env

--1.
DROP TABLE PSADMN.PS_MB_GRANT_PARMS
/
CREATE TABLE PSADMN.PS_MB_GRANT_PARMS (JOB_NO NUMBER, OBJECT_NAME VARCHAR2(128), OBJECT_TYPE VARCHAR2(128), CREATE_DATE DATE)
/

--2.
CREATE OR REPLACE TRIGGER PSADMN.TR_MB_DO_GRANT
      AFTER CREATE ON PSADMN.SCHEMA
      DECLARE
      V_JOB NUMBER;
      BEGIN
      IF ( ORA_DICT_OBJ_TYPE IN ('TABLE','VIEW'))
      THEN
      DBMS_JOB.SUBMIT( V_JOB, 'PSADMN.SP_MB_DO_GRANT(JOB);');
      INSERT INTO PSADMN.PS_MB_GRANT_PARMS(JOB_NO, OBJECT_NAME, OBJECT_TYPE, CREATE_DATE) VALUES(V_JOB, ORA_DICT_OBJ_NAME, ORA_DICT_OBJ_TYPE, SYSDATE);
      END IF;
      EXCEPTION WHEN OTHERS
                        THEN
                        RAISE_APPLICATION_ERROR(-20001, SUBSTR(SQLERRM,1,300));
     END;
   /

--3.
CREATE OR REPLACE PROCEDURE PSADMN.SP_MB_DO_GRANT(P_JOB NUMBER)
AS
V_SQL_STRNG1 VARCHAR2(200);
V_SQL_STRNG2 VARCHAR2(200);
V_SQL_STRNG3 VARCHAR2(200);
V_OBJECT_NAME USER_OBJECTS.OBJECT_NAME%TYPE;
EXP_NO_TABLE EXCEPTION;
PRAGMA EXCEPTION_INIT(EXP_NO_TABLE, -00942);
BEGIN

select OBJECT_NAME INTO V_OBJECT_NAME FROM PSADMN.PS_MB_GRANT_PARMS WHERE JOB_NO =P_JOB;

IF V_OBJECT_NAME is NULL 
    THEN 
    V_OBJECT_NAME := 'DUAL';
END IF;

--insert into t values(v_object_name);

V_SQL_STRNG1 := 'GRANT SELECT, INSERT, UPDATE, DELETE ON PSADMN.'||V_OBJECT_NAME||' TO PS_MB_SIUD'; 
V_SQL_STRNG2 := 'GRANT SELECT, INSERT, UPDATE ON PSADMN.'||V_OBJECT_NAME||' TO PS_MB_SIU '; 
V_SQL_STRNG3 := 'GRANT SELECT ON PSADMN.'||V_OBJECT_NAME||' TO PS_MB_S ';

EXECUTE IMMEDIATE V_SQL_STRNG1;
EXECUTE IMMEDIATE V_SQL_STRNG2;
EXECUTE IMMEDIATE V_SQL_STRNG3;

DELETE FROM PSADMN.PS_MB_GRANT_PARMS;

EXCEPTION WHEN EXP_NO_TABLE
                    THEN
                    NULL;
                 WHEN OTHERS
                    THEN
                     RAISE_APPLICATION_ERROR(-20002, SUBSTR(SQLERRM,1,300));
                    NULL;
END;
/
                                                                                          
spool off