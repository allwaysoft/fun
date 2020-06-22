
SET VERIFY OFF 
SET serveroutput on size 1000000

accept from_which_database prompt 'Insert from which database:'
accept to_which_database prompt 'Insert to which database:'

declare

v_cnt      NUMBER;
v_cnt_&to_which_database NUMBER;
v_cnt_&from_which_database NUMBER;
record_count_mismatch exception;

begin

dbms_output.put_line(chr(9));

for i in
(
SELECT 
  PMCTRL_COMP_CODE,
  PMCTRL_AUTO_PROJ_NUMBER_FLAG,
  PMCTRL_USE_JCCTRL_MASK_FLAG,
  PMCTRL_PROJ_CODE_MASK,
  PMCTRL_AUTO_BID_NUMBER_FLAG,
  PMCTRL_BID_MASK,
  PMCTRL_SEQ_BID_BY_PROJ_FLAG,
  PMCTRL_TRNSM_MASK,
  PMCTRL_DFLT_MEETING_FOOTNOTE,
  PMCTRL_DFLT_PO_COMP_CODE,
  PMCTRL_VALIDATE_ITEM_CODE,
  PMCTRL_VALIDATE_PO_INFO,
  PMCTRL_AUTOCREATE_BID_JOB_FLAG,
  PMCTRL_DFLT_PLIST_COMPL_PERIOD,
  PMCTRL_ISSUE_ID_MASK,
  PMCTRL_RFI_MASK,
  PMCTRL_DAYJR_MASK,
  PMCTRL_FWD_MASK,
  PMCTRL_NOTICE_MASK,
  PMCTRL_COMMLG_MASK,
  PMCTRL_SELF_VEN_CODE,
  PMCTRL_SELF_VEN_NAME,
  PMCTRL_MEETING_NUMBERING_FLAG,
  PMCTRL_DEFAULT_BILL_TYPE_CODE,
  PMCTRL_DEFAULT_INVOICE_FORMAT,
  PMCTRL_DEFAULT_JB_MAP_CODE,
  PMCTRL_DEFAULT_RFI_PERIOD,
  PMCTRL_DFLT_COMM_FOOTNOTE,
  PMCTRL_UNIQUE_ISS_NUM_FLAG,
  PMCTRL_DFLT_LEAD_TIME_STAGE1,
  PMCTRL_DFLT_LEAD_TIME_STAGE2,
  PMCTRL_DFLT_LEAD_TIME_STAGE3,
  PMCTRL_DFLT_LEAD_TIME_STAGE4,
  PMCTRL_DFLT_LEAD_TIME_STAGE5,
  PMCTRL_DFLT_LEAD_TIME_STAGE6,
  PMCTRL_AUTO_SBMT_FLAG,
  PMCTRL_SBMT_MASK,
  PMCTRL_DFLT_MARKUP_ROUND_RULE,
  PMCTRL_DFLT_MARKUP_ROUND_MTHD,
  PMCTRL_DFLT_MARKUP_ROUND_FLAG,
  PMCTRL_DFLT_DJ_GENERAL_FLAG,
  PMCTRL_DFLT_DJ_OWN_LAB_FLAG,
  PMCTRL_DFLT_DJ_TRADE_LAB_FLAG,
  PMCTRL_DFLT_DJ_OWN_EQP_FLAG,
  PMCTRL_DFLT_DJ_OE_ON_JOB_FLAG,
  PMCTRL_DFLT_DJ_TRADE_EQP_FLAG,
  PMCTRL_DFLT_DJ_MATERIALS_FLAG,
  PMCTRL_DFLT_DJ_VISITORS_FLAG,
  PMCTRL_DFLT_DJ_SAFETY_FLAG,
  PMCTRL_DFLT_DJ_NOTES_FLAG,
  PMCTRL_DFLT_DJ_ATTACHMENT_FLAG,
  PMCTRL_DFLT_CMDETAIL_MODE,
  PMCTRL_DFLT_DJ_TL_COMP_FLAG,
  PMCTRL_DAYJR_OE_TRAN_DISP_FLAG,
  PMCTRL_LIEN_WAIVER_TEXT,
  PMCTRL_PHS_DESC_FLAG,
  PMCTRL_DFLT_DJ_LAB_FORCE_FLAG,
  PMCTRL_ASSIGN_UNPOST_PCI_TO_SC,
  PMCTRL_PROJ_DOC_TYPE,
  PMCTRL_PROJ_DOC_ID,
  PMCTRL_OWNCHG_TEXT_TYPE,
  PMCTRL_SC_TEXT_TYPE,
  PMCTRL_SBMT_MASK_SEQ_PROJ,
  PMCTRL_COMMLG_MASK_SEQ_PROJ,
  PMCTRL_DAYJR_MASK_SEQ_PROJ,
  PMCTRL_FWD_MASK_SEQ_PROJ,
  PMCTRL_NOTICE_MASK_SEQ_PROJ,
  PMCTRL_RFI_MASK_SEQ_PROJ,
  PMCTRL_TRNSM_MASK_SEQ_PROJ,
  PMCTRL_ISSUE_ID_MASK_SEQ_PROJ,
  PMCTRL_SBMTP_MASK,
  PMCTRL_SBMTP_MASK_SEQ_PROJ,
  PMCTRL_OCO_PCI_EXT_ONLY_FLAG,
  --PMCTRL__IU__CREATE_DATE,
  --PMCTRL__IU__CREATE_USER,
  --PMCTRL__IU__UPDATE_DATE,
  --PMCTRL__IU__UPDATE_USER,
  --PMCTRL_BID_PRE_ESTIMATE_FLAG,
  PMCTRL_BID_UPD_STARTED_JOB_FLG,
  PMCTRL_DOC_REV_REF_MAND_FLAG,
  PMCTRL_RFI_ACCEPT_SUGGESTION,
  PMCTRL_SHOW_TRNSM_CONTENTS,
  PMCTRL_ISSUE_TEXT_TYPE,
  PMCTRL_LS_PHS_CODE,
  PMCTRL_LS_CAT_CODE,
  PMCTRL_DFLT_RFQ_REVIEW_DAYS,
  PMCTRL_USE_PCI_SUBST_FLAG,
  PMCTRL_DFLT_DJ_TASKS_FLAG,
  PMCTRL_MEETING_ID_MASK,
  PMCTRL_AGENDA_ITEM_ID_MASK,
  PMCTRL_TASK_NAME_CRITERIA_FLAG,
  PMCTRL_PCI_DET_DESC_FIRST_FLAG,
  PMCTRL_BID_MASK_OVERRIDE,
  PMCTRL_SBMT_MASK_OVERRIDE,
  PMCTRL_SBMTP_MASK_OVERRIDE,
  PMCTRL_COMMLG_MASK_OVERRIDE,
  PMCTRL_DAYJR_MASK_OVERRIDE,
  PMCTRL_FWD_MASK_OVERRIDE,
  PMCTRL_NOTICE_MASK_OVERRIDE,
  PMCTRL_RFI_MASK_OVERRIDE,
  PMCTRL_TRNSM_MASK_OVERRIDE,
  PMCTRL_ISSUE_MASK_OVERRIDE,
  PMCTRL_OCO_ORIG_CONT_AMT_OVRD,
  PMCTRL_PROJ_END_DT_UPDATEABLE,
  PMCTRL_PMPL_MASK,
  PMCTRL_PMPL_MASK_OVERRIDE,
  PMCTRL_PMPL_MASK_SEQ_PROJ,
  PMCTRL_PMPLI_MASK,
  PMCTRL_PMPLI_MASK_SEQ_PROJ,
  PMCTRL_SFPO_APPROVER_PM_ROLE,
  PMCTRL_PHS_SEGM_SEC_FLAG,
  PMCTRL_CALC_OCO_DT_ON_WRKDYS
FROM da.PMCTRL@&from_which_database
where pmctrl_comp_code not in ('ZZ')
) loop
INSERT INTO da.PMCTRL@&to_which_database
(  
  PMCTRL_COMP_CODE,
  PMCTRL_AUTO_PROJ_NUMBER_FLAG,
  PMCTRL_USE_JCCTRL_MASK_FLAG,
  PMCTRL_PROJ_CODE_MASK,
  PMCTRL_AUTO_BID_NUMBER_FLAG,
  PMCTRL_BID_MASK,
  PMCTRL_SEQ_BID_BY_PROJ_FLAG,
  PMCTRL_TRNSM_MASK,
  PMCTRL_DFLT_MEETING_FOOTNOTE,
  PMCTRL_DFLT_PO_COMP_CODE,
  PMCTRL_VALIDATE_ITEM_CODE,
  PMCTRL_VALIDATE_PO_INFO,
  PMCTRL_AUTOCREATE_BID_JOB_FLAG,
  PMCTRL_DFLT_PLIST_COMPL_PERIOD,
  PMCTRL_ISSUE_ID_MASK,
  PMCTRL_RFI_MASK,
  PMCTRL_DAYJR_MASK,
  PMCTRL_FWD_MASK,
  PMCTRL_NOTICE_MASK,
  PMCTRL_COMMLG_MASK,
  PMCTRL_SELF_VEN_CODE,
  PMCTRL_SELF_VEN_NAME,
  PMCTRL_MEETING_NUMBERING_FLAG,
  PMCTRL_DEFAULT_BILL_TYPE_CODE,
  PMCTRL_DEFAULT_INVOICE_FORMAT,
  PMCTRL_DEFAULT_JB_MAP_CODE,
  PMCTRL_DEFAULT_RFI_PERIOD,
  PMCTRL_DFLT_COMM_FOOTNOTE,
  PMCTRL_UNIQUE_ISS_NUM_FLAG,
  PMCTRL_DFLT_LEAD_TIME_STAGE1,
  PMCTRL_DFLT_LEAD_TIME_STAGE2,
  PMCTRL_DFLT_LEAD_TIME_STAGE3,
  PMCTRL_DFLT_LEAD_TIME_STAGE4,
  PMCTRL_DFLT_LEAD_TIME_STAGE5,
  PMCTRL_DFLT_LEAD_TIME_STAGE6,
  PMCTRL_AUTO_SBMT_FLAG,
  PMCTRL_SBMT_MASK,
  PMCTRL_DFLT_MARKUP_ROUND_RULE,
  PMCTRL_DFLT_MARKUP_ROUND_MTHD,
  PMCTRL_DFLT_MARKUP_ROUND_FLAG,
  PMCTRL_DFLT_DJ_GENERAL_FLAG,
  PMCTRL_DFLT_DJ_OWN_LAB_FLAG,
  PMCTRL_DFLT_DJ_TRADE_LAB_FLAG,
  PMCTRL_DFLT_DJ_OWN_EQP_FLAG,
  PMCTRL_DFLT_DJ_OE_ON_JOB_FLAG,
  PMCTRL_DFLT_DJ_TRADE_EQP_FLAG,
  PMCTRL_DFLT_DJ_MATERIALS_FLAG,
  PMCTRL_DFLT_DJ_VISITORS_FLAG,
  PMCTRL_DFLT_DJ_SAFETY_FLAG,
  PMCTRL_DFLT_DJ_NOTES_FLAG,
  PMCTRL_DFLT_DJ_ATTACHMENT_FLAG,
  PMCTRL_DFLT_CMDETAIL_MODE,
  PMCTRL_DFLT_DJ_TL_COMP_FLAG,
  PMCTRL_DAYJR_OE_TRAN_DISP_FLAG,
  PMCTRL_LIEN_WAIVER_TEXT,
  PMCTRL_PHS_DESC_FLAG,
  PMCTRL_DFLT_DJ_LAB_FORCE_FLAG,
  PMCTRL_ASSIGN_UNPOST_PCI_TO_SC,
  PMCTRL_PROJ_DOC_TYPE,
  PMCTRL_PROJ_DOC_ID,
  PMCTRL_OWNCHG_TEXT_TYPE,
  PMCTRL_SC_TEXT_TYPE,
  PMCTRL_SBMT_MASK_SEQ_PROJ,
  PMCTRL_COMMLG_MASK_SEQ_PROJ,
  PMCTRL_DAYJR_MASK_SEQ_PROJ,
  PMCTRL_FWD_MASK_SEQ_PROJ,
  PMCTRL_NOTICE_MASK_SEQ_PROJ,
  PMCTRL_RFI_MASK_SEQ_PROJ,
  PMCTRL_TRNSM_MASK_SEQ_PROJ,
  PMCTRL_ISSUE_ID_MASK_SEQ_PROJ,
  PMCTRL_SBMTP_MASK,
  PMCTRL_SBMTP_MASK_SEQ_PROJ,
  PMCTRL_OCO_PCI_EXT_ONLY_FLAG,
  --PMCTRL__IU__CREATE_DATE,
  --PMCTRL__IU__CREATE_USER,
  --PMCTRL__IU__UPDATE_DATE,
  --PMCTRL__IU__UPDATE_USER,
  --PMCTRL_BID_PRE_ESTIMATE_FLAG,
  PMCTRL_BID_UPD_STARTED_JOB_FLG,
  PMCTRL_DOC_REV_REF_MAND_FLAG,
  PMCTRL_RFI_ACCEPT_SUGGESTION,
  PMCTRL_SHOW_TRNSM_CONTENTS,
  PMCTRL_ISSUE_TEXT_TYPE,
  PMCTRL_LS_PHS_CODE,
  PMCTRL_LS_CAT_CODE,
  PMCTRL_DFLT_RFQ_REVIEW_DAYS,
  PMCTRL_USE_PCI_SUBST_FLAG,
  PMCTRL_DFLT_DJ_TASKS_FLAG,
  PMCTRL_MEETING_ID_MASK,
  PMCTRL_AGENDA_ITEM_ID_MASK,
  PMCTRL_TASK_NAME_CRITERIA_FLAG,
  PMCTRL_PCI_DET_DESC_FIRST_FLAG,
  PMCTRL_BID_MASK_OVERRIDE,
  PMCTRL_SBMT_MASK_OVERRIDE,
  PMCTRL_SBMTP_MASK_OVERRIDE,
  PMCTRL_COMMLG_MASK_OVERRIDE,
  PMCTRL_DAYJR_MASK_OVERRIDE,
  PMCTRL_FWD_MASK_OVERRIDE,
  PMCTRL_NOTICE_MASK_OVERRIDE,
  PMCTRL_RFI_MASK_OVERRIDE,
  PMCTRL_TRNSM_MASK_OVERRIDE,
  PMCTRL_ISSUE_MASK_OVERRIDE,
  PMCTRL_OCO_ORIG_CONT_AMT_OVRD,
  PMCTRL_PROJ_END_DT_UPDATEABLE,
  PMCTRL_PMPL_MASK,
  PMCTRL_PMPL_MASK_OVERRIDE,
  PMCTRL_PMPL_MASK_SEQ_PROJ,
  PMCTRL_PMPLI_MASK,
  PMCTRL_PMPLI_MASK_SEQ_PROJ,
  PMCTRL_SFPO_APPROVER_PM_ROLE,
  PMCTRL_PHS_SEGM_SEC_FLAG,
  PMCTRL_CALC_OCO_DT_ON_WRKDYS
)
values
(
i.  PMCTRL_COMP_CODE,
i.  PMCTRL_AUTO_PROJ_NUMBER_FLAG,
i.  PMCTRL_USE_JCCTRL_MASK_FLAG,
i.  PMCTRL_PROJ_CODE_MASK,
i.  PMCTRL_AUTO_BID_NUMBER_FLAG,
i.  PMCTRL_BID_MASK,
i.  PMCTRL_SEQ_BID_BY_PROJ_FLAG,
i.  PMCTRL_TRNSM_MASK,
i.  PMCTRL_DFLT_MEETING_FOOTNOTE,
i.  PMCTRL_DFLT_PO_COMP_CODE,
i.  PMCTRL_VALIDATE_ITEM_CODE,
i.  PMCTRL_VALIDATE_PO_INFO,
i.  PMCTRL_AUTOCREATE_BID_JOB_FLAG,
i.  PMCTRL_DFLT_PLIST_COMPL_PERIOD,
i.  PMCTRL_ISSUE_ID_MASK,
i.  PMCTRL_RFI_MASK,
i.  PMCTRL_DAYJR_MASK,
i.  PMCTRL_FWD_MASK,
i.  PMCTRL_NOTICE_MASK,
i.  PMCTRL_COMMLG_MASK,
i.  PMCTRL_SELF_VEN_CODE,
i.  PMCTRL_SELF_VEN_NAME,
i.  PMCTRL_MEETING_NUMBERING_FLAG,
i.  PMCTRL_DEFAULT_BILL_TYPE_CODE,
i.  PMCTRL_DEFAULT_INVOICE_FORMAT,
i.  PMCTRL_DEFAULT_JB_MAP_CODE,
i.  PMCTRL_DEFAULT_RFI_PERIOD,
i.  PMCTRL_DFLT_COMM_FOOTNOTE,
i.  PMCTRL_UNIQUE_ISS_NUM_FLAG,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE1,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE2,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE3,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE4,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE5,
i.  PMCTRL_DFLT_LEAD_TIME_STAGE6,
i.  PMCTRL_AUTO_SBMT_FLAG,
i.  PMCTRL_SBMT_MASK,
i.  PMCTRL_DFLT_MARKUP_ROUND_RULE,
i.  PMCTRL_DFLT_MARKUP_ROUND_MTHD,
i.  PMCTRL_DFLT_MARKUP_ROUND_FLAG,
i.  PMCTRL_DFLT_DJ_GENERAL_FLAG,
i.  PMCTRL_DFLT_DJ_OWN_LAB_FLAG,
i.  PMCTRL_DFLT_DJ_TRADE_LAB_FLAG,
i.  PMCTRL_DFLT_DJ_OWN_EQP_FLAG,
i.  PMCTRL_DFLT_DJ_OE_ON_JOB_FLAG,
i.  PMCTRL_DFLT_DJ_TRADE_EQP_FLAG,
i.  PMCTRL_DFLT_DJ_MATERIALS_FLAG,
i.  PMCTRL_DFLT_DJ_VISITORS_FLAG,
i.  PMCTRL_DFLT_DJ_SAFETY_FLAG,
i.  PMCTRL_DFLT_DJ_NOTES_FLAG,
i.  PMCTRL_DFLT_DJ_ATTACHMENT_FLAG,
i.  PMCTRL_DFLT_CMDETAIL_MODE,
i.  PMCTRL_DFLT_DJ_TL_COMP_FLAG,
i.  PMCTRL_DAYJR_OE_TRAN_DISP_FLAG,
i.  PMCTRL_LIEN_WAIVER_TEXT,
i.  PMCTRL_PHS_DESC_FLAG,
i.  PMCTRL_DFLT_DJ_LAB_FORCE_FLAG,
i.  PMCTRL_ASSIGN_UNPOST_PCI_TO_SC,
i.  PMCTRL_PROJ_DOC_TYPE,
i.  PMCTRL_PROJ_DOC_ID,
i.  PMCTRL_OWNCHG_TEXT_TYPE,
i.  PMCTRL_SC_TEXT_TYPE,
i.  PMCTRL_SBMT_MASK_SEQ_PROJ,
i.  PMCTRL_COMMLG_MASK_SEQ_PROJ,
i.  PMCTRL_DAYJR_MASK_SEQ_PROJ,
i.  PMCTRL_FWD_MASK_SEQ_PROJ,
i.  PMCTRL_NOTICE_MASK_SEQ_PROJ,
i.  PMCTRL_RFI_MASK_SEQ_PROJ,
i.  PMCTRL_TRNSM_MASK_SEQ_PROJ,
i.  PMCTRL_ISSUE_ID_MASK_SEQ_PROJ,
i.  PMCTRL_SBMTP_MASK,
i.  PMCTRL_SBMTP_MASK_SEQ_PROJ,
i.  PMCTRL_OCO_PCI_EXT_ONLY_FLAG,
--i.  --PMCTRL__IU__CREATE_DATE,
--i.  --PMCTRL__IU__CREATE_USER,
--i.  --PMCTRL__IU__UPDATE_DATE,
--i.  --PMCTRL__IU__UPDATE_USER,
--i.  --PMCTRL_BID_PRE_ESTIMATE_FLAG,
i.  PMCTRL_BID_UPD_STARTED_JOB_FLG,
i.  PMCTRL_DOC_REV_REF_MAND_FLAG,
i.  PMCTRL_RFI_ACCEPT_SUGGESTION,
i.  PMCTRL_SHOW_TRNSM_CONTENTS,
i.  PMCTRL_ISSUE_TEXT_TYPE,
i.  PMCTRL_LS_PHS_CODE,
i.  PMCTRL_LS_CAT_CODE,
i.  PMCTRL_DFLT_RFQ_REVIEW_DAYS,
i.  PMCTRL_USE_PCI_SUBST_FLAG,
i.  PMCTRL_DFLT_DJ_TASKS_FLAG,
i.  PMCTRL_MEETING_ID_MASK,
i.  PMCTRL_AGENDA_ITEM_ID_MASK,
i.  PMCTRL_TASK_NAME_CRITERIA_FLAG,
i.  PMCTRL_PCI_DET_DESC_FIRST_FLAG,
i.  PMCTRL_BID_MASK_OVERRIDE,
i.  PMCTRL_SBMT_MASK_OVERRIDE,
i.  PMCTRL_SBMTP_MASK_OVERRIDE,
i.  PMCTRL_COMMLG_MASK_OVERRIDE,
i.  PMCTRL_DAYJR_MASK_OVERRIDE,
i.  PMCTRL_FWD_MASK_OVERRIDE,
i.  PMCTRL_NOTICE_MASK_OVERRIDE,
i.  PMCTRL_RFI_MASK_OVERRIDE,
i.  PMCTRL_TRNSM_MASK_OVERRIDE,
i.  PMCTRL_ISSUE_MASK_OVERRIDE,
i.  PMCTRL_OCO_ORIG_CONT_AMT_OVRD,
i.  PMCTRL_PROJ_END_DT_UPDATEABLE,
i.  PMCTRL_PMPL_MASK,
i.  PMCTRL_PMPL_MASK_OVERRIDE,
i.  PMCTRL_PMPL_MASK_SEQ_PROJ,
i.  PMCTRL_PMPLI_MASK,
i.  PMCTRL_PMPLI_MASK_SEQ_PROJ,
i.  PMCTRL_SFPO_APPROVER_PM_ROLE,
i.  PMCTRL_PHS_SEGM_SEC_FLAG,
i.  PMCTRL_CALC_OCO_DT_ON_WRKDYS

);
end loop;
--commit;
Select count(1) into v_cnt from da.PMCTRL@&to_which_database
where pmctrl_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into PMCTRL table.');
select count(1) into v_cnt_&to_which_database from da.PMCTRL@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PMCTRL@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PMCTRL table, check and commit.');
else
dbms_output.put_line ('Number of records in &from_which_database does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PMCTRL@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 