set define off
spool 0.create_schema_rasd_sysprvs.log
prompt
prompt =====================
prompt
-- Priveleges for DD pachages FILE, HTTP, SMTP 
grant execute on utl_file to your_app_schema;
grant execute on utl_http to your_app_schema;
grant execute on utl_smtp to your_app_schema;

prompt =====================
prompt
spool off
