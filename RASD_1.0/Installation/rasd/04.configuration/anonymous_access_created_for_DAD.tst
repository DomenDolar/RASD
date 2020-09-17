/*
// +---------------------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                                    |
// +---------------------------------------------------------------------------------+
// | Installation - Adding anonymous access to DAD                                   |
// +---------------------------------------------------------------------------------+
// |                                                                                 |
// | Additional documentation about creating embeded DAD                             |
// | http://www.oracle-base.com/articles/11g/native-oracle-xml-db-web-services-11gr1.php    | 
// | http://sourceforge.net/p/rasd/wiki/Installation/                                |
// |                                                                                 |
// +---------------------------------------------------------------------------------+
*/  

/*
// Log on to the database as an XML DB administrator, that is, a user with the XDBADMIN role assigned.
*/ 
DECLARE
l_configxml XMLTYPE;
l_value VARCHAR2(5) := 'true'; -- (true/false)
BEGIN
l_configxml := DBMS_XDB.cfg_get();

IF l_configxml.existsNode('/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access') = 0 THEN
-- Add missing element.
SELECT insertChildXML
(
l_configxml,
     '/xdbconfig/sysconfig/protocolconfig/httpconfig',
     'allow-repository-anonymous-access',
     XMLType('<allow-repository-anonymous-access xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">' ||
     l_value ||
     '</allow-repository-anonymous-access>'),
     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
     )
INTO l_configxml
FROM dual;

DBMS_OUTPUT.put_line('Element inserted.');
ELSE
-- Update existing element.
SELECT updateXML
(
DBMS_XDB.cfg_get(),
'/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access/text()',
l_value,
'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
)
INTO l_configxml
FROM dual;
DBMS_OUTPUT.put_line('Element updated.');
END IF;

DBMS_XDB.cfg_update(l_configxml);
DBMS_XDB.cfg_refresh;
end;
/
ALTER USER anonymous ACCOUNT UNLOCK;


