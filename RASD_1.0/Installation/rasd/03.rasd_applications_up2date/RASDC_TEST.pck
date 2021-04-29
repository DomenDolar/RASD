create or replace package RASDC_TEST is
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
  function metadata return clob;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/
create or replace package body RASDC_TEST is
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

  type rtab is table of rowid index by binary_integer;
  type ntab is table of number index by binary_integer;
  type dtab is table of date index by binary_integer;
  type ctab is table of varchar2(4000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20201022 - Added Comment and UNComment RLOG option      
20200626 - Added custom functions in testing list      
20200410 - Added new compilation message      
20200211 - Added FORMAT_ERROR_BACKTRACE to compile block - based on generateing code.    
20200120 - Added Form navigation    
20150814 - Added superuser     
20150813 - Added debug mode
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20201022225530';

  end;

  function metadata return clob is
    v_clob clob := ' ';
  begin
    return v_clob;
  end;
  
  
function parse_procedure(p_form varchar2, p_spec clob) return clob is
   v_spec clob;
   v_proc varchar2(1000);
   v_procj varchar2(1000);
   v_pos number := 1;
   v_posj number := 1;
   v_ret clob;
   i number;
   j number;
begin
-- FIND PROCEDURE 
while instr(upper(p_spec), 'PROCEDURE', v_pos) > 0 loop
 v_pos := instr(upper(p_spec), 'PROCEDURE', v_pos);
 v_proc := substr(p_spec, v_pos , instr(p_spec, ';' , v_pos)-v_pos);
 v_pos := v_pos + 1;
--dbms_output.put_line (v_proc);
-- FLAT PROCEDURE TO ONE LINE 
v_proc := replace(v_proc , chr(13)||chr(10) ,'');
--dbms_output.put_line (v_proc);
-- PARSE PARAMETERS
if instr(v_proc , ')') = 0 then
   v_proc := p_form||'.'||replace(substr(v_proc, 10),' ','');
elsif instr(lower(v_proc) , 'owa.vc_arr') > 0 then 
   v_proc := '!'||p_form||'.'||replace(substr(v_proc , 10 , instr(v_proc,'(')-10 ),' ','');
else
   v_procj := replace(replace(v_proc, '(', ','),')',',');
   v_posj := 1;
   j := 0;
   v_proc := replace(substr(v_proc , 10 , instr(v_proc,'(')-10 ),' ','')||'?';
   while instr(v_procj,',',v_posj,2) > 0 loop
     v_posj := instr(v_procj,',',v_posj)+1;    
     v_proc := v_proc || trim(substr(trim(substr(v_procj, v_posj ,  instr(v_procj,',',v_posj) - v_posj)),1, instr( trim(substr(v_procj, v_posj ,  instr(v_procj,',',v_posj) - v_posj)) ,' ') )) ||'=&' ;
     if j > 100 then exit; else j :=  j + 1; end if;
   end loop;
   v_proc := p_form||'.'||substr(v_proc, 1 , length(v_proc)-1);
end if;
--dbms_output.put_line (v_proc);
--PREPARE OUTPUT TO tr

v_proc := '<tr><td></td><td>&nbsp;&nbsp;&nbsp;http://../'||v_proc||'</td><td>&nbsp;&nbsp;&nbsp;<a href="'||v_proc||'" target="_blank">Open</a></td></tr>';
v_ret := v_proc || v_ret;

  
 if i > 100 then exit; else i :=  i + 1; end if;
end loop;  

  
return v_ret;

end;  
  
  
procedure parse_code(pformid number, pform varchar2) is
begin
 for r in (select * from rasd_triggers 
where plsqlspec is not null
  and upper(plsqlspec) like '%PROCEDURE%'
  and formid = pformid
  )
 loop
 htp.p('<tr><td>Custom functions</td></tr>');
 htp.p(parse_procedure(pform, r.plsqlspec));
  
 end loop;

end;  
  
  
  
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    NSELECT      number := 0;
    PAGE         number := 0;
    GBUTTONRES   varchar2(4000) := 'Reset';
    GBUTTONSRC   varchar2(4000) := 'Submit';
    PFORMID      varchar2(4000);
    LANG         varchar2(4000);
    ACTION       varchar2(4000);
    SPOROCILO     varchar2(4000);
    B10TEXTAREA  ctab;
    B10BUFFER    ctab;
    B30RESULT    ctab;
    B30SPOROCILO ctab;
    
      v_form   varchar2(100);
      v_dummy  char(1);
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;

    
    
    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      -- submit fields
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('NSELECT') then
          NSELECT := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('PAGE') then
          PAGE := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONRES') then
          GBUTTONRES := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONSRC') then
          GBUTTONSRC := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10TEXTAREA_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10TEXTAREA(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10BUFFER_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10BUFFER(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30RESULT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30RESULT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30SPOROCILO_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30SPOROCILO(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      -- init fields
      v_max := 0;
      if B10TEXTAREA.count > v_max then
        v_max := B10TEXTAREA.count;
      end if;
      if B10BUFFER.count > v_max then
        v_max := B10BUFFER.count;
      end if;
      if v_max = 0 then
        v_max := 1;
      end if;
      for i__ in 1 .. v_max loop
        if not B10TEXTAREA.exists(i__) then
          B10TEXTAREA(i__) := null;
        end if;
        if not B10BUFFER.exists(i__) then
          B10BUFFER(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if B30RESULT.count > v_max then
        v_max := B30RESULT.count;
      end if;
      if B30SPOROCILO.count > v_max then
        v_max := B30SPOROCILO.count;
      end if;
      if v_max = 0 then
        v_max := 1;
      end if;
      for i__ in 1 .. v_max loop
        if not B30RESULT.exists(i__) then
          B30RESULT(i__) := null;
        end if;
        if not B30SPOROCILO.exists(i__) then
          B30SPOROCILO(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      --<POST_SUBMIT formid="8" blockid="">
    null;

      --</POST_SUBMIT>
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
        B10TEXTAREA(j__) := null;
        B10BUFFER(j__) := null;

      end loop;
    end;
    procedure pclear_B30(pstart number) is
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
        B30RESULT(j__) := null;
        B30SPOROCILO(j__) := null;

      end loop;
    end;
    procedure pclear_form is
    begin
      NSELECT    := 0;
      PAGE       := 0;
      GBUTTONRES := 'Reset';
      GBUTTONSRC := 'Submit';
      ACTION     := null;
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_B10(0);
      pclear_B30(0);
      null;
    end;
    procedure pselect_B10 is
      i__ pls_integer;
    begin
      pclear_B10(B10TEXTAREA.count);
      null;
    end;
    procedure pselect_B30 is
      i__ pls_integer;
    begin
      pclear_B30(B30RESULT.count);
      null;
    end;
    procedure pselect is
    begin
      if nvl(PAGE, 0) = 0 then
        pselect_B10;
      end if;
      if nvl(PAGE, 0) = 0 then
        pselect_B30;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. B10TEXTAREA.count loop
        --<on_validate formid="8" blockid="B10">
        --</on_validate>
        null;
      end loop;
      null;
    end;
    procedure pcommit_B30 is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. B30RESULT.count loop
        --<on_validate formid="8" blockid="B30">
        --</on_validate>
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="8" blockid="">
      --</pre_commit>
      if nvl(PAGE, 0) = 0 then
        pcommit_B10;
      end if;
      if nvl(PAGE, 0) = 0 then
        pcommit_B30;
      end if;
      --<post_commit formid="8" blockid="">
      --</post_commit>
      null;
    end;
    procedure poutput is
    vform varchar2(1000);
    vversion  varchar2(1000);

    begin
      htp.prn('<html>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<SCRIPT LANGUAGE="Javascript1.2">
 $(function() {
     addSpinner();   
  }); 
</SCRIPT>
</HEAD>
<body>
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_CSSJS_LAB">');
      RASDC_LIBRARY.showhead('RASDC_TEST',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                lang);

    select upper(form), version
      into vform, vversion
      from RASD_FORMS f
     where f.formid = PFORMID;


      htp.prn('</FONT>
<form name="RASDC_TEST" method="post" action="!RASDC_TEST.webclient">
<input name="PAGE" type="hidden" value="' || to_char(PAGE) || '">
<input id="ACTION" name="ACTION" type="hidden" value="' || ACTION || '">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || lang ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">

<P align="right">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Form navigator', lang) ||
              '" onclick="javascript: this.type=''reset''; var p_y1 = window.open(encodeURI(''!RASDC_EXECUTION.Program?LANG='||lang||'&PFORMID='||pformid||'''),''p_y1'',''width=800,height=400,resizable=1'');">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Debug', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Debug', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Comment RLOG', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Comment RLOG', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('UNComment RLOG', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('UNComment RLOG', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

');
end if;
htp.p('
</P>
');



      htp.p('
      </br>
            </br>
                  </br>
<P align="center">
<table border="0" id="B10_BLOCK">

<tr><td>HTML application</td><td>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.webclient</td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.webclient" target="_blank">Preview</A></td></tr>
<tr><td>REST application</td><td>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.rest?restrestype=JSON</td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.rest?restrestype=JSON" target="_blank">JSON response</A></td></tr>
<tr><td></td><td>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.rest?restrestype=XML</td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.rest?restrestype=XML" target="_blank">XML response</A></td></tr>
<tr><td>BATCH application</td><td>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.main</td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.main" target="_blank">Open</A></td></tr>
<tr><td>LOV''s</td></tr>');
for r in (select linkid, link from rasd_links where type in ('C','S','T') and formid = PFORMID) loop
htp.p('<tr><td></td><td><small>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.openLOV?PLOV='||r.linkid||'&PID=&FIN=</small></td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.openLOV?PLOV='||r.linkid||'&PID=&FIN=" target="_blank">Open '||r.link||' HTML</A></td></tr>');
htp.p('<tr><td></td><td><small>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.openLOV?PLOV='||r.linkid||'&PID=&call=REST&restrestype=JSON</small></td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.openLOV?PLOV='||r.linkid||'&call=REST&restrestype=JSON&PID=&FIN=" target="_blank">Open '||r.link||' REST (JSON response)</A></td></tr>');
htp.p('<tr><td></td><td><small>&nbsp;&nbsp;&nbsp;http://../!'||vform||'.openLOV?PLOV='||r.linkid||'&PID=&call=REST&restrestype=XML</small></td><td>&nbsp;&nbsp;&nbsp;<A href="!'||vform||'.openLOV?PLOV='||r.linkid||'&call=REST&restrestype=XML&PID=&FIN=" target="_blank">Open '||r.link||' REST (XML response)</A></td></tr>');
end loop;

parse_code( pformid, vform);

htp.p('</table>
</P>
');

      htp.prn('

<table width="100%" border="0"><tr>
');
      if SPOROCILO is not null then
        htp.prn('
<td width="1%" class="sporociloh" nowrap><FONT COLOR="green" size="4">' ||
                RASDI_TRNSLT.text('Message', lang) ||
                ': </FONT></td>
<td class="sporocilom">' ||
                RASDI_TRNSLT.text(sporocilo, lang) || '</td>
');
      end if;
      htp.prn('
<td  align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Debug', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Debug', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Comment RLOG', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Comment RLOG', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">

<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('UNComment RLOG', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('UNComment RLOG', lang) ||
              '''; document.RASDC_TEST.submit(); this.disabled = true; ">
              
');
end if;
htp.p('
</td>
</tr>
</table>

</form>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</body>
</html>
    ');

      null;
    end;

    begin
      
    psubmit;
  
       select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;
 
    
    RASDC_LIBRARY.checkprivileges(PFORMID);

    if 1 = 2 then
      null;
    elsif ACTION = GBUTTONSRC then
      pselect;
      poutput;
    elsif ACTION = RASDI_TRNSLT.text('Comment RLOG', lang) then
      for r in (
      select t.plsql, t.rowid rid from rasd_triggers t where t.formid = PFORMID
      and instr(t.plsql , 'rlog(') > 0
      ) loop
      
        update rasd_triggers x set x.plsql = replace(x.plsql, 'rlog(','--rlog(')
        where rowid = r.rid and  x.formid = PFORMID;     
        
        sporocilo := RASDI_TRNSLT.text('In triggers where rlog is, it is commented to --rlog.', lang);
      end loop;
      
      pselect;
      poutput;
    elsif ACTION = RASDI_TRNSLT.text('UNComment RLOG', lang) then
      for r in (
      select t.plsql, t.rowid rid from rasd_triggers t where t.formid = PFORMID
      and instr(t.plsql , '--rlog(') > 0
      ) loop
      
        update rasd_triggers x set x.plsql = replace(x.plsql, '--rlog(','rlog(')
        where rowid = r.rid and  x.formid = PFORMID;     
        
        sporocilo := RASDI_TRNSLT.text('In triggers where commented --rlog is, it is uncommented to rlog.', lang);
      end loop;
      pselect;
      poutput;
    elsif ACTION =  RASDI_TRNSLT.text('Compile', lang) or  ACTION =  RASDI_TRNSLT.text('Debug', lang) then
      pselect;
        declare
          v_debug varchar2(100) := 'false';
        begin
          
         if ACTION =  RASDI_TRNSLT.text('Debug', lang) 
         then
           v_debug := 'true';         
         end if;        
        
          if v_form in ('RASDC_BLOCKSONFORM',
                        'RASDC_FIELDSONBLOCK',
                        'RASDC_TRIGGERS',
                        'RASDC_LINKS',
                        'RASDC_PAGES',
                        'F_FORME',
                        'RASDC_FORMS') then
            v_dummy   := '5';
            sporocilo := RASDI_TRNSLT.text('From is not generated.', lang);    
          else
            v_dummy := '6';
            select server
              into v_server
              from RASD_FORMS_COMPILED fg, RASD_ENGINES g
             where fg.engineid = g.engineid
               and fg.formid = PFORMID
               and fg.editor = rasdi_client.secGetUsername
               and (fg.lobid = rasdi_client.secGetLOB or
                   fg.lobid is null and rasdi_client.secGetLOB is null);
            v_dummy := '7';
            cid     := dbms_sql.open_cursor;
            v_dummy := '8';
            dbms_sql.parse(cid,
                           'begin ' || v_server || '.c_debug := '||v_debug||';'|| v_server || '.form(' || PFORMID ||
                           ',''' || lang || ''');end;',
                           dbms_sql.native);
            v_dummy := '9';
            n       := dbms_sql.execute(cid);
            v_dummy := 'A';
            dbms_sql.close_cursor(cid);
            v_dummy   := 'B';
            if v_debug = 'true' then
            sporocilo := RASDI_TRNSLT.text('Program is generated in debug mode.', lang);                
            else  
            sporocilo := RASDI_TRNSLT.text('From is generated.', lang);    
            end if;
          end if;
        exception 
          when others then
           if sqlcode = -24344 then
              
            sporocilo := RASDI_TRNSLT.text('Form is generated with compilation error. Check your code.', lang)||'('||sqlerrm||')';
             
            else
            sporocilo := RASDI_TRNSLT.text('Form is NOT generated - internal RASD error.', lang) || '('||replace(sqlerrm||' : '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,'
','<br>')||')<br>'||
                         RASDI_TRNSLT.text('To debug run: ', lang) || 'begin ' || v_server || '.form(' || PFORMID ||
                         ',''' || lang || ''');end;' ;
            end if;             
          

        end;
              poutput;
    end if;


    if ACTION is null or ACTION not in ( RASDI_TRNSLT.text('UNComment RLOG', lang), RASDI_TRNSLT.text('Comment RLOG', lang), GBUTTONSRC, RASDI_TRNSLT.text('Compile', lang), RASDI_TRNSLT.text('Debug', lang)) then

      pselect;
      poutput;

    end if;

  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.prn('<html><head>
<meta http-equiv="content-type" content="text/html; charset=WINDOWS-1250">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="-1"><meta name="DESCRIPTION" content="description of the site"><meta name="KEYWORDS" content="keywords of the site">
<title></title>
'||RASDC_LIBRARY.RASD_UI_Libs||'
</head><body><div class="htmlerror"><div class="htmlerrorcode">' ||
              sqlcode || '</div><div class="htmlerrortext">' || sqlerrm ||
              '</div></body><html>
    ');
  end;
end RASDC_TEST;
/
