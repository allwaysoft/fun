select extractValue(xmltype(cad_account_xmlstring),'/csbAccount/customer/customerDetail/profile/profileCode') as "ProfileCode",
extractValue(xmltype(cad_account_xmlstring),'/csbAccount/account/customerAccount/writeOffInd') as "WriteOffInd",
cad_identifier
from ccs_account_detail
where cad_identifier = 76366


select cad_identifier, 
extract(XMLType(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()
from ccs_account_detail

select extractValue(xmltype(cad_account_xmlstring),'/csbAccount/customer/profile/profileCode/text()') from ccs_account_detail


,'LI'),0),0,'N','Y')     
LOW_INCOME from ccs_account_detail
