
--Set current schema = 'PSFNPRD'
select req_po.dept_id dept_id, req_po.dept_desc dept_desc
     , sum(case when req_po.po_dt-req_po.req_dt <= 5 then 1 else 0 end) "D0_5"
     , 100*sum(case when req_po.po_dt-req_po.req_dt <= 5 then 1 else 0 end)/sum(case when req_po.bus_req_id = req_po.bus_req_id then 1 end) "0_5%"
     
     , sum(case when req_po.po_dt-req_po.req_dt > 5 and req_po.po_dt-req_po.req_dt <= 10 then 1 else 0 end) "D5_10"
     , 100*sum(case when req_po.po_dt-req_po.req_dt > 5 and req_po.po_dt-req_po.req_dt <= 10 then 1 else 0 end)/sum(case when req_po.bus_req_id = req_po.bus_req_id then 1 end) "5_10%"
     
     , sum(case when req_po.po_dt-req_po.req_dt > 10 and req_po.po_dt-req_po.req_dt <= 20 then 1 else 0 end) "D10_20"
     , 100*sum(case when req_po.po_dt-req_po.req_dt > 10 and req_po.po_dt-req_po.req_dt <= 20 then 1 else 0 end)/sum(case when req_po.bus_req_id = req_po.bus_req_id then 1 end) "10_20%"
     
     , sum(case when req_po.po_dt-req_po.req_dt > 20 then 1 else 0 end) "D20+"          
     , 100*sum(case when req_po.po_dt-req_po.req_dt > 20 then 1 else 0 end)/sum(case when req_po.bus_req_id = req_po.bus_req_id then 1 end) "20+%"
          
     , sum(case when req_po.bus_req_id = req_po.bus_req_id then 1 end) tot_count
from 
(
select pshdr.req_id req_id, pshdr.business_unit req_bus_unt, pshdr.entered_dt req_dt
	 , pshdr.requestor_id reqstr, reqtbl.deptid dept_id, deptvw.descr dept_desc
	 , podbr.po_id po_id, podbr.business_unit po_bus_unt, pohdr.entered_dt po_dt
	 , pshdr.req_id || pshdr.business_unit bus_req_id
	 , pshdr.req_status req_stat
from ps_req_hdr pshdr
   , ps_requestor_tbl reqtbl
   , PS_DEPT_TBL_EFF_VW deptvw
   , PS_REQ_LN_DISTRIB psdbr
   , ps_po_line_distrib podbr
   , ps_po_hdr pohdr
where pshdr.entered_dt >= '2011-07-01'
--and reqtbl.deptid = '433002' 
and pshdr.req_status in ('C','A')
and psdbr.business_unit = pshdr.business_unit
and psdbr.req_id = pshdr.req_id
and reqtbl.requestor_id = pshdr.requestor_id
and deptvw.deptid = reqtbl.deptid
and podbr.business_unit = psdbr.business_unit
and podbr.req_id = psdbr.req_id
and podbr.distrib_ln_status not in ('X')
and pohdr.business_unit = podbr.business_unit
and pohdr.po_id = podbr.po_id
group by pshdr.req_id, pshdr.business_unit, pshdr.requestor_id, pshdr.entered_dt, pshdr.req_status, reqtbl.deptid, deptvw.descr
       , podbr.po_id, podbr.business_unit, pohdr.entered_dt
) req_po
group by req_po.dept_id, req_po.dept_desc







select pshdr.req_id || pshdr.business_unit 
from ps_req_hdr pshdr,ps_requestor_tbl reqtbl, PS_DEPT_TBL_EFF_VW deptvw, PS_REQ_LN_DISTRIB psdbr , ps_po_line_distrib podbr 
where reqtbl.requestor_id = pshdr.requestor_id
and reqtbl.deptid = '433002'
and pshdr.entered_dt >= '2011-07-01' 
and pshdr.req_status in ('C','A')
and podbr.distrib_ln_status not in ('X')
and deptvw.deptid = reqtbl.deptid
and psdbr.business_unit = pshdr.business_unit
and psdbr.req_id = pshdr.req_id
and podbr.business_unit = psdbr.business_unit
and podbr.req_id = psdbr.req_id
group by pshdr.req_id || pshdr.business_unit









--**************************** ORACLE MYTHICS POs information ************************************

select line.csi, distrb.po_id,  hdr.entered_dt po_dt, distrb.line_nbr, line.descr, distrb.merchandise_amt, distrb.merch_amt_bse
from
ps_po_hdr hdr,
(
select po_id, business_unit, line_nbr
, case when upper(descr254_mixed) like '%CSI%' 
       then substr(descr254_mixed, LOCATE('CSI', UPPER(descr254_mixed)), length(descr254_mixed)-LOCATE('CSI', UPPER(descr254_mixed))) 
       else NULL 
       end csi
, descr254_mixed descr
from ps_po_line where po_id in(select po_id from ps_po_line where upper(descr254_mixed) like '%ORACLE%CSI %')
) line,
ps_po_line_distrib distrb
where hdr.po_id = line.po_id
and hdr.business_unit = line.business_unit
and line.po_id = distrb.po_id
and line.business_unit = distrb.business_unit
and line.line_nbr = distrb.line_nbr
and distrb.distrib_ln_status not in ('X')
order by hdr.entered_dt, po_id, distrb.line_nbr, line.csi



