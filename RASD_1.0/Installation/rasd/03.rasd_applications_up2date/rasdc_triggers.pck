create or replace package RASDC_TRIGGERS is
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
create or replace package body RASDC_TRIGGERS is
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
  type cctab is table of varchar2(32000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG: 
20201117 - Char counter changed (UTF8 in Chrome newline has 2bytes and spec char 2byts but in editor counts 1byte - maxSize is set to 32000 chars (32768 in batabase) )    
20201027 - Refershed list of data in CodeMirror helper     
20200410 - Added new compilation message    
20200302 - Solved problem on asistance optimization and code hinter js error
20200123 - Source Asistance optimization     
20200120 - Added Form navigation      
20190617 - Added Form searcher        
20190221 - Added VS - VisualSettings for error, readonly and custom             
20181128 - Added char counter in editor. PL/SQL code is limited to 31905 characters.
20180530 - Added suport for PRE_UI POST_UI BLOCK triggers on engine version 11
20180520 - Added VS - VisualSettings now you can set for selected fileds settings for visible, readonly or disabled        
20180307 - Added __USER_OBJECTS to Hinter    
20171201 - On load focus is put to first code area; On delete trigger new content is reloaded
20160629 - Added log function for RASD.      
20160629 - Added CSS_REF and JS_REF triggers.             
20160627 - Included reference form future.   
20160310 - Included CodeMirror    
20151202 - Included session variables in filters    
20150814 - Added superuser     
20150813 - Changes because of FORM_CSS and FORM_JS
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20201117225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    ACTION           varchar2(4000);
    GBUTTON1         varchar2(4000) := 'Search';
    GBUTTON2         varchar2(4000) := 'Reset';
    LANG             varchar2(4000);
    PBLOKPROZILECNOV varchar2(4000);
    PtriggeridPROC   varchar2(4000);
    sporocilo        varchar2(4000);
    PFORMID          number;
    PBLOKtriggerid   varchar2(4000);
    GBUTTON3         varchar2(4000) := 'Save';
    BAZPROC          varchar2(4000);
    typePROCEDURE    varchar2(4000);
    PREDOGLED     varchar2(4000);
    SESSSTORAGECODEENABLED   varchar2(100);    
    B10RID           rtab;
    B10RS            ctab;
    vcom number;
    B10formid        ctab;
    B10blockid       ctab;
    B10triggerid     ctab;
    B10plsql         cctab;
    B10plsqlspec     cctab;
    b10rform         ctab; 
    B30TEXT          ctab;
         unlink   varchar2(4000);
    PF      varchar2(4000);         
procedure on_session is
    i__ pls_integer := 1;
  begin
    
rasdi_client.sessionStart;

   if ACTION is not null then
begin
rasdi_client.sessionSetValue(to_char(pformid)||'PBLOKTRIGGERID', PBLOKTRIGGERID ); 
rasdi_client.sessionSetValue('PF', pf ); 
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
vc := '';
if PBLOKTRIGGERID is null then vc := rasdi_client.sessionGetValue(to_char(pformid)||'PBLOKTRIGGERID'); PBLOKTRIGGERID  := vc;  end if; 
vc := '';
if PF is null then vc := rasdi_client.sessionGetValue('PF'); PF := vc;  end if; 
exception when others then  null; end;  end if;  

declare vc varchar2(2000); begin
null;
vc := rasdi_client.sessionGetValue('SESSSTORAGECODEENABLED'); SESSSTORAGECODEENABLED  := vc;  
if to_date(vc, 'ddmmyyyyhh24miss') + (1/24) < sysdate then
  SESSSTORAGECODEENABLED := null;
end if;
exception when others then  null; 
  SESSSTORAGECODEENABLED := null;
end;   

  if SESSSTORAGECODEENABLED is null then
begin
 rasdi_client.sessionSetValue('SESSSTORAGECODEENABLED', to_char(sysdate,'ddmmyyyyhh24miss') ); 
exception when others then null; end;
end if; 


 rasdi_client.sessionClose;


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
        elsif upper(name_array(i__)) = upper('UNLINK') then
          unlink := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON1') then
          GBUTTON1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON2') then
          GBUTTON2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PBLOKPROZILECNOV') then
          PBLOKPROZILECNOV := value_array(i__);
        elsif upper(name_array(i__)) = upper('PtriggeridPROC') then
          PtriggeridPROC := value_array(i__);
        elsif upper(name_array(i__)) = upper('SPOROCILO') then
          sporocilo := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('PBLOKtriggerid') then
          PBLOKtriggerid := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON3') then
          GBUTTON3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('BAZPROC') then
          BAZPROC := value_array(i__);
        elsif upper(name_array(i__)) = upper('typePROCEDURE') then
          typePROCEDURE := value_array(i__);
        elsif upper(name_array(i__)) = upper('PF') then
          PF := value_array(i__);          
        elsif upper(name_array(i__)) =
              upper('B10RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10blockid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10blockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10triggerid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10triggerid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10PLSQL_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then                               
          B10plsql(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10PLSQLSPEC_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10plsqlspec(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30TEXT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30TEXT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10RID.count > v_max then
        v_max := B10RID.count;
      end if;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10formid.count > v_max then
        v_max := B10formid.count;
      end if;
      if B10blockid.count > v_max then
        v_max := B10blockid.count;
      end if;
      if B10triggerid.count > v_max then
        v_max := B10triggerid.count;
      end if;
      if B10plsql.count > v_max then
        v_max := B10plsql.count;
      end if;
      if B10plsqlspec.count > v_max then
        v_max := B10plsqlspec.count;
      end if;     
      for i__ in 1 .. v_max loop
        if not B10RID.exists(i__) then
          B10RID(i__) := null;
        end if;
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10formid.exists(i__) then
          B10formid(i__) := null;
        end if;
        if not B10blockid.exists(i__) then
          B10blockid(i__) := null;
        end if;
        if not B10triggerid.exists(i__) then
          B10triggerid(i__) := null;
        end if;
        if not B10plsql.exists(i__) then
          B10plsql(i__) := null;
        end if;
        if not B10plsqlspec.exists(i__) then
          B10plsqlspec(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if B30TEXT.count > v_max then
        v_max := B30TEXT.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B30TEXT.exists(i__) then
          B30TEXT(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      --<POST_SUBMIT formid="5" blockid="">
      if action is null then
        action := RASDI_TRNSLT.text('Search', lang);
      end if;
      --</POST_SUBMIT>
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
        B10RID(j__) := null;
        B10RS(j__) := null;
        B10formid(j__) := null;
        B10blockid(j__) := null;
        B10triggerid(j__) := null;
        B10plsql(j__) := null;
        B10plsqlspec(j__) := null;
        b10rform(j__) := null;
        B10RS(j__) := 'I';

      end loop;
    end;
    procedure pclear_B30(pstart number) is
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
        B30TEXT(j__) := null;

      end loop;
    end;
    procedure pclear_form is
    begin
      ACTION           := null;
      GBUTTON1         := 'Search';
      GBUTTON2         := 'Reset';
      LANG             := null;
      PBLOKPROZILECNOV := null;
      PtriggeridPROC   := null;
      sporocilo        := null;
      PFORMID          := null;
      PBLOKtriggerid   := null;
      GBUTTON3         := 'Save';
      BAZPROC          := null;
      typePROCEDURE    := null;
            PF := null; 
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
      B10RID.delete;
      B10RS.delete;
      B10formid.delete;
      B10blockid.delete;
      B10triggerid.delete;
      B10plsql.delete;
      B10plsqlspec.delete;
      b10rform.delete;

      --<pre_select formid="5" blockid="B10">
      declare
        n number;
      begin
        select count(*) into n from RASD_TRIGGERS where formid = PFORMID;

        if n = 0 then
          action := RASDI_TRNSLT.text('New', lang);
        else

          if pbloktriggerid is null and
             action <> RASDI_TRNSLT.text('New', lang) then

            for r in (select blockid || '/.../' || triggerid id,
                             decode(blockid, null, '', blockid || '  ') ||
                             triggerid label
                        from RASD_TRIGGERS
                       where formid = PFORMID
                       and  instr(triggerid, 'FORM_CSS' ) = 0
                       and  instr(triggerid, 'FORM_JS' ) = 0
                       and  instr(triggerid, 'FORM_UIHEAD' ) = 0
--                       and  triggerid not in ('FORM_CSS', 'FORM_JS','FORM_CSS_REF', 'FORM_JS_REF')
                       order by nvl(blockid, chr(0)), triggerid) loop
              pbloktriggerid := r.id;
              exit;
            end loop;

          end if;
        end if;

      end;
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select rowid     rid,
                 formid    formid,
                 blockid   blockid,
                 triggerid,
                 plsql,
                 plsqlspec,
                 rform
            from RASD_TRIGGERS
           where formid = PFORMID
             and nvl(blockid, '-X') =
                 nvl(substr(pbloktriggerid,
                            1,
                            instr(pbloktriggerid, '/.../') - 1),
                     '-X')
             and triggerid =
                 substr(pbloktriggerid, instr(pbloktriggerid, '/.../') + 5)
             and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')   
                 ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10RID(i__),
                 B10formid(i__),
                 B10blockid(i__),
                 B10triggerid(i__),
                 B10plsql(i__),
                 B10plsqlspec(i__),
                 b10rform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10RS(i__) := 'U';

            --<post_select formid="5" blockid="B10">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10RID.delete(1);
          B10RS.delete(1);
          B10formid.delete(1);
          B10blockid.delete(1);
          B10triggerid.delete(1);
          B10plsql.delete(1);
          B10plsqlspec.delete(1);
          b10rform.delete(1);
          
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10RID.count);
      null;
    end;
    procedure pselect_B30 is
      i__ pls_integer;
    begin
      B30TEXT.delete;
      --<pre_select formid="5" blockid="B30">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select '<A HREF="javascript:var x = window.open(''!RASDC_ERRORS.Program?PPROGRAM=' ||
                 upper(name) || '#' || substr(type, 1, 1) ||
                 substr(type, instr(type, ' ') + 1, 1) || to_char(line) ||
                 ''',''nx'','''');"  style="color: Red;">ERR: (' ||
                 to_char(line) || ',' || to_char(position) || ')  ' || text ||
                 '</a>' text
            from all_errors, RASD_FORMS f
           where upper(name) = upper(f.form)
             and owner = rasdc_library.currentDADUser
             and f.formid = PFORMID
           order by line, position;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B30TEXT(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then

            --<post_select formid="5" blockid="B30">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B30TEXT.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B30(B30TEXT.count);
      null;
    end;
    procedure pselect is
    begin
      if 1 = 1 then
        pselect_B10;
      end if;
      if 1 = 1 then
        pselect_B30;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B10RID.count loop
        --<on_validate formid="5" blockid="B10">
        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          if B10plsql(i__) is not null or B10plsqlspec(i__) is not null then
            --<pre_insert formid="5" blockid="B10">
            b10formid(i__) := PFORMID;

            if PBLOKPROZILECNOV is not null then
              b10blockid(i__) := substr(PBLOKPROZILECNOV,
                                        1,
                                        instr(PBLOKPROZILECNOV, '/.../') - 1);
              b10triggerid(i__) := substr(PBLOKPROZILECNOV,
                                          instr(PBLOKPROZILECNOV, '/.../') + 5);
              PBLOKtriggerid := PBLOKPROZILECNOV;
            else
              b10triggerid(i__) := PtriggeridPROC;
              PBLOKtriggerid := '/.../' || PtriggeridPROC;
            end if;
            --</pre_insert>
            insert into RASD_TRIGGERS
              (formid, blockid, triggerid, plsql, plsqlspec)
            values
              (B10formid(i__),
               B10blockid(i__),
               B10triggerid(i__),
               B10plsql(i__),
               B10plsqlspec(i__));
            --<post_insert formid="5" blockid="B10">
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if B10plsql(i__) is null then
            --DELETE
            --<pre_delete formid="5" blockid="B10">
            --</pre_delete>
            delete RASD_TRIGGERS where ROWID = B10RID(i__) and rform is null;
            --<post_delete formid="5" blockid="B10">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="5" blockid="B10">
            --</pre_update>
            declare
              vtig_first pls_integer;
            begin

              select count(1)
                into vtig_first
                from rasd_triggers_code_types c, rasd_triggers s
               where c.tctype = s.triggerid
                 and c.language = 'P'
                 and s.rowid = B10RID(i__);
              if vtig_first = 0 then

                update RASD_TRIGGERS s
                   set plsql = B10plsql(i__)
                   ,plsqlspec =  B10plsqlspec(i__)
,                   rform  = decode (unlink,'Y',null,rform)
                 where ROWID = B10RID(i__) and (rform is null or unlink = 'Y');
                 

              else

                update RASD_TRIGGERS s
                   set plsql = B10plsql(i__), plsqlspec = B10plsqlspec(i__)
,                   rform  = decode (unlink,'Y',null,rform)
                 where ROWID = B10RID(i__) and (rform is null or unlink = 'Y');

              end if;

            end;
            --<post_update formid="5" blockid="B10">
            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit_B30 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B30TEXT.count loop
        --<on_validate formid="5" blockid="B30">
        --</on_validate>
        if 1 = 2 then
          --INSERT
          null;
        else
          -- UPDATE ali DELETE;

          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="5" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
      end if;
      if 1 = 1 then
        pcommit_B30;
      end if;
      --<post_commit formid="5" blockid="">
      update RASD_FORMS set change = sysdate where formid = PFORMID;
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB30 pls_integer;
      --povezavein
      --SQL
      procedure js_PBLOKPROZIDNOV_LOV(value varchar2,
                                      name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_PBLOKPROZIDNOV_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_PBLOKPROZID_LOV(value varchar2,
                                   name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_PBLOKPROZID_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      --TEXT
      --TF
      --SQL-T
    begin
      --js povezavein
      --js SQL
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_PBLOKPROZIDNOV_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="5" linkid="PBLOKPROZIDNOV_LOV">
                  select '/.../' || tctype id, tctype label, 1
                    from RASD_TRIGGERS_CODE_TYPES t
                   where t.language = 'P'
                     and t.tclevel = 'F'
                     and not exists (select 1
                            from RASD_TRIGGERS
                           where formid = PFORMID
                             and blockid is null
                             and triggerid = t.tctype)
                  union
                  select blockid || '/.../' || tctype id,
                          blockid || '  ' || tctype label,
                          2
                    from RASD_TRIGGERS_CODE_TYPES t, RASD_BLOCKS b
                   where b.formid = PFORMID
                     and t.language = 'P'
                     and t.tclevel = 'B'
                     and exists (
                         select 1
                         from rasd_forms_compiled f, rasd_engines e
                         where f.formid = PFORMID
                           and e.engineid = f.engineid
                           and  (e.engineid >= 11 and t.tctype in ('PRE_UI','POST_UI') 
                              or t.tctype not in ('PRE_UI','POST_UI')
                                )                               
                     )
                     and not exists (select 1
                            from RASD_TRIGGERS
                           where formid = PFORMID
                             and blockid = b.blockid
                             and triggerid = t.tctype)
                  union
                  select blockid || fieldid || '/.../' || tctype id,
                          blockid || fieldid || '  ' || tctype label,
                          2
                    from RASD_TRIGGERS_CODE_TYPES t, RASD_FIELDS b
                   where b.formid = PFORMID
                     and t.language = 'P'
                     and t.tclevel = 'D'
                     and b.element = 'PLSQL_'
                     and not exists (select 1
                            from RASD_TRIGGERS
                           where formid = PFORMID
                             and blockid = b.blockid||b.fieldid
                             and triggerid = t.tctype)
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
      htp.p('function js_PBLOKPROZID_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="5" linkid="PBLOKPROZID_LOV">
                  select blockid || '/.../' || triggerid id,
                          decode(blockid, null, '', blockid || '  ') ||
                          triggerid label
                    from RASD_TRIGGERS
                   where formid = PFORMID
                     and  instr(triggerid, 'FORM_CSS' ) = 0
                     and  instr(triggerid, 'FORM_JS' ) = 0
                     and  instr(triggerid, 'FORM_UIHEAD' ) = 0
--                   and  triggerid not in ('FORM_CSS', 'FORM_JS','FORM_CSS_REF', 'FORM_JS_REF')
                     and  blockid || '/.../' || triggerid in 
                     (
select x.blockid || '/.../' || x.triggerid from rasd_triggers x where upper(x.triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%') and formid = pformid                                         
                     ) 
                   order by nvl(blockid, chr(0)), triggerid
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
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
  ');
  
/*  
htp.p('
<STYLE>

.CodeMirror {
  font-size: 140%; 
}

.CodeMirror-hints {
  font-size: 130%;
}

</STYLE>
');
*/
htp.p('
<SCRIPT LANGUAGE="Javascript1.2">

 $(function() {
     addSpinner();   
  });
  
</SCRIPT>

<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTA(document.RASDC_TRIGGERS.B10PLSQL_1);
  resizeTW(document.RASDC_TRIGGERS.B10PLSQLSPEC_1);
}
function onLoad() {
  onResize();
    
  // var myCodeMirror = CodeMirror.fromTextArea(B10PLSQL_1);  
}

function js_kliksubmit(p) {
    document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              ''';
  document.RASDC_TRIGGERS.submit();
}

</SCRIPT>
</HEAD>
<BODY onload="onLoad();" onresize="onResize();">
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_TRIGGERS_LAB">');
      RASDC_LIBRARY.showhead('RASDC_TRIGGERS',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
      htp.prn('</FONT>

<FORM NAME="RASDC_TRIGGERS" METHOD="POST" ACTION="!rasdc_triggers.program">
<P align="right">
<INPUT  type="hidden" name="ACTION" id="ACTION">
<INPUT NAME="SESSSTORAGECODEENABLED" TYPE="hidden" VALUE="1" CLASS="HIDDEN">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Form navigator', lang) ||
              '" onclick="javascript: this.type=''reset''; var p_y1 = window.open(encodeURI(''!RASDC_EXECUTION.Program?LANG='||lang||'&PFORMID='||pformid||'''),''p_y1'',''width=850,height=400,resizable=1'');">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_TRIGGERS.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_TRIGGERS.submit(); this.disabled = true; ">');
end if;
htp.p('

<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) ||
              '" name="ACTION">
' || predogled || '
</P>

<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID || '" CLASS="HIDDEN">
<TABLE BORDER="0" width="100%" style="');

              if b10rform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;
htp.prn('">
<CAPTION  style="width: 100%; text-align: left;"><FONT ID="B10_LAB">

');
      if ACTION <> RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<B>' || RASDI_TRNSLT.text('PL/SQL', lang) ||
                '&nbsp;<SELECT ID="pBLOKtriggerid" NAME="PBLOKtriggerid" CLASS="SELECT" onchange="js_kliksubmit();">');
        js_PBLOKPROZID_LOV(PBLOKtriggerid, 'PBLOKtriggerid');
        htp.prn('</SELECT>
<input type="text" size="30" name="PF" onchange="js_kliksubmit();" id="PF" value="'||pf||'" title="'||RASDI_TRNSLT.text('Form searcher ...', lang) ||'">                            
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
                RASDI_TRNSLT.text('Search', lang) ||
                '""  onClick="js_kliksubmit();">
<img src="rasdc_files.showfile?pfile=pict/gumbnov.jpg" border="0" title="' ||
                RASDI_TRNSLT.text('New trigger', lang) ||
                '"onClick="location=''!RASDC_TRIGGERS.program?ACTION=' ||
                RASDI_TRNSLT.text('New', lang) || '&LANG=' || lang ||
                '&PFORMID=' || PFORMID ||
                '''"">
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                RASDI_TRNSLT.text('Delete trigger', lang) || '"
onClick="window.editor.setValue(''''); window.editor1.setValue('''');  document.RASDC_TRIGGERS.pBLOKtriggerid.value=''''">
</B>
');
--document.RASDC_TRIGGERS.B10PLSQLSPEC_1.value=''''; document.RASDC_TRIGGERS.B10PLSQL_1.value='''';
        rasdc_hints.link('RASDC_TRIGGERS', lang);
        htp.prn('
');
      else
        /**/
        htp.prn('
' || RASDI_TRNSLT.text('Trigger', lang) ||
                ':<INPUT type="radio" CHECKED name="typePROCEDURE" onclick="document.RASDC_TRIGGERS.B10PLSQLSPEC_1.disabled=1; document.RASDC_TRIGGERS.PtriggeridPROC.disabled=1;document.RASDC_TRIGGERS.PBLOKPROZILECNOV.disabled=0;document.RASDC_TRIGGERS.BAZPROC.checked=0">
&nbsp;&nbsp;&nbsp; ' ||
                RASDI_TRNSLT.text('PL/SQL procedure', lang) || ':<INPUT type="radio" name="typePROCEDURE" onclick="document.RASDC_TRIGGERS.B10PLSQLSPEC_1.disabled=1;document.RASDC_TRIGGERS.PtriggeridPROC.disabled=0;document.RASDC_TRIGGERS.PBLOKPROZILECNOV.disabled=1;
if (document.RASDC_TRIGGERS.PtriggeridPROC.value.length==0) {document.RASDC_TRIGGERS.PtriggeridPROC.value=''FuncProcBlockName'';}
if (document.RASDC_TRIGGERS.B10PLSQL_1.value.length==0) {document.RASDC_TRIGGERS.B10PLSQL_1.value=''--\n-- types should be in your first custom pl/sql procedure\n-- otherwise function/procedures will follow generated\n-- types and there will be an error in code\n--\n\n  type myNewGlobalPackageType is table of varchar2(10) index by binary_integer;\n\n  myNewGlobalPackageConstant constant number := 0;\n\n  myNewGlobalPackageVariable date;\n\n  function myNewFunction(pParameterIn varchar2 ) return integer is\n    myNewLocalVariable integer;\n  begin\n    -- my New Code\n    return( myNewLocalVariable );\n  end;'';}
">
&nbsp;(' || RASDI_TRNSLT.text('public', lang) ||
                '&nbsp; <INPUT NAME="BAZPROC" onclick="if (document.RASDC_TRIGGERS.BAZPROC.checked) {document.RASDC_TRIGGERS.B10PLSQLSPEC_1.disabled=0; document.RASDC_TRIGGERS.typePROCEDURE.checked=1; if (document.RASDC_TRIGGERS.PtriggeridPROC.value.length==0) {document.RASDC_TRIGGERS.PtriggeridPROC.value=''FuncProcBlockName'';} if (document.RASDC_TRIGGERS.B10PLSQLSPEC_1.value.length==0) {document.RASDC_TRIGGERS.B10PLSQLSPEC_1.value=''  type myNewGlobalProjectType is table of varchar2(10) index by binary_integer;\n\n  myNewGlobalProjectConstant constant number := 0;\n\n  myNewGlobalProjectVariable date;\n\n  function myNewFunction(pParameterIn varchar2 ) return integer;'';} if (document.RASDC_TRIGGERS.B10PLSQL_1.value.length==0) {document.RASDC_TRIGGERS.B10PLSQL_1.value=''  type <TypeName> is <Datatype>;\n\n  <ConstantName> constant <Datatype> := <Value>;\n\n  <VariableName> <Datatype>;\n\n  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is\n    <LocalVariable> <Datatype>;\n  begin\n    <Statement>;\n    return(<Result>);\n  end;'';}}else{document.RASDC_TRIGGERS.B10PLSQLSPEC_1.disabled=1;} document.RASDC_TRIGGERS.PtriggeridPROC.disabled=0;document.RASDC_TRIGGERS.PBLOKPROZILECNOV.disabled=1;" TYPE="CHECKBOX" CLASS="CHECKBOX">)
<SELECT name="PBLOKPROZILECNOV" CLASS="SELECT">');
        js_PBLOKPROZIDNOV_LOV(PBLOKPROZILECNOV, 'PBLOKPROZILECNOV');
        htp.prn('</SELECT><INPUT disabled name="PtriggeridPROC" TYPE="TEXT" VALUE="' ||
                PtriggeridPROC || '" CLASS="TEXT">
');
        rasdc_hints.link('RASDC_TRIGGERS', lang);
        htp.prn('
');
      end if; /**/

      htp.prn('
</FONT></CAPTION><TR></TR>
<TR ID="B10_BLOK"><INPUT NAME="B10RID_1" TYPE="HIDDEN" VALUE="' ||
              B10RID(1) ||
              '" CLASS="HIDDEN"><INPUT NAME="B10RS_1" TYPE="HIDDEN" VALUE="' ||
              B10RS(1) || '" CLASS="HIDDEN">
<TD>
<TEXTAREA title="' ||
              RASDI_TRNSLT.text('PL/SQL code', lang) ||
              '" style="FONT-SIZE: 8pt; font-face: Lucida Console" name="B10PLSQL_1" id="B10PLSQL_1" rows="30" cols="80" CLASS="TEXTAREA">' ||
              B10plsql(1) || '</TEXTAREA></br>
              <div id="B10PLSQLCOUNT_1"></div></br>
              Press CTRL+SPACE to open variable list.</TD>
<TD>
<TEXTAREA title="' ||
              RASDI_TRNSLT.text('Package specification area, Default code',
                                lang) ||
              '" style="FONT-SIZE: 8pt; font-face: Lucida Console" name="B10PLSQLSPEC_1" id="B10PLSQLSPEC_1" rows="30" cols="20" CLASS="TEXTAREA">' ||
              B10plsqlspec(1) || '</TEXTAREA>  <br/>
              <div id="B10PLSQLSPECCOUNT_1"></div></br></TD>
</TR>
</TABLE>

<script>

  
window.onload = function() {
  var mime = ''text/x-plsql'';
  // get mime type
  if (window.location.href.indexOf(''mime='') > -1) {
    mime = window.location.href.substr(window.location.href.indexOf(''mime='') + 5);
  }
');  



htp.prn('var rasdhintoptions;');
if SESSSTORAGECODEENABLED is null then 

htp.prn('rasdhintoptions = ''');
declare

function add_attributes(powner varchar2, pname varchar2, pprocedure varchar2) return varchar2 is
   v_ret varchar2(32000);
 begin
for r in (   
select x.argument_name, x.data_type from all_arguments x where 
  x.owner = powner
  and x.object_name = pprocedure
  and x.package_name = pname
  and x.argument_name is not null
order by sequence
) loop
v_ret := v_ret||','||r.argument_name||' '||r.data_type;
end loop;
if v_ret is null then
   return '';
else    
   return '('||substr(v_ret,'2')||')';
end if; 
end;

function add_columns (powner varchar2, pname varchar2) return varchar2 is 
 v_fir number := 1;
 v_ret varchar2(32000) := '';
 begin  
   
for r in (
select a.owner, a.table_name o_name,a.column_name c_name, a.column_id vr, 'T' vir from all_tab_columns a
where a.owner = powner
  and column_name is not null
  and a.table_name = pname
  and a.column_name not like '%$%'
  and a.column_name not like '%#%' 
union
select p.owner, p.object_name, p.procedure_name , p.subprogram_id  , 'P' from all_procedures p 
where p.owner = powner
  and procedure_name is not null
  and p.object_name = pname
  and p.procedure_name not like '%$%'
  and p.procedure_name not like '%#%' 
order by vr  
) loop
if r.vir = 'P' then
  if v_fir = 1 then 
--v_ret := v_ret ||'       "'||r.c_name||add_attributes(powner, pname,r.c_name)||'": {} ';       
v_ret := v_ret ||'       "'||r.c_name||add_attributes(powner, pname,r.c_name)||'" ';       
     v_fir := 2;
  else
--v_ret := v_ret ||'      , "'||r.c_name||add_attributes(powner, pname,r.c_name)||'": {} ';          
v_ret := v_ret ||'      , "'||r.c_name||add_attributes(powner, pname,r.c_name)||'" ';          
  end if;
else
  if v_fir = 1 then 
--v_ret := v_ret ||'       "'||r.c_name||'": {} ';       
v_ret := v_ret ||'       "'||r.c_name||'" ';       
     v_fir := 2;
  else
--v_ret := v_ret ||'      , "'||r.c_name||'": {} ';          
v_ret := v_ret ||'      , "'||r.c_name||'" ';          
  end if; 
end if;  
end loop;

return v_ret;
 end;
begin 
for r in (
                  select /*+ RULE*/ owner ,OBJECT_NAME id,
                          OBJECT_NAME || ' ... ' || substr(object_type, 1, 1) label,
                          2 x--, object_type type
                    from all_objects
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                     and object_name not like '%$%'
                  union
                  select /*+ RULE*/ distinct table_owner , SYNONYM_NAME id,
                                   SYNONYM_NAME || ' ... S' label,
                                   2 x--, 'TABLE' type
                    from user_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and s.table_name not like '%$%'
                     --and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner , table_name id,
                          owner||'.'||table_name  /*|| ' ... ' || substr(type, 1, 1) */ label, 2 x --, type
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and
                    grantee = rasdc_library.currentDADUser  
                    and table_name not like '%$%'                   
                   order by  1, 2   
                  -- fetch first 5 row only
) loop
--  if nvl(v_xxx,'XYX') <> nvl(r.owner,'YXY') then
--     v_xxx := r.owner;
--htp.p('    }, "'||r.owner||'.XXX": {"'||r.id||'": {'); add_columns (r.owner, r.id); htp.p('} ');    --'); add_columns (r.owner, r.id); htp.p('
--  else 
--htp.p('      , "'||r.id||'": {'); add_columns (r.owner, r.id); htp.p('} ');   
--  end if;      
--htp.prn('      , "'||r.owner||'.'||r.id||'": {');
htp.prn('      , "'||r.owner||'.'||r.id||'": [');
htp.prn( add_columns (r.owner, r.id) );
--htp.prn('} ');   
htp.prn('] ');   
end loop;
end; 
htp.p(''';');
 
htp.p('sessionStorage.setItem("rasdi$B10PLSQL",rasdhintoptions);'); 
htp.p('document.getElementsByName("SESSSTORAGECODEENABLED").value="1";');
else
htp.p('var rasdhintoptions = sessionStorage.getItem("rasdi$B10PLSQL"); if (rasdhintoptions == null) {rasdhintoptions = '''';} ');
end if;  


htp.prn('var rasdhintoptionsuser = ''');
htp.prn(' {tables: { ');
htp.prn(' __RASD_VARIABLES: {},');      
for r in (  SELECT blockid, fieldid, blockid||fieldid polje
            FROM RASD_FIELDS
           where formid = PFORMID
           order by nvl(blockid,'.'), fieldid) loop
htp.prn('      "'||r.polje||'": {},');          
end loop;
for r in (  SELECT blockid, fieldid, blockid||fieldid||'#SET' polje
            FROM RASD_FIELDS f
           where formid = PFORMID
             and includevis = 'Y'
           order by nvl(blockid,'.'), fieldid) loop
htp.prn('      "'||r.polje||'.visible":{},');          
htp.prn('      "'||r.polje||'.disabled":{},');          
htp.prn('      "'||r.polje||'.readonly":{},');
htp.prn('      "'||r.polje||'.required":{},');   
htp.prn('      "'||r.polje||'.error":{},');
htp.prn('      "'||r.polje||'.info":{},');
htp.prn('      "'||r.polje||'.custom":{},');       
end loop;
htp.prn('"__RASD_PROCEDURES:" : {},');
htp.prn('"rlog( message VARCHAR2 );" : {},');
htp.prn('"htpClob( text CLOB );" : {},');
htp.prn('"openLOV( p_lov varchar2,  p_value varchar2) return lovtab__ (label VARHAR2,id VARCHAR2)" : {},');
htp.prn('"version" : {},');
htp.prn('"psubmit(name_array, value_array)" : {},');
htp.prn('"pclear" : {},');
htp.prn('"pselect" : {},');
htp.prn('"pcommit" : {},');
htp.prn('"poutput" : {},');

for rx in (
  select 1 from rasd_forms f where f.formid = pformid
  and f.autocreaterestyn = 'Y'
) loop
htp.prn('"poutputrest" : {},');
htp.prn('"poutputrest() return clob" : {},');
end loop;

for r in (select blockid from rasd_blocks b where b.formid = pformid order by blockid)
loop
htp.prn('"pclear_'||r.blockid||'(pstart number)" : {},');
htp.prn('"pselect_'||r.blockid||'" : {},');
htp.prn('"pcommit_'||r.blockid||'" : {},'); 
end loop;  

htp.prn('      __USER_OBJECTS: {}');

htp.p('''+rasdhintoptions+'); --new line in javascript;

htp.p('''      , __OTHER_FUNCTIONS: {}    }}''  ;');



htp.p(' var rasdhintoptionsobj = eval(''(''+rasdhintoptionsuser+'')'');');


htp.p('
  window.editor1 = CodeMirror.fromTextArea(document.getElementById(''B10PLSQLSPEC_1''), {
    mode: mime,
    indentWithTabs: true,
    smartIndent: true,
    lineNumbers: true,
    matchBrackets : true,
    autofocus: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    hintOptions: rasdhintoptionsobj
  });
  window.editor1.setSize("350","450");  
  
  window.editor1.setOption("maxLength", 10000);
 

window.editor1.on("beforeChange", function (cm, change) {
    var maxLength = cm.getOption("maxLength");
    if (maxLength && change.update) {
        var str = change.text.join("\n");
        var delta = str.length-(cm.indexFromPos(change.to) - cm.indexFromPos(change.from));
        if (delta <= 0) { return true; }
        delta = cm.getValue().length+delta-maxLength;
        document.getElementById("B10PLSQLSPECCOUNT_1").innerHTML = "'||RASDI_TRNSLT.text('Characters left:', lang)||' " + ((delta*-1)+1) ;
        if (delta > 0) {
            str = str.substr(0, str.length-delta);
            change.update(change.from, change.to, str.split("\n"));
        }
    }
    return true;
  
});   

  window.editor = CodeMirror.fromTextArea(document.getElementById(''B10PLSQL_1''), {
    mode: mime,
    indentWithTabs: true,
    smartIndent: true,
    lineNumbers: true,
    matchBrackets : true,
    autofocus: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    hintOptions: rasdhintoptionsobj 
  });
  
  window.editor.setSize("800","450");

  //32768 max each spec char un UTF8 has 2byts but in editor counts 1byte
  window.editor.setOption("maxLength", 32000); 
 

window.editor.on("beforeChange", function (cm, change) {
    var maxLength = cm.getOption("maxLength");
    var isChrome =  window.chrome;
    if (maxLength && change.update) {
        var str = change.text.join("\n");
        var delta = str.length-(cm.indexFromPos(change.to) - cm.indexFromPos(change.from));
        var aaa = cm.doc.getValue();
        if (delta <= 0) { return true; }
        xval = cm.getValue()
        if(isChrome){
          xval = xval.replace(/(\r\n|\n|\r)/g,"  ");
        }          
        delta = xval.length+delta-maxLength;
        document.getElementById("B10PLSQLCOUNT_1").innerHTML = "'||RASDI_TRNSLT.text('Characters left:', lang)||' " + ((delta*-1)+1) ;
        if (delta > 0) {
            str = str.substr(0, str.length-delta);
            change.update(change.from, change.to, str.split("\n"));
        }
    }
    return true;
  
}); 



};
</script>
');




/* stara koda ta hinter z dialogom
htp.p('<div id="dialog" title="Variables">');
for r in (          SELECT blockid, fieldid, blockid||fieldid polje
            FROM RASD_FIELDS
           where formid = PFORMID
           order by nvl(blockid,'.'), fieldid) loop

htp.p('<a href="#" onclick="javascript: prenesi('''||r.polje||''')">'||r.blockid||' '||r.fieldid||'</a><br/>');
--htp.p('<input type="button" onclick="javascript: prenesi('''||r.polje||''')" value="'||r.blockid||' '||r.fieldid||'"/><br/>');           
           
end loop;
htp.p('</div>');

htp.p('<SCRIPT LANGUAGE="Javascript1.2">

function prenesi(pv) {
var myString = document.RASDC_TRIGGERS.B10PLSQL_1.value;
var index = doGetCaretPosition(document.RASDC_TRIGGERS.B10PLSQL_1);
//alert (pv);
//alert(index);
document.RASDC_TRIGGERS.B10PLSQL_1.value = myString.substr(0, index) + pv + myString.substr(index) 
setCaretPosition(document.RASDC_TRIGGERS.B10PLSQL_1, index+pv.length );
$( "#dialog" ).dialog("close");
}


function doGetCaretPosition (ctrl) {
var CaretPos = 0;  
// IE, but not IE10
if (document.selection && navigator.appVersion.indexOf("MSIE 10") == -1) {
ctrl.focus ();
var Sel = document.selection.createRange ();
Sel.moveStart (''character'', -ctrl.value.length);
CaretPos = Sel.text.length;
}
// Normal browsers and IE10
else if (ctrl.selectionStart || ctrl.selectionStart == ''0'')
CaretPos = ctrl.selectionStart;
return (CaretPos);
}
function setCaretPosition(ctrl, pos){
if(ctrl.setSelectionRange)
{
ctrl.focus();
ctrl.setSelectionRange(pos,pos);
}
else if (ctrl.createTextRange) {
var range = ctrl.createTextRange();
range.collapse(true);
range.moveEnd(''character'', pos);
range.moveStart(''character'', pos);
range.select();
}
}

$(document).ready(function() {

    $(''td'').on("keydown", "#B10PLSQL_1", function(e)
    {
        if ((e.keyCode == 10 || e.keyCode == 13|| e.keyCode == 32) && e.ctrlKey)
        {
      $( "#dialog" ).dialog( "open" );
			//alert(doGetCaretPosition(this));
        }
    });	
    
    $( "#dialog" ).dialog({
      autoOpen: false,
			resizable: false,
			height:250
    });


});	
</SCRIPT>');
*/

      if ACTION = RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<SCRIPT LANGUAGE="Javascript">
 document.RASDC_TRIGGERS.B10PLSQLSPEC_1.disabled=1;
</SCRIPT>
');
      end if;
      htp.prn('
<TABLE BORDER="0">
<CAPTION><FONT ID="B30_LAB"></FONT></CAPTION><TR>
<TD><FONT ID="B30TEXT_LAB"> </FONT></TD></TR>');
      for iB30 in 1 .. B30TEXT.count loop
        htp.prn('<TR ID="B30_BLOK">
<TD><A CLASS="A" NAME="B30TEXT_' || iB30 || '">' ||
                B30TEXT(iB30) || '</A></TD></TR>');
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
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_TRIGGERS.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_TRIGGERS.submit(); this.disabled = true; ">
');
end if;
htp.p('
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" name="ACTION">
' || predogled || '
</td>
</tr>
</table>
</FORM>
</BODY>
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
    --<ON_ACTION formid="5" blockid="">
    rasdc_library.log('TRIGGERS',pformid, 'START', vcom);
        
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
      v_form   varchar2(100);
    begin
      rasdi_client.secCheckPermission('RASDC_TRIGGERS', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

          select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;



      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        rasdc_library.RefData(PFORMID);   
        
        if PBLOKtriggerid is not null and B10PLSQL(1) is null then
           pbloktriggerid := null;
           action := RASDI_TRNSLT.text('Search', lang) ;          
        end if;
                
        pselect;
        sporocilo := 'Changes are saved.';
        
        if b10rform(1) is not null then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if;         

      elsif action = RASDI_TRNSLT.text('Search', lang) then
        pselect;

      elsif action = RASDI_TRNSLT.text('New', lang) then
        pselect;

      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;

      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        rasdc_library.log('TRIGGERS',pformid, 'COMMIT_S', vcom);   
        pcommit;
        rasdc_library.log('TRIGGERS',pformid, 'COMMIT_E', vcom);             
        commit;
        rasdc_library.log('TRIGGERS',pformid, 'REF_S', vcom);        
        rasdc_library.RefData(PFORMID);           
        rasdc_library.log('TRIGGERS',pformid, 'REF_E', vcom);       
        rasdc_library.log('TRIGGERS',pformid, 'SELECT_S', vcom);                  
        pselect;
        rasdc_library.log('TRIGGERS',pformid, 'SELECT_E', vcom);       
        rasdc_library.log('TRIGGERS',pformid, 'COMPILE_S', vcom);          
        begin

          if v_form in ('RASDC_BLOCKSONFORM',
                        'RASDC_FIELDSONBLOCK',
                        'RASDC_TRIGGERS',
                        'RASDC_LINKS',
                        'RASDC_PAGES',
                        'F_FORME',
                        'RASDC_FORMS') then
            sporocilo := RASDI_TRNSLT.text('From is not generated.', lang);
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
            sporocilo := RASDI_TRNSLT.text('From is generated.', lang);
            
        if b10rform(1) is not null then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if;             
          end if;
        exception
          
          when others then
              
            if sqlcode = -24344 then
              
            sporocilo := RASDI_TRNSLT.text('Form is generated with compilation error. Check your code.', lang)||'('||sqlerrm||')';
             
            else
            sporocilo := RASDI_TRNSLT.text('Form is NOT generated - internal RASD error.', lang) || '('||sqlerrm||')<br>'||
                         RASDI_TRNSLT.text('To debug run: ', lang) || 'begin ' || v_server || '.form(' || PFORMID ||
                         ',''' || lang || ''');end;' ;
            end if;                     
        end;
        rasdc_library.log('TRIGGERS',pformid, 'COMPILE_E', vcom);          
        pselect_b10;
        pselect_b30;



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

      rasdc_library.log('TRIGGERS',pformid, 'POUTPUT_S', vcom);       
        phtml;
      rasdc_library.log('TRIGGERS',pformid, 'POUTPUT_E', vcom);       
      rasdc_library.log('TRIGGERS',pformid, 'END', vcom);         
    end;
    --</ON_ACTION>
    --<ON_ERROR formid="5" blockid="">
  exception
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
 izpis_dna();
</SCRIPT>
</FORM></BODY></HTML>');

    --</ON_ERROR>
  end;
end RASDC_TRIGGERS;
/
