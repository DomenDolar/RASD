create or replace package RASDC_LINKS is
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

create or replace package body RASDC_LINKS is
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
20202401 - Extened field code to 100chars and value to 500 chars in Links and LOVs     
20190201 . Added #THIS_FORM#  in links.
20180510 - Change on object js_INnameid_LOV added datalist taht you can put fields if form un URL is not recognized.
20180307 - Change in js_INnameid_LOV - LOV iz checking if form is checked for compileYN when we have diferent versions of the same form.    
20170116 - Added possibility to include JAVASCRIPT when using link. Use #GC# to replace generated link code in JavaScript code.
20160627 - Included reference form future. 
20160401 - New order for OUT parameters in LINKS 
20160211 - Solved problem with duplicate linkid   
20151202 - Included session variables in filters    
20150814 - Added superuser    
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20200410225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    ACTION               varchar2(4000);
    PAGE                 varchar2(4000);
    sporocilo            varchar2(4000);
    LANG                 varchar2(4000);
    Plinkid              varchar2(4000);
    PFORMID              varchar2(4000);
    predogled  varchar2(4000);
    BSQLRS               ctab;
    BSQL2INTORS          ctab;
    BSQLINTORS           ctab;
    BSQLINTOrid          rtab;
    BSQL2INTOrid         rtab;
    BSQLrid              rtab;
    BSQL2INTOformid      ntab;
    BSQLINTOformid       ntab;
    BSQLformid           ntab;
    BSQLINTOlinkid       ctab;
    BSQL2INTOlinkid      ctab;
    BSQL2INTOPARAMID     ctab;
    BSQLlinkid           ctab;
    BSQLINTOPARAMID      ctab;
    BSQLlink             ctab;
    BSQLINTOtype         ctab;
    BSQL2INTOtype        ctab;
    BSQLtype             ctab;
    BSQL2INTOorderby     ntab;
    BSQLINTOorderby      ntab;
    BSQLlocation         ctab;
    BSQL2INTOblockid     ctab;
    BSQLTEXT             ctab;
    BSQLINTOblockid      ctab;
    BSQL2INTOfieldid     ctab;
    BSQLsource           ctab;
    BSQLINTOfieldid      ctab;
    BSQL2INTOnameCID     ctab;
    BSQLINTOnameCID      ctab;
    BSQL2INTOcode        ctab;
    BSQLINTOcode         ctab;
    BSQL2INTOvalue       ctab;
    BSQLINTOvalue        ctab;
    BSQL2INTOBLOKfieldid ctab;
    BSQLhiddenyn         ctab;
    BSQLINTOBLOKfieldid  ctab;
    BSQLrform  ctab;
    BSQLintorform  ctab;
    BSQL2intorform  ctab;
     unlink   varchar2(4000);
        
procedure on_session is
    i__ pls_integer := 1;
  begin
  if ACTION is not null then
begin
 rasdi_client.sessionStart;
