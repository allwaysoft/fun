select cad_account_number,decode(nvl(instr((extract(XMLtype(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')
from ccs_account_detail

select extract(XMLType(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()') from ccs_account_detail

select 
instr((extract(xmlforest(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI')
from ccs_account_detail

select xmlelement(cad_account_xmlstring) from ccs_account_detail

select cad_account_xmlstring from ccs_account_detail

select XMLType(cad_account_xmlstring) from ccs_account_detail


select XMLagg(xmlelement(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()','LI') from ccs_account_detail

select XMLelement(cad_account_xmlstring,cad_cust_type) from ccs_account_detail


select EXTRACTVALUE(cad_account_xmlstring, '/csbAccount/customer/profile/profileCode/text') from ccs_account_detail

select ccskc116.get_profile_code from ccs_account_detail

select extract(xmltype(cad_account_xmlstring),'/csbAccount/customer/customerDetail/profile/profileCode') as "ProfileCode"
from ccs_account_detail
where cad_account_number = '379728000017'


select cad_identifier, cad_account_number, extract(XMLType(cad_account_xmlstring), '/csbAccount/account/customerAccount/writeOffInd/text()').getStringVal()
from ccs_account_detail