1. IN SQL DEVELOPER

-- We could right-click the package in the TREE and hit run, that will pop up with a dialogue with all the procedures in the package, select the procedure to be run, provide the variable values and hit "OK". That will automatically do everything for the user and the result can be viewed in the "out variables log" at the bottom of the editor. This is easier than the 1st method described above.

OR

-- To test a procedure with an OUT parameter, we could either do this way by declaring a variable(1st line in code) as below. This acts as SQL Plus.
VAR OUT_CURSOR2 REFCURSOR
SET AUTOPRINT ON
DECLARE
  IN_ENTITY_ID VARCHAR2(200);
  IN_ACCT_DATE VARCHAR2(200);
  IN_PROFILE VARCHAR2(200);
  IN_FUNCTION_ID VARCHAR2(200);
  IN_TO_ACCOUNT VARCHAR2(200);
  IN_UPDATE_SOURCE VARCHAR2(200);
  IN_MONTH_END_FLAG VARCHAR2(200);
  IN_EVT_ID VARCHAR2(200);
  IN_NAV_ROUND_FLAG VARCHAR2(200);
  IN_NAV_PRECISION NUMBER;
  OUT_CURSOR1 ESTAR.CONTROL_CENTER_PKG.OUTPUT_CURSOR;
BEGIN
  IN_ENTITY_ID := '2516';
  IN_ACCT_DATE := '20120102';
  IN_PROFILE := 'DEFAULT_NAV_CALCULATION';
  IN_FUNCTION_ID := 'CALCNAV';
  IN_TO_ACCOUNT := '2516';
  IN_UPDATE_SOURCE := 'BS58246';
  IN_MONTH_END_FLAG := NULL;
  IN_EVT_ID := 'TEST';
  IN_NAV_ROUND_FLAG := 'R';
  IN_NAV_PRECISION := 2.0000000000;
  OUT_CURSOR1 := NULL;
  CONTROL_CENTER_PKG.CALC_NAV(
    IN_ENTITY_ID => IN_ENTITY_ID,
    IN_ACCT_DATE => IN_ACCT_DATE,
    IN_PROFILE => IN_PROFILE,
    IN_FUNCTION_ID => IN_FUNCTION_ID,
    IN_TO_ACCOUNT => IN_TO_ACCOUNT,
    IN_UPDATE_SOURCE => IN_UPDATE_SOURCE,
    IN_MONTH_END_FLAG => IN_MONTH_END_FLAG,
    IN_EVT_ID => IN_EVT_ID,
    IN_NAV_ROUND_FLAG => IN_NAV_ROUND_FLAG,
    IN_NAV_PRECISION => IN_NAV_PRECISION,
    OUT_CURSOR => OUT_CURSOR1
  );
  /* Legacy output:
DBMS_OUTPUT.PUT_LINE('OUT_CURSOR = ' || OUT_CURSOR);
          DBMS_SQL.return_result(OUT_CURSOR);  --This works from 12c
*/
  :OUT_CURSOR2 := OUT_CURSOR; --<-- Cursor
--rollback;
END;




2. IN SQL*PLUS
SET AUTOPRINT ON
var rc refcursor
exec pkg_golden_source.smf_gs_factor_preprocess(in_bbh_id => 414450,
                                        in_sm_delay_days => 0,
                                        in_mtg_pay_factor => NULL,
                                        in_mtg_factor_pay_dt => '20140401',
                                        in_asset_currency => 'USD',
                                        in_pay_shrtfl_factor => .0001,
                                        in_int_shrtfl_factor => .0023,
                                        in_out_cur => :rc);
print rc




3. IN PL/SQL Developer
   --Note always use TEST WINDOW for this. and in the bottom pan of the TEST WINDOW, make the out cursor variable as "cursor" type.
declare
  v_live_indicator         VARCHAR2(1);
  v_fiscal_end_date        DATE;
  v_fiscal_end_date_c      VARCHAR2(11);
  v_live_ovr_ind           VARCHAR2(1);
  v_live_ind               VARCHAR2(1);
  v_lbd_month_end          DATE;
  v_lbd_month_end_c        VARCHAR2(11);
  v_lbd_month              DATE;
  v_acct_date              DATE;
  v_month_diff             NUMBER;
  in_entity_id             VARCHAR2(11) := '8971';
  in_acct_basis            VARCHAR2(11) := 'PRIM';
  in_acct_date             VARCHAR2(8)  := '20151010';
  in_match_flag            VARCHAR2(11) := '';

BEGIN

  v_acct_date := TO_DATE(in_acct_date, 'YYYYMMDD');

  BEGIN
    SELECT FISCAL_END_DATE
      INTO v_fiscal_end_date
      FROM RULESDBO.ENTITY
     WHERE ENTITY_ID = in_entity_id;

    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        RAISE_APPLICATION_ERROR(-20101, 'Entity Id, '||in_entity_id||' does not exist in ENTITY table');
  END;

  v_fiscal_end_date_c := TO_CHAR(v_fiscal_end_date, 'YYYYMMDD');

  BEGIN
    SELECT LIVE_OVR_IND,
           LIVE_IND
      INTO v_live_ovr_ind,
           v_live_ind
      FROM RULESDBO.ENTITY_STAR_PROCESSING
     WHERE ENTITY_ID = in_entity_id;

    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        RAISE_APPLICATION_ERROR(-20101, 'Entity Id, '||in_entity_id||
                                        ' does not exist in ENTITY_STAR_PROCESSING table');
  END;

  SELECT MAX(a.END_DT)
    INTO v_lbd_month_end
    FROM estar.ESTAR_ACCOUNTING_PERIODS a,
         estar.ESTAR_ACCOUNTING_PERIODS b
   WHERE a.PORTFOLIO_ACCT = b.PORTFOLIO_ACCT AND
         a.ACCT_BASIS     = b.ACCT_BASIS     AND
         a.MONTH_END_DATE = b.MONTH_END_DATE AND
         b.PORTFOLIO_ACCT = in_entity_id     AND
         b.ACCT_BASIS     = in_acct_basis    AND
         b.END_DT         = v_acct_date;

  IF v_lbd_month_end IS NULL
  THEN
     RAISE_APPLICATION_ERROR(-20101, 'No Last Business Day Found');
  END IF;

  v_lbd_month_end_c := TO_CHAR(v_lbd_month_end, 'YYYYMMDD');

  SELECT MAX(END_DT)
    INTO v_lbd_month
    FROM estar.ESTAR_ACCOUNTING_PERIODS
   WHERE PORTFOLIO_ACCT      = in_entity_id             AND
         ACCT_BASIS          = in_acct_basis            AND
         TRUNC(END_DT, 'MM') = TRUNC(v_acct_date, 'MM') AND
         TRUNC(END_DT, 'YY') = TRUNC(v_acct_date, 'YY');

  IF v_acct_date <> v_lbd_month_end
  THEN
    v_live_indicator := 'N';

    OPEN :out_cur
    FOR SELECT v_live_indicator,
               in_entity_id,
               v_fiscal_end_date_c,
               v_live_ovr_ind,
               v_live_ind,
               v_lbd_month_end_c
          FROM DUAL
         WHERE in_match_flag IS NULL OR
               in_match_flag = v_live_indicator;

    RETURN;
  END IF;

  v_live_indicator := 'N';

  OPEN :out_cur
  FOR SELECT v_live_indicator,
             in_entity_id,
             v_fiscal_end_date_c,
             v_live_ovr_ind,
             v_live_ind,
             v_lbd_month_end_c
        FROM DUAL
       WHERE in_match_flag IS NULL OR
             in_match_flag = v_live_indicator;

END;