PROMPT =======================================
PROMPT   Create DBK_DC_GLEDGER package body
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.DBK_DC_GLEDGER AS
  PROCEDURE Verify_data IS
  BEGIN
     display_status('Delete from DC_ERROR table.');
     --delete everything for DC_GLEDGER from da.dc_error
     delete from da.dc_error
      where dcerr_table_name = 'DC_GLEDGER';
	  
     if not da.dbk_dc_verify.verify('DC_GLEDGER') then
       return;
     end if;

     commit;

     --modify
     display_status('Modify temp data in DC_GLEDGER.');

     modify;

     commit;

     --checks if batch number
     display_status(' GL_BCH_NUM - checking');
     da.dbk_dc_gledger.bch_num;

     commit;

     --company check
     display_status(' GL_COMP_NUM - checking');
     da.dbk_dc_gledger.comp_code;

     commit;

     --department check
     display_status(' GL_DEPT_CODE - checking');
     da.dbk_dc_gledger.dept_code;

     commit;

     --account code
     display_status(' GL_ACC_CODE - checking');
     da.dbk_dc_gledger.acc_code;

     commit;

     --journal code
     display_status(' GL_JOUR_CODE - checking');
     da.dbk_dc_gledger.jour_code;

     commit;

     --reference date
     display_status(' GL_REF_DATE - checking');
     da.dbk_dc_gledger.ref_date;

     commit;

     --post date
     display_status(' GL_POST_DATE - checking');
     da.dbk_dc_gledger.post_date;

     commit;
/*
     --post date2
     display_status(' GL_POST_DATE2 - checking');
     da.dbk_dc_gledger.post_date2;

     commit;
*/
     --gl_amt
     display_status(' GL_AMT - checking');
     da.dbk_dc_gledger.amt;

     commit;

     --gl_wm_code
     display_status(' GL_WM_CODE - checking');
     da.dbk_dc_gledger.wm_code;

     commit;

     --gl_num
     display_status(' GL_NUM - checking');
     da.dbk_dc_gledger.num;

     commit;

     --gl_adj_yr
     display_status(' GL_ADJ_YR - checking');
     da.dbk_dc_gledger.adj_yr;

     commit;

     --gl_adj_per
     display_status(' GL_ADJ_PER - checking');
     da.dbk_dc_gledger.adj_per;

     commit;

     --batch type check
     display_status(' Batch type - checking');
     da.dbk_dc_gledger.check_batch;


     display_status(' Sum of batch - cheching');
     da.dbk_dc_gledger.check_sum_batch;
     commit;

  END Verify_data;

--=====================================================================
-- PROCESS_TEMP_DATA
-- Move data from da.dc_gledger into da.gledger if it is possible
--=====================================================================

 PROCEDURE Process_temp_data AS

      --cursor for number of errors for DC_GLEDGER table
      cursor cur_gledger_err is
         select count(1)
           from da.dc_error
          where dcerr_table_name = 'DC_GLEDGER' ;

      --cursor for distinct Post Dates --JJO
      cursor cur_all_post_dates is
         select distinct gl_post_date
           from da.dc_gledger
          order by gl_post_date desc;

      --cursor for batch number, which have to be created
      cursor cur_batch_num is
         select distinct gl_bch_num
           from da.dc_gledger ;

      cursor cur_post_date (p_bch_num da.gledger.gl_bch_num%TYPE) is
         select gl_post_date
           from da.dc_gledger
          where gl_bch_num = p_bch_num ;

      cursor cur_gl_adj (p_bch_num da.gledger.gl_bch_num%TYPE) is
         select decode(length(to_char(gl_adj_yr)||to_char(gl_adj_per)),null,'T','A')
           from da.dc_gledger
          where gl_bch_num = p_bch_num
            and rownum < 2;

   --VR
      cursor cur_last_bch_num_used is
        select min(bch_num)
          from da.batch_table
            where bch_num < 0
            group by 'X' ;

      t_num_gledger_errors         NUMBER;
      t_post_date                  da.gledger.gl_post_date%TYPE;
      t_bch_type                   da.batch.bch_type_code%TYPE;

      t_return     VARCHAR2(2000);
      t_batch_adjustment number;
   BEGIN
      -- Count the number of errors
      open  cur_gledger_err;
      fetch cur_gledger_err into t_num_gledger_errors;
      close cur_gledger_err;

      display_status('Number of errors in DC_ERROR table for DC_GLEDGER table :'||
                to_char(t_num_gledger_errors));

      if nvl(t_num_gledger_errors,0) = 0 then


----------------------
-- Batch adjustment --
----------------------
-- The code added by Vera to adjust batch numbers according
-- to post date

