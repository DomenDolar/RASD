create or replace package RASDC_GIT is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2020       http://rasd.sourceforge.net                 |
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
  function getGitLocation return varchar2;
  procedure push2git(message varchar2, gttkn varchar2, frmcode varchar2);

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/
create or replace package body RASDC_GIT is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2020       http://rasd.sourceforge.net                 |
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

  type rtab is table of rowid index by binary_integer;
  type ntab is table of number index by binary_integer;
  type dtab is table of date index by binary_integer;
  type ctab is table of varchar2(32000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20200926 - First version (XML not implemented yet - privs problem
*/';
    return 'v.1.1.20200926225530';

  end;

  function getGitLocation return varchar2 is
  v varchar2(32000);
begin
    EXECUTE IMMEDIATE 'begin :v := dd_plsql2gitlab.p_gitlab_url; end;' using out v; 
    return v;
exception when others then
    return '';
end;      

  procedure push2git(message varchar2, gttkn varchar2, frmcode varchar2) is 
    v varchar2(32000);
    s varchar2(32000);
  begin

   OWA_UTIL.mime_header('application/json', FALSE, 'UTF-8'); 
--  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob_content));
--  HTP.p('Content-Disposition: filename="dwnld_'||file||'"');
   OWA_UTIL.http_header_close;
   
