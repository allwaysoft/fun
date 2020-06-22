/* sp_help_revlogin script 
** Generated Feb  3 2011  3:30PM on DAVIS */
 
/* 
-- Login: BUILTIN\Administrators
CREATE LOGIN [BUILTIN\Administrators] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: NT AUTHORITY\SYSTEM
CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: DAVIS\SQLServer2005MSSQLUser$DAVIS$MSSQLSERVER
CREATE LOGIN [DAVIS\SQLServer2005MSSQLUser$DAVIS$MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: DAVIS\SQLServer2005SQLAgentUser$DAVIS$MSSQLSERVER
CREATE LOGIN [DAVIS\SQLServer2005SQLAgentUser$DAVIS$MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: DAVIS\SQLServer2005MSFTEUser$DAVIS$MSSQLSERVER
CREATE LOGIN [DAVIS\SQLServer2005MSFTEUser$DAVIS$MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
*/ 
-- Login: mbtawadm
CREATE LOGIN [mbtawadm] WITH PASSWORD = 0x0100A25E8FDB8B289A8297DCFAB4D254018167AB1064E0EADAE8 HASHED, SID = 0x1209D95E2D210D4FB92D40FE09C805DB, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = OFF
 
-- Login: webdbuser
CREATE LOGIN [webdbuser] WITH PASSWORD = 0x0100B609750D613FE8BE1012B7140AC3EC49C0380656F33DADC6 HASHED, SID = 0x6A743635B5CA8F44AE77A2F047112A92, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = OFF
 
-- Login: CMSLogin
CREATE LOGIN [CMSLogin] WITH PASSWORD = 0x0100D6AE029AC3F8F18ACBA940D589BBF99F0DE11D3DFD102E34 HASHED, SID = 0xB435BAF414C34447BBE5ADE6349126E4, DEFAULT_DATABASE = [thetweb], CHECK_POLICY = ON, CHECK_EXPIRATION = OFF
 
-- Login: CCTSForms
CREATE LOGIN [CCTSForms] WITH PASSWORD = 0x010025AECC06E3DDEF1BE34635BF4A7AD1134513CABD44A4A9D4 HASHED, SID = 0x51CFD9014505BD489F05B69E3CD7E382, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = OFF
/* 
-- Login: arcserve
CREATE LOGIN [arcserve] WITH PASSWORD = 0x0100F71C5331F94B47BBAF3F156D503AE8621B47D0D1119D0FB8 HASHED, SID = 0x31FA972086349D44B5C1690B8BB9A689, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = OFF
 
-- Login: DAVIS\jrw9852
CREATE LOGIN [DAVIS\jrw9852] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
*/

----------begin mbtawadm thetweb---------------------------------------------------------

EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'mbtawadm'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'mbtawadm'

GRANT CONTROL ON [dbo].[PreLotteryRegistration] TO [mbtawadm]
GRANT DELETE ON [dbo].[PreLotteryRegistration] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_SilverLineAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_EscalAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_BoatAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_LiftAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Add_Line_Items_to_CMS_lineitems] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Delete_A_Items_from_CMS_standard_li_for_web] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Delete_D_Items_from_CMS_standard_li_for_web] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Delete_Line_Items_from_CMS_lineitems] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Process_Line_Items] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Update_Description_of_CMS_lineitems] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[cms_Update_UOM_Code_of_CMS_lineitems] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[transit_GetBusAllVariations] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[transit_GetBusLongestRoute] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[transit_GetBusRoutePattern] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[transit_GetTimeTable] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[utils_LoadBusAllVariations] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[utils_LoadBusLongestRoute] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[utils_LoadBusRoutePattern] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[utils_LoadTimeTable] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[utils_LoadTimeTableHtml] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[transit_GetLandmarksByType] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ridertools_increment] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[betaFeedback_getFeedback] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[betafeedback_save] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetAwardedBidResponses] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetAwardedBids] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetAwardedConList1] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetBids] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetCMSReportByType] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetConList1] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[buscenter_GetContractStatus] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[customerservice_InsertCustomerComment] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_addAlert] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_BusAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_CRAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_ElevAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_getAlerts] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_getAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_getAlertsWithInfo] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_getElevEscBySta] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_ProcessAlert] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[eAlerts_SubwayAlertSummary] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[feedback_GetLineByMode] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[feedback_websiteissuereport] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[insert_websiteissue] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[LoginUser] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mbta_ValidateEmployeeUser] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_DeleteAccount] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_getLoginInfo] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_isSavedRoute] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_isSavedStation] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_procServiceUpdates] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_registerUser] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_removeRoute] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_removeSavedAlert] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_removeSavedItem] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_removeStation] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_removeStationByID] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_saveRoute] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_saveStation] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_userServiceUpdates] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[mymbta_verifyUser] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_ActivateRefund] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_CountCities] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_FindRefundDups] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_GetBusRoutes] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_ModeLineStationMaster] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_SelectStatesTable] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_SelectZipCodeTable] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_TrainTripNumbers] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[ontimeguarantee_VerifyRefundActivation] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[planTrip_getLandmarks] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[planTrip_getSavedAddressLatLng] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[planTrip_GetSavedTrip] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[plantrip_saveAddress] TO [mbtawadm]
GRANT EXECUTE ON [dbo].[plantrip_saveTrip] TO [mbtawadm]
GRANT INSERT ON [dbo].[PreLotteryRegistration] TO [mbtawadm]
GRANT SELECT ON [dbo].[PreLotteryRegistration] TO [mbtawadm]
GRANT UPDATE ON [dbo].[PreLotteryRegistration] TO [mbtawadm]
------------end mbtawadm thetweb------------------------------------------------------

