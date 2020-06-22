set echo off
set verify off

accept batch prompt 'Enter Batch Number: '
accept postdate prompt 'Enter post date using the format dd-mon-yy:'


update voudist a
set a.vdist_scsch_oraseq =
	(select min(b.vdist_scsch_oraseq)
	from voudist b
	where b.vdist_vou_num = a.vdist_vou_num
	and b.vdist_line_num = 120)
where a.vdist_bch_num = &batch
and a.vdist_line_num = 20
and a.vdist_scsch_oraseq is null;


Update scsched
set scsch_prev_hldbk_amt = nvl(scsch_prev_hldbk_amt,0) + 
	(select vdist_amt *-1
	from voudist
	where vdist_bch_num = '&batch'
	and vdist_line_num = 20
	and vdist_scsch_oraseq = scsch_oraseq)
, scsch_lst_amt = 0
, scsch_hldbk_pct = 0
, scsch_curr_hldbk_amt = 0
, scsch_compl_amt = scsch_compl_amt - 
	(select vdist_amt *-1
	from voudist
	where vdist_bch_num = '&batch'
	and vdist_line_num = 20
	and vdist_scsch_oraseq = scsch_oraseq)
where scsch_oraseq in
	(select vdist_scsch_oraseq
	from voudist
	where vdist_bch_num = '&batch'
	and vdist_line_num = 20);


update scsched
set scsch_compl_pct = round((scsch_compl_amt/scsch_amt) * 100, 0)
where scsch_oraseq in
	(select vdist_scsch_oraseq
	from voudist
	where vdist_bch_num = '&batch'
	and vdist_line_num = 20);


delete 
from insvou
where insv_vou_num in 
(select vou_num
from voucher
where vou_bch_num = &batch);


update voudist
set vdist_post_date = '&postdate'
, vdist_vou_num = ('55555' || vdist_vou_num) * -1
, vdist_bch_num = vdist_bch_num * -1
where vdist_bch_num = &batch;


update voucher
set vou_post_date = '&postdate'
, vou_num = ('55555' || vou_num) * -1
, vou_bch_num = vou_bch_num * -1
where vou_bch_num = &batch
and vou_post_date is null;



prompt

prompt The batch number has been changed to be negative
prompt The VOU_NUM has been changed to a negative and has "55555" appended to the beginning of the number
prompt The post date has been updated
prompt The Previously Retained amount has be updated.

prompt

prompt Don't forget to either Commit or Rollback

