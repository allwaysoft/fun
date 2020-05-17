
  CREATE OR REPLACE PROCEDURE "MBTA"."SP_OUTPUT_MBTA" (vInput VARCHAR2) is

/*
DECLARE

	vInput					VARCHAR2(32000) := 'Hello You'||Chr(13)||Chr(10)||'How are you?';
*/
	vTemp					  VARCHAR2(32000);
	iPosCr					  NUMBER(10);
	iPosLf					    NUMBER(10);
	iLen					      NUMBER(10);
	iPos					      NUMBER(10);
	vOutput					VARCHAR2(5000);

	exit_prog				EXCEPTION;
	PRAGMA					exception_init(exit_prog,-20001);

BEGIN

DBMS_OUTPUT.ENABLE(1000000);

	IF NOT (Length(vInput) = 0 OR vInput IS NULL) then
		iPosCr := InStr(vInput,Chr(13));
		iPosLf := InStr(vInput,Chr(10));
		IF iPosCr > 0 AND iPosLf > 0 THEN
--			Dbms_Output.Put_Line('case1');
			vTemp := REPLACE(vInput,Chr(10),'');
		ELSIF NOT iPosCr > 0 AND iPosLf > 0 THEN
--			Dbms_Output.Put_Line('case2');
			iPosCr := iPosLf;
			vTemp := REPLACE(vInput,Chr(10),Chr(13));
		ELSE
--			Dbms_Output.Put_Line('case else');
			vTemp := vInput;
		END IF;

	--	Raise_Application_Error(-20001,'Stop');

		LOOP
			iLen := Length(vTemp);
			IF iPosCr > 0 THEN
				vOutput := SubStr(vTemp,1,iPosCr);
				iPos := 1;
				LOOP
					Dbms_Output.Put_Line(SubStr(vOutput,iPos,255));
					iPos := iPos + 255;
					IF Length(vOutput) < iPos THEN
						EXIT;
					END IF;
				END LOOP;
				vTemp := SubStr(vTemp,iPosCr+1);
				iPosCr := InStr(vTemp,Chr(13));
			ELSE
				iPos := 1;
				LOOP
					Dbms_Output.Put_Line(SubStr(vTemp,iPos,255));
					iPos := iPos + 255;
					IF Length(vTemp) < iPos THEN
						EXIT;
					END IF;
				END LOOP;
				vTemp := '';
			END IF;
			IF Length(vTemp) = 0 OR vTemp IS NULL THEN
				EXIT;
			END IF;
		END LOOP;
	END IF;

EXCEPTION
  WHEN exit_prog THEN
    Dbms_Output.Put_Line('Application stopped');
  WHEN OTHERS THEN
    RAISE;

END;
/
 
