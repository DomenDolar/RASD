create or replace package RASDC_FIELDSONBLOCK is
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

create or replace package body RASDC_FIELDSONBLOCK is
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
20200528 - Added info number of additional fields on block.    
20200410 - Added new compilation message     
20200203 - Added javascript check/uncheck for all fields in S, I, U, D, Mn., In., L and UI    
20190617 - Added Form searcher        
20190325 - Otimization on Table, View,Synonym LOV. Now it is stored in Session Storage. To refresh it you should logout ot delete cookie rasdi$SESSSTORAGEENABLED.
20181119 - Resolved bug on object listing (user_synonyms -> all_synonyms)      
20180917 - Added Dynamic fields 
20180520 - Added VS - VisualSettings now you can set for selected fileds settings for visible, readonly or disabled    
20160629 - Added log function for RASD.  
20160627 - Included reference form future.    
20160310 - Included CodeMirror       
20151202 - Included session variables in filters    
20151029 - Added function checknumberofsubfields        
20150928 - Added new presentation of errors on SQL...
20150814 - Added superuser    
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20200528225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    ACTION        varchar2(4000);
    GBUTTON1      varchar2(4000) := 'Search';
    GBUTTON2      varchar2(4000) := 'Reset';
    GBUTTON3      varchar2(4000) := 'Save';
    GBUTTON6      varchar2(4000) := 'Clear';
    LANG          varchar2(4000);
    SPOROCILO     varchar2(4000);
    PFORMID       number;
    Pblockid      varchar2(4000);
    PREDOGLED     varchar2(4000);
    RECNUMB20                     number := 1;
    SESSSTORAGEENABLED   varchar2(100);  
    stplus  varchar2(100);  
    B10RS         ctab;
    B10RID        rtab;
    B10formid     ctab;
    B10blockid    ctab;
    B10sqltable   ctab;
    B10numrows    ntab;
    B10emptyrows  ntab;
    B10dbblockyn  ctab;
    B10rowidyn    ctab;
    B10pagingyn   ctab;
    B10clearyn    ctab;
    B10label      ctab;
    B10LPROZILCI  ctab;
    B10sqltext    ctab;
    B10source     ctab;
    B10rform      ctab;
    B20RS         ctab;
    B20RID        rtab;
    B20fieldid    ctab;
    B20orderby    ntab;
    B20type       ctab;
    B20format     ctab;
    B20pkyn       ctab;
    B20selectyn   ctab;
    B20insertyn   ctab;
    B20updateyn   ctab;
    B20deleteyn   ctab;
    B20blockid    ctab;
    B20formid     ntab;
    B20notnullyn  ctab;
    B20insertnnyn ctab;
    B20lockyn     ctab;
    B20defaultval ctab;
    B20elementyn  ctab;
    B20nameid     ctab;
    B20label      ctab;
    B20ELEMENT    ctab;
    B20linkid     ctab;
    B20rform      ctab;
    B30TEXT       ctab;
    B20source     ctab;
    b20includevis    ctab;
    vcom number;
             unlink   varchar2(4000);
    PF      varchar2(4000);
                 
procedure on_session is
    i__ pls_integer := 1;
  begin
  rasdi_client.sessionStart;
  if ACTION is not null then
begin
rasdi_client.sessionSetValue(to_char(pformid)||'PBLOCKID', Pblockid ); 
rasdi_client.sessionSetValue('PF', pf ); 
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
vc := '';
if Pblockid is null then vc := rasdi_client.sessionGetValue(to_char(pformid)||'PBLOCKID'); Pblockid  := vc;  end if; 
vc := '';
if PF is null then vc := rasdi_client.sessionGetValue('PF'); PF := vc;  end if; 
exception when others then  null; end;  end if;
  
 
declare vc varchar2(2000); begin
null;
vc := rasdi_client.sessionGetValue('SESSSTORAGEENABLED'); SESSSTORAGEENABLED  := vc;  
if to_date(vc, 'ddmmyyyyhh24miss') + (1/24) < sysdate then
  SESSSTORAGEENABLED := null;
end if;
exception when others then  null; 
  SESSSTORAGEENABLED := null;
end;   

  if SESSSTORAGEENABLED is null then
