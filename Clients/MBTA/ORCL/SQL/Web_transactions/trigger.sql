create table mbta_web_transaction
(
USERNEW	VARCHAR2(20 BYTE),
TIMENEW	DATE,
VALUE	NUMBER(10,0)
)

select * from mbta_web_transaction

commit

drop table mbta_web_transactions

insert into mbta_actionlist
select * from actionlist where usernew = 'OrderExecuter' and rownum <= 1

select * from mbta_actionlist

delete from mbta_actionlist
commit

create table mbta_actionlist as
select * from actionlist where rownum <=100

CREATE OR REPLACE TRIGGER MBTA.T_ACTIONLIST
  before insert
  on mbta_actionlist
  for each row
begin
  if :new.usernew =  'OrderExecuter'
  then
delete from mbta_web_transaction;  
  
insert into mbta_web_transaction(USERNEW,
                                 TIMENEW,
                                 VALUE
                                 )
      values (:new.usernew,:new.timenew,:new.value);
  end if;
end;