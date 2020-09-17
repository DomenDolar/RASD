create or replace package RASD_CLIENT is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: RASD_CLIENT generated on 27.03.18 by user RASDCLI.     
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | This program is generated form RASD version 1.                       |
// +----------------------------------------------------------------------+
*/    
function version return varchar2;
function metadata return clob;
procedure metadata;
procedure webclient(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure rest(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure rlog(v_clob clob);
procedure form_js(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure form_css(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
  e_finished exception;

  type dt is varray(2) of varchar2(30);
  type dttab is table of dt;
  c_date_transform constant dttab := dttab(
      -- PL/SQL type , jQuery type : format is case sensitive
      dt('yyyy-mm-dd','yy-mm-dd') ,
      dt('yyyy/mm/dd','yy/mm/dd') ,
      dt('dd.mm.yyyy','dd.mm.yy') ,
      dt('dd/mm/yyyy', 'dd/mm/yy') ,
      dt('dd-mm-yyyy', 'dd-mm-yy') ,
      dt('mm/dd/yyyy', 'mm/dd/yy') ,
      -- default type NULL must always be the last element
      dt('NULL','mm/dd/yy')
  );
  type dtt is varray(2) of varchar2(30);
  type dtttab is table of dtt;
  c_time_transform constant dtttab := dtttab(
      -- PL/SQL type , jQuery type : ime format is case sensitive
      dtt('hh24:mi','hh:mm') ,
      dtt('hh24:mi:ss','hh:mm:ss'),
      -- default type NULL must always be the last element
      dtt('NULL','hh:mm')
  );

  C_DATE_FORMAT constant varchar2(10) := 'mm/dd/yyyy';
  C_TIMESTAMP_FORMAT constant varchar2(30) := 'mm/dd/yyyy hh24:mi:ss.ff';  
  C_NUMBER_DECIMAL constant varchar2(1) := '.';
  C_NUMBER_THOUSAND constant varchar2(1) := ',';
  C_NLS_DATE_LANGUAGE constant varchar2(20) := 'AMERICAN';
  C_NLS_LANGUAGE constant varchar2(20) := 'AMERICAN'; 

  c_HtmlJSLibraryFile varchar2(30) := 'rasd/rasd_jslib.html';
  c_HtmlDataTableFile varchar2(30) := 'rasd/rasd_datatable.html';
  c_HtmlHtmlDatePickerFile varchar2(30) := 'rasd/rasd_datepicker.html';
  c_HtmlFooterFile varchar2(30) := 'rasd/rasd_footer.html';

  c_DOC_ACCESS_PATH varchar2(30) := '/rasdlib/docs'; --

  function getHtmlJSLibrary (name varchar2, value varchar2) return varchar2;
  function getHtmlDataTable (name varchar2) return varchar2;
  function getHtmlDatePicker (name varchar2, format varchar2) return varchar2;
  function getHtmlFooter (version varchar2, program varchar2 , user varchar2) return varchar2;

  function varchr2number(p_value varchar2) return number;

  procedure sessionStart;
  procedure sessionSetValue(pname varchar2, pvalue varchar2);
  function  sessionGetValue(pname varchar2) return varchar2;
  procedure sessionClose;

  function getHtmlMenuList(p_formname varchar2) return varchar2;

  /*Security functions*/
  function secGetUsername return varchar2;
  function secGetLOB return varchar2;
  function secGet_HTTP_ACCEPT return varchar2;
  function secGet_HTTP_ACCEPT_ENCODING return varchar2;
  function secGet_HTTP_ACCEPT_LANGUAGE return varchar2;
  function secGet_HTTP_ACCEPT_CHARSET return varchar2;
  function secGet_HTTP_HOST return varchar2;
  function secGet_HTTP_PORT return varchar2;
  function secGet_HTTP_USER_AGENT return varchar2;
  function secGet_PATH_INFO return varchar2;
  function secGet_PATH_ALIAS return varchar2;
  function secGet_REMOTE_ADDR return varchar2;
  function secGet_REQUEST_CHARSET return varchar2;
  function secGet_SCRIPT_NAME return varchar2;      

  procedure secCheckPermission(p_form varchar2, p_action varchar2);
  procedure secCheckCredentials(p_username varchar2, p_password varchar2, p_other varchar2 default null);
  procedure secCheckCredentials(  name_array  in owa.vc_arr, value_array in owa.vc_arr);
  
end;
/
create or replace package body RASD_CLIENT is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: RASD_CLIENT generated on 27.03.18 by user RASDCLI.    
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | This program is generated form RASD version 1.                       |
// +----------------------------------------------------------------------+
*/    
  type rtab is table of rowid          index by binary_integer;
  type ntab is table of number         index by binary_integer;
  type dtab is table of date           index by binary_integer;
  type ttab is table of timestamp      index by binary_integer;
  type ctab is table of varchar2(4000) index by binary_integer;
  type cctab is table of clob index by binary_integer;
  type itab is table of pls_integer    index by binary_integer;
  log__ clob := '';
  set_session_block__ clob := '';
  RESTRESTYPE varchar2(4000);
  ACTION                        varchar2(4000);
  PAGE                          varchar2(4000);
  MESSAGE                       varchar2(4000);
  B10OUT                        ctab;
  
  function Blob2Clob(B BLOB) 
return clob is 
c clob;
n number;
v varchar2(32767 CHAR); 
begin 
if (b is null) then 
return null;
end if;
if (length(b)=0) then
return empty_clob(); 
end if;
dbms_lob.createtemporary(c,true);
n:=1;

while (n+32767<=length(b)) loop
dbms_lob.writeappend(c,32767,utl_raw.cast_to_varchar2(dbms_lob.substr(b,32767,n)));
n:=n+32767;
end loop;
v := utl_raw.cast_to_varchar2(dbms_lob.substr(b,length(b)-n+1,n));

dbms_lob.writeappend(c,length(v),v);
return c;
end;

  function getHtmlJSLibrary (name varchar2, value varchar2) return varchar2 is
    v_t varchar(32000);
    v_root varchar2(200);
    x blob;
  begin
    v_root := OWA_UTIL.get_cgi_env('DOC_ACCESS_PATH');
  
    select blob_content into x
    from documents where name = c_HtmlJSLibraryFile;
    v_t := Blob2Clob(x);
    
    if v_root is null then
       v_t := replace(v_t,'docs/',c_DOC_ACCESS_PATH||'/');
    end if;    
    
    return replace(replace(v_t, ':NAME', name),':VALUE',value);
    exception when others then return '';
  end;

  function getHtmlDataTable (name varchar2) return varchar2 is
    v_t varchar(32000);
    x blob;
 begin
    select blob_content into x
    from documents where name = c_HtmlDataTableFile;
    v_t := Blob2Clob(x);
    return replace(v_t, ':NAME', name);
    exception when others then return '';
  end;

  function getHtmlDatePicker (name varchar2, format varchar2) return varchar2 is
     v_t varchar(32000);
    v_fd varchar2(100);
    v_ft varchar2(100);
    v_p varchar2(1000);
    v_format varchar2(1000) := format;
    x blob;
  begin
    if v_format is null then
        v_fd := c_date_transform(c_date_transform.LAST)(2);
        v_ft := c_time_transform(c_time_transform.LAST)(2);
        v_p := ', showTimepicker: false';
    else
      FOR i IN c_date_transform.FIRST .. c_date_transform.LAST
      LOOP
        if instr( nvl(v_format,'NULL') , c_date_transform(i)(1)) > 0 then
           v_fd := c_date_transform(i)(2);
           v_format := replace(v_format, c_date_transform(i)(1) , '');
           exit;
        end if;   
      END LOOP;
      if v_fd is null then
        v_fd := c_date_transform(c_date_transform.LAST)(2);
      end if;
      if v_format is not null then
      FOR i IN c_time_transform.FIRST .. c_time_transform.LAST
      LOOP
        if instr( nvl(v_format,'NULL') , c_time_transform(i)(1)) > 0 then
           v_ft := c_time_transform(i)(2);
           v_format := replace(v_format, c_time_transform(i)(1) , '');
           exit;
        end if;   
      END LOOP;
      if v_ft is null then
        v_ft := c_time_transform(c_time_transform.LAST)(2);
        v_p := ', showTimepicker: false';        
      end if;
      if trim(v_format) is not null then 
        v_fd := c_date_transform(c_date_transform.LAST)(2);
        v_ft := c_time_transform(c_time_transform.LAST)(2);
        v_p := ', showTimepicker: false';           
      end if;  
      else
        v_p := ', showTimepicker: false';                   
      end if;    
    end if;
       
    select blob_content into x 
    from documents where name = c_HtmlHtmlDatePickerFile;
        v_t := Blob2Clob(x);
    return replace(replace(replace(replace(v_t, ':NAME', name), ':DFORMAT', v_fd),':TFORMAT', v_ft),':PROPERTIES', v_p);
  exception when others then return '';
  end;  

  function getHtmlFooter (version varchar2, program varchar2 , user varchar2) return varchar2 is
    v_t varchar(32000);
    x blob;
  begin
    select blob_content into x 
    from documents where name = c_HtmlFooterFile;
        v_t := Blob2Clob(x);
    return replace(replace(replace(v_t, ':VERSION', version), ':PROGRAM', program),':USER', user);
    exception when others then return '';
  end; 

 function varchr2number(p_value varchar2) return number is
    v_dot   number;
    v_comma number;
    v_value varchar2(30) := p_value;
    error exception;
  begin
    if p_value is not null then
      v_dot := instr(v_value, C_NUMBER_THOUSAND);
      if v_dot = 0 then
        return to_number(v_value);
      else
        while v_dot <> 0 Loop
          v_value := substr(v_value, v_dot + 1);
          v_dot   := instr(v_value, C_NUMBER_THOUSAND);
          v_comma := instr(v_value, C_NUMBER_DECIMAL);
          if v_dot <> 0 then
            if v_dot <> 4 then
              raise error;
            end if;
          else

            if v_comma <> 0 then
              if v_comma <> 4 then
                raise error;
              else
                return(to_number(replace(p_value, C_NUMBER_THOUSAND, '')));
              end if;
            else
              if length(v_value) <> 3 then
                raise error;
              else
                return(to_number(replace(p_value, C_NUMBER_THOUSAND, '')));
              end if;
            end if;
          end if;
        end loop;
      end if;
    else
      return(to_number(null));
    end if;
  end;

  procedure sessionStart is
  begin
    owa_util.mime_header('text/html', FALSE);
  end;

  procedure sessionSetValue(pname varchar2, pvalue varchar2) is
  begin
    OWA_COOKIE.SEND('rasd$'||pname, pvalue , null,null);
  end;

  function sessionGetValue(pname varchar2) return varchar2 is
     vc OWA_COOKIE.cookie;
  begin
     vc := owa_cookie.get('rasd$'||pname);
     return vc.vals(1);
  exception when others then
    return '';
  end;

  procedure sessionclose is
  begin
     owa_util.http_header_close;
  end;

  function getHtmlMenuList(p_formname varchar2) return varchar2 is
    v_menu varchar2(32000) := '';
  begin
  
    for r in (select '!'||lower(object_name)||'.webclient' url, object_name  from user_objects where object_name like 'DEMO%' and object_type = 'PACKAGE'
order by object_name) loop
      v_menu := v_menu || '<li><a href="'||r.url||'">'||r.object_name||'</a></li>
';
    end loop;
/*    v_menu := '
<div id="menucss">
<ul  id="nav">
   <li class=''active''><a href="!WELCOME.webclient">Welcome</a></li>
   <li class=''has-sub''><a href="#">Demo sample</a>
      <ul>
         '||v_menu||'
      </ul>
   </li>
</ul>
</div>
  <script>
  </script>
  <style>
  </style>
';*/

    v_menu := '
<table id="menucss">
<tr>
   <td width="150px"><ul id="menu1"><a href="!WELCOME.webclient">Welcome</a> </ul></td>
   <td width="150px">
      <ul id="menu">
      <li><a href="#">Demo sample</a>
      <ul >
         '||v_menu||'
      </ul>
      </li>
      </ul>
   </td>
</tr>
</table>
  <script>
  $( function() {
    $( "#menu" ).menu();
    $( "#menu1" ).menu();
  } );  
  </script>
  <style>
    .ui-menu { width: 300px; }  
  </style>
';


    return v_menu;

  end;
  /*Security functions*/

  function secGetUsername return varchar2 is
  begin
    /*Your code. Username is from cgi enviorment and it is based on you DADs configutration.*/

     return '';
    /*---------*/
  end;

  function secGetLOB return varchar2 is
  begin
    /*Your code. LineOfBusiness is from cgi enviorment and it is based on you DADs configutration.*/

     return '';
    /*---------*/
  end;

  function secGet_HTTP_ACCEPT return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_ACCEPT'); --HTTP_ACCEPT = text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
  end;

  function secGet_HTTP_ACCEPT_ENCODING return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_ACCEPT_ENCODING'); --HTTP_ACCEPT_ENCODING = gzip, deflate
  end;

  function secGet_HTTP_ACCEPT_LANGUAGE return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_ACCEPT_LANGUAGE'); --HTTP_ACCEPT_LANGUAGE = en,sl;q=0.9,en-GB;q=0.8
  end;

  function secGet_HTTP_ACCEPT_CHARSET return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_ACCEPT_CHARSET'); --HTTP_ACCEPT_CHARSET =
  end;

  function secGet_HTTP_HOST return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_HOST'); --HTTP_HOST = was-test.zpiz.si:9081
  end;

  function secGet_HTTP_PORT return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('HTTP_PORT'); --HTTP_PORT = 9081
  end;

  function secGet_HTTP_USER_AGENT return varchar2 is
  begin
     return  OWA_UTIL.get_cgi_env('HTTP_USER_AGENT'); --HTTP_USER_AGENT = Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36
  end;

  function secGet_PATH_INFO return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('PATH_INFO'); --
  end;

  function secGet_PATH_ALIAS return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('PATH_ALIAS'); --
  end;
  
  function secGet_REMOTE_ADDR return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('REMOTE_ADDR'); --
  end;
  
  function secGet_REQUEST_CHARSET return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('REQUEST_CHARSET'); --
  end;
  
  function secGet_SCRIPT_NAME return varchar2 is
  begin
     return OWA_UTIL.get_cgi_env('SCRIPT_NAME'); --
  end;      



  procedure secCheckPermission(p_form varchar2, p_action varchar2) is
  begin
    /*Your code.*/

    if false then raise_application_error('-20000', 'No privileges'); end if;
    /*---------*/
  end;

  procedure secCheckCredentials(p_username varchar2, p_password varchar2, p_other varchar2 default null) is
  begin
    /*Your code.*/
    if false is null then -- check credentials in you user db
      raise_application_error('-20000', 'Invalid user logon credentials!');
    end if;
    /*---------*/
  end;

  procedure secCheckCredentials(  name_array  in owa.vc_arr, value_array in owa.vc_arr ) is
    /*Your code.*/
    vu varchar2(111);
    vp varchar2(222);
    vo varchar2(333);
    vl varchar2(32000);
    vl1 varchar2(32000);
    vcv varchar2(444);
  begin
    declare
      vc OWA_COOKIE.cookie;
    begin
      vc := owa_cookie.get('SECCLIENTUSER');
      vcv := vc.vals(1);
    exception when others then
      vcv := '';
    end;

    if vcv is null then

    for i__ in 1 .. nvl(name_array.count, 0) loop
      if    upper(name_array(i__)) = upper('SECCLIENTUSER') then
        vu := value_array(i__);
      elsif upper(name_array(i__)) = upper('SECCLIENTPWD') then
        vp := value_array(i__);
      elsif upper(name_array(i__)) = upper('SECCLIENTOTHER') then
        vo:= value_array(i__);
      elsif upper(name_array(i__)) = upper('SECCLIENTURL') then
        vl:= value_array(i__);
      end if;
      vl1 := vl1||'&'||name_array(i__)||'='||value_array(i__);
    end loop;

    vl1:= substr(owa_util.get_cgi_env('PATH_INFO'),2)||'?1=1'||vl1;


    secCheckCredentials(vu, vp, vo);
    begin
    owa_util.mime_header('text/html', FALSE);
    OWA_COOKIE.SEND('SECCLIENTUSER', nvl(vu,'set values in RASD_CLIENT package'), null);
    OWA_COOKIE.SEND('SECCLIENTOTHER', nvl(vo,'set values in RASD_CLIENT package'), null);


    if vl is not null then
       OWA_UTIL.REDIRECT_URL(vl);
       owa_util.http_header_close;
    else
       OWA_UTIL.REDIRECT_URL(vl1);
       owa_util.http_header_close;
    end if;

    exception when others then
      null;
    end ;

    end if;
  exception when others then
       OWA_UTIL.REDIRECT_URL('your redirection to login page');
       owa_util.http_header_close;
  /*---------*/
  end;

     procedure htpClob(v_clob clob) is
        i number := 0;
        v clob := v_clob;
       begin
       while length(v) > 0 and i < 100000 loop
        htp.prn(substr(v,1,10000));
        i := i + 1;
        v := substr(v,10001);
       end loop; 
       end; 
     procedure rlog(v_clob clob) is
       begin
        log__ := log__ ||v_clob||'<br/>';
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '
';
       end; 
     function form_js return clob is
       begin
        return  '
        ';
       end; 
     function form_css return clob is
       begin
        return '
        ';
       end; 
procedure form_js(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is begin htpClob(form_js); end;
procedure form_css(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is begin htpClob(form_css); end;
  function version return varchar2 is
  begin
   return 'v.1.1.20180327090635'; 
  end;
  procedure on_session is
    i__ pls_integer := 1;
  begin
  if ACTION is not null then 
set_session_block__ := set_session_block__ || 'begin ';
set_session_block__ := set_session_block__ || 'rasd_client.sessionStart;';
set_session_block__ := set_session_block__ || ' rasd_client.sessionClose;';
set_session_block__ := set_session_block__ || 'exception when others then null; end;';
  else 
 rasd_client.sessionStart;
declare vc varchar2(2000); begin
null;
exception when others then  null; end;    rasd_client.sessionClose;  end if;
  end;
  procedure on_submit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
    v_max  pls_integer := 0;
  begin
-- submit fields
    for i__ in 1..nvl(num_entries,0) loop
      if 1 = 2 then null;
      elsif  upper(name_array(i__)) = 'RESTRESTYPE' then RESTRESTYPE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10OUT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10OUT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10OUT') and B10OUT.count = 0 and value_array(i__) is not null then
        B10OUT(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10OUT.count > v_max then v_max := B10OUT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10OUT.exists(i__) then
        B10OUT(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
    null;
  end;
  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
  begin
-- Reading post variables into fields.
    on_submit(name_array ,value_array); on_session;
    post_submit;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 1 = 0 then k__ := i__ + 0;
      else  
       if i__ > 1 then  k__ := i__ + 0;
       else k__ := 0 + 1;
       end if;
      end if;
      j__ := i__;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10OUT(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    PAGE := null;
    MESSAGE := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);

  null;
  end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10OUT.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10OUT.count loop
--<on_validate formid="25" blockid="B10">
--</on_validate>
    null; end loop;
  null; end;
  procedure pcommit is
  begin
--<pre_commit formid="25" blockid="">
--</pre_commit>
--<post_commit formid="25" blockid="">
--</post_commit>
  null; 
  end;
  procedure poutput is
  function ShowFieldMESSAGE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldPAGE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB10_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','RASD_CLIENT Library')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="RASD_CLIENT_LAB" class="rasdFormLab">RASD_CLIENT Library '|| rasd_client.getHtmlDataTable('RASD_CLIENT_LAB') ||'     </div>
<form name="RASD_CLIENT" method="post" action="!rasd_client.webclient"><div id="RASD_CLIENT_DIV" class="rasdForm"><div id="RASD_CLIENT_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('RASD_CLIENT_MENU') ||'     </div><div id="RASD_CLIENT_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldPAGE  then  
htp.prn('<input name="PAGE" id="PAGE_RASD" type="text" value="'||PAGE||'" class="rasdTextC"/>');  end if;  
htp.prn('
</div> id="B10_DIV" class="rasdblock"');  if  ShowBlockB10_DIV  then  
htp.prn('<div id="B10_DIV" class="rasdblock" ><div>
<table border="0" id="B10_TABLE">
<caption><div id="B10_LAB" class="labelblock"></div></caption><thead><tr>
<td><span id="B10OUT_LAB" class="label"></span></td></tr></thead><tr id="B10_BLOCK">
<td><span id="B10OUT_1_RASD">');  htp.p('
Library ....
');  
htp.prn('</span></td></tr></table></div></div>');  end if;  
htp.prn('<div id="RASD_CLIENT_MESSAGE_RASD" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="RASD_CLIENT_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('RASD_CLIENT_FOOTER',1,instr('RASD_CLIENT_FOOTER', '_')-1) , '') ||'</div></div></form></body></html>
    ');
  null; end;
  procedure poutputrest is
    v_firstrow__ boolean;
    function escapeRest(v_str varchar2) return varchar2 is 
    begin
      return replace(v_str,'"','&quot;');
    end;
    function escapeRest(v_str clob) return clob is 
    begin
      return replace(v_str,'"','&quot;');
    end;
  function ShowBlockB10_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="RASD_CLIENT" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<page><![CDATA['||PAGE||']]></page>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('</formfields>'); 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10out><![CDATA['||B10OUT(1)||']]></b10out>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"RASD_CLIENT","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"page":"'||escapeRest(PAGE)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p('},'); 
    if ShowBlockb10_DIV then 
    htp.p('"b10":['); 
     htp.p('{'); 
    htp.p('"b10out":"'||escapeRest(B10OUT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"b10":[]'); 
  end if; 
    htp.p('}}'); 
end if;
  null; end;
procedure webclient(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('RASD_CLIENT',ACTION);  
  if ACTION is null then null;
    pselect;
    poutput;
  end if;

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','RASD_CLIENT Library')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="RASD_CLIENT_LAB" class="rasdFormLab">RASD_CLIENT Library '|| rasd_client.getHtmlDataTable('RASD_CLIENT_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div></div></body><html>
    ');
    pLog;
end; 
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('RASD_CLIENT',ACTION);  

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
    poutput;
  end if;

-- Error handler for the main program.
 exception
  when rasd_client.e_finished then null;

end; 
procedure rest(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('RASD_CLIENT',ACTION);  
  if ACTION is null then null;
    pselect;
    poutputrest;
  end if;

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="RASD_CLIENT" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"RASD_CLIENT","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
     return v_vc;
  end;
function metadata return clob is
  v_clob clob := '';
  v_vc cctab;
  begin
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       v_clob := v_clob || v_vc(i);
     end loop;
     return v_clob;
  end;
procedure metadata is
  v_clob clob := '';
  v_vc cctab;
  begin
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS= '''||C_NUMBER_DECIMAL||''||C_NUMBER_THOUSAND||''' ';
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_LANGUAGE = '''||C_NLS_DATE_LANGUAGE||''' ';
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = '''||C_NLS_LANGUAGE||''' ';   
end RASD_CLIENT;
/
