create or replace package RASDC_FORMS is
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

create or replace package body RASDC_FORMS is
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
20191220 - Added Creat form button
20190325 - Added version filter
20181023 - Added warnings    
20180520 - In field Text you can search all content of forms (JS, triggers, blocks, SQL, ...)
20180307 - Added ? in program by default    
20171201 - Added compilation date and order by    
20161128 - Added NEWs block    
20160321 - Added form description in list of forms    
20151202 - Included session variables in filters    
20151001 - Added upload file    
20150814 - Added superuser
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20191220225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    GBUTTON1        varchar2(4000) := 'Search';
    GBUTTON2        varchar2(4000) := 'Reset';
    GBUTTON3        varchar2(4000) := 'Save';
    LANG            varchar2(4000);
    ACTION          varchar2(4000);
    SPOROCILO       varchar2(4000);
    Papplication    varchar2(4000);
    Pu    varchar2(4000);
    Pf1    varchar2(4000);
    PDA    varchar2(4000);    
    PDAV    varchar2(4000);    
    KOPIRAJF        varchar2(4000);
    B10RS           ctab;
    B10rid          rtab;
    B101rid         rtab;
    B10formid       ntab;
    B101formid      ntab;
    B10form         ctab;
    B10label         ctab;
    B10version      ntab;
    B101lobid       ctab;
    B10engineid     ntab;
    B101form        ctab;
    B10change       dtab;
    B10compileyn    ctab;
    B101version     ntab;
    B10application  ctab;
    B101label       ctab;
    B10owner        ctab;
    B101PROGRAM     ctab;
    B101text1id     ntab;
    B10editor       ctab;
    B10lobid        ctab;
    B101text2id     ntab;
    B10PRAVICE      ctab;
    B10LBLOKI       ctab;
    B101referenceyn ctab;
    B101change      dtab;
    B10datecompile       ctab;
    B10warning      ctab;
    
  procedure on_session is
    i__ pls_integer := 1;
  begin
  if ACTION is not null then
begin
 rasdi_client.sessionStart;
