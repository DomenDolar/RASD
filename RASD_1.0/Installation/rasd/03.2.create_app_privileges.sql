set define off
spool 03.2.create_app_privileges.log

prompt
prompt Creating access privileges to RASD programs
prompt ============================
prompt
drop public synonym rasdc_attributes ;
drop public synonym rasdc_blocksonform ;
drop public synonym rasdc_cssjs ;
drop public synonym rasdc_errors ;
drop public synonym rasdc_fieldsonblock ;
drop public synonym rasdc_files ;
drop public synonym rasdc_forms ;
drop public synonym rasdc_hints ;
drop public synonym rasdc_html ;
drop public synonym rasdc_links ;
drop public synonym rasdc_pages ;
drop public synonym rasdc_references ;
drop public synonym rasdc_security ;
drop public synonym rasdc_sql ;
drop public synonym rasdc_sqlclient ;
drop public synonym rasdc_triggers ;
drop public synonym rasdc_versions;
drop public synonym rasdc_test ;
drop public synonym RASDC_UPLOAD ;
drop public synonym rasdc_share ;
drop public synonym rasdc_stats ;
drop public synonym rasdc_execution ;
drop public synonym RASDC_WELCOME ;
create public synonym rasdc_attributes for rasd.rasdc_attributes;
create public synonym rasdc_blocksonform for rasd.rasdc_blocksonform;
create public synonym rasdc_cssjs for rasd.rasdc_cssjs;
create public synonym rasdc_errors for rasd.rasdc_errors;
create public synonym rasdc_fieldsonblock for rasd.rasdc_fieldsonblock;
create public synonym rasdc_files for rasd.rasdc_files;
create public synonym rasdc_forms for rasd.rasdc_forms;
create public synonym rasdc_hints for rasd.rasdc_hints;
create public synonym rasdc_html for rasd.rasdc_html;
create public synonym rasdc_links for rasd.rasdc_links;
create public synonym rasdc_pages for rasd.rasdc_pages;
create public synonym rasdc_references for rasd.rasdc_references;
create public synonym rasdc_security for rasd.rasdc_security;
create public synonym rasdc_sql for rasd.rasdc_sql;
create public synonym rasdc_sqlclient for rasd.rasdc_sqlclient;
create public synonym rasdc_triggers for rasd.rasdc_triggers;
create public synonym rasdc_versions for rasd.rasdc_versions;
create public synonym rasdc_test for rasd.rasdc_test;
create public synonym RASDC_UPLOAD for rasd.RASDC_UPLOAD;
create public synonym rasdc_share for rasd.rasdc_share; 
create public synonym rasdc_stats for rasd.rasdc_stats; 
create public synonym rasdc_execution for rasd.rasdc_execution; 
create public synonym RASDC_GIT for RASD.RASDC_GIT;
create public synonym RASDC_WELCOME for rasd.rasdc_welcome;
grant execute on rasd.rasdc_attributes to public;
grant execute on rasd.rasdc_blocksonform to public;
grant execute on rasd.rasdc_cssjs to public;
grant execute on rasd.rasdc_errors to public;
grant execute on rasd.rasdc_fieldsonblock to public;
grant execute on rasd.rasdc_files to public;
grant execute on rasd.rasdc_forms to public;
grant execute on rasd.rasdc_hints to public;
grant execute on rasd.rasdc_html to public;
grant execute on rasd.rasdc_links to public;
grant execute on rasd.rasdc_pages to public;
grant execute on rasd.rasdc_references to public;
grant execute on rasd.rasdc_security to public;
grant execute on rasd.rasdc_sql to public;
grant execute on rasd.rasdc_sqlclient to public;
grant execute on rasd.rasdc_triggers to public;
grant execute on rasd.rasdc_versions to public;
grant execute on rasd.rasdc_test to public;
grant execute on rasd.RASDC_UPLOAD to public;
grant execute on rasd.rasdc_share to public;
grant execute on rasd.rasdc_stats to public;
grant execute on rasd.rasdc_execution to public;
grant execute on rasd.RASDC_GIT to public;
grant execute on RASDC_WELCOME to public;


prompt
prompt Privileges added
prompt =====================
prompt

spool off