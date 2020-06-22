
PROMPT PROCESSING, PLEASE WAIT. Check DA1.ERRORS table for any messages.
PROMPT

set serveroutput on size 1000000 format word_wrapped;
set wrap ON;

Declare

v_sqlstmt   varchar2(10000);
v_err_cnt        number; 
v_cnt            number;
v_glnum          number;
v_cnt_tab        VARCHAR2(32767);
v_dc_tab_name    VARCHAR2(32767);
v_tabs_rem       VARCHAR2(32767);
V_TAB_NAME       VARCHAR2(32767);
v_err_strng      VARCHAR2(32767);
errors_in_data   EXCEPTION;

begin

--delete from da1.errors;

--delete from gledger;
--commit;

select count(1) into v_cnt from da.dc_gledger;
v_dc_tab_name := 'DC_GLEDGER';

select distinct gl_num into v_glnum from da.dc_gledger;

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('GLEDGER');
v_tab_name := 'GLEDGER';
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_GLEDGER' ;

 if v_err_cnt <> 0
  then
/*    
    select count(1) into v_cnt 
    from GLEDGER ;
    v_cnt_tab := v_cnt||' into GLEDGER ';
  else
*/
    raise errors_in_data;
 end if;
end if;

        dbms_output.put_line(chr(9));
	DBMS_OUTPUT.PUT_LINE('Successfully Inserted, COMMIT complete. Look DA1.ERRORS table');

	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ers_rownum, ers_description) 
	values(v_glnum,'GLEDGER', v_cnt, '---SUCCESSFUL---No Errors while running the VERIFY script');

	commit;

exception

when no_data_found
then 
	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM, ers_description) 
	values(v_glnum, 'DC_GLEDGER', 0, 'No records in table: '||v_dc_tab_name);
	commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Error type is inserted into table: DA1.ERRORS');

when errors_in_data
then 
dbms_output.put_line(chr(9));
	INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM,ers_err_type, ers_column_name, ers_description) 
	select (select distinct gl_num from da.dc_gledger),'DC_GLEDGER',0, dcerr_err_type, dcerr_column_name,                dcerr_description 
        from dc_error
        where upper(dcerr_table_name) = 'DC_GLEDGER'
        and rownum < 2001
        group by DCERR_err_TYPE, Dcerr_column_name, dcerr_description;
	commit;
DBMS_OUTPUT.PUT_LINE('2000 errors are inserted into table: DA1.ERRORS');

when others
then  
	v_err_strng:=SQLERRM;
        INSERT into da1.errors(ers_order, ERS_TABLE_NAME, ERS_ROWNUM, ers_description) 
	values(v_glnum, 'DC_GLEDGER', 0,'Error: '||v_err_strng||'.');
	commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Error type is inserted into table: DA1.ERRORS');

end;
/