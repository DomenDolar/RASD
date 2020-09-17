create or replace package rasdc_security is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2014       http://rasd.sourceforge.net                 |
  // +----------------------------------------------------------------------+
  // | This program is free software; you can redistribute it and/or modify |
  // | it under the terms of the GNU General Public License as published by |
  // | the Free Software Foundation; either version 2 of the License, or    |
  // | (at your option) any later version.                                  |
  // |                                                                      |
  // | This program is distributed in the hope that it will be useful       |
  // | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  // | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
  // | GNU General Public License for more details.                         |
  // +----------------------------------------------------------------------+
  // | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
  // +----------------------------------------------------------------------+
  */
  function version(p_log out varchar2) return varchar2;

  e_potek_pravic exception;

    -- za?etna stran po logiranju
  C_starturl  CONSTANT VARCHAR2(50) := '!rasdc_forms.program?1=1';
  C_login     CONSTANT VARCHAR2(50) := '!rasdc_security.logon?1=1';
  C_logiranje CONSTANT VARCHAR2(50) := '!rasdc_security.logiranje?1=1';


  FUNCTION wwv_flow_epg_include_mod_local( PROCEDURE_NAME IN VARCHAR2)  RETURN BOOLEAN;

  procedure logon(name_array in owa.vc_arr, value_array in owa.vc_arr);
  procedure logout(name_array in owa.vc_arr, value_array in owa.vc_arr);

  procedure logiranje(name_array in owa.vc_arr, value_array in owa.vc_arr);

end;
/

create or replace package body rasdc_security is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2014       http://rasd.sourceforge.net                 |
  // +----------------------------------------------------------------------+
  // | This program is free software; you can redistribute it and/or modify |
  // | it under the terms of the GNU General Public License as published by |
  // | the Free Software Foundation; either version 2 of the License, or    |
  // | (at your option) any later version.                                  |
  // |                                                                      |
  // | This program is distributed in the hope that it will be useful       |
  // | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  // | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
  // | GNU General Public License for more details.                         |
  // +----------------------------------------------------------------------+
  // | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
  // +----------------------------------------------------------------------+
  */
  c_ip constant varchar2(15) := owa_util.get_cgi_env('REMOTE_ADDR');
  -- PREBRANA POT
  c_path_info constant varchar2(100) := substr(owa_util.get_cgi_env('PATH_INFO'),
                                               2);
  -- VELJAVNOST COOKIA (po koliko minutah pretece geslo)
  C_MinGeslo CONSTANT NUMBER := 2 / 24 / 4;

  --     v_path := '/pls/intrastat/';
  c_script_name constant varchar2(100) := owa_util.get_cgi_env('SCRIPT_NAME');

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20191126 - Added function wwv_flow_epg_include_mod_local    
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20191126225530';

  end;

FUNCTION wwv_flow_epg_include_mod_local(
    PROCEDURE_NAME IN VARCHAR2) 
RETURN BOOLEAN
IS  
  i number := 0;    
BEGIN  
    IF UPPER(procedure_name) IN (
'WELCOME',
'TEST_DAD_COMM',
'RASDC_ATTRIBUTES',
'RASDC_BLOCKSONFORM',
'RASDC_CSSJS',
'RASDC_ERRORS',
'RASDC_FIELDSONBLOCK',
'RASDC_FILES',
'RASDC_FORMS',
'RASDC_HINTS',
'RASDC_HTML',
'RASDC_LINKS',
'RASDC_PAGES',
'RASDC_REFERENCES',
'RASDC_SECURITY',
'RASDC_SQL',
'RASDC_SQLCLIENT',
'RASDC_TRIGGERS',
'RASDC_VERSION',
'RASDC_TEST',
'RASDC_UPLOAD',
'RASDC_SHARE',
'RASDC_STATS'
          ) THEN  
        RETURN TRUE;  
    ELSE  
      
select count(*) into i from rasd.rasd_forms f  where upper(f.form) = UPPER(procedure_name);
if i > 0 then    
        RETURN FALSE;  
end if;    
    
    
        RETURN FALSE;  
    END IF;  
END;


  PROCEDURE html_logiranje(name_array  in owa.vc_arr,
                           value_array in owa.vc_arr) is
    v_ssl       varchar2(1) := 'N';
    lang        varchar2(10);
    message     varchar2(1000);
    num_entries pls_integer := name_array.count;
    v_secuser varchar2(100);
    v_seclob varchar2(100);
  BEGIN
    begin
     v_secuser := rasdi_client.secGetUsername;
    exception when others then 
     v_secuser := '';
    end;   
  
    begin
     v_seclob := rasdi_client.secGetLOB;
    exception when others then 
     v_seclob := '';
    end;   

  
    if owa_util.get_cgi_env('SSL_SESSION_ID') is not null then
      v_ssl := 'D';
    end if;
    
    FOR i IN 1 .. nvl(num_entries, 0) LOOP
      if upper(name_array(i)) = 'LANG' then
        lang := value_array(i);
      elsif upper(name_array(i)) = 'MESSAGE' then
        message := value_array(i);
      end if;
    END LOOP;
    htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<SCRIPT language="javascript">
