spool dcdrop.lst

PROMPT
PROMPT ======================================================================
PROMPT DCDROP.SQL: Drop all tables and packages for DATA CONVERSION.
PROMPT                  Output in: DCDROP.LST
PROMPT ======================================================================
PROMPT


set   verify            off
set   show              off
set   heading           on
set   pagesize          0
set   feedback          1
set   linesize          255
set   embedded          on
set   flush             on
set   term              on
set   serveroutput      on


PROMPT ======================================================================
PROMPT Drop table DA.DC_ERROR
PROMPT ======================================================================
drop table da.dc_error;

PROMPT ======================================================================
PROMPT Drop table DA.DC_TEMP_VIEW_TEXT
PROMPT ======================================================================
drop table da.dc_temp_view_text;

PROMPT ======================================================================
PROMPT Drop table DA.DC_IMPORT_STATUS
PROMPT ======================================================================
drop table da.dc_import_status;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPARTNERS
PROMPT ======================================================================
drop table da.dc_bpartners;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPCUSTOMERS
PROMPT ======================================================================
drop table da.dc_bpcustomers;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPVENDORS
PROMPT ======================================================================
drop table da.dc_bpvendors;

PROMPT ======================================================================
PROMPT Drop table DA.DC_GLEDGER
PROMPT ======================================================================
drop table da.dc_gledger;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCDETAIL
PROMPT ======================================================================
drop table da.dc_jcdetail;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCJOBCAT
PROMPT ======================================================================
drop table da.dc_jcjobcat;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCMCAT
PROMPT ======================================================================
drop table da.dc_jcmcat;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCJOBHPHS
PROMPT ======================================================================
drop table da.dc_jcjobhphs;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCMPHS
PROMPT ======================================================================
drop table da.dc_jcmphs;

PROMPT ======================================================================
PROMPT Drop table DA.DC_SCDETAIL
PROMPT ======================================================================
drop table da.dc_scdetail;

PROMPT ======================================================================
PROMPT Drop table DA.DC_SCMAST
PROMPT ======================================================================
drop table da.dc_scmast;

PROMPT ======================================================================
PROMPT Drop table DA.DC_VOUCHER
PROMPT ======================================================================
drop table da.dc_voucher;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CHEQUE
PROMPT ======================================================================
drop table da.dc_cheque;

PROMPT ======================================================================
PROMPT Drop table DA.DC_VOUCHQ
PROMPT ======================================================================
drop table da.dc_vouchq;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PAYCHQ
PROMPT ======================================================================
drop table da.dc_paychq;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCJOB_TABLE
PROMPT ======================================================================
drop table da.dc_jcjob_table;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPLOYEE_TABLE
PROMPT ======================================================================
drop table da.dc_pyemployee_table;

PROMPT ======================================================================
PROMPT Drop table DA.DC_VOUDIST
PROMPT ======================================================================
drop table da.dc_voudist;

PROMPT ======================================================================
PROMPT Drop table DA.DC_INVOICE
PROMPT ======================================================================
drop table da.dc_invoice;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PAYMENT
PROMPT ======================================================================
drop table da.dc_payment;

PROMPT ======================================================================
PROMPT Drop table DA.DC_INVPAY
PROMPT ======================================================================
drop table da.dc_invpay;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPPAYHIST
PROMPT ======================================================================
drop table da.dc_pyemppayhist;


PROMPT ======================================================================
PROMPT Drop table DA.DC_CMMAST_POSTED
PROMPT ======================================================================
drop table da.dc_cmmast_posted;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMMAST
PROMPT ======================================================================
drop table da.dc_cmmast;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMDETAIL_POSTED
PROMPT ======================================================================
drop table da.dc_cmdetail_posted;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMDETAIL
PROMPT ======================================================================
drop table da.dc_cmdetail;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCUTRAN
PROMPT ======================================================================

drop table da.dc_jcutran;

PROMPT ======================================================================
PROMPT Drop table DA.DC_INVDIST
PROMPT ======================================================================

drop table da.dc_invdist;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPTIMSHT
PROMPT ======================================================================

drop table da.dc_pyemptimsht;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BUDGMAST
PROMPT ======================================================================

drop table da.dc_budgmast;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BUDGET
PROMPT ======================================================================

drop table da.dc_budget;


PROMPT ======================================================================
PROMPT Drop table DA.DC_INVMEMO
PROMPT ======================================================================

