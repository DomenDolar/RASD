create or replace package RASDC_SQL is
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

  function get_sqltext(PFORMID  RASD_FORMS.formid%type,
                       pblockid RASD_BLOCKS.blockid%type) return varchar2;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/

create or replace package body RASDC_SQL is
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
  type ctab is table of varchar2(32000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20160627 - Included reference form future.     
20160310 - Included CodeMirror     
20150928 - Fixed issues on SQL compiler    
20150921 - Fixed bug in SQL checker    
20150814 - Added superuser     
20141028 - Solved problem when string of table name was in dad username 
*/';
    return 'v.1.1.20160627225530';

  end;


  function get_sqltext(PFORMID  RASD_FORMS.formid%type,
                       pblockid RASD_BLOCKS.blockid%type) return varchar2 is

    v_sqltable RASD_BLOCKS.sqltable%type;
    v_sqltext  varchar(32000);

    function create_variables(PFORMID  number,
                           pblockid varchar2) return varchar2 is
      v_plsql RASD_TRIGGERS.plsql%type;
      l       pls_integer;
      n       pls_integer;
    begin
      v_plsql := '';
        for rp in (select length(p.blockid || p.fieldid) dolzina,
                          p.fieldid,
                          p.blockid,
                          upper(p.blockid || p.fieldid) nameid,
                          type
                     from RASD_FIELDS p
                    where p.formid = PFORMID
                    order by dolzina desc) loop
                    
          if rp.type = 'N' then
            v_plsql := v_plsql||' '||rp.nameid||' number := 1;
';
          elsif rp.type = 'D' then
            v_plsql := v_plsql||' '||rp.nameid||' date := to_date(null);
';
          elsif rp.type = 'R' then
            v_plsql := v_plsql||' '||rp.nameid||' varchar2(1) := ''X'';
';
          else
            v_plsql := v_plsql||' '||rp.nameid||' varchar2(1) := ''X'';
';
          end if;
        end loop;
      return v_plsql;
    end;

    function get_Select return varchar2 is
      v_polja RASD_BLOCKS.sqltext%type;
    begin
      for r in (select fieldid,
                       blockid,
                       formid,
                       type,
                       orderby,
                       format,
                       pkyn,
                       selectyn,
                       insertyn,
                       updateyn,
                       deleteyn,
                       insertnnyn,
                       notnullyn,
                       lockyn,
                       defaultval,
                       elementyn,
                       label,
                       element,
                       linkid,
                       decode(upper(type),
                              'N',
                              'ntab',
                              'C',
                              'ctab',
                              'D',
                              'dtab',
                              'R',
                              'rtab') typei,
                       blockid || fieldid || '(i__)' poljei
                  from RASD_FIELDS p
                 where p.formid = PFORMID
                   and (p.blockid = pblockid)
                 order by p.orderby) loop
        if r.selectyn = 'Y' then
          if r.type = 'R' then
            v_polja := v_polja || ',
 ROWID ' || r.fieldid;
          else
            v_polja := v_polja || ',
' || r.fieldid;
          end if;
        end if;
      end loop;
      return substr(v_polja, 2);
    end;

  begin
    select sqltable, sqltext
      into v_sqltable, v_sqltext
      from RASD_BLOCKS
     where blockid = pblockid
       AND formid = PFORMID;
    if instr(upper(ltrim(v_sqltext)), 'SELECT') = 1 then

     
      for r in (select t.table_name x
                  from all_tables t
                 where t.owner = rasdc_library.currentDADUser
                 order by table_name desc) loop
               
        v_sqltext := replace(upper(v_sqltext),
                             ' ' || r.x ||' ',
                             ' ' || rasdc_library.currentDADUser || '.' || r.x || ' ');
        v_sqltext := replace(upper(v_sqltext),
                             ',' || r.x ||' ',
                             ',' || rasdc_library.currentDADUser || '.' || r.x|| ' ');
        v_sqltext := replace(upper(v_sqltext),
                             ' ' || r.x ||',',
                             ' ' || rasdc_library.currentDADUser || '.' || r.x || ',');
        v_sqltext := replace(upper(v_sqltext),
                             ',' || r.x ||',',
                             ',' || rasdc_library.currentDADUser || '.' || r.x|| ',');
      end loop;

      v_sqltext := 'declare 
 ci1__ number;
'||create_variables(PFORMID, pblockid)||' begin 
select count(1) into ci1__ from ('||replace(replace(upper(v_sqltext), '(1)', ''), '(I__)', '')||');
end;';      

      return v_sqltext;
    elsif instr(upper(ltrim(v_sqltext)), 'FROM') = 1 then
      v_sqltext := 'SELECT ' || get_select || ' ' ||v_sqltext;
      for r in (select t.table_name x
                  from all_tables t
                 where t.owner = rasdc_library.currentDADUser
                 order by table_name desc) loop

        v_sqltext := replace(upper(v_sqltext),
                             ' ' || r.x ||' ',
                             ' ' || rasdc_library.currentDADUser || '.' || r.x || ' ');
        v_sqltext := replace(upper(v_sqltext),
                             ',' || r.x ||' ',
                             ',' || rasdc_library.currentDADUser || '.' || r.x|| ' ');
        v_sqltext := replace(upper(v_sqltext),
                             ' ' || r.x ||',',
                             ' ' || rasdc_library.currentDADUser || '.' || r.x || ',');
        v_sqltext := replace(upper(v_sqltext),
                             ',' || r.x ||',',
                             ',' || rasdc_library.currentDADUser || '.' || r.x|| ',');               
                                       
      end loop;

      v_sqltext := 'declare 
 ci1__ number;
'||create_variables(PFORMID, pblockid)||' begin 
select count(1) into ci1__ from ('||replace(replace(upper(v_sqltext), '(1)', ''), '(I__)', '')||');
end;';      
      return v_sqltext;
    else
      if instr(v_sqltable,'.') > 0 then
      v_sqltext := 'SELECT ' || get_select || ' FROM ' ||
                   v_sqltable || ' ' ||
                   v_sqltext;
      else  
      v_sqltext := 'SELECT ' || get_select || ' FROM ' ||
                   rasdc_library.currentDADUser || '.' || v_sqltable || ' ' ||
                   v_sqltext;
      end if;             
      
      v_sqltext := 'declare 
 ci1__ number;
'||create_variables(PFORMID, pblockid)||' begin 
select count(1) into ci1__ from ('||replace(replace(upper(v_sqltext), '(1)', ''), '(I__)', '')||');
end;';            
      return v_sqltext;
    end if;
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
    B10sqltext ctab;
    B10source  ctab;
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
        elsif upper(name_array(i__)) =
              upper('B10sqltext_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10sqltext(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10rid.count > v_max then
        v_max := B10rid.count;
      end if;
      if B10sqltext.count > v_max then
        v_max := B10sqltext.count;
      end if;
      if B10source.count > v_max then
        v_max := B10source.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10rid.exists(i__) then
          B10rid(i__) := null;
        end if;
        if not B10sqltext.exists(i__) then
          B10sqltext(i__) := null;
        end if;
        if not B10source.exists(i__) then
          B10source(i__) := null;
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
        B10sqltext(j__) := null;
        B10source(j__) := null;
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
      B10RS.delete;
      B10rid.delete;
      B10sqltext.delete;
      B10source.delete;
      B10rform.delete;
      --<pre_select formid="101" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="101" blockid="B10">
          SELECT ROWID rid, sqltext, rform
            FROM RASD_BLOCKS
           where formid = PFORMID
             and blockid = pblockid

          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10rid(i__), B10sqltext(i__), b10rform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10source(i__) := null;
            B10RS(i__) := 'U';
            --<post_select formid="101" blockid="B10">
            --</post_select>
            i__ := i__ + 1;
          end if;


        END LOOP;
        if c__%rowcount < 1 then
          B10RS.delete(1);
          B10rid.delete(1);
          B10sqltext.delete(1);
          B10rform.delete(1);
          B10source.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10rid.count);
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
      for i__ in 1 .. B10RS.count loop
        --<on_validate formid="101" blockid="B10">
        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          null;
        else
          -- UPDATE ali DELETE;

          --<pre_update formid="101" blockid="B10">
          --</pre_update>
          update RASD_BLOCKS
             set sqltext = B10sqltext(i__), source = B10source(i__)
           where ROWID = B10rid(i__) and rform is null;
          --<post_update formid="101" blockid="B10">
          --</post_update>
          null;
        end if;
        null;
      end loop;
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
'||RASDC_LIBRARY.RASD_UI_Libs||'

<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTA(document.RASDC_SQL.B10sqltext_1);
}
function onLoad() {
  onResize();
}
</SCRIPT>
</HEAD>');
htp.p('<BODY  onload="onLoad();" onresize="onResize();">
<DIV class="hint">
<FONT ID="RASDC_SQL_LAB"></FONT>
<FORM NAME="RASDC_SQL" METHOD="post" ACTION="!rasdc_sql.program">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<INPUT NAME="Pblockid" TYPE="HIDDEN" VALUE="' || Pblockid ||
              '" CLASS="HIDDEN">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<P align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT NAME="ACTION" TYPE="submit" CLASS="SUBMIT" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '">
');
end if;
htp.prn('
</P>
<TABLE BORDER="1" width="100%" style="');

              if b10rform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;
htp.prn('">
<CAPTION>
</CAPTION> <TR>
<TD> <FONT ID="B10sqltext_LAB"> </FONT> </TD> </TR> <TR ID="B10_BLOK"> <INPUT NAME="B10RS_1" TYPE="hidden" VALUE="' ||
              B10RS(1) ||
              '" CLASS="HIDDEN"> <INPUT NAME="B10RID_1" TYPE="hidden" VALUE="' ||
              B10rid(1) ||
              '" CLASS="HIDDEN">
<TD><TEXTAREA class="TEXTAREA" id="B10sqltext_1" name="B10sqltext_1" title="' ||
              RASDI_TRNSLT.text('SQL text', lang) ||
              '" style="FONT-SIZE: 8pt; font-face: Lucida Console;');
              htp.prn('" rows="10" cols="60">' ||
              B10sqltext(1) || '</TEXTAREA> </TD> </TR> </TABLE>
              
 <script>
window.onload = function() {
  var mime = ''text/x-sql'';
  // get mime type
  if (window.location.href.indexOf(''mime='') > -1) {
    mime = window.location.href.substr(window.location.href.indexOf(''mime='') + 5);
  }
  window.editor = CodeMirror.fromTextArea(document.getElementById(''B10sqltext_1''), {
    mode: mime,
    indentWithTabs: true,
    smartIndent: true,
    lineNumbers: true,
    matchBrackets : true,
    autofocus: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    hintOptions: {tables: {
      __RASD_TABLES: {},
');
      for r__ in (
                  select /*+ RULE*/ OBJECT_NAME id,
                          OBJECT_NAME || ' ... ' || substr(object_type, 1, 1) label,
                          2 x, o.owner
                    from all_objects o
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select /*+ RULE*/ distinct SYNONYM_NAME id,
                                   SYNONYM_NAME || ' ... S' label,
                                   2 x, s.table_owner
                    from user_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     --and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id,
                          owner||'.'||table_name  /*|| ' ... ' || substr(type, 1, 1)*/ label, 2 x, x.owner
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and 
                    grantee = rasdc_library.currentDADUser 
                    and 1=2 
                   order by 3, 1
                  ) loop
htp.p('      '||r__.id||': {');  
          for r1 in (select * from all_tab_columns t where t.table_name = r__.id and t.owner = r__.owner) loop
htp.p(r1.column_name||' :{}, ');            
          end loop;  
          htp.p('null :{} },');
      end loop;
htp.p('      
      __RASD_VARIABLES: {},
');      
for r in (  SELECT blockid, fieldid, blockid||fieldid polje
            FROM RASD_FIELDS
           where formid = PFORMID
           order by nvl(blockid,'.'), fieldid) loop
htp.p('      '||r.polje||': {},');          
end loop;
htp.p('
      __OTHER_FUNCTIONS: {}      
    }}
  });
  window.editor.setSize("100%","180");
};
</script>
             
              
              
              
<table width="100%" border="0"><tr>
');
      if sporocilo is not null then
        htp.prn('
<td width="1%" class="sporociloh" nowrap><FONT COLOR="green" size="4">' ||
                RASDI_TRNSLT.text('Message', lang) ||
                ': </FONT></td>
<td class="sporocilom">' ||
               RASDI_TRNSLT.text( substr(sporocilo,1,1000), lang) || 
                '</td>');
      end if;
      htp.prn('
<td  align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT NAME="ACTION" TYPE="submit" CLASS="SUBMIT" value="' ||
              RASDI_TRNSLT.text('Save', lang) || '">
');
end if;
htp.p('
</td>
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
      rasdi_client.secCheckPermission('RASDC_SQL', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        commit;
        sporocilo := 'Changes are saved.';
        pselect;
        declare
          c0 number := 0;
        begin
          
          execute immediate get_sqltext(PFORMID, pblockid);
          
        exception
          when no_data_found then
            null;
          when others then
            sporocilo := sqlerrm || '</BR>' ;
        end;
        
        phtml;
        
      elsif action = RASDI_TRNSLT.text('Search', lang) then
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
end RASDC_SQL;
/

