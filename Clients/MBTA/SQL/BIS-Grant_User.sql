REM **********************  NOTE ************************
REM *****************************************************
REM Changes made to this script must also be made to bisgrantrole.sql
REM *****************************************************
REM CHANGES MADE ON 23-JUN-2002 - MARCEL RICHARD
REM 11 Oct 2002   GG      #02.53400 discoverer schedule requires direct grants of tables 
REM ***********************************************
REM RE-CREATION OF GRANT SCRIPT TO ROLE FOR AUSTIN. (28-JUL-2003)
REM ***********************************************
REM CHANGES MADE TO PM, JB, AND OM BY MARCEL ON 28-FEB-2005
REM ALL TABLES/VIEWS CONFIRMED AS VALID ON 28-FEB-2005 AS PER CMiC SUPPORT2004

set feedback  1
set scan      on
set verify    off
set trimspool on    

spool mbisgrant_schedule.lst

UNDEFINE c_user_name

Prompt Grant select table access to user &&C_user_name...

REM GL
 grant select on DA.ACCOUNT to &&C_user_name;
 grant select on DA.ACCTYPE to &&C_user_name;
 grant select on DA.BALANCE to &&C_user_name;
 grant select on DA.BUDGET to &&C_user_name;
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.CONSCHART to &&C_user_name;
 grant select on DA.DEPT to &&C_user_name;
 grant select on DA.PERIOD to &&C_user_name;
 grant select on DA.GLACTIVITY to &&C_user_name;
 grant select on DA.GLEDGER to &&C_user_name;
 grant select on DA.GLTAC to &&C_user_name;
 grant select on DA.GLTAV to &&C_user_name;
 grant select on DA.GL_ACC_NAME_V to &&C_user_name;
 grant select on DA.GL_TEMP_FORMAT_COLUMN to &&C_user_name;
REM AP
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.BPVENDORS to &&C_user_name;
 grant select on DA.VOUCHER to &&C_user_name;
 grant select on DA.CHEQUE to &&C_user_name;
 grant select on DA.VOUCHQ to &&C_user_name;
 grant select on DA.VOUDIST to &&C_user_name;
 grant select on DA.VOUMEMO to &&C_user_name;
 grant select on DA.VOUADJ to &&C_user_name;
 grant select on DA.VOUBCH_TABLE to &&C_user_name;
 grant select on DA.APGLDIST to &&C_user_name;
 grant select on DA.APINVSERC to &&C_user_name;
 grant select on DA.VENCLASS to &&C_user_name;
 grant select on DA.BPARTNERS to &&C_user_name;
REM AR
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.BPCUSTOMERS to &&C_user_name;
 grant select on DA.INVOICE to &&C_user_name;
 grant select on DA.PAYMENT to &&C_user_name;
 grant select on DA.INVDIST to &&C_user_name;
 grant select on DA.INVPAY to &&C_user_name;
 grant select on DA.INVMEMO to &&C_user_name;
 grant select on DA.INVADJ to &&C_user_name;
 grant select on DA.INVFIN to &&C_user_name;
 grant select on DA.ARINVHEAD to &&C_user_name;
 grant select on DA.ARINVDET to &&C_user_name;
 grant select on DA.ARBATCH_TABLE to &&C_user_name;
 grant select on DA.ARGLDIST to &&C_user_name;
 grant select on DA.ARINVSERC to &&C_user_name;
 grant select on DA.ARNOTES to &&C_user_name;
 grant select on DA.ARTAX to &&C_user_name;
 grant select on DA.COLLECT to &&C_user_name;
 grant select on DA.CUSTCLAS to &&C_user_name;