drop table da.dc_invmemo;

PROMPT ======================================================================
PROMPT Drop table DA.DBK_DC_INVRLSDET
PROMPT ======================================================================

drop table da.dbk_dc_invrlsdet;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCTCAT
PROMPT ======================================================================

drop table da.dc_jctcat;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCTPHS
PROMPT ======================================================================

drop table da.dc_jctphs;


PROMPT ======================================================================
PROMPT Drop table DA.DC_PYWCBCODE
PROMPT ======================================================================

drop table da.dc_pywcbcode;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYWCBRATE
PROMPT ======================================================================

drop table da.dc_pywcbrate;


PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPHIST
PROMPT ======================================================================

drop table da.dc_pyemphist;


PROMPT ======================================================================
PROMPT Drop table DA.DC_EMACTUALLOCATION
PROMPT ======================================================================

drop table da.dc_emactuallocation;

PROMPT ======================================================================
PROMPT Drop table DA.DC_VOUMEMO
PROMPT ======================================================================

drop table da.dc_voumemo;

PROMPT ======================================================================
PROMPT Drop table DA.DC_INVRLSDET
PROMPT ======================================================================

drop table da.dc_invrlsdet;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQUIPMENT
PROMPT ======================================================================

drop table da.dc_emequipment;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQPCOMTRAN
PROMPT ======================================================================

drop table da.dc_emeqpcomtran;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQPHCOMPON
PROMPT ======================================================================

drop table da.dc_emeqphcompon;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMLOCHIST
PROMPT ======================================================================

drop table da.dc_emlochist;


PROMPT ======================================================================
PROMPT Drop table DA.DC_EMTRAN
PROMPT ======================================================================

drop table da.dc_emtran;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMDETAIL
PROMPT ======================================================================

drop table da.dc_emdetail;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMBALANCE
PROMPT ======================================================================

drop table da.dc_embalance;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMCLASSRATE
PROMPT ======================================================================

drop table da.dc_emclassrate;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQPRATE
PROMPT ======================================================================

drop table da.dc_emeqprate;


PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQPJOBRATE
PROMPT ======================================================================

drop table da.dc_emeqpjobrate;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CIITEM
PROMPT ======================================================================

drop table da.dc_ciitem;


PROMPT ======================================================================
PROMPT Drop table DA.DC_CISALEPRICE
PROMPT ======================================================================

drop table da.dc_cisaleprice;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CICMPITEM
PROMPT ======================================================================

drop table da.dc_cicmpitem;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CIITEMHDR
PROMPT ======================================================================

drop table da.dc_ciitemhdr;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CIITEMDET
PROMPT ======================================================================

drop table da.dc_ciitemdet;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CISTDCST
PROMPT ======================================================================

drop table da.dc_cistdcst;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPADDRESSES
PROMPT ======================================================================

drop table da.dc_bpaddresses;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYWCBJOB
PROMPT ======================================================================

drop table da.dc_pywcbjob;

PROMPT ======================================================================
PROMPT Drop table DA.DC_ACCOUNT
PROMPT ======================================================================

drop table da.dc_account;

PROMPT ======================================================================
PROMPT Drop table DA.DC_POMAST
PROMPT ======================================================================

drop table da.dc_pomast;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PODETAIL
PROMPT ======================================================================

drop table da.dc_podetail;

PROMPT ======================================================================
PROMPT Drop table DA.DC_POCOMAST
PROMPT ======================================================================

drop table da.dc_pocomast;

PROMPT ======================================================================
PROMPT Drop table DA.DC_POCODET
PROMPT ======================================================================

drop table da.dc_pocodet;

PROMPT ======================================================================
PROMPT Drop table DA.DC_VOURLSDET
PROMPT ======================================================================

drop table da.dc_vourlsdet;

PROMPT ======================================================================
PROMPT Drop table DA.DC_SCSCHED
PROMPT ======================================================================

drop table da.dc_scsched;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPSALSPL
PROMPT ======================================================================
drop table da.dc_pyempsalspl;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRCLASS
PROMPT ======================================================================
drop table da.dc_hrclass;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRSUITPOS
PROMPT ======================================================================
drop table DA.DC_HRSUITPOS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRAPPLICANTS
PROMPT ======================================================================
drop table DA.DC_HRAPPLICANTS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRINTTRAINING
PROMPT ======================================================================
drop table DA.DC_HRINTTRAINING;

