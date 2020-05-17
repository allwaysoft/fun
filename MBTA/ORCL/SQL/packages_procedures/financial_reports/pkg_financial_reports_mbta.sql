
  CREATE OR REPLACE PACKAGE "MBTA"."PKG_FINANCIAL_REPORTS_MBTA" 
AS
/*********************************************************************
** Name:    pkg_financial_reports_mbta
** 
** Author:  Kranthi Pabba                  Date:12/08/2010
** Description:
**
** Parameter Description:
**--------------------------------------------------------------------
** Modified By :
** Remarks: 
** Modified By :
** Remarks: 
** Modified By :
** Remarks: 
*********************************************************************/
-- Global Variables
TYPE cur_ref IS REF CURSOR;

PROCEDURE SP_PSSR_2009_CANCELAMOUNT_MBTA     --Only for MBCR Transactions
	(nQueryID 	NUMBER
	,dDateFirst 	DATE
	,dDateLast 	DATE
	,pRoute 	VARCHAR2
	,pStation 	VARCHAR2
	,pDeviceGroup 	VARCHAR2
	,pDeviceClass 	VARCHAR2
	,pDevice 	VARCHAR2
	,pProductType 	VARCHAR2
	);
--------------------------------------------------------------------------------
-- Procedure: SP_PSSR_2009_CANCELAMOUNT_MBTA   Only for MBCR Transactions
--
-- Custom Version of Procedure SP_PSSR_2009_CANCELAMOUNT by S and B, any modifications done to the original SP_PSSR_2009_CANCELAMOUNT 
-- procedure after the below create date of this procedure should be changed in this procedure too. This procedure is for MBCR transactions only.
--
-- Creation :	11-30-2010  Kranthi Pabba
--
-- Purpose  :	Executes query for product sales summary report (MBCR Transactions only)
--
--
-- Input    :	nQueryID		ID to identify result set in table TempResult
--
--				dDateFirst		start date of query
--				dDateLast		end date of query
--
-- Output   : 	Results in TempResult
-- 			 	Data1	= RouteDesc
--				Data2	= StationDesc
--				Data3	= TicketsCount
--				Data4	= TicketTypeDesc
--				Data5	= TicketTypeID
--				Data6	= SumAmountsPerRecord w/o Token
--				Data7	= Credit/Debit Amount
--				Data8	= Check Amount
--				Data9	= Cash Amount
--				Data10	= Token Amount
--
--------------------------------------------------------------------------------



END pkg_financial_reports_mbta;
/
 