/*
         --VR
         --retrieve minimal value of batch
         open  cur_last_bch_num_used;
         fetch cur_last_bch_num_used into t_batch_adjustment;
         if cur_last_bch_num_used%NOTFOUND then
            t_batch_adjustment := 0;
         end if;
         close cur_last_bch_num_used;

         -- Adjust batch numbers numbers -- JJO
         t_batch_adjustment := 0;
         for row_all_post_dates in cur_all_post_dates loop
            update da.dc_gledger
               set gl_bch_num = gl_bch_num + t_batch_adjustment
                 , gl_num     = gl_num + t_batch_adjustment
             where gl_post_date = row_all_post_dates.gl_post_date;
            t_batch_adjustment := t_batch_adjustment - 1;
         end loop;
         commit;    -- JJO
*/

         -- create gl batch
         display_status('Insert into da.gledger');
         for row_batch in cur_batch_num loop
            open  cur_gl_adj(row_batch.gl_bch_num);
            fetch cur_gl_adj into t_bch_type;
            close cur_gl_adj;

            da.dbk_dc_gledger.create_batch(row_batch.gl_bch_num, t_bch_type);

            -- move everything from DC_GLEDGER table into GLEDGER table
--            display_status('Insert into da.gledger');
            insert into da.gledger
              (GL_BCH_NUM,            --1
               GL_COMP_CODE,          --2
               GL_DEPT_CODE,          --3
               GL_ACC_CODE,           --4
               GL_JOUR_CODE,          --5
               GL_SRC_CODE,           --6
               GL_SRC_DESC,           --7
               GL_REF_CODE,           --8
               GL_REF_DESC,           --9
               GL_REF_DATE,           --10
               GL_POST_DATE,          --11
               GL_AMT,                --12
               GL_WM_CODE,            --13
               GL_NUM,                --14
               GL_ADJ_YR,             --15
               GL_ADJ_PER,            --16
               GL_CALC_CODE,          --17
               GL_DSRC_COMP_CODE ,    --18
               GL_CURR_CODE,          --19
               GL_TAV_CODE1,          --20
               GL_TAV_CODE2,          --21
               GL_TAV_CODE3,          --22
               GL_TAV_CODE4,          --23
               GL_EXCHG_CURR_CODE,    --24
               GL_EXCHG_RATE ,        --25
               GL_EXCHG_AMT           --26
              ) select GL_BCH_NUM,            --1
                       GL_COMP_CODE,          --2
                       GL_DEPT_CODE,          --3
                       GL_ACC_CODE,           --4
                       GL_JOUR_CODE,          --5
                       GL_SRC_CODE,           --6
                       GL_SRC_DESC,           --7
                       GL_REF_CODE,           --8
                       GL_REF_DESC,           --9
                       GL_REF_DATE,           --10
                       GL_POST_DATE,          --11
                       GL_AMT,                --12
                       GL_WM_CODE,            --13
                       GL_NUM,                --14
                       GL_ADJ_YR,             --15
                       GL_ADJ_PER,            --16
                       'N',                    --17
                       GL_DSRC_COMP_CODE ,    --18
                       GL_CURR_CODE,          --19
                       GL_TAV_CODE1,          --20
                       GL_TAV_CODE2,          --21
                       GL_TAV_CODE3,          --22
                       GL_TAV_CODE4,          --23
                       GL_EXCHG_CURR_CODE,    --24
                       GL_EXCHG_RATE ,        --25
                       GL_EXCHG_AMT           --26
                  from DA.DC_GLEDGER
                 where GL_BCH_NUM = row_batch.gl_bch_num ;

            --delete everything from da.dc_gledger

        --    display_status('Delete rows from da.dc_gledger for bch_num:'
        --                    || to_char(row_batch.gl_bch_num) );
            delete from da.dc_gledger
             where gl_bch_num = row_batch.gl_bch_num;


            open  cur_post_date(row_batch.gl_bch_num);
            fetch cur_post_date into t_post_date;
            close cur_post_date;

            if t_post_date is null then
               t_post_date := sysdate;
            end if;

            update da.batch
               set bch_post_date = t_post_date
             where bch_num = row_batch.gl_bch_num;

--do not use the commit if it is not necessace
--            commit;     -- JJO
         end loop;

      display_status('GLEDGER moving from temp table was successful.');
      end if; /*    if nvl(t_num_gledger_errors,0) = 0 */


   exception
      when others then
         display_status('Can not move data from DC_GLEDGER into GLEDGER');
         da.dbk_dc.output(SQLERRM);
         rollback;
         raise;
   END Process_temp_data;


 --=====================================================================
 -- BCH_NUM
 -- checks if batch exists, if not create batch
 -- Start with -1 and increment by 1 for each separate ASCII file created
 --=====================================================================
