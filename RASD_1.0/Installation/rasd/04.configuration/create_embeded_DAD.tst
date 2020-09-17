begin
/*
// +---------------------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                                    |
// +---------------------------------------------------------------------------------+
// | Installation - Creating embeded DAD                                             |
// +---------------------------------------------------------------------------------+
// |                                                                                 |
// | Additional documentation about creating embeded DAD                             |
// | http://docs.oracle.com/cd/E16655_01/appdev.121/e17620/adfns_web.htm#ADFNS468    | 
// | http://sourceforge.net/p/rasd/wiki/Installation/                                |
// |                                                                                 |
// +---------------------------------------------------------------------------------+
*/  

/*
// Log on to the database as an XML DB administrator, that is, a user with the XDBADMIN role assigned.
*/ 
/*
your_application - the name of your application or environment (sample: myApp)
your_application_url - the URL where your app. will be accessed (sample: myAppUrl the call will then look like http(s)://OHS or DB:port/myAppUrl)
your_app_schema - where all programs will be stored
nls-language-settings - to set your language settings (sample: SLOVENIAN_SLOVENIA.EE8MSWIN1250). You have more of them on this link
*/
/*
   DBMS_EPG.create_dad('your_application', '/your_application_url/*');  
   DBMS_EPG.set_dad_attribute('your_application','authentication-mode' ,'Basic');     
   DBMS_EPG.set_dad_attribute('your_application','database-username'   ,'your_app_schema');
   DBMS_EPG.set_dad_attribute('your_application','document-path'       ,'docs');     
   DBMS_EPG.set_dad_attribute('your_application','document-procedure'  ,'documents_api.download'); 
   DBMS_EPG.set_dad_attribute('your_application','document-table-name' ,'DOCUMENTS');  
   DBMS_EPG.set_dad_attribute('your_application','default-page'        ,'welcome.page');
   DBMS_EPG.set_dad_attribute('your_application','nls-language'        ,'nls-language-settings'); 
   DBMS_EPG.AUTHORIZE_DAD('your_application', 'your_app_schema');
*/

  DBMS_EPG.create_dad('myApp', '/myAppUrl/*');
  DBMS_EPG.set_dad_attribute('myApp','authentication-mode' ,'Basic');     
  DBMS_EPG.set_dad_attribute('myApp','database-username'   ,'SCOTT'); 
  DBMS_EPG.set_dad_attribute('myApp','document-path'       ,'docs');      
  DBMS_EPG.set_dad_attribute('myApp','document-procedure'  ,'documents_api.download'); 
  DBMS_EPG.set_dad_attribute('myApp','document-table-name' ,'DOCUMENTS');  
  DBMS_EPG.set_dad_attribute('myApp','default-page'        ,'welcome.page');
  DBMS_EPG.set_dad_attribute('myApp','nls-language'        ,'AMERICAN_AMERICA.UTF8');  
  DBMS_EPG.AUTHORIZE_DAD('myApp', 'SCOTT');
 
  commit; 
end;
/
