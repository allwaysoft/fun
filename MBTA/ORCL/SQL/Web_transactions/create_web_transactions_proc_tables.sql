set serveroutput on size 1000000

alter session set nls_date_format = "MM-DD-YYYY HH24:MI:SS"
/

drop table mbta_email_list
/

drop table mbta_email_object_ref
/

drop sequence mbta_email_seq
/

CREATE SEQUENCE mbta_email_seq
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    NOCACHE
/    

create table mbta_email_list (mel_sequence number not null enable
                            , mel_emp_id varchar2(50)
                            , mel_emp_contractor varchar2(1)
                            , mel_first_name varchar2(100)
                            , mel_middle_name varchar2(100)
                            , mel_last_name varchar2(100)
                            , mel_emp_status varchar2(1)
                            , mel_dept_id varchar2(50)                            
                            , mel_dept_name varchar2(50)
                            , mel_job_code varchar2(50)                            
                            , mel_job_title varchar2(50)
                            , mel_email_id varchar2(100) not null enable
                            , mel_create_date date default sysdate
                            , mel_create_db_user varchar2(50) default sys_context('USERENV', 'SESSION_USER')
                            , mel_create_host varchar2(100) default SYS_CONTEXT('USERENV','HOST') 
                             )
/


comment on table mbta_email_list is 'Contains data related to email id''s of mbta employees and contractors.'
/
comment on column mbta_email_list.mel_sequence is 'This is auto generated number from sequence mbta_email_seq. "mbta_email_seq.nextval" has to be used to populate this column, when ever data is inserted in to this table.'
/
comment on column mbta_email_list.mel_emp_id is 'Id of employee/contractor.'
/
comment on column mbta_email_list.mel_emp_contractor is 'Employee or contractor or an email group, Stores E or C or G. E: Employee, C: Contractor, G: Group'
/
comment on column mbta_email_list.mel_first_name is 'First name of the employee/contractor.'
/
comment on column mbta_email_list.mel_middle_name is 'Middle name of employee/contractor.'
/
comment on column mbta_email_list.mel_last_name is 'Last name of employee/contractor.'
/
comment on column mbta_email_list.mel_emp_status is 'Status of employee/contracotr, Stores A or I. A: Active, I: Inactive.'
/
comment on column mbta_email_list.mel_dept_id is 'Department number of the employee/contractor.'
/
comment on column mbta_email_list.mel_dept_name is 'Department name of the employee/contractor.'
/
comment on column mbta_email_list.mel_job_code is 'Job code of employee/contractor.'
/
comment on column mbta_email_list.mel_job_title is 'Job title of employee/contractor.'
/
comment on column mbta_email_list.mel_email_id is 'Email id of employee/contractor.'
/
comment on column mbta_email_list.mel_create_date is 'Date of record insertion in to table.'
/
comment on column mbta_email_list.mel_create_db_user is 'Oracle user who inserted the record. Default''s to sys_context(''USERENV'', ''SESSION_USER'').'
/
comment on column mbta_email_list.mel_create_host is 'Machine used to insert the record. Default''s to SYS_CONTEXT(''USERENV'',''HOST'').'
/

CREATE UNIQUE INDEX PK_mbta_email_list ON mbta_email_list
(mel_sequence)
/

ALTER TABLE mbta_email_list ADD (
  --
  CONSTRAINT CK1_mbta_email_list 
  UNIQUE (mel_emp_id,mel_emp_status,mel_email_id),
  --
  CONSTRAINT CK2_mbta_email_list
  CHECK (mel_emp_status in ('A','I')),
  --
  CONSTRAINT CK3_mbta_email_list
  CHECK (mel_email_id like ('%@%.%')),
  --
  CONSTRAINT PK_mbta_email_list
  PRIMARY KEY
  (mel_sequence)
  USING INDEX PK_mbta_email_list)
/


insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'69428','E','GARY','S','FOSTER','A','031','Information Technology Opers','221600','Chief Technology Officer','gfoster@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'67410','E','ADAM','','VENEZIANO','A','031','Information Technology Opers','229400','Dpty Dir Enterprise Apps','AVeneziano@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'DBADMIN','G','DBADMIN','DBADMIN','DBADMIN','A','031','Information Technology Opers','','','dbadmin@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'DATABASE','G','DATABASE','DATABASE','DATABASE','A','031','Information Technology Opers','','','database@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'15801','E','JOHN','R','WIESMAN','A','031','Information Technology Opers','822200','Mgr Database Admin','jwiesman@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'KPABBA','C','KRANTHI','K','PABBA','A','031','Information Technology Opers','','','kpabba@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'66259','E','CABOT','P','RAYMOND','A','031','Information Technology Opers','821500','Mgr Data Administration','craymond@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id) 
select mbta_email_seq.nextval,'16779','E','SCOTT','A','HENDERSON','A','838','Automated Fare Collection','834300','Mgr Proj - AFC Systems','shenderson@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'68141','E','ROBERT','S','CREEDON','A','838','Automated Fare Collection','245000','Dpty Dir Fare Systems','rcreedon@mbta.com' from dual
/

insert into mbta_email_list(mel_sequence,mel_emp_id,mel_emp_contractor,mel_first_name,mel_middle_name,mel_last_name
                           ,mel_emp_status,mel_dept_id,mel_dept_name,mel_job_code,mel_job_title,mel_email_id)
