create table mbta_temp_card_usage
(
card_number number(10),
card_valid_date varchar2(20),
card_used_mnth varchar2(20),
usage_count number(10) 
)


select * from mbta_temp_card_usage

drop table mbta_temp_card_usage