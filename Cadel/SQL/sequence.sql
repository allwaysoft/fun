--1. What sequences are being used, and do they roll over or run out?
SELECT cycle_flag, sequence_name FROM ALL_SEQUENCES 

--3. Which sequences are in danger of running out?
SELECT sequence_name, (max_value - last_number)/increment_by sequences_left 
FROM ALL_SEQUENCES
ORDER BY sequences_left;

--4. I didn't really go into detail with that because its kind of a hack. It's just how I do it. I'll show you using the SAME example as above.

CREATE SEQUENCE rollover_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 MAXVALUE 3 CYCLE NOCACHE;
CREATE SEQUENCE runout_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 MAXVALUE 3 NOCYCLE NOCACHE;

CREATE TABLE sequence_table (roll NUMBER(1), runout NUMBER(1));

--Run this four times, observe the error on the fourth (same as in the article):
INSERT INTO sequence_table (roll, runout) VALUES (rollover_seq.NEXTVAL, runout_seq.NEXTVAL);

--Note: If you got the gap some other way, you may need to ROLLBACK first, otherwise you'll have to be even more clever to fix it, seeing that you've got a value you'll need to "skip" next time.

--Now do this:
ALTER SEQUENCE rollover_seq INCREMENT BY -1;
SELECT rollover_seq.NEXTVAL FROM dual;
ALTER SEQUENCE rollover_seq INCREMENT BY 1;

--Now try it:
INSERT INTO sequence_table (roll, runout) VALUES (rollover_seq.NEXTVAL, 4);

SELECT * FROM sequence_table;
--ROLL RUNOUT
---------- ----------
--1 1
--2 2
--3 3
--1 4