rasdi_client.sessionSetValue('PAPPLICATION', papplication ); 
rasdi_client.sessionSetValue('PU', pu ); 
rasdi_client.sessionSetValue('PF1', pf1 ); 
rasdi_client.sessionSetValue('PDA', pda ); 
rasdi_client.sessionSetValue('PDAV', pdav ); 
 rasdi_client.sessionClose;
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
if papplication is null then vc := rasdi_client.sessionGetValue('PAPPLICATION'); PAPPLICATION  := vc;  end if; 
if pu is null then vc := rasdi_client.sessionGetValue('PU'); pu  := vc;  end if; 
if pf1 is null then vc := rasdi_client.sessionGetValue('PF1'); pf1  := vc;  end if; 
if pda is null then vc := rasdi_client.sessionGetValue('PDA'); pda  := vc;  end if; 
if pdav is null then vc := rasdi_client.sessionGetValue('PDAV'); pdav  := vc;  end if; 
exception when others then  null; end;  end if;
  end;
    
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
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('') then
          SPOROCILO := value_array(i__);
        elsif upper(name_array(i__)) = upper('Papplication') then
          Papplication := value_array(i__);
        elsif upper(name_array(i__)) = upper('PU') then
          pu := value_array(i__);
        elsif upper(name_array(i__)) = upper('PF1') then
          pf1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('PDA') then
          pda := value_array(i__);          
        elsif upper(name_array(i__)) = upper('PDAV') then
          pdav := value_array(i__);    
        elsif upper(name_array(i__)) = upper('KOPIRAJF') then
          KOPIRAJF := value_array(i__);
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
              upper('B101RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101rid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B101formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10form_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10form(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10version_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10version(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B101lobid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101lobid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10engineid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10engineid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B101form_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101form(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10change_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10change(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := to_date(value_array(i__),
                                                                                                        rasdi_client.c_date_format);
        elsif upper(name_array(i__)) =
              upper('B10compileyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10compileyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101version_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101version(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10application_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10application(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101label_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101label(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10owner_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10owner(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101PROGRAM_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101PROGRAM(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101text1id_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101text1id(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10editor_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10editor(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10lobid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10lobid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101text2id_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101text2id(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10PRAVICE_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10PRAVICE(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LBLOKI_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LBLOKI(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101referenceyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101referenceyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B101change_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B101change(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := to_date(value_array(i__),
                                                                                                         rasdi_client.c_date_format);
        end if;
      end loop;
      v_max := 0;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10rid.count > v_max then
        v_max := B10rid.count;
      end if;
      if B10formid.count > v_max then
        v_max := B10formid.count;
      end if;
      if B10form.count > v_max then
        v_max := B10form.count;
      end if;
      if B10version.count > v_max then
        v_max := B10version.count;
      end if;
      if B10engineid.count > v_max then
        v_max := B10engineid.count;
      end if;
      if B10change.count > v_max then
        v_max := B10change.count;
      end if;
      if B10compileyn.count > v_max then
        v_max := B10compileyn.count;
      end if;
      if B10application.count > v_max then
        v_max := B10application.count;
      end if;
      if B10owner.count > v_max then
        v_max := B10owner.count;
      end if;
      if B10editor.count > v_max then
        v_max := B10editor.count;
      end if;
      if B10lobid.count > v_max then
        v_max := B10lobid.count;
      end if;
      if B10PRAVICE.count > v_max then
        v_max := B10PRAVICE.count;
      end if;
      if B10LBLOKI.count > v_max then
        v_max := B10LBLOKI.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10rid.exists(i__) then
          B10rid(i__) := null;
        end if;
        if not B10formid.exists(i__) then
          B10formid(i__) := to_number(null);
        end if;
        if not B10form.exists(i__) then
          B10form(i__) := null;
        end if;
        if not B10version.exists(i__) then
          B10version(i__) := to_number(null);
        end if;
        if not B10engineid.exists(i__) then
          B10engineid(i__) := to_number(null);
        end if;
        if not B10change.exists(i__) then
          B10change(i__) := to_date(null);
        end if;
        if not B10compileyn.exists(i__) or B10compileyn(i__) is null then
          B10compileyn(i__) := 'N';
        end if;
        if not B10application.exists(i__) then
          B10application(i__) := null;
        end if;
        if not B10owner.exists(i__) then
          B10owner(i__) := null;
        end if;
        if not B10editor.exists(i__) then
          B10editor(i__) := null;
        end if;
        if not B10lobid.exists(i__) then
          B10lobid(i__) := null;
        end if;
        if not B10PRAVICE.exists(i__) then
          B10PRAVICE(i__) := null;
        end if;
        if not B10LBLOKI.exists(i__) then
          B10LBLOKI(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin

      if lang is null then lang := rasdi_client.c_defaultLanguage; end if;
      null;
    end;
    procedure psubmit is
    begin
      on_submit;
      on_session;
      post_submit;
    end;
    procedure pclear_B10(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 0 = 0 then
        k__ := i__ + 2;
      else
        if i__ > 0 then
          k__ := i__ + 2;
        else
          k__ := 2 + 0;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B10RS(j__) := null;
        B10rid(j__) := null;
        B10formid(j__) := null;
        B10form(j__) := null;
        B10label(j__) := null;
        B10version(j__) := null;
        B10engineid(j__) := null;
        B10change(j__) := null;
        B10compileyn(j__) := null;
        B10application(j__) := null;
        B10owner(j__) := null;
        B10editor(j__) := null;
        B10lobid(j__) := null;
        B10PRAVICE(j__) := null;
        B10LBLOKI(j__) := null;
        B10RS(j__) := 'I';
        B10datecompile(j__) := null; 
        B10warning(j__) := null; 
      end loop;
    end;
    procedure pclear_form is
    begin
      GBUTTON1     := 'Search';
      GBUTTON2     := 'Reset';
      GBUTTON3     := 'Save';
      LANG         := null;
      ACTION       := null;
      SPOROCILO    := null;
      Papplication := null;
      Pu := null;
      Pf1 := null;
      KOPIRAJF     := null;
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
      B10formid.delete;
      B10form.delete;
      B10label.delete;
      B10version.delete;
      B10engineid.delete;
      B10change.delete;
      B10compileyn.delete;
      B10application.delete;
      B10owner.delete;
      B10editor.delete;
      B10lobid.delete;
      B10PRAVICE.delete;
      B10LBLOKI.delete;
      B10datecompile.delete;
            B10warning.delete;
      --<pre_select formid="100" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
        xtmsp date;
        vuser varchar2(100) := rasdi_client.secGetUsername;
      begin
        OPEN c__ FOR
          select distinct fg.rowid rid,
                 fg.formid,
                 f.form,
                 f.version,
                 fg.engineid,
                 nvl(f.change, fg.change) change,
                 fg.compileyn,
                 fg.application,
                 fg.owner,
                 fg.editor,
                 fg.lobid , f.label, to_char(f.change,rasdi_client.C_DATE_TIME_FORMAT) datecompiled, f.change,
                 decode (x.id ,  fg.engineid , '' , '1' ) warning
            from RASD_FORMS_COMPILED fg, RASD_FORMS f, (select max(x.engineid) id from rasd_engines x) x
           where fg.formid = f.formid
             and (fg.lobid = f.lobid or
                 fg.lobid is null and f.lobid is null)
             and ((fg.editor = vuser
             and ((fg.lobid = rasdi_client.secGetLOB) or
                 (fg.lobid is null and rasdi_client.secGetLOB is null))
                 ) or (instr(','||rasdi_client.secSuperUsers||',', ','||vuser||',')  > 0 and fg.owner = fg.editor and rasdi_client.secSuperUsers is not null))
             and (fg.application = papplication or papplication is null)
             and (f.version = pdav or pdav is null)

             and (upper(fg.editor) = upper(pu) or pu is null)
             and (--upper(f.form) like upper('%'||pf1||'%') or pf1 is null
                  f.formid in (select formid from rasd_triggers x where upper(x.triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf1||'%')
union
select formid  from rasd_links where upper(linkid||':'||link||':'||text) like upper('%'||pf1||'%')
union
select formid  from rasd_fields f where upper(f.fieldid||':'||f.blockid||':'||f.defaultval||':'||nameid||':'||label) like upper('%'||pf1||'%')
union
select formid from rasd_blocks where upper(blockid||':'||sqltable||':'||sqltext||':'||label) like upper('%'||pf1||'%')
union
select formid from rasd_forms where upper(form||':'||label) like upper('%'||pf1||'%')) and pf1 is not null or pf1 is null
             )
           order by decode(pda, 'Y', f.change , null) desc , fg.lobid, fg.owner, f.form;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10rid(i__),
                 B10formid(i__),
                 B10form(i__),
                 B10version(i__),
                 B10engineid(i__),
                 B10change(i__),
                 B10compileyn(i__),
                 B10application(i__),
                 B10owner(i__),
                 B10editor(i__),
                 B10lobid(i__),
                 B10label(i__),
                 B10datecompile(i__),
                 xtmsp,
                 B10warning(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10PRAVICE(i__) := null;
            B10LBLOKI(i__) := null;
            B10RS(i__) := 'U';

            --<post_select formid="100" blockid="B10">

            declare
              v_st number;
            begin

              select count(*)
                into v_st
                from RASD_FIELDS
               where formid = b10formid(i__);
              if v_st = 0 then
                B10LBLOKI(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Form source', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpod.jpg" width=21 border=0 >';
              else
                B10LBLOKI(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Form source', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpodred.jpg" width=21 border=0 >';
              end if;

              B10form(i__) := upper(B10form(i__));

            end;
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10RS.delete(1);
          B10rid.delete(1);
          B10formid.delete(1);
          B10form.delete(1);
          B10label.delete(1);
          B10version.delete(1);
          B10engineid.delete(1);
          B10change.delete(1);
          B10compileyn.delete(1);
          B10application.delete(1);
          B10owner.delete(1);
          B10editor.delete(1);
          B10lobid.delete(1);
          B10PRAVICE.delete(1);
          B10LBLOKI.delete(1);
          B10datecompile.delete(1);
          B10warning.delete(1);
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
        --<on_validate formid="100" blockid="B10">
        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          if B10form(i__) is not null or B10version(i__) is not null or
             B10application(i__) is not null then
            --<pre_insert formid="100" blockid="B10">
            b10change(i__) := sysdate;
            b10owner(i__) := rasdi_client.secGetUsername;
            b10editor(i__) := b10owner(i__);
            b10lobid(i__) := rasdi_client.secGetLOB;

            select nvl(max(formid), 0) + 1
              into b10formid(i__)
              from RASD_FORMS;

            if b10version(i__) is null then
              b10version(i__) := 1;
            end if;
            
            b10form(i__) := rasdc_library.prepareName(b10form(i__));

            --</pre_insert>
            insert into RASD_FORMS_COMPILED
              (formid,
               engineid,
               change,
               compileyn,
               application,
               owner,
               editor,
               lobid)
            values
              (B10formid(i__),
               B10engineid(i__),
               B10change(i__),
               B10compileyn(i__),
               B10application(i__),
               B10owner(i__),
               B10editor(i__),
               B10lobid(i__));
            --<post_insert formid="100" blockid="B10">
            insert into RASD_FORMS
              (formid,
               lobid,
               form,
               version,
               label,
               program,
               text1id,
               text2id,
               referenceyn,
               change)
            values
              (b10formid(i__),
               b10lobid(i__),
               trim(upper(b10form(i__))),
               b10version(i__),
               '',
               '?', --'!' || lower(b10form(i__)) || '.webclient',
               null,
               null,
               'N',
               sysdate);
               
               PDA := 'Y';
               
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if B10form(i__) is null and B10version(i__) is null then
            --DELETE
            --<pre_delete formid="100" blockid="B10">
            declare
              v_formid RASD_FORMS.formid%type;
            begin

              select formid
                into v_formid
                from RASD_FORMS_COMPILED
               where rowid = b10rid(i__);
               
              if rasdc_library.allowEditing(v_formid) then

              RASDC_LIBRARY.deleteForm(v_formid);

              delete RASD_FORMS_COMPILED where ROWID = B10rid(i__);

             end if; 
            end;
            --</pre_delete>
            --<post_delete formid="100" blockid="B10">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="100" blockid="B10">


            b10change(i__) := sysdate;
            --</pre_update>
            --<post_update formid="100" blockid="B10">
            declare
              v_formid RASD_FORMS.formid%type;
            begin
              select formid
                into v_formid
                from RASD_FORMS_COMPILED
               where rowid = b10rid(i__);
               
            if rasdc_library.allowEditing(v_formid) then

            update RASD_FORMS_COMPILED
               set engineid    = B10engineid(i__),
                   --change      = B10change(i__),
                   compileyn   = B10compileyn(i__),
                   application = B10application(i__)
             where ROWID = B10rid(i__);


              update RASD_FORMS
                 set form    = b10form(i__),
                     version = b10version(i__)
                     --change  = sysdate
               where formid = v_formid;

            end if;

            end;

            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="100" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
      end if;
      --<post_commit formid="100" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB10 pls_integer;
      vuser varchar2(100) := rasdi_client.secGetUsername;
      --povezavein
      procedure js_LBLOKI_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LBLOKI%' then
--          htp.prn('''!rasdc_blocksonform.program?ACTION=' ||
--                  RASDI_TRNSLT.text('Search', lang) || '&PFORMID=' ||
          htp.prn('''!rasdc_blocksonform.program?PFORMID=' ||
                  replace(B10formid(to_number(substr(name,
                                                     instr(name, '_', -1) + 1))),
                          '"',
                          '&quot;') || '&LANG=''+document.RASDC_FORMS.LANG.value+
''''');
        elsif name is null then
--          htp.prn('''!rasdc_blocksonform.program?ACTION=' ||
--                  RASDI_TRNSLT.text('Search', lang) || '&PFORMID=' ||
          htp.prn('''!rasdc_blocksonform.program?PFORMID=' ||
                  replace(B10formid(1), '"', '&quot;') || '&LANG=''+document.RASDC_FORMS.LANG.value+
''''');
        end if;
      end;
      procedure js_PRAVICE_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10PRAVICE%' then
          htp.prn('''!f_pravice.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&PFORMID=' ||
                  replace(B10formid(to_number(substr(name,
                                                     instr(name, '_', -1) + 1))),
                          '"',
                          '&quot;') || '&LANG=''+document.RASDC_FORMS.LANG.value+
''''');
        elsif name is null then
          htp.prn('''!f_pravice.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&PFORMID=' ||
                  replace(B10formid(1), '"', '&quot;') || '&LANG=''+document.RASDC_FORMS.LANG.value+
''''');
        end if;
      end;
      --SQL
      procedure js_APLIKACIJE_LOV(value varchar2,
                                  name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_APLIKACIJE_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_GENERATORJI_LOV(value varchar2,
                                   name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_GENERATORJI_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      --TEXT
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
      htp.p('function js_APLIKACIJE_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="100" linkid="APLIKACIJE_LOV">
                  select '' id, '' label, 1 x
                    from dual
                  union
            select distinct fg.application id,
                            fg.application label,
                            2              x
            from RASD_FORMS_COMPILED fg, RASD_FORMS f
           where fg.formid = f.formid
             and (fg.lobid = f.lobid or
                 fg.lobid is null and f.lobid is null)
             and ((fg.editor = vuser 
             and ((fg.lobid = rasdi_client.secGetLOB) or
                 (fg.lobid is null and rasdi_client.secGetLOB is null))
                 ) or (instr(rasdi_client.secSuperUsers, vuser)  > 0 and fg.owner = fg.editor))
            order by 3, 1
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_GENERATORJI_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="100" linkid="GENERATORJI_LOV">
                  select engineid id, server label
                    from RASD_ENGINES t
                   where exists (select 1 from all_procedures where object_type = 'PACKAGE' and object_name = upper(t.server)) 
                     and exists (select 1 from all_procedures where object_type = 'PACKAGE' and object_name = upper(t.client)) 
                   order by engineid desc
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      --js TEXT
      --js TF
      
      htp.prn('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('</SCRIPT>');
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">  <META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'

<SCRIPT LANGUAGE="Javascript1.2">

 $(function() {
     addSpinner();   
  });	

function js_kliksubmit() {
  document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              ''';
  document.RASDC_FORMS.submit();
}
</SCRIPT>
</HEAD>
<BODY>
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_FORMS_LAB">');
      RASDC_LIBRARY.showphead(RASDI_TRNSLT.text('Forms', lang),
                                 '<li> <a href="!rasdc_forms.program?LANG='||lang||'" class="active"><span>'||RASDI_TRNSLT.text('List of forms',lang)||'</span></a></li><li> <a href="!rasdc_versions.webclient?LANG='||lang||'" ><span>'||RASDI_TRNSLT.text('Versions',lang)||'</span></a></li>',
                                 vuser,
                                 LANG,
                                 'RASDC_FORMSpomoc');
      htp.prn('</FONT>
<FORM NAME="RASDC_FORMS" METHOD="POST" ACTION="!rasdc_forms.program">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="KOPIRAJF" TYPE="HIDDEN" VALUE CLASS="HIDDEN">
<P align="right">
<INPUT  type="hidden" name="ACTION" id="ACTION">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_FORMS.submit(); this.disabled = true;  ">
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" name="ACTION">
</P>');

declare
 v_new varchar2(32000);
begin

 v_new := replace(trim(RASDC_LIBRARY.rasdversionchanges(sysdate - 5 )),'
','</br>');

 if v_new is not null then 
htp.p('
<p>
<div style="background-color: rgb(169, 248, 149); font-size: 11px;">'||RASDI_TRNSLT.text('New in RASD', LANG)||v_new||'
</div>
</p>');
 end if;
end;

htp.p('
<table border="0"><tr><td>
' || RASDI_TRNSLT.text('Application', LANG) ||
              '</td><td><select name="Papplication" onchange="js_kliksubmit();" CLASS="SELECT">');
      js_APLIKACIJE_LOV(Papplication, 'Papplication');
      htp.prn('</select></td><td>
<A  href="javascript: js_kliksubmit();"><img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Search', lang) || '"  ></A>
<A  href="?ACTION=Clear&PDA=Y"><img src="rasdc_files.showfile?pfile=pict/gumbnov.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Create new form', lang) || '"  ></A>

');
      rasdc_hints.link('RASDC_FORMS', lang);
htp.p('
<a href="javascript: var x = window.open(encodeURI(''!rasdc_upload.page?pakcija=Nov''),'''',''scrollbars=1,width=600,height=300'');">
<img height="20" alt="Upload" title="Upload" src="rasdc_files.showfile?pfile=pict/gumbupload.jpg" width="21" border="0"></a>
</td></tr>
<tr><td>
');

htp.p(RASDI_TRNSLT.text('Text', LANG)||'</td><td><input type="text" size="30" name="PF1" id="PF1" value="'||pf1||'" /></td></tr><tr><td>');
htp.p(RASDI_TRNSLT.text('Version', LANG)||'</td><td><input type="text" size="30" name="PDAV" id="PDAV" value="'||pdav||'" /></td></tr><tr><td>');
htp.p(RASDI_TRNSLT.text('My forms', LANG)||'</td><td><input type="checkbox" ');
if PU is not null then htp.p(' checked '); end if;
htp.p(' size="30" name="PU" id="PU" value="'||vuser||'" />');
htp.p(RASDI_TRNSLT.text('Order by date', LANG)||' <input type="checkbox" ');
if PDA is not null then htp.p(' checked '); end if;
htp.p(' size="30" name="PDA" id="PDA" value="Y" /></td>
</tr></table>');

      htp.prn('
<TABLE BORDER="1" cellspacing="0" cellpadding="2">
<CAPTION>
<FONT ID="B10_LAB"> </FONT></CAPTION><TR>
<TD class="label" align="center"><FONT ID="B10form_LAB">' ||
              RASDI_TRNSLT.text('Form', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10version_LAB">' ||
              RASDI_TRNSLT.text('Comp. date', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10version_LAB">' ||
              RASDI_TRNSLT.text('Version', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10engineid_LAB">' ||
              RASDI_TRNSLT.text('Engine', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10compileyn_LAB">' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10application_LAB">' ||
              RASDI_TRNSLT.text('Application', lang) || '</FONT></TD>
<TD class="label" align="center"><FONT ID="B10owner_LAB">' ||
              RASDI_TRNSLT.text('Own./Dev./LOB', lang) || '</FONT></TD>
<TD class="label" align="center"></TD>
<TD class="label" align="center"></TD>
<TD class="label" align="center"></TD>
<TD class="label" align="center"></TD>
</TR>
');


                 
      for iB10 in 1 .. B10RS.count loop
        htp.prn('<TR ID="B10_BLOK" onmouseover="javascript:style.backgroundColor=''#E9E9E9''" onmouseout="javascript:style.backgroundColor=''#ffffff''">
<INPUT NAME="B10RS_' || iB10 || '" TYPE="HIDDEN" VALUE="' ||
                B10RS(iB10) || '" CLASS="HIDDEN">
<INPUT NAME="B10RID_' || iB10 || '" TYPE="HIDDEN" VALUE="' ||
                B10rid(iB10) || '" CLASS="HIDDEN">
<TD><INPUT NAME="B10form_' || iB10 ||
                '" TYPE="TEXT" VALUE="' || B10form(iB10) ||
                '" CLASS="TEXT">
    <FONT size="1">'|| 
    
  '<A class="A" href="javascript: location=encodeURI(');
        js_LBLOKI_POV(B10LBLOKI(iB10), 'B10LBLOKI_' || iB10 || '');
        htp.prn(')" name="B10LBLOKI_' || iB10 || '">' || B10label(iB10) ||
                '</A>'  
    
    
    ||' (<FONT ID="B10formid_' || iB10 ||
                '" CLASS="FONT">'  || B10formid(iB10) ||
                '</FONT>)</FONT>');
if  B10warning(iB10) is not null then
  htp.p('<IMG height="20" title="' ||
                  RASDI_TRNSLT.text('You are still using old version of engine.', lang) ||
                  '" src="rasdc_files.showfile?pfile=pict/gumbwarning.png" width="21" border="0">');
end if;               
                
htp.p('</TD>

<TD><FONT size="1">' || B10datecompile(iB10) || '</FONT></TD>

<TD><INPUT NAME="B10version_' || iB10 ||
                '" TYPE="TEXT" VALUE="' || B10version(iB10) ||
                '" CLASS="TEXT"></TD>
<TD><SELECT NAME="B10engineid_' || iB10 ||
                '" CLASS="SELECT">');
        js_GENERATORJI_LOV(B10engineid(iB10), 'B10engineid_' || iB10 || '');
        htp.prn('</SELECT></TD>
<TD><INPUT NAME="B10compileyn_' || iB10 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10compileyn(iB10),
                              'B10compileyn_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B10application_' || iB10 ||
                '" TYPE="TEXT" VALUE="' || B10application(iB10) || '" CLASS="TEXT"></TD>

<TD><FONT size="1"> '|| B10owner(iB10)||'/'||B10editor(iB10)||'/'|| B10lobid(iB10) || '</FONT></TD>

<TD>


');
        if B10formid(iB10) is not null then
/*
          htp.prn('
<A class="A" NAME="B10PRAVICE_' || iB10 ||
                  '" href="javascript: var x = window.open(');
          js_PRAVICE_POV(B10PRAVICE(iB10), 'B10PRAVICE_' || iB10 || '');
          htp.prn(',''j'',''width=400,height=400'')">
<IMG height="20" title="' ||
                  RASDI_TRNSLT.text('Dodaj pravice', lang) ||
                  '" src="rasdc_files.showfile?pfile=pict/gumbpravice.jpg" width="21" border="0">' ||
                  B10PRAVICE(iB10) || '
</A>
');*/
          htp.prn('
<A class="A" target="_blank" href="!');

if instr(','||rasdi_client.secSuperUsers||',', ','||vuser||',')  > 0 then
declare
 n varchar2(300);
begin
select distinct owner  into n 
from all_objects where object_name = B10form(iB10) and object_type = 'PACKAGE';
htp.p(n||'.');
exception when others then null;
--htp.p(B10form(iB10));
null;
end;
end if;

htp.p(B10form(iB10)||'.webclient">
<IMG height="20" title="' ||
                  RASDI_TRNSLT.text('Open form', lang) ||
                  '" src="rasdc_files.showfile?pfile=pict/gumbpravice.jpg" width="21" border="0">
</A>
');
        end if;
        htp.prn('
</TD>
<TD>');
if B10formid(iB10) is not null then
htp.p('
<a align="left" href="javascript: var link=window.open(encodeURI(''!rasdc_share.program?LANG='||lang||'&amp;PFORMID='||B10formid(iB10)||'''),'''',''width=550,height=400,scrollbars=1'')">
<IMG height="20" title="' ||
                  RASDI_TRNSLT.text('Share form', lang) ||
                  '" src="rasdc_files.showfile?pfile=pict/gumbshare.jpg" width="21" border="0">
</a>');
end if;
htp.p('
</TD>
<TD>
');
        if B10formid(iB10) is not null then
          htp.prn('
<A class="A" href="javascript: document.RASDC_FORMS.KOPIRAJF.value=' || '''' ||
                  B10formid(iB10) || '''' || ';document.RASDC_FORMS.submit();">
<IMG height="20" title="' ||
                  RASDI_TRNSLT.text('Copy form', lang) || '" src="rasdc_files.showfile?pfile=pict/gumbcopyblok.jpg" width="21" border="0">
</A>
');
        end if;
        htp.prn('
</TD>
<TD>
');
        if B10formid(iB10) is not null then
          htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                  RASDI_TRNSLT.text('Delete form', lang) || '"
onClick="document.RASDC_FORMS.B10form_' || iB10 ||
                  '.value=''''; document.RASDC_FORMS.B10version_' || iB10 ||
                  '.value=''''; document.RASDC_FORMS.B10application_' || iB10 ||
                  '.value='''';">
');
        end if;
        htp.prn('
</td>
<TD><A class="A" href="javascript: location=encodeURI(');
        js_LBLOKI_POV(B10LBLOKI(iB10), 'B10LBLOKI_' || iB10 || '');
        htp.prn(')" name="B10LBLOKI_' || iB10 || '">' || B10LBLOKI(iB10) ||
                '</A></TD>
</TR>');
      end loop;
      htp.prn('</TABLE>

<table width="100%" border="0"><tr>
');
      if sporocilo is not null then
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
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_FORMS.submit(); this.disabled = true;  ">
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" name="ACTION">
</td>
</tr>
</table>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</BODY></HTML>
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
  
    --<ON_ACTION formid="100" blockid="">
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(100) := rasdi_client.secGetUsername;
      v_form   RASD_FORMS.form%type;
      v_formid RASD_FORMS.formid%type;
    begin   
      rasdi_client.secCheckPermission('RASDC_FORMS', '');
      psubmit;
      IF kopirajf is not null then
        select nvl(max(formid), 0) + 1 into v_formid from RASD_FORMS;
        select form into v_form from RASD_FORMS where formid = kopirajf;
        RASDC_LIBRARY.copyform(kopirajf,
                                    v_formid,
                                    substr(v_form || '_COPY',1,30),
                                    1);
        insert into RASD_FORMS_COMPILED
          (formid,
           engineid,
           change,
           compileyn,
           application,
           owner,
           editor,
           lobid)
          (select v_formid,
                  engineid,
                  sysdate,
                  compileyn,
                  application,
                  vup ,
                  vup ,
                  lobid
             from RASD_FORMS_COMPILED
            where formid = kopirajf
              and editor = vup);

        delete from rasd_elements t where t.formid = v_formid and not exists (select 1 from rasd_attributes a where a.formid = v_formid and a.elementid = t.elementid and a.source in ('V','R')) and nvl(t.source,'G') not in  ('V','R');
        delete from rasd_attributes t where formid = v_formid and not exists (select 1 from rasd_elements a where a.formid = v_formid and a.elementid = t.elementid);
        update rasd_elements set pelementid = 0, elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = v_formid;
        update rasd_attributes set elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = v_formid;


        pselect;
        phtml;
      else
      if action is null then
        action := RASDI_TRNSLT.text('Search', lang);
      end if;
      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        pselect;
        sporocilo := 'Changes are saved.';
        phtml;
      elsif action = RASDI_TRNSLT.text('Search', lang) then
        pselect;
        phtml;
      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;
        phtml;
      end if;
     end if;
    end;
    --</ON_ACTION>
    --<ON_ERROR formid="100" blockid="">
  exception
    when others then    
      htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
</HEAD>
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

    --</ON_ERROR>
  end;
end RASDC_FORMS;
/