PROCEDURE BCH_NUM IS
--check if gl_bch_num is not null
 cursor cur_bch_num_null is
   select dc_rownum,
          gl_bch_num
     from da.dc_gledger G
     where gl_bch_num is null ;

--check if already exists batch
 cursor cur_bch_num_exist is
   select dc_rownum,
          gl_bch_num
    from da.dc_gledger G
    where exists (select '1'
                    from da.batch_table B
                    where B.bch_num = G.gl_bch_num
                  );


BEGIN
 for row_dc_gl in cur_bch_num_null
 loop
   da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,'GL_BCH_NUM','BATCH',
        'Batch number can not be null.');
 end loop;


 for row_dc_gl in cur_bch_num_exist
 loop
   da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,'GL_BCH_NUM','BATCH',
        'Batch number '||to_char(row_dc_gl.gl_bch_num)||' already exists.');
 end loop;


END BCH_NUM;

--=====================================================================
-- COMP_CODE
-- Must be a VALID CMiC company code
--=====================================================================
PROCEDURE COMP_CODE IS

t_result        da.apkc.t_result_type%TYPE;
t_comp_name     da.company.comp_name%TYPE;

cursor cur_comp_code is
  select dc_rownum, gl_comp_code
   from  da.dc_gledger;

BEGIN
 for row_dc_gl in cur_comp_code
 loop
  t_result := da.apk_gl_company.chk(da.apk_util.context(da.apkc.is_on_file,
                                                  da.apkc.is_not_null),
             row_dc_gl.gl_comp_code,t_comp_name, user);
  if ('0' != t_result) then
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,'GL_COMP_CODE',
                'COMP_CODE',
                t_result);
  end if;
 end loop;

END COMP_CODE;

--=====================================================================
-- DEPT_CODE
-- Must be a VALID CMiC department code for the company entered code
--=====================================================================
PROCEDURE DEPT_CODE IS

t_result        da.apkc.t_result_type%TYPE;
t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         gl_comp_code,
         gl_dept_code
   from  da.dc_gledger ;

begin
 for row_dc_gl in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(da.apkc.is_on_file,
                                        da.apkc.is_not_null),
                row_dc_gl.gl_comp_code,row_dc_gl.gl_dept_code,t_dept_name,user);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,'GL_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;

END DEPT_CODE;

--=====================================================================
-- ACC_CODE
-- Must be a VALID CMiC account code for the company code entered
--=====================================================================
PROCEDURE ACC_CODE IS

t_result        da.apkc.t_result_type%TYPE;
t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         gl_comp_code,
         gl_dept_code,
         gl_acc_code
   from  da.dc_gledger ;


BEGIN

 for row_dc_gl in cur_acc_code
 loop

   t_result := da.apk_gl_account.Chk_By_Company_Dept (
                        da.apk_util.context(da.apkc.is_not_null,
                                            da.apkc.is_on_file,
                                            da.apkc.account_allows_transactions),
                                row_dc_gl.gl_comp_code,
                                row_dc_gl.gl_dept_code,
                                row_dc_gl.gl_acc_code,
                                t_acc_name);

  if ('0' != t_result)
  then
    da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,'GL_ACC_CODE',
                'ACC_CODE',
                t_result);
  end if;
 end loop;
END ACC_CODE;

--=====================================================================
-- JOUR_CODE
-- Must be a VALID CMiC journal code
--=====================================================================
PROCEDURE JOUR_CODE IS
 cursor cur_journal_null_exist is
   select dc_rownum, gl_jour_code
    from da.dc_gledger  G
    where gl_jour_code is null
       or not exists (select '1'
                from da.journal J
                 where J.jour_code = G.gl_jour_code ) ;
BEGIN
 for row_dc_gl in cur_journal_null_exist
 loop
   if row_dc_gl.gl_jour_code is null
   then
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_JOUR_CODE','JOUR_CODE','Journal code can not be null.');
   else
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_JOUR_CODE','JOUR_CODE',
                        'Journal code '||row_dc_gl.gl_jour_code||
                        ' is not on file.');
   end if;
 end loop;
END JOUR_CODE;

--=====================================================================
-- REF_DATE
-- if it is empty error
--=====================================================================
PROCEDURE REF_DATE IS
 cursor cur_ref_date_null is
  select dc_rownum
   from  da.dc_gledger
   where gl_ref_date is null ;
