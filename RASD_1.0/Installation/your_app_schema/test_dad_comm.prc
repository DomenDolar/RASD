CREATE OR REPLACE PROCEDURE TEST_DAD_COMM(GUID VARCHAR2) is
  x varchar2(1000);
  e varchar2(1000);
  test varchar2(1000);
BEGIN
  
/* 
    declare
      vc OWA_COOKIE.cookie;   
      cc OWA_COOKIE.vc_arr;
      nn OWA_COOKIE. vc_arr;   
      d number;
    begin
      owa_cookie.get_all(cc,nn, d);
      e := 'Read COOKIES = '||d; 
    exception when others then
      e := 'Read COOKIES error. Set server IE 11 -> Internet tools -> Privacy -> Sites -> add site Allow'; 
      x := '';
    end;
 */       
    declare
      vc OWA_COOKIE.cookie;      
    begin
      vc := owa_cookie.get('myCookie');
      x := vc.vals(1);
      e := 'Read COOKIE myCookie OK'; 
    exception when others then
      e := '<font color="red">Read COOKIES error (COOKIE myCookie not exists). Set server IE 11 -> Internet tools -> Privacy -> Sites -> add site Allow</font>'; 
      x := '';
    end;
          
    begin
        owa_util.mime_header('text/html', FALSE);        
        OWA_COOKIE.SEND('myCookie', guid , null,null);
        --owa_util.redirect_url('zpizrasd.TEST_DAD_COMM?GUID='||guid);
        owa_util.http_header_close;
    exception when others then
      e := 'Save COOKIE myCookie error!'; 
    end;  



    htp.p('Welcome '||user||'. </br>');
    htp.p('Your GUID is '||guid||'.</br>');
    htp.p(e||'.</br>');
    test:= owa_util.get_cgi_env('HTTP_USER_AGENT');
    htp.p(test||'.</br>');
    owa_util.print_cgi_env; 
    

    htp.p('</BR>');
        htp.p('</BR>');
    htp.p('NLS_SESSION_PARAMETERS'||'</BR>');
    
    for r in (  
    select * from nls_session_parameters
    ) loop
    
    htp.p(r.parameter||':'||r.value||'</BR>');
    
    end loop;
    
       htp.p('</BR>');
        htp.p('</BR>');
    htp.p('NLS_INSTANCE_PARAMETERS'||'</BR>');
    
    for r in (  
    select * from nls_instance_parameters
    ) loop
    
    htp.p(r.parameter||':'||r.value||'</BR>');
    
    end loop;     
    
           htp.p('</BR>');
        htp.p('</BR>');
    htp.p('NLS_DATABASE_PARAMETERS'||'</BR>');
    
    for r in (  
    select * from nls_database_parameters
    ) loop
    
    htp.p(r.parameter||':'||r.value||'</BR>');
    
    end loop;    
    
    
       
END TEST_DAD_COMM;
/

