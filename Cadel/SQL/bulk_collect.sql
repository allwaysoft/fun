create or replace procedure bulk_collect_exp is
         type da1_jcdetail_row is table of da.jcdetail%ROWTYPE;
         da1_jcdetail_rec da1_jcdetail_row;
         begin
         select * BULK COLLECT INTO da1_jcdetail_rec
         from da.jcdetail
         where row;

         forall x in da1_jcdetail_rec.First..da1_jcdetail_rec.Last
       insert into da1.jcdetail values da1_jcdetail_rec(x) ;
       end ;
       
select * from da1.jcdetail       