REM JC
 grant select on DA.JCJOB to &&C_user_name;
 grant select on DA.JCDETAIL to &&C_user_name;
 grant select on DA.JCJOBCAT to &&C_user_name;
 grant select on DA.JCMPHS to &&C_user_name;
 grant select on DA.JCJOBHPHS to &&C_user_name;
 grant select on DA.JCCAT to &&C_user_name;
 grant select on DA.JCBAL to &&C_user_name;
 grant select on DA.JCBATCH_TABLE to &&C_user_name;
 grant select on DA.JCBILLRATE to &&C_user_name;
 grant select on DA.JCINVOICE to &&C_user_name;
 grant select on DA.JCNOTES to &&C_user_name;
 grant select on DA.JCSNAPSHOT to &&C_user_name;
 grant select on DA.JCSNPSHTDET to &&C_user_name;
 grant select on DA.JC0000_V to &&C_user_name;
 grant select on DA.JCJSQRY1_v to &&C_user_name;
REM PY
 grant select on DA.PYEMPLOYEE to &&C_user_name;
 grant select on DA.PYEMPTIMSHT to &&C_user_name;
 grant select on DA.PYEMPPAYHIST to &&C_user_name;
 grant select on DA.PYCHECKS to &&C_user_name;
 grant select on DA.PYEMPHIST to &&C_user_name;
 grant select on DA.PYEMPBEN to &&C_user_name;
 grant select on DA.PYEMPDED to &&C_user_name;
 grant select on DA.PYEMPPAYRATE to &&C_user_name;
 grant select on DA.PYBDPLAN to &&C_user_name;
 grant select on DA.PYBENEFIT to &&C_user_name;
 grant select on DA.PYDEDUCTION to &&C_user_name;
 grant select on DA.PYCOMBEN to &&C_user_name;
 grant select on DA.PYCOMDED to &&C_user_name;
 grant select on DA.PYEXPENSE to &&C_user_name;
 grant select on DA.PYCOMLEAVE to &&C_user_name;
 grant select on DA.PYCOMLOAN to &&C_user_name;
 grant select on DA.PYCOMPAYPRD to &&C_user_name;
 grant select on DA.PYTAX to &&C_user_name;
 grant select on DA.PYTAXCA to &&C_user_name;
 grant select on DA.PYWORKLOC to &&C_user_name;
 grant select on DA.PYCOMPAYGRP to &&C_user_name;
 grant select on DA.PYEMPTIMSHT_CERT to &&C_user_name;
 grant select on DA.PYPAYRUN to &&C_user_name;
 grant select on DA.PYTRADES to &&C_user_name;
 grant select on DA.PYTRDPAYRATE to &&C_user_name;
 grant select on DA.PYUNIONS to &&C_user_name;
 grant select on DA.PYUNIBEN to &&C_user_name;
 grant select on DA.PYUNIDED to &&C_user_name;
 grant select on DA.PYUNIPAYRATE to &&C_user_name;
 grant select on DA.PYCOMFEIN to &&C_user_name;
 grant select on DA.PYTRANDESC_VW to &&C_user_name;
 grant select on DA.PYEMPTIMSHT_IMP to &&C_user_name;
 grant select on DA.IMP_PYEMPTIMSHT to &&C_user_name;
REM SC
 grant select on DA.SCMAST to &&C_user_name;
 grant select on DA.SCSCHED to &&C_user_name;
 grant select on DA.INSTYPE to &&C_user_name;
 grant select on DA.INSDETAIL to &&C_user_name;
 grant select on DA.INSVOU to &&C_user_name;
REM PB
 grant select on DA.PBCONT to &&C_user_name;
 grant select on DA.PBILLING to &&C_user_name;
 grant select on DA.PBDRAWDETAIL to &&C_user_name;
 grant select on DA.PBGROUP to &&C_user_name;
 grant select on DA.PBITEMNAMES to &&C_user_name;
 grant select on DA.PBBILLMASTER to &&C_user_name;
REM CM
 grant select on DA.CMMAST to &&C_user_name;
 grant select on DA.CMDETAIL to &&C_user_name;
 grant select on DA.CMMAST_POSTED to &&C_user_name;
 grant select on DA.CMDETAIL_POSTED to &&C_user_name;
 grant select on DA.CMSTATUS to &&C_user_name;
 grant select on DA.CMTYPE to &&C_user_name;
