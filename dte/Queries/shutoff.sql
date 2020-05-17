select adstatus_code,No_of_accts,tengarr,tnonarr,s30,s60,s90,s90p 
from 
(SELECT /*+ parallel(ad,4) */ Nvl ( CAD_STATUS_CODE_CURR , 'None' ) adstatus_code , 
count (distinct cad_identifier) No_of_accts , 
sum(CAD_TOTAL_ENERGY_ARR) tengarr, 
sum(CAD_TOTAL_NONENERGY_ARR) tnonarr 
FROM CCS_ACCOUNT_DETAIL AD 
WHERE  AD.CAD_ACCOUNT_STATUS = 'FINAL' 
and extract(XMLType(cad_account_xmlstring), '/csbAccount/account/customerAccount/writeOffInd/text()').getStringVal() = 'N'
GROUP BY 
CAD_STATUS_CODE_CURR) ad, 
(SELECT /*+ parallel(ad1,4) */ /*+ index(asg,CASA_CAD_FK_I) */ Nvl ( CAD_STATUS_CODE_CURR , 'None' ) agrstatus_code , 
sum ( CASA_NINETY_BUCKET ) s90, 
sum ( CASA_OVER_NINETY_BUCKET ) s90p, 
sum ( CASA_SIXTY_BUCKET ) s60, 
sum ( CASA_THIRTY_BUCKET ) s30 
FROM CCS_ACCOUNT_DETAIL AD1 , 
CCS_ACCOUNT_SERVICE_AGREEMENT ASG , 
ccs_code_lookup 
WHERE AD1.CAD_IDENTIFIER = ASG.CASA_CAD_ID 
AND AD1.CAD_ACCOUNT_STATUS = 'FINAL' 
and extract(XMLType(cad_account_xmlstring), '/csbAccount/account/customerAccount/writeOffInd/text()').getStringVal() = 'N'
and CASA_CCL_ID_PC =ccl_identifier 
GROUP BY 
ad1.CAD_STATUS_CODE_CURR) agr 
where adstatus_code=agrstatus_code