--    EXECUTE IMMEDIATE 'begin    
--    :1 := dd_plsql2gitlab.sendPackage2Git( :2, :3 , :4 ,:5, :6 , :7);    
--    end;'
--    into v 
 --   using frmcode, rasdi_client.secGetUsername, rasdi_client.secGetUsername,rasdi_client.secGetUsername, message , gttkn;
    s := 'declare v varchar2(32000); x clob := ''1''; begin begin    
    v := dd_plsql2gitlab.sendPackage2Git( '''||frmcode||''', '''||substr(lower(frmcode),1,4)||''', '''||user||''' , '''||rasdi_client.secGetUsername||''' ,'''||rasdi_client.secGetUsername||''', '''||message||''' , '''||gttkn||''');    
    --x := '||user||'.'||frmcode||'.metadata;  -- privileges problem have to find solution !!!
    --v := v || dd_plsql2gitlab.sendCustom2Git( '''||frmcode||''', '''||substr(lower(frmcode),1,4)||''', x , ''src/main/'','''||frmcode||'.xml'', '''||rasdi_client.secGetUsername||''' ,'''||rasdi_client.secGetUsername||''', '''||message||''' , '''||gttkn||''');    
    exception when others then v := sqlerrm||'' (schema: '||user||' , RASD user: '||rasdi_client.secGetUsername||' ) Error stack:''||DBMS_UTILITY.FORMAT_ERROR_STACK; end;
    :v := v;   
   end;';
    EXECUTE IMMEDIATE s using out v;
/*
begin    
    v := dd_plsql2gitlab.sendPackage2Git( frmcode, rasdi_client.secGetUsername , rasdi_client.secGetUsername ,rasdi_client.secGetUsername, message , gttkn);    
    exception when others then v := sqlerrm;   
       v:= sqlerrm||' Error stack:'||DBMS_UTILITY.FORMAT_ERROR_STACK;
    end;
*/
    htp.p(v);
    --htp.p('{'||message||' user '||rasdi_client.secGetUsername||'}');

--declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); 
--begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));
--htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| 
--replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); 
--htp.p('</div>');rlog('ERROR:...'); 
--declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'DEMO_FIELDS' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;
    
    
  
  end;
  

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    GBUTTON1   varchar2(4000) := 'Search';
    GBUTTON2   varchar2(4000) := 'Reset';
    GBUTTON3   varchar2(4000) := 'Save';
    PFORMID    number;
    Pblockid   varchar2(4000);
    LANG       varchar2(4000);
    ACTION     varchar2(4000);
    SPOROCILO  varchar2(32500);
    B10RS      ctab;
    B10rid     rtab;
    B10rform   ctab;

    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('GBUTTON1') then
          GBUTTON1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON2') then
          GBUTTON2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON3') then
          GBUTTON3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('Pblockid') then
          Pblockid := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('') then
          SPOROCILO := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10rid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        end if;
      end loop;
      v_max := 0;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10rid.count > v_max then
        v_max := B10rid.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10rid.exists(i__) then
          B10rid(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      null;
    end;
    procedure psubmit is
    begin
      on_submit;
      post_submit;
    end;
    procedure pclear_B10(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 1 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 1 then
          k__ := i__ + 0;
        else
          k__ := 0 + 1;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B10RS(j__) := null;
        B10rid(j__) := null;
        b10rform(j__) := null;
      end loop;
    end;
    procedure pclear_form is
    begin
      GBUTTON1  := 'Search';
      GBUTTON2  := 'Reset';
      GBUTTON3  := 'Save';
      PFORMID   := null;
      Pblockid  := null;
      LANG      := null;
      ACTION    := null;
      SPOROCILO := null;
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_B10(0);
      null;
    end;
    procedure pselect_B10 is
      i__ pls_integer;
    begin
      select f.form into B10rform(1) 
      from rasd_forms f
      where f.formid = pformid;
    exception when others then  
      null;
    end;
    procedure pselect is
    begin
      if 1 = 1 then
        pselect_B10;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_zaklepanje varchar2(4000);
    begin
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="101" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
      end if;
      --<post_commit formid="101" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
      --povezavein
      --SQL
      --TEXT
      --TF
      --SQL-T
    begin
      --js povezavein
      --js SQL
      --js TEXT
      --js TF
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">  <META HTTP-EQUIV="Expires" CONTENT="-1">
<title>'||rasdi_trnslt.text('Push 2 GIT','LANG')||'</title>
'||RASDC_LIBRARY.RASD_UI_Libs||'

<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTA(document.RASDC_GIT.B10sqltext_1);
}
function onLoad() {
  onResize();
}
</SCRIPT>
</HEAD>');
htp.p('<BODY  onload="onLoad();" onresize="onResize();">
<DIV class="hint">
<FONT ID="RASDC_GIT_LAB">');

htp.p('<p>&nbsp;&nbsp;<font size="5" color="white">'||rasdi_trnslt.text('Push 2 GIT','LANG')||'</font></p>');

htp.p('</FONT>
<FORM NAME="RASDC_GIT" METHOD="post" ACTION="!rasdc_git.program">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<INPUT NAME="Pblockid" TYPE="HIDDEN" VALUE="' || Pblockid ||
              '" CLASS="HIDDEN">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>              
<P align="right">
');

if rasdc_library.allowEditing(pformid) then
htp.p('
');
end if;


htp.prn('
</P>');

htp.p('<div id="gitfirst" >');
htp.p(replace(rasdi_trnslt.text(
'<p>To PUSH your code to GIT you have to set your GITLAB Access Tokens, request for ACL access and request for group access.</p>
<p>To get Access Token you have to go to GITLAB <a href="<%=getGitLocation%>" target="_blank"><%=getGitLocation%></a>. Go to your profile (upper right) -> Settings -> Access Tokens. 
Name your token, check scope API and create it. Then copy it to field below and Save it.
The token is coded and stored on your local browser storage. If you would like to push code to gitlab on others browsers or computers you have to do that on that enviorments.</p>
<p>Request for ACL access send to your DBA (your DB account is "'||user||'")</p>
<p>Request for accesing project group "'||lower(substr(B10rform(1),1,4))||'" create in GITLAB on the group.</p>
'
,lang),'<%=getGitLocation%>',getGitLocation));

htp.p('<TABLE BORDER="0" width="100%" style="">');
htp.prn(' 
<TR ID="B10_BLOK"> 
<TD> <FONT ID="B10sqltext_LAB">'||rasdi_trnslt.text('Token:',lang)||' </FONT> </TD> 
<TD>
<input type="text" name="gttkn" id="gttkn" />
<INPUT NAME="ACTION" TYPE="button" CLASS="SUBMIT" onclick="setGtTkn();" value="' ||
              RASDI_TRNSLT.text('Save', lang) || '">
</TD> </TR> </TABLE>

</div>');

htp.p('<div id="gittknadded">');
htp.p(replace(rasdi_trnslt.text(
'<p>Your token for GITLAB <a href="<%=getGitLocation%>" target="_blank"><%=getGitLocation%></a> is set.</p>'
,lang),'<%=getGitLocation%>',getGitLocation));

htp.p('<TABLE BORDER="0" width="100%" style="">');
htp.prn(' 
<TR ID="B10_BLOK"> 
<TD> <FONT ID="B10sqltext_LAB">'||rasdi_trnslt.text('Message:',lang)||' </FONT> </TD> 
<TD>
<input type="text" name="dtmessage" id="dtmessage" value="'||rasdi_trnslt.text('Your commit message.',lang)||'" />');

if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT NAME="ACTION" TYPE="button" CLASS="SUBMIT" onclick="push2git();" value="' ||
              RASDI_TRNSLT.text('Push to GIT', lang) || '">
');
end if;
htp.p('</TD> </TR> </TABLE>
</div>


 <script>

  
  function setGtTkn(){
          var x = document.getElementById("gitfirst");
          var y = document.getElementById("gittknadded");    
          localStorage.setItem(''rasdgttkn'', btoa(document.getElementById("gttkn").value));
          x.style.display = "none";
          y.style.display = "block";
    }
  
  function push2git(){
          var x = document.getElementById("gitfirst");
          var y = document.getElementById("gittknadded");    
          var s = document.getElementById("rsporocilom");                   
          var m = document.getElementById("dtmessage");
          var lsgttkn = localStorage.getItem(''rasdgttkn'');
          //PUSH
          s.innerHTML = ''Sending to GIT ...'';
          $(''#rasdSpinner'').show();
  $.getJSON( ''RASDC_GIT.push2git?message=''+m.value+''&gttkn=''+lsgttkn+''&frmcode='||B10rform(1)||''' )
   .always(function( data ) {
       s.innerHTML = JSON.stringify(data);
       $(''#rasdSpinner'').hide();   
    });           
          x.style.display = "none";
          y.style.display = "none";
          
    } 
 