REM EC
 grant select on DA.EMEQUIPMENT to &&C_user_name;
 grant select on DA.EMDETAIL to &&C_user_name;
 grant select on DA.EMBALANCE to &&C_user_name;
 grant select on DA.EMEQPCLASS to &&C_user_name;
 grant select on DA.EMLOCHIST to &&C_user_name;
 grant select on DA.EMHOMELOCATION to &&C_user_name;
 grant select on DA.EMEQPCAT1 to &&C_user_name;
 grant select on DA.EMCLASSRATE to &&C_user_name;
 grant select on DA.EMEQPRATE to &&C_user_name;
 grant select on DA.EMEQPJOBRATE to &&C_user_name;
 grant select on DA.EMBATCH to &&C_user_name;
 grant select on DA.EMACTUALLOCATION to &&C_user_name;
 grant select on DA.EMTRANCODE to &&C_user_name;
 grant select on DA.EMTRANPOST to &&C_user_name;
REM PRM
 grant select on DA.PRMWORKORDERS to &&C_user_name;
 grant select on DA.PRMWORKITEMS to &&C_user_name;
 grant select on DA.PRMWORKITEMS_POSTED to &&C_user_name;
 grant select on DA.PRMLASTEQPSVC to &&C_user_name;
 grant select on DA.PRMACCAUDIT to &&C_user_name;
 grant select on DA.PRMACCUMULTRS to &&C_user_name;
 grant select on DA.PRMBUDGET to &&C_user_name;
 grant select on DA.PRMACTIVITIES to &&C_user_name;
 grant select on DA.PRMBUDGET_POSTED to &&C_user_name;
 grant select on DA.PRMDETAIL to &&C_user_name;
 grant select on DA.PRMEXPALLOC to &&C_user_name;
 grant select on DA.PRMEXPCODE to &&C_user_name;
 grant select on DA.PRMSCHEDRULES to &&C_user_name;
 grant select on DA.PRMTASKS to &&C_user_name;
 grant select on DA.PRMTRANCODES to &&C_user_name;
 grant select on DA.PRMGLDIST to &&C_user_name;
 grant select on DA.PRMNOTES to &&C_user_name;
 grant select on DA.PRMBATCH to &&C_user_name;
REM PO
 grant select on DA.POMAST to &&C_user_name;
 grant select on DA.PODETAIL to &&C_user_name;
 grant select on DA.POCOMAST to &&C_user_name;
 grant select on DA.POCODET to &&C_user_name;
 grant select on DA.POSHIPMENT to &&C_user_name;
 grant select on DA.POSHIPMDET to &&C_user_name;
 grant select on DA.PODETACC to &&C_user_name;
 grant select on DA.POBLANKET to &&C_user_name;
 grant select on DA.POBLDET to &&C_user_name;
 grant select on DA.POFFITM to &&C_user_name;
 grant select on DA.PONSITM to &&C_user_name;
 grant select on DA.PORESGR to &&C_user_name;
 grant select on DA.PORESGRNUMBERS to &&C_user_name;
 grant select on DA.POSTATUS to &&C_user_name;
 grant select on DA.POBATCH to &&C_user_name;
REM CI
 grant select on DA.CIITEM to &&C_user_name;
 grant select on DA.CIITEMDET to &&C_user_name;
 grant select on DA.CIBALANCE to &&C_user_name;
 grant select on DA.CIALLOC to &&C_user_name;
 grant select on DA.CITRANDET_POSTED to &&C_user_name;
 grant select on DA.CICLASS to &&C_user_name;
 grant select on DA.CICMPITEM to &&C_user_name;
 grant select on DA.CICMPITEMDET to &&C_user_name;
 grant select on DA.CIITEMTYPE to &&C_user_name;
 grant select on DA.CILOCATION to &&C_user_name;
 grant select on DA.CIDETAIL to &&C_user_name;
 grant select on DA.CIHEADER_POSTED to &&C_user_name;
 grant select on DA.CIPHYCNT_POSTED to &&C_user_name;
 grant select on DA.CIPHYCNTDET_POSTED to &&C_user_name;
 grant select on DA.CISALEPRICE to &&C_user_name;
 grant select on DA.CISERIALNUM to &&C_user_name;
 grant select on DA.CIBATCH to &&C_user_name;
 grant select on DA.CITRAN to &&C_user_name;
