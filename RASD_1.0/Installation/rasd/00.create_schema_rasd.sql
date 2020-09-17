set define off
spool 00.create_schema_rasd.log
prompt
prompt Creating user RASD
prompt =====================
prompt
create user RASD
  identified by ChangeRASDPwd123
  default tablespace SYSTEM
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant connect to RASD;
grant resource to RASD;
-- Grant/Revoke system privileges
grant alter any procedure to RASD;
grant create any procedure to RASD;
grant create view to RASD;
grant debug connect session to RASD;
grant select any table to RASD;
grant unlimited tablespace to RASD;
grant select any dictionary to RASD;
grant select on dba_tab_privs to rasd;
prompt
prompt User RASD created
prompt =====================
prompt
spool off
