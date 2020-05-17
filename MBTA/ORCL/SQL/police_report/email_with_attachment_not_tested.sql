create or replace procedure email_test as

v_message varchar2(255);
v_file_name varchar2(255);
c utl_smtp.connection;
v_test varchar2(50); 

CRLF CONSTANT varchar2(10) := utl_tcp.CRLF; 
BOUNDARY CONSTANT varchar2(256) := '-----7D81B75CCC90D2974F7A1CBD'; 
FIRST_BOUNDARY CONSTANT varchar2(256) := '--'||BOUNDARY||CRLF; 
LAST_BOUNDARY CONSTANT varchar2(256) := '--'||BOUNDARY||'--'||CRLF; 
MULTIPART_MIME_TYPE CONSTANT varchar2(256) := 'multipart/mixed; boundary="'||BOUNDARY||'"'; 
mime_type varchar2(255) := 'text/html'; 

PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
BEGIN
utl_smtp.write_data(c, name || ': ' || header || utl_tcp.CRLF);
END;


BEGIN
v_message := 'Email test.';
v_file_name := 'test' || trunc(sysdate) || '.csv';
c := utl_smtp.open_connection('yhcmail1c');
utl_smtp.helo(c, 'xx.xxx.net');
utl_smtp.mail(c, 'xxxxx@xxxxx.com');
utl_smtp.rcpt(c, 'xxxxx@xxxxx.com');
utl_smtp.rcpt(c, 'xxxxx@xxxxx.com');


utl_smtp.open_data(c);
-- send_header('From', '"test" <Oracle@db001>');
send_header('From', '"test" <Oracle@db001>');
send_header('To', '"Recipient" <xxxxx@xxxxx.com>');
send_header('CC', '"Recipient" <xxxxx@xxxxx.com>');
send_header('Subject', 'Test');
send_header('Content-Type',MULTIPART_MIME_TYPE);


-- Close header section by a crlf on its own 
utl_smtp.write_data(c, CRLF);


--------------------------------------------------------------------------------

-- Send the main message text
--------------------------------------------------------------------------------
 
-- mime header 
utl_smtp.write_data(c, FIRST_BOUNDARY); 
send_header('Content-Type',mime_type); 
utl_smtp.write_data(c, CRLF); 
utl_smtp.write_data(c, v_message); 
utl_smtp.write_data(c, CRLF); 

-- add the attachment 

declare
cursor a is select a from test;
begin
utl_smtp.write_data(c, FIRST_BOUNDARY); 
send_header('Content-Type',mime_type); 
send_header('Content-Disposition','attachment; filename= '||v_file_name); 
open a;
loop
fetch a into v_test;
exit when a%notfound;
v_message:=v_test;
utl_smtp.write_data(c, CRLF); 
utl_smtp.write_data(c, v_message); 


<<getout>>
null;

end loop;
close a;
end;



-- Close the message 


utl_smtp.close_data(c);
utl_smtp.quit(c);
EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
BEGIN
utl_smtp.quit(c);
EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
NULL; -- When the SMTP server is down or unavailable, we don't have
-- a connection to the server. The quit call will raise an
-- exception that we can ignore.
END;
raise_application_error(-20000,
'Failed to send mail due to the following error: ' || sqlerrm);
END email_test;
/


You can see that the code in the main is basically a wrapper around - 'cursor a is select a from test;' - which is used to set the data that I want to send in a .csv format via email.

What I would like to do is store the email wrapper as a proc - Then write a little proc to select whatever from some tables - then call the email wrapper code within this. Basically I'd like to reuse the wrapper multiple times without having all that code in every report that I want to automate in this way.
 
 
 