REM RQ
 grant select on DA.POREQ to &&C_user_name;
 grant select on DA.POREQDET to &&C_user_name;
 grant select on DA.POREQSTAT to &&C_user_name;
REM SYS
 grant select on DA.ROLES to &&C_user_name;
 grant select on DA.FORMROLES to &&C_user_name;
 grant select on DA.USERROLES to &&C_user_name;
 grant select on DA.FORMS_WITHIN_APPS to &&C_user_name;
REM BP
 grant select on DA.BPARTNERS to &&C_user_name;
REM HR
 grant select on DA.HREMPLOYEE_V to &&C_user_name;
 grant select on DA.HRAPLREFS to &&C_user_name;
 grant select on DA.HRAPPLICANTS to &&C_user_name;
 grant select on DA.HRASSETS to &&C_user_name;
 grant select on DA.HRCERTORLICNS to &&C_user_name;
 grant select on DA.HREEOJOBINFO to &&C_user_name;
 grant select on DA.HREMPBENF to &&C_user_name;
 grant select on DA.HREMPCERTLIC to &&C_user_name;
 grant select on DA.HREMPEDU to &&C_user_name;
 grant select on DA.HREMPMED to &&C_user_name;
 grant select on DA.HREMPMEDDTLS to &&C_user_name;
 grant select on DA.HREMPSAFEHRS to &&C_user_name;
 grant select on DA.HREMPSKILLS to &&C_user_name;
 grant select on DA.HREMRELATIVES to &&C_user_name;
 grant select on DA.HRINCDETAIL to &&C_user_name;
 grant select on DA.HRINCIDENT to &&C_user_name;
 grant select on DA.HRINCTYPES to &&C_user_name;
 grant select on DA.HRINJTYPES to &&C_user_name;
 grant select on DA.HRJOBSAFEHRS to &&C_user_name;
 grant select on DA.HRORGANIZATIONS to &&C_user_name;
 grant select on DA.HRORGTYPES to &&C_user_name;
 grant select on DA.HRPERFREVIEWS to &&C_user_name;
 grant select on DA.HRPOSITIONS to &&C_user_name;
 grant select on DA.HRRATING to &&C_user_name;
 grant select on DA.HRREQUIRDSKLS to &&C_user_name;
 grant select on DA.HRSKILLS to &&C_user_name;
 grant select on DA.HRTRAININGS to &&C_user_name;
REM PM
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.JCJOB to &&C_user_name;
 grant select on DA.PMRFI to &&C_user_name;
 grant select on DA.PMRFISTATUS to &&C_user_name;
 grant select on DA.DMISSUE_V to &&C_user_name;
 grant select on DA.CMMAST to &&C_user_name;
 grant select on DA.CMMAST_POSTED to &&C_user_name;
 grant select on DA.PMDISTLIST to &&C_user_name;
 grant select on DA.PMDLISTDETAIL to &&C_user_name;
 grant select on DA.PMPUNCHLIST to &&C_user_name;
 grant select on DA.PMPUNCHLISTDET to &&C_user_name;
 grant select on DA.PMPROJAREA to &&C_user_name;
 grant select on DA.PMADDENDUM to &&C_user_name;
 grant select on DA.PMBIDDER to &&C_user_name;
 grant select on DA.PMBIDITEMQUOTE to &&C_user_name;
 grant select on DA.PMBIDPACKAGE to &&C_user_name;
 grant select on DA.PMBIDPACKAGEITEM to &&C_user_name;
 grant select on DA.PMCLASSIFICATION to &&C_user_name;
 grant select on DA.PMCOMMUNICATION to &&C_user_name;
 grant select on DA.SYSCONTACT to &&C_user_name;
 grant select on DA.PMDOCGROUP to &&C_user_name;
 grant select on DA.PMDOCGRPDETAIL to &&C_user_name;
 grant select on DA.PMDOCSTATUS to &&C_user_name;
 grant select on DA.PMDOCUMENT to &&C_user_name;
 grant select on DA.PMHISTORY to &&C_user_name;
 grant select on DA.PMITEM to &&C_user_name;
 grant select on DA.PMJOURNAL to &&C_user_name;
 grant select on DA.PMMARKETSECTOR to &&C_user_name;
 grant select on DA.PMMEETING to &&C_user_name;
 grant select on DA.PMMEETINGATTND to &&C_user_name;
 grant select on DA.PMMEETINGITEM to &&C_user_name;
 grant select on DA.PMMEETINGTRACK to &&C_user_name;
 grant select on DA.PMNOTICE to &&C_user_name;
 grant select on DA.PMPROJCONTACT to &&C_user_name;
 grant select on DA.PMPROJECTITEM to &&C_user_name;
 grant select on DA.PMPROJECT_TABLE to &&C_user_name;
 grant select on DA.PMPROJECT_V to &&C_user_name;
 grant select on DA.PMPROJPARTNER to &&C_user_name;
 grant select on DA.PMROLE to &&C_user_name;
 grant select on DA.PMSUBMITPACKAGE to &&C_user_name;
 grant select on DA.PMSUBMITTAL to &&C_user_name;
 grant select on DA.PMTRANSMITTAL to &&C_user_name;
 grant select on DA.PMTRNSMDETAIL to &&C_user_name;
 grant select on DA.PMNOTES_V to &&C_user_name;
