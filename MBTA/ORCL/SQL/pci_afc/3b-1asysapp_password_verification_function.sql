Rem
Rem	
Rem Below script is modified from version of default script (utlpwdmg.sql) provided by 
Rem Oracle
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    kpabba      03/20/12 - Commented out unnecessary parts of the script for this function
Rem
Rem

SET ECHO OFF

SET VERIFY OFF

---------- Start Part-1 ---------

--accept connect_env prompt 'Connect as SYS, this function must be created in SYS schema to . --Example:- sys/pswd@sid as sysdba:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

--connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/sysapp_pass_verify_func.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

-- This script sets the default password resource parameters
-- This script needs to be run to enable the password features.
-- However the default resource parameters can be changed based 
-- on the need.
-- A default password complexity function is also provided.
-- This function makes the minimum complexity checks like
-- the minimum length of the password, password not same as the
-- username, etc. The user may enhance this function according to
-- the need.
-- This function must be created in SYS schema.
-- connect sys/<password> as sysdba before running the script

CREATE OR REPLACE FUNCTION mbta_sysapp_verify_function
(username varchar2,
  password varchar2,
  old_password varchar2)
  RETURN boolean IS 
   n boolean;
   m integer;
   differ integer;
   isdigit boolean;
   ischar  boolean;
   ispunct boolean;
--   digitarray varchar2(20);
--   punctarray varchar2(52);
   chararray varchar2(52);
--   uchararray varchar2(52);

BEGIN 
--   digitarray:= '0123456789';
   chararray:= 'abcdefghijklmnopqrstuvwxyz';
--   uchararray:= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
--   punctarray:='!@"#$%&()``*+,-~|\/:;<=>''.?_{}[]';

   -- Check if the password is same as the username
   IF NLS_LOWER(password) = NLS_LOWER(username) THEN
     raise_application_error(-20001, 'Password same as or similar to user');
   END IF;

   -- Check for the minimum length of the password
   IF length(password) < 5 THEN
      raise_application_error(-20002, 'Password length less than 8');
   END IF;

   -- Check if the password is too simple. A dictionary of words may be
   -- maintained and a check may be made so as not to allow the words
   -- that are too simple for the password.
   IF NLS_LOWER(password) IN ('welcome', 'database', 'account', 'user', 'password', 'oracle', 'computer', 'abcd') THEN
      raise_application_error(-20002, 'Password too simple');
   END IF;

   -- Check if the password contains at least one letter, one digit and one
   -- punctuation mark.
   
   -- 2. Check for the character
   <<findchar>>
   ischar:=FALSE;
   FOR i IN 1..length(chararray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(chararray,i,1) THEN
            ischar:=TRUE;
             GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;
   IF ischar = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one digit, one upper and one lower case character and a punctuation');
   END IF;   
/*  
   -- 1. Check for the digit
   isdigit:=FALSE;
   m := length(password);
   FOR i IN 1..100 LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(digitarray,i,1) THEN
            isdigit:=TRUE;
             GOTO findchar;
         END IF;
      END LOOP;
   END LOOP;
   IF isdigit = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least 1 digit, 1 upper and 1 lower case character and a punctuation');
   END IF;

   -- 3. Check for the punctuation
   <<findpunct>>
   ispunct:=FALSE;
   FOR i IN 1..length(punctarray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(punctarray,i,1) THEN
            ispunct:=TRUE;
             GOTO finduchar;
         END IF;
      END LOOP;
   END LOOP;
   IF ispunct = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one digit, one upper and one lower case character and a punctuation');
   END IF;
   -- 4. Check for the upper case character
   <<finduchar>>
   ischar:=FALSE;
   FOR i IN 1..length(uchararray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(uchararray,i,1) THEN
            ischar:=TRUE;
             GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;
   IF ischar = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one digit, one upper and one lower case character and a punctuation');
   END IF;
*/   

   <<endsearch>>
   
/*   -- Commented KP
   -- Check if the password differs from the previous password by at least
   -- 3 letters
   IF old_password IS NOT NULL THEN
     differ := length(old_password) - length(password);

     IF abs(differ) < 3 THEN
       IF length(password) < length(old_password) THEN
         m := length(password);
       ELSE
         m := length(old_password);
       END IF;

       differ := abs(differ);
       FOR i IN 1..m LOOP
         IF substr(password,i,1) != substr(old_password,i,1) THEN
           differ := differ + 1;
         END IF;
       END LOOP;

       IF differ < 3 THEN
         raise_application_error(-20004, 'Password should differ by at \
         least 3 characters');
       END IF;
     END IF;
   END IF;
   -- Everything is fine; return TRUE ; 
   
*/   -- End Commented KP
   RETURN(TRUE);
END;
/

/*    -- Commented KP
-- This script alters the default parameters for Password Management
-- This means that all the users on the system have Password Management
-- enabled and set to the following values unless another profile is 
-- created with parameter values set to different value or UNLIMITED 
-- is created and assigned to the user.

ALTER PROFILE DEFAULT LIMIT
PASSWORD_LIFE_TIME 60
PASSWORD_GRACE_TIME 10
PASSWORD_REUSE_TIME 1800
PASSWORD_REUSE_MAX UNLIMITED
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME 1/1440
PASSWORD_VERIFY_FUNCTION verify_function;

*/   -- End Commented KP

--
SET ECHO OFF
SPOOL OFF
SET TIMING OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------

exit;