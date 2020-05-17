--
-- Copyright (c) 1988, 2005, Oracle.  All Rights Reserved.
--
-- NAME
--   glogin.sql
--
-- DESCRIPTION
--   SQL*Plus global login "site profile" file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command.
--
-- USAGE
--   This script is automatically run
--

--Added by KP

set echo off
set feedback off
set verify off
set head off

set linesize 1000
set pagesize 1000

col user new_value uname
set termout off
select user from dual;
col name new_value gname
select name from v$database;
set termout on
clear columns
def promptstr=&uname.@&gname>
set sqlp '&promptstr '

undef promptstr
undef uname
undef gname

set feedback on
set verify on
set head on
set echo on