REM HR(STANDARD)
 grant select on DA.HRSTATUS to &&C_user_name;
 grant select on DA.HRAPPLICANTS to &&C_user_name;
 grant select on DA.HRASSETS to &&C_user_name;
 grant select on DA.HRDEPBEN to &&C_user_name;
 grant select on DA.HRDEPDED to &&C_user_name;
 grant select on DA.HRDOCUMENTS to &&C_user_name;
 grant select on DA.HREDUCATION to &&C_user_name;
 grant select on DA.HREMPDOCS to &&C_user_name;
 grant select on DA.HREMPEDU to &&C_user_name;
 grant select on DA.HREMPMED to &&C_user_name;
 grant select on DA.HREMPSAFEHRS to &&C_user_name;
 grant select on DA.HREMPSKILLS to &&C_user_name;
 grant select on DA.HRINCDETAIL to &&C_user_name;
 grant select on DA.HRINCIDENT to &&C_user_name;
 grant select on DA.HRINTTRAINING to &&C_user_name;
 grant select on DA.HRJOBSAFEHRS to &&C_user_name;
 grant select on DA.HRPERFREVIEWS to &&C_user_name;
 grant select on DA.HRPOSITIONS to &&C_user_name;
 grant select on DA.HRSKILLS to &&C_user_name;
 grant select on DA.HREMPCERTLIC to &&C_user_name;
 grant select on DA.HREMPITEMS to &&C_user_name;
 grant select on DA.HRORGANIZATIONS to &&C_user_name;
 grant select on DA.HRTRAININGS to &&C_user_name;
 grant select on DA.HRTRNMODULES to &&C_user_name;
REM OM
 grant select on DA.OMCAMPAIGN to &&C_user_name;
 grant select on DA.OMCAMPAIGNCMPNT to &&C_user_name;
 grant select on DA.OMCAMPCMPNTCONTACT to &&C_user_name;
 grant select on DA.OMCAMPCMPNTPRICING to &&C_user_name;
 grant select on DA.OMCOMPETITOR to &&C_user_name;
 grant select on DA.OMCOMPONENT to &&C_user_name;
 grant select on DA.OMGROUP to &&C_user_name;
 grant select on DA.OMOPPOCOMPETITOR to &&C_user_name;
 grant select on DA.OMOPPOPRODTASK to &&C_user_name;
 grant select on DA.OMOPPOPRODUCT to &&C_user_name;
 grant select on DA.OMOPPORTUNITY to &&C_user_name;
 grant select on DA.OMOPPORTUNITY_HIST to &&C_user_name;
 grant select on DA.OMORGGROUP to &&C_user_name;
 grant select on DA.OMORGGROUPDET to &&C_user_name;
 grant select on DA.OMPOSITION to &&C_user_name;
 grant select on DA.OMPRODOFFERING to &&C_user_name;
 grant select on DA.OMPRODUCT to &&C_user_name;
 grant select on DA.OMPRODUCTACCT to &&C_user_name;
 grant select on DA.OMPRODUCTLINE to &&C_user_name;
 grant select on DA.OMPRODUCTTASK to &&C_user_name;
 grant select on DA.OMREFERENCE to &&C_user_name;
 grant select on DA.OMSALESTEAM to &&C_user_name;
 grant select on DA.OMSOURCE to &&C_user_name;
 grant select on DA.OMSTAGE to &&C_user_name;
 grant select on DA.OMURGENCY to &&C_user_name;
 grant select on DA.SYSACTIONITEMS to &&C_user_name;
 grant select on DA.SYSCONTACT to &&C_user_name;
