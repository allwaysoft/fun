    select
            nvl(u.sd_value_desc, c.sd_value_desc) t_msg_txt
           ,upper(c.sd_msg_alt_code)              t_msg_alt_code
           ,c.SD_MSG_TYPE_CODE                    t_msg_typ_code
           ,c.sd_lang_code                        t_lang_code
           ,c.sd_sdu_code                         t_sdu_code
           ,c.sd_code                             t_sd_code
       from da.sddata_cmic_table     c
           ,da.sddata_user_table     u
     where 1=1
       --and c.sd_lang_code     = pt_Lang_Code
       --and c.sd_sdu_code      = g_sdu_Code
       and c.sd_code          = 'GL-00253'
       and u.sd_app_code  (+) = c.sd_app_code
       and u.sd_sdu_code  (+) = c.sd_sdu_code
       and u.sd_code      (+) = c.sd_code
       and u.sd_lang_code (+) = c.sd_lang_code