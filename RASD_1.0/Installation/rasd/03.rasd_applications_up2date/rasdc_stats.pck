create or replace package rasdc_stats is
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

create or replace package body RASDC_STATS is
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
20200203 - Added statistic for visits    
20151228 - New version
*/';
    return 'v.1.1.20200203225530';

  end;

  function metadata return clob is
    v_clob clob := ' ';
  begin
    return v_clob;
  end;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    NSELECT      number := 0;
    PAGE         number := 0;
    GBUTTONRES   varchar2(4000) := 'Reset';
    GBUTTONSRC   varchar2(4000) := 'Submit';
    PFORMID      varchar2(4000);
    LANG         varchar2(4000);
    ACTION       varchar2(4000);
    B10TEXTAREA  ctab;
    B10BUFFER    ctab;
    B30RESULT    ctab;
    B30SPOROCILO ctab;
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
      if b10textarea(1) is not null then
        declare
          cid     pls_integer;
          n       pls_integer;
          ninsert number;
          ndelete number;
          nupdate number;
        begin
          if instr(upper(b10textarea(1)), 'DESCR') = 1 then
            b10textarea(1) := 'select column_name, data_type,data_length, decode(nullable,''N'',''NOT NULL'','''')
      from user_tab_cols t
      where table_name = ''' ||
                              upper(ltrim(rtrim(substr(b10textarea(1), 6)))) || '''';
          end if;
          cid := dbms_sql.open_cursor;
          dbms_sql.parse(cid, b10textarea(1), dbms_sql.native);
          n := dbms_sql.execute(cid);
          if n >= 0 then
            nselect := instr(upper(b10textarea(1)), 'SELECT');
            ninsert := instr(upper(b10textarea(1)), 'INSERT');
            nupdate := instr(upper(b10textarea(1)), 'UPDATE');
            ndelete := instr(upper(b10textarea(1)), 'DELETE');
            if nselect = 1 then
              -- PLSQL CODE run on UI
              b30sporocilo(1) := 'Only first 100 rows are shown.';
            elsif ninsert = 1 then
              b30sporocilo(1) := '' || n || ' rows were inserted.';
            elsif ndelete = 1 then
              b30sporocilo(1) := '' || n || ' rows were deleted.';
            elsif nupdate = 1 then
              b30sporocilo(1) := '' || n || ' rows were updated.';
            end if;
          end if;
          b10buffer(1) := b10textarea(1) || '
;
' || b10buffer(1);

        exception
          when others then
            b30sporocilo(1) := '<FONT color=red>' || sqlerrm || '</FONT>';
        end;
      end if;

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
    begin
      htp.prn('<html>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
</HEAD>
<body>
<FONT ID="RASDC_FORMS_LAB">');
      RASDC_LIBRARY.showphead(RASDI_TRNSLT.text('Statistics', lang),
                                 '<li> <a href="!rasdc_forms.program?LANG='||lang||'" ><span>'||RASDI_TRNSLT.text('List of forms',lang)||'</span></a></li><li> <a href="!rasdc_versions.webclient?LANG='||lang||'" ><span>'||RASDI_TRNSLT.text('Versions',lang)||'</span></a></li><li> <a href="!rasdc_stats.webclient?LANG='||lang||'" class="active"><span>'||RASDI_TRNSLT.text('Statistics',lang)||'</span></a></li>',
                                 rasdi_client.secGetUsername,
                                 LANG,
                                 'RASDC_FORMSpomoc');
      htp.prn('</FONT>
<form name="" method="post" action="!rasdc_sqlclient.webclient" style="display: flow-root;">
<input name="PAGE" type="hidden" value="' || to_char(PAGE) || '">
<input name="ACTION" type="hidden" value="' || ACTION || '">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || lang ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID || '" CLASS="HIDDEN">
<P align="right">
</P>
<P align="center">
<table>
');
      /*
      SQL

      select 'htp.p(''<tr><td>'||object_name||'</td><td>''||'||object_name||'.version(x)); htp.p(''</td><td title="''||x||''">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>''); ' from all_objects where object_type = 'PACKAGE' and owner = 'GENUTLDEV'
      order by object_name

      */
      /*
      declare
        x varchar2(4000);
      begin
        htp.p('<tr><td>RASDC_ATTRIBUTES</td><td>' ||
              RASDC_ATTRIBUTES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_BLOCKSONFORM</td><td>' ||
              RASDC_BLOCKSONFORM.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_CSSJS</td><td>' || RASDC_CSSJS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_ERRORS</td><td>' || RASDC_ERRORS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FIELDSONBLOCK</td><td>' ||
              RASDC_FIELDSONBLOCK.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FILES</td><td>' || RASDC_FILES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FORMS</td><td>' || RASDC_FORMS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_HINTS</td><td>' || RASDC_HINTS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_HTML</td><td>' || RASDC_HTML.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_LIBRARY</td><td>' || RASDC_LIBRARY.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_LINKS</td><td>' || RASDC_LINKS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_PAGES</td><td>' || RASDC_PAGES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_REFERENCES</td><td>' ||
              RASDC_REFERENCES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SECURITY</td><td>' ||
              RASDC_SECURITY.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SQL</td><td>' || RASDC_SQL.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SQLCLIENT</td><td>' ||
              RASDC_SQLCLIENT.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_TEST</td><td>' ||
              RASDC_TEST.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_TRIGGERS</td><td>' ||
              RASDC_TRIGGERS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_VERSIONS</td><td>' ||
              RASDC_VERSIONS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_STATS</td><td>' ||
              RASDC_STATS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDI_CLIENT</td><td>' || rasdi_client.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDI_TRNSLT</td><td>' || RASDI_TRNSLT.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASD_ENGINE10</td><td>' || RASD_ENGINE10.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASD_ENGINEHTML10</td><td>' ||
              RASD_ENGINEHTML10.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');

        htp.p('<tr><td>jQuery</td><td>1.9.1</td><td></td></tr>');
        htp.p('<tr><td>jQuery UI</td><td>1.10.3</td><td></td></tr>');
        htp.p('<tr><td>CKEditor</td><td>4.3</td><td></td></tr>');

      end;
*/
      htp.prn('
    </table>
</p>
<div id="TOPCODE"  style="float:left; height: 20%; margin:10px">
<table>
<tbody>
<td class="label" align="center">TOP 10 programs with writter code</td>
<td class="label" align="center">Number of rows</td>
</tbody>
');

for r in (select form, sum(num_rows) num_rows from 
(
select f.form ,
nvl(REGEXP_count(t.plsql,'
'),-1)+1
+
nvl(REGEXP_count(t.plsqlspec,'
'),-1)+1 as num_rows
from rasd_triggers t, rasd_forms f
where t.formid = f.formid
union
select f.form ,
nvl(REGEXP_count(b.sqltext,'
'),-1)+1 as num_row
from  rasd_forms f, rasd_blocks b
where f.formid = b.formid
)
group by form
having sum(num_rows) > 100
order by 2 desc  
fetch first 10 rows only  --only on version 12 og gtreater
 ) loop
 htp.p('<tr><td>'||r.form||'</td><td>'||r.num_rows||'</td></tr>');
end loop;

htp.p('</table></div>
<div id="TOPPROG" style="float:left; height: 20%; margin:10px">
<table>
<tbody>
<td class="label" align="center">TOP 10 programers with writter code</td>
<td class="label" align="center">Number of programs</td>
<td class="label" align="center">Number of rows</td>
</tbody>
');

for r in (select owner, count(distinct formid) num_forms, sum(num_rows) num_rows from 
(
select f.owner , f.formid ,
nvl(REGEXP_count(t.plsql,'
'),-1)+1
+
nvl(REGEXP_count(t.plsqlspec,'
'),-1)+1 as num_rows
from rasd_triggers t, rasd_forms_compiled f
where t.formid = f.formid
  and f.owner = f.editor
union
select f.owner , f.formid,
nvl(REGEXP_count(b.sqltext,'
'),-1)+1 as num_row
from  rasd_forms_compiled f, rasd_blocks b
where f.formid = b.formid
  and f.owner = f.editor
)
--where 1=2
group by owner
having sum(num_rows) > 10
order by 3 desc
fetch first 10 rows only   --only on version 12 og gtreater
 ) loop
 htp.p('<tr><td>'||r.owner||'</td><td>'||r.num_forms||'</td><td>'||r.num_rows||'</td></tr>');
end loop;

htp.p('</table></div>
<div id="TOPCOMP" style="float:left;">
<table>
<tbody>
<td class="label" align="center">RASD - Compile statistics</td>
<td class="label" align="center">Number of compiles</td>
<td class="label" align="center">Time for generating form</td>
<td class="label" align="center">Time for compile form</td>
<td class="label" align="center">Avg. time to compile form</td>

<td class="label" align="center">Visit Form</td>
<td class="label" align="center">Visit Fields on Block</td>
<td class="label" align="center">Visit Triggers</td>
<td class="label" align="center">Visit CSS,JS source</td>
<td class="label" align="center">Visit HTML source</td>

</tbody>
');

for r in (
select datex, sum(decode(dselect, null, 0 , 1)) izvajanj, trunc(sum(decode(dselect, null, 0 , dprogram))) izvajanjcas, trunc(sum(decode(dselect, null, 0 , dcompile))) cimpilecas, trunc(avg(decode(dselect, null, 0 , dcompile))) avgcompilecas
       , sum(BLOCKSONFORM) BLOCKSONFORM
       , sum(FIELSONBLOCK) FIELSONBLOCK
       , sum(TRIGGERS) TRIGGERS
       , sum(CSSJS) CSSJS
       , sum(HTML) HTML
from
(
select compid, end-sart dProgram, select_e-select_s  dselect, commit_e-commit_s dcommit, compile_e-compile_s dcompile, POUTPUT_E-POUTPUT_s dPOUTPUT, t.program, f.form, datex,
BLOCKSONFORM,FIELSONBLOCK,TRIGGERS,CSSJS, HTML
from
(
select compid, max(decode(action,'START',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) SART, 
               max(decode(action,'END',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) END, 
               max(decode(action,'SELECT_S',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) SELECT_S, 
               max(decode(action,'SELECT_E',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) SELECT_E, 
               max(decode(action,'COMMIT_S',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) COMMIT_S, 
               max(decode(action,'COMMIT_E',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) COMMIT_E, 
               max(decode(action,'COMPILE_S',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) COMPILE_S, 
               max(decode(action,'COMPILE_E',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) COMPILE_E, 
               max(decode(action,'POUTPUT_S',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) POUTPUT_S, 
               max(decode(action,'POUTPUT_E',to_number(to_char(timstmp,'ff'))/1000000+to_number(to_char(timstmp,'ss'))+to_number(to_char(timstmp,'mi'))*60+to_number(to_char(timstmp,'hh24'))*3600, null)) POUTPUT_E,
               max(t.program) program, max(t.formid) formid,
               trunc(min(t.timstmp)) datex,
               decode (max(t.program), 'BLOCKSONFORM' ,1,0) BLOCKSONFORM,
               decode (max(t.program), 'FIELSONBLOCK' ,1,0) FIELSONBLOCK,
               decode (max(t.program), 'TRIGGERS' ,1,0) TRIGGERS,
               decode (max(t.program), 'CSSJS' ,1,0) CSSJS,
               decode (max(t.program), 'HTML' ,1,0) HTML               
from RASD_LOG t
group by compid
) t, rasd_forms f
where t.formid = f.formid
)
group by datex
order by 1 desc 
 
fetch first 30 rows only  --only on version 12 og gtreater
 ) loop
 htp.p('<tr><td>'||r.datex||'</td><td>'||r.izvajanj||'</td><td>'||r.izvajanjcas||'</td><td>'||r.cimpilecas||'</td><td>'||r.avgcompilecas||'</td>
  <td>'||r.BLOCKSONFORM||'</td><td>'||r.FIELSONBLOCK||'</td><td>'||r.TRIGGERS||'</td><td>'||r.CSSJS||'</td><td>'||r.HTML||'</td>
 </tr>');
end loop;

htp.p('</table></div>

<P align="right">
</P>
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

    if 1 = 2 then
      null;
    elsif ACTION = GBUTTONSRC then
      pselect;
      poutput;
    end if;

    if ACTION is null or ACTION not in (GBUTTONSRC) then

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
end;
/

