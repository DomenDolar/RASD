create or replace package RASDC_HTML is
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

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/

create or replace package body RASDC_HTML is
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
20200410 - Added new compilation message    
20160629 - Added log function for RASD.      
20150817 - Added tab look   
20150814 - Added superuser    
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20200410225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    ACTION      varchar2(4000);
    EDITOR      varchar2(4000) := 'TREE'; --'EDITOR';
    VREDNOST    varchar2(32000);
    LANG        varchar2(4000);
    PFORMID     number;
    felementid  varchar2(4000);
    ptclevel    varchar2(4000);
    POLJE       varchar2(4000);
    RECNUMB20                     number := 1;    
    B1RID       rtab;
    B1RS        ctab;
    B1elementid ntab;
    B1ELEMENT   ctab;
    B1ELEMENTX  ctab;
    B1inst      ctab;
    B1hiddenyn  ctab;
    vcom number;
    B1source    ctab;
    B1REFERENCA ctab;
    message     varchar2(4000);
    predogled   varchar2(4000);
    procedure prepisi_v_texte(v_clob clob, PFORMID number) is
      -- Prepis vsebine iz tabele RASD_FILES v tabelo RASD_TEXTS
      v_char       VARCHAR2(32767);
      desc_offset  number := 100;
      src_offset   number := 100;
      lang_context number := 1;
      warning      number;
      vtextid      number;
      i            pls_integer;
      l            pls_integer;
    BEGIN
      l := nvl(dbms_lob.getlength(v_clob), 0);
      i := 0;
      begin
        select t.textid
          into vtextid
          from RASD_FORMS f, RASD_TEXTS t
         where f.formid = PFORMID
           and f.text2id = t.textid;
        update RASD_TEXTS set text = '' where textid = vtextid;
      exception
        when no_data_found then
          vtextid := to_number(null);
      end;
      loop
        v_char := dbms_lob.substr(v_clob, 32750, i + 1);
        if vtextid is null then
          select nvl(max(textid), 0) + 1 into vtextid from RASD_TEXTS;
          update RASD_FORMS set text2id = vtextid where formid = PFORMID;
          insert into RASD_TEXTS (textid, text) values (vtextid, v_char);
        else
          update RASD_TEXTS set text = v_char where textid = vtextid;
        end if;
        i := i + 32750;
        exit when i >= l;
      end loop;
    end;

    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('EDITOR') then
          EDITOR := value_array(i__);
        elsif upper(name_array(i__)) = upper('EDITOR1') then
          VREDNOST := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('PELEMENTID') then
          felementid := value_array(i__);
        elsif upper(name_array(i__)) = upper('Ptclevel') then
          ptclevel := value_array(i__);
        elsif  upper(name_array(i__)) = upper('RECNUMB20') then 
          RECNUMB20 := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('POLJE') then
          POLJE := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B1RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1ELEMENTID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1elementid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B1ELEMENT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1ELEMENT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1inst_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1inst(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1hiddenyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1hiddenyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1source_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B1REFERENCA_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B1REFERENCA(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;

      v_max := 0;
      if B1RID.count > v_max then
        v_max := B1RID.count;
      end if;
      if B1RS.count > v_max then
        v_max := B1RS.count;
      end if;
      if B1elementid.count > v_max then
        v_max := B1elementid.count;
      end if;
      if B1ELEMENT.count > v_max then
        v_max := B1ELEMENT.count;
      end if;
      if B1inst.count > v_max then
        v_max := B1inst.count;
      end if;
      if B1hiddenyn.count > v_max then
        v_max := B1hiddenyn.count;
      end if;
      if B1source.count > v_max then
        v_max := B1source.count;
      end if;
      if B1REFERENCA.count > v_max then
        v_max := B1REFERENCA.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B1RID.exists(i__) then
          B1RID(i__) := null;
        end if;
        if not B1RS.exists(i__) then
          B1RS(i__) := null;
        end if;
        if not B1elementid.exists(i__) then
          B1elementid(i__) := to_number(null);
        end if;
        if not B1ELEMENT.exists(i__) then
          B1ELEMENT(i__) := null;
        end if;
        if not B1inst.exists(i__) then
          B1inst(i__) := null;
        end if;
        if not B1hiddenyn.exists(i__) or B1hiddenyn(i__) is null then
          B1hiddenyn(i__) := 'N';
        end if;
        if not B1source.exists(i__) then
          B1source(i__) := null;
        end if;
        if not B1REFERENCA.exists(i__) then
          B1REFERENCA(i__) := null;
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
    procedure pclear_B1(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 0 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 0 then
          k__ := i__ + 0;
        else
          k__ := 0 + 0;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B1RID(j__) := null;
        B1RS(j__) := null;
        B1elementid(j__) := null;
        B1ELEMENT(j__) := null;
        B1inst(j__) := null;
        B1hiddenyn(j__) := null;
        B1source(j__) := null;
        B1REFERENCA(j__) := null;

      end loop;
    end;
    procedure pclear_form is
    begin
      ACTION     := null;
      PFORMID    := null;
      felementid := null;
      ptclevel   := null;
      POLJE      := null;
      RECNUMB20 := 1;         
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_B1(0);
      null;
    end;
    procedure pselect_B1 is
      i__ pls_integer;
    begin
      B1RID.delete;
      B1RS.delete;
      B1elementid.delete;
      B1ELEMENT.delete;
      B1ELEMENTX.delete;
      B1inst.delete;
      B1hiddenyn.delete;
      B1source.delete;
      B1REFERENCA.delete;
      --<pre_select formid="50011" blockid="B1">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin

        OPEN c__ FOR
          select rowid rid,
                 elementid,
                 '<font size="-3">' ||
                  substr('1---2---3---4---5---6---7---8---9--10' ||
                         '--11--12--13--14--15--16--17--18--19--20' ||
                         '--21--22--23--24--25--26--27--28--29--30',
                         1,
                         ((level - 1) * 4 + 1)) || '</font>   <B>' ||
                  element || '  ' ||
                  decode(nvl(nameid, id), null, '', ' <font color=blue>') ||
                  nvl(nameid, id) ||
                  decode(nvl(nameid, id), null, '', '</font>') || '</B>' || '(' ||
                  elementid || ') '
                 ----  ||'<a href="javascript:js_dodaj('' '||pelementid||''')">?'||pelementid||'?-'||'</a>'||' '
                 --  ||'<a href="javascript:js_dodaj('' '||elementid||' '')">&nbsp;&nbsp;'||elementid||'&nbsp;&nbsp;</a>'||'&nbsp;.&nbsp;'
                 --  ||'<a href="javascript:js_dodaj('' '||pelementid||' '||orderby||' '')">&nbsp;&nbsp;'||orderby||'&nbsp;&nbsp;</a>'
                  || '|&nbsp;<a href="javascript:js_inst(''' || rownum ||
                  ''',''M''); js_rowi(''' || rownum || ''');">&nbsp;&nbsp;' ||
                  RASDI_TRNSLT.text('move', lang) || '&nbsp;&nbsp;</a>' ||
                  '&nbsp;.&nbsp;' || '<a href="javascript:js_inst(''' ||
                  rownum || ''',''C''); js_rowi(''' || rownum ||
                  ''');">&nbsp;&nbsp;' || RASDI_TRNSLT.text('copy', lang) ||
                  '&nbsp;&nbsp;</a>' || '&nbsp;.&nbsp;' ||
                  '<a href="javascript:js_inst(''' || rownum ||
                  ''',''D''); js_rowi(''' || rownum || ''');">&nbsp;&nbsp;' ||
                  RASDI_TRNSLT.text('delete', lang) || '&nbsp;&nbsp;</a>' ||
                  '&nbsp;.&nbsp;'
                 --  ||'<a href="javascript:js_inst('''||rownum||''',''A'')">&nbsp;&nbsp;'||RASDI_TRNSLT.text('dod.',lang)||'&nbsp;&nbsp;</a>'||'&nbsp;.&nbsp;'
                 --  ||'<a href="javascript:js_inst('''||rownum||''',''R'')">&nbsp;&nbsp;'||RASDI_TRNSLT.text('ref.',lang)||'&nbsp;&nbsp;</a>'||'&nbsp;'
                  || '|&nbsp;<a href="javascript:js_dodaj('' ' || elementid ||
                  ' ''); js_row(''' || rownum || ''');">&nbsp;&nbsp;' ||
                  RASDI_TRNSLT.text('on', lang) || '&nbsp;&nbsp;</a>' ||
                  '&nbsp;.&nbsp;' || '<a href="javascript:js_dodaj('' ' ||
                  pelementid || ' ' || orderby || ' ''); js_row(''' ||
                  rownum || ''');">&nbsp;&nbsp;' ||
                  RASDI_TRNSLT.text('before', lang) || '&nbsp;&nbsp;</a>' ||
                  '&nbsp;.&nbsp;' || '<a href="javascript:js_dodaj('' ' ||
                  pelementid || ' ' || to_char(to_number(orderby) + 1) ||
                  ' ''); js_row(''' || rownum || ''');">&nbsp;&nbsp;' ||
                  RASDI_TRNSLT.text('after', lang) || '&nbsp;&nbsp;</a>' ||
                  '&nbsp;.&nbsp;' element,
                 hiddenyn,
                 nvl(source, '?'),
                 ---  rlobid||'.'||rform||'.'||rid referenca
                 rform || '.' || rid referenca,
                 element || '(' || nameid || ')' elementx
            from RASD_ELEMENTS
           where formid = PFORMID
             and ((ptclevel = 'FB' and element in ('FORM_', 'TR_', 'P_') and
                 nameid is not null) or
                 (ptclevel = 'BP' and
                 ((element in ('TR_', 'P_') and nameid is not null) or
                 (element not in ('TR_', 'P_') and nameid is not null))) or
                 (ptclevel = '1' and level <= 2) or
                 (ptclevel = '2' and level <= 3) or
                 (ptclevel = '3' and level <= 4) or
                 (ptclevel = '4' and level <= 5) or ptclevel is null)
          connect by formid = prior formid
                 and pelementid = prior elementid
           start with formid = PFORMID
                  and ((felementid is null and pelementid = 0) or
                      (elementid = felementid))
           order siblings by orderby
          --order siblings by level, orderby;
          ;
        i__ := 1;
        LOOP

          FETCH c__
            INTO B1RID(i__),
                 B1elementid(i__),
                 B1ELEMENT(i__),
                 B1hiddenyn(i__),
                 B1source(i__),
                 B1REFERENCA(i__),
                 B1ELEMENTX(i__);
          exit when c__%notfound;
--          if c__%rowcount >= 1 then
          if c__%rowcount >= nvl(RECNUMB20,1) then --xx           
            B1RS(i__) := null;
            B1inst(i__) := null;
            B1RS(i__) := 'U';

            --<post_select formid="50011" blockid="B1">
            --</post_select>
            exit when i__ = 50;  --xx            
            i__ := i__ + 1;
          end if;
        END LOOP;
--        if c__%rowcount < 1 then
        if c__%rowcount < nvl(RECNUMB20,1)  then --xx          
          B1RID.delete(1);
          B1RS.delete(1);
          B1elementid.delete(1);
          B1ELEMENT.delete(1);
          B1inst.delete(1);
          B1hiddenyn.delete(1);
          B1source.delete(1);
          B1REFERENCA.delete(1);
          B1ELEMENTX.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B1(B1RID.count);
      null;
    end;
    procedure pselect is
    begin
      if 1 = 1 then
        pselect_B1;
      end if;
      null;
    end;
    procedure pcommit_B1 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B1RID.count loop
        --<on_validate formid="50011" blockid="B1">
        --</on_validate>
        if substr(B1RS(i__), 1, 1) = 'I' then
          --INSERT
          if B1inst(i__) is not null or B1hiddenyn(i__) is not null or
             B1source(i__) is not null then
            --<pre_insert formid="50011" blockid="B1">
            --</pre_insert>
            --<post_insert formid="50011" blockid="B1">
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          --<pre_update formid="50011" blockid="B1">
          --</pre_update>
          begin
            update RASD_ELEMENTS
               set hiddenyn = B1hiddenyn(i__), source = B1source(i__)
             where ROWID = B1RID(i__);
          exception
            when others then
              null; --htp.p(sqlerrm);
          end;
          --<post_update formid="50011" blockid="B1">
          if B1inst(i__) is not null then
            RASDC_LIBRARY.instruction(PFORMID,
                                      b1elementid(i__),
                                      B1inst(i__));
            -- inst(PFORMID, b1elementid(i__), B1inst(i__));
          end if;

          --</post_update>
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="50011" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B1;
      end if;
      --<post_commit formid="50011" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB1 pls_integer;
      --povezavein
      --SQL
      procedure js_LINKattributeI(value varchar2,
                                  name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B1ELEMENT%' then
          htp.prn('''!rasdc_attributes.program?LANG=' || lang ||
                  '&PELEMENTID=''+document.RASDC_HTML.B1ELEMENTID_' ||
                  substr(name, instr(name, '_', -1) + 1) ||
                  '.value+
''&PELEMENT=''+document.RASDC_HTML.B1ELEMENTX_' ||
                  substr(name, instr(name, '_', -1) + 1) || '.value+
''&PFORMID=''+document.RASDC_HTML.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_attributes.program?LANG=' || lang || '&PELEMENTID=''+document.RASDC_HTML.B1elementid_1.value+
''&PFORMID=''+document.RASDC_HTML.PFORMID.value+
''''');
        end if;
      end;
      procedure js_lovelementi(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_lovelementi(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_lovtclevel(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_lovtclevel(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      --TEXT
      procedure js_lovsource(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_lovsource(''' || value || ''')');
        htp.p('</SCRIPT>');
      end;
      --TF
      procedure js_INPUT_CHECKBOX_DEF(value varchar2,
                                      name  varchar2 default null) is
      begin
        if value = 'Y' then
          htp.prn('Y" checked "');
        else
          htp.prn('Y');
        end if;
      end;
      --SQL-T
    begin
      --js povezavein
      --js SQL
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_lovelementi(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="50011" linkid="lovelementi">
                  select -1 orderby, '' label, to_number(null) id
                    from dual
                  union
                  select orderby,
                          decode(nameid, null, element, nameid) label,
                          elementid id
                    from RASD_ELEMENTS
                   where formid = PFORMID
                     and (element in ('HTML_', 'HEAD_', 'BODY_') or
                         nameid is not null)
                   order by orderby

                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_lovtclevel(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="50011" linkid="lovtclevel">
                  select 1 vr, '' label, '' id
                    from dual
                  union
                  select 2 vr,
                          RASDI_TRNSLT.text('Form - blocks', lang) label,
                          'FB' id
                    from dual
                  union
                  select 3 vr,
                          RASDI_TRNSLT.text('Blocks - fields', lang) label,
                          'BP' id
                    from dual
                  union
                  select 4 vr, '1 level' label, '1' id
                    from dual
                  union
                  select 5 vr, '2 level' label, '2' id
                    from dual
                  union
                  select 6 vr, '3 level' label, '3' id
                    from dual
                  union
                  select 7 vr, '4 level' label, '4' id
                    from dual
                  union
                  select 8 vr, '5 level' label, '5' id
                    from dual
                  union
                  select 9 vr, '6 level' label, '6' id
                    from dual
                   order by vr
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      --js TEXT
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_lovsource(pvalue) {');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue=='''')?''selected'':'''') +'' value=""> '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''G'')?''selected'':'''') +'' value="G">' ||
            RASDI_TRNSLT.text('Eng.', lang) || ''')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''V'')?''selected'':'''') +'' value="V">' ||
            RASDI_TRNSLT.text('Chng', lang) || ''')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''R'')?''selected'':'''') +'' value="R">' ||
            RASDI_TRNSLT.text('Ref.', lang) || ''')');
      htp.p('}');
      htp.p('</SCRIPT>');
      --js TF
      htp.prn('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('</SCRIPT>');
      htp.prn('
<SCRIPT LANGUAGE="JavaScript">
  function js_inst(pPOLJE,pvalue) {
    document.RASDC_HTML.POLJE.value = ''B1inst_''+pPOLJE;
    for(var i = 0; i < RASDC_HTML.length; i++) {
      if (document.RASDC_HTML.elements[i].name == document.RASDC_HTML.POLJE.value) {
        document.RASDC_HTML.elements[i].value = pvalue;
        break;
    }}}
  function js_dodaj(pvalue) {
    for(var i = 0; i < RASDC_HTML.length; i++) {
      if (document.RASDC_HTML.elements[i].name == document.RASDC_HTML.POLJE.value) {
        document.RASDC_HTML.elements[i].value = document.RASDC_HTML.elements[i].value+pvalue;
        //document.RASDC_HTML.ACTION.focus();
        break;
    }}}

  function js_rowi(pvalue) {
      var x = document.getElementById(pvalue);
      x.style.backgroundColor=''33CCFF'';
    }

  function js_row(pvalue) {
      var x = document.getElementById(pvalue);
      x.style.backgroundColor=''#FFFF99'';
    }

</SCRIPT>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'

  <script>
  $(function() {
    $( "#tabs" ).tabs({
      active: '); if editor = 'EDITOR' then htp.p('0'); else htp.p('1'); end if;  htp.p('
    });
  });
 
 
  function submit_form(valll) {
    document.getElementById(''EDITOR'').value = valll; 
    document.getElementById(''ACTION'').value = ''Search'';
    document.getElementById(''RASDC_HTML'').submit();   
  }
  
  </script>
  
<SCRIPT LANGUAGE="Javascript1.2">
 $(function() {
     addSpinner();   
  }); 
</SCRIPT>

</HEAD>
<BODY style="min-width: 1260;">
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_HTML_LAB">');
      RASDC_LIBRARY.showhead('RASDC_HTML',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
      htp.prn('</FONT>
<FORM ID="RASDC_HTML" NAME="RASDC_HTML" METHOD="POST" ACTION="!RASDC_HTML.program">
<P>
<TABLE width="100%"><TR>
<TD align=left>
');
--      htp.p('<input type=submit value="' ||
--            RASDI_TRNSLT.text('HTML Editor', lang) ||
--            '" class="button" onclick="EDITOR.value=''EDITOR'';ACTION.value=''' ||
--            RASDI_TRNSLT.text('Search', lang) || '''; submit();">');
--      htp.p('<input type=submit value="' ||
--            RASDI_TRNSLT.text('HTML Tree', lang) ||
--            '" class="button" onclick="EDITOR.value=''TREE''; ACTION.value=''' ||
--            RASDI_TRNSLT.text('Search', lang) || ''';submit();">');
      htp.prn('
</TD>
<TD align=right>
<INPUT  class="SUBMIT" type="button" value="<<" onclick=" javascript: ACTION.value=this.value; submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value=">>" onclick=" javascript: ACTION.value=this.value; submit(); this.disabled = true; ">
');
if rasdc_library.allowEditing(pformid) then
      htp.p('<input type=button value="' ||
            RASDI_TRNSLT.text('Save', lang) ||
            '" class="submit" onclick="javascript: ACTION.value=this.value; submit(); this.disabled = true;">');
      htp.prn('
<INPUT class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick="javascript: ACTION.value=this.value; submit(); this.disabled = true;">');
end if;
      htp.p('<input type=reset value="' ||
            RASDI_TRNSLT.text('Reset', lang) || '" class="submit">');
      htp.p(predogled);
if rasdc_library.allowEditing(pformid) then
      htp.p('<input type=button value="' ||
            RASDI_TRNSLT.text('Delete all HTML elements', lang) ||
            '" class="submit" onClick="javascript: ACTION.value=''' ||
            RASDI_TRNSLT.text('Delete all HTML elements', lang) ||
            '''; var r=confirm(''' ||
            RASDI_TRNSLT.text('You realy want to delete HTML elements?',
                              lang) ||
            '''); if (r==true){ submit(); } else { }">');
end if;
      htp.p('
</TD></TR></TABLE>
</P>
<INPUT TYPE="HIDDEN" ID="ACTION" NAME="ACTION">
<input name="RECNUMB20" id="RECNUMB20" type="hidden" value="'||ltrim(to_char(RECNUMB20))||'"/>
<INPUT TYPE="HIDDEN" NAME="LANG" VALUE="' || lang || '">
<INPUT TYPE="HIDDEN" ID="EDITOR" NAME="EDITOR" VALUE="' || editor || '">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID || '" CLASS="TEXT">


<div id="tabs">
 <ul>
    <li id="tab0"><a href="#tabs-'||editor||'" onclick="submit_form(''EDITOR'');" >'||RASDI_TRNSLT.text('HTML Editor', lang)||'</a></li>
    <li id="tab1"><a href="#tabs-'||editor||'" selected onclick="submit_form(''TREE'');" >'||RASDI_TRNSLT.text('HTML Tree', lang)||'</a></li>
  </ul>

');

if editor = 'EDITOR' then

        htp.p('
<div id="tabs-'||editor||'">
<textarea id="editor1" name="editor1" rows="40" cols="150">');

        rasd_enginehtml10.outputelement(PFORMID, 0, 'T');

        htp.p('</textarea>
		<script>

			// Replace the <textarea id="editor"> with an CKEditor
			// instance, using default configurations.
			CKEDITOR.replace( ''editor1'', {
				uiColor: ''#14B8C4'',
        toolbar: [
    [ ''Source'', ''-'', ''Preview'' ],
    [ ''Cut'', ''Copy'', ''Paste'', ''PasteText'', ''PasteFromWord'', ''-'', ''Undo'', ''Redo'' ]
,[ ''Maximize'', ''ShowBlocks'' ,''-'',''About'' ] ,
    ''/'',
    [''Form'', ''Checkbox'', ''Radio'', ''TextField'', ''Textarea'', ''Select'', ''Button'', ''ImageButton'', ''HiddenField'']
,[''Link'',''Unlink'']
,[''Image'',''Flash'',''Table'',''HorizontalRule'',''SpecialChar'',''PageBreak'']
]
			});
      CKEDITOR.config.allowedContent = true;
      CKEDITOR.config.startupOutlineBlocks = true;
		</script>


</div>
');

      else

        htp.p('
<div id="tabs-'||editor||'">
<P align="center">

<TABLE ><TR><TD align=left>
<SELECT NAME="PELEMENTID" CLASS="SELECT">');
        js_lovelementi(felementid, 'PELEMENTID');
        htp.prn('</SELECT><SELECT NAME="Ptclevel" CLASS="SELECT">');
        js_lovtclevel(ptclevel, 'Ptclevel');
        htp.prn('</SELECT><INPUT NAME="POLJE" TYPE="hidden" VALUE="' ||
                POLJE || '" CLASS="TEXT">
    <img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="Search"  onClick="ACTION.value=''Search''; submit();">

 <a class="A" href="javascript: location=''RASDC_FILES.download?PDATOTEKA=''+document.RASDC_HTML.PFORMID.value+
''''" name="B10LHTML1_1"><img height="20" title="' ||
                RASDI_TRNSLT.text('HTML download', lang) ||
                '" src="rasdc_files.showfile?pfile=pict/gumbhtmld.jpg" width="21" border="0"></a>
<a class="A" href="javascript: var p_x=window.open(''RASDC_FILES.upload?PLANG=''+document.RASDC_HTML.LANG.value+
''&PFORMID=''+document.RASDC_HTML.PFORMID.value+
'''',''p_x'',''width=400,height=250,scrolbars=0'')" name="B10LHTML2_1"><img height="20" title="' ||
                RASDI_TRNSLT.text('HTML upload', lang) || '" src="rasdc_files.showfile?pfile=pict/gumbhtmlu.jpg" width="21" border="0"></a>
    ');
        rasdc_hints.link('RASDC_HTML', lang);
        htp.prn('</td>
    <TD align=right>
    </TD></TR>
<TR><TD>
<TABLE BORDER="1">
<TR ">
<TD class="label" align="center"><FONT ID="B1ELEMENT_LAB">' ||
                RASDI_TRNSLT.text('Element', lang) ||
                '</FONT></TD>
<TD class="label" align="center"><FONT ID="B1inst_LAB">' ||
                RASDI_TRNSLT.text('Instruction', lang) ||
                '</FONT></TD>
<TD class="label" align="center"><FONT ID="B1hiddenyn_LAB">' ||
                RASDI_TRNSLT.text('Hidden', lang) ||
                '</FONT></TD>
<TD class="label" align="center"><FONT ID="B1source_LAB">' ||
                RASDI_TRNSLT.text('Source', lang) ||
                '</FONT></TD>
<TD class="label" align="center"><FONT ID="B1REFERENCA_LAB">' ||
                RASDI_TRNSLT.text('Ref. to id', lang) ||
                '</FONT></TD></TR>');
        for iB1 in 1 .. B1RS.count loop
          htp.prn('<TR ID="' || iB1 || '"><INPUT NAME="B1RID_' || iB1 ||
                  '" TYPE="HIDDEN" VALUE="' || B1RID(iB1) ||
                  '" CLASS="HIDDEN"><INPUT NAME="B1RS_' || iB1 ||
                  '" TYPE="HIDDEN" VALUE="' || B1RS(iB1) ||
                  '" CLASS="HIDDEN"><INPUT NAME="B1ELEMENTID_' || iB1 ||
                  '" TYPE="HIDDEN" VALUE="' || B1elementid(iB1) ||
                  '" CLASS="HIDDEN">
<INPUT NAME="B1ELEMENTX_' || iB1 ||
                  '" TYPE="HIDDEN" VALUE="' || B1elementx(iB1) ||
                  '" CLASS="HIDDEN">
<TD><A align=left href="javascript: var link=window.open(');
          js_LINKattributeI(B1ELEMENT(iB1), 'B1ELEMENT_' || iB1 || '');
          htp.prn(','''',''width=550,height=400,scrollbars=1'')">' ||
                  RASDI_TRNSLT.text('*', lang) ||
                  '</A><FONT ID="B1ELEMENT_' || iB1 ||
                  '" CLASS="FONT" style="font-size: x-small;">' ||
                  B1ELEMENT(iB1) || '</FONT></TD>
<TD><INPUT NAME="B1inst_' || iB1 ||
                  '" TYPE="TEXT" VALUE="' || B1inst(iB1) ||
                  '" CLASS="TEXT" onclick="document.RASDC_HTML.POLJE.value=name"></TD>
<TD><INPUT NAME="B1hiddenyn_' || iB1 ||
                  '" TYPE="CHECKBOX" VALUE="');
          js_INPUT_CHECKBOX_DEF(B1hiddenyn(iB1),
                                'B1hiddenyn_' || iB1 || '');
          htp.prn('" CLASS="CHECKBOX"></TD>
<TD><SELECT NAME="B1source_' || iB1 ||
                  '" CLASS="SELECT">');
          js_lovsource(B1source(iB1), 'B1source_' || iB1 || '');
          htp.prn('</SELECT></TD>
<TD><FONT ID="B1REFERENCA_' || iB1 || '" CLASS="FONT">' ||
                  B1REFERENCA(iB1) || '</FONT></TD></TR>');
        end loop;
        htp.prn('</TABLE>
</TD></TR></TABLE>
</P>
</div>
');

      end if;

      htp.p('
</div>      
      <table width="100%" border="0"><tr>
');
      if message is not null then
        htp.prn('
<td width="1%" class="sporociloh" nowrap><FONT COLOR="green" size="4">' ||
                RASDI_TRNSLT.text('Message', lang) ||
                ': </FONT></td>
<td class="sporocilom">' ||
                RASDI_TRNSLT.text(message, lang) || '</td>
');
      end if;
      htp.prn('
<td  align="right">
<INPUT  class="SUBMIT" type="button" value="<<" onclick=" javascript: ACTION.value=this.value; submit(); this.disabled = true; ">
<INPUT  class="SUBMIT" type="button" value=">>" onclick=" javascript: ACTION.value=this.value; submit(); this.disabled = true;  ">
');
if rasdc_library.allowEditing(pformid) then
      htp.p('<input type=button value="' ||
            RASDI_TRNSLT.text('Save', lang) ||
            '" class="submit" onclick="javascript: ACTION.value=this.value; submit(); this.disabled = true;">');
      htp.prn('
<INPUT class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick="javascript: ACTION.value=this.value; submit(); this.disabled = true;">');
end if;
      htp.p('<input type=reset value="' ||
            RASDI_TRNSLT.text('Reset', lang) || '" class="submit">');
      htp.p(predogled);
if rasdc_library.allowEditing(pformid) then
      htp.p('<input type=button value="' ||
            RASDI_TRNSLT.text('Delete all HTML elements', lang) ||
            '" class="submit" onClick="javascript: ACTION.value=''' ||
            RASDI_TRNSLT.text('Delete all HTML elements', lang) ||
            '''; var r=confirm(''' ||
            RASDI_TRNSLT.text('You realy want to delete HTML elements?',
                              lang) ||
            '''); if (r==true){ submit(); } else { }">');
end if;
      htp.p('</td>
</tr>
</table>');

      htp.p('
</FORM></BODY>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</HTML>
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
    rasdc_library.log('HTML',pformid, 'START', vcom);

    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
      v_form   varchar2(100);
    begin
      rasdi_client.secCheckPermission('RASDC_HTML', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

      select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;
       
       

      if ACTION = RASDI_TRNSLT.text('<<', lang) then
    if RECNUMB20 > 50 then
      RECNUMB20 := RECNUMB20-50;
    else
      RECNUMB20 := 1;
    end if;        
        pselect;
    message := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,50))/50)+1);

      elsif ACTION = RASDI_TRNSLT.text('>>', lang) then
    RECNUMB20 := RECNUMB20+50 ;
        pselect;
    message := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,50))/50)+1);
        
      elsif ACTION = RASDI_TRNSLT.text('Search', lang) then
        if editor = 'EDITOR' then

          null;
        else
          pselect;
    message := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,50))/50)+1);

        end if;
      elsif ACTION = RASDI_TRNSLT.text('Delete all HTML elements', lang) then
        delete from rasd_elements t where t.formid = pformid and not exists (select 1 from rasd_attributes a where a.formid = pformid and a.elementid = t.elementid and a.source in ('V','R')) and nvl(t.source,'G') not in  ('V','R');
        delete from rasd_attributes t where formid = pformid and not exists (select 1 from rasd_elements a where a.formid = pformid and a.elementid = t.elementid);
        update rasd_elements set pelementid = 0, elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = pformid;
        update rasd_attributes set elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = pformid;

        message := 'All HTML elements are deleted. Except manualy changed.';
        if editor = 'EDITOR' then
          null;
        else
          pselect;

        end if;
      elsif ACTION = RASDI_TRNSLT.text('Save', lang) then
        if editor = 'EDITOR' then
          /*
              prepisi_v_texte(VREDNOST, PFORMID);
              rasd_enginehtml10.readFromFile(PFORMID);
              rasd_engine10.form(PFORMID);
          */
          message := 'Changes are saved.';
          message := 'The function is not supported.';

        else
          pcommit;
          pselect;
          message := 'Changes are saved.';

        end if;
      elsif ACTION = RASDI_TRNSLT.text('Clear', lang) then
        pclear;

      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        rasdc_library.log('HTML',pformid, 'COMMIT_S', vcom);                 
        pcommit;
        rasdc_library.log('HTML',pformid, 'COMMIT_E', vcom);           
        commit;
        rasdc_library.log('HTML',pformid, 'SELECT_S', vcom);        
        pselect;
        rasdc_library.log('HTML',pformid, 'SELECT_E', vcom);       
        rasdc_library.log('HTML',pformid, 'COMPILE_S', vcom);                  
        begin
          if v_form in ('RASDC_BLOCKSONFORM',
                        'RASDC_FIELDSONBLOCK',
                        'RASDC_TRIGGERS',
                        'RASDC_LINKS',
                        'RASDC_PAGES',
                        'F_FORME',
                        'RASDC_FORMS') then
            message := RASDI_TRNSLT.text('From is not generated.', lang);  
          else
            select server
              into v_server
              from RASD_FORMS_COMPILED fg, RASD_ENGINES g
             where fg.engineid = g.engineid
               and fg.formid = PFORMID
               and fg.editor = vup
               and (fg.lobid = rasdi_client.secGetLOB or
                   fg.lobid is null and rasdi_client.secGetLOB is null);

            cid := dbms_sql.open_cursor;
            dbms_sql.parse(cid,
                           'begin ' || v_server || '.form(' || PFORMID ||
                           ',''' || lang || ''');end;',
                           dbms_sql.native);
            n := dbms_sql.execute(cid);
            dbms_sql.close_cursor(cid);
            message := RASDI_TRNSLT.text('From is generated.', lang);  
          end if;
        exception
          when others then
           if sqlcode = -24344 then
              
            message := RASDI_TRNSLT.text('Form is generated with compilation error. Check your code.', lang)||'('||sqlerrm||')';
             
            else
            message := RASDI_TRNSLT.text('Form is NOT generated - internal RASD error.', lang) || '('||sqlerrm||')<br>'||
                         RASDI_TRNSLT.text('To debug run: ', lang) || 'begin ' || v_server || '.form(' || PFORMID ||
                         ',''' || lang || ''');end;' ;
            end if; 
       end;
      rasdc_library.log('HTML',pformid, 'COMPILE_E', vcom);            
        pselect;
      else
        if editor = 'EDITOR' then
          null;
        else
          pselect;

        end if;
      end if;

      predogled := '<input type=button class=submitp value="' ||
                   RASDI_TRNSLT.text('Preview', lang) || '" ' ||
                   owa_util.ite(RASDC_LIBRARY.formhaserrors(v_form) = true,
                                'style="background-color: red;" title="' ||
                                RASDI_TRNSLT.text('Program has ERRORS!',
                                                  lang) || '" ',
                                owa_util.ite(RASDC_LIBRARY.formischanged(PFORMID) = true,
                                             'style="background-color: orange;" title="' ||
                                             RASDI_TRNSLT.text('Programa has changes. Compile it.',
                                                               lang) ||
                                             '" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ',
                                             'style="background-color: green;" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ')) || '>';

      rasdc_library.log('HTML',pformid, 'POUTPUT_S', vcom);   
      phtml;
      rasdc_library.log('HTML',pformid, 'POUTPUT_E', vcom);         
      rasdc_library.log('HTML',pformid, 'END', vcom);         
    end;
  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<TITLE>' || RASDI_TRNSLT.text('Message', lang) || '</TITLE>
</HEAD>
<BODY bgcolor="#C0C0C0">
');
      RASDC_LIBRARY.showphead(RASDI_TRNSLT.text('Message', lang),
                                 '',
                                 '',
                                 lang);
      htp.p('<FORM ACTION="" METHOD="POST" NAME="SPOROCILA">
<table>
<tr><td>
<FONT COLOR="red" size="4">' ||
            RASDI_TRNSLT.text('Error', lang) || ': </FONT></td><td>
' || replace(sqlerrm,
                        '
',
                        '<BR>') ||
            '</td></tr><tr><td></td><td></td></tr></table>
<BR>
<INPUT TYPE="button" NAME="NAZAJ" VALUE=" ' ||
            RASDI_TRNSLT.text('Back', lang) || ' " class=submit onClick="javascript:history.go(-1)">
<script language="JavaScript">
  document.SPOROCILA.NAZAJ.focus();
</script>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</FORM></BODY></HTML>');

  end;
end RASDC_HTML;
/

