conn ADMIN/pwd@oracle_cloud_medium
prompt CREATE RASD ENVIORMENT 
@rasd/00.create_schema_rasd.sql
conn rasd/ChangeRASDPwd123@oracle_cloud_medium 
@rasd/01.rasd_objects.sql
@rasd/02.rasd_app_db_data.sql
commit;
conn ADMIN/pwd@oracle_cloud_medium
@rasd/03.2.create_app_privileges.sql
@rasd/03.3.add_ACL.sql
commit;
prompt CREATE YOUR CLIENT
conn ADMIN/pwd@oracle_cloud_medium
@your_app_schema/0.create_your_app_schema.sql
conn your_app_schema/ChangeYourYASPwd123@oracle_cloud_medium
@your_app_schema/1.rasd_clinet_table_documents.sql
@your_app_schema/2.rasd_clinet_table_of_user_scott.sql
@your_app_schema/3.rasd_client_applications.sql
@your_app_schema/4.rasd_client_DOCUMENTS_data.sql
@your_app_schema/5.rasd_client_privileges.sql
commit;
BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'YOUR_APP_SCHEMA',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'yas',
    p_auto_rest_auth      => FALSE
  );    
  COMMIT;
END;
/
BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, 
    p_schema       => 'YOUR_APP_SCHEMA',
    p_object       => 'EMP',
    p_object_type  => 'TABLE', 
    p_object_alias => 'employees'
  );
    
  COMMIT;
END;
/

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, 
    p_schema       => 'YOUR_APP_SCHEMA',
    p_object       => 'rasdc_sqlclient',
    p_object_type  => 'TABLE', 
    p_object_alias => 'rasdc_sqlclient'
  );
    
  COMMIT;
END;
/
--https://...oraclecloudapps.com/ords/yas/employees/
--https://...oraclecloudapps.com/ords/your_app_schema.welcome.page
exit
