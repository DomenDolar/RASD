set define off
spool 0.create_schema_rasd.log
prompt
prompt Creating user your_app_schema
prompt =====================
prompt
create user your_app_schema
  identified by ChangeYourYASPwd123
  default tablespace SYSTEM
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant connect to your_app_schema;
grant resource to your_app_schema;

prompt =====================
prompt
spool off
