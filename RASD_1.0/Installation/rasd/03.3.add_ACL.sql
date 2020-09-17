rem PL/SQL Developer Test Script

set feedback off
set autoprint off
spool 03.3.add_ACL.log

rem Execute PL/SQL Block
begin
-- ADD sourceforge.net to RASD, for checking latests versions of RASD
dbms_network_acl_admin.create_acl (
acl => 'URL_RASD_PERMISSIONS.xml', 
description => 'URL_RASD_PERMISSIONS',
principal => 'RASD',
is_grant => TRUE,
privilege => 'connect',
start_date => null,
end_date => null
);
dbms_output.put_line('acl URL_RASD_PERMISSIONS created');
commit;
end;
/
begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'URL_RASD_PERMISSIONS.xml',
principal => 'RASD',
is_grant => true,
privilege => 'connect');

DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'URL_RASD_PERMISSIONS.xml',
principal => 'RASD',
is_grant => true,
privilege => 'resolve');

dbms_output.put_line('Added privileges connect, resolve to acl URL_RASD_PERMISSIONS.');
commit;
end;
/
begin  
dbms_network_acl_admin.assign_acl (
acl => 'URL_RASD_PERMISSIONS.xml',
host => 'sourceforge.net',  
lower_port => 80,
upper_port => 80
);
COMMIT;
dbms_network_acl_admin.assign_acl (
acl => 'URL_RASD_PERMISSIONS.xml',
host => 'sourceforge.net',  
lower_port => 443,
upper_port => 443
);
dbms_output.put_line('Open acces to sourceforge.net on port 80 and 443 to acl URL_RASD_PERMISSIONS.');
COMMIT;
end;
/
begin  
dbms_output.put_line('Registrated ACL premisons for RASD:');
for r in (
SELECT PRINCIPAL, HOST, lower_port, upper_port, acl, 'connect' AS PRIVILEGE 
--    DECODE(DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE_ACLID(aclid, PRINCIPAL, 'connect'), 1,'GRANTED', 0,'DENIED', NULL) PRIVILEGE_STATUS
FROM DBA_NETWORK_ACLS
    JOIN DBA_NETWORK_ACL_PRIVILEGES USING (ACL, ACLID) 
WHERE ACL like '%RASD%'    
UNION ALL
SELECT PRINCIPAL, HOST, NULL lower_port, NULL upper_port, acl, 'resolve' AS PRIVILEGE 
--    DECODE(DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE_ACLID(aclid, PRINCIPAL, 'resolve'), 1,'GRANTED', 0,'DENIED', NULL) PRIVILEGE_STATUS
FROM DBA_NETWORK_ACLS
    JOIN DBA_NETWORK_ACL_PRIVILEGES USING (ACL, ACLID)
WHERE ACL like '%RASD%'   
order by acl, principal
) loop

dbms_output.put_line(lpad(r.PRINCIPAL,20,' ')||' '||lpad(r.host,20,' ')||' '||lpad(nvl(r.lower_port,'0'),5,' ')||' '||lpad(nvl(r.upper_port,'0'),5,' ')||' '||lpad(r.acl,50,' ')||' '|| r.privilege);
end loop;

dbms_output.put_line('IMPORTANT!!!');
dbms_output.put_line('Now you have to add souceforge.net certificate (public key) to your oracle wallet (location is set in RASD.RASDI_CLIENT).');

COMMIT;
end;
/
/*
To connect RASD to SOURCEFORGE you have to creta Wallet with valid certificate of site.
This Wallet must be then connected to HTTP request (utl_http.begin_request, UTL_HTTP.set_wallet).
https://docs.oracle.com/middleware/1213/wls/JDBCA/oraclewallet.htm#JDBCA596
https://oracle-base.com/articles/misc/utl_http-and-ssl
*/
spool off