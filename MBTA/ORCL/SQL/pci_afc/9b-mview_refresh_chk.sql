set linesize 500
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH:MI:SS AM';
select owner, mview_name, last_refresh_date from user_mviews order by last_refresh_date desc;
exit;