PROMPT ======================================================================
PROMPT Drop table DA.DC_FAASSET
PROMPT ======================================================================
drop table DA.DC_FAASSET;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYCHECKS
PROMPT ======================================================================
drop table DA.DC_PYCHECKS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYTAXEXM
PROMPT ======================================================================
drop table DA.DC_VOURLSDET;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYTAXEXM
PROMPT ======================================================================
drop table DA.DC_PYTAXEXM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYTAXEMP
PROMPT ======================================================================
drop table DA.DC_PYTAXEMP;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMEQPTRAN_V
PROMPT ======================================================================
drop table DA.DC_EMEQPTRAN_V;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMRATEREVETYPE_V
PROMPT ======================================================================
drop table DA.DC_EMRATEREVTYPE_V;

PROMPT ======================================================================
PROMPT Drop table DA.DC_APPURCHASEAGREEMENT
PROMPT ======================================================================
drop table DA.DC_APPURCHASEAGREEMENT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_APPURCHASEAGREEMENTDET
PROMPT ======================================================================
drop table DA.DC_APPURCHASEAGREEMENTDET;

PROMPT ======================================================================
PROMPT Drop table DA.DC_APMATERIALRECEIPT
PROMPT ======================================================================
drop table DA.DC_APMATERIALRECEIPT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMTRANPOST
PROMPT ======================================================================
drop table DA.DC_EMTRANPOST;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMTRANDIST
PROMPT ======================================================================
drop table DA.DC_EMTRANDIST;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JC_JOB_PHASE_PROJECTION
PROMPT ======================================================================
drop table DA.DC_JC_JOB_PHASE_PROJECTION;

PROMPT ======================================================================
PROMPT Drop table DA.DC_ACCOUNT
PROMPT ======================================================================
drop table DA.DC_JC_ACCOUNT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_DEPT_TABLE
PROMPT ======================================================================
drop table DA.DC_DEPT_TABLE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYTRADES
PROMPT ======================================================================
drop table DA.DC_PYTRADES;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMPROJECT_TABLE
PROMPT ======================================================================
drop table DA.DC_PMPROJECT_TABLE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_ADDRESS
PROMPT ======================================================================
drop table DA.DC_ADDRESS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPLEAVE
PROMPT ======================================================================
drop table DA.DC_PYEMPLEAVE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPLEAVEHIST
PROMPT ======================================================================
drop table DA.DC_PYEMPLEAVEHIST;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPBEN
PROMPT ======================================================================
drop table DA.DC_PYEMPBEN;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPDED
PROMPT ======================================================================
drop table DA.DC_PYEMPDED;

PROMPT ======================================================================
PROMPT Drop table DA.DC_LOCATION_TABLE
PROMPT ======================================================================
drop table DA.DC_LOCATION_TABLE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMPROJPARTNER
PROMPT ======================================================================
drop table DA.DC_PMPROJPARTNER;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMPROJCONTACT
PROMPT ======================================================================
drop table DA.DC_PMPROJCONTACT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMRFI
PROMPT ======================================================================
drop table DA.DC_PMRFI;

PROMPT ======================================================================
PROMPT Drop table DA.DC_DMISSUE
PROMPT ======================================================================
drop table DA.DC_DMISSUE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMSUBMITTAL
PROMPT ======================================================================
drop table DA.DC_PMSUBMITTAL;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMSUBMITPACKAGE
PROMPT ======================================================================
drop table DA.DC_PMSUBMITPACKAGE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMHISTORY
PROMPT ======================================================================
drop table DA.DC_PMHISTORY;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMJOURNAL
PROMPT ======================================================================
drop table DA.DC_PMJOURNAL;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMJOUROLAB
PROMPT ======================================================================
drop table DA.DC_PMJOUROLAB;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMJOURTEQP
PROMPT ======================================================================
drop table DA.DC_PMJOURTEQP;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMJOURTLAB
PROMPT ======================================================================
drop table DA.DC_PMJOURTLAB;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMJOURVIS
PROMPT ======================================================================
drop table DA.DC_PMJOURVIS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMDESCRIPTION
PROMPT ======================================================================
drop table DA.DC_PMDESCRIPTION;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMUSERFFDATA
PROMPT ======================================================================
drop table DA.DC_PMUSERFFDATA;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMMEETING
PROMPT ======================================================================
drop table DA.DC_PMMEETING;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMMEETINGTRACK
PROMPT ======================================================================
drop table DA.DC_PMMEETINGTRACK;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMMEETINGITEM
PROMPT ======================================================================
drop table DA.DC_PMMEETINGITEM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMMEETINGATTND
PROMPT ======================================================================
drop table DA.DC_PMMEETINGATTND;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMNOTES
PROMPT ======================================================================
drop table DA.DC_PMNOTES;

