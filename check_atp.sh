export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib
export ORACLE_HOME=/usr/lib/oracle/18.3/client64
export TNS_ADMIN=/usr/lib/oracle/18.3/client64/lib/network/admin
export PATH=$PATH:/usr/lib/oracle/18.3/client64/bin

sqlplus ADMIN/BEstrO0ng_#11@fkatpdb1_tp << EOF
SELECT NAME, OPEN_MODE FROM V$DATABASE;
exit;
EOF