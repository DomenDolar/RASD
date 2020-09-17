----------------------------------------------------
-- Privileges to RASD user                        --
----------------------------------------------------

set define off
spool 5.rasd_client_privileges.log
prompt Privileges to RASD

grant select, update on documents to rasd;
grant execute on Documents_Api to rasd;

spool off