PROMPT ======================================================================
PROMPT Drop table DA.DC_SYSCONTACT
PROMPT ======================================================================
drop table DA.DC_SYSCONTACT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRINCIDENT
PROMPT ======================================================================
drop table DA.DC_HRINCIDENT;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRELECTEDPLANS_EM
PROMPT ======================================================================
drop table DA.DC_HRELECTEDPLANS_EM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMDETVENDATA
PROMPT ======================================================================
drop table DA.DC_CMDETVENDATA;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMDETVENDATA_POSTED
PROMPT ======================================================================
drop table DA.DC_CMDETVENDATA_POSTED;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMTRANSMITTAL_TABLE
PROMPT ======================================================================
drop table DA.DC_PMTRANSMITTAL_TABLE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMTRNSMDETAIL
PROMPT ======================================================================
drop table DA.DC_PMTRNSMDETAIL;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPMARKETSECTOR
PROMPT ======================================================================
drop table DA.DC_BPMARKETSECTOR;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMRELATIVES
PROMPT ======================================================================
drop table DA.DC_HREMRELATIVES;

PROMPT ======================================================================
PROMPT Drop table DA.DC_JCJOBSECGRPPROJ
PROMPT ======================================================================
drop table DA.DC_JCJOBSECGRPPROJ;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYACCESSCODE
PROMPT ======================================================================
drop table DA.DC_PYACCESSCODE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPSECGRPEMP
PROMPT ======================================================================
drop table DA.DC_PYEMPSECGRPEMP;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMPSAFEHRS
PROMPT ======================================================================
drop table DA.DC_HREMPSAFEHRS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_INSDETAIL
PROMPT ======================================================================
drop table DA.DC_INSDETAIL;

PROMPT ======================================================================
PROMPT Drop table DA.DC_NONSTOCKITEM
PROMPT ======================================================================
drop table DA.DC_NONSTOCKITEM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BABANK
PROMPT ======================================================================
drop table DA.DC_BABANK;

PROMPT ======================================================================
PROMPT Drop table DA.DC_APREGINV
PROMPT ======================================================================
drop table DA.DC_APREGINV;

PROMPT ======================================================================
PROMPT Drop table DA.DC_APREGDIST
PROMPT ======================================================================
drop table DA.DC_APREGDIST;

PROMPT ======================================================================
PROMPT Drop table DA.DC_OMOPPORTUNITY
PROMPT ======================================================================
drop table DA.DC_OMOPPORTUNITY;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HRTRAININGS
PROMPT ======================================================================
drop table DA.DC_HRTRAININGS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_CMOWNCHGNUM
PROMPT ======================================================================
drop table DA.DC_CMOWNCHGNUM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PMFWD
PROMPT ======================================================================
drop table DA.DC_PMFWD;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PONSITM
PROMPT ======================================================================
drop table DA.DC_PONSITM;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYTAXCAEMP
PROMPT ======================================================================
drop table DA.DC_PYTAXCAEMP;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PRMWORKORDERS
PROMPT ======================================================================
drop table DA.DC_PRMWORKORDERS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_BPBANKS
PROMPT ======================================================================
drop table DA.DC_BPBANKS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYBENTRD
PROMPT ======================================================================
drop table DA.DC_PYBENTRD;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYEMPLOAN
PROMPT ======================================================================
drop table DA.DC_PYEMPLOAN;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PYJOBPAYRATE
PROMPT ======================================================================
drop table DA.DC_PYJOBPAYRATE;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMPCERTLIC
PROMPT ======================================================================
drop table DA.DC_HREMPCERTLIC;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMPEDU
PROMPT ======================================================================
drop table DA.DC_HREMPEDU;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMPMEMS
PROMPT ======================================================================
drop table DA.DC_HREMPMEMS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_HREMPSKILLS
PROMPT ======================================================================
drop table DA.DC_HREMPSKILLS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PRMTASKS
PROMPT ======================================================================
drop table DA.DC_PRMTASKS;

