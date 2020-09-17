create or replace package rasd_engine10 is
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
  c_engserver  rasd_engines.server%type := 'rasd_engine10';
  c_engclient  rasd_engines.client%type := 'rasd_engineHTML10';
  c_englibrary rasd_engines.library%type := 'rasd_client';
  c_engversion rasd_engines.library%type := '1';
  c_rs         rasd_fields.fieldid%type := 'RS'; --field name for record statud
  c_rid        rasd_fields.fieldid%type := 'RID'; --field name for rowid
  c_recnum     rasd_fields.fieldid%type := 'RECNUM';
  c_page       rasd_fields.fieldid%type := 'PAGE';
  c_message    rasd_fields.fieldid%type := 'MESSAGE';
  c_action     rasd_fields.fieldid%type := 'ACTION';  
  c_restrestype rasd_fields.fieldid%type := 'RESTRESTYPE'; 
  c_fin        rasd_fields.fieldid%type := 'FIN'; -- field name for returninga parameters
  c_session_max_val_long        number := 512; 
/*  
GBUTTONSRC -- search button action
GBUTTONRES -- reset button action
GBUTTONSAVE -- save-commit button action
GBUTTONBCK -- back button action
GBUTTONFWD -- forward button action
GBUTTONCLR -- clear button action
*/  
  c_nl    constant varchar2(2) := '
';
  c_true  constant varchar2(1) := 'Y';
  c_false constant varchar2(1) := 'N';
  c_openLOVname varchar2(10) := 'openLOV';
  v_gl          pls_integer; -- number of generated code
  type t_vrchrl is table of varchar2(32767) index by binary_integer;
  v_gc t_vrchrl; -- generated content
  re   rasd_engines%rowtype;
  c_debug boolean := false;
  
  --====================================
  cursor c_form(pformid rasd_forms.formid%type) is
    select * 
    from rasd_forms where formid = pformid;

  cursor c_fieldsOfForm(pformid  rasd_forms.formid%type,
                        pfieldid rasd_fields.fieldid%type default null) is
    select fieldid,
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
           nvl(element,'INPUT_TEXT') element,
           linkid,
           decode(upper(type),
                  'N',
                  'number',
                  'C',
                  'varchar2(4000)',
                  'D',
                  'date',
                  'T',
                  'timestamp',
                  'R',
                  'rowid',
                  'L',
                  'varchar2(32000)'
                  ) types,
           fieldid fieldi,
           nameid nameid
      from rasd_fields p
     where p.formid = pformid
       and p.blockid is null
       and (p.fieldid = pfieldid or pfieldid is null)
     order by p.orderby;

  cursor c_fieldsOfBlock(pformid  rasd_forms.formid%type,
                         pblockid rasd_blocks.blockid%type default null,
                         pfieldid rasd_fields.fieldid%type default null) is
    select fieldid,
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
           nvl(element,'INPUT_TEXT') element,
           linkid,
           INCLUDEVIS,
           decode(upper(type),
                  'N',
                  'ntab',
                  'C',
                  'ctab',
                  'D',
                  'dtab',
                  'T',
                  'ttab',
                  'R',
                  'rtab',
                  'L',
                  'cctab'
                  ) types,
           blockid || fieldid || '(i__)' fieldi,
           nameid nameid
      from rasd_fields p
     where p.formid = pformid
       and (p.blockid = pblockid or
           (p.blockid is not null and pblockid is null))
       and (p.fieldid = pfieldid or pfieldid is null)
     order by p.orderby;

  cursor c_blocks(pformid  rasd_forms.formid%type,
                  pblockid rasd_blocks.blockid%type default null) is
    select b.formid,
           b.blockid,
           b.sqltable,
           b.numrows,
           b.emptyrows,
           b.dbblockyn,
           b.rowidyn,
           b.pagingyn,
           b.clearyn,
           b.sqltext,
           b.label,
           min(p.orderby) orderby
      from rasd_blocks b, rasd_fields p
     where b.formid = pformid
       and (b.blockid = pblockid or
           (pblockid is null and b.blockid is not null))
       and b.formid = p.formid
       and b.blockid = p.blockid
     group by b.formid,
              b.blockid,
              b.sqltable,
              b.numrows,
              b.emptyrows,
              b.dbblockyn,
              b.rowidyn,
              b.pagingyn,
              b.clearyn,
              b.sqltext,
              b.label
     order by orderby;
  
  function version(p_log out varchar2) return varchar2;

  procedure addcnl(p_content in varchar2);
  procedure addc(p_content in varchar2);

  procedure addFields(pformid rasd_forms.formid%type,
                      p_lang  rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage);
  --function  get_SQLTekst(pformid rasd_forms.formid%type,
    --                    pblockid rasd_blocks.blockid%type) return varchar2;
  
  procedure form(p_formid rasd_forms.formid%type, p_lang rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage);
  
  function form_source(p_formid rasd_forms.formid%type,
                       p_lang   rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage) return t_vrchrl;  

  function transformPLSQL(pformid  number,
                          pblockid varchar2,
                          pplsql   varchar2) return varchar2;

end;
/

create or replace package body rasd_engine10 is
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

 
function version(p_log out varchar2) return varchar2 is
  begin
   p_log := '/* Change LOG: 
