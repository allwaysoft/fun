create table mbta_db_size_hist
(mdsh_insert_date date,
 mdsh_tbs_name varchar2(30),
 mdsh_tbs_curr_size number,
 mdsh_tbs_curr_used number,
 mdsh_tbs_curr_free number,
 mdsh_tbs_curr_used_pct varchar2(10),
 mdsh_tbs_max_size number,
 mdsh_comment varchar2(50)
)
/

comment on table mbta_db_size_hist is 'Contains historical data for tablespace sizes of Oracle HCMS Database(HRPRDAB) by each day'
/
comment on column mbta_db_size_hist.mhdsh_insert_date is 'Data insert date'
/
comment on column mbta_db_size_hist.mhdsh_tbs_name is 'Tablespace Name'
/
comment on column mbta_db_size_hist.mhdsh_tbs_curr_size is 'Allocated size of the Tablespace at that point of time'
/
comment on column mbta_db_size_hist.mhdsh_tbs_curr_used is 'Total space used out of the total allocated for the Tablespace at that point of time'
/
comment on column mbta_db_size_hist.mhdsh_tbs_curr_free is 'Total free space otu of the toal allocated for the Tablespace at that point of time'
/
comment on column mbta_db_size_hist.mhdsh_tbs_curr_used_pct is 'Percent of used space out of the total allocated for the Tablespace at that point of time'
/
comment on column mbta_db_size_hist.mhdsh_tbs_max_size is 'Max size the Tablespace could be extended to'
/
comment on column mbta_db_size_hist.mhdsh_comment is 'Comments if necessary, If there is huge change in the sizes on a particular day, a comment could be added to identify that day'
/

---------------
CREATE UNIQUE INDEX pk_mbta_db_size_hist 
ON mbta_db_size_hist
(mhdsh_insert_date,mhdsh_tbs_name)
/

CREATE BITMAP INDEX ix1_mbta_db_size_hist
ON mbta_db_size_hist(mhdsh_tbs_name)
/

------------
ALTER TABLE mbta_db_size_hist 
ADD 
(
CONSTRAINT pk_mbta_db_size_hist
PRIMARY KEY
(mhdsh_insert_date,mhdsh_tbs_name)
USING INDEX pk_mbta_db_size_hist
)
/