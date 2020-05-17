execute dbms_system.set_boo_param_in_session(305, 163,'timed_statistics',true); 

execute dbms_system.set_ev(305, 163, 10046, 8, ' ');

execute dbms_support.start_trace_in_session(305, 163, waits=>true, binds=>false); 




execute dbms_support.stop_trace_in_session(305, 163);


BEGIN
loop
Delete from jcjobcat WHERE jcat_comp_code not in ('ZZ') and rownum < 1000;
exit when SQL%rowcount < 999;
end loop;
END;



select count(*)
from jcjobcat;

alter table PYEMPLOYEE_TABLE disable constraint EMPLOYEE_JCJOBCAT_FK
alter table PYEMPLOYEE_TABLE enable constraint EMPLOYEE_JCJOBCAT_FK


Owner: DA, Trigger Name: DBTA_PYEMPPAYHIST
----------------------------------------
ns.p_audit('Z','I','PYEMPPAYHIST',:new.PHY__IU__create_date,:new.PHY__IU__create

========================================
Owner: DA, Trigger Name: DBTA_PYEMPPAYHIST_ADJUSTMENT
----------------------------------------
ns.p_audit('Z','I','PYEMPPAYHIST_ADJUSTMENT',:new.PHY__IU__create_date,:new.PHY_

========================================
Owner: DA, Trigger Name: DBTA_PYEMPPAYHIST_REDISTRIBUTE
----------------------------------------
ns.p_audit('Z','I','PYEMPPAYHIST_REDISTRIBUTE_COST',:new.PHY__IU__create_date,:n

========================================
Owner: DA, Trigger Name: DBTA_PYEMPPAYHIST_PYEPHIST_AUD
----------------------------------------
ns.p_audit('Z','I','PYEMPPAYHIST_PYEPHIST_AUDIT',:new.PHY__IU__create_date,:new.

BEGIN

FOR X IN
(
SELECT TABLE_NAME, CONSTRAINT_NAME
 FROM USER_CONSTRAINTS
-- WHERE CONSTRAINT_TYPE = 'R' and TABLE_NAME = 'JCJOBCAT'
WHERE CONSTRAINT_TYPE = 'R' and TABLE_NAME = 'PYEMPTIMSHT'
-- ORDER BY TABLE_NAME
)
LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE '||X.TABLE_NAME||' DISABLE CONSTRAINT '||X.CONSTRAINT_NAME;
END LOOP;

END;

WHERE CONSTRAINT_TYPE = 'R' and TABLE_NAME = 'PYEMPLOYEE_TABLE'
WHERE CONSTRAINT_TYPE = 'R' and TABLE_NAME = 'PYEMPTIMSHT'
WHERE CONSTRAINT_TYPE = 'R' and TABLE_NAME = 'SCDETAIL'

DA.PYEMPTIMSHT_JCJOBCAT_FK
DA.SCDETAIL_JCJOBCAT_FK/