Insert into dept
select * from
(select distinct dept_comp_code from dept where dept_comp_code not in ('ZZ','01')),
(SELECT 
  DEPT_CODE,
  DEPT_CONSCHART_CODE,
  DEPT_CTRL_CODE,
  DEPT_NAME,
  DEPT_ADD1,
  DEPT_ADD2,
  DEPT_ADD3,
  DEPT_REGION_CODE,
  DEPT_COUNTRY,
  DEPT_POSTAL_CODE,
  DEPT_COUNTRY_CODE,
  DEPT_AREA_CODE,
  DEPT_PHONE_NUM,
  DEPT_FAX_COUNTRY_CODE,
  DEPT_FAX_AREA_CODE,
  DEPT_FAX_NUM,
  DEPT_INTER_CLEAR_ACC_CODE,
  DEPT_INCOME_CLOSE_DEPT_CODE,
  DEPT_INCOME_CLOSE_ACC_CODE,
  DEPT_YR,
  DEPT_BU_CODE,
  DEPT_PER,
  DEPT_CLOSE_YR,
  DEPT_BALANCE_FLAG,
  DEPT_TAX_CODE,
  DEPT_FED_TAX1_CODE,
  DEPT_FED_TAX2_CODE,
  DEPT_CK_DIGIT_CODE,
  DEPT_TAX1_CODE,
  DEPT_TAX1_INCINV_FLAG,
  DEPT_TAX2_CODE,
  DEPT_TAX2_INCINV_FLAG,
  DEPT_TAX3_CODE,
  DEPT_TAX3_INCINV_FLAG,
  DEPT_TAX4_CODE,
  DEPT_TAX4_INCINV_FLAG,
  DEPT_TAX5_CODE,
  DEPT_TAX5_INCINV_FLAG,
  DEPT_HIER,
  DEPT_WCB_CODE,
  DEPT_ADDR_CODE,
  DEPT_IB_REV_ACC_CODE,
  DEPT_AP_TAX1_CODE,
  DEPT_AP_TAX2_CODE,
  DEPT_AP_TAX3_CODE,
  DEPT_ADDR_COMP_CODE,
  DEPT_JB_ALT_COMP_ADD_CODE,
  DEPT_JB_ALT_REMIT_ADD_CODE,
  DEPT_BILLING_RATE_CODE
FROM DEPT where dept_comp_code = '01' and dept_code not in '00')

select * from dept

commit

SELECT INITCAP('DAN MORGAN') FROM dual

SELECT NLS_UPPER('Dan Morgan', 'NLS_SORT = XDanish')
FROM dual

select * from babank

update babank set bnk_bank_name = case when initcap(bnk_bank_name) like '% And %' THEN replace('And','and') else initcap(bnk_bank_name)

select bnk_bank_name, CASE 
            when initcap(bnk_bank_name) like '% And %' 
            THEN replace(initcap(bnk_bank_name),'And','and') 
            else initcap(bnk_bank_name)
        END from babank
        
        
        
        select original
 ,      regexp_replace(
           initcap(
              regexp_replace( original
                            , '([:alnum:]{2,})('')([:alnum:]*)'
                            , '\199dummystring99\3'))
          , '99dummystring99'
          , '''') formatted
  from   (select 'O''MALLEY' original from dual
          union
          select 'TEH''TE' original from dual
          union
          select 'BYGGER''N' original from dual);