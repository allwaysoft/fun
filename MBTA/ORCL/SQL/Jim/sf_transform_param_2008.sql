
  CREATE OR REPLACE FUNCTION "MBTA"."SF_TRANSFORM_PARAM_2008" (vParamName varchar2, vParamValue VARCHAR2, vParamType NUMBER DEFAULT 0) return varchar2 is
--------------------------------------------------------------------------------------------------------------------------------------
-- I need to transform all types (All, not in List, in List, x, not x, IN(x), <=, >, =)to ONE, standard model
-- vParamType 	0: Default not handed over (old usage), dangerous, because error "invalid number" may occur.	2007-03-21	ABU
--				1: NumberData Returned
--				2: StringData Returned
--				3: NumberData Returned, without "To_Number" function call
--				4: StringData Returned, without "To_Char"   function call
--------------------------------------------------------------------------------
--
--	Changes:
--
--	2008-09-12	ABU		Added hints "NO_UNNEST (ReportParameter)" to SELECT-Statements
--
--------------------------------------------------------------------------------------------------------------------------------------

  vReturn   varchar2(1000);
  vListID   varchar2(20) := '0';
  nPos 			number := 0;
  nIsChar		number := 0;

begin

  vReturn := 'AND ';

  if Upper(vParamValue) = 'ALL' then
    vReturn := vReturn || '1=1 ';

  elsif substr(vParamValue, 1, 1) = '<' then
    vReturn := vReturn || vParamName || vParamValue || ' ';

  elsif substr(vParamValue, 1, 1) = '>' then
    vReturn := vReturn || vParamName || vParamValue || ' ';

  elsif substr(vParamValue, 1, 1) = '=' then
    vReturn := vReturn || vParamName || vParamValue || ' ';

  elsif Upper(substr(vParamValue, 1, 3)) = 'IN(' then
    vReturn := vReturn || vParamName || vParamValue || ' ';

  elsif Upper(substr(vParamValue, 1, 12)) = 'NOT IN LIST-' then
    vListID := substr(vParamValue, 13, length(vParamValue) - 12);
	IF vParamType = 0 THEN
   		vReturn := vReturn || ' ( to_number(' || vParamName || ') NOT IN ';
   		vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
    	vReturn := vReturn || ' OR to_char(' || vParamName || ') NOT IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
    	vReturn := vReturn || ' ) ';
	ELSIF vParamType = 1 THEN
   		vReturn := vReturn || ' to_number(' || vParamName || ') NOT IN ';
   		vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 2 THEN
    	vReturn := vReturn || ' to_char(' || vParamName || ') NOT IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 3 THEN
   		vReturn := vReturn || vParamName || ' NOT IN ';
   		vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 4 THEN
    	vReturn := vReturn || vParamName || ' NOT IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	END IF;

  elsif Upper(substr(vParamValue, 1, 8)) = 'IN LIST-' then
	    vListID := substr(vParamValue, 9, length(vParamValue) - 8);
	IF vParamType = 0 THEN
    	vReturn := vReturn || ' ( to_number(' || vParamName || ') IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
    	vReturn := vReturn || ' OR to_char(' || vParamName || ') IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
    	vReturn := vReturn || ' ) ';
	ELSIF vParamType = 1 THEN
    	vReturn := vReturn || ' to_number(' || vParamName || ') IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 2 THEN
    	vReturn := vReturn || ' to_char(' || vParamName || ') IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 3 THEN
    	vReturn := vReturn || vParamName || ' IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ NumberData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	ELSIF vParamType = 4 THEN
    	vReturn := vReturn || vParamName || ' IN ';
    	vReturn := vReturn || ' (SELECT /*+ NO_UNNEST (ReportParameter) */ StringData FROM ReportParameter WHERE ListID=' || vListID || ') ';
	END IF;

  elsif Upper(substr(vParamValue, 1, 4)) = 'NOT ' THEN
  	nPos := instr(vParamValue, ' ', 5);
	IF nPos <> 0 then
  		vListID := substr(vParamValue, 5, nPos - 5);
	ELSE
		vListID := substr(vParamValue, 5);
	END IF;
  	nIsChar := length(translate(trim(vListID), ' 0123456789', ' '));
  	if nIsChar > 0 then
		  vReturn := vReturn || vParamName || '!=''' || vListID || ''' ';
  	else
		IF	(vParamType = 3)	then
	    	vReturn := vReturn || vParamName || ' ' || '=' || to_number(vListID) || ' ';
		else
	    	vReturn := vReturn || 'to_number(' || vParamName || ') ' || '!=' || to_number(vListID) || ' ';
		END IF;
 	end if;

  else
  	nPos := instr(vParamValue, ' ', 1);
	IF nPos <> 0 then
  		vListID := substr(vParamValue, 1, nPos - 1);
	ELSE
		vListID := vParamValue;
	END IF;
  	nIsChar := length(translate(trim(vListID), ' 0123456789', ' '));
  	if nIsChar > 0 then
    	vReturn := vReturn || vParamName || '=''' || vListID || ''' ';
  	ELSE
		IF	(vParamType = 3)	then
	    	vReturn := vReturn || vParamName || ' ' || '=' || to_number(vListID) || ' ';
		ELSIF (vParamType = 4) THEN
			vReturn := vReturn || vParamName || ' ' || '=''' || to_number(vListID) || ''' ';
		else
	    	vReturn := vReturn || 'to_number(' || vParamName || ') ' || '=' || to_number(vListID) || ' ';
		END IF;
  	end if;

  end if;

  return vReturn;

end;
/
 