BEGIN
  for row_dc_gl in cur_ref_date_null
  loop
          da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_REF_DATE','REF_DATE','Reference date can not be null.');
  end loop;
END REF_DATE;

--=====================================================================
-- POST_DATE
-- if it is empty error
--=====================================================================
PROCEDURE POST_DATE IS
 cursor cur_post_date_null is
  select dc_rownum
   from  da.dc_gledger
   where gl_post_date is null ;
BEGIN
  for row_dc_gl in cur_post_date_null
  loop
          da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_POST_DATE','POST_DATE','Posting date can not be null.');
  end loop;
END POST_DATE;

--=====================================================================
-- POST_DATE2
-- if there is a same post date in all lines in the batch
--=====================================================================
PROCEDURE POST_DATE2 IS
 cursor cur_post_date_unq is
  select dc_rownum
        ,gl_bch_num
    from da.dc_gledger O
      where 1 < (select count(distinct gl_post_date)
                   from da.dc_gledger I
                     where O.gl_bch_num = I.gl_bch_num ) ;
BEGIN
  for row_dc_gl in cur_post_date_unq
  loop
          da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_POST_DATE','POST_DATE'
                ,'There are different posting dates GL_POST_DATE in the batch '||row_dc_gl.gl_bch_num||'.');
  end loop;
END POST_DATE2;


--=====================================================================
-- AMT
-- This is amount of transaction. This amount should not be zero or blank
--=====================================================================
PROCEDURE AMT IS
 cursor cur_amt_null is
  select dc_rownum
   from  da.dc_gledger
   where nvl(gl_amt,0) = 0;
BEGIN
  for row_dc_gl in cur_amt_null
  loop
          da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_AMT','AMT','Amount of transaction can not be null or zero.');
  end loop;
END AMT;

--=====================================================================
-- WM_CODE
-- This must be VALID CMiC weight/measure code.
--=====================================================================
PROCEDURE WM_CODE IS
 cursor cur_wm_code is
  select dc_rownum,
  	 gl_wm_code,
         gl_comp_code
   from  da.dc_gledger G
   where gl_wm_code is null
      or not exists (select '1'
                from da.wgtmes W
                 where W.wm_comp_code = G.gl_comp_code
                   and W.wm_code      = G.gl_wm_code
                   );
BEGIN
  for row_dc_gl in cur_wm_code
  loop
    if row_dc_gl.gl_wm_code is null
    then
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_WM_CODE','WM_CODE','Weight/Measure code can not be null.');
   else
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_WM_CODE','WM_CODE','Weight/Measure code '||row_dc_gl.gl_wm_code||
                        ' is not on file for company '||row_dc_gl.gl_comp_code||'.');
   end if;
 end loop;
END WM_CODE;

--=====================================================================
-- NUM
-- gl_bch_num equal to gl_num, otherwise error
--=====================================================================
PROCEDURE NUM IS
 cursor cur_num is
  select dc_rownum, gl_num, gl_bch_num
   from  da.dc_gledger G
   where gl_num != gl_bch_num
      or gl_bch_num is null ;
BEGIN
  for row_dc_gl in cur_num
  loop
    if row_dc_gl.gl_num is null
    then
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_NUM','GL_NUM','GL transaction number can not be null.');

   elsif (row_dc_gl.gl_num != row_dc_gl.gl_bch_num )
   then
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_NUM','GL_NUM','GL transaction number '||row_dc_gl.gl_num||
                        ' do not equal GL batch number '
                        ||row_dc_gl.gl_bch_num||'.');
   end if;
 end loop;
END NUM;

--=====================================================================
-- ADJ_YR
-- valid year, or blank
--=====================================================================
PROCEDURE ADJ_YR IS
 cursor cur_adj_yr is
  select dc_rownum, gl_adj_yr, gl_comp_code
   from  da.dc_gledger
   where gl_adj_yr is not null
  minus
  select distinct dc_rownum, gl_adj_yr, gl_comp_code
   from  da.dc_gledger G
        , da.period
        , da.company
   where gl_comp_code = comp_code
    and  comp_conschart_code = per_conschart_code
    and  gl_adj_yr = per_yr
    and  gl_adj_yr is not null;
BEGIN
--check if year is valid year for company
  for row_dc_gl in cur_adj_yr
  loop
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_ADJ_YR','YEAR','Fiscal year '||row_dc_gl.gl_adj_yr||
                        ' have not been set up for company '||row_dc_gl.gl_comp_code
                        ||'.');

  end loop;
END ADJ_YR;