--Used the below query to give the final information.
SELECT   A.VENDOR_ID,         
         D.NAME1,
         C.DEPTID,
         C.ACCOUNT acct_no,   
         C.ACCOUNTING_DT,
         A.INVOICE_ID,
         A.INVOICE_DT,                         
         B.PO_ID,
		 case when upper(f.descr254_mixed) like '%CSI%' 
       	      then substr(f.descr254_mixed, LOCATE('CSI', UPPER(f.descr254_mixed)), length(f.descr254_mixed)-LOCATE('CSI', UPPER(f.descr254_mixed))) 
	          else NULL 
         end csi,
		 f.descr254_mixed po_description,           
         C.VOUCHER_ID,
         C.MONETARY_AMOUNT,                        
         B.DESCR voucher_desc,
         C.BUSINESS_UNIT,     
         B.BUSINESS_UNIT_PO--,                                
         --D.VENDOR_NAME_SHORT,
         --E.ADDRESS1,
         --E.ADDRESS2,
         --C.DST_ACCT_TYPE,
         --C.CURRENCY_CD,
         --B.INV_ITEM_ID,
         --A.GRP_AP_ID,
         --E.COUNTRY,
         --E.ADDRESS_SEQ_NUM,
         --A.PYMNT_TERMS_CD,
         --A.VENDOR_SETID
FROM     PS_VOUCHER A,
         PS_VOUCHER_LINE B,
         PS_VENDOR D,
        -- PS_VENDOR_ADDR E,
         PS_VCHR_ACCTG_LINE C,
         PS_PO_LINE F
WHERE    A.BUSINESS_UNIT = B.BUSINESS_UNIT
AND      A.VOUCHER_ID = B.VOUCHER_ID
AND      B.BUSINESS_UNIT = C.BUSINESS_UNIT
AND      B.VOUCHER_ID = C.VOUCHER_ID
AND      B.VOUCHER_LINE_NUM = C.VOUCHER_LINE_NUM
AND      A.VENDOR_SETID = D.SETID
AND      A.VENDOR_ID = D.VENDOR_ID
--AND                       A.ADDRESS_SEQ_NUM = E.ADDRESS_SEQ_NUM
--AND      D.SETID = E.SETID
--AND      D.VENDOR_ID = E.VENDOR_ID
--AND      E.EFFDT = (SELECT MAX(E_ED.EFFDT) FROM PS_VENDOR_ADDR E_ED WHERE E.SETID = E_ED.SETID
  --                                                                   AND E.VENDOR_ID = E_ED.VENDOR_ID
    --                                                                 AND E.ADDRESS_SEQ_NUM = E_ED.ADDRESS_SEQ_NUM
      --                                                               AND E_ED.EFFDT <= A.INVOICE_DT)
AND B.BUSINESS_UNIT_PO = F.BUSINESS_UNIT
AND B.PO_ID            = F.PO_ID
AND B.LINE_NBR         = F.LINE_NBR
--      
AND C.DST_ACCT_TYPE in ('DST','RSA')
AND C.ACCOUNTING_DT >= '2010-01-01'
AND A.VENDOR_ID in ('73280', '101450')   --ORACLE and MYTHICS          '100089','101348' MISI
AND A.ENTRY_STATUS not in ('X')          --X means not deleted vouchers
order by c.ACCOUNTING_DT, c.ACCOUNT, B.PO_ID 
--AND   A.INVOICE_ID = '100-70360'



select b.descr, b.merchandise_amt, b.merch_amt_bse, b.qty_vchr, b.unit_price, b.receipt_dt, f.descr254_mixed 
from PS_VOUCHER_LINE b, PS_PO_LINE f
where B.BUSINESS_UNIT_PO = F.BUSINESS_UNIT
AND B.PO_ID            = F.PO_ID
AND B.LINE_NBR         = F.LINE_NBR 
--AND f.po_id in ('4000055593','4000055594','4000052946')
and   upper(f.descr254_mixed) like '%KRANTHI%' 
order by b.receipt_dt desc


select * from  PS_VOUCHER

select * from ps_vendor where vendor_id in ('100089','101348')



select * from ps_req_hdr pshdr where pshdr.req_status in ('C','A')

select * from ps_req_line where upper(descr254_mixed) like '%ORACLE%'

select * from ps_po_line where po_id = '4000053628' --where upper(descr254_mixed) like '%ORACLE%CSI%'

select * from ps_po_hdr where po_id = '4000053628'

select * from ps_po_line_ship where po_id = '4000053628'

select * from ps_po_line_distrib where po_id = '4000053628'       -- fund_code 05 is operational, 73 is future --mercheandise_amt, merch_amt_bse, budget_dt

select po_id, substr(descr254_mixed, LOCATE('CSI', UPPER(descr254_mixed)), length(descr254_mixed)-LOCATE('CSI', UPPER(descr254_mixed))),  descr254_mixed 
from ps_po_line 
where upper(descr254_mixed) like '%ORACLE%CSI%'

select po_id, business_unit, line_nbr, substr(descr254_mixed, LOCATE('CSI', UPPER(descr254_mixed)), length(descr254_mixed)-LOCATE('CSI', UPPER(descr254_mixed))) csi,
deescr254_mixed descr
from ps_po_line where po_id in(select po_id from ps_po_line where upper(descr254_mixed) like '%ORACLE%CSI%')

select po_id, LOCATE('CSI', UPPER(descr254_mixed)),  descr254_mixed from ps_po_line where upper(descr254_mixed) like '%CSI%ORACLE%'

--****************************************************************************************


