spool dcidx.lst

PROMPT
PROMPT ======================================================================
PROMPT DCIDX.SQL: Create all indexes for DATA CONVERSION. Output in: DCIDX.LST
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


start dcaccnt.idx
start dcbpartn.idx
start dcbpcust.idx
start dcbpvend.idx
start dcgledge.idx
start dcjcdeta.idx
start dcjcjcat.idx
start dcjcmcat.idx
start dcjcjhph.idx
start dcjcmphs.idx
start dcscdeta.idx
start dcscmast.idx
start dcvouche.idx
start dccheque.idx
start dcvouchq.idx
start dcpaychq.idx
start dcvoudis.idx
start dcjcjob.idx
start dcpyempl.idx
start dcinvoic.idx
start dcpaymen.idx
start dcinvpay.idx
start dcpyephi.idx
start dccmma_p.idx
start dccmmast.idx
start dccmde_p.idx
start dccmdeta.idx
start dcjcutra.idx
start dcinvdis.idx
start dcpyepsh.idx
start dcbudgma.idx
start dcbudget.idx
start dcinvmem.idx
start dcjctcat.idx
start dcjctphs.idx
start dcpywcbc.idx
start dcpywcbr.idx
start dcpyemph.idx
start dcemaclo.idx
start dcvoumem.idx
start dcemequi.idx
start dcemeqpc.idx
start dcemeqphc.idx
start dcemloch.idx
start dcemtran.idx
start dcemdeta.idx
start dcembala.idx
start dcemclrt.idx
start dcemeqpr.idx
start dcemqpjo.idx
start dcciitem.idx
start dccislpr.idx
start dccicmpi.idx
start dcciithd.idx
start dcciitdt.idx
start dccistdc.idx
start dcbpaddr.idx
start dcpywcbj.idx
start Dcaccnt.idx
start dcpomast.idx
start dcpodet.idx
start dcpocom.idx
start dcpocod.idx
start dcscsche.idx
start dchrclas.idx
start dchremptrn.idx
start dchrspos.idx
start dchrapl.idx
start dcfaasset.idx
start dcpychecks.idx
start dcpytaxe.idx
start dcpytaxemp.idx
start dcpyempsalspl.idx
start dcemeqptran_v.idx
start dcemraterevtype_v.idx
start dcappurchag.idx
start dcappurchag_det.idx
start dcapmatrec.idx
start dcemtranpost.idx
start dcemtrandist.idx
start dcjcjpp.idx
start dcdept_table.idx
start dcpytrades.idx
start dcpmproject.idx
start dcaddress.idx
start dcpyempleave.idx
start dcpyempleavehist.idx
start dcpyempben.idx
start dcpyempded.idx
start dclocation.idx
start dcpmprojpartner.idx
start dcpmprojcontact.idx
start dcpmrfi.idx
start dcdmissue.idx
start dcpmsubmittal.idx
start dcpmsubpack.idx
start dcpmhistory.idx
start dcpmjournal.idx
start dcpmjourolab.idx
start dcpmjourteqp.idx
start dcpmjourteqp.idx
start dcpmjourvis.idx
start dcpmdescription.idx
start dcpmuserffdata.idx
start dcpmmeeting.idx
start dcpmmeetingtrack.idx
start dcpmmeetingitem.idx
start dcpmmeetingattnd.idx
start dcpmnotes.idx
start dcsyscontact.idx
start dchrincident.idx
start dchrelectedplans_em.idx
start dccmdetvendata.idx
start dccmdetvendata_p.idx
start dcpmtransmittal.idx
start dcpmtrnsmdetail.idx
start dcbpmarketsector.idx
start dchremrelatives.idx
start dcjcjobsecgrpproj.idx
start dcpyaccesscode.idx
start dcpyempsecgrpemp.idx
start dchrempsafehrs.idx
start dcinsdetail.idx
start dcnonstockitem.idx
start dcbabank.idx
start dcapreginv.idx
start dcapregdist.idx
start dcomopportunity.idx
start dchrtrainings.idx
start dccmownchgnum.idx
start dcpmfwd.idx
start dcponsitm.idx
start dcpytaxcaemp.idx
start dcprmworkorders.idx
start dcbpbanks.idx
start dcpybentrd.idx
start dcpyemploan.idx
start dcpyjobpayrate.idx
start dchrempcertlic.idx
start dchrempedu.idx
start dchrempmems.idx
start dchrempskills.idx
start dcprmtasks.idx
start dcprmschedrules.idx
start dcemclasstran_v.idx
start dcemrate_v.idx
start dchrdiscipline.idx
start dcpmrole.idx
start dcpmprojcontactrole.idx
start dcprmaccumultrs.idx
start dcprmlasteqpsvc.idx
start dcpybentrd_header.idx
start dcpybentrd_detail.idx
start dcpycommax.idx
start dcpy_generic_crew_header.idx
start dcpy_generic_crew_detail.idx
start dcpy_crew_header.idx
start dcpy_crew_details.idx
start dcprmworkitems_posted.idx
start dcbabankacct.idx
start dcpychkloc.idx


spool off
