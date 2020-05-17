UPDATE da.PYEMPLOYEE_TABLE dapt
SET dapt.EMP_CKLOC_CODE = (
  SELECT DISTINCT da1pt.EMP_CKLOC_CODE
  FROM da1.PYEMPLOYEE_TABLE@conv da1pt
  WHERE da1pt.emp_no = dapt.emp_no);



--update sysopt set SYS_PY_USE_CHKLOC_FLAG = 'Y';