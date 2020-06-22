CREATE OR REPLACE PACKAGE    CC_DBK_DC AS
  PROCEDURE Verify (p_table_name IN VARCHAR2);

  PROCEDURE Error ( p_table_name   in   VARCHAR2,
                    p_dc_rownum    in   NUMBER,
                    p_column_name  in   VARCHAR2,
                    p_error_type   in   VARCHAR2,
                    p_error_text   in   VARCHAR2 );


  PROCEDURE Display_status (p_table  	   in VARCHAR2,
                            P_Message_Text in VARCHAR2);

  PROCEDURE Delete_status (p_table      in VARCHAR2);

  PROCEDURE Output(text IN VARCHAR2);

END;
/


CREATE OR REPLACE PACKAGE BODY    CC_Dbk_Dc AS
--====================================================================
--Delete_status
--====================================================================
PROCEDURE Delete_status (P_table IN VARCHAR2) AS
BEGIN
   DELETE FROM da.dc_import_status
     WHERE UPPER(dcis_table_code) = UPPER(p_table);

EXCEPTION WHEN
        OTHERS THEN
                dbms_output.put_line('DC.DELETE_STATUS: Can not delete from da.dc_import_status table.');
                ROLLBACK;
                RAISE;
END Delete_status;

--====================================================================
--ERROR
--====================================================================
PROCEDURE Error ( p_table_name        VARCHAR2,
                    p_dc_rownum         NUMBER,
                    p_column_name       VARCHAR2,
                    p_error_type        VARCHAR2,
                    p_error_text        VARCHAR2 )
  IS
  BEGIN
    INSERT INTO da.dc_error
        (dcerr_table_name,      --1
         dcerr_rownum,          --2
         dcerr_column_name,     --3
         dcerr_err_type,       --4
         dcerr_description,     --5
         dcerr_date             --6
        )
     VALUES
        (p_table_name,          --1
         p_dc_rownum,           --2
         p_column_name,         --3
         p_error_type,          --4
         p_error_text,          --5
         SYSDATE                --6
        );
  EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('DC.ERROR: Can not insert into da.dc_error table.');
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
END Error;


--====================================================================
--DISPLAY_STATUS
--====================================================================

PROCEDURE Display_Status(P_Table IN VARCHAR2,
                         P_Message_Text IN VARCHAR2) IS
BEGIN
   dbms_output.put_line(P_Message_Text);

   INSERT INTO da.dc_import_status
                       (dcis_table_code  --1
                        ,dcis_message    --2
                        ,dcis_user       --3
                        ,dcis_date       --4
                        )
                VALUES
                        (P_Table         --1
                        ,P_Message_Text  --2
                        ,USER            --3
                        ,SYSDATE         --4
                        );
   EXCEPTION WHEN
          OTHERS THEN
                dbms_output.put_line('DC.DISPLAY_STATUS: Can not insert into da.dc_import_status table.');
                ROLLBACK;
                RAISE;
END Display_Status;

--====================================================================
--Output - procedure to output text using dbms_output
--====================================================================

PROCEDURE Output (text IN VARCHAR2) IS
BEGIN
        dbms_output.put_line(RPAD(text,255));
END output;

--====================================================================
--Verify
--====================================================================


PROCEDURE Verify (p_table_name VARCHAR2) IS

 t_up_table_name VARCHAR2(30) := UPPER (p_table_name) ;

BEGIN
     dbms_output.ENABLE(1000000);