if (self != top) {top.location.href = self.location.href}
</SCRIPT>
<TITLE>Logiranje</TITLE>
</HEAD>
<BODY bgcolor="#C0C0C0">
');
    rasdc_library.shownhead(RASDI_TRNSLT.text('Logon', lang),
                               '',
                               '',
                               lang,
                               '');
    htp.prn('
<FORM ACTION="!rasdc_security.logiranje" METHOD="post" NAME="LOGIRANJE">&nbsp;
<input type=hidden name=lang value=' || lang || '>
<TABLE border = 0>
');
    if v_ssl <> 'D' then
    
      htp.p('<TR>
    <TD>' || RASDI_TRNSLT.text('Username', lang) ||
              '*:</TD>
    <TD><INPUT maxLength=20 name=KINBAROPU value="'||v_secuser||'"></TD></TR>');
    end if;
    
      
    htp.prn('<TR>
    <TD>' || RASDI_TRNSLT.text('Password', lang) || '*:</TD>
    <TD><INPUT type=password maxLength=20 name=OLSEG></TD></TR>
  <TR>
  <TR>');
   htp.p(' <TD>' || RASDI_TRNSLT.text('LineOfBusiness', lang) ||
            ':</TD>
    <TD><INPUT type=input readonly maxLength=20 value="'||v_seclob||'">
        <INPUT type=hidden name=BOL value="'||v_seclob||'">
    </TD></TR>
  <TR>
    <TD></TD>
    <TD>&nbsp;</TD></TR></TABLE>
    <INPUT class=submit type=submit value=' ||
            RASDI_TRNSLT.text('Submit', lang) ||
            ' name=AKCIJA>&nbsp;<INPUT class=submit type=reset value=' ||
            RASDI_TRNSLT.text('Reset', lang) || '>
    <DIV class=error>' || message || '</DIV>
    <P>
     <A href="' || C_logiranje || '&KINBAROPU=demo&BOL=RASD">Sample applications</A></BR></BR>
     <A href="' || C_logiranje || '&KINBAROPU=rasd&BOL=RASD">RASD supported applications (login app, menu, ...)</A>
    </P>
    <P>
      Customizing security issues, menu presentation and others can be made through package rasdi_client.
    </P>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</BODY>
<script language="JavaScript">
<!--
 document.LOGIRANJE.KINBAROPU.focus();
// -->)
</script>
</HTML>
');
    raise e_potek_pravic;
  END;

  procedure logon(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
  begin
    html_logiranje(name_array, value_array);
  exception
    when others then
      null;
  end;

  procedure logout(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
    v_cookie    owa_cookie.cookie;
  begin
    owa_cookie.remove('LOGON', '');
    owa_cookie.remove('LOGONLOB', '');
    OWA_UTIL.REDIRECT_URL(C_login);
  exception
    when others then
      null;
  end;

  procedure logiranje(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    p varchar2(1000);
    u varchar2(1000);
    l varchar2(1000);
  BEGIN

    for i__ in 1 .. nvl(name_array.count, 0) loop
      if 1 = 2 then
        null;
      elsif upper(name_array(i__)) = upper('KINBAROPU') then
        u := value_array(i__);
      elsif upper(name_array(i__)) = upper('OLSEG') then
        p := value_array(i__);
      elsif upper(name_array(i__)) = upper('BOL') then
        l := value_array(i__);
      end if;
    end loop;


    rasdi_client.secCheckCredentials(u, p, l);
       
    --owa_util.print_cgi_env;

--    OWA_COOKIE.SEND('LOGON', u, null, c_path_info);
--    OWA_COOKIE.SEND('LOGONLOB', l, null, c_path_info);

--    OWA_COOKIE.SEND('LOGON', u, null, owa_util.get_cgi_env('SCRIPT_NAME') , owa_util.get_cgi_env('HTTP_HOST'));
--    OWA_COOKIE.SEND('LOGONLOB', u, null, owa_util.get_cgi_env('SCRIPT_NAME') , owa_util.get_cgi_env('HTTP_HOST'));

    OWA_COOKIE.SEND('LOGON', u, null, '/' , '');
    OWA_COOKIE.SEND('LOGONLOB', l, null, '/' , '');

    OWA_UTIL.REDIRECT_URL(C_starturl);
  exception
    when others then
      OWA_UTIL.REDIRECT_URL(C_login || '&message=' || sqlerrm);
  END;

end;
/

