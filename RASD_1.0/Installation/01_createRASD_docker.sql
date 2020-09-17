conn system/oracle@XE
prompt CREATE RASD ENVIORMENT 
@rasd/00.create_schema_rasd.sql
conn rasd/ChangeRASDPwd123@XE 
@rasd/01.rasd_objects.sql
@rasd/02.rasd_app_db_data.sql
commit;
conn system/oracle@XE 
@rasd/03.2.create_app_privileges.sql
@rasd/03.3.add_ACL.sql
commit;
prompt CREATE YOUR CLIENT
conn system/oracle@XE
@your_app_schema/0.create_your_app_schema.sql
conn sys/oracle@XE as sysdba
@your_app_schema/0.create_your_app_schema_sysprvs.sql
conn your_app_schema/ChangeYourYASPwd123@XE
@your_app_schema/1.rasd_clinet_table_documents.sql
@your_app_schema/2.rasd_clinet_table_of_user_scott.sql
@your_app_schema/3.rasd_client_applications.sql
@your_app_schema/4.rasd_client_DOCUMENTS_data.sql
@your_app_schema/5.rasd_client_privileges.sql
commit;
prompt REGISTERING DAD
conn system/oracle@XE
 begin
   DBMS_EPG.create_dad('your_application', '/your_application_url/*');  
   DBMS_EPG.set_dad_attribute('your_application','authentication-mode' ,'Basic');     
   DBMS_EPG.set_dad_attribute('your_application','database-username'   ,'YOUR_APP_SCHEMA');
   DBMS_EPG.set_dad_attribute('your_application','document-path'       ,'docs');     
   DBMS_EPG.set_dad_attribute('your_application','document-procedure'  ,'documents_api.download'); 
   DBMS_EPG.set_dad_attribute('your_application','document-table-name' ,'DOCUMENTS');  
   DBMS_EPG.set_dad_attribute('your_application','default-page'        ,'welcome.page');
   DBMS_EPG.set_dad_attribute('your_application','nls-language'        ,'AMERICAN_AMERICA.UTF8'); 
   DBMS_EPG.AUTHORIZE_DAD('your_application', 'YOUR_APP_SCHEMA');
   
   DBMS_EPG.create_dad('rasdlib', '/rasdlib/*');  
   DBMS_EPG.set_dad_attribute('rasdlib','authentication-mode' ,'Basic');     
   DBMS_EPG.set_dad_attribute('rasdlib','database-username'   ,'YOUR_APP_SCHEMA');
   DBMS_EPG.set_dad_attribute('rasdlib','document-path'       ,'docs');     
   DBMS_EPG.set_dad_attribute('rasdlib','document-procedure'  ,'documents_api.download'); 
   DBMS_EPG.set_dad_attribute('rasdlib','document-table-name' ,'DOCUMENTS');  
   DBMS_EPG.set_dad_attribute('rasdlib','default-page'        ,'welcome.page');
   DBMS_EPG.set_dad_attribute('rasdlib','nls-language'        ,'AMERICAN_AMERICA.UTF8'); 
   DBMS_EPG.AUTHORIZE_DAD('rasdlib', 'YOUR_APP_SCHEMA');
   
   DBMS_EPG.create_dad('rasddevlib', '/rasddevlib/*');  
   DBMS_EPG.set_dad_attribute('rasddevlib','authentication-mode' ,'Basic');     
   DBMS_EPG.set_dad_attribute('rasddevlib','database-username'   ,'YOUR_APP_SCHEMA');
   DBMS_EPG.set_dad_attribute('rasddevlib','document-path'       ,'docs');     
   DBMS_EPG.set_dad_attribute('rasddevlib','document-procedure'  ,'documents_api.download'); 
   DBMS_EPG.set_dad_attribute('rasddevlib','document-table-name' ,'DOCUMENTS');  
   DBMS_EPG.set_dad_attribute('rasddevlib','default-page'        ,'welcome.page');
   DBMS_EPG.set_dad_attribute('rasddevlib','nls-language'        ,'AMERICAN_AMERICA.UTF8'); 
   DBMS_EPG.AUTHORIZE_DAD('rasddevlib', 'YOUR_APP_SCHEMA');
   
   commit;
 end;
/
prompt run http://127.0.0.1:8080/your_application_url/welcome.page
exit