20180520 Added VS - element NAME+#SET - VisualSettings (new type stab) now you can set for selected fileds settings for visible, readonly or disabled          
20180420 Added possibility to chose to create REST program .rest or BATCH program .main - default is Y. 
20180405 Chanege in REST - fields unchecked on elementyn are not in the rest list
20180329 Added encodeURI to all LOV LINKS   
20180320 Change on LOV SELECT and RADIO because responsive display. Change only in JS functions for setting values.
20180206 In SELECT block commented rows with selected=false (change in program on lines 1823, 1871, 3723)   
20170203 Added ON_ERROR trigger   
20170203 Solved bug on LINKS with no inserted field   
20170123 FORM_JS and FORM_CSS changed in HEAD_ RASD_ATTRIBUTES_TEMPLATE (<% htpClob(rasd_client.getHtmlJSLibrary('':NAME'','':VALUE'')); htpClob(FORM_UIHEAD); htp.p(''<style type=&quot;text/css&quot;>''); htpClob(FORM_CSS); htp.p(''</style><script type=&quot;text/javascript&quot;>''); htpClob(FORM_JS); htp.p(''</script>''); %>) 
20170119 Added trigger FORM_UIHEAD    
20170119 form_js and form_css added to public access and <%= %> can be used in code 
20170116 Added possibility to include JAVASCRIPT when using link (#GC#) 
20170112 Adden new trigger type - PRE_ACTION   
20161124 Added possibility to check blocks and form fields for setting SESSION variables. Default setting is - not checked.      
20160831 Added on_submit(name_array, value_array) into OpenLOV function
20160809 Optimized compile (method generatePLSQL)   
20160704 Soleved bug when field was type L and block size = 1 (function transformPLSQL change in SQL)   
20160629 Added CSS_REF and JS_REF triggers.            
20160520 Commented conndition that only dtabase blocks can be on page (line 4181), Translates for OpenLOV added
20160412 Excluded if nvl(rb.pagingyn, ''N'') = c_true on_select trigger (line 3785)
20160407 addLINK change for SUBMIT fields - ; sign added afther condition   
20160405 Trigger PRE_SELECT is set on Form level; Data is changed. insted of Form is changed.       
20160401 Added option to use links on SUBMIT fields. Added javascript function cMF - check Mandatory Fields      
20160322 Session limitation: Cookies are now set only on blocks of size 1 (mod_plsql limit is 20 cookies per action)
20160322 Added pLog function to print Log somevhere in code - when using return or exception rasd_client.e_finished
20160321 Added condition on session: and rp.elementyn = c_true
20160317 New transformPLSQL function, REST output set to PAGE
20160229 Added record organisation after submit...
20160226 Changed session behavior (now added before settin output) and metadata is prepared if for is hecked - compile...
20151223 Added function js_...
20151217 Added new condition on Insert, Update, Delete for RS   
20151123 Changed transformPLSQL added . now you can write abc.count in trigger   
20151118 Added escapeRest.      
20151112 Added rLog function for debug.      
20150921 Added Metadata section.      
20150813 Added FORM JS and CSS option.      
*/';
   return 'v.'||c_engversion||'.0.20180520225530'; 
   
  end;

  -----------------------------------------------------------------------------------------
  procedure AREA_SYSTEM_PROCEDURES is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  procedure executeImmediate(p_plsql in varchar2) is
    cid pls_integer;
    n   pls_integer;
  begin
    cid := dbms_sql.open_cursor;
    dbms_sql.parse(cid, p_plsql, dbms_sql.native);
    n := dbms_sql.execute(cid);
  end;

  procedure addcnl(p_content in varchar2) is
  begin
    v_gl := v_gl + 1;
    v_gc(v_gl) := p_content;
  end;

  procedure addc(p_content in varchar2) is
  begin
    if length(v_gc(v_gl))+length(p_content) >  10000 then
       v_gl := v_gl + 1;
       v_gc(v_gl) := p_content;       
    else
      v_gc(v_gl) := v_gc(v_gl) || p_content;
    end if;  
  end;

 
  procedure generatePLSQL is
    cid integer;
    ret integer;
    z   pls_integer;
    s   sys.dbms_sql.varchar2s;
    i   pls_integer;
    l   pls_integer;
    lengthc pls_integer := 150; -- set to 150 because chars larger then 1byte. dbms_sql.varchar2s has limit 256byts
  begin
    z := 0;
    s.delete;
    for j in 1 .. v_gc.count loop
      z := z + 1;
      l := nvl(length(v_gc(j)), 0);
      i := 0;
      loop
        s(z) := substr(v_gc(j), i + 1, lengthc);
        exit when l - i < lengthc;
        i := i + lengthc;
        z := z + 1;
      end loop;
      if nvl(length(s(z) || c_nl), 0) < lengthc then
        s(z) := s(z) || c_nl;
      else
        z := z + 1;
        s(z) := c_nl;
      end if;
    end loop;
    
    -- drop added for faster compile: DROP-CREATE is faster then REPLACE
    if v_gc.count > 4000 then
    begin
    execute immediate replace(replace(v_gc(1),'create or replace ', 'drop '),' is','');
    null;
    exception when others then null; end;
    end if;
    
    cid := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cid, s, 1, s.count, false, DBMS_SQL.NATIVE);
    ret := DBMS_SQL.EXECUTE(cid);
    DBMS_SQL.CLOSE_CURSOR(cid);
    
   -- Option for wrapped content
   -- DBMS_DDL.create_wrapped(s, 1, s.count);
    
    s.delete;
    v_gc.delete;
    v_gl := 0;
  end;

  function setHTP(ptext varchar2) return varchar2 is
    vtext varchar2(4000);
    i     pls_integer;
  begin
    i     := 1;
    vtext := ptext;
    while instr(vtext, '<%', i) > 0 loop
      i := instr(vtext, '<%', i);
      if instr(vtext, '%>', i) > i then
        if substr(vtext, i, 3) = '<%=' then
          vtext := substr(vtext, 1, i - 1) || '''||' ||
                   substr(vtext, i + 3);
          i     := instr(vtext, '%>', i);
          vtext := substr(vtext, 1, i - 1) || '||''' ||
                   substr(vtext, i + 2);
        else
          vtext := substr(vtext, 1, i - 1) || ''');' ||
                   substr(vtext, i + 2);
          i     := instr(vtext, '%>', i);
          vtext := substr(vtext, 1, i - 1) || 'htp.prn(''' ||
                   substr(vtext, i + 2);
        end if;
      else
        i := i + 2;
      end if;
    end loop;
    return vtext;
  end;
  function setHTP(ptext clob) return clob is
    vtext clob;
    i     pls_integer;
    vx clob;
  begin
    i     := 1;
    vtext := ptext;
    while instr(vtext, '<%', i) > 0 loop
      i := instr(vtext, '<%', i);
      if instr(vtext, '%>', i) > i then
        if substr(vtext, i, 3) = '<%=' then
          vtext := substr(vtext, 1, i - 1) || '''||' ||
                   substr(vtext, i + 3);
          i     := instr(vtext, '%>', i);
          vx    := replace(substr(vtext, 1, i - 1),'''''','''');
          vtext := vx || '||''' ||
                   substr(vtext, i + 2);
        else
          vtext := substr(vtext, 1, i - 1) || ''');' ||
                   substr(vtext, i + 2);
          i     := instr(vtext, '%>', i);
          vx    := replace(substr(vtext, 1, i - 1),'''''','''');
          vtext := vx || 'htpClob(''' ||
                   substr(vtext, i + 2);
        end if;
      else
        i := i + 2;
      end if;
    end loop;
    return vtext;
  end;

  -----------------------------------------------------------------------------------------
  procedure AREA_LOGICAL_PROCEDURES is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  function trueTrigger(pformid    number,
                       ptriggerid rasd_triggers.triggerid%type,
                       pblockid   varchar2 default null) return boolean is
    n pls_integer;
  begin
    select 1
      into n
      from rasd_triggers
     where formid = pformid
       and (formid = pformid and blockid = pblockid or
           formid = pformid and blockid is null and pblockid is null)
       and upper(triggerid) = upper(ptriggerid);
    return true;
  exception
    when no_data_found then
      return false;
  end;

  function transformPLSQL(pformid  number,
                          pblockid varchar2,
                          pplsql   varchar2) return varchar2 is
    v_plsql clob; --varchar2(32000); --rasd_triggers.plsql%type;
    l       pls_integer;
    n       pls_integer;
    type tsez is table of clob /*varchar2(32000)*/ index by binary_integer;
    ix number := 1;
    v_z number;
    v_k number;
    vsez tsez;
    v_pr1 number;
    
  function replaceUpper(p_value clob, p_sstr varchar2 , pnstr varchar2) return clob is
     v_value clob :=  p_value;
     l number;
  begin
   l := 1;
   while instr(upper(v_value) , upper(p_sstr)) > 0 loop
     l := instr(upper(v_value), upper(p_sstr), l, 1);
     v_value := substr(v_value, 1, l - 1) || pnstr || substr(v_value, l + length(p_sstr)); 
   end loop;
   return v_value;
  end;

  begin
      
    v_plsql := pplsql;
    
    -- Trim string values
    v_plsql := replace(v_plsql , '''''' , '##0RASD0##');
    
    while instr(v_plsql , '''') > 0 and ix < 10000000 loop
       v_z := instr(v_plsql, '''');
       v_k := instr(v_plsql, '''', v_z + 1 );
       
       if v_k > 0 then 
           vsez(ix) := substr(v_plsql , v_z , v_k-v_z+1 );
           v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');         
       else
           vsez(ix) := substr(v_plsql , v_z );
           v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
       end if;
       ix := ix+1;
    end loop;  
    --   
  
    if v_plsql is not null then
      for rp in (select length(p.blockid || p.fieldid) dolzina,
                        p.fieldid,
                        p.blockid,
                        upper(p.blockid || p.fieldid) imeid,
                        b.numrows
                   from rasd_fields p, rasd_blocks b
                  where p.formid = pformid
                    and p.formid = b.formid and p.blockid = b.blockid
                    and p.blockid is not null
                  union
                  select length(p.blockid || p.fieldid||'#SET') dolzina,
                        p.fieldid||'#SET' fieldid,
                        p.blockid,
                        upper(p.blockid || p.fieldid||'#SET') imeid,
                        b.numrows
                   from rasd_fields p, rasd_blocks b
                  where p.formid = pformid
                    and p.formid = b.formid and p.blockid = b.blockid
                    and p.blockid is not null
                    and p.includevis = c_true  
                  order by dolzina desc) loop
      
              if rp.blockid = pblockid and rp.numrows <> 1 then
                  if instr(rp.imeid,'#SET') = 0 then
                  vsez(ix) := rp.imeid||'.';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'.' , '##RASD'||ix||'##'); 
                  ix := ix + 1;                  
                  end if;                 
                  vsez(ix) := rp.imeid||'(';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'(' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(i__)';
                  v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
                  v_plsql := replaceUpper(v_plsql, rp.imeid, '##RASD'||ix||'##');                  
                  ix := ix + 1;
              else
                  if instr(rp.imeid,'#SET') = 0 then
                  vsez(ix) := rp.imeid||'.';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'.' , '##RASD'||ix||'##');                  
                  ix := ix + 1;                  
                  end if;
                  vsez(ix) := rp.imeid||'(';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'(' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(1)';
                  v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
                  v_plsql := replaceUpper(v_plsql, rp.imeid, '##RASD'||ix||'##');                  
                  ix := ix + 1;
              end if;
      end loop;
    end if;
    
    while instr(v_plsql,'##RASD') > 0 loop
      for ix in 1..vsez.count loop
        v_plsql := replace(v_plsql, '##RASD'||ix||'##' , vsez(ix));    
      end loop;    
    end loop;

    v_plsql := replace(v_plsql , '##0RASD0##' , '''''' );

    
    return v_plsql;
  end;

  function transformPLSQLold(pformid  number,
                          pblockid varchar2,
                          pplsql   varchar2) return varchar2 is
    v_plsql varchar2(32000); --rasd_triggers.plsql%type;
    l       pls_integer;
    n       pls_integer;
  begin
    v_plsql := pplsql;
    if v_plsql is not null then
      for rp in (select length(p.blockid || p.fieldid) dolzina,
                        p.fieldid,
                        p.blockid,
                        p.blockid || p.fieldid imeid
                   from rasd_fields p
                  where p.formid = pformid
                    and p.blockid is not null
                  order by dolzina desc) loop
      
        l := 1;
        loop
          l := instr(upper(v_plsql), upper(rp.imeid), l, 1);
          exit when l = 0;
          select count(*)
            into n
            from rasd_fields
           where formid = pformid
             and blockid is not null
             and substr(upper(v_plsql), l) like
                 upper(blockid || fieldid) || '%'
             and blockid || fieldid <> rp.imeid
             and length(blockid || fieldid) > length(rp.imeid);
          if n > 0 then
            null;
          else
            if instr(v_plsql, '(', l) > 0 or instr(v_plsql, '.', l) > 0 then
              select count(*)
                into n
                from (select blockid, fieldid
                        from rasd_fields
                       where blockid = rp.blockid
                         and formid = pformid)
               where blockid = rp.blockid
                 and (upper(rp.imeid) =
                     upper(rtrim(substr(v_plsql,
                                        l,
                                        instr(v_plsql, '(', l) - l)))
                     or upper(rp.imeid) =
                     upper(rtrim(substr(v_plsql,
                                        l,
                                        instr(v_plsql, '.', l) - l)))                    
                      );
              if n = 0 then
                if rp.blockid = pblockid then
                  v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                             '(i__)' ||
                             substr(v_plsql, l + length(rp.imeid));
                else
                  v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                             '(1)' || substr(v_plsql, l + length(rp.imeid));
                end if;
              end if;
            else
              if rp.blockid = pblockid then
                v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                           '(i__)' || substr(v_plsql, l + length(rp.imeid));
              else
                v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                           '(1)' || substr(v_plsql, l + length(rp.imeid));
              end if;
            end if;
          end if;
          l := l + length(rp.imeid);
        end loop;
      end loop;
    end if;
    return v_plsql;
  end;

  procedure createTriggerPLSQL(pformid    number,
                               ptriggerid rasd_triggers.triggerid%type,
                               pblockid   varchar2 default null,
                               pdefault   varchar2 DEFAULT null) is
    v_plsql  rasd_triggers.plsql%type;
    v_plsqlp rasd_triggers.plsql%type;
    v_code   clob; --varchar2(32000);
    i pls_integer;
  begin
    addcnl('--<' || ptriggerid || ' formid="' || pformid || '" blockid="' ||
           pblockid || '">');
    if c_debug then
        select count(1)  into i
        from rasd_triggers_code_types
        where tctype <> 'PRE_SELECT'
          and tctype = upper(ptriggerid)
          and language = 'P'
          and tclevel = 'B';
        if i = 0 then
            addcnl('rlog( ''START trigger ' || pblockid ||' '|| ptriggerid ||' '');');
        else
          if instr(pdefault, 'i__') = 0 then
            addcnl('rlog( ''START trigger ' || pblockid ||' '|| ptriggerid ||' '');');
          else   
            addcnl('rlog( ''START trigger ' || pblockid ||' '|| ptriggerid ||' record=''||i__||'' '');');
          end if;  
        end if;    
    end if;
           
    for r in (select p.plsql, p.plsqlspec
                from rasd_triggers p
               where p.formid = pformid
                 and (p.blockid = pblockid or pblockid is null)
                 and upper(triggerid) = upper(ptriggerid)) loop
    
      v_plsqlp := r.plsql;
      v_plsql  := '';
      /*if pdefault is not null then --CODE if we would like to replace default code with trigger name in trigger code.
        loop
          exit when instr(upper(v_plsqlp), upper(ptriggerid)) = 0;
          v_plsql  := v_plsql ||
                      substr(v_plsqlp,
                             1,
                             instr(upper(v_plsqlp), upper(ptriggerid)) - 1) ||
                      pdefault;
          v_plsqlp := substr(v_plsqlp,
                             instr(upper(v_plsqlp), upper(ptriggerid)) +
                             length(ptriggerid));
        end loop;
      end if;*/ 
      v_plsql := v_plsql || v_plsqlp;
      if upper(ptriggerid) = 'PRE_SELECT' then
        v_code :=  transformPLSQL(pformid, '', v_plsql);
      else  
        v_code :=  transformPLSQL(pformid, pblockid, v_plsql);
      end if;
      addcnl(v_code);
    end loop; 
    addcnl('--</' || ptriggerid || '>');
    if c_debug then
            addcnl('rlog(''END trigger</br>'');');
    end if;
    update rasd_triggers set
      plsqlspec = pdefault
    where formid = pformid
                 and (blockid = pblockid or pblockid is null)
                 and upper(triggerid) = upper(ptriggerid)
                 and pdefault is not null
                 ;    
  end;
 
  function getSQLText(pformid  rasd_forms.formid%type,
                      pblockid rasd_blocks.blockid%type) return varchar2 is
    v_sqltable rasd_blocks.sqltable%type;
    v_sqltext  rasd_blocks.sqltext%type;
  
    function getSelect return varchar2 is
      v_fields rasd_blocks.sqltext%type;
    begin
      for r in c_fieldsOfBlock(pformid, pblockid) loop
        if r.selectyn = c_true then
          if r.type = 'R' then
            v_fields := v_fields || ',
 ROWID ' || r.fieldid;
          else
            v_fields := v_fields || ',
' || r.fieldid;
          end if;
        end if;
      end loop;
      return substr(v_fields, 2);
    end;
  begin
    select sqltable, sqltext
      into v_sqltable, v_sqltext
      from rasd_blocks
     where blockid = pblockid
       AND formid = pformid;
  
    if instr(upper(ltrim(v_sqltext)), 'SELECT') = 1 then
      return transformPLSQL(pformid, pblockid, v_sqltext);
    elsif instr(upper(ltrim(v_sqltext)), 'FROM') = 1 then
      v_sqltext := 'SELECT ' || getSelect || ' ' ||
                   transformPLSQL(pformid, pblockid, v_sqltext);
      v_sqltext := '--<SQL formid="' || pformid || '" blockid="' ||
                   pblockid || '">
' || v_sqltext || '
--</SQL>
';
      return v_sqltext;
    else
      v_sqltext := 'SELECT ' || getSelect || ' FROM ' || v_sqltable || ' ' ||
                   transformPLSQL(pformid, pblockid, v_sqltext);
      v_sqltext := '--<SQL formid="' || pformid || '" blockid="' ||
                   pblockid || '">
' || v_sqltext || '
--</SQL>
';
      return v_sqltext;
    end if;
  end;

  function trueLock(p_formid  rasd_forms.formid%type,
                    p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(*)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and lockyn = c_true
       and rownum = 1;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;
  function trueInsertNN(p_formid  rasd_forms.formid%type,
                        p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(insertyn)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and insertnnyn = c_true;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;
  function trueNotNull(p_formid  rasd_forms.formid%type,
                       p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(*)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and notnullyn = c_true;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;
  function trueInsert(p_formid  rasd_forms.formid%type,
                      p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(insertyn)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and insertyn = c_true;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;
  function trueDelete(p_formid  rasd_forms.formid%type,
                      p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(deleteyn)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and deleteyn = c_true;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;
  function trueUpdate(p_formid  rasd_forms.formid%type,
                      p_blockid rasd_blocks.blockid%type) return boolean is
    i pls_integer;
  begin
    select count(updateyn)
      into i
      from rasd_fields
     where blockid = p_blockid
       and formid = p_formid
       and updateyn = c_true;
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;

  function trueField(p_formid  rasd_fields.formid%type,
                     p_fieldid rasd_fields.fieldid%type,
                     p_blockid rasd_fields.blockid%type default null)
    return boolean is
    i pls_integer;
  begin
    select count(*)
      into i
      from rasd_fields
     where formid = p_formid
       and fieldid = p_fieldid
       and nvl(blockid, ' ') = nvl(p_blockid, ' ');
    if i > 0 then
      return true;
    else
      return false;
    end if;
  end;

  function truePageSet(p_formid  rasd_forms.formid%type,
                       p_blockid rasd_blocks.blockid%type) return varchar2 is
    v_pogoj varchar2(4000);
  begin
    v_pogoj := '';
    for r in (select *
                from rasd_pages
               where formid = p_formid
                 and blockid = p_blockid
                 and page <> 0) loop
      v_pogoj := v_pogoj || ' or nvl(' || c_page || ',0) = ' ||
                 to_char(r.page);
    end loop;
    -- on default all blocks are on page 0.
    v_pogoj := ' or nvl(' || c_page || ',0) = 0' || v_pogoj;
    return substr(v_pogoj, 4);
  end;

  function truePageFieldSet(p_formid  rasd_forms.formid%type,
                       p_blockid rasd_blocks.blockid%type,
                       p_fieldid rasd_fields.fieldid%type) return varchar2 is
    v_pogoj varchar2(4000);
  begin
    v_pogoj := '';
    for r in (select *
                from rasd_pages
               where formid = p_formid
                 and (blockid = p_blockid or blockid is null and p_blockid is null)
                 and fieldid = p_fieldid
                 and page <> 0) loop
      v_pogoj := v_pogoj || ' or nvl(' || c_page || ',0) = ' ||
                 to_char(r.page);
    end loop;
    -- on default all blocks are on page 0.
    v_pogoj := ' or nvl(' || c_page || ',0) = 0' || v_pogoj;
    return substr(v_pogoj, 4);
  end;


  function getDefaultValue(p_formid  rasd_forms.formid%type,
                           p_blockid rasd_blocks.blockid%type,
                           p_fieldid rasd_fields.fieldid%type)
    return varchar2 is
    v rasd_fields.defaultval%type;
  begin
  
    select defaultval
      into v
      from rasd_fields p
     where fieldid = p_fieldid
       and (blockid = p_blockid or blockid is null and p_blockid is null)
       and formid = p_formid;
  
    return v;
  exception when no_data_found then
    return '';
  end;
  -----------------------------------------------------------------------------------------
  procedure AREA_FILL_PROCEDURES is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  procedure addFields(pformid rasd_forms.formid%type,
                      p_lang  rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage) is
    n pls_integer;
  begin
    -- RECORD NUMBER (RECNUM) of block
    for r in (select b.blockid,
                     c_recnum || b.blockid fieldid,
                     rownum * -1 vrstnired
                from rasd_blocks b
               where b.formid = pformid
                 and nvl(b.pagingyn, c_false) = c_true
               order by b.blockid desc) loop
    
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid is null
         and upper(p.fieldid) = upper(r.fieldid);
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           type,
           orderby,
           elementyn,
           nameid,
           element,
           source,
           defaultval)
        values
          (pformid,
           r.fieldid,
           'N',
           r.vrstnired,
           c_true,
           upper(r.fieldid),
           'INPUT_HIDDEN',
           'G',
           1);
      end if;
    end loop;
  
    -- RECORD STATUS (RS) of field
    for r in (select b.blockid from rasd_blocks b where b.formid = pformid) loop
    
      if trueInsert(pformid, r.blockid) or trueUpdate(pformid, r.blockid) or
         trueDelete(pformid, r.blockid) or trueLock(pformid, r.blockid) then
        select count(*)
          into n
          from rasd_fields p
         where p.formid = pformid
           and p.blockid = r.blockid
           and upper(p.fieldid) = upper(c_rs);
        if n = 0 then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             element,
             source)
          values
            (pformid,
             c_rs,
             r.blockid,
             'C',
             0,
             c_true,
             upper(r.blockid || c_rs),
             'INPUT_HIDDEN',
             'G');
        end if;
      end if;
    end loop;
  
    -- ROWID (RID) of field
    for r in (select b.blockid
                from rasd_blocks b
               where b.formid = pformid
                 and b.rowidyn = c_true) loop
    
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid = r.blockid
         and upper(p.fieldid) = upper(c_rid);
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           blockid,
           type,
           orderby,
           pkyn,
           selectyn,
           elementyn,
           nameid,
           element,
           source)
        values
          (pformid,
           c_rid,
           r.blockid,
           'R',
           1 , 
           c_true,
           c_true,
           c_true,
           upper(r.blockid || c_rid),
           'INPUT_HIDDEN',
           'G');
      end if;
    end loop;
  
    -- current PAGE on form
    for r in (select b.blockid, b.dbblockyn from rasd_blocks b where b.formid = pformid 
              and nvl(b.dbblockyn,c_false) = c_true) loop
    select count(*)
      into n
      from rasd_fields p
     where p.formid = pformid
       and p.blockid is null
       and upper(p.fieldid) = upper(c_page);
    if n = 0 then
      insert into rasd_fields
        (formid,
         fieldid,
         type,
         orderby,
         elementyn,
         nameid,
         element,
         source,
         defaultval)
      values
        (pformid,
         c_page,
         'N',
         0,
         c_true,
         upper(c_page),
         'INPUT_HIDDEN',
         'G',
         '0');
    end if;

    end loop;
    -- current ACTION on form
    for r in (select max(decode(b.pagingyn, c_true, 1, 0)) paging,
                     max(decode(b.clearyn, c_true, 1, 0)) clear,
                     max(decode(p.insertyn,
                                c_true,
                                1,
                                decode(p.updateyn,
                                       c_true,
                                       1,
                                       decode(p.deleteyn, c_true, 1, 0)))) savedata,
                     max(decode(b.dbblockyn, c_true, 1, 0)) dbblock      
                from rasd_blocks b, rasd_fields p
               where b.formid = pformid
                 and b.formid = p.formid
                 and nvl(b.dbblockyn,c_false) = c_true) loop
      -- ACTION
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid is null
         and upper(p.fieldid) = upper(c_action);
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           blockid,
           type,
           orderby,
           elementyn,
           nameid,
           element,
           source)
        values
          (pformid,
           c_action,
           '',
           'C',
           0,
           c_true,
           upper(c_action),
           'INPUT_HIDDEN',
           'G');
      end if;
      -- MESSAGE
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid is null
         and upper(p.fieldid) = upper(c_message);
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           blockid,
           type,
           orderby,
           elementyn,
           nameid,
           element,
           source)
        values
          (pformid,
           c_message,
           '',
           'C',
           0,
           c_true,
           upper(c_message),
           'FONT_',
           'G');
      end if;
      -- SEARCH
      if r.dbblock = 1 then
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid is null
         and upper(p.fieldid) = upper('GBUTTONSRC');
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           blockid,
           type,
           orderby,
           elementyn,
           nameid,
           element,
           source,
           defaultval)
        values
          (pformid,
           'GBUTTONSRC',
           '',
           'C',
           0,
           c_true,
           upper('GBUTTONSRC'),
           'INPUT_SUBMIT',
           'G',
           '''' || RASDI_TRNSLT.text('GBUTTONSRC', p_lang) || '''');
      end if;
      end if;
      
      -- RESET
      if r.dbblock = 1 then
      select count(*)
        into n
        from rasd_fields p
       where p.formid = pformid
         and p.blockid is null
         and upper(p.fieldid) = upper('GBUTTONRES');
      if n = 0 then
        insert into rasd_fields
          (formid,
           fieldid,
           blockid,
           type,
           orderby,
           elementyn,
           nameid,
           element,
           source,
           defaultval)
        values
          (pformid,
           'GBUTTONRES',
           '',
           'C',
           0,
           c_true,
           upper('GBUTTONRES'),
           'INPUT_RESET',
           'G',
           '''' || RASDI_TRNSLT.text('GBUTTONRES', p_lang) || '''');
      end if;
      end if;
      -- SAVE
      if r.savedata = 1 then
        select count(*)
          into n
          from rasd_fields p
         where p.formid = pformid
           and p.blockid is null
           and upper(p.fieldid) = upper('GBUTTONSAVE');
        if n = 0 then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             element,
             source,
             defaultval)
          values
            (pformid,
             'GBUTTONSAVE',
             '',
             'C',
             0,
             c_true,
             upper('GBUTTONSAVE'),
             'INPUT_SUBMIT',
             'G',
             '''' || RASDI_TRNSLT.text('GBUTTONSAVE', p_lang) || '''');
        end if;
      end if;
      -- PAGING
      if r.paging = 1 and r.dbblock = 1 then
        select count(*)
          into n
          from rasd_fields p
         where p.formid = pformid
           and p.blockid is null
           and upper(p.fieldid) = upper('GBUTTONBCK');
        if n = 0 then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             element,
             source,
             defaultval)
          values
            (pformid,
             'GBUTTONBCK',
             '',
             'C',
             0,
             c_true,
             upper('GBUTTONBCK'),
             'INPUT_SUBMIT',
             'G',
             '''' || RASDI_TRNSLT.text('GBUTTONBCK', p_lang) || '''');
        end if;
        select count(*)
          into n
          from rasd_fields p
         where p.formid = pformid
           and p.blockid is null
           and upper(p.fieldid) = upper('GBUTTONFWD');
        if n = 0 then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             element,
             source,
             defaultval)
          values
            (pformid,
             'GBUTTONFWD',
             '',
             'C',
             0,
             c_true,
             upper('GBUTTONFWD'),
             'INPUT_SUBMIT',
             'G',
             '''' || RASDI_TRNSLT.text('GBUTTONFWD', p_lang) || '''');
        end if;
      end if;
      -- CLEAR
      if r.clear = 1 then
        select count(*)
          into n
          from rasd_fields p
         where p.formid = pformid
           and p.blockid is null
           and upper(p.fieldid) = upper('GBUTTONCLR');
        if n = 0 then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             element,
             source,
             defaultval)
          values
            (pformid,
             'GBUTTONCLR',
             '',
             'C',
             0,
             c_true,
             upper('GBUTTONCLR'),
             'INPUT_SUBMIT',
             'G',
             '''' || RASDI_TRNSLT.text('GBUTTONCLR', p_lang) || '''');
        end if;
      end if;
    end loop;
  
    -- add CHECKBOX on form for default values
    select count(*)
      into n
      from rasd_fields p
     where p.formid = pformid
       and p.linkid is null
       and nvl(p.elementyn, 'N') = c_true
       and p.element = 'INPUT_CHECKBOX';
  
    if n > 0 then
      select count(*)
        into n
        from rasd_links s
       where s.formid = pformid
         and s.linkid = 'link$CHKBXD'
         and s.type = 'C';
      if n = 0 then
        insert into rasd_links
          (formid,
           linkid,
           link,
           type,
           location,
           text,
           source,
           hiddenyn,
           rlobid,
           rform,
           rlinkid)
        values
          (pformid,
           'link$CHKBXD',
           'CHKBXD',
           'C',
           '',
           '',
           'G',
           c_false,
           '',
           '',
           '');
        insert into rasd_link_params
          (linkid,
           paramid,
           type,
           orderby,
           formid,
           blockid,
           fieldid,
           namecid,
           code,
           value)
        values
          ('link$CHKBXD',
           'TRUE',
           'TRUE',
           1,
           pformid,
           null,
           'THIS',
           null,
           c_true,
           c_true);
        insert into rasd_link_params
          (linkid,
           paramid,
           type,
           orderby,
           formid,
           blockid,
           fieldid,
           namecid,
           code,
           value)
        values
          ('link$CHKBXD',
           'FALSE',
           'FALSE',
           2,
           pformid,
           null,
           'THIS',
           null,
           c_false,
           c_false);
      end if;
    
      -- update CHECKBOX values
      update rasd_fields p
         set linkid = 'link$CHKBXD'
       where p.formid = pformid
         and p.linkid is null
         and nvl(p.elementyn, 'N') = c_true
         and p.element = 'INPUT_CHECKBOX';
    end if;
  
    commit;
  end;

  -----------------------------------------------------------------------------------------
  procedure AREA_JS_CODE is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------

  function addLOV(pformid  rasd_links.formid%type,
                  pblockid rasd_link_params.blockid%type,
                  pfieldid rasd_fields.fieldid%type,
                  plinkid  rasd_links.linkid%type) return varchar2 is
  
   -- v_type     rasd_links.type%type;
   -- v_location rasd_links.location%type;
 --   v_text     rasd_links.text%type;
    v_url      rasd_links.text%type;
    v_form     rasd_forms.form%type;
  
  begin
 
                  select min(upper(f.form)) into v_form
                   from rasd_fields p, rasd_links gpp, rasd_forms f
                   where p.formid = pformid
                     and p.blockid = pblockid
                     and p.fieldid = pfieldid
                     and gpp.formid = p.formid
                     and gpp.linkid = p.linkid
                     and gpp.type in ('C','T','S')  
                     and nvl(p.element,'INPUT_TEXT') in ('INPUT_TEXT')
                     and f.formid = pformid;
                     
  if v_form is not null then
  /*  select pov.type, pov.location, pov.text, upper(f.form)
      into v_type, v_location, v_text, v_form
      from rasd_links pov, rasd_forms f
     where pov.formid = pformid
       and pov.linkid = plinkid
       and pov.formid = f.formid;
       
    if v_type = 'S' then
      -- calling LOV form
      v_url := '';
      for r in (select decode(p.elementyn,
                              c_true,
                              decode(p.element,
                                     'FONT_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''||replace(value,''"'',''&quot;'')||' || c_nl || '''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''||replace(' || gpp.fieldid ||
                                                   ',''"'',''&quot;'')||' || c_nl || '''',
                                                   upper(nvl(pblockid, 'x')),
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(1),''"'',''&quot;'')||' || c_nl || '''')),
                                     'A_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''||replace(value,''"'',''&quot;'')||' || c_nl || '''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''||replace(' || gpp.fieldid ||
                                                   ',''"'',''&quot;'')||' || c_nl || '''',
                                                   upper(nvl(pblockid, 'x')),
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(1),''"'',''&quot;'')||' || c_nl || '''')),
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''''+this.value+' || c_nl ||
                                            '''''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''''+document.' || v_form || '.' ||
                                                   gpp.fieldid || '.value+' || c_nl ||
                                                   '''''',
                                                   upper(nvl(pblockid, '-x')),
                                                   '''''+document.' || v_form || '.' ||
                                                   gpp.blockid || gpp.fieldid ||
                                                   '_''||substr(name,instr(name,''_'',-1)+1)||''' ||
                                                   '.value+' || c_nl || '''''',
                                                   '''''+document.' || v_form || '.' ||
                                                   gpp.blockid || gpp.fieldid || '_1' ||
                                                   '.value+' || c_nl || ''''''))),
                              decode(upper(gpp.fieldid),
                                     'THIS',
                                     '''||replace(value,''"'',''&quot;'')||''',
                                     decode(upper(gpp.blockid),
                                            null,
                                            '''||replace(' || gpp.fieldid ||
                                            ',''"'',''&quot;'')||' || c_nl || '''',
                                            upper(nvl(pblockid, 'x')),
                                            '''||replace(' || gpp.blockid ||
                                            gpp.fieldid ||
                                            '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                            '''||replace(' || gpp.blockid ||
                                            gpp.fieldid ||
                                            '(1),''"'',''&quot;'')||' || c_nl || ''''))) jsfieldid,
                       gpp.blockid,
                       gpp.fieldid,
                       gpp.namecid namecid,
                       gpp.value
                  from rasd_link_params gpp, rasd_fields p
                 where gpp.linkid = plinkid
                   and gpp.formid = pformid
                   and gpp.type = 'WHERE'
                   and p.formid(+) = gpp.formid
                   and p.fieldid(+) = gpp.fieldid
                   and nvl(p.blockid(+), 'x') = nvl(gpp.blockid, 'x')) loop
        --defining target field
        v_url := v_url || '&' || r.blockid || r.fieldid || '=' ||
                 r.jsfieldid;
      end loop;*/
      v_url := '!' || v_form || '.' || c_openLOVname || '?PLOV=' || plinkid ||
               '&FIN='||v_form||'.''||name||''&PID=''''+document.' || v_form || '.''||name||''.value+''''' || v_url;
      v_url := 'javascript: var link=window.open(encodeURI('''''||v_url||'''''),'''''||c_openLOVname||''''',''''resizable,scrollbars,width=680,height=550'''');';
    end if;
    return(v_url);
  end;

  function addLINK(pformid  rasd_links.formid%type,
                   pblockid rasd_link_params.blockid%type,
                   pfieldid rasd_fields.fieldid%type,
                   plinkid  rasd_links.linkid%type) return varchar2 is
    v_type     rasd_links.type%type;
    v_location rasd_links.location%type;
    v_text     rasd_links.text%type;
    v_url      rasd_links.text%type;
    v_form     rasd_forms.form%type;
    v_fieldcid varchar2(100);
    v_element  rasd_fields.element%type;
  begin
    select pov.type, pov.location, pov.text, f.form
      into v_type, v_location, v_text, v_form
      from rasd_links pov, rasd_forms f
     where pov.formid = pformid
       and pov.linkid = plinkid
       and pov.formid = f.formid;
       
    select max(nvl(f.element,'INPUT_TEXT')) into v_element
      from rasd_fields f
     where f.formid = pformid
       and (f.blockid =  pblockid or f.blockid is null and pblockid is null)
       and f.fieldid = pfieldid;
      
    v_url := '';
    if v_type in ('F', 'U') then
      --type is OUT
      if v_element = 'INPUT_SUBMIT'then

      for r in (select decode(p.elementyn,
                              c_true,
                              decode(nvl(p.element,'INPUT_TEXT'),
                                     'FONT_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''''''||replace(value,''"'',''&quot;'')||' || c_nl || '''''''',
                                            decode(upper(gpp.blockid),
                                                   null,                       '''''''||replace(' || gpp.fieldid ||',''"'',''&quot;'')||' || c_nl || '''''''', 
                                                   upper(nvl(pblockid, 'x')),  '''''''||replace(' || gpp.blockid || gpp.fieldid || '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''''''',
                                                                               '''''''||replace(' || gpp.blockid || gpp.fieldid || '(1),''"'',''&quot;'')||' || c_nl || '''''''')),
                                     'A_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''''''||replace(value,''"'',''&quot;'')||' || c_nl || '''''''',
                                            decode(upper(gpp.blockid),
                                                   null,                       '''''''||replace(' || gpp.fieldid ||',''"'',''&quot;'')||' || c_nl || '''''''', 
                                                   upper(nvl(pblockid, 'x')),  '''''''||replace(' || gpp.blockid || gpp.fieldid || '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''''''',
                                                                               '''''''||replace(' || gpp.blockid || gpp.fieldid ||'(1),''"'',''&quot;'')||' || c_nl || '''''''')),
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            'this.value' || c_nl || '',
                                            decode(upper(gpp.blockid),
                                                   null,                          'document.' || upper(v_form) || '.' ||gpp.fieldid || '.value' || c_nl || '',
                                                   upper(nvl(pblockid, '-x')),    'document.' || upper(v_form) || '.' ||upper(gpp.blockid) || upper(gpp.fieldid) ||'_''||substr(name,instr(name,''_'',-1)+1)||''' ||'.value' || c_nl || '',
                                                                                  'document.' || upper(v_form) || '.' ||upper(gpp.blockid) || upper(gpp.fieldid) || '_1' || '.value' || c_nl || ''))),
                              decode(upper(gpp.fieldid),
                                     'THIS',
                                     '''''''||replace(value,''"'',''&quot;'')||''''''',
                                     decode(upper(gpp.blockid),
                                            null,                              '''''''||replace(' || gpp.fieldid ||',''"'',''&quot;'')||' || c_nl || '''''''',
                                            upper(nvl(pblockid, 'x')),         '''''''||replace(' || gpp.blockid ||gpp.fieldid || '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''''''',
                                                                               '''''''||replace(' || gpp.blockid ||gpp.fieldid ||'(1),''"'',''&quot;'')||' || c_nl || ''''''''))) jsfieldid,
                       gpp.blockid,
                       gpp.fieldid,
                       gpp.namecid,
                       gpp.value
                  from rasd_link_params gpp, rasd_fields p
                 where gpp.linkid = plinkid
                   and gpp.formid = pformid
                   and gpp.formid = p.formid(+)
                   and nvl(gpp.blockid, 'x') = nvl(p.blockid(+), 'x')
                   and gpp.fieldid = p.fieldid(+)
                   and gpp.type = 'OUT'
                   and nvl(gpp.fieldid,'##x##') not in ('#JSLINK#')
                  order by gpp.blockid , gpp.fieldid , gpp.value
                 
                  ) loop
        --defining target field
        v_fieldcid := '';
        if r.namecid is not null then
          begin
            select distinct r.namecid || decode(p.blockid, null, '', '_1')
              into v_fieldcid
              from rasd_fields p, rasd_forms f
             where upper(f.form) = replace(replace(upper(v_text),'.WEBCLIENT',''),'!','')
               and f.formid = p.formid
               and p.nameid = r.namecid;
          exception
            when others then
              v_fieldcid := r.namecid;
          end;
        end if;
      
        if r.fieldid is not null and v_fieldcid is not null and
           r.value is not null then
          v_url := v_url ||  'document.' || upper(v_form) || '.' ||v_fieldcid  ||'.value' || '=' || r.jsfieldid || ';' ||
                   setHTP(r.value);
        elsif r.fieldid is not null and v_fieldcid is not null and
              r.value is null then
          v_url := v_url ||  'document.' || upper(v_form) || '.' ||v_fieldcid  ||'.value' || '=' || r.jsfieldid || ';';
        elsif r.fieldid is null and v_fieldcid is not null and
              r.value is not null then
          v_url := v_url ||  'document.' || upper(v_form) || '.' ||v_fieldcid  ||'.value' || '=' || setHTP(r.value) ||';';
        elsif r.fieldid is null and v_fieldcid is null and
              r.value is not null then
          v_url := v_url ||  setHTP(r.value);
        elsif r.fieldid is not null and v_fieldcid is null and
              r.value is not null then
--          v_url := v_url ||  setHTP(replace(upper(r.value), upper(r.blockid||r.fieldid)||'_VALUE' , r.jsfieldid ));
          v_url := v_url ||  setHTP(replace(r.value, upper(r.blockid||r.fieldid)||'_VALUE' , r.jsfieldid ));
        end if;
      
      end loop;
      
      v_url := substr(v_url, 1);
        
      else
      for r in (select decode(p.elementyn,
                              c_true,
                              decode(nvl(p.element,'INPUT_TEXT'),
                                     'FONT_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''||replace(value,''"'',''&quot;'')||' || c_nl || '''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''||replace(' || gpp.fieldid ||
                                                   ',''"'',''&quot;'')||' || c_nl || '''',
                                                   upper(nvl(pblockid, 'x')),
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(1),''"'',''&quot;'')||' || c_nl || '''')),
                                     'A_',
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''||replace(value,''"'',''&quot;'')||' || c_nl || '''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''||replace(' || gpp.fieldid ||
                                                   ',''"'',''&quot;'')||' || c_nl || '''',
                                                   upper(nvl(pblockid, 'x')),
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                                   '''||replace(' || gpp.blockid ||
                                                   gpp.fieldid ||
                                                   '(1),''"'',''&quot;'')||' || c_nl || '''')),
                                     decode(upper(gpp.fieldid),
                                            'THIS',
                                            '''''+this.value+' || c_nl ||
                                            '''''',
                                            decode(upper(gpp.blockid),
                                                   null,
                                                   '''''+document.' || upper(v_form) || '.' ||
                                                   gpp.fieldid || '.value+' || c_nl ||
                                                   '''''',
                                                   upper(nvl(pblockid, '-x')),
                                                   '''''+document.' || upper(v_form) || '.' ||
                                                   upper(gpp.blockid) || upper(gpp.fieldid) ||
                                                   '_''||substr(name,instr(name,''_'',-1)+1)||''' ||
                                                   '.value+' || c_nl || '''''',
                                                   '''''+document.' || upper(v_form) || '.' ||
                                                   upper(gpp.blockid) || upper(gpp.fieldid) || '_1' ||
                                                   '.value+' || c_nl || ''''''))),
                              decode(upper(gpp.fieldid),
                                     'THIS',
                                     '''||replace(value,''"'',''&quot;'')||''',
                                     decode(upper(gpp.blockid),
                                            null,
                                            '''||replace(' || gpp.fieldid ||
                                            ',''"'',''&quot;'')||' || c_nl || '''',
                                            upper(nvl(pblockid, 'x')),
                                            '''||replace(' || gpp.blockid ||
                                            gpp.fieldid ||
                                            '(to_number(substr(name,instr(name,''_'',-1)+1))),''"'',''&quot;'')||' || c_nl || '''',
                                            '''||replace(' || gpp.blockid ||
                                            gpp.fieldid ||
                                            '(1),''"'',''&quot;'')||' || c_nl || ''''))) jsfieldid,
                       gpp.blockid,
                       gpp.fieldid,
                       gpp.namecid,
                       gpp.value
                  from rasd_link_params gpp, rasd_fields p
                 where gpp.linkid = plinkid
                   and gpp.formid = pformid
                   and gpp.formid = p.formid(+)
                   and nvl(gpp.blockid, 'x') = nvl(p.blockid(+), 'x')
                   and gpp.fieldid = p.fieldid(+)
                   and nvl(gpp.fieldid,'##x##')not in ('#JSLINK#')                   
                   and gpp.type = 'OUT') loop
        --defining target field
        v_fieldcid := '';
        if r.namecid is not null then
          begin
            select distinct r.namecid || decode(p.blockid, null, '', '_1')
              into v_fieldcid
              from rasd_fields p, rasd_forms f
             where upper(f.form) = replace(replace(upper(v_text),'.WEBCLIENT',''),'!','')
               and f.formid = p.formid
               and p.nameid = r.namecid;
          exception
            when others then
              v_fieldcid := r.namecid;
          end;
        end if;
      
        if r.fieldid is not null and v_fieldcid is not null and
           r.value is not null then
          v_url := v_url || '&' || v_fieldcid || '=' || r.jsfieldid || '&' ||
                   setHTP(r.value);
        elsif r.fieldid is not null and v_fieldcid is not null and
              r.value is null then
          v_url := v_url || '&' || v_fieldcid || '=' || r.jsfieldid;
        elsif r.fieldid is null and v_fieldcid is not null and
              r.value is not null then
          v_url := v_url || '&' || v_fieldcid || '=' || setHTP(r.value);
        elsif r.fieldid is null and v_fieldcid is null and
              r.value is not null then
          v_url := v_url || '&' || setHTP(r.value);
        elsif r.fieldid is not null and v_fieldcid is null and
              r.value is not null then
          v_url := v_url || '&' || setHTP(replace(upper(r.value), upper(r.blockid||r.fieldid)||'_VALUE' , r.jsfieldid ));
        end if;
      end loop;
    
      if v_url is null then
        v_url := v_text;
      elsif instr(v_text,'?') > 0 then
        v_url := v_text || v_url;
      else  
        v_url := v_text || '?' || substr(v_url, 2);        
      end if;
      
      end if;
    end if;
    return(v_url);
  end;

  procedure jsLinkIN(pformid rasd_forms.formid%type,
                     ptype   varchar2 default 'P') is
    v_form     rasd_forms.form%type;
    v_fieldcid varchar2(100);
    n          pls_integer;
    v_link     pls_integer := 0;
  begin
    select form into v_form from rasd_forms where formid = pformid;
    for rpov in (select distinct replace(replace(upper(gpov.text), '!', ''),
                                         '.webclient') form,
                                 gpov.linkid,
                                 gpov.location
                   from rasd_links gpov, rasd_fields gp
                  where gpov.formid = pformid
                    and gpov.type in ('F', 'U')
                    and gpov.formid = gp.formid(+)
                    and gpov.linkid = gp.linkid(+)) loop
      if ptype = 'G' and rpov.location = 'N' then
        -- returning parameters are only when forms are linked
        select count(*)
          into n
          from rasd_link_params pp
         where pp.formid = pformid
           and pp.linkid = rpov.linkid
           and nvl(pp.fieldid,'##x##') not in ('#JSLINK#')
           and pp.type = 'IN';
        if n > 0 then
          addcnl('    htp.p(''<SCRIPT LANGUAGE="JavaScript">'');');
        
          addcnl('    htp.p(''function js_' || rpov.linkid ||
                 '(p,w) {'');');
          addcnl('    htp.p(''  var i = 0;'');');
          addcnl('    htp.p(''  var pi;'');');
          addcnl('    htp.p(''  if (p.indexOf(''''_'''') == -1) pi = '''''''';'');');
          addcnl('    htp.p(''  else pi = p.substring(p.indexOf(''''_''''));'');');
          addcnl('    htp.p(''  while(i < document.' || v_form ||
                 '.elements.length){'');');
          for r in (select gpp.blockid,
                           gpp.fieldid,
                           gpp.namecid namecid,
                           decode(gpp.fieldid,
                                  'THIS',
                                  'p',
                                  decode(gpp.blockid,
                                         null,
                                         '''''' || gpp.fieldid || '''''',
                                         '''''' || gpp.blockid || gpp.fieldid ||
                                         '''''+pi')) v_fieldid
                      from rasd_link_params gpp
                     where gpp.linkid = rpov.linkid
                       and gpp.formid = pformid
                       and nvl(gpp.fieldid,'##x##') not in ('#JSLINK#')
                       and gpp.type = 'IN') loop
            -- target field
            v_fieldcid := '';
            if r.namecid is not null then
              begin
                select distinct r.namecid ||
                                decode(p.blockid, null, '', '_1')
                  into v_fieldcid
                  from rasd_fields p, rasd_forms f
                 where upper(f.form) = upper(rpov.form)
                   and f.formid = p.formid
                   and p.nameid = r.namecid;
              exception
                when others then
                  v_fieldcid := r.namecid;
              end;
            end if;
            addcnl('    htp.p(''    if (document.' || v_form ||
                   '.elements[i].name == ' || r.v_fieldid || ') {'');');
            addcnl('    htp.p(''     document.' || v_form ||
                   '.elements[i].value = w.' || rpov.form || '.' ||
                   v_fieldcid || '.value;}'');');
          end loop;
          addcnl('    htp.p(''    i++;'');');
          addcnl('    htp.p(''  }'');');
          addcnl('    htp.p(''}'');');
          addcnl('    htp.p(''</SCRIPT>'');');
        end if;
      elsif ptype = 'P' then

        addcnl('  function js_' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) return varchar2 is');
        addcnl('   v_return varchar2(32000) := '''';');
        addcnl('  begin');
        addcnl('    if 1=2 then null;');
        v_link := 0;
        for rp in (select p.nameid,
                          p.blockid,
                          p.fieldid,
                          l.linkid,
                          l.location,
                          p.element
                     from rasd_fields p, rasd_links l
                    where l.linkid = p.linkid
                      and l.formid = p.formid
                      and p.formid = pformid
                      and l.type in ('F', 'U')
                      and p.linkid = rpov.linkid) loop
          v_link := 1;
          addcnl('    elsif name like ''' || rp.nameid || '%'' then');
          
          if rp.element = 'INPUT_SUBMIT' then
          addcnl('      v_return := v_return || ''' ||
                 addLINK(pformid, rp.blockid, rp.fieldid, rp.linkid) ||
                 ''';');

          else  
          addcnl('      v_return := v_return || ''''''' ||
                 addLINK(pformid, rp.blockid, rp.fieldid, rp.linkid) ||
                 ''''''';');
          end if;       
        end loop;
        if v_link = 1 then
          addcnl('    elsif name is null then');
          addcnl('      v_return := v_return ||''''''' ||
                 addLINK(pformid, '', '', rpov.linkid) || ''''''';');
          v_link := 0;
        end if;
        addcnl('    end if;');
        addcnl('    return v_return;');
        addcnl('  end;');


        addcnl('  procedure js_' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          addcnl('      htp.prn(js_' || rpov.linkid ||'(value, name));');
        addcnl('  end;');

/*
        addcnl('  procedure js_' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
        addcnl('    if 1=2 then null;');
        v_link := 0;
        for rp in (select p.nameid,
                          p.blockid,
                          p.fieldid,
                          l.linkid,
                          l.location
                     from rasd_fields p, rasd_links l
                    where l.linkid = p.linkid
                      and l.formid = p.formid
                      and p.formid = pformid
                      and l.type in ('F', 'U')
                      and p.linkid = rpov.linkid) loop
          v_link := 1;
          addcnl('    elsif name like ''' || rp.nameid || '%'' then');
          addcnl('      htp.prn(''''''' ||
                 addLINK(pformid, rp.blockid, rp.fieldid, rp.linkid) ||
                 ''''''');');
        end loop;
        if v_link = 1 then
          addcnl('    elsif name is null then');
          addcnl('      htp.prn(''''''' ||
                 addLINK(pformid, '', '', rpov.linkid) || ''''''');');
          v_link := 0;
        end if;
        addcnl('    end if;');
        addcnl('  end;');
*/

      end if;
    end loop;
  end;

  procedure jsSQL(pformid rasd_forms.formid%type,
                  ptype   varchar2 default 'P') is
    v_form rasd_forms.form%type;
  begin
    select form into v_form from rasd_forms where formid = pformid;
    for rpov in (select distinct gpov.text lsql, gpov.linkid, gp.element
                   from rasd_links gpov, rasd_fields gp
                  where gpov.formid = pformid
                    and gpov.type = 'S'
                    and nvl(gp.element,'INPUT_TEXT') in ('FONT_RADIO', 'SELECT_')
                    and gpov.formid = gp.formid
                    and gpov.linkid = gp.linkid
                    and nvl(gpov.location, 'I') = 'I'
                    and gpov.text is not null) loop
      if ptype = 'G' then
        addcnl('    htp.p(''<script language="JavaScript">'');');
        if upper(rpov.element) = 'SELECT_' then
          
          addcnl('    htp.p(''function js_S' || rpov.linkid ||
                 '(pvalue, pobjectname) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pobjectname+''''_RASD''''); '');');  --added 14.3.2018
          addcnl('    for r__ in (');
          addcnl('--<lovsql formid="' || pformid || '" linkid="' ||
                 rpov.linkid || '">');
          addcnl(rpov.lsql);
          addcnl('--</lovsql>');
          addcnl('    ) loop');
          addcnl('      htp.p(''  var option = document.createElement("option"); option.value="''||r__.id||''"; option.text = "''||replace(r__.label,'''''''',''\'''''')||''"; option.selected = ((pvalue==''''''||r__.id||'''''')?'''' selected '''':''''''''); x.add(option);'');'); --added 14.3.2018
--          addcnl('      htp.p(''  document.write(''''<option class=rasdSelectp ''''+ ((pvalue==''''''||r__.id||'''''')?''''selected'''':'''''''') +'''' value="''||r__.id||''">''||replace(r__.label,'''''''',''\'''''')||''</option>'''')'');');
          addcnl('    end loop;');
          addcnl('    htp.p(''}'');');
        elsif upper(rpov.element) = 'FONT_RADIO' then
          addcnl('    htp.p(''function js_R' || rpov.linkid ||
                 '(pname, pvalue) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pname+''''_RASD''''); '');');  --added 20.3.2018
          addcnl('    for r__ in (');
          addcnl('--<lovsql formid="' || pformid || '" linkid="' ||
                 rpov.linkid || '">');
          addcnl(rpov.lsql);
          addcnl('--</lovsql>');
          addcnl('    ) loop');
--          addcnl('       htp.p(''  document.write(''''<input type="radio" class=rasdRadio name="''''+pname+''''" ''''+ ((pvalue==''''''||r__.id||'''''')?'''' checked '''':'''''''') +'''' value="''||r__.id||''" >''||replace(r__.label,'''''''',''\'''''')||'''''')'');');
          addcnl('       htp.p(''   var option = document.createElement("input"); option.type = "radio"; option.className = "rasdRadio"; option.name = pname; option.type = "radio"; option.value = "''||r__.id||''"; option.checked = ((pvalue==''''''||r__.id||'''''')?'''' checked '''':''''''''); x.appendChild(option);'');'); --added 20.3.2018
          addcnl('       htp.p(''   var tekst = document.createTextNode("''||replace(r__.label,'''''''',''\'''''')||''"); x.appendChild(tekst); '');');  --added 20.3.2018
          addcnl('    end loop;');
          addcnl('    htp.p(''}'');');
        end if;
        addcnl('    htp.prn(''</script>'');');
      elsif ptype = 'P' then
        if upper(rpov.element) = 'SELECT_' then
        addcnl('  procedure js_S' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_S' || rpov.linkid ||
                 '(''''''||value||'''''',''''''||name||'''''');'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        elsif upper(rpov.element) = 'FONT_RADIO' then
        addcnl('  procedure js_R' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_R' || rpov.linkid ||
                 '(''''''||name||'''''',''''''||value||'''''');'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        end if;
      end if;
    end loop;
  end;

  procedure jsTEXT(pformid rasd_forms.formid%type,
                   ptype   varchar2 default 'P') is
    v_form rasd_forms.form%type;
  begin
    select form into v_form from rasd_forms where formid = pformid;
    for rpov in (select distinct gpov.text lsql, gpov.linkid, gp.element
                   from rasd_links gpov, rasd_fields gp
                  where gpov.formid = pformid
                    and gpov.type = 'T'
                    and nvl(gp.element,'INPUT_TEXT') in ('FONT_RADIO', 'SELECT_')
                    and nvl(gpov.location, 'I') = 'I'
                    and gpov.formid = gp.formid
                    and gpov.linkid = gp.linkid) loop
      if ptype = 'G' then
        addcnl('    htp.p(''<script language="JavaScript">'');');
        if upper(rpov.element) = 'SELECT_' then
          addcnl('    htp.p(''function js_S' || rpov.linkid ||
                 '(pvalue, pobjectname) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pobjectname+''''_RASD''''); '');');  --added 14.3.2018
          for r in (select gpp.value,
                           --nvl(gpp.code, substr(value, 1, 10)) code,
                           gpp.code code
                      from rasd_link_params gpp
                     where gpp.linkid = rpov.linkid
                       and gpp.formid = pformid
                       and gpp.type = 'TEXT'
                     order by orderby) loop
            addcnl('      htp.p(''  var option = document.createElement("option"); option.value="' ||
                   r.code || '"; option.text = "' || replace(setHTP(r.value),'''''','\''''') || '"; option.selected = ((pvalue=='''''||r.code ||''''')?'''' selected '''':''''''''); x.add(option);'');'); --added 14.3.2018                     
           -- addcnl('      htp.p(''  document.write(''''<option class=rasdSelectp ''''+ ((pvalue==''''' ||
           --        r.code ||
           --        ''''')?''''selected'''':'''''''') +'''' value="' ||
           --        r.code || '">' || replace(setHTP(r.value),'''''','\''''') || '</option>'''')'');');
          end loop;
          addcnl('    htp.p(''}'');');
        elsif upper(rpov.element) = 'FONT_RADIO' then
          addcnl('    htp.p(''function js_R' || rpov.linkid ||
                 '(pname, pvalue) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pname+''''_RASD''''); '');');  --added 20.3.2018                 
          for r in (select gpp.value,
                           --nvl(gpp.code, substr(value, 1, 10)) code
                           gpp.code code
                      from rasd_link_params gpp
                     where gpp.linkid = rpov.linkid
                       and gpp.formid = pformid
                       and gpp.type = 'TEXT'
                     order by orderby) loop
        --    addcnl('      htp.p(''  document.write(''''<input type="radio" class=rasdRadio name="''''+pname+''''" ''''+ ((pvalue==''''' ||
          --         r.code ||
            --       ''''')?'''' checked '''':'''''''') +'''' value="' ||
              --     r.code || '">' || replace(setHTP(r.value),'''''','\''''') || ''''')'');');                   
             addcnl('       htp.p(''   var option = document.createElement("input"); option.type = "radio"; option.className = "rasdRadio"; option.name = pname; option.type = "radio"; option.value = "'||r.code ||'"; option.checked = ((pvalue=='''''||r.code ||''''')?'''' checked '''':''''''''); x.appendChild(option);'');'); --added 20.3.2018
             addcnl('       htp.p(''   var tekst = document.createTextNode("' || replace(setHTP(r.value),'''''','\''''') || '"); x.appendChild(tekst); '');');  --added 20.3.2018
                   
          end loop;
          addcnl('    htp.p(''}'');');
        end if;
        addcnl('    htp.p(''</script>'');');
      elsif ptype = 'P' then
        if upper(rpov.element) = 'SELECT_' then
        addcnl('  procedure js_S' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
         addcnl('  begin');
          addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_S' || rpov.linkid ||
                 '(''''''||value||'''''',''''''||name||'''''')'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        elsif upper(rpov.element) = 'FONT_RADIO' then
         addcnl('  procedure js_R' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
         addcnl('  begin');
         addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_R' || rpov.linkid ||
                 '(''''''||name||'''''',''''''||value||'''''')'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        end if;
      end if;
    end loop;
  end;
  procedure jsTRUEFALSE(pformid rasd_forms.formid%type,
                        ptype   varchar2 default 'P') is
    v_true rasd_link_params.code%type;
    v_false rasd_link_params.code%type;
  begin
    for rpov in (select distinct gpov.text   lsql,
                                 gpov.linkid linkid,
                                 gp.element
                   from rasd_links gpov, rasd_fields gp
                  where gp.formid = pformid
                    and nvl(gp.element,'INPUT_TEXT') in
                        ('FONT_RADIO', 'SELECT_', 'INPUT_CHECKBOX')
                    and gpov.formid = gp.formid
                    and gpov.linkid = gp.linkid
                    and gpov.type = 'C'
                    and nvl(gpov.location, 'I') = 'I') loop
      if ptype = 'G' then
        addcnl('    htp.prn(''<script language="JavaScript">'');');
        if upper(rpov.element) = 'SELECT_' then
          addcnl('    htp.p(''function js_S' || rpov.linkid ||
                 '(pvalue,pobjectname) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pobjectname+''''_RASD''''); '');');  --added 14.3.2018                 
          for r in (select gpp.value,
                           --nvl(gpp.code, substr(value, 1, 10)) code
                           gpp.code code
                      from rasd_link_params gpp
                     where gpp.linkid = rpov.linkid
                       and gpp.formid = pformid
                       and gpp.type in ('TRUE', 'FALSE')
                     order by gpp.type) loop
            addcnl('      htp.p(''  var option = document.createElement("option"); option.value="' ||
                   r.code || '"; option.text = "' || replace(setHTP(r.value),'''''','\''''') || '";  option.selected = ((pvalue=='''''||r.code ||''''')?'''' selected '''':''''''''); x.add(option);'');'); --added 14.3.2018                                          
--            addcnl('      htp.p(''  document.write(''''<option class=rasdSelectp ''''+ ((pvalue==''''' ||
  --                 r.code ||
    --               ''''')?''''selected'''':'''''''') +'''' value="' ||
      --             r.code || '">' || setHTP(r.value) || '</option>'''')'');');
          end loop;
          addcnl('    htp.p(''}'');');
        elsif upper(rpov.element) = 'FONT_RADIO' then
          addcnl('    htp.p(''function js_R' || rpov.linkid ||
                 '(pname, pvalue) {'');');
          addcnl('      htp.p('' var x = document.getElementById(pname+''''_RASD''''); '');');  --added 20.3.2018                                  
          for r in (select gpp.value,
                           --nvl(gpp.code, substr(value, 1, 10)) code
                           gpp.code code
                      from rasd_link_params gpp
                     where gpp.linkid = rpov.linkid
                       and gpp.formid = pformid
                       and gpp.type in ('TRUE', 'FALSE')
                     order by gpp.type) loop
--            addcnl('      htp.p(''  document.write(''''<input type="radio" class=rasdRadio name="''''+pname+''''" ''''+ ((pvalue==''''' ||
  --                 r.code ||
    --               ''''')?'''' checked '''':'''''''') +'''' value="' ||
      --             r.code || '">' || setHTP(r.value) || ''''')'');');
             addcnl('       htp.p(''   var option = document.createElement("input"); option.type = "radio"; option.className = "rasdRadio"; option.name = pname; option.type = "radio"; option.value = "'||r.code ||'"; option.checked = ((pvalue=='''''||r.code ||''''')?'''' checked '''':''''''''); x.appendChild(option);'');'); --added 20.3.2018
             addcnl('       htp.p(''   var tekst = document.createTextNode("' || setHTP(r.value) || '"); x.appendChild(tekst); '');');  --added 20.3.2018
                   
          end loop;
          addcnl('    htp.p(''}'');');
        end if;
        addcnl('    htp.p(''</script>'');');
      elsif ptype = 'P' then
        if upper(rpov.element) = 'SELECT_' then
        addcnl('  procedure js_S' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_S' || rpov.linkid ||
                 '(''''''||value||'''''',''''''||name||'''''')'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        elsif upper(rpov.element) = 'FONT_RADIO' then
        addcnl('  procedure js_R' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          addcnl('    htp.p(''<script language="JavaScript">'');');
          addcnl('    htp.p(''js_R' || rpov.linkid ||
                 '(''''''||name||'''''',''''''||value||'''''');'');');
          addcnl('    htp.p(''</script>'');');
        addcnl('  end;');
        elsif upper(rpov.element) = 'INPUT_CHECKBOX' then
        addcnl('  procedure js_C' || rpov.linkid ||
               '(value varchar2, name varchar2 default null) is');
        addcnl('  begin');
          begin
            select nvl(gpp.code, substr(value, 1, 100))
              into v_true
              from rasd_link_params gpp
             where gpp.linkid = rpov.linkid
               and gpp.formid = pformid
               and gpp.type = 'TRUE';
            select nvl(gpp.code, substr(value, 1, 100))
              into v_false
              from rasd_link_params gpp
             where gpp.linkid = rpov.linkid
               and gpp.formid = pformid
               and gpp.type = 'FALSE';
          exception
            when others then
              v_true := c_true;
              v_false := c_false;
          end;
          addcnl('  if value = ''' || v_true || ''' then ');
          addcnl('    htp.prn(''' || v_true || '" ONCLICK="if (this.checked) { this.value='''''||v_true||'''''; } else { this.value='''''||v_false||''''';}" checked "'');');
          addcnl('  else');
          addcnl('    htp.prn(''' || v_false || '" ONCLICK="if (this.checked) { this.value='''''||v_true||'''''; } else { this.value='''''||v_false||''''';}" "'');');
          addcnl('  end if; ');
        addcnl('  end;');
        end if;
      end if;
    end loop;
  end;

  procedure jsMandatory (pformid rasd_forms.formid%type, ptype   varchar2 default 'P') is 
     i number := 0;
     j number := 0;
     vfieldn varchar2(10);
  begin
/*
function checkMandatoryFields() {
   var i = 0;
   
   //blok velikosti 1 brez In.
   i = i + CheckFieldMandatory(''B10S1_1_RASD'', ''''); //TEXT
   i = i + CheckFieldMandatory(''B10S2_1_RASD'', ''''); //TEXTAREA
   i = i + CheckFieldMandatory(''B10S3_1_RASD'', ''''); //TEXT PWD
   i = i + CheckFieldMandatory(''B10S4_1_RASD'', '''');//SELECT 
   i = i + CheckFieldMandatory(''B10S5_1_RASD'', ''B10S5_1''); //RADIO
   i = i + CheckFieldMandatory(''B10S6_1_RASD'', ''''); //CHECKBOX
  

  try {
  for (j__ = 1; j__ < 9999; j__++) { 
   if (   CheckFieldValue(''B20A4_''+j__+''_RASD'','''') //pogoji iz polj In.
	   || CheckFieldValue(''B20A3_''+j__+''_RASD'','''') 
	  ) 
   
   {
   
   i = i + CheckFieldMandatory(''B20A1_''+j__+''_RASD'', ''''); //pogoji iz polj Mn.
   i = i + CheckFieldMandatory(''B20A2_''+j__+''_RASD'', '''');
   i = i + CheckFieldMandatory(''B20A3_''+j__+''_RASD'', '''');
   i = i + CheckFieldMandatory(''B20A4_''+j__+''_RASD'', '''');
   i = i + CheckFieldMandatory(''B20A5_''+j__+''_RASD'', ''B20A5_''+j__+'''');
   i = i + CheckFieldMandatory(''B20A6_''+j__+''_RASD'', ''''); 
   
   }
  }  
  }
   catch(err) {
     //alert(err.message);
  }
  
   if (i > 0) { return false; } else { return true; }
}
*/    
-- addcnl('procedure jsMandatory(ppage varchar2 default ''0'') is');
-- addcnl('    begin');
 addcnl('    htp.p(''<script language="JavaScript">'');');
 
 

 for rb in c_blocks(pformid) loop  

 addcnl('    htp.p(''function cMF'||rb.blockid||'() {'');');
 addcnl('    htp.p(''var i = 0;'');');

    j := 0;
    for rp in c_fieldsOfBlock(pformid, rb.blockid) loop
      if    nvl(rp.elementyn, c_false) = c_true 
        and nvl(rp.notnullyn, c_false) = c_true
        and nvl(rp.element,'INPUT_TEXT') in ('INPUT_TEXT','TEXTAREA_','SELECT_','FONT_RADIO' ,'INPUT_CHECKBOX' ,'INPUT_PASSWORD')
        then
           j := 1;
        end if;  
    end loop;   
   if j > 0 then
   
   addcnl('    htp.p(''  try { for (j__ = 1; j__ <= '||owa_util.ite( rb.numrows=0 , 9999,rb.numrows)||'; j__++) { '');');

   -- preveri insertnnyn če ta del izvede
    i := 0;
    for rp in c_fieldsOfBlock(pformid, rb.blockid) loop
    if    nvl(rp.elementyn, c_false) = c_true 
        and nvl(rp.insertnnyn, c_false) = c_true
        and nvl(rp.element,'INPUT_TEXT') in ('INPUT_TEXT','TEXTAREA_','SELECT_','FONT_RADIO' ,'INPUT_CHECKBOX' ,'INPUT_PASSWORD')
        then
           i := 1;
        end if;  
    end loop;   
   if i > 0 then
   addcnl('    htp.p('' if (  1==2 '');');   
      for rp in c_fieldsOfBlock(pformid, rb.blockid) loop
      if    nvl(rp.elementyn, c_false) = c_true 
        and nvl(rp.insertnnyn, c_false) = c_true
        and nvl(rp.element,'INPUT_TEXT') in ('INPUT_TEXT','TEXTAREA_','SELECT_','FONT_RADIO' ,'INPUT_CHECKBOX' ,'INPUT_PASSWORD')
        then
   if rp.type = 'D' then vfieldn := ''; else vfieldn := '_RASD'; end if;      
         if rp.element = 'FONT_RADIO' then
   addcnl('    htp.p(''	   || CheckFieldValue('''''||rp.nameid||'_''''+j__+'''''||vfieldn||''''','''''||rp.nameid||'_''''+j__+'''''''') '');');
         else           
   addcnl('    htp.p(''	   || CheckFieldValue('''''||rp.nameid||'_''''+j__+'''''||vfieldn||''''','''''''') '');');
         end if;
     end if;        
      end loop;
   addcnl('    htp.p(''  )'');');
   end if;  
   
   addcnl('    htp.p(''  {'');');
      for rp in c_fieldsOfBlock(pformid, rb.blockid) loop
      if    nvl(rp.elementyn, c_false) = c_true 
        and nvl(rp.notnullyn, c_false) = c_true
        and nvl(rp.element,'INPUT_TEXT') in ('INPUT_TEXT','TEXTAREA_','SELECT_','FONT_RADIO' ,'INPUT_CHECKBOX' ,'INPUT_PASSWORD')
        then
   if rp.type = 'D' then vfieldn := ''; else vfieldn := '_RASD'; end if;      
         if rp.element = 'FONT_RADIO' then
   addcnl('    htp.p(''   i = i + CheckFieldMandatory('''''||rp.nameid||'_''''+j__+'''''||vfieldn||''''', '''''||rp.nameid||'_''''+j__+'''''''');'');');           
         else 
   addcnl('    htp.p(''   i = i + CheckFieldMandatory('''''||rp.nameid||'_''''+j__+'''''||vfieldn||''''', '''''''');'');');
         end if;     
     end if;
     end loop;
   addcnl('    htp.p(''  }'');');
   addcnl('    htp.p(''  } } catch(err) {'');');
   addcnl('    htp.p(''      //alert(err.message);'');');
   addcnl('    htp.p(''  }'');');

   end if; 

 addcnl('    htp.p(''if (i > 0) { return false; } else { return true; }'');');
 addcnl('    htp.p(''}'');');
 
 end loop;

 

 addcnl('    htp.p(''function cMF() {'');');
 addcnl('    htp.p(''var i = 0;'');');
 

 for rb in c_blocks(pformid) loop  

    j := 0;
    for rp in c_fieldsOfBlock(pformid, rb.blockid) loop
      if    nvl(rp.elementyn, c_false) = c_true 
        and nvl(rp.notnullyn, c_false) = c_true
        and nvl(rp.element,'INPUT_TEXT') in ('INPUT_TEXT','TEXTAREA_','SELECT_','FONT_RADIO' ,'INPUT_CHECKBOX' ,'INPUT_PASSWORD')
        then
           j := 1;
        end if;  
    end loop;   
   if j > 0 then
   
   addcnl('    htp.p(''  if ( cMF'||rb.blockid||'() == false ) { i++; } '');');

   end if; 
 end loop;

 
 addcnl('    htp.p(''if (i > 0) { return false; } else { return true; }'');');
 addcnl('    htp.p(''}'');');
 addcnl('    htp.p(''</script>'');');
-- addcnl('    end;');
  end;


  /*******************************************************************************************/
  /*******************************************************************************************/
  procedure AREA_PLSQL_CODE is
  begin
    null;
  end;
  /*******************************************************************************************/

  procedure plsqlSQLTEXT(pformid rasd_forms.formid%type,
                         ptype   varchar2,
                         p_lang  varchar2) is
    v_form        rasd_forms.form%type;
    v_firstrecord boolean;
    v_i           number := 0;
    n             number;
    i             number;
  begin
    select form into v_form from rasd_forms where formid = pformid;
  
    /*select count(*) -- not connected to field
      into n
      from rasd_links p, rasd_fields pp
     where p.formid = pformid
       and p.formid = pp.formid
       and p.linkid = pp.linkid
       and p.type in ('T', 'S', 'C');*/
    select count(*)
      into n
      from rasd_links p
     where p.formid = pformid
       and p.type in ('T', 'S', 'C');       
    if n > 0 then
      if ptype = 'G' then

        addcnl('');
        addcnl(' procedure on_submit(name_array  in owa.vc_arr, value_array in owa.vc_arr);');
        addcnl('');
        addcnl('procedure ' || c_openLOVname || '(');
        addcnl('  name_array  in owa.vc_arr,');
        addcnl('  value_array in owa.vc_arr');
        addcnl(') is');
        addcnl('  num_entries number := name_array.count;');
        for r in (select distinct l.blockid || l.fieldid || '  ' ||
                                  decode(upper(p.type),
                                         'N',
                                         'number',
                                         'C',
                                         'varchar2(2000)',
                                         'D',
                                         'date',
                                         'T',
                                         'timestamp',
                                         'R',
                                         'rowid') zapis
                    from rasd_link_params l,
                         rasd_fields      p,
                         rasd_links       pov,
                         rasd_fields      px
                   where upper(l.type) = 'WHERE'
                     and l.formid = p.formid
                     and l.fieldid = p.fieldid
                     and l.formid = pformid
                     and l.linkid = pov.linkid
                     and l.formid = pov.formid
                     and pov.type in ('S', 'T')
                     and pov.linkid = px.linkid
                     and pov.formid = px.formid) loop
          addcnl('  ' || r.zapis || ';');
        end loop;
        for r in (select p.text, p.linkid
                    from rasd_links p--, rasd_fields po
                   where p.formid = pformid
                     and p.type = 'S'
--                     and p.formid = po.formid
--                     and p.linkid = po.linkid
--                     and nvl(po.element,'INPUT_TEXT') not in ('FONT_RADIO', 'SELECT_')
                     and p.text is not null) loop
          addcnl('cursor c_' || r.linkid || '(p_id varchar2) is ');
          addcnl('--<lovsql formid="' || pformid || '" linkid="' ||
                 r.linkid || '">');
          addcnl('select id, label from ('||r.text||' ) where upper(id) like ''%''||upper(p_id)||''%'' or upper(label) like ''%''||upper(p_id)||''%'' ');          
          addcnl('--</lovsql>');
          addcnl(';');
        end loop;
      
        addcnl('TYPE pLOVType IS RECORD (');
        addcnl('output varchar2(300),');
        addcnl('p1 varchar2(200)');
        addcnl(');');
        addcnl('  TYPE tab_pLOVType IS TABLE OF pLOVType INDEX BY BINARY_INTEGER;');
        addcnl('  v_lov tab_pLOVType;');
        addcnl('  v_counter number := 1;');
        addcnl('  v_description varchar2(100);');
        addcnl('  p_lov varchar2(100);');
        addcnl('  p_nameid varchar2(100);');
        addcnl('  p_id varchar2(100);');
        addcnl('  v_output boolean;');
        addcnl('  v_call varchar2(10);');
        addcnl('  '||c_restrestype||' varchar2(10);');
        addcnl('begin');
        addcnl('  on_submit(name_array, value_array);');
        addcnl('  for i in 1..num_entries loop');
        addcnl('    if name_array(i) = ''PLOV'' then p_lov := value_array(i);');
        addcnl('    elsif name_array(i) = ''FIN'' then p_nameid := value_array(i);');
        addcnl('    elsif name_array(i) = ''PID'' then p_id := value_array(i);');
        addcnl('    elsif upper(name_array(i)) = ''CALL'' then v_call := value_array(i);');
        addcnl('    elsif upper(name_array(i)) = upper('''||c_restrestype||''') then '||c_restrestype||' := value_array(i);');
      /*  for r in (select '  elsif upper(name_array(i)) = upper(''' ||
                         l.blockid || l.fieldid || ''') then ' || l.blockid ||
                         l.fieldid || ' := ' ||
                         decode(upper(p.type),
                                'N',
                                decode(p.format,
                                       null,
                                       re.library ||
                                       '.varchr2number(value_array(i))',
                                       'to_number(value_array(i),' || p.format || ')'),
                                'C',
                                'value_array(i)',
                                'D',
                                decode(p.format,
                                       null,
                                       'to_date(value_array(i),' || re.library ||
                                       '.c_date_format)',
                                       'to_date(value_array(i),' || p.format || ')'),
                                'R',
                                'rowid') rowvalue
                    from rasd_link_params l, rasd_fields p, rasd_links pov
                   where l.formid = pformid
                     and upper(l.type) = 'WHERE'
                     and p.formid = l.formid
                     and p.fieldid = l.fieldid
                     and nvl(p.blockid, 'x') = nvl(l.blockid, 'x')
                     and pov.linkid = l.linkid
                     and pov.type in ('S')
                     and pov.linkid = l.linkid
                     and pov.formid = l.formid) loop
          addcnl('  ' || r.rowvalue || ';');
        end loop;*/
        addcnl('    end if;');
        addcnl('  end loop;');
        v_firstrecord := true;
        v_i           := 0;
        for r in (select distinct p.text, p.linkid, p.link
                    from rasd_links p--, rasd_fields px
                   where p.formid = pformid
                     and p.type = 'S'
                     and p.text is not null
                     --and p.linkid = px.linkid
                     --and nvl(px.element,'INPUT_TEXT') in ('INPUT_TEXT') --not in ('FONT_RADIO', 'SELECT_')
                     --and p.formid = px.formid
                     ) loop
          if v_firstrecord then
            addcnl('  if p_lov = ''' || r.linkid || ''' then');
          else
            addcnl('  elsif p_lov = ''' || r.linkid || ''' then');
          end if;
          addcnl('    v_description := ''' || nvl(setHTP(r.link), r.linkid) ||
                 ''';');
          addcnl('    for r in c_' || r.linkid || '(p_id) loop');
          addcnl('        v_lov(v_counter).p1 := r.id;');
          addcnl('        v_lov(v_counter).output := r.label;');
          addcnl('        v_counter := v_counter + 1;');
          addcnl('    end loop;');
          addcnl('    v_counter := v_counter - 1;');
          v_i           := 1;
          v_firstrecord := false;
        end loop;
        for r in (select p.text, p.linkid, p.link
                    from rasd_links p--, rasd_fields px
                   where p.formid = pformid
                     and p.type = 'T'
                     --and p.linkid = px.linkid
                     --and p.formid = px.formid
                     ) loop
          if v_firstrecord then
            addcnl('  if p_lov = ''' || r.linkid || ''' then');
          else
            addcnl('  elsif p_lov = ''' || r.linkid || ''' then');
          end if;
          addcnl('    v_description := ''' ||
                 nvl(setHTP(r.link), r.linkid) || ''';');
          i := 1;
          for r1 in (select gp.value tekst,
                            decode(gp.code,
                                   null,
                                   --gp.value,
                                   gp.code,
                                   gp.code /*|| '#,#' || gp.value*/) value
                       from rasd_link_params gp
                      where gp.formid = pformid
                        and gp.linkid = r.linkid
                        and gp.type = 'TEXT'
                      order by gp.orderby) loop
            addcnl('        v_lov(' || i || ').output := ''' ||
                   setHTP(r1.tekst) || ''';');
            addcnl('        v_lov(' || i || ').p1 := ''' ||
                   setHTP(r1.value) || ''';');
            i := i + 1;
          end loop;
          addcnl('        v_counter := '|| (i  - 1) ||'; ');
          
          v_i           := 1;
          v_firstrecord := false;
        end loop;
        for r in (select p.text, p.linkid, p.link
                    from rasd_links p--, rasd_fields px
                   where p.formid = pformid
                     and p.type = 'C'
                     --and p.linkid = px.linkid
                     --and p.formid = px.formid
                     ) loop
          if v_firstrecord then
            addcnl('  if p_lov = ''' || r.linkid || ''' then');
          else
            addcnl('  elsif p_lov = ''' || r.linkid || ''' then');
          end if;
          addcnl('    v_description := ''' ||
                 nvl(setHTP(r.link), r.linkid) || ''';');
          i := 1;
          for r1 in (select gp.value tekst, gp.code
                       from rasd_link_params gp
                      where gp.formid = pformid
                        and gp.linkid = r.linkid
                        and gp.type in ('TRUE', 'FALSE')
                      order by gp.type) loop
            addcnl('        v_lov(' || i || ').output := ''' ||
                   setHTP(r1.tekst) || ''';');
            addcnl('        v_lov(' || i || ').p1 := ''' ||
                   setHTP(r1.code) || ''';');
            i := i + 1;
          end loop;
          addcnl('        v_counter := '|| (i  - 1) ||'; ');
         
          v_i           := 1;
          v_firstrecord := false;
        end loop;
        if v_i = 1 then
          addcnl('  else');
          addcnl('   return;');
          addcnl('  end if;');
        end if;
      
        addcnl('if v_call = ''REST'' then ');

        addcnl('if '||c_restrestype||' = ''XML'' then ');

        addcnl(' htp.p(''<?xml version="1.0" encoding="UTF-8"?>'||c_nl||'<openLOV LOV="''||p_lov||''" filter="''||p_id||''">'');      ');
        addcnl(' htp.p(''<result>'');');
        addcnl(' for i in 1..v_counter loop');
        addcnl(' htp.p(''<element><code>''||v_lov(i).p1||''</code><description>''||v_lov(i).output||''</description></element>'');');
        addcnl(' end loop; ');
        addcnl(' htp.p(''</result></openLOV>'');');

        addcnl('else ');

        addcnl(' htp.p(''{"openLOV":{"@LOV":"''||p_lov||''","@filter":"''||p_id||''",'' );      ');
        addcnl(' htp.p(''"result":['');');
        addcnl(' for i in 1..v_counter loop');
        addcnl('  if i = 1 then ');
        addcnl(' htp.p(''{"code":"''||v_lov(i).p1||''","description":"''||v_lov(i).output||''"}'');');
        addcnl('  else');
        addcnl(' htp.p('',{"code":"''||v_lov(i).p1||''","description":"''||v_lov(i).output||''"}'');');
        addcnl('  end if;');
        addcnl(' end loop; ');
        addcnl(' htp.p('']}}'');');

        addcnl('end if;');

        addcnl('else');
        addcnl(' htp.p(''');
        addcnl('<html>'');');       
        begin
        addcnl('    htp.prn(''');
        rasd_enginehtml10.writeHTMLHead(pformid);
        addcnl('    '');');
        exception when others then
        addcnl('    '');');
        end;
        addcnl(' htp.bodyOpen('''','''');');
                      
        addcnl('htp.p(''');
        addcnl('<script language="JavaScript">');
        addcnl('   function closeLOV() {');
        addcnl('     this.close();');
        addcnl('   }');
        addcnl('   function selectLOV() {');
        addcnl('     var value = window.document.''||p_lov||''.LOVlist.options[window.document.''||p_lov||''.LOVlist.selectedIndex].value;');
        addcnl('     var tekst = window.document.''||p_lov||''.LOVlist.options[window.document.''||p_lov||''.LOVlist.selectedIndex].text;');

        addcnl('     window.opener.''||p_nameid||''.value = value;');

        addcnl('     '');');
      
       /* for r in (select l.fieldid,
                         l.blockid || decode(l.fieldid,
                                             'THIS',
                                             '''||substr(p_nameid,1,instr(p_nameid,''_'',-1)-1)||''',
                                             l.fieldid) field,
                         l.orderby,
                         l.blockid,
                         pp.linkid
                    from rasd_link_params l, rasd_links pp
                   where upper(l.type) = 'INTO'
                     and l.formid = pformid
                     and l.formid = pp.formid
                     and l.linkid = pp.linkid
                     and pp.type = 'S'
                   order by l.orderby) loop
        
          addcnl('    if p_lov = ''' || r.linkid || ''' then');
          addcnl('    htp.p(''var ' || r.field || ' = "";');
          addcnl('       var ii = 0;');
          addcnl('       if (value.indexOf("#,#") != -1) {');
          addcnl('         for (var i = 1; i < ' || to_char(r.orderby) ||
                 '; i++){ii = value.indexOf("#,#",ii)+3;}');
          addcnl('        if (value.indexOf("#,#",ii) != -1) {    ');
          addcnl('            ' || r.field ||
                 ' = value.substr(ii,value.indexOf("#,#",ii)-ii);}');
          addcnl('        else {' || r.field || ' = value.substr(ii);}');
          addcnl('       }');
          addcnl('       else{' || r.field || ' = value;}');
          if r.blockid is null and r.fieldid = 'THIS' then
            addcnl('       opener.document.' || v_form ||
                   '.''||p_nameid||''.value=' || r.field || ';'');');
          elsif r.blockid is null and r.fieldid <> 'THIS' then
            addcnl('       opener.document.' || v_form || '.' || r.field ||
                   '.value=' || r.field || ';'');');
          else
            addcnl('      '');');
            addc('       if instr(''');
            for rr in (select p.blockid || p.fieldid field
                         from rasd_fields p
                        where p.formid = pformid
                          and p.blockid = r.blockid
                        order by p.orderby) loop
              addc(rr.field);
            end loop;
            addc('       '',substr(p_nameid,1,instr(p_nameid,''_'',-1)) > 0 then');
            addcnl('      htp.p(''opener.document.' || v_form || '.' ||
                   r.field ||
                   '_''||substr(p_nameid,instr(p_nameid,''_'',-1)+1)||''.value=' ||
                   r.field || ';'');');
            addcnl('      else;');
            addcnl('      htp.p(''opener.document.' || v_form || '.' ||
                   r.field || '_1.value=' || r.field || ';'');');
            addcnl('      end if;');
            addcnl('      htp.p(''');
          end if;
          addcnl('    end if;');
        end loop;*/
        addcnl('htp.p(''this.close ();');
        addcnl('   }');
        addcnl('  with (document) {');
        addcnl('  if (screen.availWidth < 900){');
        addcnl('    moveTo(-4,-4)}');
        addcnl('  }');
        addcnl('</script>'');');
        addcnl(' htp.p(''<div class="rasdLovName">''||v_description||''</div>'');');
        addcnl(' htp.formOpen(curl=>''!' || v_form || '.' || c_openLOVname ||
               ''',');
        addcnl('                 cattributes=>''name="''||p_lov||''"'');');
        addcnl(' htp.p(''<input type="hidden" name="PLOV" value="''||p_lov||''">'');');
        addcnl(' htp.p(''<input type="hidden" name="FIN" value="''||p_nameid||''">'');');
        addcnl(' htp.p(''<div class="rasdLov" align="center"><center>'');');
        addcnl(' htp.p('''||RASDI_TRNSLT.text('Filter', p_lang)||':<input type="text" name="PID" value="''||p_id||''" ></BR><input type="submit" class="rasdButton" value="'||RASDI_TRNSLT.text('Search', p_lang)||'"><input class="rasdButton" type="button" value="'||RASDI_TRNSLT.text('Clear', p_lang)||'" onclick="document.''||p_lov||''.PID.value=''''''''; document.''||p_lov||''.submit();"></BR>'');');        
        addcnl(' htp.formselectOpen(''LOVlist'',cattributes=>''size=15 width="100%"'');');
        addcnl(' for i in 1..v_counter loop');
        addcnl('  if i = 1 then -- fokus na prvem');
        addcnl('    htp.formSelectOption(cvalue=>v_lov(i).output,cselected=>1,Cattributes => ''value="''||v_lov(i).p1||''"'');');
        addcnl('  else');
        addcnl('    htp.formSelectOption(cvalue=>v_lov(i).output,Cattributes => ''value="''||v_lov(i).p1||''"'');');
        addcnl('  end if;');
        addcnl(' end loop;');
        addcnl(' htp.formselectClose;');
        addcnl(' htp.p('''');');
        addcnl(' htp.line;');
        addcnl(' htp.p(''<input type="button" class="rasdButton" value="' ||
               RASDI_TRNSLT.text('Select and Confirm', p_lang) ||
               '" onClick="selectLOV();">'');');
        addcnl(' htp.p(''<input type="button" class="rasdButton" value="' ||
               RASDI_TRNSLT.text('Close', p_lang) ||
               '" onClick="closeLOV();">'');');
        addcnl(' htp.p(''</center></div>'');');
        addcnl(' htp.p(''</form>'');');
        addcnl(' htp.p(''</body>'');');
        addcnl(' htp.p(''</html>'');');
        addcnl('end if;');
        addcnl('end;');
      elsif ptype = 'S' then
        addcnl('');
        addcnl('procedure ' || c_openLOVname || '(');
        addcnl('  name_array  in owa.vc_arr,');
        addcnl('  value_array in owa.vc_arr');
        addcnl(');');
      
      elsif ptype = 'P' then
      
        for r in (select distinct p.text, p.linkid, p.link
                    from rasd_links p, rasd_fields px
                   where p.formid = pformid
                     and p.type in ('S','T')
                     --and p.text is not null
                     and nvl(px.element,'INPUT_TEXT') not in ('FONT_RADIO', 'SELECT_')
                     and p.linkid = px.linkid
                     and p.formid = px.formid) loop
          addcnl('  procedure js_' || r.linkid ||
                 '(value varchar2, name varchar2 default null) is');
          addcnl('  begin');
          addcnl('    if 1=2 then null;');
          for rp in (select p.nameid,
                            p.blockid,
                            p.fieldid,
                            l.linkid,
                            l.location
                       from rasd_fields p, rasd_links l
                      where l.linkid = p.linkid
                        and l.formid = p.formid
                        and p.formid = pformid
                        and l.type in ('S','T')
                        and p.linkid = r.linkid) loop
            addcnl('    elsif name like ''' || rp.nameid || '%'' then');
            addcnl('      htp.prn(''' ||
                   addLOV(pformid, rp.blockid, rp.fieldid, rp.linkid) ||
                   ''');');
          end loop;
          addcnl('    end if;');
          addcnl('  end;');
        end loop;
      end if;
    end if;
  end;

  /*******************************************************************************************/
  procedure AREA_MAIN_PART is
  begin
    null;
  end;
  /*******************************************************************************************/
  /*******************************************************************************************/
  /*******************************************************************************************/
  /*******************************************************************************************/
  procedure form_create(p_formid rasd_forms.formid%type,
                 p_lang   rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage) IS
    tt          varchar2(32767);
    tt1          varchar2(32767);
    v_dummy     varchar2(14000);
    v_insertdummy varchar2(14000);
    v_where     varchar2(14000);
    v_firstrow  boolean;
    v_truefalse rasd_link_params.code%type;
    n           pls_integer;
    v_user      varchar2(4000) := rasdc_library.currentDADUser;
    v_i_record  varchar2(10) ;
    v_metadata  number;
    v_sess_yn   number;
  begin
    --engine data
    begin
      select *
        into re
        from rasd_engines
       where upper(server) = upper(c_engserver);
    exception
      when no_data_found then
        re.server  := c_engserver;
        re.client  := c_engclient;
        re.library := c_englibrary;
    end;
  
    v_gc.delete;
    v_gl := 0;
    for rf in c_form(p_formid) loop
      addFields(p_formid, p_lang);
      /***************************************************************************************/
      /*** SPECIFIKACIJA *********************************************************************/
      /***************************************************************************************/
      addcnl('create or replace package ' || v_user || '.' || rf.form ||
             ' is');
    
      addcnl('/*');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | RASD - Rapid Application Service Development                         |');
      addcnl('//   Program: ' || rf.form || ' generated on '||to_char(sysdate)||' by user '||user||'.     ');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | http://rasd.sourceforge.net                                          |');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | This program is generated form RASD version '||c_engversion||'.                       |');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('*/    ');
    
      addcnl('function version return varchar2;');    
    
      addcnl('function metadata return clob;');
      addcnl('procedure metadata;');
    
      addcnl('procedure webclient(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  );');
      
if rf.autocreatebatchyn = 'Y' then      
      addcnl('procedure main(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  );');
end if;

if rf.autocreaterestyn = 'Y' then      
      addcnl('procedure rest(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  );');
end if;

      addcnl('procedure rlog(v_clob clob);');

      addcnl('procedure form_js(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  );');
      addcnl('procedure form_css(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  );');

      for rpro in (select plsqlspec
                     from rasd_triggers
                    where formid = rf.formid
                      and blockid is null
                      and upper(triggerid) not in
                       (select tctype from RASD_TRIGGERS_CODE_TYPES t where language = 'P' and tclevel = 'F')
                      and upper(triggerid) not like '%REF(%'                       
                      and plsqlspec is not null
                    order by triggerid) loop
        addcnl(rpro.plsqlspec);
      end loop;
    
      plsqlSQLTEXT(rf.formid, 'S', p_lang);
    
      addcnl('end;');
      generatePLSQL;
      /***************************************************************************************/
      /*** BODY ******************************************************************************/
      /***************************************************************************************/
      addcnl('create or replace package body ' || v_user || '.' || rf.form ||
             ' is');

      addcnl('/*');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | RASD - Rapid Application Service Development                         |');
      addcnl('//   Program: ' || rf.form || ' generated on '||to_char(sysdate)||' by user '||user||'.    ');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | http://rasd.sourceforge.net                                          |');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('// | This program is generated form RASD version '||c_engversion||'.                       |');
      addcnl('// +----------------------------------------------------------------------+');
      addcnl('*/    ');


      addcnl('  type rtab is table of rowid          index by binary_integer;');
      addcnl('  type ntab is table of number         index by binary_integer;');
      addcnl('  type dtab is table of date           index by binary_integer;');
      addcnl('  type ttab is table of timestamp      index by binary_integer;');
      addcnl('  type ctab is table of varchar2(4000) index by binary_integer;');
      addcnl('  type cctab is table of clob index by binary_integer;');
      addcnl('  type itab is table of pls_integer    index by binary_integer;');

      addcnl('  type set_type is record');
      addcnl('  (');
      addcnl('    visible boolean default true,');
      addcnl('    readonly boolean default false,');
      addcnl('    disabled boolean default false');
      addcnl('  );');
      addcnl('  type stab is table of set_type index by binary_integer;');

      addcnl('  log__ clob := '''';');
      addcnl('  set_session_block__ clob := '''';');

      /***************************************************************************************/
      /*** TYPES *****************************************************************************/
      /***************************************************************************************/

      addcnl('  '||c_restrestype||' varchar2(4000);');

      for rpf in c_FieldsOfForm(rf.formid) loop
        if rpf.defaultval is null then
          addcnl('  ' || rpad(rpf.fieldid, 30, ' ') || rpf.types || ';');
        else
          addc('  ' || rpad(rpf.fieldid, 30, ' ') || rpf.types || ' := ' );
          
          if rpf.type = 'D' then            
            addc('to_date('||rpf.defaultval||')');
          elsif  rpf.type = 'T' then            
            addc('to_timestamp('||rpf.defaultval||')');
          else
            addc(rpf.defaultval);
          end if;                 
          
          addcnl(';');
        end if;
      end loop;
      for rpb in c_fieldsOfBlock(rf.formid) loop
        addcnl('  ' || rpad(rpb.blockid || rpb.fieldid, 30, ' ') ||
               rpb.types || ';');
        if nvl(rpb.INCLUDEVIS, c_false) = c_true then
        addcnl('  ' || rpad(rpb.blockid || rpb.fieldid||'#SET', 30, ' ') ||' stab;');          
        end if;
      end loop;
    
      for rpro in (select plsql
                     from rasd_triggers
                    where formid = rf.formid
                      and blockid is null
                      and upper(triggerid) not in
                       (select tctype from RASD_TRIGGERS_CODE_TYPES t where (language = 'P' and tclevel = 'F' or language = 'J' and tclevel = 'F' or language = 'C' and tclevel = 'F' or language = 'H' and tclevel = 'F'))
                      and upper(triggerid) not like '%REF(%'
                      and plsqlspec is null
                      order by triggerid) loop
        addcnl(rpro.plsql);
      end loop;

      /***************************************************************************************/
      /*** CUSTOM PROCEDURES, FUNCTIONS, TYPES     *******************************************/
      /***************************************************************************************/
 
      for rpro in (select plsql
                     from rasd_triggers
                    where formid = rf.formid
                      and blockid is null
                      and upper(triggerid) not in
                       (select tctype from RASD_TRIGGERS_CODE_TYPES t where language = 'P' and tclevel = 'F' or language = 'J' and tclevel = 'F' or language = 'C' and tclevel = 'F' or language = 'H' and tclevel = 'F')
                      and upper(triggerid) not like '%REF(%'
                      and plsqlspec is not null
                    order by triggerid) loop
        addcnl(rpro.plsql);
       end loop;

      addcnl('     procedure htpClob(v_clob clob) is');
      addcnl('        i number := 0;');
      addcnl('        v clob := v_clob;');       
      addcnl('       begin');
      addcnl('       while length(v) > 0 and i < 100000 loop');
      addcnl('        htp.prn(substr(v,1,10000));');
      addcnl('        i := i + 1;');
      addcnl('        v := substr(v,10001);');
      addcnl('       end loop; ');
      addcnl('       end; ');

      addcnl('     procedure rlog(v_clob clob) is');
      addcnl('       begin');
      addcnl('        log__ := log__ ||v_clob||''<br/>'';');
      addcnl('       end; ');


      addcnl('procedure pLog is begin htpClob(''<div class="debug">''||log__||''</div>''); end;');


      addcnl('     function FORM_UIHEAD return clob is');
      addcnl('       begin');     
      addcnl('        return  ''');
    for r in (select p.plsql, p.plsqlspec
                from rasd_triggers p
               where p.formid = rf.formid
                 and (blockid is null)
                 and  instr(triggerid, 'FORM_UIHEAD' ) > 0                 
                 ) loop
        addcnl(setHTP(replace(r.plsql,'''','''''')));
    end loop; 
      addcnl(''';');
      addcnl('       end; ');


      addcnl('     function form_js return clob is');
      addcnl('       begin');     
      addcnl('        return  ''');
    for r in (select p.plsql, p.plsqlspec
                from rasd_triggers p
               where p.formid = rf.formid
                 and (blockid is null)
--                 and upper(triggerid) in ('FORM_JS','FORM_JS_REF')
                 and  instr(triggerid, 'FORM_JS' ) > 0                 
                 ) loop
        addcnl(setHTP(replace(r.plsql,'''','''''')));
    end loop; 
      addcnl('        '';');
      addcnl('       end; ');

      addcnl('     function form_css return clob is');
      addcnl('       begin');
      addcnl('        return ''');
    for r in (select p.plsql, p.plsqlspec
                from rasd_triggers p
               where p.formid = rf.formid
                 and (blockid is null)
--                 and upper(triggerid) in('FORM_CSS','FORM_CSS_REF')
                 and  instr(triggerid, 'FORM_CSS' ) > 0
                 ) loop
        addcnl(setHTP(replace(r.plsql,'''','''''')));
    end loop; 
      addcnl('        '';');
      addcnl('       end; ');

      addcnl('procedure form_js(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl(') is begin htpClob(form_js); end;');
      addcnl('procedure form_css(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl('  ) is begin htpClob(form_css); end;');

      /***************************************************************************************/
      /*** LOV *****************************************************************************/
      /***************************************************************************************/
    
      plsqlSQLTEXT(rf.formid, 'G', p_lang);      

      /***************************************************************************************/
      /*** Version ***************************************************************************/
      /***************************************************************************************/
        addcnl('  function version return varchar2 is');
        addcnl('  begin');
        addcnl('   return ''v.'||c_engversion||'.'||rf.version||'.'||to_char(sysdate,'yyyymmddhh24miss')||'''; ');
        addcnl('  end;');

      /***************************************************************************************/
      /*****************************    SESSION    ********************************************/
      /***************************************************************************************/

      addcnl('  procedure on_session is');
        addcnl('    i__ pls_integer := 1;');
      addcnl('  begin');

        if c_debug then
              addcnl('rlog(''START <b>on_session</b>'');');
        end if;
      
         addcnl('  if ACTION is not null then ');        

      addcnl('set_session_block__ := set_session_block__ || ''begin '';');
     
      addcnl('set_session_block__ := set_session_block__ || '''|| re.library ||'.sessionStart;'';');
      
      for rp in c_fieldsOfForm(rf.formid) loop  
        
      
        select count(*) into v_sess_yn from rasd_pages p where p.page = 99 and p.formid = rf.formid and p.blockid is null and p.fieldid = rp.fieldid;
      
      
        if nvl(rp.element,'INPUT_TEXT') not in ('FONT_' , 'A_' , 'IMG_' ,'PLSQL_', 'INPUT_BUTTON', 'INPUT_SUBMIT', 'INPUT_RESET')
           and rp.fieldid <> c_page 
           and rp.fieldid <> c_message 
           and rp.fieldid <> c_action 
           and rp.fieldid <> c_restrestype 
           and rp.fieldid <> c_fin 
           and rp.fieldid <> c_fin 
           and instr(rp.fieldid, c_recnum) = 0
           and rp.elementyn = c_true
           and v_sess_yn = 1
        then  
        if trueField(rf.formid , 'GBUTTONCLR') then  
         addcnl('  if ACTION = GBUTTONCLR then '); 

         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', '''''''' ); '';');

         addcnl('  else ');        
        else
         addcnl('  if 1 = 1 then ');            
        end if; 
        
        if rp.type = 'N' then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||'),'''''''','''''''''''')||''''''); '';');
        elsif rp.type = 'D' then
          if rp.format is null then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||','|| re.library || '.c_date_format),'''''''','''''''''''')||''''''); '';');
          else
          addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''',''''''||replace(to_char('||rp.fieldi||', '||rp.format ||'),'''''''','''''''''''')||'''''' ); '';');
         end if;
        elsif rp.type = 'T' then
          if rp.format is null then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||','|| re.library || '.c_timestamp_format),'''''''','''''''''''')||''''''); '';');
          else
          addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''',''''''||replace(to_char('||rp.fieldi||', '||rp.format ||'),'''''''','''''''''''')||'''''' ); '';');
         end if;
        elsif rp.type = 'R' then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(rowidtochar('||rp.fieldi||'),'''''''','''''''''''')||'''''' ); '';');
        else
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace('||rp.fieldi||','''''''','''''''''''')||'''''' ); '';');
        end if; 
        
         addcnl(' end if; ');        
                 
        end if;  
      end loop;
     
     
      for rb in c_blocks(rf.formid) loop  
        

      select count(*) into v_sess_yn from rasd_pages p where p.page = 99 and p.formid = rf.formid and p.blockid = rb.blockid;
      
      if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' and nvl(rb.dbblockyn,'N') = 'N' 
         and v_sess_yn = 1 
      then  
            
      
      if trueField(rf.formid, c_page) then  
        addcnl('   if ' || truePageSet(rf.formid, rb.blockid) || ' then null; ');
      end if;
      for rp in c_fieldsOfBlock(rf.formid,rb.blockid) loop     
        if nvl(rp.element,'INPUT_TEXT') not in ('FONT_' , 'A_' , 'IMG_' ,'PLSQL_', 'INPUT_BUTTON', 'INPUT_SUBMIT', 'INPUT_RESET') 
           and rp.fieldid <> c_rs 
           and rp.fieldid <> c_rid   
           and rp.elementyn = c_true   
        then    

          
        if trueField(rf.formid , 'GBUTTONCLR') then  
         addcnl('  if ACTION = GBUTTONCLR then '); 

         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', '''''''' ); '';');

         addcnl('  else ');        
        else
         addcnl('  if 1 = 1 then ');            
        end if;        
      
            
        if rp.type = 'N' then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||'),'''''''','''''''''''')||''''''); '';');
        elsif rp.type = 'D' then
          if rp.format is null then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||','|| re.library || '.c_date_format),'''''''','''''''''''')||''''''); '';');
          else
          addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''',''''''||replace(to_char('||rp.fieldi||', '||rp.format ||'),'''''''','''''''''''')||''''''); '';');
         end if;
        elsif rp.type = 'T' then
          if rp.format is null then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(to_char('||rp.fieldi||','|| re.library || '.c_timestamp_format),'''''''','''''''''''')||''''''); '';');
          else
          addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''',''''''||replace(to_char('||rp.fieldi||', '||rp.format ||'),'''''''','''''''''''')||''''''); '';');
         end if;
        elsif rp.type = 'R' then
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace(rowidtochar('||rp.fieldi||'),'''''''','''''''''''')||''''''); '';');
        else
         addcnl('    if length( '||rp.fieldi||') < '||c_session_max_val_long||' then ');
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', ''''''||replace('||rp.fieldi||','''''''','''''''''''')||'''''' ); '';');
        addcnl('     else');
         addcnl('set_session_block__ := set_session_block__ || '''||re.library ||'.sessionSetValue('''''||rp.nameid||''''', '''''''' ); '';');
        addcnl('     end if;');
        end if;
        
         addcnl(' end if; ');        
                  
        end if;  
      end loop;
      if trueField(rf.formid, c_page) then       
        addcnl('    end if;');
      end if;  
      end if;
      end loop;
      
      addcnl('set_session_block__ := set_session_block__ || '' '|| re.library ||'.sessionClose;'';');
      addcnl('set_session_block__ := set_session_block__ || ''exception when others then null; end;'';');

    
      addcnl('  else ');

      addcnl(' '|| re.library ||'.sessionStart;');      
      addcnl('declare vc varchar2(2000); begin');
      addcnl('null;');
      
      for rp in c_fieldsOfForm(rf.formid) loop  
        if rp.element not in ('A_' , 'IMG_' ,'PLSQL_', 'INPUT_BUTTON', 'INPUT_SUBMIT', 'INPUT_RESET') 
           and rp.fieldid <> c_page 
           and rp.fieldid <> c_message 
           and rp.fieldid <> c_action 
           and rp.fieldid <> c_restrestype 
           and rp.fieldid <> c_fin 
           and rp.fieldid <> c_fin 
           and instr(rp.fieldid, c_recnum) = 0
           and rp.elementyn = c_true
        then     
        if rp.type = 'N' then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := '|| re.library || '.varchr2number(vc);  end if; ');
        elsif rp.type = 'D' then
          if rp.format is null then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_date(vc,'|| re.library ||'.c_date_format);  end if; ');
          else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_date(vc,' || rp.format || ');  end if; ');
         end if;
        elsif rp.type = 'T' then
          if rp.format is null then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_timestamp(vc,'|| re.library ||'.c_timestamp_format);  end if; ');
          else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_timestamp(vc,' || rp.format || ');  end if; ');
         end if;
        elsif rp.type = 'R' then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := chartorowid(vc);  end if; ');
        else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := vc;  end if; ');
        end if;          
        end if; 
      end loop;
            
      for rb in c_blocks(rf.formid) loop  
      if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' and nvl(rb.dbblockyn,'N') = 'N' then  
      for rp in c_fieldsOfBlock(rf.formid,rb.blockid) loop 
        if rp.element not in ( 'A_' , 'IMG_' ,'PLSQL_', 'INPUT_BUTTON', 'INPUT_SUBMIT', 'INPUT_RESET') 
           and rp.fieldid <> c_rs 
           and rp.fieldid <> c_rid
           and rp.elementyn = c_true              
        then     
        if rp.type = 'N' then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := '|| re.library || '.varchr2number(vc);  end if; ');
        elsif rp.type = 'D' then
          if rp.format is null then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_date(vc,'|| re.library ||'.c_date_format);  end if; ');
          else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_date(vc,' || rp.format || ');  end if; ');
         end if;
        elsif rp.type = 'T' then
          if rp.format is null then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_timestamp(vc,'|| re.library ||'.c_timestamp_format);  end if; ');
          else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := to_timestamp(vc,' || rp.format || ');  end if; ');
         end if;
        elsif rp.type = 'R' then
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := chartorowid(vc);  end if; ');
        else
         addcnl('if '||rp.fieldi||' is null then vc := '||re.library ||'.sessionGetValue('''||rp.nameid||'''); '||rp.fieldi||'  := vc;  end if; ');
        end if;          
          
        end if; 
      end loop;
      end if;
      end loop;
      addcnl('exception when others then  null; end;    '|| re.library ||'.sessionClose;  end if;');
        if c_debug then
              addcnl('rlog(''END on_session<br/>'');');
        end if;
      
      addcnl('  end;');


      /***************************************************************************************/
      /*****************************    SUBMIT    ********************************************/
      /***************************************************************************************/
      addcnl('  procedure on_submit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is');
      addcnl('    num_entries number := name_array.count;');
      addcnl('    v_max  pls_integer := 0;');
      addcnl('  begin');
      addcnl('-- submit fields');
      if c_debug then
          addcnl('rlog(''<b>on_submit</b> fields<br/>'');');
      end if;
      addcnl('    for i__ in 1..nvl(num_entries,0) loop');

      --  if c_debug then
      --      addcnl('rlog(''''||name_array(i__)||'';'');');
      --  end if;
      
      
      addcnl('      if 1 = 2 then null;');
      addcnl('      elsif  upper(name_array(i__)) = '''||c_restrestype||''' then '||c_restrestype||' := value_array(i__);');
      for rpf in c_fieldsOfForm(rf.formid) loop
        addcnl('      elsif  upper(name_array(i__)) = upper(''' ||
               rpf.nameid || ''') then ' || rpf.fieldi || ' := ');
        if rpf.type = 'N' then
          addc(re.library || '.varchr2number(value_array(i__));');
        elsif rpf.type = 'D' then
          if rpf.format is null then
            addc('to_date(value_array(i__), ' || re.library ||
                 '.c_date_format);');
          else
            addc('to_date(value_array(i__), ' || rpf.format || ');');
          end if;
        elsif rpf.type = 'T' then
          if rpf.format is null then
            addc('to_timestamp(value_array(i__), ' || re.library ||
                 '.c_timestamp_format);');
          else
            addc('to_timestamp(value_array(i__), ' || rpf.format || ');');
          end if;
        elsif rpf.type = 'R' then
          addc('chartorowid(value_array(i__));');
        else
          addc('value_array(i__);');
        end if;
        
        if c_debug then
            addc('rlog('''|| rpf.fieldi||'=''||'||rpf.fieldi||'||'';'');');
        end if;

      end loop;
      for rpb in c_fieldsOfBlock(rf.formid) loop
        addcnl('      elsif  upper(name_array(i__)) = upper(''' ||
               rpb.nameid ||
               '_''||substr(name_array(i__),instr(name_array(i__),''_'',-1)+1)) then');
        addcnl('        ' || rpb.blockid || rpb.fieldid ||
               '(to_number(substr(name_array(i__),instr(name_array(i__),''_'',-1)+1))) := ');
        if rpb.type = 'N' then
          addc(re.library || '.varchr2number(value_array(i__));');
        elsif rpb.type = 'D' then
          if rpb.format is null then
            addc('to_date(value_array(i__), ' || re.library ||
                 '.c_date_format);');
          else
            addc('to_date(value_array(i__), ' || rpb.format || ');');
          end if;
        elsif rpb.type = 'T' then
          if rpb.format is null then
            addc('to_timestamp(value_array(i__), ' || re.library ||
                 '.c_timestamp_format);');
          else
            addc('to_timestamp(value_array(i__), ' || rpb.format || ');');
          end if;
        elsif rpb.type = 'R' then
          addc('chartorowid(value_array(i__));');
        else
          addc('value_array(i__);');
        end if;
        
        if c_debug then
            addc('rlog('''|| rpb.blockid || rpb.fieldid ||'(''||to_number(substr(name_array(i__),instr(name_array(i__),''_'',-1)+1))||'')=''||'||rpb.blockid || rpb.fieldid||'(to_number(substr(name_array(i__),instr(name_array(i__),''_'',-1)+1)))||'';'');');
        end if;

      end loop;

      for rpb in c_fieldsOfBlock(rf.formid) loop
        addcnl('      elsif  upper(name_array(i__)) = upper(''' || rpb.nameid ||''') and ' || rpb.blockid || rpb.fieldid ||'.count = 0 and value_array(i__) is not null then');
        addcnl('        ' || rpb.blockid || rpb.fieldid ||
               '(1) := ');
        if rpb.type = 'N' then
          addc(re.library || '.varchr2number(value_array(i__));');
        elsif rpb.type = 'D' then
          if rpb.format is null then
            addc('to_date(value_array(i__), ' || re.library ||
                 '.c_date_format);');
          else
            addc('to_date(value_array(i__), ' || rpb.format || ');');
          end if;
        elsif rpb.type = 'T' then
          if rpb.format is null then
            addc('to_timestamp(value_array(i__), ' || re.library ||
                 '.c_timestamp_format);');
          else
            addc('to_timestamp(value_array(i__), ' || rpb.format || ');');
          end if;
        elsif rpb.type = 'R' then
          addc('chartorowid(value_array(i__));');
        else
          addc('value_array(i__);');
        end if;
        
        if c_debug then
            addc('rlog('''|| rpb.blockid || rpb.fieldid ||'(1)=''||'||rpb.blockid || rpb.fieldid||'(1)||'';'');');
        end if;

      end loop;
    
      addcnl('      end if;');
      addcnl('    end loop;');
      --INPUT_CHECKBOX init, whitch are not checked for fields on form
      for rpf in c_fieldsOfForm(rf.formid) loop
        if rpf.element in ('INPUT_CHECKBOX') --, 'SELECT_', 'FONT_RADIO') and
         then
          begin
            select count(*)
              into n
              from rasd_links
             where formid = rf.formid
               and linkid = rpf.linkid
               and type = 'C';
            if n > 0 and rpf.linkid is not null then
              begin
                select nvl(gpp.code, substr(value, 1, 100))
                  into v_truefalse
                  from rasd_link_params gpp
                 where gpp.linkid = rpf.linkid
                   and gpp.formid = rf.formid
                   and gpp.type = 'FALSE';
              exception
                when others then
                  if rpf.type = 'N' then
                    v_truefalse := 0;
                    --              elsif rpf.type = 'D' then
                    --                v_truefalse := c_false;
                    --              elsif rpf.type = 'R' then
                    --                v_truefalse := c_false;
                  else
                    v_truefalse := c_false;
                  end if;
                  --              v_truefalse := c_false;
              end;
              addcnl('      if ' || rpf.fieldi || ' is null then');
              if rpf.type = 'N' then
                addcnl('        ' || rpf.fieldi || ' := ' || re.library ||
                       '.varchr2number(' || v_truefalse || ');');
              elsif rpf.type = 'D' then
                if rpf.format is null then
                  addcnl('        ' || rpf.fieldi || ' := to_date(''' ||
                         v_truefalse || ''', ' || re.library ||
                         '.c_date_format);');
                else
                  addcnl('        ' || rpf.fieldi || ' := to_date(''' ||
                         v_truefalse || ''', ' || rpf.format || ');');
                end if;
              elsif rpf.type = 'T' then
                if rpf.format is null then
                  addcnl('        ' || rpf.fieldi || ' := to_timestamp(''' ||
                         v_truefalse || ''', ' || re.library ||
                         '.c_timestamp_format);');
                else
                  addcnl('        ' || rpf.fieldi || ' := to_timestamp(''' ||
                         v_truefalse || ''', ' || rpf.format || ');');
                end if;
              elsif rpf.type = 'R' then
                addcnl('        ' || rpf.fieldi || ' := chartorowid(''' ||
                       v_truefalse || ''');');
              else
                addcnl('        ' || rpf.fieldi || ' := ''' || v_truefalse ||
                       ''';');
              end if;
              addcnl('      end if;');
            else
              --           v_truefalse := c_false;
              if rpf.type = 'N' then
                v_truefalse := 0;
                --              elsif rpf.type = 'D' then
                --                v_truefalse := c_false;
                --              elsif rpf.type = 'R' then
                --                v_truefalse := c_false;
              else
                v_truefalse := c_false;
              end if;
              addcnl('      if  ' || rpf.fieldi || ' is null then');
              if rpf.type = 'N' then
                addcnl('        ' || rpf.fieldi || ' := ' || re.library ||
                       '.varchr2number(' || v_truefalse || ');');
              elsif rpf.type = 'D' then
                if rpf.format is null then
                  addcnl('        ' || rpf.fieldi || ' := to_date(''' ||
                         v_truefalse || ''', ' || re.library ||
                         '.c_date_format);');
                else
                  addcnl('        ' || rpf.fieldi || ' := to_date(''' ||
                         v_truefalse || ''', ' || rpf.format || ');');
                end if;
              elsif rpf.type = 'T' then
                if rpf.format is null then
                  addcnl('        ' || rpf.fieldi || ' := to_timestamp(''' ||
                         v_truefalse || ''', ' || re.library ||
                         '.c_timestamp_format);');
                else
                  addcnl('        ' || rpf.fieldi || ' := to_timestamp(''' ||
                         v_truefalse || ''', ' || rpf.format || ');');
                end if;
              elsif rpf.type = 'R' then
                addcnl('        ' || rpf.fieldi || ' := chartorowid(''' ||
                       v_truefalse || ''');');
              else
                addcnl('        ' || rpf.fieldi || ' := ''' || v_truefalse ||
                       ''';');
              end if;
              addcnl('      end if;');
            end if;
          end;          
        end if;
      end loop;
    
      -- organize shuffled fields of records
      addcnl('-- organize records');
      if c_debug then
          addcnl('rlog(''<br/><b>on_submit</b> organize records<br/>'');');
      end if;
      for rb in c_blocks(rf.formid) loop
      if nvl(rb.dbblockyn, c_false) = c_true then  
        
        if c_debug then
            addc('rlog(''START organize '|| rb.blockid ||' '');');
        end if;

         addcnl('declare'); 
         addcnl('v_last number := '); 
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;
         addcnl('.last;');
         addcnl('v_curr number := '); 
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;
         addcnl('.first;');
         addcnl('i__ number;'); 
         addcnl('begin'); 
         addcnl(' if v_last <> ');
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;
         addcnl('.count then ');
        if c_debug then
            addc('rlog(''organized block '|| rb.blockid ||' '');');
        end if;
         addcnl('   v_curr := ');
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;         
         addcnl('.FIRST;  '); 
         addcnl('   i__ := 1;'); 
         addcnl('   WHILE v_curr IS NOT NULL LOOP'); 
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
         addcnl('      if '||rp.blockid||rp.fieldid||'.exists(v_curr) then '||rp.blockid||rp.fieldid||'(i__) := '||rp.blockid||rp.fieldid||'(v_curr); end if;'); 
            end loop;
         addcnl('      i__ := i__ + 1;'); 
         addcnl('      v_curr := ');
                    declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;
         addcnl('.NEXT(v_curr);  '); 
         addcnl('   END LOOP;'); 
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
         addcnl('      '||rp.blockid||rp.fieldid||'.DELETE(i__ , v_last);'); 
            end loop;
         addcnl('end if;'); 
         addcnl('end;'); 
        if c_debug then
            addc('rlog(''END organize </br>'');');
        end if;         
      end if;
      end loop;

      -- init of all fields 
      addcnl('-- init fields');
      if c_debug then
          addcnl('rlog(''<br/><b>on_submit</b> init fields<br/>'');');
      end if;
      for rb in (select blockid, numrows  from rasd_blocks where formid = rf.formid) loop

        if c_debug then
            addc('rlog(''START init '|| rb.blockid ||' '');');
        end if;
     
        addcnl('    v_max := 0;');
        for xr in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          addcnl('    if ' || xr.blockid || xr.fieldid ||
                 '.count > v_max then v_max := ' || xr.blockid ||
                 xr.fieldid || '.count; end if;');
        end loop;
        addcnl('    if v_max = 0 then v_max := '||rb.numrows||'; end if;');      --added check fields standalone no dbcode
        addcnl('    for i__ in 1..v_max loop');
        for rpb in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if rpb.element in ('INPUT_CHECKBOX') --, 'SELECT_', 'FONT_RADIO') and
           then
            begin
              select count(*)
                into n
                from rasd_links
               where formid = rf.formid
                 and linkid = rpb.linkid
                 and type = 'C';
              if n > 0 and rpb.linkid is not null then
                begin
                  select nvl(gpp.code, substr(value, 1, 100))
                    into v_truefalse
                    from rasd_link_params gpp
                   where gpp.linkid = rpb.linkid
                     and gpp.formid = rf.formid
                     and gpp.type = 'FALSE';
                exception
                  when others then
                    --           v_truefalse := c_false;
                    if rpb.type = 'N' then
                      v_truefalse := 0;
                      --              elsif rpf.type = 'D' then
                      --                v_truefalse := c_false;
                      --              elsif rpf.type = 'R' then
                      --                v_truefalse := c_false;
                    else
                      v_truefalse := c_false;
                    end if;
                end;
                addcnl('      if not ' || rpb.blockid || rpb.fieldid ||
                       '.exists(i__) or ' || rpb.fieldi || ' is null then');
                if rpb.type = 'N' then
                  addcnl('        ' || rpb.fieldi || ' := ' || re.library ||
                         '.varchr2number(' || v_truefalse || ');');
                elsif rpb.type = 'D' then
                  if rpb.format is null then
                    addcnl('        ' || rpb.fieldi || ' := to_date(''' ||
                           v_truefalse || ''', ' || re.library ||
                           '.c_date_format);');
                  else
                    addcnl('        ' || rpb.fieldi || ' := to_date(''' ||
                           v_truefalse || ''', ' || rpb.format || ');');
                  end if;
                elsif rpb.type = 'T' then
                  if rpb.format is null then
                    addcnl('        ' || rpb.fieldi || ' := to_timestamp(''' ||
                           v_truefalse || ''', ' || re.library ||
                           '.c_timestamp_format);');
                  else
                    addcnl('        ' || rpb.fieldi || ' := to_timestamp(''' ||
                           v_truefalse || ''', ' || rpb.format || ');');
                  end if;
                elsif rpb.type = 'R' then
                  addcnl('        ' || rpb.fieldi || ' := chartorowid(''' ||
                         v_truefalse || ''');');
                else
                  addcnl('        ' || rpb.fieldi || ' := ''' ||
                         v_truefalse || ''';');
                end if;
                addcnl('      end if;');
              else
                --           v_truefalse := c_false;
                if rpb.type = 'N' then
                  v_truefalse := 0;
                  --              elsif rpf.type = 'D' then
                  --                v_truefalse := c_false;
                  --              elsif rpf.type = 'R' then
                  --                v_truefalse := c_false;
                else
                  v_truefalse := c_false;
                end if;
                addcnl('      if not ' || rpb.blockid || rpb.fieldid ||
                       '.exists(i__) or ' || rpb.fieldi || ' is null then');
                if rpb.type = 'N' then
                  addcnl('        ' || rpb.fieldi || ' := ' || re.library ||
                         '.varchr2number(' || v_truefalse || ');');
                elsif rpb.type = 'D' then
                  if rpb.format is null then
                    addcnl('        ' || rpb.fieldi || ' := to_date(''' ||
                           v_truefalse || ''', ' || re.library ||
                           '.c_date_format);');
                  else
                    addcnl('        ' || rpb.fieldi || ' := to_date(''' ||
                           v_truefalse || ''', ' || rpb.format || ');');
                  end if;
                elsif rpb.type = 'T' then
                  if rpb.format is null then
                    addcnl('        ' || rpb.fieldi || ' := to_timestamp(''' ||
                           v_truefalse || ''', ' || re.library ||
                           '.c_timestamp_format);');
                  else
                    addcnl('        ' || rpb.fieldi || ' := to_timestamp(''' ||
                           v_truefalse || ''', ' || rpb.format || ');');
                  end if;
                elsif rpb.type = 'R' then
                  addcnl('        ' || rpb.fieldi || ' := chartorowid(''' ||
                         v_truefalse || ''');');
                else
                  addcnl('        ' || rpb.fieldi || ' := ''' ||
                         v_truefalse || ''';');
                end if;
                addcnl('      end if;');
              end if;
            end;
          else
            -- others
            addcnl('      if not ' || rpb.blockid || rpb.fieldid ||
                   '.exists(i__) then');
            if rpb.type = 'N' then
              if rpb.defaultval is null then
              addcnl('        ' || rpb.fieldi || ' := to_number(null);');
              else
              addcnl('        ' || rpb.fieldi || ' := '||rpb.defaultval||';');                
              end if;
            elsif rpb.type = 'D' then
              if rpb.defaultval is null then
              addcnl('        ' || rpb.fieldi || ' := to_date(null);');
              else
               if rpb.format is null then
              addcnl('        ' || rpb.fieldi || ' := to_date('||rpb.defaultval||',' || re.library ||
                                                                                   '.c_date_format);');                 
               else
              addcnl('        ' || rpb.fieldi || ' := to_date('||rpb.defaultval||',' || rpb.format ||');');                                  
               end if;
              end if;
            elsif rpb.type = 'T' then
              if rpb.defaultval is null then
              addcnl('        ' || rpb.fieldi || ' := to_timestamp(null);');
              else
               if rpb.format is null then
                 
              addcnl('        ' || rpb.fieldi || ' := to_timestamp('||rpb.defaultval||');');                 
               else
              addcnl('        ' || rpb.fieldi || ' := to_timestamp('||rpb.defaultval||',' || rpb.format ||');');                                  
               end if;
              end if;
            elsif rpb.type = 'R' then
                addcnl('        ' || rpb.fieldi || ' := null;');
            else
              if rpb.defaultval is null then
                addcnl('        ' || rpb.fieldi || ' := null;');
              else
                addcnl('        ' || rpb.fieldi || ' := '||rpb.defaultval||';');
              end if;  
            end if;
            addcnl('      end if;');
          end if;
          
          if nvl(rpb.includevis,c_false) = c_true then
            addcnl('      if not ' || rpb.blockid || rpb.fieldid ||'#SET'||
                   '.exists(i__) then');
                addcnl('        ' || rpb.blockid || rpb.fieldid || '#SET(i__).visible := true;');          
            addcnl('      end if;');
          end if;
          
        end loop;
        addcnl('    null; end loop;');

        if c_debug then
            addc('rlog(''END init </br>'');');
        end if;

        
      end loop;
           
      addcnl('  end;');
      addcnl('  procedure post_submit is');
      addcnl('  begin');
      if trueTrigger(rf.formid, 'POST_SUBMIT') then
        createTriggerPLSQL(rf.formid, 'POST_SUBMIT', '' , '-- Executing after filling fields on submit.');
      end if;
      addcnl('    null;');
      addcnl('  end;');
      addcnl('  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is');
      addcnl('  begin');
      if trueTrigger(rf.formid, 'ON_SUBMIT') then
        createTriggerPLSQL(rf.formid, 'ON_SUBMIT' , '' , '-- Reading post variables into fields.'||c_nl||'    on_submit(name_array ,value_array); on_session;');
      else
        addcnl('-- Reading post variables into fields.'||c_nl||'    on_submit(name_array ,value_array); on_session;');
      end if;
      addcnl('    post_submit;');

      if c_debug then
      addcnl(' exception when others then');
      addcnl('    rlog(''CODE: <b>psubmit</b><br/>'');');
      addcnl('    rlog(''ERRORCODE:''||sqlcode||''<br/>'');');
      addcnl('    rlog(''ERRORMESSAGE''||sqlerrm||''<br/>'');');     
      addcnl('    raise;');     
      end if;

      addcnl('  end;');
     
      /***************************************************************************************/
      /*****************************   CLEAR_XX     *************+***************************/
      /***************************************************************************************/
      for rb in c_blocks(rf.formid) loop
        addcnl('  procedure pclear_' || rb.blockid || '(pstart number) is');
        addcnl('    i__ pls_integer;');
        addcnl('    j__ pls_integer;');
        addcnl('    k__ pls_integer;');
        addcnl('  begin');
        if c_debug then
              addcnl('rlog(''START <b>pclear_' || rb.blockid || '</b>'');');
        end if;
        addcnl('      i__ := pstart;');
        addcnl('      if ' || to_char(rb.numrows) ||
               ' = 0 then k__ := i__ + ' || to_char(nvl(rb.emptyrows, 0)) || ';');
        if nvl(rb.dbblockyn, c_false) = c_true then      
        addcnl(' if pstart = 0 then k__ := k__ + ');
--        addcnl(  rb.blockid||c_rid );
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
                  exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  exit;
              end if;
           end loop;        
           end if;
           end;
         addcnl('.count(); end if;'); 
        end if;
        
        addcnl('      else  ');
        addcnl('       if i__ > ' || to_char(rb.numrows) ||
               ' then  k__ := i__ + ' || to_char(nvl(rb.emptyrows, 0)) || ';');
        addcnl('       else k__ := ' || to_char(nvl(rb.emptyrows, 0)) ||
               ' + ' || to_char(rb.numrows) || ';');
        addcnl('       end if;');
        addcnl('      end if;');
        
        addcnl('      j__ := i__;');        
       
        if rb.numrows <> 1 then 
        addcnl('      for i__ in 1..j__ loop');  -- added loop for setting default values of fields 6.2.2018
         for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if nvl(rp.selectyn,c_false) = c_false then 
        addcnl('      begin');
        addcnl('      '|| rb.blockid || rp.fieldid||'(i__) := '|| rb.blockid || rp.fieldid||'(i__);');
        addcnl('      exception when others then');             

          if rp.defaultval is null then
         addcnl('        ' || rb.blockid || rp.fieldid || '(i__) := null;' || c_nl);
          else
         addcnl('        ' || rb.blockid || rp.fieldid || '(i__) := ' || rp.defaultval || ';' || c_nl);
          end if;
        addcnl('      end;');          
          end if;
        end loop;   
        addcnl('      null;');            
        addcnl('      end loop;');
        end if;
        addcnl('      for i__ in j__+1..k__ loop');
        tt := '-- Generated initialization of the fields in new record. Use (i__) to access fields values.'||c_nl;
        for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if rp.defaultval is null then
            tt := tt || '        ' || rb.blockid || rp.fieldid ||
                  '(i__) := null;' || c_nl;
          else
            tt := tt || '        ' || rb.blockid || rp.fieldid ||
                  '(i__) := ' || rp.defaultval || ';' || c_nl;
          end if;
          
          
        end loop;
        if nvl(rb.dbblockyn, c_false) = c_true then
          if trueInsert(rf.formid, rb.blockid) then
            tt := tt || '        ' || rb.blockid || c_rs ||
                  '(i__) := ''I'';' || c_nl;
          end if;
        end if;
        if trueTrigger(rf.formid, 'on_new_record', rb.blockid) then
          createTriggerPLSQL(rf.formid, 'on_new_record', rb.blockid, tt);
        else
          addcnl(tt);
        end if;
        addcnl('      end loop;');
        if c_debug then
              addcnl('rlog(''END pclear<br/>'');');
        end if;
        addcnl('  end;');
      end loop;
      addcnl('  procedure pclear_form is');
      addcnl('  begin');
      if c_debug then
              addcnl('rlog(''START <b>pclear_form</b>'');');
      end if;
      for rp in c_fieldsOfForm(rf.formid) loop
        if rp.fieldid <> c_action then
          if rp.defaultval is null then
           addcnl('    ' || rp.fieldid || ' := null;');
          else
           addcnl('    ' || rp.fieldid || ' := ' || rp.defaultval || ';');
          end if;
        end if; 
      end loop;
        if c_debug then
              addcnl('rlog(''END pclear_form<br/>'');');
        end if;
      addcnl('  null; end;');
      /***************************************************************************************/
      /*****************************   CLEAR     *************+***************************/
      /***************************************************************************************/
      addcnl('  procedure pclear is');
      addcnl('  begin');
      tt := '-- Clears all fields on form and blocks.'||c_nl;
      tt := tt || '    pclear_form;'||c_nl; 

      for rb in c_blocks(rf.formid) loop
        tt := tt || '    pclear_' || rb.blockid || '(0);'||c_nl; 
--        if trueTrigger(rf.formid, 'on_clear', rb.blockid) then
--          createTriggerPLSQL(rf.formid,
--                             'on_clear',
--                             rb.blockid,
--                             '    pclear_' || rb.blockid || '(0);');
--        else
--          addcnl('    pclear_' || rb.blockid || '(0);');
--        end if;
      end loop;

      if trueTrigger(rf.formid, 'on_clear') then
        createTriggerPLSQL(rf.formid, 'on_clear', '', tt);
      else 
        addcnl(tt);         
      end if;

      
      addcnl('  null;');
      
            if c_debug then
      addcnl(' exception when others then');
      addcnl('    rlog(''CODE: pclear</BR>'');');
      addcnl('    rlog(''ERRORCODE:''||sqlcode||''</BR>'');');
      addcnl('    rlog(''ERRORMESSAGE''||sqlerrm||''</BR>'');');     
      addcnl('    raise;');     
      end if;
      
      addcnl('  end;');
      /***************************************************************************************/
      /*****************************   SELECT_XX   *************+***************************/
      /***************************************************************************************/
    
      for rb in c_blocks(rf.formid) loop
        -- fills numrowse
        addcnl('  procedure pselect_' || rb.blockid || ' is');
        addcnl('    i__ pls_integer;');
        if c_debug then
              addcnl('dtime__ timestamp;');
        end if;
        addcnl('  begin');
        if c_debug then
              addcnl('rlog(''<br/>START <b>pselect_' || rb.blockid || '</b><br/>'');');
              addcnl('dtime__ := systimestamp;');
        end if;
        if nvl(rb.dbblockyn, 'N') = c_true then
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if rp.selectyn = c_true then -- condition added 6.2.2018 
            addcnl('      ' || rb.blockid || rp.fieldid || '.delete;');
            end if;
          end loop;
          createTriggerPLSQL(rf.formid, 'pre_select', rb.blockid, '-- Triggers before executing SQL.');
          addcnl('      declare ');
          addcnl('        TYPE ctype__ is REF CURSOR;');
          addcnl('        c__ ctype__;');
          addcnl('      begin');
          tt := '-- Generated SELECT code. Use (i__) to access fields values.'||c_nl;
          tt := tt || 'OPEN c__ FOR '||c_nl;
          tt := tt || getSQLText(rf.formid, rb.blockid) || ';';
          if trueTrigger(rf.formid, 'on_select', rb.blockid) then
            createTriggerPLSQL(rf.formid,
                               'on_select',
                               rb.blockid,
                              tt);
          else
            addcnl(tt);
          end if;
          addcnl('        i__ := 1;');
          addcnl('        LOOP ');
          
          addcnl('          FETCH c__ INTO');
          
          v_firstrow := true;
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if rp.selectyn = c_true then
              if v_firstrow then
                addcnl('            ' || rp.fieldi);
              else
                addcnl('           ,' || rp.fieldi);
              end if;
              v_firstrow := false;
            end if;
          end loop;
          
          addcnl('          ;');
          
          addcnl('          exit when c__%notfound;');
          addcnl('           if c__%rowcount >= ');
          if nvl(rb.pagingyn, 'N') = c_true then
            addc(' nvl(' || c_recnum || rb.blockid || ',1)');
          else
            addc(' 1');
          end if;
          addc(' then');
          --no db fields
          /* comment on 6.2.2018 - because the values did not pass afther submit 
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if rp.selectyn <> c_true then
              addcnl('            ' || rp.fieldi || ' := null;');
            end if;
          end loop;
          */
          
          --record status
          if trueUpdate(rf.formid, rb.blockid) then
            addcnl('            ' || rb.blockid || c_rs ||
                   '(i__) := ''U'';');
          end if;
          --locking
          tt := '-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.'||c_nl;
          if trueLock(rf.formid, rb.blockid) then
            for rp1 in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              if rp1.lockyn = c_true then
                tt := tt || '            ' || rb.blockid || c_rs ||
                      '(i__) := ' || rb.blockid || c_rs ||
                      '(i__) ||'',''||';
                if rp1.type = 'N' then
                  tt := tt || 'to_char(' || rp1.fieldi || ')';
                elsif rp1.type = 'D' then
                  tt := tt || 'to_char(' || rp1.fieldi || ', ' ||
                        re.library || '.c_date_format)';
                elsif rp1.type = 'T' then
                  tt := tt || 'to_timestamp(' || rp1.fieldi || ', ' ||
                        re.library || '.c_timestamp_format)';
                elsif rp1.type = 'R' then
                  tt := tt || 'rowidtochar(' || rp1.fieldi || ')';
                else
                  tt := tt || rp1.fieldi;
                end if;
                tt := tt || ';' || c_nl;
              end if;
            end loop;
          end if;
        
          if trueTrigger(rf.formid, 'on_lock_value', rb.blockid) then
            createTriggerPLSQL(rf.formid, 'on_lock_value', rb.blockid, tt);
          else
            addcnl(tt);
          end if;
          --locking end
          createTriggerPLSQL(rf.formid, 'post_select', rb.blockid,'-- Triggers after executing SQL. Use (i__) to access fields values.');
          --if nvl(rb.pagingyn, 'N') = c_true then
            addcnl('            exit when i__ =' || rb.numrows || ';');
          --end if;
          addcnl('            i__ := i__ + 1;');
          addcnl('          end if;');
          addcnl('        END LOOP;');
          addcnl('         if c__%rowcount < ');
          if nvl(rb.pagingyn, 'N') = c_true then
            addc(' nvl(' || c_recnum || rb.blockid || ',1)');
          else
            addc(' 1');
          end if;
          addc(' then');
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            addcnl('          ' || rb.blockid || rp.fieldid ||
                   '.delete(1);');
          end loop;
          addcnl('          i__ := 0;');
          addcnl('        end if; ');
          addcnl('        CLOSE c__;');
          addcnl('      end;');
        end if;
        -- ON_NEW_RECORD
        if nvl(rb.dbblockyn, 'N') = c_true then
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if rp.selectyn = c_true then
              addcnl('      pclear_' || rb.blockid || '(' || rb.blockid ||
                     rp.fieldid || '.count);');
              exit;
            end if;
          end loop;
        else
          -- addcnl('    pclear_' || rb.blockid || '(0);'); -- before
          -- new code
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              addcnl('      pclear_' || rb.blockid || '(' || rb.blockid ||
                     rp.fieldid || '.count);');
              exit;
          end loop;
          --
        end if;
        if c_debug then
              addcnl('rlog(''Execution time for ' || rb.blockid || ': ''||to_char(systimestamp - dtime__)||''ms. '');');
              
              addcnl('rlog(''END pselect_' || rb.blockid || ' <br/>'');');
        end if;        
        addcnl('  null; end;');
      end loop;
      -- ON_NEW_RECORD for fields on form
      --addcnl('      pclear_form;');
      /***************************************************************************************/
      /*****************************   SELECT     *************+***************************/
      /***************************************************************************************/
      addcnl('  procedure pselect is');
      addcnl('  begin');
      for rb in c_blocks(rf.formid) loop
        if nvl(rb.dbblockyn, 'N') = c_true then
          addcnl('    if ' || truePageSet(rf.formid, rb.blockid) || ' then ');
          addcnl('      pselect_' || rb.blockid || ';');
          addcnl('    end if;');
        end if;
      end loop;

      addcnl('  null;');
      
            if c_debug then
      addcnl(' exception when others then');
      addcnl('    rlog(''CODE: pselect</BR>'');');
      addcnl('    rlog(''ERRORCODE:''||sqlcode||''</BR>'');');
      addcnl('    rlog(''ERRORMESSAGE''||sqlerrm||''</BR>'');');     
      addcnl('    raise;');     
      end if;      
      addcnl(' end;');
      /***************************************************************************************/
      /*****************************   COMMIT_XX   *************+***************************/
      /***************************************************************************************/
      for rb in c_blocks(rf.formid) loop
        addcnl('  procedure pcommit_' || rb.blockid || ' is');
        addcnl('  begin');
        if c_debug then
              addcnl('rlog(''START <b>pcommit_' || rb.blockid || '</b><br/>'');');
        end if;
        v_i_record := '';
        for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if rp.elementyn = c_true then
            addcnl('    for i__ in 1..' || rb.blockid || rp.fieldid ||
                   '.count loop');
            v_i_record := 'i__';
            exit;
          end if;
        end loop;
        createTriggerPLSQL(rf.formid, 'on_validate', rb.blockid ,'-- Validating field values before DML. Use ('||v_i_record||') to access fields values.');
        if rb.dbblockyn = c_true then
          v_dummy := null;
          v_where := null;
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if upper(rp.fieldid) = upper(c_rs) then
              v_dummy := 'substr(' || rp.fieldi || ',1,1) = ''I''';
            end if;
            if rp.pkyn = c_true then
              --create where syntax
              if rb.rowidyn = c_true then
                v_where := v_where || ' and ROWID = ' || rp.fieldi;
              else
                v_where := v_where || ' and ' || rp.fieldid || ' = ' ||
                           rp.fieldi;
              end if;
            end if;
          end loop;
          if v_where is null then
            v_where := '1=2';
          else
            v_where := substr(v_where, 6);
          end if;
          v_insertdummy := v_dummy;
          addcnl('      if ' || nvl(v_insertdummy, '1=2') || ' then --INSERT');
          tt := '';
          if trueInsertNN(rf.formid, rb.blockid) then
            v_dummy := null;
            for rp in c_fieldsOfBlock(RF.formid, rb.blockid) loop
              if rp.insertnnyn = c_true then
                v_dummy := v_dummy || ' or ' || rp.fieldi || ' is not null' || c_nl;
              end if;
            end loop;
            addcnl('        if ' || substr(v_dummy, 5) || ' then ');
            createTriggerPLSQL(rf.formid, 'pre_insert', rb.blockid, '-- Triggers before INSERT. Use (i__) to access fields values.');
            
            tt := '-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.'||c_nl;
            if trueNotNull(rf.formid, rb.blockid) then
              v_dummy := null;
              for rp in c_fieldsOfBlock(RF.formid, rb.blockid) loop
                if rp.notnullyn = c_true then
                  v_dummy := v_dummy || ' or ' || rp.fieldi || ' is null' || c_nl;
                end if;
              end loop;
              if v_dummy is not null then
                tt := tt ||' if ' || substr(v_dummy, 5) || ' then '|| c_nl;
                tt := tt ||'   raise_application_error(''-20001'',''' ||
                       RASDI_TRNSLT.text('Mandatory data is missing!', p_lang) ||
                       ''');'|| c_nl;
                tt := tt ||' end if;';
              end if;
            end if;
            if trueTrigger(rf.formid, 'on_mandatory', rb.blockid) then
               createTriggerPLSQL(rf.formid, 'on_mandatory', rb.blockid, tt);
            else  
               addcnl(tt);
            end if;

            tt         := '-- Generated INSERT statement. Use (i__) to access fields values.'||c_nl;
            tt         := tt || 'if ' || nvl(v_insertdummy, '1=2') || ' then' || c_nl;
            tt         := tt || 'insert into ' || rb.sqltable || ' (' || c_nl;
            v_firstrow := true;
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              if rp.insertyn = c_true then
                if v_firstrow then
                  tt := tt || '  ' || rp.fieldid || c_nl;
                else
                  tt := tt || ' ,' || rp.fieldid || c_nl;
                end if;
                v_firstrow := false;
              end if;
            end loop;
            tt         := tt || ') values (' || c_nl;
            v_firstrow := true;
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              if rp.insertyn = c_true then
                if v_firstrow then
                  tt := tt || '  ' || rp.fieldi || c_nl;
                else
                  tt := tt || ' ,' || rp.fieldi || c_nl;
                end if;
                v_firstrow := false;
              end if;
            end loop;
            tt := tt || ');'|| c_nl;
            tt := tt || ' '||c_message||' := '''|| RASDI_TRNSLT.text('Data is changed.', p_lang) ||''';' || c_nl;
            tt := tt || 'end if;';

            if trueTrigger(rf.formid, 'on_insert', rb.blockid) then
              createTriggerPLSQL(rf.formid, 'on_insert', rb.blockid, tt);
            else
              if trueInsert(rf.formid, rb.blockid) then
                addcnl(tt);
              end if;
            end if;
            createTriggerPLSQL(RF.formid, 'post_insert', rb.blockid, '-- Triggers after INSERT. Use (i__) to access fields values.');
            addcnl('        null; end if;');
          end if;
          addcnl('      null; else -- UPDATE or DELETE;');
          --locking
          tt := '-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.'||c_nl;
          if trueLock(rf.formid, rb.blockid) and
             (trueDelete(rf.formid, rb.blockid) or
              trueUpdate(rf.formid, rb.blockid)) then
          tt := tt||' declare'||c_nl;
          tt := tt||'   v_locking varchar2(4000);'||c_nl;
          tt := tt||' begin  '||c_nl;
          tt := tt|| '  select ''U''';
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              if rp.lockyn = c_true then
                if rp.type = 'N' then
                  tt := tt || '||'',''||to_char(' || rp.fieldid || ')';
                elsif rp.type = 'D' then
                  tt := tt || '||'',''||to_char(' || rp.fieldid || ', ' ||
                        re.library || '.c_date_format)';
                elsif rp.type = 'T' then
                  tt := tt || '||'',''||to_timestamp(' || rp.fieldid || ', ' ||
                        re.library || '.c_timestamp_format)';
                elsif rp.type = 'R' then
                  tt := tt || '||'',''||rowidtochar(' || rp.fieldid || ')';
                else
                  tt := tt || '||'',''||' || rp.fieldid;
                end if;
              end if;
            end loop;
            tt := tt || ' into v_locking' || c_nl;
            tt := tt || 'from ' || rb.sqltable || c_nl;
            tt := tt || 'where ' || v_where || ' for update;' || c_nl;
            tt := tt || '  if ' || rb.blockid || c_rs ||
                  '(i__) <> v_locking then' || c_nl;
            tt := tt || '    raise_application_error(''-20002'',''' ||
                  RASDI_TRNSLT.text('Data has been changed! Refresh data.', p_lang) || ''');' || c_nl;
            tt := tt || '  end if;'|| c_nl;
            tt := tt || ' end;';
          end if;
          if trueTrigger(rf.formid, 'on_lock', rb.blockid) then
            createTriggerPLSQL(rf.formid, 'on_lock', rb.blockid, tt);
          else
            addcnl(tt);
          end if;
          --end locking
          tt := '';
          if trueDelete(rf.formid, rb.blockid) then
            v_dummy := null;
            for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              if rp.deleteyn = c_true then
                v_dummy := v_dummy || ' and ' || rp.fieldi || ' is null' || c_nl;
              end if;
            end loop;
            addcnl('        if ' || substr(v_dummy, 6) || ' then --DELETE');
            createTriggerPLSQL(rf.formid, 'pre_delete', rb.blockid,'-- Triggers before DELETE. Use (i__) to access fields values.');
            tt := '-- Generated DELETE statement. Use (i__) to access fields values.'||c_nl;
            tt := tt || 'if ' || nvl(replace(v_insertdummy,'''I''','''U'''), '1=2') || ' then' || c_nl;
            tt := tt || 'delete ' || rb.sqltable || c_nl;
            tt := tt || 'where ' || v_where || ';' ||c_nl;
            tt := tt || ' '||c_message||' := '''|| RASDI_TRNSLT.text('Data is changed.', p_lang) ||''';' || c_nl;
            tt := tt || 'end if;';
            if trueTrigger(rf.formid, 'on_delete', rb.blockid) then
              createTriggerPLSQL(rf.formid, 'on_delete', rb.blockid, tt);
            else
              if trueDelete(rf.formid, rb.blockid) then
                addcnl(tt);
              end if; -- Delete exists
            end if;
            createTriggerPLSQL(rf.formid, 'post_delete', rb.blockid, '-- Triggers after DELETE. Use (i__) to access fields values.');
            addcnl('        else --UPDATE');
          end if;
          if trueUpdate(rf.formid, rb.blockid) then
            createTriggerPLSQL(rf.formid, 'pre_update', rb.blockid, '-- Triggers before UPDATE. Use (i__) to access fields values.');
          end if;
          
            tt := '-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.'||c_nl;
            if trueNotNull(rf.formid, rb.blockid) then
              v_dummy := null;
              for rp in c_fieldsOfBlock(RF.formid, rb.blockid) loop
                if rp.notnullyn = c_true then
                  v_dummy := v_dummy || ' or ' || rp.fieldi || ' is null' || c_nl;
                end if;
              end loop;
              if v_dummy is not null then
                tt := tt ||' if ' || substr(v_dummy, 5) || ' then '|| c_nl;
                tt := tt ||'   raise_application_error(''-20001'',''' ||
                       RASDI_TRNSLT.text('Mandatory data is missing!', p_lang) ||
                       ''');'|| c_nl;
                tt := tt ||' end if;';
              end if;
            end if;
            if trueTrigger(rf.formid, 'on_mandatory', rb.blockid) then
               createTriggerPLSQL(rf.formid, 'on_mandatory', rb.blockid, tt);
            else  
               addcnl(tt);
            end if;          
          
          tt         := '-- Generated UPDATE statement. Use (i__) to access fields values.'||c_nl;
          tt := tt ||'if ' || nvl(replace(v_insertdummy,'''I''','''U'''), '1=2') || ' then' || c_nl;
          tt := tt ||'update ' || rb.sqltable || ' set' || c_nl;
          v_firstrow := true;
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
            if rp.updateyn = c_true then
              if v_firstrow then
                tt := tt || '  ' || rp.fieldid || ' = ' || rp.fieldi || c_nl;
              else
                tt := tt || ' ,' || rp.fieldid || ' = ' || rp.fieldi || c_nl;
              end if;
              v_firstrow := false;
            end if;
          end loop;
          tt := tt || 'where ' || v_where || ';'|| c_nl;
          tt := tt || ' '||c_message||' := '''|| RASDI_TRNSLT.text('Data is changed.', p_lang) ||''';' || c_nl;
          tt := tt || 'end if;'|| c_nl;
          if trueTrigger(rf.formid, 'on_update', rb.blockid) then
            createTriggerPLSQL(rf.formid, 'on_update', rb.blockid, tt);
          else
            if trueUpdate(rf.formid, rb.blockid) then
              addcnl(tt);
            end if;
          end if;
          if trueUpdate(rf.formid, rb.blockid) then
            createTriggerPLSQL(rf.formid, 'post_update', rb.blockid, '-- Triggers after UPDATE. Use (i__) to access fields values.');
          end if;
          if trueDelete(rf.formid, rb.blockid) then
            addcnl('       null;  end if;');
          end if;
          addcnl('      null; end if;');
        end if;
        for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if rp.elementyn = c_true then
            addcnl('    null; end loop;');
            exit;
          end if;
        end loop;
        
       
        addcnl('  null; end;');
      end loop;
      /***************************************************************************************/
      /*****************************   COMMIT     *************+***************************/
      /***************************************************************************************/
      addcnl('  procedure pcommit is');
      addcnl('  begin');
      createTriggerPLSQL(rf.formid, 'pre_commit','','-- Triggers before executing DML operations on DB blocks.');
      for rb in c_blocks(rf.formid) loop
        if nvl(rb.dbblockyn, 'N') = c_true then
          addcnl('    if ' || truePageSet(rf.formid, rb.blockid) || ' then ');
          addcnl('       pcommit_' || rb.blockid || ';');
          addcnl('    end if;');
        end if;
      end loop;
      createTriggerPLSQL(rf.formid, 'post_commit','','-- Triggers after executing DML operations on DB blocks.');

      addcnl('  null; ');
            
      if c_debug then
      addcnl(' exception when others then');
      addcnl('    rlog(''CODE: pcommit</BR>'');');
      addcnl('    rlog(''ERRORCODE:''||sqlcode||''</BR>'');');
      addcnl('    rlog(''ERRORMESSAGE''||sqlerrm||''</BR>'');');     
      addcnl('    raise;');     
      end if; 
      addcnl('  end;');
      /***************************************************************************************/
      /*****************************    OUTPUT     *************+***************************/
      /***************************************************************************************/
      addcnl('  procedure poutput is');
      -- HTML

      for rb in c_blocks(rf.formid) loop
        if not (nvl(rb.numrows, 1) = 1 and nvl(rb.emptyrows, 0) = 0) then
          addcnl('    i' || rb.blockid || ' pls_integer;');
        end if;
      end loop;     

      for rfx in (select * from rasd_fields where  formid =  rf.formid and blockid is null and  nvl(element,'INPUT_TEXT') not in ('INPUT_HIDDEN')) loop

        addcnl('  function ShowField'||rfx.nameid||' return boolean is ');
        addcnl('  begin ');
         select count(*)
         into n
         from rasd_fields p
         where p.formid = rf.formid
           and p. blockid is null
           and p.fieldid = c_page;
        if n > 0 then 
          addcnl('    if ' || truePageFieldSet(rf.formid, null , rfx.fieldid ) || ' then ');
          addcnl('       return true;');
          addcnl('    end if;');
          addcnl('    return false;');
        else
          addcnl('    return true;');
        end if; 
        addcnl('  end; ');
      end loop;

      
      for rb in (select * from rasd_blocks where  formid =  rf.formid) loop

        addcnl('  function ShowBlock'||rb.blockid||'_DIV return boolean is ');
        addcnl('  begin ');

         select count(*)
         into n
         from rasd_fields p
         where p.formid = rf.formid
           and p. blockid is null
           and p.fieldid = c_page;
         if n > 0 then 

         select count(*)
         into n
         from rasd_blocks p
         where p.formid = rf.formid
           --and nvl(p.dbblockyn,c_false) = c_true
           ;
        if n > 0 then  
          addcnl('    if ' || truePageSet(rf.formid, rb.blockid) || ' then ');
          addcnl('       return true;');
          addcnl('    end if;');
          addcnl('    return false;');
        else
          addcnl('    return true;');
        end if;  
        
        else

          addcnl('    return true;');
          
        end if;
        
          addcnl('  end; ');
      end loop;
            
      jsLinkIN(rf.formid, 'P');
      jsSQL(rf.formid, 'P');
      jsTEXT(rf.formid, 'P');
      jsTRUEFALSE(rf.formid, 'P');
      plsqlSQLTEXT(rf.formid, 'P', p_lang);
      addcnl('  begin');
        if c_debug then
              addcnl('rlog(''START <b>poutput</b>'');');
        end if;
      -- set HTML session values (cookies, header)
      addcnl('if set_session_block__ is not null then  execute immediate set_session_block__;  end if;');

      jsLinkIN(rf.formid, 'G');
      jsSQL(rf.formid, 'G');
      jsTEXT(rf.formid, 'G');
      jsTRUEFALSE(rf.formid, 'G');
      jsMandatory(rf.formid, 'G');      
      addcnl('    htp.prn(''');
      rasd_engineHTML10.writeHTML(rf.formid);
      addcnl('    '');');
      /*tt := '  exception' || c_nl;
      tt := tt || '  when others then' || c_nl;
      tt := tt ||
            '    htp.p(''<font color="red">''||replace(replace(sqlerrm,''' || c_nl ||
            ''',''\n''),''"'',''\"'')||''</font>'');' || c_nl;
      tt := tt || '    htp.p(''<script language="JavaScript">'');' || c_nl;
      tt := tt || '    htp.p(''<!--'');' || c_nl;
      tt := tt || '    htp.p(''  alert("''||replace(replace(sqlerrm,''' || c_nl ||
            ''',''\n''),''"'',''\"'')||''");'');' || c_nl;
      tt := tt || '    htp.p(''history.go(-1);'');' || c_nl;
      tt := tt || '    htp.p(''// -->'');' || c_nl;
      tt := tt || '    htp.p(''</script>'');' || c_nl;
      if trueTrigger(rf.formid, 'ON_ERROR_CLI') then
        createTriggerPLSQL(rf.formid, 'ON_ERROR_CLI', '', tt);
      else
        addcnl(tt);
      end if; */
        if c_debug then
              addcnl('rlog(''END poutput<br/>'');');
        end if;      
      addcnl('  null; end;');

      /***************************************************************************************/
      /*****************************    OUTPUTREST   *************+***************************/
      /***************************************************************************************/
if rf.autocreaterestyn = 'Y' then      
      addcnl('  procedure poutputrest is');
      addcnl('    v_firstrow__ boolean;');

      addcnl('    function escapeRest(v_str varchar2) return varchar2 is ');
      addcnl('    begin');
      addcnl('      return replace(v_str,''"'',''&quot;'');');
      addcnl('    end;');
      addcnl('    function escapeRest(v_str clob) return clob is ');
      addcnl('    begin');
      addcnl('      return replace(v_str,''"'',''&quot;'');');
      addcnl('    end;');

      for rb in (select * from rasd_blocks where  formid =  rf.formid) loop
        addcnl('  function ShowBlock'||rb.blockid||'_DIV return boolean is ');
        addcnl('  begin ');

         select count(*)
         into n
         from rasd_blocks p
         where p.formid = rf.formid
           and nvl(p.dbblockyn,c_false) = c_true;
        if n > 0 then  
          addcnl('    if ' || truePageSet(rf.formid, rb.blockid) || ' then ');
          addcnl('       return true;');
          addcnl('    end if;');
          addcnl('    return false;');
        else
          addcnl('    return true;');
        end if;  
          addcnl('  end; ');
      end loop;
     addcnl('  begin');

      -- set HTML session values (cookies, header)
     addcnl('if set_session_block__ is not null then  execute immediate set_session_block__;  end if;');


     addcnl('if '||c_restrestype||' = ''XML'' then' );
     
          addcnl('    htp.p(''<?xml version="1.0" encoding="UTF-8"?>''); ');
          addcnl('    htp.p(''<form name="'||rf.form||'" version="'||rf.version||'">''); ');
          addcnl('    htp.p(''<formfields>''); ');
          for rp in c_fieldsOfForm(rf.formid) loop
          if nvl(rp.elementyn,c_false) = c_true then
          if rp.type in ('C','L') then 
          addcnl('    htp.p(''<'||lower(rp.fieldid)||'><![CDATA[''||'||rp.fieldid||'||'']]></'||lower(rp.fieldid)||'>''); ');
          else           
          addcnl('    htp.p(''<'||lower(rp.fieldid)||'>''||'||rp.fieldid||'||''</'||lower(rp.fieldid)||'>''); ');
          end if;
          end if;
          end loop;
          addcnl('    htp.p(''</formfields>''); ');

      for rb in c_blocks(rf.formid) loop
        
          addcnl('    if ShowBlock'||lower(rb.blockid)||'_DIV then ');
      
          addcnl('    htp.p(''<'||lower(rb.blockid)||'>''); ');
       if nvl(rb.dbblockyn, c_false) = c_true or rb.numrows != 1 then
          addcnl('  for i__ in 1..');
          
          
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
               exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
               exit;
               end if;
           end loop;        
           end if;
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.elementyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
               exit;
               end if;
           end loop;        
           end if;
           end;          
         
          addcnl('.count loop ');
          addcnl('    htp.p(''<element>''); ');             
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if nvl(rp.elementyn,c_false) = c_true then  
          if rp.type in ('C','L') then 
          addcnl('    htp.p(''<'||lower(rp.blockid||rp.fieldid)||'><![CDATA[''||'||rp.blockid||rp.fieldid||'(i__)||'']]></'||lower(rp.blockid||rp.fieldid)||'>''); ');
          else
          addcnl('    htp.p(''<'||lower(rp.blockid||rp.fieldid)||'>''||'||rp.blockid||rp.fieldid||'(i__)||''</'||lower(rp.blockid||rp.fieldid)||'>''); ');
          end if;
          end if;
          end loop;
          addcnl('    htp.p(''</element>''); ');             
          addcnl('  end loop; ');
       else
          addcnl('    htp.p(''<element>''); ');             
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
          if nvl(rp.elementyn,c_false) = c_true then  
          if rp.type in ('C','L') then             
          addcnl('    htp.p(''<'||lower(rp.blockid||rp.fieldid)||'><![CDATA[''||'||rp.blockid||rp.fieldid||'(1)||'']]></'||lower(rp.blockid||rp.fieldid)||'>''); ');
          else
          addcnl('    htp.p(''<'||lower(rp.blockid||rp.fieldid)||'>''||'||rp.blockid||rp.fieldid||'(1)||''</'||lower(rp.blockid||rp.fieldid)||'>''); ');
          end if;
          end if;
          end loop;
          addcnl('    htp.p(''</element>''); ');                     
       end if;   
          addcnl('  htp.p(''</'||lower(rb.blockid)||'>''); ');
          addcnl('  end if; ');
      end loop;
          addcnl('    htp.p(''</form>''); ');
                    
     addcnl('else' );
                 
          addcnl('    htp.p(''{"form":{"@name":"'||rf.form||'","@version":"'||rf.version||'",'' ); ');
          addcnl('    htp.p(''"formfields": {''); ');
          
          v_firstrow := true;
          for rp in c_fieldsOfForm(rf.formid) loop
          if v_firstrow then  
            if nvl(rp.elementyn,c_false) = c_true then
            if rp.type in ('C','L') then
            addcnl('    htp.p(''"'||lower(rp.fieldid)||'":"''||escapeRest('||rp.fieldid||')||''"''); '); 
            else   
            addcnl('    htp.p(''"'||lower(rp.fieldid)||'":"''||'||rp.fieldid||'||''"''); '); 
            end if;            
            v_firstrow := false;
            end if;
          else
            if nvl(rp.elementyn,c_false) = c_true then            
            if rp.type in ('C','L') then
            addcnl('    htp.p('',"'||lower(rp.fieldid)||'":"''||escapeRest('||rp.fieldid||')||''"''); ');            
            else  
            addcnl('    htp.p('',"'||lower(rp.fieldid)||'":"''||'||rp.fieldid||'||''"''); ');            
            end if;
            end if;
          end if;
          end loop;
          addcnl('    htp.p(''},''); '); --

          v_firstrow := true;
      for rb in c_blocks(rf.formid) loop

          addcnl('    if ShowBlock'||lower(rb.blockid)||'_DIV then ');
        
          if v_firstrow then   
            addcnl('    htp.p(''"'||lower(rb.blockid)||'":[''); ');
--            v_firstrow := false;
          else
            addcnl('    htp.p('',"'||lower(rb.blockid)||'":[''); ');
          end if;          
          
          if nvl(rb.dbblockyn, c_false) = c_true or rb.numrows != 1 then
        
          addcnl('  v_firstrow__ := true;');
          addcnl('  for i__ in 1..');
          
           declare
            V_ridok number := 0;
           begin
           v_ridok := 0;
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true and rp.fieldid = c_rid then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
               exit;
               end if;
           end loop;        
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.selectyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;                  
               exit;
               end if;
           end loop;        
           end if;
           if v_ridok = 0 then
           for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
               if nvl(rp.elementyn, c_false) = c_true then
                  addcnl(  rp.blockid||rp.fieldid );
                  v_ridok := 1;
               exit;
               end if;
           end loop;        
           end if;
           end;          
          
          addcnl('.count loop ');
          addcnl('    if v_firstrow__ then');
          addcnl('     htp.p(''{''); ');
          addcnl('     v_firstrow__ := false;');
          addcnl('    else');
          addcnl('     htp.p('',{''); ');
          addcnl('    end if;');
          declare
           v_f boolean := true;
          begin
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              
          if v_f then
          if nvl(rp.elementyn,c_false) = c_true then     
          if rp.type in ('C','L') then            
          addcnl('    htp.p(''"'||lower(rp.blockid||rp.fieldid)||'":"''||escapeRest('||rp.blockid||rp.fieldid||'(i__))||''"''); '); 
          else
          addcnl('    htp.p(''"'||lower(rp.blockid||rp.fieldid)||'":"''||'||rp.blockid||rp.fieldid||'(i__)||''"''); '); 
          end if;
          v_f := false;
          end if;
          else
          if nvl(rp.elementyn,c_false) = c_true then  
          if rp.type in ('C','L') then            
          addcnl('    htp.p('',"'||lower(rp.blockid||rp.fieldid)||'":"''||escapeRest('||rp.blockid||rp.fieldid||'(i__))||''"''); ');           
          else
          addcnl('    htp.p('',"'||lower(rp.blockid||rp.fieldid)||'":"''||'||rp.blockid||rp.fieldid||'(i__)||''"''); ');           
          end if;
          end if;
          end if;
 
          end loop;
          end;
          addcnl('    htp.p(''}''); ');
          addcnl('  end loop; ');
         
          else
            
          addcnl('     htp.p(''{''); ');
          declare
           v_f boolean := true;
          begin
          for rp in c_fieldsOfBlock(rf.formid, rb.blockid) loop
              
          if v_f then   
          if nvl(rp.elementyn,c_false) = c_true then  
          if rp.type in ('C','L') then 
          addcnl('    htp.p(''"'||lower(rp.blockid||rp.fieldid)||'":"''||escapeRest('||rp.blockid||rp.fieldid||'(1))||''"''); '); 
          else
          addcnl('    htp.p(''"'||lower(rp.blockid||rp.fieldid)||'":"''||'||rp.blockid||rp.fieldid||'(1)||''"''); '); 
          end if;
          v_f := false;
          end if;
          else
          if nvl(rp.elementyn,c_false) = c_true then  
          if rp.type in ('C','L') then 
          addcnl('    htp.p('',"'||lower(rp.blockid||rp.fieldid)||'":"''||escapeRest('||rp.blockid||rp.fieldid||'(1))||''"''); ');           
          else
          addcnl('    htp.p('',"'||lower(rp.blockid||rp.fieldid)||'":"''||'||rp.blockid||rp.fieldid||'(1)||''"''); ');           
          end if;
          end if;
          end if;
 
          end loop;
          end;
          addcnl('    htp.p(''}''); ');
          
          end if;
          
          addcnl('    htp.p('']''); '); 
 
         addcnl('  else ');
         
          if v_firstrow then   
            addcnl('    htp.p(''"'||lower(rb.blockid)||'":[]''); ');
            v_firstrow := false;
          else
            addcnl('    htp.p('',"'||lower(rb.blockid)||'":[]''); ');
          end if;
                   
         addcnl('  end if; ');
      end loop;
          addcnl('    htp.p(''}}''); ');

     addcnl('end if;' );
          
     addcnl('  null; end;');
end if;

      /***************************************************************************************/
      /*** WEBCLIENT ***************************************************************************/
      /***************************************************************************************/
      addcnl('procedure webclient(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl(') is');

      /***************************************************************************************/
      /** BEGIN ******************************************************************************/
      /***************************************************************************************/
      addcnl('begin  ');
      
        if c_debug then
           addcnl('   rlog(''<b>Use rlog(''''your text''''); function to log your comments in code.</b> <br/>'');');
           addcnl('   rlog(''START PROGRAM <br/>'');');
        end if;
      
--added PRE_ACTION trigger.... 12.1.2017
        
--      addcnl('  rasd_client.secCheckCredentials(  name_array , value_array ); ');
        tt := '';
        
        if c_debug then
            tt := ' rlog(''PRE_ACTION'');'|| c_nl;
        end if;

        tt := tt ||'  rasd_client.secCheckCredentials(  name_array , value_array ); '|| c_nl;
        
        if c_debug then
            tt := tt ||' rlog(''END PRE_ACTION'');'|| c_nl;
        end if;

        if trueTrigger(rf.formid, 'PRE_ACTION') then
          createTriggerPLSQL(rf.formid, 'PRE_ACTION', '', tt);
        else
          addcnl(tt);
        end if;          
--      
      
  
      if trueField(rf.formid, c_action) then
        tt := '  -- The program execution sequence based on  ' || c_action || ' defined.' || c_nl;
        tt := tt || '  psubmit(name_array ,value_array);' || c_nl;

        tt := tt || '  rasd_client.secCheckPermission('''||rf.form||''',' || c_action || ');  '|| c_nl;

        tt := tt || '  if ' || c_action || ' is null then null;' || c_nl;

        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
          end if;
        end loop;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutput;' || c_nl;

        tt1 := '';
        if trueField(rf.formid,'GBUTTONBCK') then
        tt1 := tt1 ||', GBUTTONBCK';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONBCK then ' ;
            --  getDefaultValue(rf.formid, null, 'GBUTTONBCK') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) and
             rb.pagingyn = c_true then
            tt := tt || '    if ' || c_recnum || rb.blockid || ' > ' ||
                  rb.numrows || ' then' || c_nl;
            tt := tt || '      ' || c_recnum || rb.blockid || ' := ' ||
                  c_recnum || rb.blockid || '-' || rb.numrows || ';' || c_nl;
            tt := tt || '    else' || c_nl;
            tt := tt || '      ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
            tt := tt || '    end if;' || c_nl;
          end if;
        end loop;        
        if c_debug then
            tt := tt ||' rlog(''<b>START for ACTION GBUTTONBCK</b> <br/>'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONBCK<br/>'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONFWD') then
        tt1 := tt1 ||', GBUTTONFWD';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONFWD then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONFWD') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) and
             rb.pagingyn = c_true then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := ' ||
                  c_recnum || rb.blockid || '+' || rb.numrows || ';' || c_nl;
          end if;
        end loop;
        if c_debug then
            tt := tt ||' rlog(''<b>START for ACTION GBUTTONFWD</b> <br/>'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONFWD<br/>'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONSRC') then
        tt1 := tt1 ||', GBUTTONSRC';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONSRC then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONSRC') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
          end if;
        end loop;
        if c_debug then
            tt := tt ||' rlog(''<b>START for ACTION GBUTTONSRC</b> <br/>'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONSRC <br/>'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONSAVE') then       
        tt1 := tt1 ||', GBUTTONSAVE';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONSAVE then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONSAVE') || ' then' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''<b>START for ACTION GBUTTONSAVE</b> <br/>'');'|| c_nl;
        end if;
        tt := tt || '    pcommit;' || c_nl;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    --if '||c_message||' is null then' || c_nl;
        tt := tt || '    --'||c_message||' := '''|| RASDI_TRNSLT.text('Form is changed.', p_lang) ||''';' || c_nl;
        tt := tt || '    --end if;' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONSAVE<br/>'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONCLR') then               
        tt1 := tt1 ||', GBUTTONCLR';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONCLR then ' ;
             -- getDefaultValue(rf.formid, null, 'GBUTTONCLR') || ' then' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''<b>START for ACTION GBUTTONCLR</b> <br/>'');'|| c_nl;
        end if;
        tt := tt || '    pclear;' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONCLR <br/>'');'|| c_nl;
        end if;
        end if;
        --if length(tt1) > 0 then 
        tt := tt || '  end if;' || c_nl;
        --end if;

        if trueTrigger(rf.formid, 'ON_ACTION') then
          createTriggerPLSQL(rf.formid, 'ON_ACTION', '', tt);
        else
          addcnl(tt);
        end if;

        tt := '  -- The execution after default execution based on  ' || c_action || '.' || c_nl;

        if tt1 is not null then
        tt := tt ||'  -- Delete this code (if) when you have new actions and add your own.' || c_nl;          
        tt := tt ||'  if  nvl(' || c_action || ',GBUTTONSRC) not in ( '||substr(tt1,2)||' ) then ' || c_nl;          
        else
        tt := tt ||'  if  ' || c_action || ' is not null then ' || c_nl;
        end if;
        
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;
        tt := tt ||'    raise_application_error(''-20000'', ''' || c_action || '="''||'||c_action||'||''" is not defined. Define it in POST_ACTION trigger.'');' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;

        tt := tt || '  end if;' || c_nl;

        if trueTrigger(rf.formid, 'POST_ACTION') then
          createTriggerPLSQL(rf.formid, 'POST_ACTION', '', tt);
        else
          addcnl(tt);
        end if;


      else
        tt := '  -- The program execution sequence based on  ' || c_action || ' defined.' || c_nl;
        tt := tt || '  rasd_client.secCheckPermission('''||rf.form||''','''');  '|| c_nl;
        tt := tt || '  psubmit(name_array ,value_array);' || c_nl;
        tt := tt || '  poutput;' || c_nl;

        if trueTrigger(rf.formid, 'ON_ACTION') then
          createTriggerPLSQL(rf.formid, 'ON_ACTION', '', tt);
        else
          addcnl(tt);
        end if;
        
        tt := '  -- The execution after default execution based on  ' || c_action || '.' || c_nl;
        if trueTrigger(rf.formid, 'POST_ACTION') then
          createTriggerPLSQL(rf.formid, 'POST_ACTION', '', tt);
        else
          addcnl(tt);
        end if;

      end if;

        if c_debug then
           addcnl('    rlog(''END PROGRAM <br/>'');');
        end if;
           addcnl('    pLog;');
                   

      addcnl('exception');
      addcnl('  when ' || re.library || '.e_finished then pLog;');
      addcnl('  when others then');
    
      -- HTML error handler
     declare
      i_start number;
      i_end number;
     begin
      i_start := v_gl;      
      
      addcnl('    htp.prn(''');     
      
      rasd_engineHTML10.writeHTMLError(rf.formid);      

      addcnl('    '');');
      
      i_end := v_gl;      

      tt := '';
      for i in i_start+1..i_end loop
        
      tt := tt  || v_gc(i);
      
      end loop;

     
        if trueTrigger(rf.formid, 'ON_ERROR') then
          v_gl := i_start;
          createTriggerPLSQL(rf.formid, 'ON_ERROR', '', tt);
        end if;


      end;
      --
      /*        
        tt := 'exception' || c_nl;
        tt := tt || '  when ' || re.library || '.e_finished then null;' || c_nl;
        tt := tt || '  when others then' || c_nl;
        tt := tt || '    htp.p(''<script language="JavaScript">'');' || c_nl;
        tt := tt || '    htp.p(''<!--'');' || c_nl;
        tt := tt || '    htp.p(''  alert("''||replace(replace(sqlerrm,''' || c_nl ||
              ''',''\n''),''"'',''\"'')||''");'');' || c_nl;
        tt := tt || '    htp.p(''history.go(-1);'');' || c_nl;
        tt := tt || '    htp.p(''// -->'');' || c_nl;
        tt := tt || '    htp.p(''</script>'');' || c_nl;
        if trueTrigger(rf.formid, 'ON_ERROR') then
          createTriggerPLSQL(rf.formid, 'ON_ERROR', '', tt);
        else
          addcnl(tt);
        end if;
      */
      addcnl('    pLog;');


      addcnl('end; ');

      /***************************************************************************************/
      /**** MAIN ***************************************************************************/
      /***************************************************************************************/
if rf.autocreatebatchyn = 'Y' then
      addcnl('procedure main(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl(') is');
      

      /***************************************************************************************/
      /** BEGIN ******************************************************************************/
      /***************************************************************************************/
      addcnl('begin  ');
      
--      addcnl('  rasd_client.secCheckCredentials(  name_array , value_array ); ');
        tt := '';
        
        if c_debug then
            tt := ' rlog(''PRE_ACTION'');'|| c_nl;
        end if;

        tt := tt ||'  rasd_client.secCheckCredentials(  name_array , value_array ); '|| c_nl;
        
        if c_debug then
            tt := tt ||' rlog(''END PRE_ACTION'');'|| c_nl;
        end if;


        if trueTrigger(rf.formid, 'PRE_ACTION') then
          createTriggerPLSQL(rf.formid, 'PRE_ACTION', '', tt);
        else
          addcnl(tt);
        end if;  


        tt := '  -- The program execution sequence based on  ' || c_action || ' defined.' || c_nl;
        tt := tt || '  psubmit(name_array ,value_array);' || c_nl;
        tt := tt || '  rasd_client.secCheckPermission('''||rf.form||''',' || c_action || ');  '|| c_nl;
        
        if trueField(rf.formid,'GBUTTONSAVE') then       
        tt1 := tt1 ||', GBUTTONSAVE';
        tt := tt || '  if ' || c_action || ' = GBUTTONSAVE then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONSAVE') || ' then' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''START GBUTTONSAVE'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    pcommit;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONSAVE'');'|| c_nl;
        end if;
        tt := tt || '  end if;' || c_nl;
        end if;
        
        if trueTrigger(rf.formid, 'ON_ACTION_MAIN') then
          createTriggerPLSQL(rf.formid, 'ON_ACTION_MAIN', '', tt); 
        else
          addcnl(tt);
        end if;


       tt := '  -- The execution after default execution based on  ' || c_action || '.' || c_nl;

        if tt1 is not null then
        tt := tt ||'  -- Delete this code (if) when you have new actions and add your oown.' || c_nl;          
        tt := tt ||'  if  nvl(' || c_action || ',GBUTTONSRC) not in ( '||substr(tt1,2)||' ) then ' || c_nl;          
        else
        tt := tt ||'  if  ' || c_action || ' is not null then ' || c_nl;
        end if;
        
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;
        tt := tt ||'    raise_application_error(''-20000'', ''' || c_action || '="''||'||c_action||'||''" is not defined. Define it in POST_ACTION trigger.'');' || c_nl;
        tt := tt || '    poutput;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;

        tt := tt || '  end if;' || c_nl;

       if trueField(rf.formid, c_action) then    

        if trueTrigger(rf.formid, 'POST_ACTION') then
          createTriggerPLSQL(rf.formid, 'POST_ACTION', '', tt);
        else
          addcnl(tt);
        end if;
       
      end if;
      
      tt := '-- Error handler for the main program.' || c_nl;
      tt :=  tt ||' exception' || c_nl;
      tt :=  tt ||'  when ' || re.library || '.e_finished then null;' || c_nl;      
      if trueTrigger(rf.formid, 'ON_ERROR_MAIN') then
          createTriggerPLSQL(rf.formid, 'ON_ERROR_MAIN', '', tt);
      else
          addcnl(tt);
      end if;
      addcnl('end; ');
end if;
      /***************************************************************************************/
      /**** REST   ***************************************************************************/
      /***************************************************************************************/
if rf.autocreaterestyn = 'Y' then
      addcnl('procedure rest(');
      addcnl('  name_array  in owa.vc_arr,');
      addcnl('  value_array in owa.vc_arr');
      addcnl(') is');
      

      /***************************************************************************************/
      /** BEGIN ******************************************************************************/
      /***************************************************************************************/
      addcnl('begin  ');

--      addcnl('  rasd_client.secCheckCredentials(  name_array , value_array ); ');
        tt := '';
        
        if c_debug then
            tt := ' rlog(''PRE_ACTION'');'|| c_nl;
        end if;

        tt := tt ||'  rasd_client.secCheckCredentials(  name_array , value_array ); '|| c_nl;
        
        if c_debug then
            tt := tt ||' rlog(''END PRE_ACTION'');'|| c_nl;
        end if;

        if trueTrigger(rf.formid, 'PRE_ACTION') then
          createTriggerPLSQL(rf.formid, 'PRE_ACTION', '', tt);
        else
          addcnl(tt);
        end if;  
              
      if trueField(rf.formid, c_action) then
        tt := '  -- The program execution sequence based on  ' || c_action || ' defined.' || c_nl;
        tt := tt || '  psubmit(name_array ,value_array);' || c_nl;
        tt := tt || '  rasd_client.secCheckPermission('''||rf.form||''',' || c_action || ');  '|| c_nl;
        tt := tt || '  if ' || c_action || ' is null then null;' || c_nl;

        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
          end if;
        end loop;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        tt1 := '';
        if trueField(rf.formid,'GBUTTONBCK') then
        tt1 := tt1 ||', GBUTTONBCK';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONBCK then ' ;
            --  getDefaultValue(rf.formid, null, 'GBUTTONBCK') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) and
             rb.pagingyn = c_true then
            tt := tt || '    if ' || c_recnum || rb.blockid || ' > ' ||
                  rb.numrows || ' then' || c_nl;
            tt := tt || '      ' || c_recnum || rb.blockid || ' := ' ||
                  c_recnum || rb.blockid || '-' || rb.numrows || ';' || c_nl;
            tt := tt || '    else' || c_nl;
            tt := tt || '      ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
            tt := tt || '    end if;' || c_nl;
          end if;
        end loop;        
        if c_debug then
            tt := tt ||'rlog(''START GBUTTONBCK'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONBCK'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONFWD') then
        tt1 := tt1 ||', GBUTTONFWD';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONFWD then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONFWD') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) and
             rb.pagingyn = c_true then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := ' ||
                  c_recnum || rb.blockid || '+' || rb.numrows || ';' || c_nl;
          end if;
        end loop;
        if c_debug then
            tt := tt ||' rlog(''START GBUTTONFWD'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        if c_debug then
            tt := tt ||' rlog (''END GBUTTONFWD'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONSRC') then
        tt1 := tt1 ||', GBUTTONSRC';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONSRC or ' || c_action || ' is null  then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONSRC') || ' then' || c_nl;
        for rb in c_blocks(rf.formid) loop
          if trueField(rf.formid, c_recnum || rb.blockid) then
            tt := tt || '    ' || c_recnum || rb.blockid || ' := 1;' || c_nl;
          end if;
        end loop;
        if c_debug then
            tt := tt ||' rlog(''START GBUTTONSRC'');'|| c_nl;
        end if;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONSRC'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONSAVE') then       
        tt1 := tt1 ||', GBUTTONSAVE';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONSAVE then ' ;
--              getDefaultValue(rf.formid, null, 'GBUTTONSAVE') || ' then' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''START GBUTTONSAVE'');'|| c_nl;
        end if;
        tt := tt || '    pcommit;' || c_nl;
        tt := tt || '    pselect;' || c_nl;
        tt := tt || '    --if '||c_message||' is null then' || c_nl;
        tt := tt || '    --'||c_message||' := '''|| RASDI_TRNSLT.text('Form is changed.', p_lang) ||''';' || c_nl;
        tt := tt || '    --end if;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONSAVE'');'|| c_nl;
        end if;
        end if;
        if trueField(rf.formid,'GBUTTONCLR') then               
        tt1 := tt1 ||', GBUTTONCLR';
        tt := tt || '  elsif ' || c_action || ' = GBUTTONCLR then ' ;
             -- getDefaultValue(rf.formid, null, 'GBUTTONCLR') || ' then' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''START GBUTTONCLR'');'|| c_nl;
        end if;
        tt := tt || '    pclear;' || c_nl;
        tt := tt || '    poutputrest;' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''END GBUTTONCLR'');'|| c_nl;
        end if;
        end if;
        --if length(tt1) > 0 then 
        tt := tt || '  end if;' || c_nl;
        --end if;

        if trueTrigger(rf.formid, 'ON_ACTION_REST') then
          createTriggerPLSQL(rf.formid, 'ON_ACTION_REST', '', tt);
        else
          addcnl(tt);
        end if;

       tt := '  -- The execution after default execution based on  ' || c_action || '.' || c_nl;

        if tt1 is not null then
        tt := tt ||'  -- Delete this code when you have new actions and add your own.' || c_nl;          
        tt := tt ||'  if  nvl(' || c_action || ',GBUTTONSRC) not in ( '||substr(tt1,2)||' ) then ' || c_nl;          
        else
        tt := tt ||'  if  ' || c_action || ' is not null then ' || c_nl;
        end if;
        
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;
        tt := tt ||'    raise_application_error(''-20000'', ''' || c_action || '="''||'||c_action||'||''" is not defined. Define it in POST_ACTION trigger.'');' || c_nl;
        if c_debug then
            tt := tt ||' rlog(''POST_ACTION'');'|| c_nl;
        end if;

        tt := tt || '  end if;' || c_nl;

        if trueTrigger(rf.formid, 'POST_ACTION') then
          createTriggerPLSQL(rf.formid, 'POST_ACTION', '', tt);
        else
          addcnl(tt);
        end if;



      else
        tt := '  -- The program execution sequence based on  ' || c_action || ' defined.' || c_nl;
        tt := tt || '  psubmit(name_array ,value_array);' || c_nl;
        tt := tt || '  rasd_client.secCheckPermission('''||rf.form||''','''');  '|| c_nl;
        tt := tt || '  poutput;' || c_nl;

        if trueTrigger(rf.formid, 'ON_ACTION_REST') then
          createTriggerPLSQL(rf.formid, 'ON_ACTION_REST', '', tt);
        else
          addcnl(tt);
        end if;
        
        tt := '  -- The execution after default execution based on  ' || c_action || '.' || c_nl;
        if trueTrigger(rf.formid, 'POST_ACTION') then
          createTriggerPLSQL(rf.formid, 'POST_ACTION', '', tt);
        else
          addcnl(tt);
        end if;

      end if;


      
      tt := '-- Error handler for the rest program.' || c_nl;
      tt :=  tt ||' exception' || c_nl;
      tt :=  tt ||'  when ' || re.library || '.e_finished then null;' || c_nl;      
      tt :=  tt ||'  when others then' || c_nl;

      tt :=  tt ||'if '||c_restrestype||' = ''XML'' then' || c_nl;
   
      tt :=  tt ||'    htp.p(''<?xml version="1.0" encoding="UTF-8"?>'|| c_nl||
                              '<form name="'||rf.form||'" version="'||rf.version||'">''); ';
      tt :=  tt ||'    htp.p(''<error>''); ';
      tt :=  tt ||'    htp.p(''  <errorcode>''||sqlcode||''</errorcode>''); ';
      tt :=  tt ||'    htp.p(''  <errormessage>''||sqlerrm||''</errormessage>''); ';
      tt :=  tt ||'    htp.p(''</error>''); ';
      tt :=  tt ||'    htp.p(''</form>''); ';
  
      tt :=  tt ||'else' || c_nl;
  
      tt :=  tt ||'    htp.p(''{"form":{"@name":"'||rf.form||'","@version":"'||rf.version||'",'' ); ';
      tt :=  tt ||'    htp.p(''"error":{''); ';
      tt :=  tt ||'    htp.p(''  "errorcode":"''||sqlcode||''",''); ';
      tt :=  tt ||'    htp.p(''  "errormessage":"''||sqlerrm||''"''); ';
      tt :=  tt ||'    htp.p(''}''); ';
      tt :=  tt ||'    htp.p(''}}''); ';

      tt :=  tt ||'end if;' || c_nl;

      if trueTrigger(rf.formid, 'ON_ERROR_REST') then
          createTriggerPLSQL(rf.formid, 'ON_ERROR_REST', '', tt);
      else
          addcnl(tt);
      end if;
      addcnl('end; ');
end if;
      /***************************************************************************************/
      /*** METADATA     **********************************************************************/
      /***************************************************************************************/


addcnl('function metadata_xml return cctab is');
addcnl('  v_clob clob := '''';');     
--addcnl('  type t_vc is table of varchar2(32000) index by binary_integer;');
addcnl('  v_vc cctab;');
addcnl('  begin');

select count(*) into v_metadata 
from rasd_forms_compiled
where compileyn = 'Y'
 and formid = rf.formid;

if v_metadata > 0 then
--addcnl('  /** '); 
--end if;

declare
 v_xmldata clob;
begin
select xmlelement( 
           "form", xmlelement("form",form) ,
            xmlelement("version",f.version) ,
            xmlelement("change",to_char(sysdate,'dd.mm.yyyy hh/mi/ss')) ,
            xmlelement("user",user) ,
            xmlelement("label",XMLCData(f.label)) ,
            xmlelement("lobid",f.lobid) ,
            xmlelement("program",f.program) ,
            xmlelement("compiler",
            xmlelement("engineid",re.engineid) ,
            xmlelement("server",re.server) ,
            xmlelement("client",re.client) ,
            xmlelement("library",re.library)),            
--            xmlelement("text1id",f.text1id) ,
--            xmlelement("text2id",f.text2id) ,
            --rasd_blocks
            (select xmlelement("blocks", XMLAgg(xmlelement("block",
              xmlelement("blockid",b.blockid) ,
              xmlelement("sqltable",b.sqltable) ,
              xmlelement("numrows",b.numrows) ,
              xmlelement("emptyrows",b.emptyrows) ,
              xmlelement("dbblockyn",b.dbblockyn) ,
              xmlelement("rowidyn",b.rowidyn) ,
              xmlelement("pagingyn",b.pagingyn) ,
              xmlelement("clearyn",b.clearyn) ,
              xmlelement("sqltext",XMLCData(b.sqltext)||'
') ,
              xmlelement("label",XMLCData(b.label)) ,
              xmlelement("source",b.source) ,
              xmlelement("hiddenyn",b.hiddenyn),
              --rasd_fields 
              (select xmlelement("fields", XMLAgg(xmlelement("field",
                xmlelement("blockid",p.blockid) ,
                xmlelement("fieldid",p.fieldid) ,
                xmlelement("type",p.type) ,
                xmlelement("format",XMLCData(p.format)) ,
                xmlelement("element",p.element) ,
                xmlelement("hiddenyn",p.hiddenyn) ,
                xmlelement("orderby",p.orderby) ,
                xmlelement("pkyn",p.pkyn) ,
                xmlelement("selectyn",p.selectyn) ,
                xmlelement("insertyn",p.insertyn) ,
                xmlelement("updateyn",p.updateyn) ,
                xmlelement("deleteyn",p.deleteyn) ,
                xmlelement("insertnnyn",p.insertnnyn) ,
                xmlelement("notnullyn",p.notnullyn) ,
                xmlelement("lockyn",p.lockyn) ,
                xmlelement("defaultval",XMLCData(p.defaultval)) ,
                xmlelement("elementyn",p.elementyn) ,
                xmlelement("nameid",p.nameid) ,
                xmlelement("label",XMLCData(p.label)) ,
                xmlelement("linkid",p.linkid) ,
                xmlelement("source",p.source)
                ))) from rasd_fields p where formid = f.formid and p.blockid = b.blockid )              
              ))) from rasd_blocks b where b.formid = f.formid ) ,
            --rasd_fields p.blockid is null 
            (select xmlelement("fields", XMLAgg(xmlelement("field",
                xmlelement("blockid",p.blockid) ,
                xmlelement("fieldid",p.fieldid) ,
                xmlelement("type",p.type) ,
                xmlelement("format",XMLCData(p.format)) ,
                xmlelement("element",p.element) ,
                xmlelement("hiddenyn",p.hiddenyn) ,
                xmlelement("orderby",p.orderby) ,
                xmlelement("pkyn",p.pkyn) ,
                xmlelement("selectyn",p.selectyn) ,
                xmlelement("insertyn",p.insertyn) ,
                xmlelement("updateyn",p.updateyn) ,
                xmlelement("deleteyn",p.deleteyn) ,
                xmlelement("insertnnyn",p.insertnnyn) ,
                xmlelement("notnullyn",p.notnullyn) ,
                xmlelement("lockyn",p.lockyn) ,
                xmlelement("defaultval",XMLCData(p.defaultval)) ,
                xmlelement("elementyn",p.elementyn) ,
                xmlelement("nameid",p.nameid) ,
                xmlelement("label",XMLCData(p.label)) ,
                xmlelement("linkid",p.linkid) ,
                xmlelement("source",p.source)
                ))) from rasd_fields p where formid = f.formid and p.blockid is null ) ,
             --rasd_links    
            (select xmlelement("links", XMLAgg(xmlelement("link",
              xmlelement("linkid",b.linkid) ,
              xmlelement("link",b.link) ,
              xmlelement("type",b.type) ,
              xmlelement("location",XMLCData(b.location)) ,
              xmlelement("text",XMLCData(b.text)) ,
              xmlelement("source",b.source) ,
              xmlelement("hiddenyn",b.hiddenyn),
              --rasd_link_params
             (select xmlelement("params" , XMLAgg(xmlelement("param" ,
               xmlelement("paramid",c.paramid),
               xmlelement("type",c.type),
               xmlelement("orderby",c.orderby),
               xmlelement("blockid",c.blockid),
               xmlelement("fieldid",c.fieldid),
               xmlelement("namecid",c.namecid),
               xmlelement("code",c.code),
               xmlelement("value",XMLCData(c.value))
            ))) 
            from rasd_link_params c where b.linkid = c.linkid and b.formid = c.formid )
           ))) from rasd_links b where b.formid = f.formid ) ,
           --rasd_pages
            (select xmlelement("pages", XMLAgg(xmlelement("pagedata",
              xmlelement("page",g.page) ,
              xmlelement("blockid",g.blockid) ,
              xmlelement("fieldid",g.fieldid)
           ))) from rasd_pages g where g.formid = f.formid ),                           
           --rasd_triggers
            (select xmlelement("triggers", XMLAgg(xmlelement("trigger",
              xmlelement("blockid",h.blockid) ,
              xmlelement("triggerid",h.triggerid) ,
              xmlelement("plsql",XMLCData(h.plsql||'
')),
              xmlelement("plsqlspec",XMLCData(h.plsqlspec||'
')),
              xmlelement("source",h.source),
              xmlelement("hiddenyn",h.hiddenyn)
           ))) from rasd_triggers h where h.formid = f.formid ) ,
             --rasd_elements    
            (select xmlelement("elements", XMLAgg(xmlelement("element",
              xmlelement("elementid",k.elementid) ,
              xmlelement("pelementid",k.pelementid) ,
              xmlelement("orderby",k.orderby) ,
              xmlelement("element",k.element) ,
              xmlelement("type",k.type) ,
              xmlelement("id",k.id) ,
              xmlelement("nameid",k.nameid),
              xmlelement("endtagelementid",k.endtagelementid),
              xmlelement("source",k.source),
              xmlelement("hiddenyn",k.hiddenyn),
              --rasd_attributes
             (select xmlelement("attributes" , XMLAgg(xmlelement("attribute" ,
               xmlelement("orderby",l.orderby),
               xmlelement("attribute",l.attribute),
               xmlelement("type",l.type),
               xmlelement("text",XMLCData(l.text)),
               xmlelement("name",XMLCData(l.name)),
               xmlelement("value",XMLCData(l.value)),
               xmlelement("valuecode",XMLCData(l.valuecode)),
               xmlelement("forloop",XMLCData(l.forloop)),
               xmlelement("endloop",XMLCData(l.endloop)),
               xmlelement("source",l.source),
               xmlelement("hiddenyn",l.hiddenyn),
               xmlelement("valueid",l.valueid),
               xmlelement("textid",l.textid),
               xmlelement("textcode",XMLCData(l.textcode))
            ))) 
            from rasd_attributes l where k.elementid = l.elementid and k.formid = l.formid )
           ))) from rasd_elements k where k.formid = f.formid )                                       
       ).getclobval() into v_xmldata
from rasd_forms f where formid = rf.formid; 

  declare
     v_c clob := v_xmldata; --replace(v_xmldata,'''','''''');
     i number := 1;
     j number := 0;
  begin
    while length(v_c) > 0 and i < 100000 loop
       v_gl := v_gl + 1;
       j := j + 1;
       v_gc(v_gl) := ' v_vc('||j||') := '''||replace(substr(v_c, 1 , 2400),'''','''''')||''';';  
       v_c := substr(v_c, 2401);      
       i := i + 1;    
    end loop;
  end;
  
end;

--if v_metadata = 0 then
--addcnl('  **/ '); 
end if;


addcnl('     return v_vc;');
addcnl('  end;');      

addcnl('function metadata return clob is');
addcnl('  v_clob clob := '''';');     
addcnl('  v_vc cctab;');
addcnl('  begin');
addcnl('     v_vc := metadata_xml;');
addcnl('     for i in 1..v_vc.count loop');
addcnl('       v_clob := v_clob || v_vc(i);');
addcnl('     end loop;');
addcnl('     return v_clob;');
addcnl('  end;');      

addcnl('procedure metadata is');
addcnl('  v_clob clob := '''';');     
addcnl('  v_vc cctab;');
addcnl('  begin');
addcnl('     v_vc := metadata_xml;');
addcnl('     for i in 1..v_vc.count loop');
addcnl('       htp.prn(v_vc(i));');
addcnl('     end loop;');
addcnl('  end;'); 

      /***************************************************************************************/    
      addcnl('end ' || rf.form || ';');

      --generatePLSQL;
    end loop; -- konec forme!!!
  end;
  
  procedure form(p_formid rasd_forms.formid%type,
                 p_lang   rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage) IS
  begin
      form_create( p_formid ,p_lang   );
      generatePLSQL;                             
  end;
  
  function form_source(p_formid rasd_forms.formid%type,
                       p_lang   rasd_fields.fieldid%type default rasdi_client.c_defaultLanguage) return t_vrchrl IS
  begin
      form_create( p_formid ,p_lang   );
      return v_gc;                             
  end;  
  
end;
/