select mbta_email_seq.nextval,'70907','E','ERIC','M','BROWNE','A','838','Automated Fare Collection','703100','Administrator,AFC System','ebrowne@mbta.com' from dual
/

create table mbta_email_object_ref (meor_emp_id varchar2(50)
                               , meor_object_owner varchar2(30)
                               , meor_object_id number
                               , meor_object_name varchar2(30) 
                                )
/

comment on table mbta_email_object_ref is 'Contains data about different DB objects(pakages, procedures...) and corresponding list of employees who recieve emails from those object.'
/
comment on column mbta_email_object_ref.meor_emp_id is 'Employee id of a person to which email from a DB object will be sent.'
/
comment on column mbta_email_object_ref.meor_object_owner is 'DB user name of the DB object from which email will be sent.'
/
comment on column mbta_email_object_ref.meor_object_id is 'Object id of the DB object from which email will be sent.'
/
comment on column mbta_email_object_ref.meor_object_name is 'Name of the DB object from which email will be sent.'
/

CREATE UNIQUE INDEX PK_mbta_email_obj_ref ON mbta_email_object_ref
(meor_emp_id,meor_object_owner,meor_object_id)
/

ALTER TABLE mbta_email_object_ref ADD (
  --
  CONSTRAINT PK_mbta_email_obj_ref
  PRIMARY KEY
  (meor_emp_id,meor_object_owner,meor_object_id)
  USING INDEX PK_mbta_email_obj_ref
                                   )
/




CREATE OR REPLACE PROCEDURE SP_EMAIL_ACTIONLIST_TRNS_MBTA(P_TRANS_TIME_DIFF NUMBER)
IS
V_RECENT_TRANS_TIME DATE;
V_TRANS_TIME_DIFF NUMBER;
crlf varchar2(2):= chr(13) || chr(10);

TYPE email_type is table of varchar2(32000) index by binary_integer;
v_email_val email_type;

cursor email_cur is select mel.mel_email_id email_id 
from mbta_email_list mel , mbta_email_object_ref meor
where mel.mel_emp_id = meor.meor_emp_id
and mel_emp_status = 'A'
and MEOR.MEOR_OBJECT_OWNER = sys_context('USERENV', 'SESSION_USER')
and MEOR.MEOR_OBJECT_NAME = 'SP_EMAIL_ACTIONLIST_TRNS_MBTA'; 

BEGIN

-- This Procedure takes a number as input parameter,it will be considered as number of hours. 
-- If there hasn't been a transaction with in that number of hours, an email will be sent out raising an alert.
-- This procedure is scheduled to run every 15 mins, checking for the transactions in the table.    

V_TRANS_TIME_DIFF := P_TRANS_TIME_DIFF;

SELECT MAX(TIMENEW) INTO V_RECENT_TRANS_TIME 
FROM ACTIONLIST
WHERE USERNEW = 'OrderExecuter';

IF (SYSDATE-V_RECENT_TRANS_TIME)*24 > V_TRANS_TIME_DIFF
THEN

select mel.mel_email_id into v_email_val(1) from mbta_email_list mel where mel.mel_emp_id='DATABASE';

FOR email_rec IN email_cur
   LOOP
      if email_cur%rowcount = 1
      then
      v_email_val(2) := email_rec.email_id; 
      else
      v_email_val(2) := v_email_val(2) || ',' || email_rec.email_id;
      end if;
   END LOOP;

v_email_val(3) := 'Alert: No "OrderExecuter" Transaction in ACTIONLIST Table, in the past ' || V_TRANS_TIME_DIFF || ' Hrs!';
v_email_val(4) := 'Hi, '
                  || crlf || crlf
                  ||'Please be advised that the last "Order Executer" transaction inserted in to ACTIONLIST table in production AFC CCS DB was at ' 
                  ||to_char(V_RECENT_TRANS_TIME, 'mm-dd-yyyy hh:mi:ss AM')
                  ||'.'
                  || crlf || crlf                  
                  ||'Reply to this email for any further questions.'
                  || crlf || crlf
                  ||'Thanks! ';                  

--send_mail_mbta(v_email_val(1),v_email_val(2),v_email_val(3),v_email_val(4));

dbms_output.put_line(v_email_val(2));

ELSE
NULL;
END IF;
  
exception
 when others
 then
   raise_application_error(-20001,  substr(sqlerrm, 1, 2048-20));  
END;
/

insert into mbta_email_object_ref (meor_emp_id, meor_object_owner, meor_object_id, meor_object_name)
select mel.mel_emp_id, owner, object_id, object_name 
from all_objects, mbta_email_list mel  
where owner = 'MBTA'
--and mel_emp_status = 'A' 
--and mel_emp_id not in ('DBADMIN','KRANTHI')
and (mel_dept_id = '838' or mel_emp_id = 'DATABASE')
and object_name = 'SP_EMAIL_ACTIONLIST_TRNS_MBTA'
/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'SP_EMAIL_ACTIONLIST_TRNS_MBTA(6);'
   ,next_date => sysdate
   ,interval  => '/*15:mnts*/ sysdate+1/24/60*15'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/