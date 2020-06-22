
PROMPT PROCESSING, PLEASE WAIT

set serveroutput on size 1000000 format word_wrapped;
set wrap ON;

Declare

v_sqlstmt   varchar2(10000);
v_err_cnt        number; 
v_cnt            number;
v_cnt_tab        VARCHAR2(32767);
v_dc_tab_name    VARCHAR2(32767);
v_tabs_rem       VARCHAR2(32767);
V_TAB_NAME       VARCHAR2(32767);
v_err_strng      VARCHAR2(32767);
errors_in_data   EXCEPTION;

begin

delete from da1.errors;
commit;

select count(1) into v_cnt from da.dc_jcdetail;
v_dc_tab_name := 'DC_JCDETAIL';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCDETAIL');
v_tab_name := 'JCDETAIL';
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCDETAIL' ;

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCDETAIL 
    where jcdt_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt||' into JCDETAIL ';
  else
    raise errors_in_data;
 end if;
end if;

dbms_output.put_line(chr(9));
	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ers_description) 
	values(1,'JCDETAIL', '---SUCCESSFUL---No Errors while running the script CADCUSTOM_VERIFY.SQL');
	DBMS_OUTPUT.PUT_LINE('Successfully Inserted');
	commit;

exception

when no_data_found
then 
	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM, ers_description) 
	values(1, 'JCDETAIL', -20100, 'No records in table: '||v_dc_tab_name);
	commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Error type is inserted into table: DA1.ERRORS');

when errors_in_data
then 
dbms_output.put_line(chr(9));
	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM,ers_err_type, ers_column_name, ers_description) 
	select 1,'JCDETAIL',-2101, dcerr_err_type, dcerr_column_name, dcerr_description 
        from dc_error
        where upper(dcerr_table_name) = 'DC_JCDETAIL'
        and rownum < 2001
        group by DCERR_err_TYPE, Dcerr_column_name, dcerr_description;
	commit;
DBMS_OUTPUT.PUT_LINE('2000 errors are inserted into table: DA1.ERRORS');

when others
then  
	v_err_strng:=SQLERRM;
        INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM, ers_description) 
	values(1, 'JCDETAIL', -20102,'Error: '||v_err_strng||'.');
	commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Error type is inserted into table: DA1.ERRORS');

end;
/