create or replace procedure sleep_pr(p_milli_seconds in number)
as language java name 'java.lang.thread.sleep(long);