------------begin mbtawadm ektron-----------------------------------------------------

EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'mbtawadm'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'mbtawadm'

GRANT CONNECT  TO [mbtawadm]
------------end mbtawadm ektron-------------------------------------------------------










----------begin 'webdbuser'thetweb------------------------------------------------------
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'webdbuser'

GRANT CONNECT  TO [webdbuser]
----------end 'webdbuser'thetweb--------------------------------------------------------


------------begin 'webdbuser'ektron-----------------------------------------------------
EXEC sp_addrolemember @rolename = 'db_executor', @membername = 'webdbuser'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'webdbuser'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'webdbuser'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'webdbuser'

GRANT CONNECT  TO [webdbuser]

------------end webdbuser ektron-------------------------------------------------------










----------begin CMSLogin thetweb------------------------------------------------------

GRANT DELETE ON [dbo].[bids] TO [CMSLogin]
GRANT DELETE ON [dbo].[Conlist1] TO [CMSLogin]
GRANT DELETE ON [dbo].[CMS_lineitems] TO [CMSLogin]
GRANT DELETE ON [dbo].[CMS_Password] TO [CMSLogin]
GRANT DELETE ON [dbo].[CMS_Reports] TO [CMSLogin]
GRANT DELETE ON [dbo].[CMS_standard_li_for_web] TO [CMSLogin]
GRANT DELETE ON [dbo].[CMS_CMS] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Add_Line_Items_to_CMS_lineitems] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Delete_A_Items_from_CMS_standard_li_for_web] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Delete_D_Items_from_CMS_standard_li_for_web] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Delete_Line_Items_from_CMS_lineitems] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Process_Line_Items] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Update_Description_of_CMS_lineitems] TO [CMSLogin]
GRANT EXECUTE ON [dbo].[cms_Update_UOM_Code_of_CMS_lineitems] TO [CMSLogin]
GRANT INSERT ON [dbo].[CMS_lineitems] TO [CMSLogin]
GRANT INSERT ON [dbo].[Conlist1] TO [CMSLogin]
GRANT INSERT ON [dbo].[bids] TO [CMSLogin]
GRANT INSERT ON [dbo].[CMS_CMS] TO [CMSLogin]
GRANT INSERT ON [dbo].[CMS_standard_li_for_web] TO [CMSLogin]
GRANT INSERT ON [dbo].[CMS_Reports] TO [CMSLogin]
GRANT INSERT ON [dbo].[CMS_Password] TO [CMSLogin]
GRANT SELECT ON [dbo].[CMS_Password] TO [CMSLogin]
GRANT SELECT ON [dbo].[CMS_Reports] TO [CMSLogin]
GRANT SELECT ON [dbo].[CMS_standard_li_for_web] TO [CMSLogin]
GRANT SELECT ON [dbo].[CMS_CMS] TO [CMSLogin]
GRANT SELECT ON [dbo].[bids] TO [CMSLogin]
GRANT SELECT ON [dbo].[Conlist1] TO [CMSLogin]
GRANT SELECT ON [dbo].[CMS_lineitems] TO [CMSLogin]
GRANT UPDATE ON [dbo].[CMS_lineitems] TO [CMSLogin]
GRANT UPDATE ON [dbo].[Conlist1] TO [CMSLogin]
GRANT UPDATE ON [dbo].[bids] TO [CMSLogin]
GRANT UPDATE ON [dbo].[CMS_CMS] TO [CMSLogin]
GRANT UPDATE ON [dbo].[CMS_standard_li_for_web] TO [CMSLogin]
GRANT UPDATE ON [dbo].[CMS_Reports] TO [CMSLogin]
GRANT UPDATE ON [dbo].[CMS_Password] TO [CMSLogin]

----------end CMSLogin thetweb--------------------------------------------------------


------------begin mbtawadm ektron-----------------------------------------------------

---

------------end mbtawadm ektron-------------------------------------------------------








----------begin CCTSForms thetweb------------------------------------------------------

EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CCTSForms'

----------end CCTSForms thetweb--------------------------------------------------------


------------begin mbtawadm ektron-----------------------------------------------------
---
------------end mbtawadm ektron-------------------------------------------------------