--=====================================================================
-- ADJ_PER
-- blank if GL_ADJ_YR is blank, otherwise valid period
--=====================================================================
PROCEDURE ADJ_PER IS
 cursor cur_adj_yr_per is
  select dc_rownum, gl_adj_yr, gl_adj_per, gl_comp_code
   from  da.dc_gledger
   where    gl_adj_yr  is not null
      or    gl_adj_per is not  null
  minus
  select dc_rownum, gl_adj_yr, gl_adj_per, gl_comp_code
   from  da.dc_gledger G
        , da.period
        , da.company
   where gl_comp_code = comp_code
    and  comp_conschart_code = per_conschart_code
    and  gl_adj_yr = per_yr
    and  gl_adj_per = per_per
    and  gl_adj_yr is not null
    and  gl_adj_per is not null ;
BEGIN
--check if year and period is valid year and period for company
  for row_dc_gl in cur_adj_yr_per
  loop
        da.dbk_dc.error('DC_GLEDGER',row_dc_gl.dc_rownum,
                'GL_ADJ_PER','PERIOD','Fiscal period '||row_dc_gl.gl_adj_per||
                        ' have not been set up for year '||row_dc_gl.gl_adj_yr
                        ||' for company '||row_dc_gl.gl_comp_code
                        ||'.');

  end loop;
END ADJ_PER;

--=====================================================================
-- CHECK_BATCH_TYPE
-- create GL batch
--=====================================================================
PROCEDURE check_batch AS
 cursor cur_batch_type is
  select gl_bch_num,
    count(distinct(nvl(sign(length(to_char(gl_adj_yr)||to_char(gl_adj_per))),0)))
   "S_COUNT"
   from da.dc_gledger
     group by gl_bch_num
     having count(distinct(nvl(sign(length(to_char(gl_adj_yr)||to_char(gl_adj_per))),0))) > 1;

 t_num_type_batch       NUMBER;
BEGIN

 for row_gl in cur_batch_type
 loop
  if nvl(row_gl.S_COUNT,0) > 1
  then
        da.dbk_dc.error('DC_GLEDGER','0',
                '*','BATCH_TYPE',
                'There are more than one type of GL line in batch with batch number '
                ||to_char(row_gl.gl_bch_num)||'.');
        null;
  end if;
 end loop;
END check_batch;

--=====================================================================
-- CHECK_SUM
-- Check if lines in GL has 0 sum
--=====================================================================
PROCEDURE check_sum_batch AS
 cursor cur_batch_sum is
  select gl_bch_num,
         sum(gl_amt) "GL_AMT_SUM"
   from da.dc_gledger
     group by gl_bch_num ;


BEGIN

 for row_gl in cur_batch_sum
 loop
  if nvl(row_gl.GL_AMT_SUM,0) != 0
  then
        da.dbk_dc.error('DC_GLEDGER','0',
                '*','BATCH_SUM',
                'The sum of GL lines for batch '
                ||to_char(row_gl.gl_bch_num)
                ||' equal '||to_char(row_gl.gl_amt_sum)||' .');
        null;
  end if;
 end loop;
END check_sum_batch;


--=====================================================================
-- CREATE_BATCH
-- create GL batch
--=====================================================================
PROCEDURE create_batch (p_bch_num da.batch.bch_num%TYPE,
			p_bch_type da.batch.bch_type_code%TYPE)
AS
BEGIN
    insert into da.batch
        (BCH_NUM
         ,BCH_NAME
         ,BCH_USER
         ,BCH_AMT
         ,BCH_DATE
         ,BCH_POST_DATE
         ,BCH_TYPE_CODE
         ,BCH_SEQ_NUM
         ,BCH_EDIT_PRINT_FLAG )
    values ( p_bch_num,
            'DC - '||to_char(sysdate,'DD/MM/YYYY - HH:MI:SS'),
            user,
            0,
            sysdate,
            null,
            p_bch_type,
            0,
            null) ;

 exception when others then
         display_status('Can not create batch '||to_char(p_bch_num)||' in DA.BATCH table.');
         da.dbk_dc.output(SQLERRM);
         raise;

END Create_batch;

PROCEDURE display_status(text varchar2)
AS
BEGIN
 da.dbk_dc.display_status('DC_GLEDGER',text);
END display_status;

PROCEDURE modify AS
BEGIN

  display_status('Update GL_ADJ_PER, GL_ADJ_PER in DA.DC_GLEDGER table.');
  update da.dc_gledger
     set gl_adj_per = null,
         gl_adj_yr  = null
     where gl_adj_per = 0
       and gl_adj_yr  = 0;

   commit;

  exception when others then
        display_status('Can not update DA.DC_GLEDGER table.');
        rollback;
        raise;
END modify;



END;
/

show errors
/

