spool dcdb.lst

PROMPT
PROMPT ======================================================================
PROMPT DCDB.SQL: Create all checking packages for DATA CONVERSION.
PROMPT                  Output in: DCDB.LST
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

--All Packages header scripts
     start dc.ps
     start dcaccnt.ps
     start dcverify.ps
     start dcbpartn.ps
     start dcbpcust.ps
     start dcbpvend.ps
     start dcgledge.ps
     start dcjcdeta.ps
     start dcjcjcat.ps
     start dcjcmcat.ps
     start dcjcmphs.ps
     start dcjcjhph.ps
     start dcscdeta.ps
     start dcscmast.ps
     start dcvouche.ps
     start dccheque.ps
     start dcvouchq.ps
     start dcpaychq.ps
     start dcvoudis.ps
     start dcjcjob.ps
     start dcpyempl.ps
     start dcinvoic.ps
     start dcpaymen.ps
     start dcinvpay.ps
     start dcpyephi.ps
     start dccmma_p.ps
     start dccmmast.ps
     start dccmde_p.ps
     start dccmdeta.ps
     start dcjcutra.ps
     start dcinvdis.ps
     start dcpyepsh.ps
     start dcbudgma.ps
     start dcbudget.ps
     start dcinvmem.ps
     start dcjctcat.ps
     start dcjctphs.ps
     start dcpywcbc.ps
     start dcpywcbr.ps
     start dcpyemph.ps
     start dcemaclo.ps
     start dcvoumem.ps
     start dcemequi.ps
     start dcemeqpc.ps
     start dcemeqphc.ps
     start dcemloch.ps
     start dcemtran.ps
     start dcemdeta.ps
     start dcembala.ps
     start dcemclrt.ps
     start dcemeqpr.ps
     start dcemqpjo.ps
     start dcciitem.ps
     start dccislpr.ps
     start dccicmpi.ps
     start dcciithd.ps
     start dcciitdt.ps
     start dccistdc.ps
     start dcbpaddr.ps
     start dcpywcbj.ps
     start dcaccnt.ps
     start dcpomast.ps
     start dcpodet.ps
     start dcpoco.ps
     start dcpocom.ps
     start dcpocod.ps
     start dcscsche.ps
    -- start dcpyespl.ps
     start dchrclas.ps
     start dchremptrn.ps
     start dchrspos.ps
     start dchrapl.ps
     start dcfaasset.ps
     start dcvourlsdt.ps
     start dcinvrlsdt.ps
     start dcpychecks.ps
     start dcpytaxe.ps
     start dcpytaxemp.ps
     start dcpyempsalspl.ps
     start dcemeqptran_v.ps
     start dcemraterevtype_v.ps
     start dcappurchag.ps
     start dcappurchag_det.ps
     start dcapmatrec.ps
     start dcemtranpost.ps
     start dcemtrandist.ps
     start dcjcjpp.ps
     start dcdept_table.ps
     start dcpytrades.ps
     start dcpmproject.ps
     start dcaddress.ps
     start dcpyempleave.ps
     start dcpyempleavehist.ps
     start dcpyempben.ps
     start dcpyempded.ps
     start dclocation.ps
     start dcpmprojpartner.ps
     start dcpmprojcontact.ps
     start dcpmrfi.ps
     start dcdmissue.ps
     start dcpmsubmittal.ps
     start dcpmsubpack.ps
     start dcpmhistory.ps
     start dcpmjournal.ps
     start dcpmjourolab.ps
     start dcpmjourteqp.ps
     start dcpmjourtlab.ps
     start dcpmjourvis.ps
     start dcpmdescription.ps
     start dcpmuserffdata.ps
     start dcpmmeeting.ps
     start dcpmmeetingtrack.ps
     start dcpmmeetingitem.ps
     start dcpmmeetingattnd.ps
     start dcpmnotes.ps
     start dcsyscontact.ps
     start dchrincident.ps
     start dchrelectedplans_em.ps
     start dccmdetvendata.ps
     start dccmdetvendata_p.ps
     start dcpmtransmittal.ps
     start dcpmtrnsmdetail.ps
     start dcbpmarketsector.ps
     start dchremrelatives.ps
     start dcjcjobsecgrpproj.ps
     start dcpyaccesscode.ps
     start dcpyempsecgrpemp.ps
     start dchrempsafehrs.ps
     start dcinsdetail.ps
     start dcnonstockitem.ps
     start dcbabank.ps
start dcapreginv.ps
start dcapregdist.ps
start dcomopportunity.ps
start dchrtrainings.ps
start dccmownchgnum.ps
start dcpmfwd.ps
start dcponsitm.ps
start dcpytaxcaemp.ps
start dcprmworkorders.ps
start dcbpbanks.ps
start dcpybentrd.ps
start dcpyemploan.ps
start dcpyjobpayrate.ps
start dchrempcertlic.ps
start dchrempedu.ps
start dchrempmems.ps
start dchrempskills.ps
start dcprmtasks.ps
start dcprmschedrules.ps
start dcemclasstran_v.ps
start dcemrate_v.ps
start dchrdiscipline.ps
start dcpmrole.ps
start dcpmprojcontactrole.ps
start dcprmaccumultrs.ps
start dcprmlasteqpsvc.ps
start dcpybentrd_header.ps
start dcpybentrd_detail.ps
start dcpycommax.ps
start dcpy_generic_crew_header.ps
start dcpy_generic_crew_detail.ps
start dcpy_crew_header.ps
start dcpy_crew_details.ps
start dcprmworkitems_posted.ps
start dcbabankacct.ps
start dcpychkloc.ps







