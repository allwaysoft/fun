`spool dcsys.lst

PROMPT
PROMPT ======================================================================
PROMPT DCSYS.SQL: Create all tables for DATA CONVERSION. Output in: DCSYS.LST
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


start dc_err.tbl

start dc_is.tbl

start dc_temp.tbl

--BPARTNERS
start dcbpartn.tbl

--BPCUSTOMERS
start dcbpcust.tbl

--BPVENDORS
start dcbpvend.tbl

--GLEDGER
start dcgledge.tbl

--JCDETAIL
start dcjcdeta.tbl

--JCJOBCAT
start dcjcjcat.tbl

--JCMCAT
start dcjcmcat.tbl

--JCJOBHPHS
start dcjcjhph.tbl

--JCMPHS
start dcjcmphs.tbl

--SCDETAIL
start dcscdeta.tbl

--SCMAST
start dcscmast.tbl

--VOUCHER
start dcvouche.tbl

--CHEQUE
start dccheque.tbl

--VOUCHQ
start dcvouchq.tbl

--PAYCHQ
start dcpaychq.tbl

--VOUDIST
start dcvoudis.tbl

--JCJOB_TABLE
start dcjcjob.tbl

--PYEMPLOYEE_TABLE
start dcpyempl.tbl

--INVOICE
start dcinvoic.tbl

--PAYMENT
start dcpaymen.tbl

--INVPAY
start dcinvpay.tbl

--PYEMPPAYHIST
start dcpyephi.tbl

--CMMAST_POSTED
start dccmma_p.tbl

--CMMAST
start dccmmast.tbl

--CMDETAIL_POSTED
start dccmde_p.tbl

--CMDETAIL
start dccmdeta.tbl

--JCUTRAN
start dcjcutra.tbl

--INVDIST
start dcinvdis.tbl

--PYEMPTIMSHT
start dcpyepsh.tbl

--BUDGMAST
start dcbudgma.tbl

--BUDGET
start dcbudget.tbl

--INVMEMO
start dcinvmem.tbl

--JCTCAT
start dcjctcat.tbl

--JCTPHS
start dcjctphs.tbl

--PYWCBCODE
start dcpywcbc.tbl

--PYWCBRATE
start dcpywcbr.tbl

--PYEMPHIST
start dcpyemph.tbl

--EMACTUALLOCATION
start dcemaclo.tbl

--VOUMEMO
start dcvoumem.tbl

--EMEQUIPMENT
start dcemequi.tbl

--EMEQPCOMTRAN
start dcemeqpc.tbl

--EMEQPHCOMPON
start dcemeqphc.tbl

--EMLOCHIST
start dcemloch.tbl

--EMTRAN
start dcemtran.tbl

--EMDETAIL
start dcemdeta.tbl

--EMBALANCE
start dcembala.tbl

--EMCLASSRATE
start dcemclrt.tbl

--EMEQPRATE
start dcemeqpr.tbl

--EMEQPJOBRATE
start dcemqpjo.tbl

--CIITEM
start dcciitem.tbl

--CISALEPRICE
start dccislpr.tbl

--CICMPITEM
start dccicmpi.tbl

--CIITEMHDR
start dcciithd.tbl

--CIITEMDET
start dcciitdt.tbl

--CISTDCST
start dccistdc.tbl

--BPADDRESSES
start dcbpaddr.tbl

--PYWCBJOB
start dcpywcbj.tbl

--account
start dcaccnt.tbl

--pomast
start dcpomast.tbl

--podetail
start dcpodet.tbl

--pocomast
start dcpocom.tbl

--pocodet
start dcpocod.tbl

--scsched
start dcscsche.tbl

--PYEMPSALSPL
-- start dcpyespl.tbl

--hrclass
start dchrclas.tbl

--hrinttraining
start dchremptrn.tbl

--hrsuitpos
start dchrspos.tbl

--hrapplicant
start dchrapl.tbl

--faasset
start dcfaasset.tbl

--vourlsdet
start dcvourlsdt.tbl

--invrlsdet
start dcinvrlsdt.tbl

--pychecks
start dcpychecks.tbl

--pytaxexm
start dcpytaxe.tbl

--pytaxemp
start dcpytaxemp.tbl

--pyempsalspl
start dcpyempsalspl.tbl

--emeqptran_v
start dcemeqptran_v.tbl

--emraterevtype_v
start dcemraterevtype_v.tbl

--appurchaseagreement
start dcappurchag.tbl

--appurchaseagreementdet
start dcappurchag_det.tbl

--apmaterialreceipt
start dcapmatrec.tbl

--emtranpost
start dcemtranpost.tbl

--emtrandist
start dcemtrandist.tbl

--jc_job_phase_projection
start dcjcjpp.tbl

--dept_table
start dcdept_table.tbl

--pytrades
start dcpytrades.tbl

--pmproject_table
start dcpmproject.tbl

--address
start dcaddress.tbl

-- pyempleave
start dcpyempleave.tbl

-- pyempleavehist
start dcpyempleavehist.tbl

-- pyempben
start dcpyempben.tbl

-- pyempded
start dcpyempded.tbl

-- location_table
start dclocation.tbl

-- pmprojpartner
start dcpmprojpartner.tbl

-- pmprojcontact
start dcpmprojcontact.tbl

-- pmrfi
start dcpmrfi.tbl

-- dmissue
start dcdmissue.tbl

-- pmsubmittal
start dcpmsubmittal.tbl

-- pmsubmitpackage
start dcpmsubpack.tbl

-- pmhistory
start dcpmhistory.tbl

-- pmjournal
start dcpmjournal.tbl

-- pmjournallab
start dcpmjourolab.tbl

-- pmjourteqp
start dcpmjourteqp.tbl

-- pmjourtlab
start dcpmjourtlab.tbl

-- pmjourvis
start dcpmjourvis.tbl

-- pmdescription
start dcpmdescription.tbl

-- pmuserffdata
start dcpmuserffdata.tbl

-- pmmeeting
start dcpmmeeting.tbl

-- pmmeetingtrack
start dcpmmeetingtrack.tbl

-- pmmeetingitem
start dcpmmeetingitem.tbl

-- pmmeetingattnd
start dcpmmeetingattnd.tbl

-- pmnotes
start dcpmnotes.tbl

-- syscontact
start dcsyscontact.tbl

start dchrincident.tbl
start dchrelectedplans_em.tbl
start dccmdetvendata.tbl
start dccmdetvendata_p.tbl
start dcpmtransmittal.tbl
start dcpmtrnsmdetail.tbl
start dcbpmarketsector.tbl
start dchremrelatives.tbl
start dcjcjobsecgrpproj.tbl
start dcpyaccesscode.tbl
start dcpyempsecgrpemp.tbl
start dchrempsafehrs.tbl
start dcinsdetail.tbl
start dcnonstockitem.tbl
start dcbabank.tbl
start dcapreginv.tbl
start dcapregdist.tbl
start dcomopportunity.tbl
start dchrtrainings.tbl
start dccmownchgnum.tbl
start dcpmfwd.tbl
start dcponsitm.tbl
start dcpytaxcaemp.tbl
start dcprmworkorders.tbl
start dcbpbanks.tbl
start dcpybentrd.tbl
start dcpyemploan.tbl
start dcpyjobpayrate.tbl
start dchrempcertlic.tbl
start dchrempedu.tbl
start dchrempmems.tbl
start dchrempskills.tbl
start dcprmtasks.tbl
start dcprmschedrules.tbl
start dcemclasstran_v.tbl
start dcemrate_v.tbl
start dchrdiscipline.tbl
start dcpmrole.tbl
start dcpmprojcontactrole.tbl
start dcprmaccumultrs.tbl
start dcprmlasteqpsvc.tbl
start dcpybentrd_header.tbl
start dcpybentrd_detail.tbl
start dcpycommax.tbl
start dcpy_generic_crew_header.tbl
start dcpy_generic_crew_detail.tbl
start dcpy_crew_header.tbl
start dcpy_crew_details.tbl
start dcprmworkitems_posted.tbl
start dcbabankacct.tbl




spool off