rasdi_client.sessionSetValue(to_char(pformid)||'PLINKID', PLINKID ); 
 rasdi_client.sessionClose;
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
if PLINKID is null then vc := rasdi_client.sessionGetValue(to_char(pformid)||'PLINKID'); PLINKID  := vc;  end if; 
exception when others then  null; end;  end if;
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
        elsif upper(name_array(i__)) = upper('PAGE') then
          PAGE := value_array(i__);
        elsif upper(name_array(i__)) = upper('SPOROCILO') then
          sporocilo := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('Plinkid') then
          Plinkid := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLRS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLRS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHERERS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTORS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTORS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTORS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTORID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOrid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLWHERERID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOrid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLRID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLrid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREformid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOformid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLINTOformid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOformid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLformid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLINTOlinkid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOlinkid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHERElinkid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOlinkid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREPARAMID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOPARAMID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLlinkid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLlinkid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOPARAMID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOPARAMID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLlink_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLlink(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOtype_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOtype(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREtype_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOtype(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLtype_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLtype(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREorderby_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOorderby(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLINTOorderby_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOorderby(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('BSQLlocation_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLlocation(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREblockid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOblockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLTEXT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLTEXT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOblockid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOblockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREfieldid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOfieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLsource(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOfieldid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOfieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREnameCID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOnameCID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOnameCID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOnameCID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREcode_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOcode(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOcode_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOcode(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREvalue_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOvalue(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOvalue_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOvalue(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLWHEREBLOKfieldid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQL2INTOBLOKfieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLhiddenyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('BSQLINTOBLOKfieldid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          BSQLINTOBLOKfieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if BSQLRS.count > v_max then
        v_max := BSQLRS.count;
      end if;
      if BSQLrid.count > v_max then
        v_max := BSQLrid.count;
      end if;
      if BSQLformid.count > v_max then
        v_max := BSQLformid.count;
      end if;
      if BSQLlinkid.count > v_max then
        v_max := BSQLlinkid.count;
      end if;
      if BSQLlink.count > v_max then
        v_max := BSQLlink.count;
      end if;
      if BSQLtype.count > v_max then
        v_max := BSQLtype.count;
      end if;
      if BSQLlocation.count > v_max then
        v_max := BSQLlocation.count;
      end if;
      if BSQLTEXT.count > v_max then
        v_max := BSQLTEXT.count;
      end if;
      if BSQLsource.count > v_max then
        v_max := BSQLsource.count;
      end if;
      if BSQLhiddenyn.count > v_max then
        v_max := BSQLhiddenyn.count;
      end if;
      for i__ in 1 .. v_max loop
        if not BSQLRS.exists(i__) then
          BSQLRS(i__) := null;
        end if;
        if not BSQLrid.exists(i__) then
          BSQLrid(i__) := null;
        end if;
        if not BSQLformid.exists(i__) then
          BSQLformid(i__) := to_number(null);
        end if;
        if not BSQLlinkid.exists(i__) then
          BSQLlinkid(i__) := null;
        end if;
        if not BSQLlink.exists(i__) then
          BSQLlink(i__) := null;
        end if;
        if not BSQLtype.exists(i__) then
          BSQLtype(i__) := null;
        end if;
        if not BSQLlocation.exists(i__) then
          BSQLlocation(i__) := null;
        end if;
        if not BSQLTEXT.exists(i__) then
          BSQLTEXT(i__) := null;
        end if;
        if not BSQLsource.exists(i__) then
          BSQLsource(i__) := null;
        end if;
        if not BSQLhiddenyn.exists(i__) then
          BSQLhiddenyn(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if BSQL2INTORS.count > v_max then
        v_max := BSQL2INTORS.count;
      end if;
      if BSQL2INTOrid.count > v_max then
        v_max := BSQL2INTOrid.count;
      end if;
      if BSQL2INTOformid.count > v_max then
        v_max := BSQL2INTOformid.count;
      end if;
      if BSQL2INTOlinkid.count > v_max then
        v_max := BSQL2INTOlinkid.count;
      end if;
      if BSQL2INTOPARAMID.count > v_max then
        v_max := BSQL2INTOPARAMID.count;
      end if;
      if BSQL2INTOtype.count > v_max then
        v_max := BSQL2INTOtype.count;
      end if;
      if BSQL2INTOorderby.count > v_max then
        v_max := BSQL2INTOorderby.count;
      end if;
      if BSQL2INTOblockid.count > v_max then
        v_max := BSQL2INTOblockid.count;
      end if;
      if BSQL2INTOfieldid.count > v_max then
        v_max := BSQL2INTOfieldid.count;
      end if;
      if BSQL2INTOnameCID.count > v_max then
        v_max := BSQL2INTOnameCID.count;
      end if;
      if BSQL2INTOcode.count > v_max then
        v_max := BSQL2INTOcode.count;
      end if;
      if BSQL2INTOvalue.count > v_max then
        v_max := BSQL2INTOvalue.count;
      end if;
      if BSQL2INTOBLOKfieldid.count > v_max then
        v_max := BSQL2INTOBLOKfieldid.count;
      end if;
      for i__ in 1 .. v_max loop
        if not BSQL2INTORS.exists(i__) then
          BSQL2INTORS(i__) := null;
        end if;
        if not BSQL2INTOrid.exists(i__) then
          BSQL2INTOrid(i__) := null;
        end if;
        if not BSQL2INTOformid.exists(i__) then
          BSQL2INTOformid(i__) := to_number(null);
        end if;
        if not BSQL2INTOlinkid.exists(i__) then
          BSQL2INTOlinkid(i__) := null;
        end if;
        if not BSQL2INTOPARAMID.exists(i__) then
          BSQL2INTOPARAMID(i__) := null;
        end if;
        if not BSQL2INTOtype.exists(i__) then
          BSQL2INTOtype(i__) := null;
        end if;
        if not BSQL2INTOorderby.exists(i__) then
          BSQL2INTOorderby(i__) := to_number(null);
        end if;
        if not BSQL2INTOblockid.exists(i__) then
          BSQL2INTOblockid(i__) := null;
        end if;
        if not BSQL2INTOfieldid.exists(i__) then
          BSQL2INTOfieldid(i__) := null;
        end if;
        if not BSQL2INTOnameCID.exists(i__) then
          BSQL2INTOnameCID(i__) := null;
        end if;
        if not BSQL2INTOcode.exists(i__) then
          BSQL2INTOcode(i__) := null;
        end if;
        if not BSQL2INTOvalue.exists(i__) then
          BSQL2INTOvalue(i__) := null;
        end if;
        if not BSQL2INTOBLOKfieldid.exists(i__) then
          BSQL2INTOBLOKfieldid(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if BSQLINTORS.count > v_max then
        v_max := BSQLINTORS.count;
      end if;
      if BSQLINTOrid.count > v_max then
        v_max := BSQLINTOrid.count;
      end if;
      if BSQLINTOformid.count > v_max then
        v_max := BSQLINTOformid.count;
      end if;
      if BSQLINTOlinkid.count > v_max then
        v_max := BSQLINTOlinkid.count;
      end if;
      if BSQLINTOPARAMID.count > v_max then
        v_max := BSQLINTOPARAMID.count;
      end if;
      if BSQLINTOtype.count > v_max then
        v_max := BSQLINTOtype.count;
      end if;
      if BSQLINTOorderby.count > v_max then
        v_max := BSQLINTOorderby.count;
      end if;
      if BSQLINTOblockid.count > v_max then
        v_max := BSQLINTOblockid.count;
      end if;
      if BSQLINTOfieldid.count > v_max then
        v_max := BSQLINTOfieldid.count;
      end if;
      if BSQLINTOnameCID.count > v_max then
        v_max := BSQLINTOnameCID.count;
      end if;
      if BSQLINTOcode.count > v_max then
        v_max := BSQLINTOcode.count;
      end if;
      if BSQLINTOvalue.count > v_max then
        v_max := BSQLINTOvalue.count;
      end if;
      if BSQLINTOBLOKfieldid.count > v_max then
        v_max := BSQLINTOBLOKfieldid.count;
      end if;
      for i__ in 1 .. v_max loop
        if not BSQLINTORS.exists(i__) then
          BSQLINTORS(i__) := null;
        end if;
        if not BSQLINTOrid.exists(i__) then
          BSQLINTOrid(i__) := null;
        end if;
        if not BSQLINTOformid.exists(i__) then
          BSQLINTOformid(i__) := to_number(null);
        end if;
        if not BSQLINTOlinkid.exists(i__) then
          BSQLINTOlinkid(i__) := null;
        end if;
        if not BSQLINTOPARAMID.exists(i__) then
          BSQLINTOPARAMID(i__) := null;
        end if;
        if not BSQLINTOtype.exists(i__) then
          BSQLINTOtype(i__) := null;
        end if;
        if not BSQLINTOorderby.exists(i__) then
          BSQLINTOorderby(i__) := to_number(null);
        end if;
        if not BSQLINTOblockid.exists(i__) then
          BSQLINTOblockid(i__) := null;
        end if;
        if not BSQLINTOfieldid.exists(i__) then
          BSQLINTOfieldid(i__) := null;
        end if;
        if not BSQLINTOnameCID.exists(i__) then
          BSQLINTOnameCID(i__) := null;
        end if;
        if not BSQLINTOcode.exists(i__) then
          BSQLINTOcode(i__) := null;
        end if;
        if not BSQLINTOvalue.exists(i__) then
          BSQLINTOvalue(i__) := null;
        end if;
        if not BSQLINTOBLOKfieldid.exists(i__) then
          BSQLINTOBLOKfieldid(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
            if action is null then action := RASDI_TRNSLT.text('Search', lang); end if;

      --<POST_SUBMIT formid="50006" blockid="">
      declare
        v_type RASD_LINKS.type%type;
      begin
        if plinkid is null then

          select linkid
            into plinkid
            from RASD_LINKS t
           where t.formid = PFORMID
             and rownum = 1
           order by linkid;

        end if;

        if plinkid is not null then

          select type
            into v_type
            from RASD_LINKS t
           where t.formid = PFORMID
             and upper(t.linkid) = upper(plinkid);

          if v_type in ('C', 'F') then
            page := 1;
          elsif v_type in ('T') then
            page := 2;
          elsif v_type in ('S', 'U') then
            page := 3;
          end if;
        else
          page := 3;
        end if;
      exception
        when others then
          if action <> RASDI_TRNSLT.text('Save', lang) then
            action := RASDI_TRNSLT.text('New', lang);
          end if;
          page := 3;
      end;
      if action = RASDI_TRNSLT.text('New', lang) then
        page    := 3;
        plinkid := null;
      end if;
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
    procedure pclear_BSQL(pstart number) is
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
        BSQLRS(j__) := null;
        BSQLrid(j__) := null;
        BSQLformid(j__) := null;
        BSQLlinkid(j__) := null;
        BSQLlink(j__) := null;
        BSQLtype(j__) := null;
        BSQLlocation(j__) := null;
        BSQLTEXT(j__) := null;
        BSQLsource(j__) := null;
        BSQLhiddenyn(j__) := null;
        BSQLrform(j__) := null;      
        BSQLRS(j__) := 'I';

      end loop;
    end;
    procedure pclear_BSQLINTO(pstart number) is
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
        BSQLINTORS(j__) := null;
        BSQLINTOrid(j__) := null;
        BSQLINTOformid(j__) := null;
        BSQLINTOlinkid(j__) := null;
        BSQLINTOPARAMID(j__) := null;
        BSQLINTOtype(j__) := null;
        BSQLINTOorderby(j__) := null;
        BSQLINTOblockid(j__) := null;
        BSQLINTOfieldid(j__) := null;
        BSQLINTOnameCID(j__) := null;
        BSQLINTOcode(j__) := null;
        BSQLINTOvalue(j__) := null;
        BSQLINTOBLOKfieldid(j__) := null;
        BSQLINTOrform(j__) := null;       
        BSQLINTORS(j__) := 'I';

      end loop;
    end;
    procedure pclear_BSQL2INTO(pstart number) is
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
        BSQL2INTORS(j__) := null;
        BSQL2INTOrid(j__) := null;
        BSQL2INTOformid(j__) := null;
        BSQL2INTOlinkid(j__) := null;
        BSQL2INTOPARAMID(j__) := null;
        BSQL2INTOtype(j__) := null;
        BSQL2INTOorderby(j__) := null;
        BSQL2INTOblockid(j__) := null;
        BSQL2INTOfieldid(j__) := null;
        BSQL2INTOnameCID(j__) := null;
        BSQL2INTOcode(j__) := null;
        BSQL2INTOvalue(j__) := null;
        BSQL2INTOBLOKfieldid(j__) := null;
        BSQL2INTOrform(j__) := null;
        BSQL2INTORS(j__) := 'I';

      end loop;
    end;
    procedure pclear_form is
    begin
      ACTION    := null;
      PAGE      := null;
      sporocilo := null;
      LANG      := null;
      Plinkid   := null;
      PFORMID   := null;
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_BSQL(0);
      pclear_BSQLINTO(0);
      pclear_BSQL2INTO(0);
      null;
    end;
    procedure pselect_BSQL is
      i__ pls_integer;
    begin
      BSQLRS.delete;
      BSQLrid.delete;
      BSQLformid.delete;
      BSQLlinkid.delete;
      BSQLlink.delete;
      BSQLtype.delete;
      BSQLlocation.delete;
      BSQLTEXT.delete;
      BSQLsource.delete;
      BSQLhiddenyn.delete;
      BSQLrform.delete;
      --<pre_select formid="50006" blockid="BSQL">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="50006" blockid="BSQL">
          SELECT ROWID rid, linkid, link, type, location, TEXT, source, rform
            FROM RASD_LINKS
           where formid = PFORMID
             and linkid = plinkid
          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO BSQLrid(i__),
                 BSQLlinkid(i__),
                 BSQLlink(i__),
                 BSQLtype(i__),
                 BSQLlocation(i__),
                 BSQLTEXT(i__),
                 BSQLsource(i__),
                 bsqlrform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            BSQLRS(i__) := null;
            BSQLformid(i__) := null;
            BSQLhiddenyn(i__) := null;
            BSQLRS(i__) := 'U';

            --<post_select formid="50006" blockid="BSQL">
            BSQLlinkid(i__) := upper(BSQLlink(i__));
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          BSQLRS.delete(1);
          BSQLrid.delete(1);
          BSQLformid.delete(1);
          BSQLlinkid.delete(1);
          BSQLlink.delete(1);
          BSQLtype.delete(1);
          BSQLlocation.delete(1);
          BSQLTEXT.delete(1);
          BSQLsource.delete(1);
          BSQLhiddenyn.delete(1);
          bsqlrform.delete(1);

          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_BSQL(BSQLrid.count);
      null;
    end;
    procedure pselect_BSQLINTO is
      i__ pls_integer;
    begin
      BSQLINTORS.delete;
      BSQLINTOrid.delete;
      BSQLINTOformid.delete;
      BSQLINTOlinkid.delete;
      BSQLINTOPARAMID.delete;
      BSQLINTOtype.delete;
      BSQLINTOorderby.delete;
      BSQLINTOblockid.delete;
      BSQLINTOfieldid.delete;
      BSQLINTOnameCID.delete;
      BSQLINTOcode.delete;
      BSQLINTOvalue.delete;
      BSQLINTOBLOKfieldid.delete;
      bsqlintorform.delete;
      
      --<pre_select formid="50006" blockid="BSQLINTO">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select pp.rowid rid,
                 pp.orderby,
                 pp.blockid,
                 pp.fieldid,
                 pp.namecid,
                 pp.code,
                 pp.value, pp.rform
            from RASD_LINK_PARAMS PP, RASD_LINKS p
           where p.formid = PFORMID
             and p.linkid = plinkid
             and p.formid = pp.formid
             and p.linkid = pp.linkid
             and ((upper(p.type) = 'C' and upper(pp.type) = 'TRUE') or
                 (upper(p.type) = 'F' and upper(pp.type) = 'OUT') or
                 (upper(p.type) = 'T' and upper(pp.type) = 'TEXT'))
           order by decode(upper(pp.type) , 'OUT', 1 ,orderby), blockid , fieldid , value;
        i__ := 1;
        LOOP
          FETCH c__
            INTO BSQLINTOrid(i__),
                 BSQLINTOorderby(i__),
                 BSQLINTOblockid(i__),
                 BSQLINTOfieldid(i__),
                 BSQLINTOnameCID(i__),
                 BSQLINTOcode(i__),
                 BSQLINTOvalue(i__),
                 bsqlintorform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            BSQLINTORS(i__) := null;
            BSQLINTOformid(i__) := null;
            BSQLINTOlinkid(i__) := null;
            BSQLINTOPARAMID(i__) := null;
            BSQLINTOtype(i__) := null;
            BSQLINTOBLOKfieldid(i__) := null;
            BSQLINTORS(i__) := 'U';

            --<post_select formid="50006" blockid="BSQLINTO">
            bsqlintoblokfieldid(i__) := bsqlintoblockid(i__) || '/.../' ||
                                        bsqlintofieldid(i__);
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          BSQLINTORS.delete(1);
          BSQLINTOrid.delete(1);
          BSQLINTOformid.delete(1);
          BSQLINTOlinkid.delete(1);
          BSQLINTOPARAMID.delete(1);
          BSQLINTOtype.delete(1);
          BSQLINTOorderby.delete(1);
          BSQLINTOblockid.delete(1);
          BSQLINTOfieldid.delete(1);
          BSQLINTOnameCID.delete(1);
          BSQLINTOcode.delete(1);
          BSQLINTOvalue.delete(1);
          BSQLINTOBLOKfieldid.delete(1);
          BSQLINTOrform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_BSQLINTO(BSQLINTOrid.count);
      null;
    end;
    procedure pselect_BSQL2INTO is
      i__ pls_integer;
    begin
      BSQL2INTORS.delete;
      BSQL2INTOrid.delete;
      BSQL2INTOformid.delete;
      BSQL2INTOlinkid.delete;
      BSQL2INTOPARAMID.delete;
      BSQL2INTOtype.delete;
      BSQL2INTOorderby.delete;
      BSQL2INTOblockid.delete;
      BSQL2INTOfieldid.delete;
      BSQL2INTOnameCID.delete;
      BSQL2INTOcode.delete;
      BSQL2INTOvalue.delete;
      BSQL2INTOBLOKfieldid.delete;
      BSQL2INTOrform.delete;
      --<pre_select formid="50006" blockid="BSQL2INTO">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select pp.rowid rid,
                 pp.orderby,
                 pp.blockid,
                 pp.fieldid,
                 pp.namecid,
                 pp.code,
                 pp.value, pp.rform
            from RASD_LINK_PARAMS PP, RASD_LINKS p
           where p.formid = PFORMID
             and p.linkid = plinkid
             and p.formid = pp.formid
             and p.linkid = pp.linkid
             and ((upper(p.type) = 'C' and upper(pp.type) = 'FALSE') or
                 (upper(p.type) = 'F' and upper(pp.type) = 'IN'))
           order by orderby, blockid, fieldid;
        i__ := 1;
        LOOP
          FETCH c__
            INTO BSQL2INTOrid(i__),
                 BSQL2INTOorderby(i__),
                 BSQL2INTOblockid(i__),
                 BSQL2INTOfieldid(i__),
                 BSQL2INTOnameCID(i__),
                 BSQL2INTOcode(i__),
                 BSQL2INTOvalue(i__),
                 BSQL2INTOrform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            BSQL2INTORS(i__) := null;
            BSQL2INTOformid(i__) := null;
            BSQL2INTOlinkid(i__) := null;
            BSQL2INTOPARAMID(i__) := null;
            BSQL2INTOtype(i__) := null;
            BSQL2INTOBLOKfieldid(i__) := null;
            BSQL2INTORS(i__) := 'U';

            --<post_select formid="50006" blockid="BSQL2INTO">
            bsql2intoblokfieldid(i__) := bsql2intoblockid(i__) || '/.../' ||
                                         bsql2intofieldid(i__);
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          BSQL2INTORS.delete(1);
          BSQL2INTOrid.delete(1);
          BSQL2INTOformid.delete(1);
          BSQL2INTOlinkid.delete(1);
          BSQL2INTOPARAMID.delete(1);
          BSQL2INTOtype.delete(1);
          BSQL2INTOorderby.delete(1);
          BSQL2INTOblockid.delete(1);
          BSQL2INTOfieldid.delete(1);
          BSQL2INTOnameCID.delete(1);
          BSQL2INTOcode.delete(1);
          BSQL2INTOvalue.delete(1);
          BSQL2INTOBLOKfieldid.delete(1);
          BSQL2INTOrform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_BSQL2INTO(BSQL2INTOrid.count);
      null;
    end;
    procedure pselect is
    begin
      if nvl(PAGE, 0) = 1 or nvl(PAGE, 0) = 2 or nvl(PAGE, 0) = 3 then
        pselect_BSQL;
      end if;
      if nvl(PAGE, 0) = 1 or nvl(PAGE, 0) = 2 then
        pselect_BSQLINTO;
      end if;
      if nvl(PAGE, 0) = 1 then
        pselect_BSQL2INTO;
      end if;
      null;
    end;
    procedure pcommit_BSQL is
      x number; 
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. BSQLRS.count loop
        --<on_validate formid="50006" blockid="BSQL">
        --</on_validate>
        if substr(BSQLRS(i__), 1, 1) = 'I' then
          --INSERT
          if BSQLlinkid(i__) is not null or BSQLlink(i__) is not null or
             BSQLtype(i__) is not null or BSQLlocation(i__) is not null or
             BSQLTEXT(i__) is not null then
            --<pre_insert formid="50006" blockid="BSQL">
            bsqlformid(i__) := PFORMID;
            bsqlsource(i__) := 'V';
            if bsqltype(i__) = 'S' then
              bsqltext(i__) := RASDI_TRNSLT.text('select ''Code or Id stored in DB'' id, ''Description shown insted of code'' label from dual',
                                                 lang);
            end if;
            select decode(BSQLtype(i__),'F','link$','U','link$','lov$')||rasdc_library.prepareName(BSQLlinkid(i__)) into
            BSQLlinkid(i__) from dual;
            --</pre_insert>
            
            if  BSQLtype(i__) in ('F','U') and BSQLlocation(i__) is null then
                BSQLlocation(i__) := 'I';
            end if;
            
            select count(*) into x from RASD_LINKS where formid = BSQLformid(i__) and linkid = BSQLlinkid(i__); 
            
            BSQLTEXT(i__) := trim(BSQLTEXT(i__));
            
            if x = 0 then
            
            insert into RASD_LINKS
              (formid, linkid, link, type, location, TEXT, source)
            values
              (BSQLformid(i__),
               BSQLlinkid(i__),
               upper(BSQLlink(i__)),
               BSQLtype(i__),
               BSQLlocation(i__),
               BSQLTEXT(i__),
               BSQLsource(i__));
               
            end if;
               
            --<post_insert formid="50006" blockid="BSQL">
            plinkid := bsqllinkid(i__);
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if BSQLlink(i__) is null then
            --DELETE
            --<pre_delete formid="50006" blockid="BSQL">
            declare
              v_linkid RASD_LINKS.linkid%type;
            begin
              select linkid
                into v_linkid
                from RASD_LINKS
               where rowid = bsqlrid(i__) and rform is null;

              RASDC_LIBRARY.deleteLink(PFORMID, v_linkid);
            exception when others then null;  
            end;
            --</pre_delete>
            delete RASD_LINKS where ROWID = BSQLrid(i__) and rform is null;
            --<post_delete formid="50006" blockid="BSQL">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="50006" blockid="BSQL">
            bsqlsource(i__) := 'V';
            --</pre_update>
            update RASD_LINKS
               set link     = BSQLlink(i__),
                   location = BSQLlocation(i__),
                   TEXT     = BSQLTEXT(i__),
                   rform  = decode (unlink,'Y',null,rform)
             where ROWID = BSQLrid(i__) and (rform is null or unlink = 'Y');
            --<post_update formid="50006" blockid="BSQL">
            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit_BSQLINTO is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. BSQLINTORS.count loop
        --<on_validate formid="50006" blockid="BSQLINTO">
        --</on_validate>
        if substr(BSQLINTORS(i__), 1, 1) = 'I' then
          --INSERT
          if BSQLINTOorderby(i__) is not null or
             BSQLINTOnameCID(i__) is not null or
             BSQLINTOcode(i__) is not null or
             BSQLINTOvalue(i__) is not null or
             BSQLINTOBLOKfieldid(i__) is not null then
            --<pre_insert formid="50006" blockid="BSQLINTO">
            bsqlintoformid(i__) := PFORMID;
            bsqlintolinkid(i__) := plinkid;
            bsqlintoblockid(i__) := substr(bsqlintoblokfieldid(i__),
                                           1,
                                           instr(bsqlintoblokfieldid(i__),
                                                 '/.../') - 1);
            bsqlintofieldid(i__) := substr(bsqlintoblokfieldid(i__),
                                           instr(bsqlintoblokfieldid(i__),
                                                 '/.../') + 5);

            if bsqltype(1) = 'C' then
              bsqlintoorderby(i__) := 1;
              bsqlintotype(i__) := 'TRUE';
              bsqlintoPARAMID(i__) := 'TRUE';
            elsif bsqltype(1) = 'F' then
              select nvl(max(orderby), 0) + 1
                into bsqlintoorderby(i__)
                from RASD_LINK_PARAMS
               where formid = PFORMID
                 and linkid = plinkid
                 and type = 'OUT';
              bsqlintoorderby(i__) := 1;
              bsqlintotype(i__) := 'OUT';
              bsqlintoPARAMID(i__) := bsqlintoblockid(i__) ||
                                      bsqlintofieldid(i__) ||
                                      bsqlintoorderby(i__);
            elsif bsqltype(1) = 'T' then
              bsqlintotype(i__) := 'TEXT';
              bsqlintoPARAMID(i__) := 'TEXT' || bsqlintoorderby(i__);
            end if;

            --</pre_insert>
            insert into RASD_LINK_PARAMS
              (formid,
               linkid,
               PARAMID,
               type,
               orderby,
               blockid,
               fieldid,
               nameCID,
               code,
               value)
            values
              (BSQLINTOformid(i__),
               BSQLINTOlinkid(i__),
               BSQLINTOPARAMID(i__),
               BSQLINTOtype(i__),
               BSQLINTOorderby(i__),
               BSQLINTOblockid(i__),
               BSQLINTOfieldid(i__),
               BSQLINTOnameCID(i__),
               BSQLINTOcode(i__),
               BSQLINTOvalue(i__));
            --<post_insert formid="50006" blockid="BSQLINTO">
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if BSQLINTOorderby(i__) is null and BSQLINTOnameCID(i__) is null and
             BSQLINTOcode(i__) is null and BSQLINTOvalue(i__) is null and
             BSQLINTOBLOKfieldid(i__) is null then
            --DELETE
            --<pre_delete formid="50006" blockid="BSQLINTO">
            --</pre_delete>
            delete RASD_LINK_PARAMS where ROWID = BSQLINTOrid(i__) and rform is null;
            --<post_delete formid="50006" blockid="BSQLINTO">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="50006" blockid="BSQLINTO">
            bsqlintoblockid(i__) := substr(bsqlintoblokfieldid(i__),
                                           1,
                                           instr(bsqlintoblokfieldid(i__),
                                                 '/.../') - 1);
            bsqlintofieldid(i__) := substr(bsqlintoblokfieldid(i__),
                                           instr(bsqlintoblokfieldid(i__),
                                                 '/.../') + 5);
            bsqlintoPARAMID(i__) := bsqlintoblockid(i__) ||
                                    bsqlintofieldid(i__);

            if bsqltype(1) = 'C' then
              bsqlintoPARAMID(i__) := 'TRUE';
              bsqlintoorderby(i__) := 1;
            elsif bsqltype(1) = 'F' then
              select nvl(max(orderby), 0) + 1
                into bsqlintoorderby(i__)
                from RASD_LINK_PARAMS
               where formid = PFORMID
                 and linkid = plinkid
                 and type = 'OUT';
              bsqlintoPARAMID(i__) := bsqlintoblockid(i__) ||
                                      bsqlintofieldid(i__) ||
                                      bsqlintoorderby(i__);
            elsif bsqltype(1) = 'T' then
              bsqlintoPARAMID(i__) := 'TEXT' || bsqlintoorderby(i__);
            end if;

            --</pre_update>
            update RASD_LINK_PARAMS
               set PARAMID = BSQLINTOPARAMID(i__),
                   orderby = BSQLINTOorderby(i__),
                   blockid = BSQLINTOblockid(i__),
                   fieldid = BSQLINTOfieldid(i__),
                   nameCID = BSQLINTOnameCID(i__),
                   code    = BSQLINTOcode(i__),
                   value   = BSQLINTOvalue(i__),
                   rform  = decode (unlink,'Y',null,rform)
             where ROWID = BSQLINTOrid(i__) and (rform is null or unlink = 'Y');
             
            --<post_update formid="50006" blockid="BSQLINTO">
            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit_BSQL2INTO is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. BSQL2INTORS.count loop
        --<on_validate formid="50006" blockid="BSQL2INTO">
        --</on_validate>
        if substr(BSQL2INTORS(i__), 1, 1) = 'I' then
          --INSERT
          if BSQL2INTOorderby(i__) is not null or
             BSQL2INTOnameCID(i__) is not null or
             BSQL2INTOcode(i__) is not null or
             BSQL2INTOvalue(i__) is not null or
             BSQL2INTOBLOKfieldid(i__) is not null then
            --<pre_insert formid="50006" blockid="BSQL2INTO">
            bsql2intoformid(i__) := PFORMID;
            bsql2intolinkid(i__) := plinkid;
            bsql2intoblockid(i__) := substr(bsql2intoblokfieldid(i__),
                                            1,
                                            instr(bsql2intoblokfieldid(i__),
                                                  '/.../') - 1);
            bsql2intofieldid(i__) := substr(bsql2intoblokfieldid(i__),
                                            instr(bsql2intoblokfieldid(i__),
                                                  '/.../') + 5);

            if bsqltype(1) = 'C' then
              bsql2intotype(i__) := 'FALSE';
              bsql2intoPARAMID(i__) := 'FALSE';
              bsqlintoorderby(1) := 1;
            elsif bsqltype(1) = 'F' then
              bsql2intotype(i__) := 'IN';
              bsql2intoPARAMID(i__) := bsql2intoblockid(i__) ||
                                       bsql2intofieldid(i__) ||
                                       bsql2intoorderby(i__);
            end if;

            --</pre_insert>
            insert into RASD_LINK_PARAMS
              (formid,
               linkid,
               PARAMID,
               type,
               orderby,
               blockid,
               fieldid,
               nameCID,
               code,
               value)
            values
              (BSQL2INTOformid(i__),
               BSQL2INTOlinkid(i__),
               BSQL2INTOPARAMID(i__),
               BSQL2INTOtype(i__),
               BSQL2INTOorderby(i__),
               BSQL2INTOblockid(i__),
               BSQL2INTOfieldid(i__),
               BSQL2INTOnameCID(i__),
               BSQL2INTOcode(i__),
               BSQL2INTOvalue(i__));
            --<post_insert formid="50006" blockid="BSQL2INTO">
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if BSQL2INTOorderby(i__) is null and
             BSQL2INTOnameCID(i__) is null and BSQL2INTOcode(i__) is null and
             BSQL2INTOvalue(i__) is null and
             BSQL2INTOBLOKfieldid(i__) is null then
            --DELETE
            --<pre_delete formid="50006" blockid="BSQL2INTO">
            --</pre_delete>
            delete RASD_LINK_PARAMS where ROWID = BSQL2INTOrid(i__) and rform is null;
            --<post_delete formid="50006" blockid="BSQL2INTO">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="50006" blockid="BSQL2INTO">
            bsql2intoblockid(i__) := substr(bsql2intoblokfieldid(i__),
                                            1,
                                            instr(bsql2intoblokfieldid(i__),
                                                  '/.../') - 1);
            bsql2intofieldid(i__) := substr(bsql2intoblokfieldid(i__),
                                            instr(bsql2intoblokfieldid(i__),
                                                  '/.../') + 5);
            bsql2intoPARAMID(i__) := bsql2intoblockid(i__) ||
                                     bsql2intofieldid(i__);

            if bsqltype(1) = 'C' then
              bsqlintoorderby(1) := 1;
              bsql2intoPARAMID(i__) := 'FALSE';
            elsif bsqltype(1) = 'F' then
              bsql2intoPARAMID(i__) := bsql2intoblockid(i__) ||
                                       bsql2intofieldid(i__) ||
                                       bsql2intoorderby(i__);
            end if;

            --</pre_update>
            update RASD_LINK_PARAMS
               set PARAMID = BSQL2INTOPARAMID(i__),
                   orderby = BSQL2INTOorderby(i__),
                   blockid = BSQL2INTOblockid(i__),
                   fieldid = BSQL2INTOfieldid(i__),
                   nameCID = BSQL2INTOnameCID(i__),
                   code    = BSQL2INTOcode(i__),
                   value   = BSQL2INTOvalue(i__),
                   rform  = decode (unlink,'Y',null,rform)
             where ROWID = BSQL2INTOrid(i__) and (rform is null or unlink = 'Y');
             
            --<post_update formid="50006" blockid="BSQL2INTO">
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
      --<pre_commit formid="50006" blockid="">
      --</pre_commit>
      if nvl(PAGE, 0) = 1 or nvl(PAGE, 0) = 2 or nvl(PAGE, 0) = 3 then
        pcommit_BSQL;
      end if;
      if nvl(PAGE, 0) = 1 or nvl(PAGE, 0) = 2 then
        pcommit_BSQLINTO;
      end if;
      if nvl(PAGE, 0) = 1 then
        pcommit_BSQL2INTO;
      end if;
      --<post_commit formid="50006" blockid="">
      -- ?e gre za vra?anje parametrov je potrebno formi postredovati name skripte
      -- kjer so podatki za vra?anje nazaj na formo!!!
      --IN
      declare
        n     number;
        v_vrx varchar2(15);
      begin
        select count(*)
          into n
          from RASD_LINKS gp, RASD_LINK_PARAMS gpp
         where gpp.linkid = plinkid
           and gpp.formid = PFORMID
           and gpp.type = 'IN'
           and gp.linkid = gpp.linkid
           and gp.formid = gpp.formid
           and nvl(gp.location, 'I') = 'N';
        if n > 0 then
          --vracanje nazaj-> vnos nove spremenljivke
          select count(*)
            into n
            from RASD_LINK_PARAMS gpp
           where gpp.linkid = plinkid
             and gpp.formid = PFORMID
             and gpp.type = 'OUT'
             and (gpp.namecid = rasd_engine10.c_fin or
                 gpp.value like rasd_engine10.c_fin || '=%');
          if n = 0 then
            insert into RASD_LINK_PARAMS
              (linkid, PARAMID, type, orderby, formid, namecid, value)
            values
              (plinkid,
               rasd_engine10.c_fin,
               'OUT',
               0,
               PFORMID,
               '',
               rasd_engine10.c_fin || '=opener.js_' || plinkid ||
               '(\''''''||name||''\'''',this.document)');
          end if;
        end if;
      exception
        when others then
          null;
      end;
      commit;

      --</post_commit>
      null;
    end;
    procedure phtml is
      iBSQLINTO  pls_integer;
      iBSQL2INTO pls_integer;
      --povezavein
      procedure js_PROGRAMI_LOV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'BSQLTEXT%' then
          htp.prn('''!RASDC_LOV.program?FIN=opener.js_PROGRAMI_LOV(\''' || name ||
                  '\'',this.document)&LANG=''+document.RASDC_LINKS.LANG.value+
''''');
        elsif name is null then
          htp.prn('''!RASDC_LOV.program?FIN=opener.js_PROGRAMI_LOV(\''' || name ||
                  '\'',this.document)&LANG=''+document.RASDC_LINKS.LANG.value+
''''');
        end if;
      end;
      --SQL
      procedure js_INnameid_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_INnameid_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_INTOBLOKIPOLJA_LOV(value varchar2,
                                      name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_INTOBLOKIPOLJA_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_POVEZAVE_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_POVEZAVE_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      --TEXT
      procedure js_IZPIS_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_IZPIS_LOV(''' || name || ''',''' || value || ''')');
        htp.p('</SCRIPT>');
      end;
      --TF
      --SQL-T
    begin
      --js povezavein
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_PROGRAMI_LOV(p,w) {');
      htp.p('  var i = 0;');
      htp.p('  var pi;');
      htp.p('  if (p.indexOf(''_'') == -1) pi = '''';');
      htp.p('  else pi = p.substring(p.indexOf(''_''));');
      htp.p('  while(i < document.RASDC_LINKS.elements.length){');
      htp.p('    if (document.RASDC_LINKS.elements[i].name == ''BSQLTEXT''+pi) {');
      htp.p('     document.RASDC_LINKS.elements[i].value = w.F_LOVPROG.REZULTAT.value;}');
      htp.p('    i++;');
      htp.p('  }');
      htp.p('}');
      htp.p('</SCRIPT>');
      --js SQL
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_INnameid_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="50006" linkid="INnameid_LOV">
                  select '' id, '' label, 1 x, '' b, to_number(null) v
                    from dual
                  union
                  select pr.nameid id,
                          pr.nameid label,
                          2 x,
                          nvl(pr.blockid, chr(0)) b,
                          orderby v
                    from RASD_FIELDS pr,
                          (select max(f.formid) formid
                             from RASD_LINKS          p,
                                  RASD_FORMS          f,
                                  (
select fc.* from RASD_FORMS_COMPILED fc, rasd_forms f
where nvl(fc.compileyn , 'N') = 'Y'
and fc.formid = f.formid
union 
select fc.* from RASD_FORMS_COMPILED fc, rasd_forms f
where nvl(fc.compileyn , 'N') = 'N'
and fc.formid = f.formid
and f.form not in (
select f1.form from RASD_FORMS_COMPILED fc1, rasd_forms f1
where nvl(fc1.compileyn , 'N') = 'Y'
and fc1.formid = f1.formid
)                                                                    
                                  ) fg
                            where p.type = 'F'
                              and (upper(f.form) =
                                  upper(substr(substr(p.text,
                                                       instr(p.text, '!') + 1),
                                                1,
                                                instr(substr(upper(p.text),
                                                             instr(p.text, '!') + 1),
                                                      '.WEBCLIENT') - 1)) or
                                  upper(f.form) =
                                  upper(substr(substr(p.text,
                                                       instr(p.text, '!') + 1),
                                                1,
                                                instr(substr(upper(p.text),
                                                             instr(p.text, '!') + 1),
                                                      '.OPENLOV') - 1)))
                              and f.formid = fg.formid
                              and fg.lobid = rasdi_client.secGetLOB
                              and fg.editor = rasdi_client.secGetUsername
                              and p.formid = PFORMID
                              and p.linkid = plinkid
                            order by f.version) fx
                   where fx.formid = pr.formid
                     and pr.nameid is not null
                     and pr.element not in ('FONT_','FONT_RADIO','A_' ,'IMG_','PLSQL_')
                   order by 3, 4, 5
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_INTOBLOKIPOLJA_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="50006" linkid="INTOBLOKIPOLJA_LOV">
                  select '' id, '' label, 1, ''
                    from dual
                  union
                  select '/.../THIS' || '' id, 'THIS' || '' label, 2, ''
                    from dual
                  union
                  select '/.../#JSLINK#' || '' id, 'JAVASCRIPT' || '' label, 3, ''
                    from dual
                  union
                  select t.blockid || '/.../' || t.fieldid id,
                          decode(t.blockid, null, '', t.blockid || ' ') ||
                          t.fieldid label,
                          4,
                          decode(blockid, null, chr(0), blockid)
                    from RASD_FIELDS t
                   where t.formid = PFORMID
                   order by 3, 4, 1
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_POVEZAVE_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="50006" linkid="POVEZAVE_LOV">
                  select linkid id, link || ' ('||linkid||'-'|| type || ')' label
                    from RASD_LINKS t
                   where t.formid = PFORMID
                   order by 1
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
      htp.p('function js_IZPIS_LOV(pname, pvalue) {');
      htp.p('  document.write(''<input type="radio" CLASS=radio name="''+pname+''" ''+ ((pvalue==''I'')?'' checked '':'''') +'' value="I">' ||
            RASDI_TRNSLT.text('current window ', lang) || ''')');
      htp.p('  document.write(''<input type="radio" CLASS=radio name="''+pname+''" ''+ ((pvalue==''N'')?'' checked '':'''') +'' value="N">' ||
            RASDI_TRNSLT.text('new window', lang) || ''')');
      htp.p('}');
      htp.p('</SCRIPT>');
      --js TF
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'

');
      if BSQLtype(1) in ('F', 'S', 'U') then
        htp.prn('
        
<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTW(document.RASDC_LINKS.BSQLTEXT_1);
}
</SCRIPT>
');
      else
        /**/
        htp.prn('
<SCRIPT LANGUAGE="Javascript1.2">
function onResize() { }
</SCRIPT>
');
      end if; /**/
      htp.prn('
<SCRIPT LANGUAGE="Javascript1.2">
 $(function() {
     addSpinner();   
  }); 
</SCRIPT>
      
<SCRIPT LANGUAGE="Javascript1.2">
function onLoad() {
  onResize();
}
</SCRIPT>
<SCRIPT LANGUAGE="Javascript1.2">
function js_kliksubmit() {
  
  document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              ''';
  document.RASDC_LINKS.submit();
}
</SCRIPT>
</HEAD>
<BODY onload="onLoad();" onresize="onResize();">
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_LINKS_LAB">');
      RASDC_LIBRARY.showHead('RASDC_LINKS',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
      htp.prn('</FONT>
<FORM NAME="RASDC_LINKS" METHOD="post" ACTION="!rasdc_links.program">
<INPUT NAME="LANG" TYPE="hidden" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="hidden" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<P align="right">
<INPUT  type="hidden" name="ACTION" id="ACTION">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_LINKS.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_LINKS.submit(); this.disabled = true; ">
');
end if;
htp.p('
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) ||
              '" name="ACTION">
' || predogled || '
</P>
');
      if ACTION <> RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<SELECT NAME="Plinkid" CLASS="SELECT" onchange="js_kliksubmit();">');
        js_POVEZAVE_LOV(Plinkid, 'Plinkid');
        htp.prn('</SELECT>
<IMG onclick="js_kliksubmit();" title="' ||
                RASDI_TRNSLT.text('Search', lang) ||
                '""  src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0">
<img src="rasdc_files.showfile?pfile=pict/gumbnov.jpg" border="0" title="' ||
                RASDI_TRNSLT.text('New LOV-link', lang) ||
                '"onClick="location=''!rasdc_links.program?ACTION=' ||
                RASDI_TRNSLT.text('New', lang) || '&LANG=' || lang ||
                '&PFORMID=' || PFORMID ||
                '''"">
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                RASDI_TRNSLT.text('Delete LOV-link', lang) || '"
onClick="document.RASDC_LINKS.BSQLlink_1.value=''''; document.rasdc_links.plinkid.value='''';">
');
        rasdc_hints.link('RASDC_LINKS', lang);
        htp.prn('
');
      end if;
      htp.prn('
<BR>
<TABLE BORDER="0" width="100%" style="');

              if bsqlrform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;
htp.prn('">
<CAPTION><FONT ID="BSQL_LAB"></FONT></CAPTION><TR>
');
      if ACTION = RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<TD class="label" align="center">' ||
                RASDI_TRNSLT.text('Type', lang) ||
                '</TD>
<TD class="label" align="center">' ||
                RASDI_TRNSLT.text('Link', lang) || '</TD>
');
      end if;
      htp.prn('
<TD class="label" align="center" width="10%"><FONT ID="BSQLlink_LAB">' ||
              RASDI_TRNSLT.text('Link description', lang) ||
              '</FONT></TD>
<TD><FONT ID="BSQLlocation_LAB"></FONT></TD>
<TD><FONT ID="BSQLTEXT_LAB"></FONT></TD></TR><TR ID="BSQL_BLOK"></TR><INPUT NAME="BSQLRS_1" TYPE="hidden" VALUE="' ||
              BSQLRS(1) ||
              '" CLASS="HIDDEN"><INPUT NAME="BSQLRID_1" TYPE="hidden" VALUE="' ||
              BSQLrid(1) || '" CLASS="HIDDEN">
');
      if ACTION = RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<TD>
<INPUT type="radio" value="S" name="BSQLtype_1" CLASS="HIDDEN">' ||
                RASDI_TRNSLT.text('LOV SQL(S)', lang) ||
                '<BR>
<INPUT type="radio" value="T" name="BSQLtype_1" CLASS="HIDDEN">' ||
                RASDI_TRNSLT.text('LOV custom(T)', lang) ||
                '<BR>
<INPUT type="radio" value="C" name="BSQLtype_1" CLASS="HIDDEN">' ||
                RASDI_TRNSLT.text('True/False(C)', lang) ||
                '<BR>
<INPUT type="radio" value="F" name="BSQLtype_1" CLASS="HIDDEN">' ||
                RASDI_TRNSLT.text('Link to form(F)', lang) ||
                '<BR>
<INPUT type="radio" value="U" name="BSQLtype_1" CLASS="HIDDEN">' ||
                RASDI_TRNSLT.text('Link custom URL(U)', lang) || '
</TD>
<TD><INPUT NAME="BSQLlinkid_1" VALUE="' || BSQLlinkid(1) ||
                '" CLASS="TEXT" maxLength="30" size="30" TYPE="TEXT"></TD>
');
      else
        htp.prn('
<INPUT NAME="BSQLtype_1" TYPE="hidden" VALUE="' ||
                BSQLtype(1) || '" CLASS="HIDDEN">
');
      end if;
      htp.prn('
<TD><INPUT NAME="BSQLlink_1" type="TEXT" VALUE="' ||
              BSQLlink(1) || '" CLASS="TEXT" maxLength="100" size="50"></TD>
<TD>
');
      if BSQLtype(1) in ('F', 'U') then
        htp.prn( RASDI_TRNSLT.text('Open form in', lang)||'
<FONT ID="BSQLlocation_1" CLASS="RADIO">');
        js_IZPIS_LOV(BSQLlocation(1), 'BSQLlocation_1');
        htp.prn('</FONT>
');
      end if;
      htp.prn('
</TD>
<TD></TD><TR><TD cols colspan="3">
');
      if BSQLtype(1) in ('F', 'U') and
         action <> RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<INPUT type="text" class="TEXTAREA" name="BSQLTEXT_1" rows="5" cols="60" style="FONT-SIZE: 8pt; font-face: Lucida Console" ONDBLCLICK__="javascript: ');
        if BSQLtype(1) in ('F') then
          htp.prn(' var link = window.open(');
          js_PROGRAMI_LOV(BSQLTEXT(1), 'BSQLTEXT_1');
          htp.prn(','''',''width=300,height=600,scrolbars=no''); ');
        end if;
        htp.prn('" value="' || BSQLTEXT(1) || '" />');
        
htp.p('<strong><p style="font-size:12px">Sample: !&lt;form>.webclient; !&lt;form>.webclient?&lt;PAR1>=&lt;VALUE1>...; !&lt;from>.openLOV?PLOV=&lt;LOV name>&FIN=&lt;location back>&PID=&lt;filter>; &lt;URL>?... <BR/>Use #THIS_FORM# when calling current form like !#THIS_FORM#.webclient</p></strong></BR>
');

      elsif BSQLtype(1) in ('S') and
         action <> RASDI_TRNSLT.text('New', lang) then
        htp.prn('
<TEXTAREA class="TEXTAREA" name="BSQLTEXT_1" rows="5" cols="60" style="FONT-SIZE: 8pt; font-face: Lucida Console" ONDBLCLICK__="javascript: ');
        if BSQLtype(1) in ('F') then
          htp.prn(' var link = window.open(');
          js_PROGRAMI_LOV(BSQLTEXT(1), 'BSQLTEXT_1');
          htp.prn(','''',''width=300,height=600,scrolbars=no''); ');
        end if;
        htp.prn('">' || BSQLTEXT(1) || '</TEXTAREA>');
        
htp.p('<p class="label">'||rasdi_trnslt.text('Important! The length result in ID must be less than 100chars and result in LABEL must be less than 500chars!',lang)||'</p>');        
        
      end if;
      htp.prn('
</TD></TR></TABLE>

');
      if PAGE < 3 then
        /**/
        htp.prn('

<TABLE BORDER="1">
<CAPTION>
  <B><FONT ID="BSQLINTO_LAB">
  ');
        if BSQLtype(1) in ('F') then
          htp.prn(RASDI_TRNSLT.text('OUT - Call parameters </br><p style="font-size:12px">Rules: FF && TF && D -> &TF=FF&V; FF && TF -> &TF=FF; TF && D -> TF=D; V -> &V; FF && D -> &replace(D , &lt;FF>_VALUE, FF). Use FF=JAVASCRIPT to override link code - #GC# replaces generarated link code</p>', lang));
        elsif bsqltype(1) in ('C') then
          htp.prn(RASDI_TRNSLT.text('TRUE value', lang));
        elsif bsqltype(1) in ('T') then
          htp.prn(RASDI_TRNSLT.text('LOV values', lang));
        end if;
        htp.prn('
  </FONT></B></CAPTION><TR>
');
        if BSQLtype(1) in ('T') then
          htp.prn('
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Order', lang) || '</TD>
');
        end if;
        if BSQLtype(1) in ('F') then
          htp.prn('
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Current form field - FF </br>(use THIS for current field)', lang) ||
                  '</TD>
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Target field - TF on &lt;form> </br>(&lt;form> must be checked for Compile) ', lang) || '</TD>
');
        end if;

if BSQLtype(1) in ('F','T','C') then
        htp.prn('
<TD class="label" align="center">' ||
                RASDI_TRNSLT.text('Description or Label - Label', lang) || '</TD>
');
end if;
        if BSQLtype(1) in ('T', 'C') then
          htp.prn('
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Code or Id - Id', lang) || '</TD>
');
        end if;
        htp.prn('
<TD class="label" align="center"></TD>
</TR>
');
        for iBSQLINTO in 1 .. BSQLINTORS.count loop
          htp.prn('<TR ID="BSQLINTO_BLOK" onmouseover="javascript:style.backgroundColor=''#E9E9E9''" ');
          
                 if Bsqlintorform(iBSQLINTO) is null then                   
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#ffffff''" bgcolor="#FFFFFF" ');
                 else 
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#aaccf7''" bgcolor="#aaccf7" ');                   
                 end if;           
          
htp.prn(' ><INPUT NAME="BSQLINTORID_' ||
                  iBSQLINTO || '" TYPE="hidden" VALUE="' ||
                  BSQLINTOrid(iBSQLINTO) ||
                  '" CLASS="HIDDEN"><INPUT NAME="BSQLINTORS_' || iBSQLINTO ||
                  '" TYPE="hidden" VALUE="' || BSQLINTORS(iBSQLINTO) || '" CLASS="HIDDEN">
');
          if BSQLtype(1) in ('T') then
            htp.prn('
<TD><INPUT NAME="BSQLINTOorderby_' || iBSQLINTO ||
                    '" VALUE="' || BSQLINTOorderby(iBSQLINTO) || '" CLASS="TEXT" size="2" maxlength="5" TYPE="TEXT"></TD>
');
          end if;
          if BSQLtype(1) in ('F') then
            htp.prn('
<TD><SELECT NAME="BSQLINTOBLOKfieldid_' || iBSQLINTO ||
                    '" CLASS="SELECT">');
            js_INTOBLOKIPOLJA_LOV(BSQLINTOBLOKfieldid(iBSQLINTO),
                                  'BSQLINTOBLOKfieldid_' || iBSQLINTO || '');
/*
            htp.prn('</SELECT></TD>
<TD><SELECT NAME="BSQLINTOnameCID_' || iBSQLINTO ||
                    '" CLASS="SELECT">');
            js_INnameid_LOV(BSQLINTOnameCID(iBSQLINTO),
                            'BSQLINTOnameCID_' || iBSQLINTO || '');
            htp.prn('</SELECT></TD>
');

*/

            htp.prn('</SELECT></TD>
<TD><INPUT NAME="BSQLINTOnameCID_' || iBSQLINTO || '" ID="BSQLINTOnameCID_RASD_' || iBSQLINTO ||
                    '" CLASS="SELECT" list="BSQLINTOnameCID_LOV_RASD_' || iBSQLINTO ||'" value="'||BSQLINTOnameCID(iBSQLINTO)||'"/><datalist id="BSQLINTOnameCID_LOV_RASD_' || iBSQLINTO ||'" >');
            js_INnameid_LOV(BSQLINTOnameCID(iBSQLINTO),
                            'BSQLINTOnameCID_' || iBSQLINTO || '');
            htp.prn('</datalist></TD>
');
          end if;
if BSQLtype(1) in ('F','T','C') then
          htp.prn('
<TD><INPUT NAME="BSQLINTOvalue_' || iBSQLINTO ||
                  '" VALUE="' || BSQLINTOvalue(iBSQLINTO) || '" CLASS="TEXT" size="50" maxlength="500" TYPE="TEXT"></TD>
');
end iF;
          if BSQLtype(1) in ('T', 'C') then
            htp.prn('
<TD><INPUT NAME="BSQLINTOcode_' || iBSQLINTO ||
                    '" VALUE="' || BSQLINTOcode(iBSQLINTO) || '" CLASS="TEXT"  size="20" maxlength="100" TYPE="TEXT"></TD>
');
          end if;
          htp.prn('
<TD>
');
          if BSQLtype(1) in ('T') then
            htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                    RASDI_TRNSLT.text('Delete row', lang) || '"
onClick="document.RASDC_LINKS.BSQLINTOorderby_' ||
                    iBSQLINTO ||
                    '.value=''''; document.RASDC_LINKS.BSQLINTOvalue_' ||
                    iBSQLINTO ||
                    '.value='''';document.RASDC_LINKS.BSQLINTOcode_' ||
                    iBSQLINTO || '.value='''';">
');
          elsif BSQLtype(1) in ('C') then
            htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                    RASDI_TRNSLT.text('Delete row', lang) || '"
onClick="document.RASDC_LINKS.BSQLINTOvalue_' ||
                    iBSQLINTO ||
                    '.value='''';document.RASDC_LINKS.BSQLINTOcode_' ||
                    iBSQLINTO || '.value='''';">
');
          elsif BSQLtype(1) in ('F') then
            htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                    RASDI_TRNSLT.text('Delete row', lang) || '"
onClick="document.RASDC_LINKS.BSQLINTOvalue_' ||
                    iBSQLINTO ||
                    '.value='''';document.RASDC_LINKS.BSQLINTOBLOKfieldid_' ||
                    iBSQLINTO ||
                    '.value='''';document.RASDC_LINKS.BSQLINTOnameCID_' ||
                    iBSQLINTO || '.value='''';">
');
          end if;
          htp.prn('
</td>
</TR>');
        end loop;
        htp.prn('</TABLE>

');
      end if;
      if PAGE < 2 then
        /**/
        htp.prn('
<TABLE BORDER="1">
<CAPTION>
  <B><FONT ID="BSQL2INTO_LAB">');
        if BSQLtype(1) in ('F') then
          htp.prn(RASDI_TRNSLT.text('IN - Input parameters</BR><strong><p style="font-size:12px"></p>', lang));
        elsif bsqltype(1) in ('C') then
          htp.prn(RASDI_TRNSLT.text('FALSE value', lang));
        end if;
        htp.prn('</FONT></B>
  </CAPTION><TR>
');
        if BSQLtype(1) in ('F') then
          htp.prn('
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Order', lang) ||
                  '</TD>
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('From field on &lt;form>', lang) ||
                  '</TD>
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('To field in current form', lang) || '</TD>
');
        end if;
        if BSQLtype(1) in ('C') then
          htp.prn('
<TD  class="label" align="center">' ||
                  RASDI_TRNSLT.text('Description or Label - Label', lang) ||
                  '</TD>
<TD class="label" align="center">' ||
                  RASDI_TRNSLT.text('Code or Id - Id', lang) || '</TD>
');
        end if;
        htp.prn('
<TD class="label" align="center"></TD>
</TR>');
        for iBSQL2INTO in 1 .. BSQL2INTORS.count loop
          htp.prn('<TR ID="BSQL2INTO_BLOK" onmouseover="javascript:style.backgroundColor=''#E9E9E9''" ');
          
                 if Bsql2intorform(iBSQL2INTO) is null then                   
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#ffffff''" bgcolor="#FFFFFF" ');
                 else 
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#aaccf7''" bgcolor="#aaccf7" ');                   
                 end if;           
          
htp.prn(' ><INPUT NAME="BSQLWHERERID_' ||
                  iBSQL2INTO || '" TYPE="hidden" VALUE="' ||
                  BSQL2INTOrid(iBSQL2INTO) ||
                  '" CLASS="HIDDEN"><INPUT NAME="BSQLWHERERS_' ||
                  iBSQL2INTO || '" TYPE="hidden" VALUE="' ||
                  BSQL2INTORS(iBSQL2INTO) || '" CLASS="HIDDEN">
');
          if BSQLtype(1) in ('F') then
            htp.prn('
<TD><INPUT NAME="BSQLWHEREorderby_' || iBSQL2INTO ||
                    '" VALUE="' || BSQL2INTOorderby(iBSQL2INTO) ||
                    '" CLASS="TEXT"  maxlength="5" size="2" TYPE="TEXT"></TD>
<TD><SELECT NAME="BSQLWHEREnameCID_' || iBSQL2INTO ||
                    '" CLASS="SELECT">');
            js_INnameid_LOV(BSQL2INTOnameCID(iBSQL2INTO),
                            'BSQLWHEREnameCID_' || iBSQL2INTO || '');
            htp.prn('</SELECT></TD>
<TD><SELECT NAME="BSQLWHEREBLOKfieldid_' || iBSQL2INTO ||
                    '" CLASS="SELECT">');
            js_INTOBLOKIPOLJA_LOV(BSQL2INTOBLOKfieldid(iBSQL2INTO),
                                  'BSQLWHEREBLOKfieldid_' || iBSQL2INTO || '');
            htp.prn('</SELECT></TD>
');
          end if;
          if BSQLtype(1) in ('C') then
            htp.prn('
<TD><INPUT NAME="BSQLWHEREvalue_' || iBSQL2INTO ||
                    '" VALUE="' || BSQL2INTOvalue(iBSQL2INTO) ||
                    '" CLASS="TEXT"  maxlength="500" size="50" TYPE="TEXT"></TD>
<TD><INPUT NAME="BSQLWHEREcode_' || iBSQL2INTO ||
                    '" VALUE="' || BSQL2INTOcode(iBSQL2INTO) || '" CLASS="TEXT"  maxlength="100" size="20" TYPE="TEXT"></TD>
');
          end if;
          htp.prn('
<TD>
');
          if BSQLtype(1) in ('C') then
            htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                    RASDI_TRNSLT.text('Delete row', lang) || '"
onClick="document.RASDC_LINKS.BSQLWHEREvalue_' ||
                    iBSQL2INTO ||
                    '.value='''';document.RASDC_LINKS.BSQLWHEREcode_' ||
                    iBSQL2INTO || '.value='''';">
');
          elsif BSQLtype(1) in ('F') then
            htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                    RASDI_TRNSLT.text('Delete row', lang) || '"
onClick="document.RASDC_LINKS.BSQLWHEREorderby_' ||
                    iBSQL2INTO ||
                    '.value='''';document.RASDC_LINKS.BSQLWHEREnameCID_' ||
                    iBSQL2INTO ||
                    '.value='''';document.RASDC_LINKS.BSQLWHEREBLOKfieldid_' ||
                    iBSQL2INTO || '.value='''';">
');
          end if;
          htp.prn('
</td>
</TR>');
        end loop;
        htp.prn('</TABLE>

');
      end if;
      htp.prn('


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
<P align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_LINKS.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_LINKS.submit(); this.disabled = true; ">
');
end if;
htp.p('
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) ||
              '" name="ACTION">
' || predogled || '
</P>
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
    --<ON_ACTION formid="50006" blockid="">
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;

      v_form   varchar2(100);

    begin
      rasdi_client.secCheckPermission('RASDC_LINKS', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

            select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;

      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        rasdc_library.RefData(PFORMID);        
        pselect;
        sporocilo := 'Changes are saved.';
        
        if bsqlrform(1) is not null then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if; 
        
      elsif action = RASDI_TRNSLT.text('Search', lang) or
            action = RASDI_TRNSLT.text('New', lang) then
        pselect;

      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;

      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        pcommit;
        commit;
        rasdc_library.RefData(PFORMID);        
        pselect;
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

        
        if bsqlrform(1) is not null then
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

            phtml;

    end;
    --</ON_ACTION>
    --<ON_ERROR formid="50006" blockid="">
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
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</FORM></BODY></HTML>');

    --</ON_ERROR>
  end;
end RASDC_LINKS;
/