/*
     IF NOT da.Dbk_Dc_Verify.verify(t_up_table_name) THEN
       RETURN;
     END IF;
*/
     IF (t_up_table_name = 'GLEDGER')
     THEN
         delete_status('DC_GLEDGER');
         display_status('DC_GLEDGER','GLEDGER table - checking');
         da.Dbk_Dc_Gledger.verify_data;
         da.Dbk_Dc_Gledger.Process_temp_data;
     ELSIF (t_up_table_name = 'BPARTNERS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPATRNERS');
         display_status('DC_BPARTNERS','BPARTNERS table - checking');
         da.Dbk_Dc_Bpartners.verify_bpartners;
         da.Dbk_Dc_Bpartners.Process_temp_data;
     ELSIF (t_up_table_name = 'BPVENDORS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPVENDORS');
         display_status('DC_BPVENDORS','BPVENDORS table - checking');
         da.Dbk_Dc_Bpvendors.verify_bpvendors;
         da.Dbk_Dc_Bpvendors.Process_temp_data;
     ELSIF (t_up_table_name = 'BPCUSTOMERS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPCUSTOMERS');
         display_status('DC_BPCUSTOMERS','BPCUSTOMERS table - checking');
         da.Dbk_Dc_Bpcustomers.verify_bpcustomers;
         da.Dbk_Dc_Bpcustomers.Process_temp_data;
     ELSIF (t_up_table_name = 'JCMPHS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCMPHS');
         display_status('DC_JCMPHS','JCMPHS table - checking');
         da.Dbk_Dc_Jcmphs.verify_data;
         da.Dbk_Dc_Jcmphs.Process_temp_data;
     ELSIF (t_up_table_name = 'JCMCAT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCMCAT');
         display_status('DC_JCMCAT','JCMCAT table - checking');
         da.Dbk_Dc_Jcmcat.verify_data;
         da.Dbk_Dc_Jcmcat.Process_temp_data;
     ELSIF (t_up_table_name = 'JCJOBCAT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCJOBCAT');
         display_status('DC_JCJOBCAT','JCJOBCAT table - checking');
         da.Dbk_Dc_Jcjobcat.verify_data;
         da.Dbk_Dc_Jcjobcat.Process_temp_data;
     ELSIF (t_up_table_name = 'JCDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCDETAIL');
         display_status('DC_JCDETAIL','JCDETAIL table - checking');
         da.Dbk_Dc_Jcdetail.verify_data;
         da.Dbk_Dc_Jcdetail.Process_temp_data;
     ELSIF (t_up_table_name = 'SCMAST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_SCMAST');
         display_status('DC_SCMAST','SCMAST table - checking');
         da.Dbk_Dc_Scmast.verify_data;
         da.Dbk_Dc_Scmast.Process_temp_data;
     ELSIF (t_up_table_name = 'SCDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_SCDETAIL');
         display_status('DC_SCDETAIL','SCDETAIL table - checking');
         da.Dbk_Dc_Scdetail.verify_data;
         da.Dbk_Dc_Scdetail.Process_temp_data;
     ELSIF (t_up_table_name = 'SCSCHED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_SCSCHED');
         display_status('DC_SCSCHED','SCSCHED table - checking');
         da.Dbk_Dc_Scsched.verify_data;
         da.Dbk_Dc_Scsched.Process_temp_data;
     ELSIF (t_up_table_name = 'VOUCHER')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_VOUCHER');
         display_status('DC_VOUCHER','VOUCHER table - checking');
         da.Dbk_Dc_Voucher.verify_data;
         da.Dbk_Dc_Voucher.Process_temp_data;
     ELSIF (t_up_table_name = 'CHEQUE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CHEQUE');
         display_status('DC_CHEQUE','CHEQUE table - checking');
         da.Dbk_Dc_Cheque.verify_data;
         da.Dbk_Dc_Cheque.Process_temp_data;
     ELSIF (t_up_table_name = 'VOUCHQ')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_VOUCHQ');
         display_status('DC_VOUCHQ','VOUCHQ table - checking');
         da.Dbk_Dc_Vouchq.verify_data;
         da.Dbk_Dc_Vouchq.Process_temp_data;
     ELSIF (t_up_table_name = 'PAYCHQ')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PAYCHQ');
         display_status('DC_PAYCHQ','PAYCHQ table - checking');
         da.Dbk_Dc_Paychq.verify_data;
         da.Dbk_Dc_Paychq.Process_temp_data;
     ELSIF (t_up_table_name = 'JCUTRAN')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCUTRAN');
         display_status('DC_JCUTRAN','JCUTRAN table - checking');
         da.Dbk_Dc_Jcutran.verify_data;
         da.Dbk_Dc_Jcutran.Process_temp_data;
     ELSIF (t_up_table_name = 'VOUDIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_VOUDIST');
         display_status('DC_VOUDIST','VOUDIST table - checking');
         da.Dbk_Dc_Voudist.verify_data;
         da.Dbk_Dc_Voudist.Process_temp_data;
     ELSIF (t_up_table_name = 'JCJOBHPHS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCJOBHPHS');
         display_status('DC_JCJOBHPHS','JCJOBHPHS table - checking');
         da.Dbk_Dc_Jcjobhphs.verify_data;
         da.Dbk_Dc_Jcjobhphs.Process_temp_data;
     ELSIF (t_up_table_name = 'JCJOB')
     THEN
        dbms_output.put_line('For validation of JCJOB_TABLE use JCJOB_TABLE parameter.');
     ELSIF (t_up_table_name = 'JCJOB_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCJOB_TABLE');
         display_status('DC_JCJOB_TABLE','JCJOB_TABLE table - checking');
         da.Dbk_Dc_Jcjob_Table.verify_data;
         da.Dbk_Dc_Jcjob_Table.Process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPLOYEE')
     THEN
        dbms_output.put_line('For validation of PYEMPLOYEE_TABLE use PYEMPLOYEE_TABLE parameter.');
     ELSIF (t_up_table_name = 'PYEMPLOYEE_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPLOYEE_TABLE');
         display_status('DC_PYEMPLOYEE_TABLE','PYEMPLOYEE_TABLE table - checking');
         da.Dbk_Dc_Pyemployee_Table.verify_data;
         da.Dbk_Dc_Pyemployee_Table.Process_temp_data;
     ELSIF (t_up_table_name = 'INVOICE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INVOICE');
         display_status('DC_INVOICE','INVOICE table - checking');
         da.CC_Dbk_Dc_Invoice.verify_data;
         da.CC_Dbk_Dc_Invoice.Process_temp_data;
     ELSIF (t_up_table_name = 'INVDIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INVDIST');
         display_status('DC_INVDIST','INVDIST table - checking');
         da.CC_Dbk_Dc_Invdist.verify_data;
         da.CC_Dbk_Dc_Invdist.Process_temp_data;
     ELSIF (t_up_table_name = 'PAYMENT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PAYMENT');
         display_status('DC_PAYMENT','PAYMENT table - checking');
         da.CC_Dbk_Dc_Payment.verify_data;
         da.CC_Dbk_Dc_Payment.Process_temp_data;
     ELSIF (t_up_table_name = 'INVPAY')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INVPAY');
         display_status('DC_INVPAY','INVPAY table - checking');
         da.CC_Dbk_Dc_Invpay.verify_data;
         da.CC_Dbk_Dc_Invpay.Process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPPAYHIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPPAYHIST');
         display_status('DC_PYEMPPAYHIST','PYEMPPAYHIST table - checking');
         da.Dbk_Dc_Pyemppayhist.verify_data;
         da.Dbk_Dc_Pyemppayhist.Process_temp_data;
     ELSIF (t_up_table_name = 'CMMAST_POSTED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMMAST_POSTED');
         display_status('DC_CMMAST_POSTED','CMMAST_POSTED table - checking');
         da.Dbk_Dc_Cmmast_Posted.verify_data;
         da.Dbk_Dc_Cmmast_Posted.Process_temp_data;
     ELSIF (t_up_table_name = 'CMMAST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMMAST');
         display_status('DC_CMMAST','CMMAST table - checking');
         da.Dbk_Dc_Cmmast.verify_data;
         da.Dbk_Dc_Cmmast.Process_temp_data;
     ELSIF (t_up_table_name = 'CMDETAIL_POSTED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMDETAIL_POSTED');
         display_status('DC_CMDETAIL_POSTED','CMDETAIL_POSTED table - checking');
         da.Dbk_Dc_Cmdetail_Posted.verify_data;
         da.Dbk_Dc_Cmdetail_Posted.Process_temp_data;
     ELSIF (t_up_table_name = 'CMDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMDETAIL');
         display_status('DC_CMDETAIL','CMDETAIL table - checking');
         da.Dbk_Dc_Cmdetail.verify_data;
         da.Dbk_Dc_Cmdetail.Process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPTIMSHT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPTIMSHT');
         display_status('DC_PYEMPTIMSHT','PYEMPTIMSHT table - checking');
         da.Dbk_Dc_Pyemptimsht.verify_data;
         da.Dbk_Dc_Pyemptimsht.Process_temp_data;
     ELSIF (t_up_table_name = 'BUDGMAST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BUDGMAST');
         display_status('DC_BUDGMAST','BUDGMAST table - checking');
         da.Dbk_Dc_Budgmast.verify_data;
         da.Dbk_Dc_Budgmast.Process_temp_data;
     ELSIF (t_up_table_name = 'BUDGET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BUDGET');
         display_status('DC_BUDGET','BUDGET table - checking');
         da.Dbk_Dc_Budget.verify_data;
         da.Dbk_Dc_Budget.Process_temp_data;
     ELSIF (t_up_table_name = 'INVMEMO')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INVMEMO');
         display_status('DC_INVMEMO','INVMEMO table - checking');
         da.Dbk_Dc_Invmemo.verify_data;
         da.Dbk_Dc_Invmemo.Process_temp_data;
     ELSIF (t_up_table_name = 'INVRLSDET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INVRLSDET');
         display_status('DC_INVRLSDET','INVRLSDET table - checking');
         da.Dbk_Dc_Invrlsdet.verify_data;
         da.Dbk_Dc_Invrlsdet.Process_temp_data;
     ELSIF (t_up_table_name = 'JCTCAT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCTCAT');
         display_status('DC_JCTCAT','JCTCAT table - checking');
         da.Dbk_Dc_Jctcat.verify_data;
         da.Dbk_Dc_Jctcat.Process_temp_data;
     ELSIF (t_up_table_name = 'JCTPHS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCTPHS');
         display_status('DC_JCTPHS','JCTPHS table - checking');
         da.Dbk_Dc_Jctphs.verify_data;
         da.Dbk_Dc_Jctphs.Process_temp_data;
     ELSIF (t_up_table_name = 'PYWCBCODE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYWCBCODE');
         display_status('DC_PYWCBCODE','PYWCBCODE table - checking');
         da.Dbk_Dc_Pywcbcode.verify_data;
         da.Dbk_Dc_Pywcbcode.Process_temp_data;
     ELSIF (t_up_table_name = 'PYWCBRATE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYWCBRATE');
         display_status('DC_PYWCBRATE','PYWCBRATE table - checking');
         da.Dbk_Dc_Pywcbrate.verify_data;
         da.Dbk_Dc_Pywcbrate.Process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPHIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPHIST');
         display_status('DC_PYEMPHIST','PYEMPHIST table - checking');
         da.Dbk_Dc_Pyemphist.verify_data;
         da.Dbk_Dc_Pyemphist.Process_temp_data;
     ELSIF (t_up_table_name = 'EMACTUALLOCATION')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMACTUALLOCATION');
         display_status('DC_EMACTUALLOCATION','EMACTUALLOCATION table - checking');
         da.Dbk_Dc_Emactuallocation.verify_data;
         da.Dbk_Dc_Emactuallocation.Process_temp_data;
     ELSIF (t_up_table_name = 'VOUMEMO')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_VOUMEMO');
         display_status('DC_VOUMEMO','VOUMEMO table - checking');
         da.Dbk_Dc_Voumemo.verify_data;
         da.Dbk_Dc_Voumemo.Process_temp_data;
     ELSIF (t_up_table_name = 'VOURLSDET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_VOURLSDET');
         display_status('DC_VOURLSDET','VOURLSDET table - checking');
         da.Dbk_Dc_Vourlsdet.verify_data;
         da.Dbk_Dc_Vourlsdet.Process_temp_data;
     ELSIF (t_up_table_name = 'EMEQUIPMENT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQUIPMENT');
         display_status('DC_EMEQUIPMENT','EMEQUIPMENT table - checking');
         da.Dbk_Dc_Emequipment.verify_data;
         da.Dbk_Dc_Emequipment.Process_temp_data;
     ELSIF (t_up_table_name = 'EMEQPCOMTRAN')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQPCOMTRAN');
         display_status('DC_EMEQPCOMTRAN','EMEQPCOMTRAN table - checking');
         da.Dbk_Dc_Emeqpcomtran.verify_data;
         da.Dbk_Dc_Emeqpcomtran.Process_temp_data;
	ELSIF (t_up_table_name = 'EMEQPHCOMPON')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQPHCOMPON');
         display_status('DC_EMEQPHCOMPON','EMEQPHCOMPON table - checking');
         da.Dbk_Dc_Emeqphcompon.verify_data;
         da.Dbk_Dc_Emeqphcompon.Process_temp_data;
     ELSIF (t_up_table_name = 'EMLOCHIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMLOCHIST');
         display_status('DC_EMLOCHIST','EMLOCHIST table - checking');
         da.Dbk_Dc_Emlochist.verify_data;
         da.Dbk_Dc_Emlochist.Process_temp_data;
     ELSIF (t_up_table_name = 'EMTRAN')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMTRAN');
         display_status('DC_EMTRAN','EMTRAN table - checking');
         da.Dbk_Dc_Emtran.verify_data;
         da.Dbk_Dc_Emtran.Process_temp_data;
     ELSIF (t_up_table_name = 'EMDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMDETAIL');
         display_status('DC_EMDETAIL','EMDETAIL table - checking');
         da.Dbk_Dc_Emdetail.verify_data;
         da.Dbk_Dc_Emdetail.Process_temp_data;
     ELSIF (t_up_table_name = 'EMBALANCE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMBALANCE');
         display_status('DC_EMBALANCE','EMBALANCE table - checking');
         da.Dbk_Dc_Embalance.verify_data;
         da.Dbk_Dc_Embalance.Process_temp_data;
     ELSIF (t_up_table_name = 'EMCLASSRATE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMCLASSRATE');
         display_status('DC_EMCLASSRATE','EMCLASSRATE table - checking');
         da.Dbk_Dc_Emclassrate.verify_data;
         da.Dbk_Dc_Emclassrate.Process_temp_data;
     ELSIF (t_up_table_name = 'EMEQPRATE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQPRATE');
         display_status('DC_EMEQPRATE','EMEQPRATE table - checking');
         da.Dbk_Dc_Emeqprate.verify_data;
         da.Dbk_Dc_Emeqprate.Process_temp_data;
     ELSIF (t_up_table_name = 'EMEQPJOBRATE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQPJOBRATE');
         display_status('DC_EMEQPJOBRATE','EMEQPJOBRATE table - checking');
         da.Dbk_Dc_Emeqpjobrate.verify_data;
         da.Dbk_Dc_Emeqpjobrate.Process_temp_data;
     ELSIF (t_up_table_name = 'CIITEM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CIITEM');
         display_status('DC_CIITEM','CIITEM table - checking');
         da.Dbk_Dc_Ciitem.verify_data;
         da.Dbk_Dc_Ciitem.Process_temp_data;
     ELSIF (t_up_table_name = 'CISALEPRICE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CISALEPRICE');
         display_status('DC_CISALEPRICE','CISALEPRICE table - checking');
         da.Dbk_Dc_Cisaleprice.verify_data;
         da.Dbk_Dc_Cisaleprice.Process_temp_data;
     ELSIF (t_up_table_name = 'CICMPITEM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CICMPITEM');
         display_status('DC_CICMPITEM','CICMPITEM table - checking');
         da.Dbk_Dc_Cicmpitem.verify_data;
         da.Dbk_Dc_Cicmpitem.Process_temp_data;
     ELSIF (t_up_table_name = 'CIITEMHDR')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CIITEMHDR');
         display_status('DC_CIITEMHDR','CIITEMHDR table - checking');
         da.Dbk_Dc_Ciitemhdr.verify_data;
         da.Dbk_Dc_Ciitemhdr.Process_temp_data;
     ELSIF (t_up_table_name = 'CIITEMDET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CIITEMDET');
         display_status('DC_CIITEMDET','CIITEMDET table - checking');
         da.Dbk_Dc_Ciitemdet.verify_data;
         da.Dbk_Dc_Ciitemdet.Process_temp_data;
     ELSIF (t_up_table_name = 'CISTDCST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CISTDCST');
         display_status('DC_CISTDCST','CISTDCST table - checking');
         da.Dbk_Dc_Cistdcst.verify_data;
         da.Dbk_Dc_Cistdcst.Process_temp_data;
     ELSIF (t_up_table_name = 'BPADDRESSES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPADDRESSES');
         display_status('DC_BPADDRESSES','BPADDRESSES table - checking');
         da.Dbk_Dc_Bpaddresses.verify_data;
         da.Dbk_Dc_Bpaddresses.Process_temp_data;
     ELSIF (t_up_table_name = 'PYWCBJOB')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYWCBJOB');
         display_status('DC_PYWCBJOB','PYWCBJOB table - checking');
         da.Dbk_Dc_Pywcbjob.verify_data;
         da.Dbk_Dc_Pywcbjob.Process_temp_data;
     ELSIF (t_up_table_name = 'ACCOUNT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_ACCOUNT');
         display_status('DC_ACCOUNT','ACCOUNT table - checking');
         da.Dbk_Dc_Account.verify_data;
         da.Dbk_Dc_Account.Process_temp_data;
     ELSIF (t_up_table_name = 'POMAST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_POMAST');
         display_status('DC_POMAST','POMAST table - checking');
         da.Dbk_Dc_Pomast.verify_data;
         da.Dbk_Dc_Pomast.Process_temp_data;
     ELSIF (t_up_table_name = 'PODETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PODETAIL');
         display_status('DC_PODETAIL','PODETAIL table - checking');
         da.Dbk_Dc_Podetail.verify_data;
         da.Dbk_Dc_Podetail.Process_temp_data;
     ELSIF (t_up_table_name = 'POCOMAST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_POCOMAST');
         display_status('DC_POCOMAST','POCOMAST table - checking');
         da.Dbk_Dc_Pocomast.verify_data;
         da.Dbk_Dc_Pocomast.Process_temp_data;
     ELSIF (t_up_table_name = 'POCODET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_POCODET');
         display_status('DC_POCODET','POCODET table - checking');
         da.Dbk_Dc_Pocodet.verify_data;
         da.Dbk_Dc_Pocodet.Process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPSALSPL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPSALSPL');
         display_status('DC_PYEMPEMPSALSPL','PYEMPSALSPL table - checking');
         da.Dbk_Dc_Pyempsalspl.verify_data;
         da.Dbk_Dc_Pyempsalspl.Process_temp_data;
     ELSIF (t_up_table_name = 'HRCLASS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRCLASS');
         display_status('DC_HRCLASS','HRCLASS table - checking');
         da.Dbk_Dc_Hrclass.verify_data;
         da.Dbk_Dc_Hrclass.Process_temp_data;
     ELSIF (t_up_table_name = 'HRINTTRAINING')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRINTTRAINING');
         display_status('DC_HRINTTRAINING','HRINTTRAINING table - checking');
         da.Dbk_Dc_Hrinttraining.verify_data;
         da.Dbk_Dc_Hrinttraining.Process_temp_data;
     ELSIF (t_up_table_name = 'HRSUITPOS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRSUITPOS');
         display_status('DC_HRSUITPOS','HRSUITPOS table - checking');
         da.Dbk_Dc_Hrsuitpos.verify_data;
         da.Dbk_Dc_Hrsuitpos.Process_temp_data;
     ELSIF (t_up_table_name = 'HRAPPLICANTS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRAPPLICANTS');
         display_status('DC_HRAPPLICANTS','HRAPPLICANTS table - checking');
         da.Dbk_Dc_Hrapplicants.verify_data;
         da.Dbk_Dc_Hrapplicants.Process_temp_data;
     ELSIF (t_up_table_name = 'FAASSET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_FAASSET');
         display_status('DC_FAASSET','FAASSET table - checking');
         da.Dbk_Dc_Faasset.verify_data;
         da.Dbk_Dc_Faasset.Process_temp_data;
     ELSIF (t_up_table_name = 'PYCHECKS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYCHECKS');
         display_status('DC_PYCHECKS','PYCHECKS table - checking');
         da.Dbk_Dc_Pychecks.verify_data;
         da.Dbk_Dc_Pychecks.Process_temp_data;
     ELSIF (t_up_table_name = 'PYTAXEXM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYTAXEXM');
         display_status('DC_PYTAXEXM','PYTAXEXM table - checking');
         da.dbk_dc_pytaxexm.verify_data;
         da.dbk_dc_pytaxexm.process_temp_data;
     ELSIF (t_up_table_name = 'PYTAXEMP')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYTAXEMP');
         display_status('DC_PYTAXEMP','PYTAXEMP table - checking');
         da.dbk_dc_pytaxemp.verify_data;
         da.dbk_dc_pytaxemp.process_temp_data;
     ELSIF (t_up_table_name = 'HELP')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPSALSPL');
         display_status('DC_PYEMPSALSPL','PYEMPSALSPL table - checking');
         da.dbk_dc_pyempsalspl.verify_data;
         da.dbk_dc_pyempsalspl.process_temp_data;
     ELSIF (t_up_table_name = 'EMEQPTRAN_V')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMEQPTRAN_V');
         display_status('DC_EMEQPTRAN_V','EMEQPTRAN_V table - checking');
         da.dbk_dc_emeqptran_v.verify_data;
         da.dbk_dc_emeqptran_v.process_temp_data;
     ELSIF (t_up_table_name = 'EMRATEREVTYPE_V')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMRATEREVTYPE_V');
         display_status('DC_EMRATEREVTYPE_V','EMRATEREVTYPE_V table - checking');
         da.dbk_dc_emraterevtype_v.verify_data;
         da.dbk_dc_emraterevtype_v.process_temp_data;
     ELSIF (t_up_table_name = 'APPURCHASEAGREEMENT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_APPURCHASEAGREEMENT');
         display_status('DC_APPURCHASEAGREEMENT','APPURCHASEAGREEMENT table - checking');
         da.dbk_dc_appurchaseagreement.verify_data;
         da.dbk_dc_appurchaseagreement.process_temp_data;
     ELSIF (t_up_table_name = 'APPURCHASEAGREEMENTDET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_APPURCHASEAGREEMENTDET');
         display_status('DC_APPURCHASEAGREEMENTDET','APPURCHASEAGREEMENTDET table - checking');
         da.dbk_dc_appurchaseagreementdet.verify_data;
         da.dbk_dc_appurchaseagreementdet.process_temp_data;
     ELSIF (t_up_table_name = 'APMATERIALRECEIPT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_APMATERIALRECEIPT');
         display_status('DC_APMATERIALRECEIPT','APMATERIALRECEIPT table - checking');
         da.dbk_dc_apmaterialreceipt.verify_data;
         da.dbk_dc_apmaterialreceipt.process_temp_data;
     ELSIF (t_up_table_name = 'EMTRANPOST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMTRANPOST');
         display_status('DC_EMTRANPOST','EMTRANPOST table - checking');
         da.dbk_dc_emtranpost.verify_data;
         da.dbk_dc_emtranpost.process_temp_data;
     ELSIF (t_up_table_name = 'EMTRANDIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMTRANDIST');
         display_status('DC_EMTRANDIST','EMTRANDIST table - checking');
         da.dbk_dc_emtrandist.verify_data;
         da.dbk_dc_emtrandist.process_temp_data;
     ELSIF (t_up_table_name = 'JC_JOB_PHASE_PROJECTION')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JC_JOB_PHASE_PROJECTION');
         display_status('DC_JC_JOB_PHASE_PROJECTION','JC_JOB_PHASE_PROJECTION table - checking');
         da.dbk_dc_jc_job_phase_projection.verify_data;
         da.dbk_dc_jc_job_phase_projection.process_temp_data;
     ELSIF (t_up_table_name = 'DEPT_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_DEPT_TABLE');
         display_status('DC_DEPT_TABLE','DEPT_TABLE table - checking');
         da.dbk_dc_dept_table.verify_data;
         da.dbk_dc_dept_table.process_temp_data;
     ELSIF (t_up_table_name = 'PYTRADES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYTRADES');
         display_status('DC_PYTRADES','PYTRADES table - checking');
         da.dbk_dc_pytrades.verify_data;
         da.dbk_dc_pytrades.process_temp_data;
     ELSIF (t_up_table_name = 'PMPROJECT_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMPROJECT_TABLE');
         display_status('DC_PMPROJECT_TABLE','PMPROJECT_TABLE table - checking');
         da.dbk_dc_pmproject_table.verify_data;
         da.dbk_dc_pmproject_table.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPLEAVE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPLEAVE');
         display_status('DC_PYEMPLEAVE','PMPROJECT_TABLE table - checking');
         da.dbk_dc_pyempleave.verify_data;
         da.dbk_dc_pyempleave.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPLEAVEHIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPLEAVEHIST');
         display_status('DC_PYEMPLEAVEHIST','PMPROJECT_TABLE table - checking');
         da.dbk_dc_pyempleavehist.verify_data;
         da.dbk_dc_pyempleavehist.process_temp_data;
     ELSIF (t_up_table_name = 'ADDRESS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_ADDRESS');
         display_status('DC_ADDRESS','ADDRESS table - checking');
         da.dbk_dc_address.verify_data;
         da.dbk_dc_address.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPBEN')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPBEN');
         display_status('DC_PYEMPBEN','PYEMPBEN table - checking');
         da.dbk_dc_pyempben.verify_data;
         da.dbk_dc_pyempben.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPDED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPDED');
         display_status('DC_PYEMPDED','PYEMPDED table - checking');
         da.dbk_dc_pyempded.verify_data;
         da.dbk_dc_pyempded.process_temp_data;
     ELSIF (t_up_table_name = 'LOCATION_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_LOCATION_TABLE');
         display_status('DC_LOCATION_TABLE','LOCATION_tABLE table - checking');
         da.dbk_dc_location_table.verify_data;
         da.dbk_dc_location_table.process_temp_data;
     ELSIF (t_up_table_name = 'PMPROJPARTNER')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMPROJPARTNER');
         display_status('DC_PMPROJPARTNER','PMPROJPARTNER table - checking');
         da.dbk_dc_pmprojpartner.verify_data;
         da.dbk_dc_pmprojpartner.process_temp_data;
     ELSIF (t_up_table_name = 'PMPROJCONTACT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMPROJCONTACT');
         display_status('DC_PMPROJCONTACT','PMPROJCONTACT table - checking');
         da.dbk_dc_pmprojcontact.verify_data;
         da.dbk_dc_pmprojcontact.process_temp_data;
     ELSIF (t_up_table_name = 'DMISSUE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_DMISSUE');
         display_status('DC_DMISSUE','DMISSUE table - checking');
         da.dbk_dc_dmissue.verify_data;
         da.dbk_dc_dmissue.process_temp_data;
     ELSIF (t_up_table_name = 'PMRFI')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMRFI');
         display_status('DC_PMRFI','PMRFI table - checking');
         da.dbk_dc_pmrfi.verify_data;
         da.dbk_dc_pmrfi.process_temp_data;
     ELSIF (t_up_table_name = 'PMSUBMITTAL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMSUBMITTAL');
         display_status('DC_PMSUBMITTAL','PMSUBMITTAL table - checking');
         da.dbk_dc_pmsubmittal.verify_data;
         da.dbk_dc_pmsubmittal.process_temp_data;
     ELSIF (t_up_table_name = 'PMSUBMITPACKAGE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMSUBMITPACKAGE');
         display_status('DC_PMSUBMITPACKAGE','PMSUBMITPACKAGE table - checking');
         da.dbk_dc_pmsubmitpackage.verify_data;
         da.dbk_dc_pmsubmitpackage.process_temp_data;
     ELSIF (t_up_table_name = 'PMHISTORY')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMHISTORY');
         display_status('DC_PMHISTORY','PMHISTORY table - checking');
         da.dbk_dc_pmhistory.verify_data;
         da.dbk_dc_pmhistory.process_temp_data;
     ELSIF (t_up_table_name = 'PMJOURNAL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMJOURNAL');
         display_status('DC_PMJOURNAL','PMJOURNAL table - checking');
         da.dbk_dc_pmjournal.verify_data;
         da.dbk_dc_pmjournal.process_temp_data;
     ELSIF (t_up_table_name = 'PMJOUROLAB')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMJOUROLAB');
         display_status('DC_PMJOUROLAB','PMJOUROLAB table - checking');
         da.dbk_dc_pmjourolab.verify_data;
         da.dbk_dc_pmjourolab.process_temp_data;
     ELSIF (t_up_table_name = 'PMJOURTEQP')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMJOURTEQP');
         display_status('DC_PMJOURTEQP','PMJOURTEQP table - checking');
         da.dbk_dc_pmjourteqp.verify_data;
         da.dbk_dc_pmjourteqp.process_temp_data;
     ELSIF (t_up_table_name = 'PMJOURTLAB')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMJOURTLAB');
         display_status('DC_PMJOURTLAB','PMJOURTLAB table - checking');
         da.dbk_dc_pmjourtlab.verify_data;
         da.dbk_dc_pmjourtlab.process_temp_data;
     ELSIF (t_up_table_name = 'PMJOURVIS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMJOURVIS');
         display_status('DC_PMJOURVIS','PMJOURVIS table - checking');
         da.dbk_dc_pmjourvis.verify_data;
         da.dbk_dc_pmjourvis.process_temp_data;
     ELSIF (t_up_table_name = 'PMDESCRIPTION')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMDESCRIPTION');
         display_status('DC_PMDESCRIPTION','PMDESCRIPTION table - checking');
         da.dbk_dc_pmdescription.verify_data;
         da.dbk_dc_pmdescription.process_temp_data;
     ELSIF (t_up_table_name = 'PMUSERFFDATA')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMUSERFFDATA');
         display_status('DC_PMUSERFFDATA','PMUSERFFDATA table - checking');
         da.dbk_dc_pmuserffdata.verify_data;
         da.dbk_dc_pmuserffdata.process_temp_data;
     ELSIF (t_up_table_name = 'PMMEETING')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMMEETING');
         display_status('DC_PMMEETING','PMMEETING table - checking');
         da.dbk_dc_pmmeeting.verify_data;
         da.dbk_dc_pmmeeting.process_temp_data;
     ELSIF (t_up_table_name = 'PMMEETINGTRACK')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMMEETINGTRACK');
         display_status('DC_PMMEETINGTRACK','PMMEETINGTRACK table - checking');
         da.dbk_dc_pmmeetingtrack.verify_data;
         da.dbk_dc_pmmeetingtrack.process_temp_data;
     ELSIF (t_up_table_name = 'PMMEETINGITEM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMMEETINGITEM');
         display_status('DC_PMMEETINGITEM','PMMEETINGITEM table - checking');
         da.dbk_dc_pmmeetingitem.verify_data;
         da.dbk_dc_pmmeetingitem.process_temp_data;
     ELSIF (t_up_table_name = 'PMMEETINGATTND')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMMEETINGATTND');
         display_status('DC_PMMEETINGATTND','PMMEETINGATTND table - checking');
         da.dbk_dc_pmmeetingattnd.verify_data;
         da.dbk_dc_pmmeetingattnd.process_temp_data;
     ELSIF (t_up_table_name = 'PMNOTES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMNOTES');
         display_status('DC_PMNOTES','PMNOTES table - checking');
         da.dbk_dc_pmnotes.verify_data;
         da.dbk_dc_pmnotes.process_temp_data;
     ELSIF (t_up_table_name = 'SYSCONTACT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_SYSCONTACT');
         display_status('DC_SYSCONTACT','SYSCONTACT table - checking');
         da.dbk_dc_syscontact.verify_data;
         da.dbk_dc_syscontact.process_temp_data;
     ELSIF (t_up_table_name = 'HRINCIDENT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRINCIDENT');
         display_status('DC_HRINCIDENT','HRINCIDENT table - checking');
         da.dbk_dc_hrincident.verify_data;
         da.dbk_dc_hrincident.process_temp_data;
     ELSIF (t_up_table_name = 'HRELECTEDPLANS_EM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRELECTEDPLANS_EM');
         display_status('DC_HRELECTEDPLANS_EM','HRELECTEDPLANS_EM table - checking');
         da.dbk_dc_hrelectedplans_em.verify_data;
         da.dbk_dc_hrelectedplans_em.process_temp_data;
     ELSIF (t_up_table_name = 'CMDETVENDATA')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMDETVENDATA');
         display_status('DC_CMDETVENDATA','CMDETVENDATA table - checking');
         da.dbk_dc_cmdetvendata.verify_data;
         da.dbk_dc_cmdetvendata.process_temp_data;
     ELSIF (t_up_table_name = 'CMDETVENDATA_POSTED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMDETVENDATA_POSTED');
         display_status('DC_CMDETVENDATA_POSTED','CMDETVENDATA_POSTED table - checking');
         da.dbk_dc_cmdetvendata_posted.verify_data;
         da.dbk_dc_cmdetvendata_posted.process_temp_data;
     ELSIF (t_up_table_name = 'PMTRANSMITTAL_TABLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMTRANSMITTAL_TABLE');
         display_status('DC_PMTRANSMITTAL_TABLE','PMTRANSMITTAL_TABLE table - checking');
         da.dbk_dc_pmtransmittal_table.verify_data;
         da.dbk_dc_pmtransmittal_table.process_temp_data;
     ELSIF (t_up_table_name = 'PMTRNSMDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMTRNSMDETAIL');
         display_status('DC_PMTRNSMDETAIL','PMTRNSMDETAIL table - checking');
         da.dbk_dc_pmtrnsmdetail.verify_data;
         da.dbk_dc_pmtrnsmdetail.process_temp_data;
     ELSIF (t_up_table_name = 'BPMARKETSECTOR')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPMARKETSECTOR');
         display_status('DC_BPMARKETSECTOR','BPMARKETSECTOR table - checking');
         da.dbk_dc_bpmarketsector.verify_data;
         da.dbk_dc_bpmarketsector.process_temp_data;
     ELSIF (t_up_table_name = 'HREMRELATIVES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMRELATIVES');
         display_status('DC_HREMRELATIVES','HREMRELATIVES table - checking');
         da.dbk_dc_hremrelatives.verify_data;
         da.dbk_dc_hremrelatives.process_temp_data;
     ELSIF (t_up_table_name = 'JCJOBSECGRPPROJ')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JCJOBSECGRPPROJ');
         display_status('DC_JCJOBSECGRPPROJ','JCJOBSECGRPPROJ table - checking');
         da.dbk_dc_jcjobsecgrpproj.verify_data;
         da.dbk_dc_jcjobsecgrpproj.process_temp_data;
     ELSIF (t_up_table_name = 'PYACCESSCODE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYACCESSCODE');
         display_status('DC_PYACCESSCODE','PYACCESSCODE table - checking');
         da.dbk_dc_pyaccesscode.verify_data;
         da.dbk_dc_pyaccesscode.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPSECGRPEMP')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPSECGRPEMP');
         display_status('DC_PYEMPSECGRPEMP','PYEMPSECGRPEMP table - checking');
         da.dbk_dc_pyempsecgrpemp.verify_data;
         da.dbk_dc_pyempsecgrpemp.process_temp_data;
     ELSIF (t_up_table_name = 'HREMPSAFEHRS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMPSAFEHRS');
         display_status('DC_HREMPSAFEHRS','HREMPSAFEHRS table - checking');
         da.dbk_dc_hrempsafehrs.verify_data;
         da.dbk_dc_hrempsafehrs.process_temp_data;
     ELSIF (t_up_table_name = 'INSDETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_INSDETAIL');
         display_status('DC_INSDETAIL','INSDETAIL table - checking');
         da.dbk_dc_insdetail.verify_data;
         da.dbk_dc_insdetail.process_temp_data;
     ELSIF (t_up_table_name = 'NONSTOCKITEM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_NONSTOCKITEM');
         display_status('DC_NONSTOCKITEM','NONSTOCKITEM table - checking');
         da.dbk_dc_nonstockitem.verify_data;
         da.dbk_dc_nonstockitem.process_temp_data;
     ELSIF (t_up_table_name = 'BABANK')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BABANK');
         display_status('DC_BABANK','BABANK table - checking');
         da.dbk_dc_babank.verify_data;
         da.dbk_dc_babank.process_temp_data;
     ELSIF (t_up_table_name = 'APREGINV')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_APREGINV');
         display_status('DC_APREGINV','APREGINV table - checking');
         da.dbk_dc_apreginv.verify_data;
         da.dbk_dc_apreginv.process_temp_data;
     ELSIF (t_up_table_name = 'APREGDIST')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_APREGDIST');
         display_status('DC_APREGDIST','APREGDIST table - checking');
         da.dbk_dc_apregdist.verify_data;
         da.dbk_dc_apregdist.process_temp_data;
     ELSIF (t_up_table_name = 'OMOPPORTUNITY')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_OMOPPORTUNITY');
         display_status('DC_OMOPPORTUNITY','OMOPPORTUNITY table - checking');
         da.dbk_dc_omopportunity.verify_data;
         da.dbk_dc_omopportunity.process_temp_data;
     ELSIF (t_up_table_name = 'HRTRAININGS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRTRAININGS');
         display_status('DC_HRTRAININGS','HRTRAININGS table - checking');
         da.dbk_dc_hrtrainings.verify_data;
         da.dbk_dc_hrtrainings.process_temp_data;
     ELSIF (t_up_table_name = 'CMOWNCHGNUM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_CMOWNCHGNUM');
         display_status('DC_CMOWNCHGNUM','CMOWNCHGNUM table - checking');
         da.dbk_dc_cmownchgnum.verify_data;
         da.dbk_dc_cmownchgnum.process_temp_data;
     ELSIF (t_up_table_name = 'PMFWD')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMFWD');
         display_status('DC_PMFWD','PMFWD table - checking');
         da.dbk_dc_pmfwd.verify_data;
         da.dbk_dc_pmfwd.process_temp_data;
     ELSIF (t_up_table_name = 'PONSITM')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PONSITM');
         display_status('DC_PONSITM','PONSITM table - checking');
         da.dbk_dc_ponsitm.verify_data;
         da.dbk_dc_ponsitm.process_temp_data;
     ELSIF (t_up_table_name = 'PYTAXCAEMP')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYTAXCAEMP');
         display_status('DC_PYTAXCAEMP','PYTAXCAEMP table - checking');
         da.dbk_dc_pytaxcaemp.verify_data;
         da.dbk_dc_pytaxcaemp.process_temp_data;
     ELSIF (t_up_table_name = 'PRMWORKORDERS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMWORKORDERS');
         display_status('DC_PRMWORKORDERS','PRMWORKORDERS table - checking');
         da.dbk_dc_prmworkorders.verify_data;
         da.dbk_dc_prmworkorders.process_temp_data;
     ELSIF (t_up_table_name = 'BPBANKS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BPBANKS');
         display_status('DC_BPBANKS','BPBANKS table - checking');
         da.dbk_dc_bpbanks.verify_data;
         da.dbk_dc_bpbanks.process_temp_data;
     ELSIF (t_up_table_name = 'PYBENTRD')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYBENTRD');
         display_status('DC_PYBENTRD','PYBENTRD table - checking');
         da.dbk_dc_pybentrd.verify_data;
         da.dbk_dc_pybentrd.process_temp_data;
     ELSIF (t_up_table_name = 'PYEMPLOAN')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYEMPLOAN');
         display_status('DC_PYEMPLOAN','PYEMPLOAN table - checking');
         da.dbk_dc_pyemploan.verify_data;
         da.dbk_dc_pyemploan.process_temp_data;
     ELSIF (t_up_table_name = 'PYJOBPAYRATE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYJOBPAYRATE');
         display_status('DC_PYJOBPAYRATE','PYJOBPAYRATE table - checking');
         da.dbk_dc_pyjobpayrate.verify_data;
         da.dbk_dc_pyjobpayrate.process_temp_data;
     ELSIF (t_up_table_name = 'HREMPCERTLIC')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMPCERTLIC');
         display_status('DC_HREMPCERTLIC','HREMPCERTLIC table - checking');
         da.dbk_dc_hrempcertlic.verify_data;
         da.dbk_dc_hrempcertlic.process_temp_data;
     ELSIF (t_up_table_name = 'HREMPEDU')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMPEDU');
         display_status('DC_HREMPEDU','HREMPEDU table - checking');
         da.dbk_dc_hrempedu.verify_data;
         da.dbk_dc_hrempedu.process_temp_data;
     ELSIF (t_up_table_name = 'HREMPMEMS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMPMEMS');
         display_status('DC_HREMPMEMS','HREMPMEMS table - checking');
         da.dbk_dc_hrempmems.verify_data;
         da.dbk_dc_hrempmems.process_temp_data;
     ELSIF (t_up_table_name = 'HREMPSKILLS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HREMPSKILLS');
         display_status('DC_HREMPSKILLS','HREMPSKILLS table - checking');
         da.dbk_dc_hrempskills.verify_data;
         da.dbk_dc_hrempskills.process_temp_data;
     ELSIF (t_up_table_name = 'PRMTASKS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMTASKS');
         display_status('DC_PRMTASKS','PRMTASKS table - checking');
         da.dbk_dc_prmtasks.verify_data;
         da.dbk_dc_prmtasks.process_temp_data;
     ELSIF (t_up_table_name = 'PRMSCHEDRULES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMSCHEDRULES');
         display_status('DC_PRMSCHEDRULES','PRMSCHEDRULES table - checking');
         da.dbk_dc_prmschedrules.verify_data;
         da.dbk_dc_prmschedrules.process_temp_data;
     ELSIF (t_up_table_name = 'EMCLASSTRAN_V')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMCLASSTRAN_V');
         display_status('DC_EMCLASSTRAN_V','EMCLASSTRAN_V table - checking');
         da.dbk_dc_emclasstran_v.verify_data;
         da.dbk_dc_emclasstran_v.process_temp_data;
     ELSIF (t_up_table_name = 'EMRATE_V')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_EMRATE_V');
         display_status('DC_EMRATE_V','EMRATE_V table - checking');
         da.dbk_dc_emrate_v.verify_data;
         da.dbk_dc_emrate_v.process_temp_data;
     ELSIF (t_up_table_name = 'HRDISCIPLINE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_HRDISCIPLINE');
         display_status('DC_HRDISCIPLINE','HRDISCIPLINE table - checking');
         da.dbk_dc_HRDISCIPLINE.verify_data;
         da.dbk_dc_HRDISCIPLINE.process_temp_data;
     ELSIF (t_up_table_name = 'PMROLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMROLE');
         display_status('DC_PMROLE','PMROLE table - checking');
         da.dbk_dc_PMROLE.verify_data;
         da.dbk_dc_PMROLE.process_temp_data;
     ELSIF (t_up_table_name = 'PMPROJCONTACTROLE')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PMPROJCONTACTROLE');
         display_status('DC_PMPROJCONTACTROLE','PMPROJCONTACTROLE table - checking');
         da.dbk_dc_PMPROJCONTACTROLE.verify_data;
         da.dbk_dc_PMPROJCONTACTROLE.process_temp_data;
     ELSIF (t_up_table_name = 'PRMACCUMULTRS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMACCUMULTRS');
         display_status('DC_PRMACCUMULTRS','PRMACCUMULTRS table - checking');
         da.dbk_dc_PRMACCUMULTRS.verify_data;
         da.dbk_dc_PRMACCUMULTRS.process_temp_data;
     ELSIF (t_up_table_name = 'PRMLASTEQPSVC')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMLASTEQPSVC');
         display_status('DC_PRMLASTEQPSVC','PRMLASTEQPSVC table - checking');
         da.dbk_dc_PRMLASTEQPSVC.verify_data;
         da.dbk_dc_PRMLASTEQPSVC.process_temp_data;
     ELSIF (t_up_table_name = 'PYBENTRD_HEADER')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYBENTRD_HEADER');
         display_status('DC_PYBENTRD_HEADER','PYBENTRD_HEADER table - checking');
         da.dbk_dc_PYBENTRD_HEADER.verify_data;
         da.dbk_dc_PYBENTRD_HEADER.process_temp_data;
     ELSIF (t_up_table_name = 'PYBENTRD_DETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYBENTRD_DETAIL');
         display_status('DC_PYBENTRD_DETAIL','PYBENTRD_DETAIL table - checking');
         da.dbk_dc_PYBENTRD_DETAIL.verify_data;
         da.dbk_dc_PYBENTRD_DETAIL.process_temp_data;
     ELSIF (t_up_table_name = 'PYCOMMAX')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYCOMMAX');
         display_status('DC_PYCOMMAX','PYCOMMAX table - checking');
         da.dbk_dc_PYCOMMAX.verify_data;
         da.dbk_dc_PYCOMMAX.process_temp_data;
      ELSIF (t_up_table_name = 'PY_GENERIC_CREW_HEADER')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PY_GENERIC_CREW_HEADER');
         display_status('DC_PY_GENERIC_CREW_HEADER','PY_GENERIC_CREW_HEADER table - checking');
         da.dbk_dc_PY_GENERIC_CREW_HEADER.verify_data;
         da.dbk_dc_PY_GENERIC_CREW_HEADER.process_temp_data;
      ELSIF (t_up_table_name = 'PY_GENERIC_CREW_DETAIL')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PY_GENERIC_CREW_DETAIL');
         display_status('DC_PY_GENERIC_CREW_DETAIL','PY_GENERIC_CREW_DETAIL table - checking');
         da.dbk_dc_PY_GENERIC_CREW_DETAIL.verify_data;
         da.dbk_dc_PY_GENERIC_CREW_DETAIL.process_temp_data;
      ELSIF (t_up_table_name = 'PY_CREW_HEADER')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PY_CREW_HEADER');
         display_status('DC_PY_CREW_HEADER','PY_CREW_HEADER table - checking');
         da.dbk_dc_PY_CREW_HEADER.verify_data;
         da.dbk_dc_PY_CREW_HEADER.process_temp_data;
     ELSIF (t_up_table_name = 'PY_CREW_DETAILS')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PY_CREW_DETAILS');
         display_status('DC_PY_CREW_DETAILS','PY_CREW_DETAILS table - checking');
         da.dbk_dc_PY_CREW_DETAILS.verify_data;
         da.dbk_dc_PY_CREW_DETAILS.process_temp_data;
     ELSIF (t_up_table_name = 'PRMWORKITEMS_POSTED')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PRMWORKITEMS_POSTED');
         display_status('DC_PRMWORKITEMS_POSTED','PRMWORKITEMS_POSTED table - checking');
         da.dbk_dc_PRMWORKITEMS_POSTED.verify_data;
         da.dbk_dc_PRMWORKITEMS_POSTED.process_temp_data;
     ELSIF (t_up_table_name = 'BABANKACCT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_BABANKACCT');
         display_status('DC_BABANKACCT','BABANKACCT table - checking');
         da.dbk_dc_BABANKACCT.verify_data;
         da.dbk_dc_BABANKACCT.process_temp_data;
     ELSIF (t_up_table_name = 'PYCHKLOC')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYCHKLOC');
         display_status('DC_PYCHKLOC','PYCHKLOC table - checking');
         da.dbk_dc_PYCHKLOC.verify_data;
         da.dbk_dc_PYCHKLOC.process_temp_data;
     ELSIF (t_up_table_name = 'PYJOBALLOC')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_PYJOBALLOC');
         display_status('DC_PYJOBALLOC','PYJOBALLOC table - checking');
         da.dbk_dc_PYJOBALLOC.verify_data;
         da.dbk_dc_PYJOBALLOC.process_temp_data;
     ELSIF (t_up_table_name = 'JBCONT')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JBCONT');
         display_status('DC_JBCONT','JBCONT table - checking');
         da.dbk_dc_JBCONT.verify_data;
         da.dbk_dc_JBCONT.process_temp_data;
     ELSIF (t_up_table_name = 'JBCONTDET')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JBCONTDET');
         display_status('DC_JBCONTDET','JBCONTDET table - checking');
         da.dbk_dc_JBCONTDET.verify_data;
         da.dbk_dc_JBCONTDET.process_temp_data;
     ELSIF (t_up_table_name = 'JBITEMNAMES')
     THEN
         dbms_output.put_line(' ');
         delete_status('DC_JBITEMNAMES');
         display_status('DC_JBITEMNAMES','JBITEMNAMEST table - checking');
         da.dbk_dc_JBITEMNAMES.verify_data;
         da.dbk_dc_JBITEMNAMES.process_temp_data;
     ELSIF (t_up_table_name = 'HELP')
     THEN
        dbms_output.put_line('Data Conversion package');
        dbms_output.put_line('Filename mapping (name of table - filename):');
        dbms_output.put_line(' ');
        dbms_output.put_line('BPARTNERS         - dcbpartn - Business Partners');
        dbms_output.put_line('BPCUSTOMERS       - dcbpcust - Customers');
        dbms_output.put_line('BPVENDORS         - dcbpvend - Vendors');
        dbms_output.put_line('BPADDRESSES       - dcbpaddr - Addresses for Business Partners');
        dbms_output.put_line('GLEDGER           - dcgledge - General Ledger');
        dbms_output.put_line('ACCOUNT           - dcaccnt  - Account maintenance');
        dbms_output.put_line('JCDETAIL          - dcjcdeta');
        dbms_output.put_line('JCJOBCAT          - dcjcjcat');
        dbms_output.put_line('JCMCAT            - dcjcmcat');
        dbms_output.put_line('JCJOBHPHS         - dcjcjhph');
        dbms_output.put_line('JCMPHS            - dcjcmphs');
        dbms_output.put_line('JCTCAT            - dcjctcat');
        dbms_output.put_line('JCTPHS            - dcjctphs');
        dbms_output.put_line('JCJOB_TABLE       - dcjcjob');
        dbms_output.put_line('JCUTRAN           - dcjcutra');
        dbms_output.put_line('SCDETAIL          - dcscdeta');
        dbms_output.put_line('SCMAST            - dcscmast');
        dbms_output.put_line('SCSCHED           - dcscsche');
        dbms_output.put_line('VOUCHER           - dcvouche');
        dbms_output.put_line('VOUDIST           - dcvoudis');
        dbms_output.put_line('CHEQUE            - dccheque');
        dbms_output.put_line('VOUCHQ            - dcvouchq');
        dbms_output.put_line('VOUMEMO           - dcvoumem');
        dbms_output.put_line('PAYCHQ            - dcpaychq');
        dbms_output.put_line('INVOICE           - dcinvoic');
        dbms_output.put_line('INVDIST           - dcinvdis');
        dbms_output.put_line('INVMEMO           - dcinvmem');
        dbms_output.put_line('INVRLSDET         - dcinvrlsdt');
        dbms_output.put_line('PAYMENT           - dcpaymen');
        dbms_output.put_line('INVPAY            - dcinvpay');
        dbms_output.put_line('PYEMPLOYEE_TABLE  - dcpyempl');
        dbms_output.put_line('PYEMPPAYHIST      - dcpyephi');
        dbms_output.put_line('PYEMPTIMSHT       - dcpyepsh');
        dbms_output.put_line('PYWCBCODE         - dcpywcbc');
        dbms_output.put_line('PYWCBRATE         - dcpywcbr');
        dbms_output.put_line('PYWCBJOB          - dcpywcbj');
        dbms_output.put_line('PYEMPHIST         - dcpyemph');
        dbms_output.put_line('CMMAST_POSTED     - dccmma_p');
        dbms_output.put_line('CMMAST            - dccmmast');
        dbms_output.put_line('CMDETAIL_POSTED   - dccmde_p');
        dbms_output.put_line('CMDETAIL          - dccmdeta');
        dbms_output.put_line('BUDGMAST          - dcbudgma');
        dbms_output.put_line('BUDGET            - dcbudget');
        dbms_output.put_line('EMACTUALLOCATION  - dcemaclo');
        dbms_output.put_line('EMEQUIPMENT       - dcemequi');
        dbms_output.put_line('EMEQPCOMTRAN      - dcemeqpc');
        dbms_output.put_line('EMEQPHCOMPON      - dcemeqphc');
        dbms_output.put_line('EMLOCHIST         - dcemloch');
        dbms_output.put_line('EMTRAN            - dcemtran');
        dbms_output.put_line('EMDETAIL          - dcemdeta');
        dbms_output.put_line('EMBALANCE         - dcembala');
        dbms_output.put_line('EMBALANCE         - dcembala');
        dbms_output.put_line('EMCLASSRATE       - dcemclrt');
        dbms_output.put_line('EMEQPRATE         - dcemeqpr');
        dbms_output.put_line('EMEQPJOBRATE      - dcemqpjo');
        dbms_output.put_line('CIITEM            - dcciitem');
        dbms_output.put_line('CIITEMHDR         - dcciithd');
        dbms_output.put_line('CIITEMDET         - dcciitdt');
        dbms_output.put_line('CISALEPRICE       - dccislpr');
        dbms_output.put_line('CICMPITEM         - dccicmpi');
        dbms_output.put_line('CISTDCST          - dccistdc - Inventory opening balances');
        dbms_output.put_line('POMAST            - dcpodet  - Purchase Order Master');
        dbms_output.put_line('PODETAIL          - dcpodet  - Purchase Order Detail');
        dbms_output.put_line('POCOMAST          - dcpocom  - Change Order Purchase Order Master');
        dbms_output.put_line('POCODET           - dcpocod  - Change Order Purchase Order Detail');
        dbms_output.put_line('PYEMPSALSPL       - dcpyemplsalspl');
        dbms_output.put_line('HRCLASS           - dchrclass - Training Classes');
        dbms_output.put_line('HRINTTRAINING     - dchrintraining - Training Courses');
        dbms_output.put_line('HRSUITPOS         - dchrsuitpos - Suitable Positions');
        dbms_output.put_line('HRAPPLICANTS      - dchrapplicants - Job Applicants');
        dbms_output.put_line('FAASSET           - dcfaasset - Master Fixed Asset Table');
        dbms_output.put_line('PYCHECKS          - dcpychecks');
        dbms_output.put_line('PYTAXEXM          - dcpytaxe');
        dbms_output.put_line('PYTAXEMP          - dcpytaxemp');
	dbms_output.put_line('PYEMPSALSPL	- dcpyempsalspl');
	dbms_output.put_line('EMEQPTRAN_V	- dcemeqptran_v');
	dbms_output.put_line('EMRATEREVTYPE_V		- dcemraterevtype_v');
	dbms_output.put_line('APPURCHASEAGREEMENT	- dcappurchag');
	dbms_output.put_line('APPURCHASEAGREEMENTDET	- dcappurchag_det');
	dbms_output.put_line('APMATERIALRECEIPT	- dcapmatrec');
	dbms_output.put_line('EMTRANPOST	- dcemtranpost');
	dbms_output.put_line('EMTRANDIST	- dcemtrandist');
        dbms_output.put_line('VOURLSDET         - dcvourlsdt');
	dbms_output.put_line('JC_JOB_PHASE_PROJECTION	- dcjcjpp');
	dbms_output.put_line('DEPT_TABLE	- dcdept_table');
	dbms_output.put_line('PYTRADES	- dcpytrades');
	dbms_output.put_line('PMPROJECT_TABLE	- dcpmproject');
	dbms_output.put_line('PYEMPLEAVE	- dcpyempleave');
	dbms_output.put_line('PYEMPLEAVEHIST	- dcpyempleavehist');
	dbms_output.put_line('ADDRESS	- dcaddress');
	dbms_output.put_line('PYEMPBEN	- dcpyempben');
	dbms_output.put_line('PYEMPDED	- dcpyempded');
	dbms_output.put_line('LOCATION_TABLE	- dclocation');
	dbms_output.put_line('PMPROJPARTNER	- dcpmprojpartner');
	dbms_output.put_line('PMPROJCONTACT	- dcpmprojcontact');
	dbms_output.put_line('PMRFI	- dcpmrfi');
	dbms_output.put_line('DMISSUE	- dcdmissue');
	dbms_output.put_line('PMSUBMITTAL	- dcpmsubmittal');
	dbms_output.put_line('PMSUBMITPACKAGE	- dcpmsubpack');
	dbms_output.put_line('PMHISTORY	- dcpmhistory');
	dbms_output.put_line('PMJOURNAL	- dcpmjournal');
	dbms_output.put_line('PMJOUROLAB	- dcpmjourolab');
	dbms_output.put_line('PMJOURTEQP	- dcpmjourteqp');
	dbms_output.put_line('PMJOURTLAB	- dcpmjourtlab');
	dbms_output.put_line('PMJOURVIS	- dcpmjourvis');
	dbms_output.put_line('PMDESCRIPTION	- dcpmdescription');
	dbms_output.put_line('PMUSERFFDATA	- dcpmuserffdata');
	dbms_output.put_line('PMMEETING	- dcpmmeeting');
	dbms_output.put_line('PMMEETINGTRACK	- dcpmmeetingtrack');
	dbms_output.put_line('PMMEETINGITEM	- dcpmmeetingitem');
	dbms_output.put_line('PMMEETINGATTND	- dcpmmeetingattnd');
	dbms_output.put_line('PMNOTES	- dcpmnotes');
	dbms_output.put_line('HRINCIDENT	- dchrincident');
	dbms_output.put_line('HRELECTEDPLANS_EM	- dchrelectedplans_em');
	dbms_output.put_line('CMDETVENDATA	- dccmdetvendata');
	dbms_output.put_line('CMDETVENDATA_POSTED	- dccmdetvendata_p');
	dbms_output.put_line('PMTRANSMITTAL_TABLE	- dcpmtransmittal_table');
	dbms_output.put_line('PMTRNSMDETAIL	- dcpmtrnsmdetail');
	dbms_output.put_line('BPMARKETSECTOR	- dcbpmarketsector');
	dbms_output.put_line('HREMRELATIVES	- dchremrelatives');
	dbms_output.put_line('JCJOBSECGRPPROJ	- dcjcjobsecgrpproj');
	dbms_output.put_line('PYACCESSCODE	- dcpyaccesscode');
	dbms_output.put_line('PYEMPSECGRPEMP	- dcpyempsecgrpemp');
	dbms_output.put_line('HREMPSAFEHRS	- dchrempsafehrs');
	dbms_output.put_line('INSDETAIL	- dcinsdetail');
	dbms_output.put_line('NONSTOCKITEM	- dcnonstockitem');
	dbms_output.put_line('BABANK	- dcbabank');
	dbms_output.put_line('APREGINV	- dcapreginv');
	dbms_output.put_line('APREGDIST	- dcapregdist');
	dbms_output.put_line('OMOPPORTUNITY	- dcomopportunity');
	dbms_output.put_line('HRTRAININGS	- dchrtrainings');
	dbms_output.put_line('CMOWNCHGNUM	- dccmownchgnum');
	dbms_output.put_line('PMFWD	- dcpmfwd');
	dbms_output.put_line('PONSITM	- dcponsitm');
	dbms_output.put_line('PYTAXCAEMP	- dcpytaxcaemp');
	dbms_output.put_line('PRMWORKORDERS	- dcprmworkorders');
	dbms_output.put_line('BPBANKS	- dcbpbanks');
	dbms_output.put_line('PYBENTRD	- dcpybentrd');
	dbms_output.put_line('PYEMPLOAN	- dcpyemploan');
	dbms_output.put_line('PYJOBPAYRATE	- dcpyjobpayrate');
	dbms_output.put_line('HREMPCERTLIC	- dchrempcertlic');
	dbms_output.put_line('HREMPEDU	- dchrempedu');
	dbms_output.put_line('HREMPMEMS	- dchrempmems');
	dbms_output.put_line('HREMPSKILLS	- dchrempskills');
	dbms_output.put_line('PRMTASKS	- dcprmtasks');
	dbms_output.put_line('PRMSCHEDRULES	- dcprmschedrules');
	dbms_output.put_line('EMCLASSTRAN_V	- dcemclasstran_v');
	dbms_output.put_line('EMRATE_V	- dcemrate_v');
	dbms_output.put_line('HRDICIPLINE - dchrdiscipline');
	dbms_output.put_line('PMROLE - pmrole');
	dbms_output.put_line('PMPROJCONTACTROLE - pmprojcontactrole');
	dbms_output.put_line('PRMACCUMULTRS - prmaccumultrs');
	dbms_output.put_line('PRMLASTEQPSVC - prmlasteqpsvc');
	dbms_output.put_line('PYBENTRD_HEADER - pybentrd_header');
	dbms_output.put_line('PYBENTRD_DETAIL - pybentrd_detail');
	dbms_output.put_line('PYCOMMAX - pycommax');
	dbms_output.put_line('PRMWORKITEMS_POSTED - prmworkitems_posted');
	dbms_output.put_line('BABANKACCT - babankacct');
	dbms_output.put_line('PYCHKLOC - pychkloc');
	dbms_output.put_line('PYJOBALLOC - pyjoballoc');
	dbms_output.put_line('JBCONT - jbcont');
	dbms_output.put_line('JBCONTDET - jbcontdet');
	dbms_output.put_line('JBITEMNAMES - jbitemnames');
     ELSE
        dbms_output.put_line('No check utility for table '||UPPER(p_table_name));
     END IF;

END Verify;

END;

/