PROMPT ======================================================================
PROMPT Drop table DA.DC_PRMSCHEDRULES
PROMPT ======================================================================
drop table DA.DC_PRMSCHEDRULES;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMCLASSTRAN_V
PROMPT ======================================================================
drop table DA.DC_EMCLASSTRAN_V;

PROMPT ======================================================================
PROMPT Drop table DA.DC_EMRATE_V
PROMPT ======================================================================
drop table DA.DC_EMRATE_V;



--Drop all packages




PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC
PROMPT ======================================================================
drop package da.dbk_dc;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPARTNERS
PROMPT ======================================================================
drop package da.dbk_dc_bpartners;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPCUSTOMERS
PROMPT ======================================================================
drop package da.dbk_dc_bpcustomers;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPVENDORS
PROMPT ======================================================================
drop package da.dbk_dc_bpvendors;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_GLEDGER
PROMPT ======================================================================
drop package da.dbk_dc_gledger;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCDETAIL
PROMPT ======================================================================
drop package da.dbk_dc_jcdetail;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCJOBCAT
PROMPT ======================================================================
drop package da.dbk_dc_jcjobcat;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCMCAT
PROMPT ======================================================================
drop package da.dbk_dc_jcmcat;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCJOBHPHS
PROMPT ======================================================================
drop package da.dbk_dc_jcjobhphs;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCMPHS
PROMPT ======================================================================
drop package da.dbk_dc_jcmphs;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_SCDETAIL
PROMPT ======================================================================
drop package da.dbk_dc_scdetail;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_SCMAST
PROMPT ======================================================================
drop package da.dbk_dc_scmast;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VOUCHER
PROMPT ======================================================================
drop package da.dbk_dc_voucher;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CHEQUE
PROMPT ======================================================================
drop package da.dbk_dc_cheque;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VOUCHQ
PROMPT ======================================================================
drop package da.dbk_dc_vouchq;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PAYCHQ
PROMPT ======================================================================
drop package da.dbk_dc_paychq;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCJOB_TABLE
PROMPT ======================================================================
drop package da.dbk_dc_jcjob_table;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPLOYEE_TABLE
PROMPT ======================================================================
drop package da.dbk_dc_pyemployee_table;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VOUDIST
PROMPT ======================================================================
drop package da.dbk_dc_voudist;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INVOICE
PROMPT ======================================================================
drop package da.dbk_dc_invoice;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PAYMENT
PROMPT ======================================================================
drop package da.dbk_dc_payment;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INVPAY
PROMPT ======================================================================
drop package da.dbk_dc_invpay;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPPAYHIST
PROMPT ======================================================================
drop package da.dbk_dc_pyemppayhist;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMMAST_POSTED
PROMPT ======================================================================
drop package da.dbk_dc_cmmast_posted;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMMAST
PROMPT ======================================================================
drop package da.dbk_dc_cmmast;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMDETAIL_POSTED
PROMPT ======================================================================
drop package da.dbk_dc_cmdetail_posted;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMDETAIL
PROMPT ======================================================================
drop package da.dbk_dc_cmdetail;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCUTRAN
PROMPT ======================================================================
drop package da.dbk_dc_jcutran;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INVDIST
PROMPT ======================================================================
drop package da.dbk_dc_invdist;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPTIMSHT
PROMPT ======================================================================
drop package da.dbk_dc_pyemptimsht;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BUDGMAST
PROMPT ======================================================================
drop package da.dbk_dc_budgmast;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BUDGET
PROMPT ======================================================================
drop package da.dbk_dc_budget;


PROMPT ======================================================================
PROMPT Drop package DA.DC_INVMEMO
PROMPT ======================================================================
drop package da.dbk_dc_invmemo;


PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCTCAT
PROMPT ======================================================================
drop package da.dbk_dc_jctcat;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCTPHS
PROMPT ======================================================================
drop package da.dbk_dc_jctphs;


PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYWCBCODE
PROMPT ======================================================================
drop package da.dbk_dc_pywcbcode;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYWCBRATE
PROMPT ======================================================================
drop package da.dbk_dc_pywcbrate;


PROMPT ======================================================================
PROMPT Drop table DA.DBK_DC_PYEMPHIST
PROMPT ======================================================================
drop package da.dbk_dc_pyemphist;