window.onload = function() {
  var mime = ''text/x-sql'';
  // get mime type
  if (window.location.href.indexOf(''mime='') > -1) {
    mime = window.location.href.substr(window.location.href.indexOf(''mime='') + 5);
  }
  
  var x = document.getElementById("gitfirst");
  var y = document.getElementById("gittknadded");
  x.style.display = "none";
  y.style.display = "none";
  
  var lsgttkn = localStorage.getItem(''rasdgttkn'');
  if (lsgttkn == null) {x.style.display = "block";} 
  else {y.style.display = "block";}
  
  
};
</script>

');

htp.p('
<table width="100%" border="0"><tr>
');
--      if sporocilo is not null then
        htp.prn('
<td class="sporocilom"><div id="rsporocilom">' ||
               RASDI_TRNSLT.text( substr(sporocilo,1,1000), lang) ||
                '</div></td>');
  --    end if;
      htp.prn('
');
if rasdc_library.allowEditing(pformid) then
htp.p('
');
end if;
htp.p('
</tr>
</table>
 </FORM>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT> </BODY> </HTML>
    ');

    exception
      when others then
        htp.p('<font color="red">' ||
              replace(replace(sqlerrm,
                              '
',
                              '\n'),
                      '"',
                      '\"') || '</font>');
        htp.p('<script language="JavaScript">');
        htp.p('<!--');
        htp.p('  alert("' || replace(replace(sqlerrm,
                                             '
',
                                             '\n'),
                                     '"',
                                     '\"') || '");');
        htp.p('history.go(-1);');
        htp.p('// -->');
        htp.p('</script>');

        null;
    end;
  begin
    --<ON_ACTION formid="101" blockid="">
    declare
      vup    varchar2(30) := rasdi_client.secGetUsername;
      v_form varchar2(100);
    begin
      rasdi_client.secCheckPermission('RASDC_GIT', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        commit;
        sporocilo := 'Changes are saved.';
        pselect;

        phtml;

      else 
        pselect;
              
        phtml;
      end if;
    end;
    --</ON_ACTION>
  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.p('<script language="JavaScript">');
      htp.p('<!--');
      htp.p('  alert("' || replace(replace(sqlerrm,
                                           '
',
                                           '\n'),
                                   '"',
                                   '\"') || '");');
      htp.p('history.go(-1);');
      htp.p('// -->');
      htp.p('</script>');

  end;
end ;
/