REM DM
 grant select on DA.DMIRESPAUDIT to &&C_user_name;
 grant select on DA.DMISSUENOTE to &&C_user_name;
 grant select on DA.DMISSUEOBJECT to &&C_user_name;
 grant select on DA.DMISSUEPRIORITY to &&C_user_name;
 grant select on DA.DMISSUEQUOTE to &&C_user_name;
 grant select on DA.DMISSUESTATUS to &&C_user_name;
 grant select on DA.DMISSUETYPE to &&C_user_name;
 grant select on DA.DMISSUE_V to &&C_user_name;
 grant select on DA.PRMDETAIL to &&C_user_name;
 grant select on DA.PRMNOTES to &&C_user_name;
 grant select on DA.PRMPRIORITY to &&C_user_name;
 grant select on DA.PRMTASKS to &&C_user_name;
 grant select on DA.PRMWOASSGNMTS to &&C_user_name;
 grant select on DA.PRMWOCLASSIFIER_CODES to &&C_user_name;
 grant select on DA.PRMWORKITEMS to &&C_user_name;
 grant select on DA.PRMWORKITEMS_POSTED to &&C_user_name;
 grant select on DA.PRMWORKORDERS to &&C_user_name;
 grant select on DA.PRMWOTRAN to &&C_user_name;
REM GLOBAL TABLES(STANDARD)
 grant select on DA.ADDRESS to &&C_user_name;
 grant select on DA.DEPT to &&C_user_name;
 grant select on DA.HRREGIONS_VW to &&C_user_name;
 grant select on DA.JCJOB_TABLE to &&C_user_name;
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.HRJOBSITE_VW to &&C_user_name;
 grant select on DA.COMPSEC to &&C_user_name;
REM HR ADVANCED INFORMATION(CUSTOM LEN)
 grant select on DA.HREMPMEMS to &&C_user_name;
 grant select on DA.HREMPDOCS to &&C_user_name;
 grant select on DA.HRDOCUMENTS to &&C_user_name;
 grant select on DA.HRDOCTYPES to &&C_user_name;
 grant select on DA.HREMPEDU to &&C_user_name;
 grant select on DA.HREMPSKILLS to &&C_user_name;
 grant select on DA.HREMPCERTLIC to &&C_user_name;
 grant select on DA.HRPERFREVIEWS to &&C_user_name;
 grant select on DA.HRPOSITIONS to &&C_user_name;
 grant select on DA.HRORGANIZATIONS to &&C_user_name;
 grant select on DA.HRORGTYPES to &&C_user_name;
 grant select on DA.HRJOBSAFEHRS to &&C_user_name;
REM HR APPLICATION TRACKING(CUSTOM LEN)
 grant select on DA.HRAPPLICANTS to &&C_user_name;
 grant select on DA.HRAPLREFS to &&C_user_name;
 grant select on DA.HRAPPSOURCE to &&C_user_name;
 grant select on DA.HRAPPREVEMPS to &&C_user_name;
