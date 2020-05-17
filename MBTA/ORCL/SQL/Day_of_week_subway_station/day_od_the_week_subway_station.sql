,nvl(
      sum(
              decode(to_char(sd.creadate,'d')
                         ,null
                         ,Decode(To_Char(sd.Creadate,'HH24')
                                     ,'01',decode(sd.Machinebooking||':'||sd.Cancellation
                                                       ,'1:1',1
                                                       ,'0:0',1
                                                              ,-1
                                                      ),0
                                      ),0
                          )
            ),0
       )



decode(to_Char(sd.Creadate,'HH24'),'00',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                   ,'01',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                   ,'02',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                         ,to_char(sd.creadate,'d')
          )



,decode(to_date(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)

select to_char(sysdate,'yyyy') from dual

select to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy')  from dual


select trunc(service_date), service_description from mbta_weekend_service where service_type = 1
group by trunc(service_date), service_description

select to_char(last_day(add_months(trunc(add_months(sysdate, -12),'syyyy'), 11)),'ddd') from dual


select trunc(add_months(sysdate, -12),'syyyy') from dual

select to_char(trunc(sysdate,'yyyy')-1,'d') from dual


Year SYYYY, YYYY, YEAR, SYEAR, YYY, YY, Y 
ISO Year IYYY, IY, I 
Quarter Q 
Month MONTH, MON, MM, RM 
Week WW 
IW IW 
W W 
Day DDD, DD, J 
Start day of the week DAY, DY, D 
Hour HH, HH12, HH24 
minute mi 


select trunc(sysdate,'hh24') from dual





