PROMPT ======================================================================
PROMPT Drop table DA.DBK_DC_EMACTUALLOCATION
PROMPT ======================================================================
drop package da.dbk_dc_emactuallocation;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VOUMEMO
PROMPT ======================================================================
drop package da.dbk_dc_voumemo;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQUIPMENT
PROMPT ======================================================================
drop package da.dbk_dc_emequipment;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQPCOMTRAN
PROMPT ======================================================================
drop package da.dbk_dc_emeqpcomtran;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQPHCOMPON
PROMPT ======================================================================
drop package da.dbk_dc_emeqphcompon;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMLOCHIST
PROMPT ======================================================================
drop package da.dbk_dc_emlochist;


PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMTRAN
PROMPT ======================================================================
drop package da.dbk_dc_emtran;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMDETAIL
PROMPT ======================================================================
drop package da.dbk_dc_emdetail;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMBALANCE
PROMPT ======================================================================
drop package da.dbk_dc_embalance;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMCLASSRATE
PROMPT ======================================================================
drop package da.dbk_dc_emclassrate;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQPRATE
PROMPT ======================================================================
drop package da.dbk_dc_emeqprate;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQPJOBRATE
PROMPT ======================================================================
drop package da.dbk_dc_emeqpjobrate;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CIITEM
PROMPT ======================================================================
drop package da.dbk_dc_ciitem;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CISALEPRICE
PROMPT ======================================================================
drop package da.dbk_dc_cisaleprice;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CICMPITEM
PROMPT ======================================================================
drop package da.dbk_dc_cicmpitem;


PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CIITEMHDR
PROMPT ======================================================================

drop package da.dbk_dc_ciitemhdr;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CIITEMDET
PROMPT ======================================================================

drop package da.dbk_dc_ciitemdet;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CISTDCST
PROMPT ======================================================================

drop package da.dbk_dc_cistdcst;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPADDRESSES
PROMPT ======================================================================

drop package da.dbk_dc_bpaddresses;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYWCBJOB
PROMPT ======================================================================

drop package da.dbk_dc_pywcbjob;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_ACCOUNT
PROMPT ======================================================================

drop package da.dbk_dc_account;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_POMAST
PROMPT ======================================================================

drop package da.dbk_dc_pomast;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PODETAIL
PROMPT ======================================================================

drop package da.dbk_dc_podetail;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_POCOMAST
PROMPT ======================================================================

drop package da.dbk_dc_pocomast;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_POCODET
PROMPT ======================================================================

drop package da.dbk_dc_pocodet;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_SCSCHED
PROMPT ======================================================================

drop package da.dbk_dc_scsched;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPSALSPL
PROMPT ======================================================================

drop package DA.DBK_DC_PYEMPSALSPL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRCLASS
PROMPT ======================================================================
drop package DA.DBK_dc_hrclass;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRSUITPOS
PROMPT ======================================================================
drop package DA.DBK_DC_HRSUITPOS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRAPPLICANTS
PROMPT ======================================================================
drop package DA.DBK_DC_HRAPPLICANTS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRINTTRAINING
PROMPT ======================================================================
drop package DA.DBK_DC_HRINTTRAINING;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_FAASSET
PROMPT ======================================================================
drop package DA.DBK_DC_FAASSET;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYCHECKS
PROMPT ======================================================================
drop package DA.DBK_DC_PYCHECKS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VOURLSDET
PROMPT ======================================================================
drop package DA.DBK_DC_VOURLSDET;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYTAXEXM
PROMPT ======================================================================
drop package DA.DBK_DC_PYTAXEXM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYTAXEMP
PROMPT ======================================================================
drop package DA.DBK_DC_PYTAXEMP;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPSALSPL
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPSALSPL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INVRLSDET
PROMPT ======================================================================
drop package DA.DBK_DC_INVRLSDET;

PROMPT ======================================================================
PROMPT Drop procedure DA.DBP_DC_SCDETAIL
PROMPT ======================================================================
drop procedure DA.DBP_DC_SCDETAIL;