REM HR CODES AND LOCAL TABLES(CUSTOM LEN)
 grant select on DA.PYCOMPAYGRP to &&C_user_name;
 grant select on DA.PYPAYRUN to &&C_user_name;
 grant select on DA.PYTRADES to &&C_user_name;
 grant select on DA.HRPOSITIONS to &&C_user_name;
 grant select on DA.PYUNIONS to &&C_user_name;
 grant select on DA.HRCARPLANS to &&C_user_name;
 grant select on DA.HRRATING to &&C_user_name;
 grant select on DA.HRBODYPARTS to &&C_user_name;
 grant select on DA.HRCONTFACTRS to &&C_user_name;
 grant select on DA.HRTRETYPES to &&C_user_name;
 grant select on DA.HRILLTYPES to &&C_user_name;
 grant select on DA.HRINCTYPES to &&C_user_name;
 grant select on DA.HRINJTYPES to &&C_user_name;
 grant select on DA.HREDUCATION to &&C_user_name;
 grant select on DA.HRSKILLS to &&C_user_name;
 grant select on DA.HRCERTORLICNS to &&C_user_name;
 grant select on DA.HRMEMTYPES to &&C_user_name;
REM HR GENERAL INFORMATION(CUSTOM LEN)
 grant select on DA.PYEMPLOYEE to &&C_user_name;
 grant select on DA.HREMPSAFEHRS to &&C_user_name;
 grant select on DA.HRSAFECERT to &&C_user_name;
REM HR MEDICAL AND WORK MODIFICATIONS(CUSTOM LEN)
 grant select on DA.HREMPMED to &&C_user_name;
 grant select on DA.HREMPMEDDTLS to &&C_user_name;
 grant select on DA.HRMEDFACTS to &&C_user_name;
 grant select on DA.HRMEDTYPES to &&C_user_name;
 grant select on DA.HREMPWRKMODS to &&C_user_name;
 grant select on DA.HREMPWRKMODTL to &&C_user_name;
 grant select on DA.HRWRKMODS to &&C_user_name;
 grant select on DA.HRWRKMODFREQS to &&C_user_name;
REM JB JOB BILLING
 grant select on DA.COMPANY to &&C_user_name;
 grant select on DA.JCJOB to &&C_user_name;
 grant select on DA.JBBILLMASTER to &&C_user_name;
 grant select on DA.JBPY_BILLING_OVERTIME_RULES to &&C_user_name;
 grant select on DA.JBINVPRT_INVOICE_STATUS to &&C_user_name;
 grant select on DA.JB_BILLING_RATE_DETAIL to &&C_user_name;
 grant select on DA.JB_BILLING_RATE_HEADER to &&C_user_name;
 grant select on DA.JBBILL to &&C_user_name; 
 grant select on DA.JBBILLDET to &&C_user_name;
 grant select on DA.JBBILLDET_BURDEN to &&C_user_name;
 grant select on DA.JBBILLDET_MILESTONE to &&C_user_name;
 grant select on DA.JBBILLINGTYPE to &&C_user_name;
 grant select on DA.JBCONT to &&C_user_name;
 grant select on DA.JBCONTDET to &&C_user_name;
 grant select on DA.JBCONTDET_BURDEN to &&C_user_name;
 grant select on DA.JBCONTDET_MILESTONE to &&C_user_name;
 grant select on DA.JBGROUP to &&C_user_name;
 grant select on DA.JBITEMNAMES to &&C_user_name;
REM CRM CUSTOMER RELATIONSHIP MANAGEMENT
 grant select on DA.OMACTIONITEMS to &&C_user_name;
 grant select on DA.OMCOMPETITOR to &&C_user_name;
 grant select on DA.OMOPPOCOMPETITOR to &&C_user_name; 
 grant select on DA.OMOPPORTUNITY to &&C_user_name;
 grant select on DA.OMORGANIZATION_TABLE to &&C_user_name;
 grant select on DA.BPARTNERS_TABLE to &&C_user_name;
 grant select on DA.SYSCONTACT to &&C_user_name;
 grant select on DA.OMSTAGE to &&C_user_name;
 grant select on DA.OMCLASSIFIERVAL to &&C_user_name;
 grant select on DA.OMCLASSIFIER to &&C_user_name;
 grant select on DA.SYSACTIONITEMS to &&C_user_name;
 grant select on DA.PMNOTES_V to &&C_user_name;

prompt Complete

spool off