begin
 rasdi_client.sessionSetValue('SESSSTORAGEENABLED', to_char(sysdate,'ddmmyyyyhh24miss') ); 
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
        elsif upper(name_array(i__)) = upper('GBUTTON1') then
          GBUTTON1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON2') then
          GBUTTON2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON3') then
          GBUTTON3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON6') then
          GBUTTON6 := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('UNLINK') then
          unlink := value_array(i__);
        elsif upper(name_array(i__)) = upper('SPOROCILO') then
          SPOROCILO := value_array(i__);
        elsif  upper(name_array(i__)) = upper('RECNUMB20') then 
          RECNUMB20 := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('Pblockid') then
          Pblockid := value_array(i__);
        elsif upper(name_array(i__)) = upper('') then
          PREDOGLED := value_array(i__);
        elsif upper(name_array(i__)) = upper('PF') then
          PF := value_array(i__);          
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
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
              upper('B10sqltable_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10sqltable(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10numrows_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10numrows(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10emptyrows_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10emptyrows(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10dbblockyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10dbblockyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10rowidyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10rowidyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10pagingyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10pagingyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10clearyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10clearyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10label_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10label(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LPROZILCI_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LPROZILCI(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10sqltext_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10sqltext(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10source_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10rform_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10rform(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20fieldid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20fieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20orderby_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20orderby(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20type_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20type(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20format_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20format(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20pkyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20pkyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20selectyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20selectyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20insertyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20insertyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20updateyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20updateyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20deleteyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20deleteyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20blockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20notnullyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20notnullyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20insertnnyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20insertnnyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20lockyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20lockyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20defaultval_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20defaultval(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20elementyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20elementyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b20includevis_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b20includevis(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20nameid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20nameid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20label_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20label(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20ELEMENT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20ELEMENT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20linkid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20linkid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30TEXT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30TEXT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10RID.count > v_max then
        v_max := B10RID.count;
      end if;
      if B10formid.count > v_max then
        v_max := B10formid.count;
      end if;
      if B10blockid.count > v_max then
        v_max := B10blockid.count;
      end if;
      if B10sqltable.count > v_max then
        v_max := B10sqltable.count;
      end if;
      if B10numrows.count > v_max then
        v_max := B10numrows.count;
      end if;
      if B10emptyrows.count > v_max then
        v_max := B10emptyrows.count;
      end if;
      if B10dbblockyn.count > v_max then
        v_max := B10dbblockyn.count;
      end if;
      if B10rowidyn.count > v_max then
        v_max := B10rowidyn.count;
      end if;
      if B10pagingyn.count > v_max then
        v_max := B10pagingyn.count;
      end if;
      if B10clearyn.count > v_max then
        v_max := B10clearyn.count;
      end if;
      if B10label.count > v_max then
        v_max := B10label.count;
      end if;
      if B10LPROZILCI.count > v_max then
        v_max := B10LPROZILCI.count;
      end if;
      if B10sqltext.count > v_max then
        v_max := B10sqltext.count;
      end if;
      if B10source.count > v_max then
        v_max := B10source.count;
      end if;
      if B10rform.count > v_max then
        v_max := B10rform.count;
      end if;      
      for i__ in 1 .. v_max loop
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10RID.exists(i__) then
          B10RID(i__) := null;
        end if;
        if not B10formid.exists(i__) then
          B10formid(i__) := null;
        end if;
        if not B10blockid.exists(i__) then
          B10blockid(i__) := null;
        end if;
        if not B10sqltable.exists(i__) then
          B10sqltable(i__) := null;
        end if;
        if not B10numrows.exists(i__) then
          B10numrows(i__) := to_number(null);
        end if;
        if not B10emptyrows.exists(i__) then
          B10emptyrows(i__) := to_number(null);
        end if;
        if not B10dbblockyn.exists(i__) or B10dbblockyn(i__) is null then
          B10dbblockyn(i__) := 'N';
        end if;
        if not B10rowidyn.exists(i__) or B10rowidyn(i__) is null then
          B10rowidyn(i__) := 'N';
        end if;
        if not B10pagingyn.exists(i__) or B10pagingyn(i__) is null then
          B10pagingyn(i__) := 'N';
        end if;
        if not B10clearyn.exists(i__) or B10clearyn(i__) is null then
          B10clearyn(i__) := 'N';
        end if;
        if not B10label.exists(i__) then
          B10label(i__) := null;
        end if;
        if not B10LPROZILCI.exists(i__) then
          B10LPROZILCI(i__) := null;
        end if;
        if not B10sqltext.exists(i__) then
          B10sqltext(i__) := null;
        end if;
        if not B10source.exists(i__) then
          B10source(i__) := null;
        end if;
        if not B10rform.exists(i__) then
          B10rform(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if B20RS.count > v_max then
        v_max := B20RS.count;
      end if;
      if B20RID.count > v_max then
        v_max := B20RID.count;
      end if;
      if B20fieldid.count > v_max then
        v_max := B20fieldid.count;
      end if;
      if B20orderby.count > v_max then
        v_max := B20orderby.count;
      end if;
      if B20type.count > v_max then
        v_max := B20type.count;
      end if;
      if B20format.count > v_max then
        v_max := B20format.count;
      end if;
      if B20pkyn.count > v_max then
        v_max := B20pkyn.count;
      end if;
      if B20selectyn.count > v_max then
        v_max := B20selectyn.count;
      end if;
      if B20insertyn.count > v_max then
        v_max := B20insertyn.count;
      end if;
      if B20updateyn.count > v_max then
        v_max := B20updateyn.count;
      end if;
      if B20deleteyn.count > v_max then
        v_max := B20deleteyn.count;
      end if;
      if B20blockid.count > v_max then
        v_max := B20blockid.count;
      end if;
      if B20formid.count > v_max then
        v_max := B20formid.count;
      end if;
      if B20notnullyn.count > v_max then
        v_max := B20notnullyn.count;
      end if;
      if B20insertnnyn.count > v_max then
        v_max := B20insertnnyn.count;
      end if;
      if B20lockyn.count > v_max then
        v_max := B20lockyn.count;
      end if;
      if B20defaultval.count > v_max then
        v_max := B20defaultval.count;
      end if;
      if B20elementyn.count > v_max then
        v_max := B20elementyn.count;
      end if;
      if b20includevis.count > v_max then
        v_max := b20includevis.count;
      end if;      
      if B20nameid.count > v_max then
        v_max := B20nameid.count;
      end if;
      if B20label.count > v_max then
        v_max := B20label.count;
      end if;
      if B20ELEMENT.count > v_max then
        v_max := B20ELEMENT.count;
      end if;
      if B20linkid.count > v_max then
        v_max := B20linkid.count;
      end if;
      if B20source.count > v_max then
        v_max := B20source.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B20RS.exists(i__) then
          B20RS(i__) := null;
        end if;
        if not B20RID.exists(i__) then
          B20RID(i__) := null;
        end if;
        if not B20fieldid.exists(i__) then
          B20fieldid(i__) := null;
        end if;
        if not B20orderby.exists(i__) then
          B20orderby(i__) := to_number(null);
        end if;
        if not B20type.exists(i__) then
          B20type(i__) := null;
        end if;
        if not B20format.exists(i__) then
          B20format(i__) := null;
        end if;
        if not B20pkyn.exists(i__) or B20pkyn(i__) is null then
          B20pkyn(i__) := 'N';
        end if;
        if not B20selectyn.exists(i__) or B20selectyn(i__) is null then
          B20selectyn(i__) := 'N';
        end if;
        if not B20insertyn.exists(i__) or B20insertyn(i__) is null then
          B20insertyn(i__) := 'N';
        end if;
        if not B20updateyn.exists(i__) or B20updateyn(i__) is null then
          B20updateyn(i__) := 'N';
        end if;
        if not B20deleteyn.exists(i__) or B20deleteyn(i__) is null then
          B20deleteyn(i__) := 'N';
        end if;
        if not B20blockid.exists(i__) then
          B20blockid(i__) := null;
        end if;
        if not B20formid.exists(i__) then
          B20formid(i__) := to_number(null);
        end if;
        if not B20notnullyn.exists(i__) or B20notnullyn(i__) is null then
          B20notnullyn(i__) := 'N';
        end if;
        if not B20insertnnyn.exists(i__) or B20insertnnyn(i__) is null then
          B20insertnnyn(i__) := 'N';
        end if;
        if not B20lockyn.exists(i__) or B20lockyn(i__) is null then
          B20lockyn(i__) := 'N';
        end if;
        if not B20defaultval.exists(i__) then
          B20defaultval(i__) := null;
        end if;
        if not B20elementyn.exists(i__) or B20elementyn(i__) is null then
          B20elementyn(i__) := 'N';
        end if;
        if not b20includevis.exists(i__) or b20includevis(i__) is null then
          b20includevis(i__) := 'N';
        end if;        
        if not B20nameid.exists(i__) then
          B20nameid(i__) := null;
        end if;
        if not B20label.exists(i__) then
          B20label(i__) := null;
        end if;
        if not B20ELEMENT.exists(i__) then
          B20ELEMENT(i__) := null;
        end if;
        if not B20linkid.exists(i__) then
          B20linkid(i__) := null;
        end if;
        if not B20source.exists(i__) then
          B20source(i__) := null;
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
      --<POST_SUBMIT formid="5004" blockid="">
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
        B10RS(j__) := null;
        B10RID(j__) := null;
        B10formid(j__) := null;
        B10blockid(j__) := null;
        B10sqltable(j__) := null;
        B10numrows(j__) := null;
        B10emptyrows(j__) := null;
        B10dbblockyn(j__) := null;
        B10rowidyn(j__) := null;
        B10pagingyn(j__) := null;
        B10clearyn(j__) := null;
        B10label(j__) := null;
        B10LPROZILCI(j__) := ' ';
        B10sqltext(j__) := null;
        B10rform(j__) := null;
        B10source(j__) := null;
        B10RS(j__) := 'I';

      end loop;
    end;
    procedure pclear_B20(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 8 = 0 then
        k__ := i__ + 2;
      else
        if i__ > 8 then
          k__ := i__ + 2;
        else
          k__ := 2 + 8;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B20RS(j__) := null;
        B20RID(j__) := null;
        B20fieldid(j__) := null;
        B20orderby(j__) := null;
        B20type(j__) := null;
        B20format(j__) := null;
        B20pkyn(j__) := null;
        B20selectyn(j__) := null;
        B20insertyn(j__) := null;
        B20updateyn(j__) := null;
        B20deleteyn(j__) := null;
        B20blockid(j__) := null;
        B20formid(j__) := null;
        B20notnullyn(j__) := null;
        B20insertnnyn(j__) := null;
        B20lockyn(j__) := null;
        B20defaultval(j__) := null;
        B20elementyn(j__) := null;
        b20includevis(j__) := null;        
        B20nameid(j__) := null;
        B20label(j__) := null;
        B20ELEMENT(j__) := null;
        B20linkid(j__) := null;
        B20source(j__) := null;
        B20rform(j__) := null;
        B20RS(j__) := 'I';

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
      ACTION    := null;
      GBUTTON1  := 'Search';
      GBUTTON2  := 'Reset';
      GBUTTON3  := 'Save';
      GBUTTON6  := 'Clear';
      RECNUMB20 := 1;      
      LANG      := null;
      SPOROCILO := null;
      PFORMID   := null;
      Pblockid  := null;
      PREDOGLED := null;
      PF := null;      
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_B10(0);
      pclear_B20(0);
      pclear_B30(0);
      null;
    end;
    procedure pselect_B10 is
      i__ pls_integer;
    begin
      B10RS.delete;
      B10RID.delete;
      B10formid.delete;
      B10blockid.delete;
      B10sqltable.delete;
      B10numrows.delete;
      B10emptyrows.delete;
      B10dbblockyn.delete;
      B10rowidyn.delete;
      B10pagingyn.delete;
      B10clearyn.delete;
      B10label.delete;
      B10LPROZILCI.delete;
      B10sqltext.delete;
      B10source.delete;
      B10rform.delete;
      --<pre_select formid="5004" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="5004" blockid="B10">
          SELECT ROWID RID,
                 formid,
                 blockid,
                 sqltable,
                 numrows,
                 emptyrows,
                 dbblockyn,
                 rowidyn,
                 pagingyn,
                 clearyn,
                 label,
                 sqltext , rform
            FROM RASD_BLOCKS
           where formid = PFORMID
             and blockid = pblockid 
          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10RID(i__),
                 B10formid(i__),
                 B10blockid(i__),
                 B10sqltable(i__),
                 B10numrows(i__),
                 B10emptyrows(i__),
                 B10dbblockyn(i__),
                 B10rowidyn(i__),
                 B10pagingyn(i__),
                 B10clearyn(i__),
                 B10label(i__),
                 B10sqltext(i__),                 
                 B10rform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10LPROZILCI(i__) := null;
            B10source(i__) := null;
            B10RS(i__) := 'U';

            --<post_select formid="5004" blockid="B10">
            b10sqltable(i__) := upper(b10sqltable(i__));
            B10blockid(i__) := upper(B10blockid(i__));
            declare
              v_st number;
            begin

              select count(*)
                into v_st
                from RASD_TRIGGERS
               where formid = PFORMID
                 and blockid = b10blockid(i__);
              if v_st = 0 then
                B10LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Block triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbproz.jpg" width=23 border=0 >';
              else
                B10LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Block triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbprozred.jpg" width=23 border=0 >';
              end if;

            end;
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10RS.delete(1);
          B10RID.delete(1);
          B10formid.delete(1);
          B10blockid.delete(1);
          B10sqltable.delete(1);
          B10numrows.delete(1);
          B10emptyrows.delete(1);
          B10dbblockyn.delete(1);
          B10rowidyn.delete(1);
          B10pagingyn.delete(1);
          B10clearyn.delete(1);
          B10label.delete(1);
          B10LPROZILCI.delete(1);
          B10sqltext.delete(1);
          B10source.delete(1);
          B10rform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10RID.count);
      null;
    end;
    procedure pselect_B20 is
      i__ pls_integer;
    begin
      B20RS.delete;
      B20RID.delete;
      B20fieldid.delete;
      B20orderby.delete;
      B20type.delete;
      B20format.delete;
      B20pkyn.delete;
      B20selectyn.delete;
      B20insertyn.delete;
      B20updateyn.delete;
      B20deleteyn.delete;
      B20blockid.delete;
      B20formid.delete;
      B20notnullyn.delete;
      B20insertnnyn.delete;
      B20lockyn.delete;
      B20defaultval.delete;
      B20elementyn.delete;
      b20includevis.delete;      
      B20nameid.delete;
      B20label.delete;
      B20ELEMENT.delete;
      B20linkid.delete;
      B20source.delete;
      B20rform.delete;
      --<pre_select formid="5004" blockid="B20">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="5004" blockid="B20">
          SELECT ROWID RID,
                 fieldid,
                 orderby,
                 type,
                 format,
                 pkyn,
                 selectyn,
                 insertyn,
                 updateyn,
                 deleteyn,
                 notnullyn,
                 insertnnyn,
                 lockyn,
                 defaultval,
                 elementyn,
                 nameid,
                 label,
                 ELEMENT,
                 linkid , rform, includevis
            FROM RASD_FIELDS
           where nvl(blockid, 'X') = nvl(pblockid, 'X')
             and formid = PFORMID
             and fieldid in (
select f.fieldid  from rasd_links l, rasd_fields f where upper(l.linkid||':'||l.link||':'||l.text) like upper('%'||pf||'%') and l.formid = pformid and l.formid = f.formid and l.linkid = f.linkid and nvl(f.blockid, 'X') = nvl(pblockid, 'X')
union
select f.fieldid  from rasd_fields f where upper(f.fieldid||':'||f.blockid||':'||f.defaultval||':'||nameid||':'||label) like upper('%'||pf||'%') and formid = pformid and nvl(f.blockid, 'X') = nvl(pblockid, 'X')
) 
           order by orderby
          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B20RID(i__),
                 B20fieldid(i__),
                 B20orderby(i__),
                 B20type(i__),
                 B20format(i__),
                 B20pkyn(i__),
                 B20selectyn(i__),
                 B20insertyn(i__),
                 B20updateyn(i__),
                 B20deleteyn(i__),
                 B20notnullyn(i__),
                 B20insertnnyn(i__),
                 B20lockyn(i__),
                 B20defaultval(i__),
                 B20elementyn(i__),                 
                 B20nameid(i__),
                 B20label(i__),
                 B20ELEMENT(i__),
                 B20linkid(i__),
                 b20rform(i__),
                 b20includevis(i__);
          exit when c__%notfound;
--          if c__%rowcount >= 1 then
          if c__%rowcount >= nvl(RECNUMB20,1) then --xx
            B20RS(i__) := null;
            B20blockid(i__) := null;
            B20formid(i__) := null;
            B20source(i__) := null;
            B20RS(i__) := 'U';

            --<post_select formid="5004" blockid="B20">
            --</post_select>
            exit when i__ =15;  --xx
            i__ := i__ + 1;
          end if;
        END LOOP;
        
        declare
         x_st number;
         
        begin

        --stplus := RECNUMB20;
        
        select count(*) into x_st 
        from rasd_fields f where f.formid = PFORMID and nvl(f.blockid, 'X') = nvl(pblockid, 'X');   

        if  x_st >  (RECNUMB20+15-1) then
          stplus := '(+'||(x_st-RECNUMB20-15+1)||')';
        end if;        
         
           
        end;
        
--        if c__%rowcount < 1 then
        if c__%rowcount < nvl(RECNUMB20,1)  then --xx
          B20RS.delete(1);
          B20RID.delete(1);
          B20fieldid.delete(1);
          B20orderby.delete(1);
          B20type.delete(1);
          B20format.delete(1);
          B20pkyn.delete(1);
          B20selectyn.delete(1);
          B20insertyn.delete(1);
          B20updateyn.delete(1);
          B20deleteyn.delete(1);
          B20blockid.delete(1);
          B20formid.delete(1);
          B20notnullyn.delete(1);
          B20insertnnyn.delete(1);
          B20lockyn.delete(1);
          B20defaultval.delete(1);
          B20elementyn.delete(1);
          b20includevis.delete(1);          
          B20nameid.delete(1);
          B20label.delete(1);
          B20ELEMENT.delete(1);
          B20linkid.delete(1);
          B20source.delete(1);
          B20rform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B20(B20RID.count);
      null;
    end;
    procedure pselect_B30 is
      i__ pls_integer;
    begin
      B30TEXT.delete;
      --<pre_select formid="5004" blockid="B30">
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

            --<post_select formid="5004" blockid="B30">
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
        pselect_B20;
      end if;
      if 1 = 1 then
        pselect_B30;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B10RS.count loop
        --<on_validate formid="5004" blockid="B10">

        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          if B10blockid(i__) is not null or B10sqltable(i__) is not null or
             B10numrows(i__) is not null or B10emptyrows(i__) is not null or
             B10label(i__) is not null then
            --<pre_insert formid="5004" blockid="B10">
            B10formid(i__) := PFORMID;
            B10source(i__) := 'V';
            
            B10blockid(i__) := rasdc_library.prepareName(B10blockid(i__));

            --</pre_insert>
            insert into RASD_BLOCKS
              (formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label,
               sqltext,
               source)
            values
              (B10formid(i__),
               upper(B10blockid(i__)),
               B10sqltable(i__),
               B10numrows(i__),
               B10emptyrows(i__),
               B10dbblockyn(i__),
               B10rowidyn(i__),
               B10pagingyn(i__),
               B10clearyn(i__),
               B10label(i__),
               B10sqltext(i__),
               B10source(i__));

            --<post_insert formid="5004" blockid="B10">
            RASDC_LIBRARY.insertfields(PFORMID, b10blockid(i__), lang);
            update RASD_FORMS set change = sysdate where formid = PFORMID;
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;
          if B10blockid(i__) is null then
            --DELETE
            --<pre_delete formid="5004" blockid="B10">
            declare
              v_blockid RASD_BLOCKS.blockid%type;
            begin
              select blockid
                into v_blockid
                from RASD_BLOCKS
               where rowid = b10rid(i__) and rform is null;
              RASDC_LIBRARY.deleteblock(PFORMID, v_blockid);
            exception when others then null;  
            end;

            --</pre_delete>
            delete RASD_BLOCKS where ROWID = B10RID(i__) and rform is null;
            --<post_delete formid="5004" blockid="B10">
            --</post_delete>
          else
            --UPDATE

            --<pre_update formid="5004" blockid="B10">
            declare
              v_blockid RASD_BLOCKS.blockid%type;
            begin
              select blockid
                into v_blockid
                from RASD_BLOCKS
               where rowid = b10rid(i__) and (rform is null or unlink = 'Y');
              if v_blockid <> b10blockid(i__) then
                RASDC_LIBRARY.changeblock(PFORMID,
                                            v_blockid,
                                            PFORMID,
                                            b10blockid(i__),
                                            B10label(i__));
              end if;
            exception when others then null;  
            end;

            --</pre_update>
            update RASD_BLOCKS
               set blockid   = B10blockid(i__),
                   sqltable  = B10sqltable(i__),
                   numrows   = B10numrows(i__),
                   emptyrows = B10emptyrows(i__),
                   dbblockyn = B10dbblockyn(i__),
                   rowidyn   = B10rowidyn(i__),
                   pagingyn  = B10pagingyn(i__),
                   clearyn   = B10clearyn(i__),
                   label     = B10label(i__),
                   sqltext   = B10sqltext(i__)
,                   rform  = decode (unlink,'Y',null,rform)
                 where ROWID = B10RID(i__) and (rform is null or unlink = 'Y');
            --<post_update formid="5004" blockid="B10">
            if (b10rform(i__) is null or unlink = 'Y') then
               RASDC_LIBRARY.insertfields(PFORMID, b10blockid(i__), lang);
            end if;
            
            update RASD_FORMS set change = sysdate where formid = PFORMID;

            if B10dbblockyn(i__) = 'Y' then
              declare
                c0 number := 0;
              begin
                execute immediate rasdc_sql.get_sqltext(PFORMID,
                                                        B10blockid(i__));
              exception
                when no_data_found then
                  null;
                when others then
                  sporocilo := sporocilo || '
'||RASDI_TRNSLT.text('SQL error on block: ' ||
                                                            B10blockid(i__) || ' (' ||
                                                            sqlerrm || ')!',
                                                            lang);
                /*  raise_application_error('-20003',
                                          RASDI_TRNSLT.text('SQL error on block ' ||
                                                            B10blockid(i__) || ' (' ||
                                                            sqlerrm || ')!',
                                                            lang));*/
              end;
            end if;
            --</post_update>
            null;
          end if;
          null;
        end if;

        null;
      end loop;
      null;

    end;
    procedure pcommit_B20 is
      v_zaklepanje varchar2(4000);
    begin

      for i__ in 1 .. B20RS.count loop
        --<on_validate formid="5004" blockid="B20">
        declare
          v_f   varchar2(100);
          v_sql varchar2(1000);
        begin
          if B20format(i__) is not null then
            if B20type(i__) in ('N') then

              v_sql := '
  declare
    v varchar2(100);
  begin
  select
    to_char(0, ' || B20format(i__) || ') into v
  from dual;
  end;
  ';
              execute immediate v_sql;

            elsif B20type(i__) in ('D') then

              v_sql := '
  declare
    v varchar2(100);
  begin
  select
     to_char(current_date, ' || B20format(i__) || ') into v
  from dual;
  end;
  ';
   
              execute immediate v_sql;

            else
              raise_application_error('-20003',
                                      RASDI_TRNSLT.text('Field format can be set only for type Number-N and Date-D!',
                                                        lang));
            end if;
          end if;
        exception
          when others then
            sporocilo := sporocilo || '
'||RASDI_TRNSLT.text('Wrong format (' ||
                                                      B20format(i__) ||
                                                      ') of field ' ||
                                                      B20fieldid(i__) ||
                                                      '. (' || sqlerrm || ')!',
                                                      lang);
/*            raise_application_error('-20003',
                                    RASDI_TRNSLT.text('Wrong format (' ||
                                                      B20format(i__) ||
                                                      ') of field ' ||
                                                      B20fieldid(i__) ||
                                                      '. (' || sqlerrm || ')!',
                                                      lang));*/
        end;
        declare
          i___x number;
          i___x1 number;
          i___x2 number;
        begin

if B20fieldid(i__) is not null then
  
select count(*) into i___x
from rasd_fields where formid = pformid
and ( instr(upper(blockid||fieldid), upper(pblockid||B20fieldid(i__)) ) > 0
   or instr(upper(pblockid||B20fieldid(i__)) ,upper(blockid||fieldid)) > 0 
   ) and upper(pblockid||B20fieldid(i__)) <> upper(blockid||fieldid) 
;  
if i___x > 0 then
            sporocilo := sporocilo || '
'||RASDI_TRNSLT.text('Warning: Sub-string of field name ',lang)||B20fieldid(i__)||RASDI_TRNSLT.text(' exists in form.', lang);
end if;

end if;
        end;
        declare
          v_f   varchar2(100);
          v_sql varchar2(1000);
        begin
          if B20defaultval(i__) is not null then
            if B20type(i__) in ('N') then

              v_sql := '
  declare
    n number := ' || B20defaultval(i__) || ';
  begin
    null;
  end;
  ';
              execute immediate v_sql;

            elsif B20type(i__) in ('D') then

              if B20format(i__) is not null then
                v_sql := '
  declare
    d date := to_date(' || B20defaultval(i__) || ', ' ||
                         B20format(i__) || ');
  begin
   null;
  end;
  ';
              else
                v_sql := '
  declare
    d date := to_date(' || B20defaultval(i__) || ', rasdi_client.c_date_format);
  begin
   null;
  end;
  ';
              end if;
              execute immediate v_sql;

            elsif B20type(i__) in ('T') then
null;
              if B20format(i__) is not null then
                v_sql := '
  declare
    d timestamp := to_timestmap(' || B20defaultval(i__) || ', ' ||
                         B20format(i__) || ');
  begin
   null;
  end;
  ';
              else
                v_sql := '
  declare
    d timestamp := to_timestamp(' || B20defaultval(i__) || ');
  begin
   null;
  end;
  ';
              end if;
              execute immediate v_sql;

            elsif B20type(i__) in ('C') then

              v_sql := '
  declare
    v varchar2(1000) := ' || B20defaultval(i__) || ';
  begin
    null;
  end;
  ';
              execute immediate v_sql;

            else
              raise_application_error('-20003',
                                      RASDI_TRNSLT.text('Element default value can be set only for type Char-C, Number-N, Date-D and T-Timestamp!',
                                                        lang));
            end if;
          end if;
        exception
          when others then
            sporocilo := sporocilo || '
'||RASDI_TRNSLT.text('Wrong default value (' ||
                                                      B20defaultval(i__) ||
                                                      ') of field ' ||
                                                      B20fieldid(i__) ||
                                                      '. (' || sqlerrm || ')!',
                                                      lang);            
/*            raise_application_error('-20003',
                                    RASDI_TRNSLT.text('Wrong default value (' ||
                                                      B20defaultval(i__) ||
                                                      ') of field ' ||
                                                      B20fieldid(i__) ||
                                                      '. (' || sqlerrm || ')!',
                                                      lang));*/
        end;


        --</on_validate>
        if substr(B20RS(i__), 1, 1) = 'I' then
          --INSERT
          if B20fieldid(i__) is not null or B20orderby(i__) is not null or
             B20format(i__) is not null or B20defaultval(i__) is not null or
             B20label(i__) is not null or B20ELEMENT(i__) is not null or
             B20linkid(i__) is not null then
            --<pre_insert formid="5004" blockid="B20">
            B20formid(i__) := PFORMID;
            B20blockid(i__) := Pblockid;
            B20source(i__) := 'V';
            if B20nameid(i__) is null then
              B20nameid(i__) := upper(B20blockid(i__) || B20fieldid(i__));
            end if;
            
            B20fieldid(i__) := rasdc_library.prepareName(B20fieldid(i__));
            
            --</pre_insert>
            insert into RASD_FIELDS
              (fieldid,
               orderby,
               type,
               format,
               pkyn,
               selectyn,
               insertyn,
               updateyn,
               deleteyn,
               blockid,
               formid,
               notnullyn,
               insertnnyn,
               lockyn,
               defaultval,
               elementyn,
               nameid,
               label,
               ELEMENT,
               linkid,
               source)
            values
              (upper(B20fieldid(i__)),
               nvl(B20orderby(i__),290875),
               B20type(i__),
               B20format(i__),
               B20pkyn(i__),
               B20selectyn(i__),
               B20insertyn(i__),
               B20updateyn(i__),
               B20deleteyn(i__),
               B20blockid(i__),
               B20formid(i__),
               B20notnullyn(i__),
               B20insertnnyn(i__),
               B20lockyn(i__),
               B20defaultval(i__),
               'Y',
               upper(B20nameid(i__)),
               B20label(i__),
               B20ELEMENT(i__),
               B20linkid(i__),
               B20source(i__));
            --<post_insert formid="5004" blockid="B20">
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if B20fieldid(i__) is null then
            --DELETE
            --<pre_delete formid="5004" blockid="B20">
            --</pre_delete>
            delete RASD_FIELDS where ROWID = B20RID(i__) and rform is null;
            --<post_delete formid="5004" blockid="B20">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="5004" blockid="B20">
            B20source(i__) := 'V';
            declare
              v_fieldid RASD_FIELDS.fieldid%type;
              v_nameid  RASD_FIELDS.nameid%type;
              v_element RASD_FIELDS.element%type;
            begin
              select fieldid, nameid, element
                into v_fieldid, v_nameid, v_element
                from RASD_FIELDS
               where rowid = b20rid(i__) and (rform is null or unlink = 'Y');

              --  if v_fieldid <> b20fieldid(i__) or v_nameid <> b20nameid(i__) then
              RASDC_LIBRARY.changefield(PFORMID,
                                           v_fieldid,
                                           b20fieldid(i__),
                                           v_nameid,
                                           b20nameid(i__),
                                           v_element,
                                           b20element(i__),
                                           B20label(i__));

                   --  end if;
            exception when others then null;       
            end;
            --</pre_update>
            update RASD_FIELDS
               set fieldid    = upper(B20fieldid(i__)),
                   orderby    = B20orderby(i__),
                   type       = B20type(i__),
                   format     = B20format(i__),
                   pkyn       = B20pkyn(i__),
                   selectyn   = B20selectyn(i__),
                   insertyn   = B20insertyn(i__),
                   updateyn   = B20updateyn(i__),
                   deleteyn   = B20deleteyn(i__),
                   notnullyn  = B20notnullyn(i__),
                   insertnnyn = B20insertnnyn(i__),
                   lockyn     = B20lockyn(i__),
                   defaultval = B20defaultval(i__),
                   elementyn  = B20elementyn(i__),
                   includevis  = b20includevis(i__),                   
                   nameid     = nvl(upper(B20nameid(i__)) , upper(blockid||fieldid) ),
                   label      = B20label(i__),
                   ELEMENT    = B20ELEMENT(i__),
                   linkid     = B20linkid(i__),
                   source     = B20source(i__)
,                   rform  = decode (unlink,'Y',null,rform)
             where ROWID = B20RID(i__) and (rform is null or unlink = 'Y');                   
            --<post_update formid="5004" blockid="B20">
            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
      
declare
  i___x number;
  i___x1 number; i___x2 number;
begin      
select sum(decode(x.pkyn,'Y',1,0)) , sum(decode(x.updateyn,'Y',1,0)) , sum(decode(x.deleteyn,'Y',1,0))  
into i___x, i___x1, i___x2
from rasd_fields x where formid = pformid
and blockid = pblockid;

if (i___x1 > 0 or i___x2 > 0 ) and i___x = 0 then

            sporocilo := sporocilo || '<br/>
'||RASDI_TRNSLT.text('Warning: If you would like to execute UPDATE or DELETE the PK field should be selected.',lang);
  

end if;    
end;  
      
      
      
      
    end;
    procedure pcommit_B30 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B30TEXT.count loop
        --<on_validate formid="5004" blockid="B30">
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
      --<pre_commit formid="5004" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
        null;
      end if;
      if 1 = 1 then
        pcommit_B20;
       null;
      end if;
      if 1 = 1 then
        pcommit_B30;
      end if;
      --<post_commit formid="5004" blockid="">
      update RASD_FORMS set change = sysdate where formid = PFORMID;
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB20 pls_integer;
      iB30 pls_integer;
      --povezavein
      procedure js_B10LPROZILCI_POV(value varchar2,
                                    name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LPROZILCI%' then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) ||
                  '&LANG=''+document.RASDC_FIELDSONBLOCK.LANG.value+
''&Pblockid=''+document.RASDC_FIELDSONBLOCK.B10blockid_' ||
                  substr(name, instr(name, '_', -1) + 1) || '.value+
''&PFORMID=''+document.RASDC_FIELDSONBLOCK.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_FIELDSONBLOCK.LANG.value+
''&Pblockid=''+document.RASDC_FIELDSONBLOCK.B10blockid_1.value+
''&PFORMID=''+document.RASDC_FIELDSONBLOCK.PFORMID.value+
''''');
        end if;
      end;
      --SQL
      procedure js_B20linkid_LOV(value varchar2,
                                 name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_B20linkid_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_B10sqltable_LOV(value varchar2,
                                   name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_B10sqltable_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      procedure js_Pblockid_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_Pblockid_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;
      --TEXT
      procedure js_B20ELEMENT_LOV(value varchar2,
                                  name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_B20ELEMENT_LOV(''' || value || ''')');
        htp.p('</SCRIPT>');
      end;
      procedure js_B20type_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_B20type_LOV(''' || value || ''')');
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
      htp.p('function js_B20linkid_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="5004" linkid="B20linkid_LOV">
                  select '' id, '' label, 1
                    from dual
                  union
                  select linkid id, link label, 2
                    from RASD_LINKS
                   where formid = PFORMID
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
      htp.p('function js_B10sqltable_LOV(pvalue) {');
      htp.p('var v_output = "";');
      
      for r__ in (
                  --<LOVSQL formid="5004" linkid="B10sqltable_LOV">
                   select '' id, '' label, 1 x
                    from dual
                  union
                   select b.sqltable, sqltable || ' ... F' , 3
                   from rasd_blocks b where b.formid = PFORMID 
                   and b.sqltable is not null 
                   order by 3, 1
                  --</LOVSQL>
                  ) loop
              htp.p('  v_output = v_output + ''<OPTION CLASS=selectp value="' || r__.id || '">' ||  r__.label || '</OPTION> ''; ');

      end loop;
      
        htp.p('v_output = v_output.replace(''value="''+pvalue+''"'', ''value="''+pvalue+''" selected'' );');
        htp.p('document.write(v_output);');      
        htp.p('v_output = "";');      
      
      
      if SESSSTORAGEENABLED is null then      
      for r__ in (
                  --<LOVSQL formid="5004" linkid="B10sqltable_LOV">
/*                   select '' id, '' label, 1 x
                    from dual
                  union*/
                  select /*+ RULE*/ OBJECT_NAME id,
                          OBJECT_NAME || ' ... ' || substr(object_type, 1, 1) label,
                          2 x
                    from all_objects
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select /*+ RULE*/ distinct SYNONYM_NAME id,
                                   SYNONYM_NAME || ' ... S' label,
                                   2 x
                    from all_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id,
                          owner||'.'||table_name  /*|| ' ... ' || substr(type, 1, 1)*/ label, 2 x
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and 
                    grantee = rasdc_library.currentDADUser  
/*                   union 
                   select b.sqltable, sqltable || ' ... F' , 3
                   from rasd_blocks b where b.formid = PFORMID 
                   and b.sqltable is not null 
                   and b.sqltable not in  (
                  select /*+ RULE* / OBJECT_NAME id
                    from all_objects
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select /*+ RULE* / distinct SYNONYM_NAME id
                    from all_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and 
                    grantee = rasdc_library.currentDADUser                    
                   ) */
                   order by 3, 1
                  --</LOVSQL>
                  ) loop
    --    htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
  --            r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
--              r__.label || ' '')');
              htp.p('  v_output = v_output + ''<OPTION CLASS=selectp value="' || r__.id || '">' ||  r__.label || '</OPTION> ''; ');

      end loop;

     htp.p('sessionStorage.setItem("rasdi$B20sqltable_LOV",v_output);');  -- ist isource je v programu blocksonform
      htp.p('document.getElementsByName("SESSSTORAGEENABLED").value="1";');

      else
      
      htp.p('v_output = sessionStorage.getItem("rasdi$B20sqltable_LOV");'); -- ist isource je v programu blocksonform
       
      end if;
      htp.p('if (v_output != null) { v_output = v_output.replace(''value="''+pvalue+''"'', ''value="''+pvalue+''" selected'' ); }');
      
      htp.p('document.write(v_output);');      
      
      
      htp.p('}');
      htp.prn('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_Pblockid_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="5004" linkid="Pblockid_LOV">
                  select '' id, 'F' label, -1000
                    from dual
                  union
                  select blockid id, blockid label, vr
                    from (select b.blockid, nvl(min(f.orderby), 0) vr
                             from RASD_BLOCKS b, rasd_fields f
                            where b.formid = PFORMID
                              and b.blockid = f.blockid(+)
                              and b.formid = f.formid(+)
                            group by b.blockid
                            order by vr)
                   order by 3, 1
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
      htp.p('function js_B20ELEMENT_LOV(pvalue) {');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue=='''')?''selected'':'''') +'' value=""> '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_TEXT'')?''selected'':'''') +'' value="INPUT_TEXT">' ||
            RASDI_TRNSLT.text('Input text field', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''TEXTAREA_'')?''selected'':'''') +'' value="TEXTAREA_">' ||
            RASDI_TRNSLT.text('Input text Area', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_PASSWORD'')?''selected'':'''') +'' value="INPUT_PASSWORD">' ||
            RASDI_TRNSLT.text('Input text password', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_BUTTON'')?''selected'':'''') +'' value="INPUT_BUTTON">' ||
            RASDI_TRNSLT.text('Button', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_SUBMIT'')?''selected'':'''') +'' value="INPUT_SUBMIT">' ||
            RASDI_TRNSLT.text('Button SUBMIT', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_RESET'')?''selected'':'''') +'' value="INPUT_RESET">' ||
            RASDI_TRNSLT.text('Button RESET', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_HIDDEN'')?''selected'':'''') +'' value="INPUT_HIDDEN">' ||
            RASDI_TRNSLT.text('Hidden field', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''SELECT_'')?''selected'':'''') +'' value="SELECT_">' ||
            RASDI_TRNSLT.text('Input select (LOV)', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''FONT_RADIO'')?''selected'':'''') +'' value="FONT_RADIO">' ||
            RASDI_TRNSLT.text('Input radio (LOV)', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''INPUT_CHECKBOX'')?''selected'':'''') +'' value="INPUT_CHECKBOX">' ||
            RASDI_TRNSLT.text('Check BOX (LOV)', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''FONT_'')?''selected'':'''') +'' value="FONT_">' ||
            RASDI_TRNSLT.text('Text', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''A_'')?''selected'':'''') +'' value="A_">' ||
            RASDI_TRNSLT.text('Link', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''IMG_'')?''selected'':'''') +'' value="IMG_">' ||
            RASDI_TRNSLT.text('Image', lang) || ' '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''PLSQL_'')?''selected'':'''') +'' value="PLSQL_">' ||
            RASDI_TRNSLT.text('Code ON UI', lang) || ' '')');
      
      -- added dynamic fields      
      for rx in (select distinct e.client||'.core' pckcore
                         from rasd_forms_compiled f, rasd_engines e
                         where f.formid = PFORMID
                           and e.engineid = f.engineid) loop                
    declare
        TYPE ctype__ is REF CURSOR;
         c__ ctype__;
         v_name varchar2(300);
         v_label  varchar2(300);
      begin
      OPEN c__ FOR 
                  --<lovsql formid="6" linkid="LOV_SQL">
                  'select distinct element , replace(element, ''DYNAMICFIELD_'') label  
                   from rasd_attributes_template t 
                   where t.element like ''DYNAMICFIELD_%'' and coreid = '||rx.pckcore||' order by 1';
                  --</lovsql>
      loop
        FETCH c__
            INTO v_name, v_label;
          exit when c__%notfound;
          
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue=='''||v_name||''')?''selected'':'''') +'' value="'||v_name||'">' ||
            RASDI_TRNSLT.text('Dynamic field '||v_label, lang) || ' '')');            

      end loop;
      end;
           
      end loop;

            
      htp.p('}');
      htp.p('</SCRIPT>');
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_B20type_LOV(pvalue) {');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''C'')?''selected'':'''') +'' value="C">C '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''D'')?''selected'':'''') +'' value="D">D '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''N'')?''selected'':'''') +'' value="N">N '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''R'')?''selected'':'''') +'' value="R">R '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''L'')?''selected'':'''') +'' value="L">L '')');
      htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''T'')?''selected'':'''') +'' value="T">T '')');
      htp.p('}');
      htp.p('</SCRIPT>');
      --js TF
      htp.prn('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('</SCRIPT>');
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'

');
      if Pblockid is not null then
        htp.prn('
<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTW(document.RASDC_FIELDSONBLOCK.B10sqltext_1);
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
function onLoad() {
  onResize();
}
</SCRIPT>
<SCRIPT LANGUAGE="Javascript1.2">
function js_kliksubmit() {
  document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              ''';              
  document.RASDC_FIELDSONBLOCK.submit();
}

function ChUnCh(v1 , v2 ) {
var utf = v1.checked; var i; var uff; for (i = 1; i <= 16; i++) { if (document.getElementsByName("B20fieldid_"+i)[0] != null) { if (document.getElementsByName("B20fieldid_"+i)[0].value.length > 0) { document.getElementsByName(v2+"_"+i)[0].checked = utf; }  }  }
}

</SCRIPT>
<LINK rel="STYLESHEET" type="text/css" href="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/themes/base/jquery.ui.all.css">
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/js/jquery-1.9.1.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.core.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.widget.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.mouse.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.draggable.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.position.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.resizable.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.button.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.dialog.js"></SCRIPT>

<SCRIPT LANGUAGE="Javascript1.2">

 $(function() {
     addSpinner();   
  });
  
</SCRIPT>

<script type="text/javascript">
    $(document).ready(function () {
       $(".dialog").dialog({ autoOpen: false }); 
    });
</script>
</HEAD>
<BODY onload="onLoad();" onresize="onResize();">
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_FIELDSONBLOCK_LAB">');

htp.p(rasdc_hints.getHint('RASDC_BLOCKSONFORM_DIALOG',lang));
htp.p(rasdc_hints.getHint('RASDC_FIELDSONBLOCK_DIALOG',lang));

      RASDC_LIBRARY.showhead('RASDC_FIELDSONBLOCK',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
/*
<INPUT  class="SUBMIT" type="submit" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" name="ACTION" onclick="alert(''ddd'');  ">
<INPUT class="SUBMIT" type="submit" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" name="ACTION">
*/

     htp.prn('</FONT>

<FORM NAME="RASDC_FIELDSONBLOCK" id="RASDC_FIELDSONBLOCK" METHOD="POST" ACTION="!rasdc_fieldsonblock.program">
<P align="right">
<INPUT  type="hidden" name="ACTION" id="ACTION">
<INPUT NAME="SESSSTORAGEENABLED" TYPE="hidden" VALUE="1" CLASS="HIDDEN">
<input name="RECNUMB20" id="RECNUMB20" type="hidden" value="'||ltrim(to_char(RECNUMB20))||'"/>
<INPUT  class="SUBMIT" type="button" value="<<" onclick=" document.getElementById(''ACTION'').value=''<<''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value=">>'||stplus||'" onclick=" document.getElementById(''ACTION'').value=''>>''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true; ">
');
end if;
htp.prn(' 
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" name="ACTION">
' || predogled || '</P>

<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<TABLE BORDER="0" width="100%" style="');

              if b10rform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;

htp.prn('">
<CAPTION><B><FONT ID="B10_LAB">' ||
              RASDI_TRNSLT.text('Block', lang) ||
              '</FONT></B>
&nbsp;<SELECT NAME="Pblockid" CLASS="SELECT" onchange="js_kliksubmit();">');
      js_Pblockid_LOV(Pblockid, 'Pblockid');
      htp.prn('</SELECT>
<input type="text" size="30" name="PF" onchange="js_kliksubmit();" id="PF" value="'||pf||'" title="'||RASDI_TRNSLT.text('Form searcher ...', lang) ||'">      
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Submit', lang) || '"  onClick="js_kliksubmit();">
');
      rasdc_hints.link('RASDC_FIELDSONBLOCK', lang);
      htp.prn('
</CAPTION>
');
      if Pblockid is not null then
        htp.prn('
<TR>
<TD class="label" align="center"><FONT ID="B10blockid_LAB"> ' ||
                RASDI_TRNSLT.text('Block', lang) ||
                rasdc_hints.linkDialog('Block',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10sqltable_LAB"> ' ||
                RASDI_TRNSLT.text('Table, View, Synonym', lang) ||
                rasdc_hints.linkDialog('Table',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10numrows_LAB"> ' ||
                RASDI_TRNSLT.text('Rows', lang) ||
                rasdc_hints.linkDialog('Rows',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10emptyrows_LAB"> ' ||
                RASDI_TRNSLT.text('Empty rows', lang) ||
                rasdc_hints.linkDialog('Emptyrows',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10dbblockyn_LAB"> ' ||
                RASDI_TRNSLT.text('DB block', lang) ||
                rasdc_hints.linkDialog('DBblock',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10rowidyn_LAB"> ' ||
                RASDI_TRNSLT.text('RowID', lang) ||
                rasdc_hints.linkDialog('Rowid',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10pagingyn_LAB"> ' ||
                RASDI_TRNSLT.text('Bck / Fwd', lang) ||
                rasdc_hints.linkDialog('Bck',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10clearyn_LAB"> ' ||
                RASDI_TRNSLT.text('Clear', lang) ||
                rasdc_hints.linkDialog('Clear',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10label_LAB" color="red"> ' ||
                RASDI_TRNSLT.text('Block name', lang) ||
                rasdc_hints.linkDialog('Blockname',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD><FONT ID="B10LPROZILCI_LAB"> </FONT></TD></TR><TR ID="B10_BLOK"><INPUT NAME="B10RS_1" TYPE="HIDDEN" VALUE="' ||
                B10RS(1) ||
                '" CLASS="HIDDEN"><INPUT NAME="B10RID_1" TYPE="HIDDEN" VALUE="' ||
                B10RID(1) ||
                '" CLASS="HIDDEN"><INPUT NAME="B10formid_1" TYPE="HIDDEN" VALUE="' ||
                B10formid(1) ||
                '" CLASS="HIDDEN"><INPUT NAME="B10rform_1" TYPE="HIDDEN" VALUE="' ||
                B10rform(1) ||
                '" CLASS="HIDDEN">
<TD><INPUT NAME="B10blockid_1" TYPE="TEXT" VALUE="' ||
                B10blockid(1) ||
                '" CLASS="TEXT" size="10" maxlength="30"></TD>
<TD><SELECT NAME="B10sqltable_1" CLASS="SELECT">');
        js_B10sqltable_LOV(B10sqltable(1), 'B10sqltable_1');
        htp.prn('</SELECT></TD>
<TD><INPUT NAME="B10numrows_1" TYPE="TEXT" VALUE="' ||
                B10numrows(1) ||
                '" CLASS="TEXT" size="2" maxlength="5"></TD>
<TD><INPUT NAME="B10emptyrows_1" TYPE="TEXT" VALUE="' ||
                B10emptyrows(1) ||
                '" CLASS="TEXT" size="2" maxlength="5"></TD>
<TD><INPUT NAME="B10dbblockyn_1" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10dbblockyn(1), 'B10dbblockyn_1');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B10rowidyn_1" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10rowidyn(1), 'B10rowidyn_1');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B10pagingyn_1" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10pagingyn(1), 'B10pagingyn_1');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B10clearyn_1" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10clearyn(1), 'B10clearyn_1');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B10LABEL_1" TYPE="TEXT" VALUE="' ||
                B10label(1) || '" CLASS="TEXT" size="30" maxlength="100"></TD>
<TD><A HREF="javascript:location=');
        js_B10LPROZILCI_POV(B10LPROZILCI(1), 'B10LPROZILCI_1');
        htp.prn('" NAME="B10LPROZILCI_1" CLASS="A">' || B10LPROZILCI(1) ||
                '</A></TD></TR>
<TR><TD colspan="10"><TEXTAREA NAME="B10sqltext_1" id="B10sqltext_1" CLASS="TEXTAREA" style="FONT-SIZE: 8pt; font-face: Lucida Console" rows="4" cols="100">' ||
                B10sqltext(1) || '</TEXTAREA></TD></TR>

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
  /*    for r__ in (
                  select \*+ RULE*\ OBJECT_NAME id,
                          OBJECT_NAME || ' ... ' || substr(object_type, 1, 1) label,
                          2 x, o.owner
                    from all_objects o
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select \*+ RULE*\ distinct SYNONYM_NAME id,
                                   SYNONYM_NAME || ' ... S' label,
                                   2 x, s.table_owner owner
                    from all_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id,
                          owner||'.'||table_name  \*|| ' ... ' || substr(type, 1, 1)*\ label, 2 x, x.owner
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
      end loop;*/
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
  window.editor.setSize("100%","100");
};
</script>

');
      end if; /**/
      htp.prn('
</TABLE>
<TABLE BORDER="1" width="100%">
<CAPTION><B><FONT ID="B20_LAB">' ||
              RASDI_TRNSLT.text('Fields', lang) ||
              '</FONT></B></CAPTION><TR>
<TD class="label" align="center"><FONT ID="B20fieldid_LAB">' ||
              RASDI_TRNSLT.text('Field', lang) ||
              rasdc_hints.linkDialog('Field',lang,'RASDC_FIELDSONBLOCK_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20orderby_LAB">' ||
              RASDI_TRNSLT.text('Order', lang) ||
              rasdc_hints.linkDialog('Order',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20type_LAB">' ||
              RASDI_TRNSLT.text('Type', lang) ||
              rasdc_hints.linkDialog('Type',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20format_LAB">' ||
              RASDI_TRNSLT.text('Format(D,N)', lang) ||
              rasdc_hints.linkDialog('Format',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20pkyn_LAB">' ||
              RASDI_TRNSLT.text('PK', lang) ||
              rasdc_hints.linkDialog('PK',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20selectyn_LAB">' ||
              RASDI_TRNSLT.text('S', lang) ||
              rasdc_hints.linkDialog('S',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20selectyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20insertyn_LAB">' ||
              RASDI_TRNSLT.text('I', lang) ||
              rasdc_hints.linkDialog('I',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20insertyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20updateyn_LAB">' ||
              RASDI_TRNSLT.text('U', lang) ||
              rasdc_hints.linkDialog('U',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20updateyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20deleteyn_LAB">' ||
              RASDI_TRNSLT.text('D', lang) ||
              rasdc_hints.linkDialog('D',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20deleteyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20notnullyn_LAB">' ||
              RASDI_TRNSLT.text('Mn.', lang) ||
              rasdc_hints.linkDialog('Mn',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20notnullyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20insertnnyn_LAB">' ||
              RASDI_TRNSLT.text('In.', lang) ||
              rasdc_hints.linkDialog('In',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20insertnnyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20lockyn_LAB">' ||
              RASDI_TRNSLT.text('L', lang) ||
              rasdc_hints.linkDialog('L',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20lockyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20defaultval_LAB">' ||
              RASDI_TRNSLT.text('Default', lang) ||
              rasdc_hints.linkDialog('Default',lang,'RASDC_FIELDSONBLOCK_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20elementyn_LAB" color="red">' ||
              RASDI_TRNSLT.text('UI', lang) ||
              rasdc_hints.linkDialog('UI',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT><br/><input type="checkbox" onclick="ChUnCh(this,''B20elementyn'')" ></TD>
<TD class="label" align="center"><FONT ID="B20nameid_LAB" color="red">' ||
              RASDI_TRNSLT.text('UI field', lang) ||
              rasdc_hints.linkDialog('UIfield',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20label_LAB" color="red">' ||
              RASDI_TRNSLT.text('Label', lang) ||
              rasdc_hints.linkDialog('Label',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20ELEMENT_LAB" color="red">' ||
              RASDI_TRNSLT.text('Type', lang) ||
              rasdc_hints.linkDialog('Typered',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="b20includevis_LAB" color="red">' ||
              RASDI_TRNSLT.text('VS', lang) ||
              rasdc_hints.linkDialog('VS',lang,'RASDC_FIELDSONBLOCK_DIALOG')||
'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20linkid_LAB">' ||
              RASDI_TRNSLT.text('LOV/link', lang) || rasdc_hints.linkDialog('LOV',lang,'RASDC_FIELDSONBLOCK_DIALOG')||'</FONT></TD>
<TD class="label" align="center"></TD>
</TR>');
      for iB20 in 1 .. B20RS.count loop
        htp.prn('<TR ID="B20_BLOK" 
             onmouseover="javascript:style.backgroundColor=''#E9E9E9''" ');
             
                 if B20rform(iB20) is null then                   
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#ffffff''" bgcolor="#FFFFFF" ');
                 else 
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#aaccf7''" bgcolor="#aaccf7" ');                   
                 end if;             
             
        htp.prn('>
     <INPUT NAME="B20RS_' || iB20 ||
                '" TYPE="HIDDEN" VALUE="' || B20RS(iB20) ||
                '" CLASS="HIDDEN"><INPUT NAME="B20RID_' || iB20 ||
                '" TYPE="HIDDEN" VALUE="' || B20RID(iB20) ||
                '" CLASS="HIDDEN">
<TD><INPUT NAME="B20fieldid_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20fieldid(iB20) ||
                '" CLASS="TEXT" size="15" maxlength="30"></TD>
<TD><INPUT NAME="B20orderby_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20orderby(iB20) ||
                '" CLASS="TEXT" maxlength="5" size="2"></TD>
<TD><SELECT NAME="B20type_' || iB20 || '" CLASS="SELECT">');
        js_B20type_LOV(B20type(iB20), 'B20type_' || iB20 || '');
        htp.prn('</SELECT></TD>
<TD><INPUT NAME="B20format_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20format(iB20) ||
                '" CLASS="TEXT" maxlength="30" size="10"></TD>
<TD><INPUT NAME="B20pkyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20pkyn(iB20), 'B20pkyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20selectyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20selectyn(iB20),
                              'B20selectyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20insertyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20insertyn(iB20),
                              'B20insertyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20updateyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20updateyn(iB20),
                              'B20updateyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20deleteyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20deleteyn(iB20),
                              'B20deleteyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20notnullyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20notnullyn(iB20),
                              'B20notnullyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20insertnnyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20insertnnyn(iB20),
                              'B20insertnnyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20lockyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20lockyn(iB20), 'B20lockyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20defaultval_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20defaultval(iB20) ||
                '" CLASS="TEXT" size="5" maxlength="100"></TD>
<TD><INPUT NAME="B20elementyn_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20elementyn(iB20),
                              'B20elementyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20nameid_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20nameid(iB20) ||
                '" CLASS="TEXT" size="10" maxlength="100"></TD>
<TD><INPUT NAME="B20label_' || iB20 ||
                '" TYPE="TEXT" VALUE="' || B20label(iB20) ||
                '" CLASS="TEXT" size="20" maxlength="100"></TD>
<TD><SELECT NAME="B20ELEMENT_' || iB20 ||
                '" CLASS="SELECT">');
        js_B20ELEMENT_LOV(B20ELEMENT(iB20), 'B20ELEMENT_' || iB20 || '');
        htp.prn('</SELECT></TD>
<TD><INPUT NAME="b20includevis_' || iB20 ||
                '" TYPE="CHECKBOX" VALUE="');
        js_INPUT_CHECKBOX_DEF(b20includevis(iB20),
                              'b20includevis_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>        
<TD><SELECT NAME="B20linkid_' || iB20 ||
                '" CLASS="SELECT">');
        js_B20linkid_LOV(B20linkid(iB20), 'B20linkid_' || iB20 || '');
        htp.prn('</SELECT></TD>
<TD>
');
        if B20fieldid(iB20) is not null then
          htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                  RASDI_TRNSLT.text('Delete field', lang) || '"
onClick="document.RASDC_FIELDSONBLOCK.B20fieldid_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20orderby_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20format_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20defaultval_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20nameid_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20label_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20ELEMENT_' || iB20 ||
                  '.value='''';document.RASDC_FIELDSONBLOCK.B20linkid_' || iB20 ||
                  '.value='''';">
');
        end if;
        htp.prn('
</td>
</TR>');
      end loop;
      htp.prn('</TABLE>
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
<INPUT  class="SUBMIT" type="button" value="<<" onclick=" document.getElementById(''ACTION'').value=''<<''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value=">>'||stplus||'" onclick=" document.getElementById(''ACTION'').value=''>>''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_FIELDSONBLOCK.submit(); this.disabled = true; ">
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
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</BODY>
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
    --<ON_ACTION formid="5004" blockid="">
    rasdc_library.log('FIELSONBLOCK',pformid, 'START', vcom);
       
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
      v_form   varchar2(100);
      v_dummy  char(1);
    begin
      rasdi_client.secCheckPermission('RASDC_FIELDSONBLOCK', '');
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

        
        declare
          v number;
        begin
          
        select  nvl( count(*) - sum(decode(f.selectyn,'Y',0,'N',1,1)) , 1) into v
        from rasd_fields f, rasd_blocks b 
        where f.formid = pformid and f.blockid = Pblockid
        and f.formid(+) = b.formid and f.blockid(+) = b.blockid 
        and b.dbblockyn = 'Y';

        if v = 0 then
           sporocilo := 'At least one field should be checked at S(SELECT) when block is DB block.';
        end if; 
       
        end;
        sporocilo := nvl(sporocilo, 'Changes are saved.') || rasdc_library.checknumberofsubfields(PFORMID);
        
        if b10rform(1) is not null then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if; 
  elsif ACTION = '<<' then     
    if RECNUMB20 > 15 then
      RECNUMB20 := RECNUMB20-15;
    else
      RECNUMB20 := 1;
    end if;
    pselect;
    sporocilo := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,15))/15)+1);
  elsif ACTION = '>>' then
    RECNUMB20 := RECNUMB20+15 ;
    pselect;
    sporocilo := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,15))/15)+1);
      elsif action = RASDI_TRNSLT.text('Search', lang) then
        RECNUMB20 := 1;
        pselect;
    sporocilo := 'Page '||to_char( ((RECNUMB20 - mod(RECNUMB20,15))/15)+1);
      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;
      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        v_dummy := '1';
        rasdc_library.log('FIELSONBLOCK',pformid, 'COMMIT_S', vcom);   
        pcommit;    
        rasdc_library.log('FIELSONBLOCK',pformid, 'COMMIT_E', vcom);             
        v_dummy := '2';
        commit;
        rasdc_library.log('FIELSONBLOCK',pformid, 'REF_S', vcom);        
        rasdc_library.RefData(PFORMID);   
        rasdc_library.log('FIELSONBLOCK',pformid, 'REF_E', vcom);       
        rasdc_library.log('FIELSONBLOCK',pformid, 'SELECT_S', vcom);                  
        v_dummy := '3';
        pselect;
        v_dummy := '4';
        rasdc_library.log('FIELSONBLOCK',pformid, 'SELECT_E', vcom);       
        rasdc_library.log('FIELSONBLOCK',pformid, 'COMPILE_S', vcom);          
        begin
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
               and fg.editor = vup
               and (fg.lobid = rasdi_client.secGetLOB or
                   fg.lobid is null and rasdi_client.secGetLOB is null);
            v_dummy := '7';
            cid     := dbms_sql.open_cursor;
            v_dummy := '8';
            dbms_sql.parse(cid,
                           'begin ' || v_server || '.c_debug := false;'|| v_server || '.form(' || PFORMID ||
                           ',''' || lang || ''');end;',
                           dbms_sql.native);
            v_dummy := '9';
            n       := dbms_sql.execute(cid);
            v_dummy := 'A';
            dbms_sql.close_cursor(cid);
            v_dummy   := 'B';
            sporocilo := RASDI_TRNSLT.text('From is generated.', lang) || rasdc_library.checknumberofsubfields(PFORMID);

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
        rasdc_library.log('FIELSONBLOCK',pformid, 'COMPILE_E', vcom);          
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
      rasdc_library.log('FIELSONBLOCK',pformid, 'POUTPUT_S', vcom);       
      phtml;
      rasdc_library.log('FIELSONBLOCK',pformid, 'POUTPUT_E', vcom);       
      rasdc_library.log('FIELSONBLOCK',pformid, 'END', vcom);      
    end;

    --</ON_ACTION>
    --<ON_ERROR formid="5004" blockid="">
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
end RASDC_FIELDSONBLOCK;
/