--All Packages body scripts
     start dc.pb
     start dcaux.plb    -- previously called dcsetup.sql
     start dcaccnt.pb
     start dcverify.pb
     start dcbpartn.pb
     start dcbpcust.pb
     start dcbpvend.pb
     start dcgledge.pb
     start dcjcdeta.pb
     start dcjcjcat.pb
     start dcjcmcat.pb
     start dcjcjhph.pb
     start dcjcmphs.pb
     start dcscdeta.pb
     start dcscmast.pb
     start dcvouche.pb
     start dccheque.pb
     start dcvouchq.pb
     start dcpaychq.pb
     start dcvoudis.pb
     start dcjcjob.pb
     start dcpyempl.pb
     start dcinvoic.pb
     start dcpaymen.pb
     start dcinvpay.pb
     start dcpyephi.pb
     start dccmma_p.pb
     start dccmmast.pb
     start dccmde_p.pb
     start dccmdeta.pb
     start dcjcutra.pb
     start dcinvdis.pb
     start dcpyepsh.pb
     start dcbudgma.pb
     start dcbudget.pb
     start dcinvmem.pb
     start dcjctcat.pb
     start dcjctphs.pb
     start dcpywcbc.pb
     start dcpywcbr.pb
     start dcpyemph.pb
     start dcemaclo.pb
     start dcvoumem.pb
     start dcemequi.pb
     start dcemeqpc.pb
     start dcemeqphc.pb
     start dcemloch.pb
     start dcemtran.pb
     start dcemdeta.pb
     start dcembala.pb
     start dcemclrt.pb
     start dcemeqpr.pb
     start dcemqpjo.pb
     start dcciitem.pb
     start dccislpr.pb
     start dccicmpi.pb
     start dcciithd.pb
     start dcciitdt.pb
     start dccistdc.pb
     start dcbpaddr.pb
     start dcpywcbj.pb
     start dcaccnt.pb
     start dcpodet.pb
     start dcpomast.pb
     start dcpoco.pb
     start dcpocom.pb
     start dcpocod.pb
     start dcscsche.pb
     start dcscdetail.sql -- procedure to populate scdetail
   --  start dcpyespl.pb
     start dchrclas.pb
     start dchremptrn.pb
     start dchrspos.pb
     start dchrapl.pb
     start dcfaasset.pb
     start dcvourlsdt.pb
     start dcinvrlsdt.pb
     start dcpychecks.pb
     start dcpytaxe.pb
     start dcpytaxemp.pb
     start dcpyempsalspl.pb
     start dcemeqptran_v.pb
     start dcemraterevtype_v.pb
     start dcappurchag.pb
     start dcappurchag_det.pb
     start dcapmatrec.pb
     start dcemtranpost.pb
     start dcemtrandist.pb
     start dcjcjpp.pb
     start dcdept_table.pb
     start dcpytrades.pb
     start dcpmproject.pb
     start dcaddress.pb
     start dcpyempleave.pb
     start dcpyempleavehist.pb
     start dcpyempben.pb
     start dcpyempded.pb
     start dclocation.pb
     start dcpmprojpartner.pb
     start dcpmprojcontact.pb
     start dcpmrfi.pb
     start dcdmissue.pb
     start dcpmsubmittal.pb
     start dcpmsubpack.pb
     start dcpmhistory.pb
     start dcpmjournal.pb
     start dcpmjourolab.pb
     start dcpmjourteqp.pb
     start dcpmjourtlab.pb
     start dcpmjourvis.pb
     start dcpmdescription.pb
     start dcpmuserffdata.pb
     start dcpmmeeting.pb
     start dcpmmeetingtrack.pb
     start dcpmmeetingitem.pb
     start dcpmmeetingattnd.pb
     start dcpmnotes.pb
     start dcsyscontact.pb
     start dchrincident.pb
     start dchrelectedplans_em.pb
     start dccmdetvendata.pb
     start dccmdetvendata_p.pb
     start dcpmtransmittal.pb
     start dcpmtrnsmdetail.pb
     start dcbpmarketsector.pb
     start dchremrelatives.pb
     start dcjcjobsecgrpproj.pb
     start dcpyaccesscode.pb
     start dcpyempsecgrpemp.pb
     start dchrempsafehrs.pb
     start dcinsdetail.pb
     start dcnonstockitem.pb
     start dcbabank.pb
start dcapreginv.pb
start dcapregdist.pb
start dcomopportunity.pb
start dchrtrainings.pb
start dccmownchgnum.pb
start dcpmfwd.pb
start dcponsitm.pb
start dcpytaxcaemp.pb
start dcprmworkorders.pb
start dcbpbanks.pb
start dcpybentrd.pb
start dcpyemploan.pb
start dcpyjobpayrate.pb
start dchrempcertlic.pb
start dchrempedu.pb
start dchrempmems.pb
start dchrempskills.pb
start dcprmtasks.pb
start dcprmschedrules.pb
start dcemclasstran_v.pb
start dcemrate_v.pb
start dchrdiscipline.pb
start dcpmrole.pb
start dcpmprojcontactrole.pb
start dcprmaccumultrs.pb
start dcprmlasteqpsvc.pb
start dcpybentrd_header.pb
start dcpybentrd_detail.pb
start dcpycommax.pb
start dcpy_generic_crew_header.pb
start dcpy_generic_crew_detail.pb
start dcpy_crew_header.pb
start dcpy_crew_details.pb
start dcprmworkitems_posted.pb
start dcbabankacct.pb
start dcpychkloc.pb



spool off