CREATE OR REPLACE package ref_cursor_pkg
as
TYPE ref_row_type IS RECORD (bpcode da.bpartners.bp_code%type,
                             bpname da.bpartners.bp_name%type,
                             bpshortname da.bpartners.bp_short_name%type);

TYPE ref_cur is REF CURSOR RETURN ref_row_type;

procedure ref_cursor_proc
(
ref_proc_var IN OUT ref_cur
);
end ref_cursor_pkg;

/


CREATE OR REPLACE package body ref_cursor_pkg
as
procedure ref_cursor_proc(ref_proc_var IN OUT ref_cur) 
is
v_var      number;
begin
open ref_proc_var for select bp_code, bp_name, bp_short_name from da.bpartners
where rownum <100;
--dbms_output.put_line ('successful');
end;
end ref_cursor_pkg;

/
