expdp system/mcrs4@fap parfile=expdp_no_data.par
=== BEGIN expdp_no_data.par

DUMPFILE=DATA_PUMP_DIR:exp_full_no_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=DATA_PUMP_DIR:exp_full_no_data.log
FULL=Y
CONTENT=METADATA_ONLY
EXCLUDE=STATISTICS
EXCLUDE=CONSTRAINTS
EXCLUDE=TRIGGERS
EXCLUDE=INDEX
EXCLUDE=SCHEMA:"IN ('ANONYMOUS','CTXSYS','DBSNMP','DMSYS','EXFSYS','MDSYS','OLAPSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','SYSMAN','WMSYS','XDB','MGMT_VIEW','OUTLN','SYS','SYSTEM','PERFSTAT','DIP','MDDATA','OPS$NTIRETY1','ORACLE_OCM','SCOTT','TSMSYS')"

=== END expdp_no_data.par
scp -r exp_full_no_data.dmp oracle@hseax15:/export/dpmpfiles/.


impdp system/o113wasm@fapa parfile=impdp_no_data.par
=== BEGIN impdp_no_data.par

DUMPFILE=FAPA_DATA_PUMP_DIR:exp_full_no_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=FAPA_DATA_PUMP_LOG_DIR:imp_full_no_data.log

=== END impdp_no_data.par



expdp system/mcrs4@fap parfile=expdp_yes_data.par
=== BEGIN expdp_yes_data.par

DUMPFILE=DATA_PUMP_DIR:exp_full_yes_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=DATA_PUMP_DIR:exp_full_yes_data.log
schemas=emsdba,maxqueue
STATUS=30

=== END expdp_yes_data.par
scp -r exp_full_yes_data.dmp oracle@hseax15:/export/dpmpfiles/.


impdp system/o113wasm@fapa parfile=impdp_yes_data.par
=== BEGIN imdp_yes_data.par

DUMPFILE=FAPA_DATA_PUMP_DIR:exp_full_yes_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=FAPA_DATA_PUMP_DIR:imp_full_yes_data.log
schemas=emsdba,maxqueue
STATUS=30

=== END impdp_yes_data.par

============================================FADA===============================================

expdp system/mcrs4@fap parfile=expdp_no_data.par
=== BEGIN expdp_no_data.par

DUMPFILE=DATA_PUMP_DIR:exp_full_no_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=DATA_PUMP_DIR:exp_full_no_data.log
FULL=Y
CONTENT=METADATA_ONLY
EXCLUDE=STATISTICS
EXCLUDE=CONSTRAINTS
EXCLUDE=TRIGGERS
EXCLUDE=INDEX
EXCLUDE=SCHEMA:"IN ('ANONYMOUS','CTXSYS','DBSNMP','DMSYS','EXFSYS','MDSYS','OLAPSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','SYSMAN','WMSYS','XDB','MGMT_VIEW','OUTLN','SYS','SYSTEM','PERFSTAT','DIP','MDDATA','OPS$NTIRETY1','ORACLE_OCM','SCOTT','TSMSYS')"

=== END expdp_no_data.par



impdp system/o113wasm@fada parfile=impdp_no_data.par
=== BEGIN impdp_no_data.par

DUMPFILE=FADA_DATA_PUMP_DIR:exp_full_no_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=FADA_DATA_PUMP_LOG_DIR:imp_full_no_data.log

=== END impdp_no_data.par



expdp system/mcrs4@fap parfile=expdp_yes_data.par
=== BEGIN expdp_yes_data.par

DUMPFILE=DATA_PUMP_DIR:exp_full_yes_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=DATA_PUMP_DIR:exp_full_yes_data.log
schemas=emsdba,maxqueue
STATUS=30

=== END expdp_yes_data.par



impdp system/o113wasm@fada parfile=impdp_yes_data.par
=== BEGIN imdp_yes_data.par

DUMPFILE=FADA_DATA_PUMP_DIR:exp_full_yes_data.dmp
#--REUSE_DUMPFILE=Y only in 11g
LOGFILE=FADA_DATA_PUMP_DIR:imp_full_yes_data.log
schemas=emsdba,maxqueue
STATUS=30

=== END impdp_yes_data.par