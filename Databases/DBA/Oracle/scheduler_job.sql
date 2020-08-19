
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"PZNADMIN1"."CLEAN_YES_CLAIMS"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'PZNADMIN1.WEB_YES_CLAIMS_PKG.JOB_CLEAN_YES_CLAIMS_SCROLL_PR',
            number_of_arguments => 0,
            start_date => SYSTIMESTAMP,
            repeat_interval => 'freq=daily; byhour=02;',
            end_date => NULL,
            enabled => TRUE,
            comments => 'Deletes YES claims from the scroll table for the previous day. This helps keep the YES process perform better'
            );
END;


--***** When calling a proc with parameters always use PLSQL_BLOCK type as below. NOT STORED_PROCEDURE type as above.
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"PZNADMIN1"."SEND_MAIL_FWB_AUDIT_REPORT_JOB"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN PZNADMIN1.SEND_MAIL_FWB_AUDIT_REPORT_PR(P_RECIPIENTS => ''Richard.Verzone@bcbsma.com, Kangna.Gupta@bcbsma.com'',
                                                                                                    P_CC => null,
                                                                                                    P_BCC => ''kranthi.pabba@bcbsma.com'',
                                                                                                    P_SUBJECT => ''Daily FWB AUDIT REPORT'',
                                                                                                    P_MESSAGE => ''Please find attached for FWB audit report. Thanks''); 
                                                                                                    END;',
            number_of_arguments => 0,
            start_date => SYSTIMESTAMP,
            repeat_interval => 'freq=weekly; byday=mon,tue,wed,thu,fri,sat,sun; byhour=10;',
            end_date => NULL,
            enabled => TRUE,
            comments => 'Sends out audit report email to Kangna and '
            );
END;
/