PROMPT ======================================================================
PROMPT Drop procedure DA.DBP_DC_SCDETAIL_BY_COMP
PROMPT ======================================================================
drop procedure DA.DBP_DC_SCDETAIL_BY_COMP;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INVRLSDET
PROMPT ======================================================================
drop package DA.DBK_DC_POCO;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMEQPTRAN_V
PROMPT ======================================================================
drop package DA.DBK_DC_EMEQPTRAN_V;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMRATEREVTYPE_V
PROMPT ======================================================================
drop package DA.DBK_DC_EMRATEREVTYPE_V;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_APPURCHASEAGREEMENT
PROMPT ======================================================================
drop package DA.DBK_DC_APPURCHASEAGREEMENT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_APPURCHASEAGREEMENTDET
PROMPT ======================================================================
drop package DA.DBK_DC_APPURCHASEAGREEMENTDET;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_APMATERIALRECEIPT
PROMPT ======================================================================
drop package DA.DBK_DC_APMATERIALRECEIPT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMTRANPOST
PROMPT ======================================================================
drop package DA.DBK_DC_EMTRANPOST;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMTRANDIST
PROMPT ======================================================================
drop package DA.DBK_DC_EMTRANDIST;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JC_JOB_PHASE_PROJECTION
PROMPT ======================================================================
drop package DA.DBK_DC_JC_JOB_PHASE_PROJECTION;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_ACCOUNT
PROMPT ======================================================================
drop package DA.DBK_DC_ACCOUNT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_DEPT_TABLE
PROMPT ======================================================================
drop package DA.DBK_DC_DEPT_TABLE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYTRADES
PROMPT ======================================================================
drop package DA.DBK_DC_PYTRADES;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMPROJECT_TABLE
PROMPT ======================================================================
drop package DA.DBK_DC_PMPROJECT_TABLE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_ADDRESS
PROMPT ======================================================================
drop package DA.DBK_DC_ADDRESS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPLEAVE
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPLEAVE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPLEAVEHIST
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPLEAVEHIST;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPBEN
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPBEN;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPDED
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPDED;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_LOCATION_TABLE
PROMPT ======================================================================
drop package DA.DBK_DC_LOCATION_TABLE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMPROJPARTNER
PROMPT ======================================================================
drop package DA.DBK_DC_PMPROJPARTNER;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMPROJCONTACT
PROMPT ======================================================================
drop package DA.DBK_DC_PMPROJCONTACT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMRFI
PROMPT ======================================================================
drop package DA.DBK_DC_PMRFI;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_DMISSUE
PROMPT ======================================================================
drop package DA.DBK_DC_DMISSUE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMSUBMITTAL
PROMPT ======================================================================
drop package DA.DBK_DC_PMSUBMITTAL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMSUBMITPACKAGE
PROMPT ======================================================================
drop package DA.DBK_DC_PMSUBMITPACKAGE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMHISTORY
PROMPT ======================================================================
drop package DA.DBK_DC_PMHISTORY;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMJOURNAL
PROMPT ======================================================================
drop package DA.DBK_DC_PMJOURNAL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMJOUROLAB
PROMPT ======================================================================
drop package DA.DBK_DC_PMJOUROLAB;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMJOURTEQP
PROMPT ======================================================================
drop package DA.DBK_DC_PMJOURTEQP;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMJOURTLAB
PROMPT ======================================================================
drop package DA.DBK_DC_PMJOURTLAB;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMJOURVIS
PROMPT ======================================================================
drop package DA.DBK_DC_PMJOURVIS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMDESCRIPTION
PROMPT ======================================================================
drop package DA.DBK_DC_PMDESCRIPTION;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMUSERFFDATA
PROMPT ======================================================================
drop package DA.DBK_DC_PMUSERFFDATA;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMMEETING
PROMPT ======================================================================
drop package DA.DBK_DC_PMMEETING;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMMEETINGTRACK
PROMPT ======================================================================
drop package DA.DBK_DC_PMMEETINGTRACK;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMMEETINGITEM
PROMPT ======================================================================
drop package DA.DBK_DC_PMMEETINGITEM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMMEETINGATTND
PROMPT ======================================================================
drop package DA.DBK_DC_PMMEETINGATTND;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMNOTES
PROMPT ======================================================================
drop package DA.DBK_DC_PMNOTES;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_SYSCONTACT
PROMPT ======================================================================
drop package DA.DBK_DC_SYSCONTACT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRINCIDENT
PROMPT ======================================================================
drop package DA.DBK_DC_HRINCIDENT;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRELECTEDPLANS_EM
PROMPT ======================================================================
drop package DA.DBK_DC_HRELECTEDPLANS_EM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMDETVENDATA
PROMPT ======================================================================
drop package DA.DBK_DC_CMDETVENDATA;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMTRANSMITTAL_TABLE
PROMPT ======================================================================
drop package DA.DBK_DC_PMTRANSMITTAL_TABLE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMDETVENDATA_POSTED
PROMPT ======================================================================
drop package DA.DBK_DC_CMDETVENDATA_POSTED;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMTRNSMDETAIL
PROMPT ======================================================================
drop package DA.DBK_DC_PMTRNSMDETAIL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPMARKETSECTOR
PROMPT ======================================================================
drop package DA.DBK_DC_BPMARKETSECTOR;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMRELATIVES
PROMPT ======================================================================
drop package DA.DBK_DC_HREMRELATIVES;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_JCJOBSECGRPPROJ
PROMPT ======================================================================
drop package DA.DBK_DC_JCJOBSECGRPPROJ;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYACCESSCODE
PROMPT ======================================================================
drop package DA.DBK_DC_PYACCESSCODE;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPSECGRPEMP
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPSECGRPEMP;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMPSAFEHRS
PROMPT ======================================================================
drop package DA.DBK_DC_HREMPSAFEHRS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_INSDETAIL
PROMPT ======================================================================
drop package DA.DBK_DC_INSDETAIL;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_NONSTOCKITEM
PROMPT ======================================================================
drop package DA.DBK_DC_NONSTOCKITEM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BABANK
PROMPT ======================================================================
drop package DA.DBK_DC_BABANK;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_APREGINV
PROMPT ======================================================================
drop package DA.DBK_DC_APREGINV;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_APREGDIST
PROMPT ======================================================================
drop package DA.DBK_DC_APREGDIST;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_OMOPPORTUNITY
PROMPT ======================================================================
drop package DA.DBK_DC_OMOPPORTUNITY;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HRTRAININGS
PROMPT ======================================================================
drop package DA.DBK_DC_HRTRAININGS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_CMOWNCHGNUM
PROMPT ======================================================================
drop package DA.DBK_DC_CMOWNCHGNUM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PMFWD
PROMPT ======================================================================
drop package DA.DBK_DC_PMFWD;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PONSTIM
PROMPT ======================================================================
drop package DA.DBK_DC_PONSITM;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYTAXCAEMP
PROMPT ======================================================================
drop package DA.DBK_DC_PYTAXCAEMP;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PRMWORKORDERS
PROMPT ======================================================================
drop package DA.DBK_DC_PRMWORKORDERS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_BPBANKS
PROMPT ======================================================================
drop package DA.DBK_DC_BPBANKS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYBENTRD
PROMPT ======================================================================
drop package DA.DBK_DC_PYBENTRD;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYEMPLOAN
PROMPT ======================================================================
drop package DA.DBK_DC_PYEMPLOAN;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PYJOBPAYRATE
PROMPT ======================================================================
drop package DA.DBK_DC_PYJOBPAYRATE;.

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMPCERTLIC
PROMPT ======================================================================
drop package DA.DBK_DC_HREMPCERTLIC;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMPEDU
PROMPT ======================================================================
drop package DA.DBK_DC_HREMPEDU;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMPMEMS
PROMPT ======================================================================
drop package DA.DBK_DC_HREMPMEMS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_HREMPSKILLS
PROMPT ======================================================================
drop package DA.DBK_DC_HREMPSKILLS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PRMTASKS
PROMPT ======================================================================
drop package DA.DBK_DC_PRMTASKS;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_PRMSCHEDRULES
PROMPT ======================================================================
drop package DA.DBK_DC_PRMSCHEDRULES;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMCLASSTRAN_V
PROMPT ======================================================================
drop package DA.DBK_DC_EMCLASSTRAN_V;

PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_EMRATE_V
PROMPT ======================================================================
drop package DA.DBK_DC_EMRATE_V;


PROMPT ======================================================================
PROMPT Drop package DA.DBK_DC_VERIFY
PROMPT ======================================================================
drop package DA.DBK_DC_VERIFY;


PROMPT ======================================================================
PROMPT Check number of objects left
PROMPT ======================================================================
select object_name
from all_objects
where (object_name like 'DC\_%' escape '\')
  or  (object_name like 'DBK\_DC\_%'  escape '\')
/

spool off
