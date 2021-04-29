create or replace package RASDC_BLOCKSONFORM is
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
create or replace package body RASDC_BLOCKSONFORM is
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
  type ltab is table of clob index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin

    p_log := '/* Change LOG:
20210303 - Changes because change type of SQLTEXT
20200928 - Added Push 2 GIT (program shoud not have errors)    
20200410 - Added new compilation message     
20190617 - Added Form searcher    
20190325 - Optimization on Table, View,Synonym LOV. Now it is stored in Session Storage. To refresh it you should logout ot delete cookie rasdi$SESSSTORAGEENABLED.    
20181119 - Resolved bug on object listing (user_synonyms -> all_synonyms)   
20180420 - Added possibility to chose to create REST program .rest or BATCH program .main - default is Y.
20160704 - Added autodeletehtmlyn functionality      
20160629 - Added log function for RASD.     
20160627 - Included reference form future.     
20151202 - Included session variables in filters    
20151029 - Added function checknumberofsubfields        
20151001 - Added download XML    
20150814 - Added superuser
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20210303225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    SPOROCILO      varchar2(4000);
    ACTION         varchar2(4000);
    PFORMID        number;
    LANG           varchar2(4000);
    KOPIRAJBLOK    varchar2(4000);
    PREDOGLED      varchar2(4000);
    SESSSTORAGEENABLED   varchar2(100);
    B10formid      ntab;
    B10RS          ctab;
    B10form        ctab;
    B10text2id     ntab;
    B10version     ntab;
    B10change      dtab;
    B10label       ctab;
    B10PROGRAM     ctab;
    B10referenceyn ctab;
b10autodeletehtmlyn    ctab;
b10AUTOCREATERESTYN     ctab;
b10AUTOCREATEBATCHYN    ctab;
    B10LHTML1      ctab;
    B10LHTML2      ctab;
    B10LHTML3      ctab;
    B10LPROZILCI   ctab;
    B10LPOLJA      ctab;
    B20sqltext     ltab;
    B20source      ctab;
    B20RID         rtab;
    B20RS          ctab;
    B20formid      ctab;
    B20blockid     ctab;
    B20sqltable    ctab;
    B20numrows     ntab;
    B20emptyrows   ntab;
    B20dbblockyn   ctab;
    B20rowidyn     ctab;
    B20pagingyn    ctab;
    B20clearyn     ctab;
    B20label       ctab;
    B20LSQL        ctab;
    B20LPROZILCI   ctab;
    B20LCOPYBLOK   ctab;
    B20LPOLJA      ctab;
    B20vrstnired   ctab;
    B20rform   ctab;
    B30TEXT        ctab;
    vcom number;
    PF      varchar2(4000);
    PPAGES      varchar2(4000);

    
  procedure on_session is
    i__ pls_integer := 1;
  begin
 rasdi_client.sessionStart;    
  if ACTION is not null then
begin
rasdi_client.sessionSetValue('PF', pf ); 
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
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

 rasdi_client.sessionSetValue('SESSSTORAGEENABLED', to_char(sysdate, 'ddmmyyyyhh24miss') ); 

exception when others then null; end;
end if;

--end if;

 rasdi_client.sessionClose;
end;    
        
    
    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('SPOROCILO') then
          SPOROCILO := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('KOPIRAJBLOK') then
          KOPIRAJBLOK := value_array(i__);
        elsif upper(name_array(i__)) = upper('PPAGES') then
          PPAGES := value_array(i__);
        elsif upper(name_array(i__)) = upper('PF') then
          PF := value_array(i__);
        elsif upper(name_array(i__)) = upper('PREDOGLED') then
          PREDOGLED := value_array(i__);
        elsif upper(name_array(i__)) = upper('SESSSTORAGEENABLED') then
          SESSSTORAGEENABLED := value_array(i__); 
        elsif upper(name_array(i__)) =
              upper('B10formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10form_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10form(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10text2id_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10text2id(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10version_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10version(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10change_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10change(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := to_date(value_array(i__),
                                                                                                        rasdi_client.c_date_format);
        elsif upper(name_array(i__)) =
              upper('B10label_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10label(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10PROGRAM_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10PROGRAM(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10referenceyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10referenceyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10AUTOCREATERESTYN_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10AUTOCREATERESTYN(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);

        elsif upper(name_array(i__)) =
              upper('b10AUTOCREATEBATCHYN_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10AUTOCREATEBATCHYN(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10autodeletehtmlyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10autodeletehtmlyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);

        elsif upper(name_array(i__)) =
              upper('B10LHTML1_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LHTML1(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LHTML2_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LHTML2(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LHTML3_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LHTML3(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LPROZILCI_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LPROZILCI(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10LPOLJA_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10LPOLJA(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20sqltext_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20sqltext(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20source_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20blockid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20blockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20sqltable_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20sqltable(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20numrows_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20numrows(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20emptyrows_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20emptyrows(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20dbblockyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20dbblockyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20rowidyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20rowidyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20pagingyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20pagingyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20clearyn_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20clearyn(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20label_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20label(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20LSQL_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20LSQL(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20LPROZILCI_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20LPROZILCI(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20LCOPYBLOK_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20LCOPYBLOK(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20LPOLJA_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20LPOLJA(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30TEXT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30TEXT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10formid.count > v_max then
        v_max := B10formid.count;
      end if;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10form.count > v_max then
        v_max := B10form.count;
      end if;
      if B10text2id.count > v_max then
        v_max := B10text2id.count;
      end if;
      if B10version.count > v_max then
        v_max := B10version.count;
      end if;
      if B10change.count > v_max then
        v_max := B10change.count;
      end if;
      if B10label.count > v_max then
        v_max := B10label.count;
      end if;
      if B10PROGRAM.count > v_max then
        v_max := B10PROGRAM.count;
      end if;
      if B10referenceyn.count > v_max then
        v_max := B10referenceyn.count;
      end if;
      if b10AUTOCREATERESTYN.count > v_max then
        v_max := b10AUTOCREATERESTYN.count;
      end if;      
      if b10AUTOCREATEBATCHYN.count > v_max then
        v_max := b10AUTOCREATEBATCHYN.count;
      end if;      
      if b10autodeletehtmlyn.count > v_max then
        v_max := b10autodeletehtmlyn.count;
      end if;      
      if B10LHTML1.count > v_max then
        v_max := B10LHTML1.count;
      end if;
      if B10LHTML2.count > v_max then
        v_max := B10LHTML2.count;
      end if;
      if B10LHTML3.count > v_max then
        v_max := B10LHTML3.count;
      end if;
      if B10LPROZILCI.count > v_max then
        v_max := B10LPROZILCI.count;
      end if;
      if B10LPOLJA.count > v_max then
        v_max := B10LPOLJA.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B10formid.exists(i__) then
          B10formid(i__) := to_number(null);
        end if;
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10form.exists(i__) then
          B10form(i__) := null;
        end if;
        if not B10text2id.exists(i__) then
          B10text2id(i__) := to_number(null);
        end if;
        if not B10version.exists(i__) then
          B10version(i__) := to_number(null);
        end if;
        if not B10change.exists(i__) then
          B10change(i__) := to_date(null);
        end if;
        if not B10label.exists(i__) then
          B10label(i__) := null;
        end if;
        if not B10PROGRAM.exists(i__) then
          B10PROGRAM(i__) := null;
        end if;
        if not B10referenceyn.exists(i__) or B10referenceyn(i__) is null then
          B10referenceyn(i__) := 'N';
        end if;
        if not b10autodeletehtmlyn.exists(i__) or b10autodeletehtmlyn(i__) is null then
          b10autodeletehtmlyn(i__) := 'N';
        end if;  
        if not b10AUTOCREATERESTYN.exists(i__) or b10AUTOCREATERESTYN(i__) is null then
          b10AUTOCREATERESTYN(i__) := 'N';
        end if;  
        if not b10AUTOCREATEBATCHYN.exists(i__) or b10AUTOCREATEBATCHYN(i__) is null then
          b10AUTOCREATEBATCHYN(i__) := 'N';
        end if;  
        if not B10LHTML1.exists(i__) then
          B10LHTML1(i__) := null;
        end if;
        if not B10LHTML2.exists(i__) then
          B10LHTML2(i__) := null;
        end if;
        if not B10LHTML3.exists(i__) then
          B10LHTML3(i__) := null;
        end if;
        if not B10LPROZILCI.exists(i__) then
          B10LPROZILCI(i__) := null;
        end if;
        if not B10LPOLJA.exists(i__) then
          B10LPOLJA(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if B20sqltext.count > v_max then
        v_max := B20sqltext.count;
      end if;
      if B20source.count > v_max then
        v_max := B20source.count;
      end if;
      if B20RID.count > v_max then
        v_max := B20RID.count;
      end if;
      if B20RS.count > v_max then
        v_max := B20RS.count;
      end if;
      if B20formid.count > v_max then
        v_max := B20formid.count;
      end if;
      if B20blockid.count > v_max then
        v_max := B20blockid.count;
      end if;
      if B20sqltable.count > v_max then
        v_max := B20sqltable.count;
      end if;
      if B20numrows.count > v_max then
        v_max := B20numrows.count;
      end if;
      if B20emptyrows.count > v_max then
        v_max := B20emptyrows.count;
      end if;
      if B20dbblockyn.count > v_max then
        v_max := B20dbblockyn.count;
      end if;
      if B20rowidyn.count > v_max then
        v_max := B20rowidyn.count;
      end if;
      if B20pagingyn.count > v_max then
        v_max := B20pagingyn.count;
      end if;
      if B20clearyn.count > v_max then
        v_max := B20clearyn.count;
      end if;
      if B20label.count > v_max then
        v_max := B20label.count;
      end if;
      if B20vrstnired.count > v_max then
        v_max := B20vrstnired.count;
      end if;    
      if B20rform.count > v_max then
        v_max := B20rform.count;
      end if;          
      if B20LSQL.count > v_max then
        v_max := B20LSQL.count;
      end if;
      if B20LPROZILCI.count > v_max then
        v_max := B20LPROZILCI.count;
      end if;
      if B20LCOPYBLOK.count > v_max then
        v_max := B20LCOPYBLOK.count;
      end if;
      if B20LPOLJA.count > v_max then
        v_max := B20LPOLJA.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B20sqltext.exists(i__) then
          B20sqltext(i__) := null;
        end if;
        if not B20source.exists(i__) then
          B20source(i__) := null;
        end if;
        if not B20RID.exists(i__) then
          B20RID(i__) := null;
        end if;
        if not B20RS.exists(i__) then
          B20RS(i__) := null;
        end if;
        if not B20formid.exists(i__) then
          B20formid(i__) := null;
        end if;
        if not B20blockid.exists(i__) then
          B20blockid(i__) := null;
        end if;
        if not B20sqltable.exists(i__) then
          B20sqltable(i__) := null;
        end if;
        if not B20numrows.exists(i__) then
          B20numrows(i__) := to_number(null);
        end if;
        if not B20emptyrows.exists(i__) then
          B20emptyrows(i__) := to_number(null);
        end if;
        if not B20dbblockyn.exists(i__) or B20dbblockyn(i__) is null then
          B20dbblockyn(i__) := 'N';
        end if;
        if not B20rowidyn.exists(i__) or B20rowidyn(i__) is null then
          B20rowidyn(i__) := 'N';
        end if;
        if not B20pagingyn.exists(i__) or B20pagingyn(i__) is null then
          B20pagingyn(i__) := 'N';
        end if;
        if not B20clearyn.exists(i__) or B20clearyn(i__) is null then
          B20clearyn(i__) := 'N';
        end if;
        if not B20label.exists(i__) then
          B20label(i__) := null;
        end if;
        if not B20vrstnired.exists(i__) then
          B20vrstnired(i__) := null;
        end if;
        if not B20rform.exists(i__) then
          B20rform(i__) := null;
        end if;
        if not B20LSQL.exists(i__) then
          B20LSQL(i__) := null;
        end if;
        if not B20LPROZILCI.exists(i__) then
          B20LPROZILCI(i__) := null;
        end if;
        if not B20LCOPYBLOK.exists(i__) then
          B20LCOPYBLOK(i__) := null;
        end if;
        if not B20LPOLJA.exists(i__) then
          B20LPOLJA(i__) := null;
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
      if action is null then action := RASDI_TRNSLT.text('Search', lang); end if;
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
        B10formid(j__) := null;
        B10RS(j__) := null;
        B10form(j__) := null;
        B10text2id(j__) := null;
        B10version(j__) := null;
        B10change(j__) := null;
        B10label(j__) := null;
        B10PROGRAM(j__) := null;
        B10referenceyn(j__) := null;
        b10autodeletehtmlyn(j__)  := null;    
        b10AUTOCREATERESTYN(j__)  := null;    
        b10AUTOCREATEBATCHYN(j__)  := null;    
        B10LHTML1(j__) := null;
        B10LHTML2(j__) := null;
        B10LHTML3(j__) := null;
        B10LPROZILCI(j__) := null;
        B10LPOLJA(j__) := null;

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
        B20sqltext(j__) := null;
        B20source(j__) := null;
        B20RID(j__) := null;
        B20RS(j__) := null;
        B20formid(j__) := null;
        B20blockid(j__) := null;
        B20sqltable(j__) := null;
        B20numrows(j__) := null;
        B20emptyrows(j__) := null;
        B20dbblockyn(j__) := null;
        B20rowidyn(j__) := null;
        B20pagingyn(j__) := null;
        B20clearyn(j__) := null;
        B20label(j__) := null;
        B20vrstnired(j__) := null;
        B20rform(j__) := null;
        B20LSQL(j__) := ' ';
        B20LPROZILCI(j__) := ' ';
        B20LCOPYBLOK(j__) := ' ';
        B20LPOLJA(j__) := ' ';
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
      SPOROCILO   := null;
      ACTION      := null;
      PFORMID     := null;
      LANG        := null;
      KOPIRAJBLOK := null;
      PF := null;
      PPAGES := null;            
      PREDOGLED   := null;
      SESSSTORAGEENABLED := null;
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
      B10formid.delete;
      B10RS.delete;
      B10form.delete;
      B10text2id.delete;
      B10version.delete;
      B10change.delete;
      B10label.delete;
      B10PROGRAM.delete;
      B10referenceyn.delete;
      b10autodeletehtmlyn.delete;
      b10AUTOCREATERESTYN.delete;
      b10AUTOCREATEBATCHYN.delete;        
      B10LHTML1.delete;
      B10LHTML2.delete;
      B10LHTML3.delete;
      B10LPROZILCI.delete;
      B10LPOLJA.delete;
      --<pre_select formid="5003" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="5003" blockid="B10">
          SELECT formid,
                 form,
                 text2id,
                 version,
                 label,
                 PROGRAM,
                 referenceyn,
                 autodeletehtmlyn,
                 f.autocreaterestyn,
                 f.autocreatebatchyn
            FROM RASD_FORMS f
           where formid = PFORMID
           order by form
          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10formid(i__),
                 B10form(i__),
                 B10text2id(i__),
                 B10version(i__),
                 B10label(i__),
                 B10PROGRAM(i__),
                 B10referenceyn(i__),
                 b10autodeletehtmlyn(i__),
                 b10AUTOCREATERESTYN(i__),
                 b10AUTOCREATEBATCHYN(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10change(i__) := null;
            B10LHTML1(i__) := null;
            B10LHTML2(i__) := null;
            B10LHTML3(i__) := null;
            B10LPROZILCI(i__) := null;
            B10LPOLJA(i__) := null;
            B10RS(i__) := 'U';

            --<post_select formid="5003" blockid="B10">
            declare
              v_st number;
            begin

              B10LHTML1(i__) := '<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('HTML download', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumbhtmld.jpg" width=21 border=0 >';
              B10LHTML3(i__) := '<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('PL/SQL download', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumbplsql.jpg" width=21 border=0 >';

              if b10text2id(i__) is null then
                B10LHTML2(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('HTML upload', lang) ||
                                  '" src="rasdc_files.showfile?pfile=pict/gumbhtmlu.jpg" width=21 border=0 >';
              else
                B10LHTML2(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('HTML upload', lang) ||
                                  '" src="rasdc_files.showfile?pfile=pict/gumbhtmlured.jpg" width=21 border=0 >';
              end if;

              select count(*)
                into v_st
                from RASD_TRIGGERS
               where formid = PFORMID
                 and blockid is null;
              if v_st = 0 then
                B10LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Form triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbproz.jpg" width=23 border=0 >';
              else
                B10LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Form triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbprozred.jpg" width=23 border=0 >';
              end if;

              select count(*)
                into v_st
                from RASD_FIELDS
               where formid = PFORMID
                 and blockid is null;
              if v_st = 0 then
                B10LPOLJA(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Fields of form', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpod.jpg" width=21 border=0 >';
              else
                B10LPOLJA(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Fields of form', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpodred.jpg" width=21 border=0 >';
              end if;

            end;
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10formid.delete(1);
          B10RS.delete(1);
          B10form.delete(1);
          B10text2id.delete(1);
          B10version.delete(1);
          B10change.delete(1);
          B10label.delete(1);
          B10PROGRAM.delete(1);
          B10referenceyn.delete(1);
          b10autodeletehtmlyn.delete(1);
          b10AUTOCREATERESTYN.delete(1);
          b10AUTOCREATEBATCHYN.delete(1);          
          B10LHTML1.delete(1);
          B10LHTML2.delete(1);
          B10LHTML3.delete(1);
          B10LPROZILCI.delete(1);
          B10LPOLJA.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10formid.count);
      null;
    end;
    procedure pselect_B20 is
      i__ pls_integer;
    begin
      B20sqltext.delete;
      B20source.delete;
      B20RID.delete;
      B20RS.delete;
      B20formid.delete;
      B20blockid.delete;
      B20sqltable.delete;
      B20numrows.delete;
      B20emptyrows.delete;
      B20dbblockyn.delete;
      B20rowidyn.delete;
      B20pagingyn.delete;
      B20clearyn.delete;
      B20label.delete;
      B20LSQL.delete;
      B20LPROZILCI.delete;
      B20LCOPYBLOK.delete;
      B20LPOLJA.delete;
      B20vrstnired.delete;
      B20rform.delete;
      --<pre_select formid="5003" blockid="B20">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="5003" blockid="B20">
          select sqltext,
                 RID,
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
                 vrstnired,
                 rform
            from (SELECT distinct to_char(substr(b.sqltext,1,1)) sqltext,
                                  b.ROWID RID,
                                  b.formid,
                                  b.blockid,
                                  b.sqltable,
                                  b.numrows,
                                  b.emptyrows,
                                  b.dbblockyn,
                                  b.rowidyn,
                                  b.pagingyn,
                                  b.clearyn,
                                  b.label,
                                  nvl(min(f.orderby), 0) vrstnired,
                                  b.rform
                    FROM RASD_BLOCKS b, RASD_FIELDS f
                   where b.formid = B10formid(1)
                     and b.formid = f.formid(+)
                     and b.blockid = f.blockid(+)
                     and b.blockid in 
(select x.blockid from rasd_triggers x where upper(x.triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%') and formid = pformid
union
select blockid  from rasd_links l, rasd_fields f where upper(l.linkid||':'||l.link||':'||l.text) like upper('%'||pf||'%') and l.formid = pformid and l.formid = f.formid and l.linkid = f.linkid
union
select blockid  from rasd_fields f where upper(f.fieldid||':'||f.blockid||':'||f.defaultval||':'||nameid||':'||label) like upper('%'||pf||'%') and formid = pformid
union
select blockid from rasd_blocks where upper(blockid||':'||sqltable||':'||sqltext||':'||label) like upper('%'||pf||'%') and formid = pformid
)                     
                     and (b.blockid in 
(select a.blockid from rasd_pages a where a.page = to_number(ppages) and formid = pformid )    or ppages is null )                 

                   group by to_char(substr(b.sqltext,1,1)),
                            b.ROWID,
                            b.formid,
                            b.blockid,
                            b.sqltable,
                            b.numrows,
                            b.emptyrows,
                            b.dbblockyn,
                            b.rowidyn,
                            b.pagingyn,
                            b.clearyn,
                            b.label ,
                            b.rform                           
                   order by vrstnired)
          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B20sqltext(i__),
                 B20RID(i__),
                 B20formid(i__),
                 B20blockid(i__),
                 B20sqltable(i__),
                 B20numrows(i__),
                 B20emptyrows(i__),
                 B20dbblockyn(i__),
                 B20rowidyn(i__),
                 B20pagingyn(i__),
                 B20clearyn(i__),
                 B20label(i__),
                 B20vrstnired(i__),
                 B20rform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B20source(i__) := null;
            B20RS(i__) := null;
            B20LSQL(i__) := null;
            B20LPROZILCI(i__) := null;
            B20LCOPYBLOK(i__) := null;
            B20LPOLJA(i__) := null;
            B20RS(i__) := 'U';

            --<post_select formid="5003" blockid="B20">
            B20sqltable(i__) := upper(b20sqltable(i__));
            B20blockid(i__) := upper(B20blockid(i__));

            declare
              v_st number;
            begin

              if b20sqltext(i__) is null then
                B20LSQL(i__) := '<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('SQL', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumbsql.jpg" width=21 border=0 >';
              else
                B20LSQL(i__) := '<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('SQL', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumbsqlred.jpg" width=21 border=0 >';
              end if;

              select count(*)
                into v_st
                from RASD_TRIGGERS
               where formid = PFORMID
                 and blockid = b20blockid(i__);
              if v_st = 0 then
                B20LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Block triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbproz.jpg" width=23 border=0 >';
              else
                B20LPROZILCI(i__) := '<IMG height=20 title="' ||
                                     RASDI_TRNSLT.text('Block triggers',
                                                       lang) ||
                                     '" src ="rasdc_files.showfile?pfile=pict/gumbprozred.jpg" width=23 border=0 >';
              end if;

              select count(*)
                into v_st
                from RASD_FIELDS
               where blockid = b20blockid(i__)
                 and formid = PFORMID;
              if v_st = 0 then
                B20LPOLJA(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Fields of block', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpod.jpg" width=21 border=0 >';
              else
                B20LPOLJA(i__) := '<IMG height=20 title="' ||
                                  RASDI_TRNSLT.text('Fields of block', lang) ||
                                  '" src ="rasdc_files.showfile?pfile=pict/gumbpodred.jpg" width=21 border=0 >';
              end if;

              B20LCOPYBLOK(i__) := '<IMG height=20 title="' ||
                                   RASDI_TRNSLT.text('Copy block', lang) ||
                                   '" src ="rasdc_files.showfile?pfile=pict/gumbcopyblok.jpg" width=21 border=0 >';

            end;
            --</post_select>
            

            
            i__ := i__ + 1;
          end if;
        END LOOP;
        
        if c__%rowcount < 1 then
          B20sqltext.delete(1);
          B20source.delete(1);
          B20RID.delete(1);
          B20RS.delete(1);
          B20formid.delete(1);
          B20blockid.delete(1);
          B20sqltable.delete(1);
          B20numrows.delete(1);
          B20emptyrows.delete(1);
          B20dbblockyn.delete(1);
          B20rowidyn.delete(1);
          B20pagingyn.delete(1);
          B20clearyn.delete(1);
          B20label.delete(1);
          B20LSQL.delete(1);
          B20LPROZILCI.delete(1);
          B20LCOPYBLOK.delete(1);
          B20LPOLJA.delete(1);
          B20vrstnired.delete(1);
          B20rform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B20(B20sqltext.count);
      null;
    end;
    procedure pselect_B30 is
      i__ pls_integer;
    begin
      B30TEXT.delete;
      --<pre_select formid="5003" blockid="B30">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select '<A HREF="javascript:var x = window.open(encodeURI(''!RASDC_ERRORS.Program?PPROGRAM=' ||
                 upper(name) || '#' || substr(type, 1, 1) ||
                 substr(type, instr(type, ' ') + 1, 1) || to_char(line) ||
                 '''),''nx'','''');"  style="color: Red;">ERR: (' ||
                 to_char(line) || ',' || to_char(position) || ')  ' || text ||
                 '</A>' text
            from all_errors
           where upper(name) = upper(b10form(1))
             and owner = rasdc_library.currentDADUser
           order by line, position;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B30TEXT(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then

            --<post_select formid="5003" blockid="B30">
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
      for i__ in 1 .. B10formid.count loop
        --<on_validate formid="5003" blockid="B10">
        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          null;
        else
          -- UPDATE ali DELETE;

          --<pre_update formid="5003" blockid="B10">
          B10change(i__) := sysdate;
          update RASD_ATTRIBUTES a
             set value = B10label(i__), source = 'G'
           where formid = B10formid(i__)
             and elementid =
                 (select min(elementid)
                    from RASD_ELEMENTS e, RASD_FORMS f
                   where f.formid = B10formid(i__)
                     and e.formid = f.formid
                     and e.nameid = f.form || '_LAB')
             and type = 'V';
          --</pre_update>
          update RASD_FORMS f
             set change      = B10change(i__),
                 label       = B10label(i__),
                 PROGRAM     = B10PROGRAM(i__),
                 autodeletehtmlyn = B10autodeletehtmlyn(i__),
                f.autocreaterestyn = b10AUTOCREATERESTYN(i__),
                f.autocreatebatchyn = b10AUTOCREATEBATCHYN(i__)
           where formid = B10formid(i__);
          --<post_update formid="5003" blockid="B10">
          --</post_update>
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit_B20 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B20RID.count loop
        --<on_validate formid="5003" blockid="B20">
        --</on_validate>
        if substr(B20RS(i__), 1, 1) = 'I' then
          --INSERT
          if B20blockid(i__) is not null or B20sqltable(i__) is not null or
             B20numrows(i__) is not null or B20emptyrows(i__) is not null or
             B20label(i__) is not null then
            --<pre_insert formid="5003" blockid="B20">
            -- priprava id-jev za blok
            B20formid(i__) := B10formid(1);
            B20source(i__) := 'V';
            if B20numrows(i__) is null then
              B20numrows(i__) := 1;
            end if;
            B20blockid(i__) := rasdc_library.prepareName(B20blockid(i__));

            --</pre_insert>
            insert into RASD_BLOCKS
              (source,
               formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label)
            values
              (B20source(i__),
               B20formid(i__),
               upper(B20blockid(i__)),
               B20sqltable(i__),
               B20numrows(i__),
               B20emptyrows(i__),
               B20dbblockyn(i__),
               B20rowidyn(i__),
               B20pagingyn(i__),
               B20clearyn(i__),
               B20label(i__));
            --<post_insert formid="5003" blockid="B20">
            RASDC_LIBRARY.insertFields(PFORMID, upper(b20blockid(i__)), lang);
            --</post_insert>
            null;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if B20blockid(i__) is null then
            --DELETE
            --<pre_delete formid="5003" blockid="B20">
            declare
              v_blockid RASD_BLOCKS.blockid%type;
            begin
              select blockid
                into v_blockid
                from RASD_BLOCKS
               where rowid = b20rid(i__) and rform is null;
              RASDC_LIBRARY.deleteBlock(PFORMID, v_blockid);
            exception when others then null;  
            end;

            --</pre_delete>
            delete RASD_BLOCKS where ROWID = B20RID(i__) and rform is null;
            --<post_delete formid="5003" blockid="B20">
            --</post_delete>
          else
            
            --UPDATE
            --<pre_update formid="5003" blockid="B20">
            declare
              v_blockid RASD_BLOCKS.blockid%type;
            begin
              select blockid
                into v_blockid
                from RASD_BLOCKS
               where rowid = b20rid(i__) and rform is null;
              if v_blockid <> b20blockid(i__) then
                RASDC_LIBRARY.changeBlock(PFORMID,
                                            v_blockid,
                                            PFORMID,
                                            b20blockid(i__),
                                            B20label(i__));
                null;
              end if;
            exception when others then
               null;  
            end;

            --</pre_update>
            update RASD_BLOCKS
               set blockid   = B20blockid(i__),
                   sqltable  = B20sqltable(i__),
                   numrows   = B20numrows(i__),
                   emptyrows = B20emptyrows(i__),
                   dbblockyn = B20dbblockyn(i__),
                   rowidyn   = B20rowidyn(i__),
                   pagingyn  = B20pagingyn(i__),
                   clearyn   = B20clearyn(i__),
                   label     = B20label(i__)
             where ROWID = B20RID(i__) and rform is null ;
            --<post_update formid="5003" blockid="B20">
            if b20rform is null then
                RASDC_LIBRARY.insertfields(PFORMID, b20blockid(i__), lang);
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
    procedure pcommit_B30 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B30TEXT.count loop
        --<on_validate formid="5003" blockid="B30">
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
      --<pre_commit formid="5003" blockid="">
      --</pre_commit>
      if 1 = 1 then
        null;
        pcommit_B10;
      end if;
      if 1 = 1 then
        pcommit_B20;
        null;
      end if;
      if 1 = 1 then
        pcommit_B30;
        null;
      end if;
      --<post_commit formid="5003" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB20 pls_integer;
      iB30 pls_integer;
      --povezavein
      procedure js_B10text1_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LHTML1%' then
          htp.prn('''RASDC_FILES.download?PDATOTEKA=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''RASDC_FILES.download?PDATOTEKA=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B10text3_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LHTML3%' then
          htp.prn('''RASDC_FILES.downloadplsql?PDATOTEKA=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''RASDC_FILES.downloadplsql?PDATOTEKA=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B10text2_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LHTML2%' then
          htp.prn('''RASDC_FILES.upload?PLANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''RASDC_FILES.upload?PLANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B10LPOLJA_POV(value varchar2,
                                 name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LPOLJA%' then
          htp.prn('''!rasdc_fieldsonblock.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_fieldsonblock.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B20LPOLJA_POV(value varchar2,
                                 name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B20LPOLJA%' then
          htp.prn('''!rasdc_fieldsonblock.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) ||
                  '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_' ||
                  substr(name, instr(name, '_', -1) + 1) || '.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_fieldsonblock.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_1.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B10LPROZILCI_POV(value varchar2,
                                    name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B10LPROZILCI%' then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B20LPROZILCI_POV(value varchar2,
                                    name  varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B20LPROZILCI%' then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) ||
                  '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_' ||
                  substr(name, instr(name, '_', -1) + 1) || '.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_triggers.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_1.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      procedure js_B20LSQL_POV(value varchar2, name varchar2 default null) is
      begin
        if 1 = 2 then
          null;
        elsif name like 'B20LSQL%' then
          htp.prn('''!rasdc_sql.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) ||
                  '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_' ||
                  substr(name, instr(name, '_', -1) + 1) || '.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        elsif name is null then
          htp.prn('''!rasdc_sql.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) || '&LANG=''+document.RASDC_BLOCKSONFORM.LANG.value+
''&Pblockid=''+document.RASDC_BLOCKSONFORM.B20blockid_1.value+
''&PFORMID=''+document.RASDC_BLOCKSONFORM.PFORMID.value+
''''');
        end if;
      end;
      --SQL
      procedure js_B20sqltable_LOV(value varchar2,
                                   name  varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_B20sqltable_LOV(''' || value || ''');');
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
      
      procedure js_PPAGES_LOV(value varchar2, name varchar2 default null) is
      begin
        htp.p('<SCRIPT LANGUAGE="JavaScript">');
        htp.p('js_PPAGES_LOV(''' || value || ''');');
        htp.p('</SCRIPT>');
      end;      
      --SQL-T
    begin
      --js povezavein
      --js SQL
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_B20sqltable_LOV(pvalue) {');
      htp.p('var v_output = "";');
      
      for r__ in (
                  --<LOVSQL formid="5003" linkid="B20sqltable_LOV">
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
        htp.p('var v_output = "";');

      if SESSSTORAGEENABLED is null then

      for r__ in (
                  --<LOVSQL formid="5003" linkid="B20sqltable_LOV">
                  /* select '' id, '' label, 1 x
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
                          owner||'.'||table_name  /*|| ' ... ' || substr(type, 1, 1) */ label, 2 x
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and
                    grantee = rasdc_library.currentDADUser  
                 /*union 
                   select b.sqltable, sqltable || ' ... F' , 3
                   from rasd_blocks b where b.formid = PFORMID 
                   and b.sqltable is not null 
                   and b.sqltable not in  (
                  select /*+ RULE*-/ OBJECT_NAME id
                    from all_objects
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select /*+ RULE*-/ distinct SYNONYM_NAME id
                    from all_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and 
                    grantee = rasdc_library.currentDADUser                    
                   )    */                
                   order by 3, 1
                  --</LOVSQL>
                  ) loop
--        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' || r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||  r__.label || ' '')');
        htp.p('  v_output = v_output + ''<OPTION CLASS=selectp value="' || r__.id || '">' ||  r__.label || '</OPTION> ''; ');
      end loop;
      
      htp.p('sessionStorage.setItem("rasdi$B20sqltable_LOV",v_output);');
      htp.p('document.getElementsByName("SESSSTORAGEENABLED").value="1";');

      else
      
      htp.p('v_output = sessionStorage.getItem("rasdi$B20sqltable_LOV");');
       
      end if;
      htp.p('if (v_output != null) { v_output = v_output.replace(''value="''+pvalue+''"'', ''value="''+pvalue+''" selected'' ); }');
      
      htp.p('document.write(v_output);');
      htp.p('}');
      --
      htp.prn('</SCRIPT>');
      --js TEXT
      --js TF
      htp.prn('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('</SCRIPT>');

      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function js_PPAGES_LOV(pvalue) {');
      for r__ in (
                  --<LOVSQL formid="5004" linkid="Pblockid_LOV">
                  select '' id, '' label, -1000 vr
                    from dual
                  union
                  select distinct to_char(page) id, RASDI_TRNSLT.text('Page', lang)||' '||to_char(page) label, page vr
                  from rasd_pages where formid = PFORMID
                   order by 3, 1
                  --</LOVSQL>
                  ) loop
        htp.p('  document.write(''<OPTION CLASS=selectp ''+ ((pvalue==''' ||
              r__.id || ''')?''selected'':'''') +'' value="' || r__.id || '">' ||
              r__.label || ' '')');
      end loop;
      htp.p('}');
      htp.prn('</SCRIPT>');

      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<SCRIPT LANGUAGE="Javascript1.2">
function js_kliksubmit() {
  document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              ''';              
  document.RASDC_BLOCKSONFORM.submit();
}
</SCRIPT>

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
</head>
<BODY>
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_BLOCKSONFORM_LAB">');

htp.p(rasdc_hints.getHint('RASDC_BLOCKSONFORM_DIALOG',lang));

      RASDC_LIBRARY.showhead('RASDC_BLOCKSONFORM',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
      htp.prn('</FONT>
<FORM NAME="RASDC_BLOCKSONFORM" METHOD="post" ACTION="!rasdc_blocksonform.program">
<P align="right">
<INPUT  type="hidden" name="ACTION" id="ACTION">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_BLOCKSONFORM.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_BLOCKSONFORM.submit(); this.disabled = true; ">
');
end if;
htp.prn('              
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" name="ACTION">
' || predogled || '</P>

<INPUT NAME="PFORMID" TYPE="hidden" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN"><INPUT NAME="LANG" TYPE="hidden" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="SESSSTORAGEENABLED" TYPE="hidden" VALUE="1" CLASS="HIDDEN">
<INPUT NAME="KOPIRAJBLOK" TYPE="hidden" VALUE CLASS="HIDDEN">
<TABLE BORDER="0">
<CAPTION><B><FONT ID="B10_LAB"></FONT></B></CAPTION><TR>
<TD class="label" align="center"><FONT ID="B10form_LAB">' ||
              RASDI_TRNSLT.text('Form', lang) ||
              rasdc_hints.linkDialog('Form',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10version_LAB">' ||
              RASDI_TRNSLT.text('Version', lang) ||
              rasdc_hints.linkDialog('Version',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10label_LAB" color="red">' ||
              RASDI_TRNSLT.text('Name', lang) ||
               rasdc_hints.linkDialog('Name',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10PROGRAM_LAB" color="red"> ' ||
              RASDI_TRNSLT.text('Post action', lang) ||
               rasdc_hints.linkDialog('Postaction',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B10autodeletehtmlyn_LAB"> ' ||
              RASDI_TRNSLT.text('Auto delete HTML', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="b10AUTOCREATERESTYN_LAB"> ' ||
              RASDI_TRNSLT.text('Create REST program .rest', lang) ||
              '</FONT></TD>
<TD class="label" align="center"><FONT ID="b10AUTOCREATEBATCHYN_LAB"> ' ||
              RASDI_TRNSLT.text('Create BATCH program .main', lang) ||
              '</FONT></TD>
<TD><FONT ID="B10LHTML1_LAB"> </FONT></TD>
<TD><FONT ID="B10LHTML2_LAB"> </FONT></TD>
<TD><FONT ID="B10LPROZILCI_LAB"> </FONT></TD>
<TD><FONT ID="B10LPOLJA_LAB"> </FONT></TD></TR><TR ID="B10_BLOK"><INPUT NAME="B10formid_1" TYPE="hidden" VALUE="' ||
              B10formid(1) ||
              '" CLASS="HIDDEN"><INPUT NAME="B10RS_1" TYPE="hidden" VALUE="' ||
              B10RS(1) || '" CLASS="HIDDEN">
<TD><FONT ID="B10FORM_1" CLASS="FONT">' || B10form(1) ||
              '</FONT></TD>
<TD><FONT ID="B10VERSION_1" CLASS="FONT">' || B10version(1) ||
              '</FONT></TD>
<TD><INPUT NAME="B10LABEL_1" VALUE="' || B10label(1) ||
              '" CLASS="TEXT"  size="50" maxLength="100"></TD>
<TD><INPUT NAME="B10PROGRAM_1" VALUE="' || B10PROGRAM(1) ||
              '" CLASS="TEXT"  size="30" maxLength="100"></TD>
<TD><INPUT NAME="B10autodeletehtmlyn_1" TYPE="checkbox" VALUE="');
      js_INPUT_CHECKBOX_DEF(B10autodeletehtmlyn(1), 'B10autodeletehtmlyn_1');
      htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="b10AUTOCREATERESTYN_1" TYPE="checkbox" VALUE="');
      js_INPUT_CHECKBOX_DEF(b10AUTOCREATERESTYN(1), 'b10AUTOCREATERESTYN_1');
      htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="b10AUTOCREATEBATCHYN_1" TYPE="checkbox" VALUE="');
      js_INPUT_CHECKBOX_DEF(b10AUTOCREATEBATCHYN(1), 'b10AUTOCREATEBATCHYN_1');
      htp.prn('" CLASS="CHECKBOX"></TD>
<!--TD>
<A class="A" href="javascript: location=encodeURI(');
      js_B10text1_POV(B10LHTML1(1), 'B10LHTML1_1');
      htp.prn(')" name="B10LHTML1_1">' || B10LHTML1(1) ||
              '</A></TD--!>
<!--TD><A class="A" href="javascript: var p_x=window.open(encodeURI(');
      js_B10text2_POV(B10LHTML2(1), 'B10LHTML2_1');
      htp.prn('),''p_x'',''width=400,height=250,scrolbars=0'')" name="B10LHTML2_1">' ||
              B10LHTML2(1) || '</A></TD--!>
<td><A class="A" href="javascript: location=encodeURI(''!rasdc_references.webclient?LANG='||lang||'&PFORMID='||pformid||''');" name="B10REF_1">
<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('Form references', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumblink'||B10referenceyn(1)||'.jpg" width=21 border=0 >
</A>
</td>');
if  rasdc_git.getGitLocation is not null 
 and  RASDC_LIBRARY.formhaserrors(B10form(1))=false 
 and  rasdc_library.allowEditing(pformid) 
  then
htp.p('<td><A class="A" '); 
htp.p(' href="javascript: var p_y = window.open(encodeURI(''!rasdc_git.program?ACTION=' ||
                  RASDI_TRNSLT.text('Search', lang) ||'LANG='||lang||'&Pblockid=X&PFORMID='||pformid||'''),''p_y'',''width=700,height=400,resizable=1'');"');
htp.p(' name="B10GIT_1">
<IMG height=20 title="' ||
                                RASDI_TRNSLT.text('Push 2 GIT', lang) ||
                                '" src="rasdc_files.showfile?pfile=pict/gumbgit.jpg" width=21 border=0 >
</A>
</td>');
end if;
htp.p('<TD><A class="A" 
href="RASDC_FILES.downloadplsql?PDATOTEKA='||PFORMID||'" target="_blank" name="B10LHTML3_1">' || B10LHTML3(1) ||
              '</A></TD>
<TD> <a class="A" href="'|| B10form(1)  ||'.metadata" target="_blank" >
     <img height="20" title="XML download" src="rasdc_files.showfile?pfile=pict/gumbxml.jpg" width="21" border="0"></a>
</TD>              

<TD><A class="A" href="javascript: location=encodeURI(');
      js_B10LPROZILCI_POV(B10LPROZILCI(1), 'B10LPROZILCI_1');
      htp.prn(')" name="B10LPROZILCI_1">' || B10LPROZILCI(1) ||
              '</A></TD>
<TD><A class="A" href="javascript: location=encodeURI(');
      js_B10LPOLJA_POV(B10LPOLJA(1), 'B10LPOLJA_1');
      htp.prn(')" name="B10LPOLJA_1">' || B10LPOLJA(1) || '</A>');
      rasdc_hints.link('RASDC_BLOCKSONFORM', lang);
      htp.prn('</TD></TR></TABLE>
<BR>
<TABLE BORDER="1" width="100%">
<CAPTION><B><FONT ID="B20_LAB">' ||
              RASDI_TRNSLT.text('Blocks', lang) ||
              '</FONT></B>
&nbsp;<SELECT NAME="PPAGES" CLASS="SELECT" onchange="js_kliksubmit();">');
      js_PPAGES_LOV(PPAGES, 'PPAGES');
      htp.prn('</SELECT>
<input type="text" size="30" onchange="js_kliksubmit();" name="PF" id="PF" value="'||pf||'" title="'||RASDI_TRNSLT.text('Form searcher ...', lang) ||'">      
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Submit', lang) || '"  onClick="js_kliksubmit();">
');
     -- rasdc_hints.link('RASDC_BLOCKSONFORM', lang);                            
              
      htp.prn('</CAPTION><TR>
<TD class="label" align="center"><FONT ID="B20blockid_LAB"> ' ||
              RASDI_TRNSLT.text('Block', lang) ||
               rasdc_hints.linkDialog('Block',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20sqltable_LAB">' ||
              RASDI_TRNSLT.text('Table, View, Synonym', lang) ||
              rasdc_hints.linkDialog('Table',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20numrows_LAB"> ' ||
              RASDI_TRNSLT.text('Rows', lang) ||
              rasdc_hints.linkDialog('Rows',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20emptyrows_LAB"> ' ||
              RASDI_TRNSLT.text('Empty rows', lang) ||
              rasdc_hints.linkDialog('Emptyrows',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20dbblockyn_LAB"> ' ||
              RASDI_TRNSLT.text('DB block', lang) ||
              rasdc_hints.linkDialog('DBblock',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20rowidyn_LAB"> ' ||
              RASDI_TRNSLT.text('RowID', lang) ||
              rasdc_hints.linkDialog('RowID',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20pagingyn_LAB"> ' ||
              RASDI_TRNSLT.text('Bck / Fwd', lang) ||
              rasdc_hints.linkDialog('Bck',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20clearyn_LAB"> ' ||
              RASDI_TRNSLT.text('Clear', lang) ||
              rasdc_hints.linkDialog('Clear',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20label_LAB" color="red">' ||
              RASDI_TRNSLT.text('Block name', lang) ||
              rasdc_hints.linkDialog('Blockname',lang,'RASDC_BLOCKSONFORM_DIALOG')||'</FONT></TD>
<TD class="label" align="center"><FONT ID="B20LSQL_LAB">'||rasdc_hints.linkDialog('SQL',lang,'RASDC_BLOCKSONFORM_DIALOG')||' </FONT></TD>
<TD class="label" align="center"><FONT ID="B20LPROZILCI_LAB"> </FONT></TD>
<TD class="label" align="center"><FONT ID="B20LCOPYBLOK_LAB">  </FONT></TD>
<TD class="label" align="center"><FONT ID="B20LPOLJA_LAB">  </FONT></TD>
<TD class="label" align="center"></TD></TR>');
      for iB20 in 1 .. B20RS.count loop
        htp.prn('<TR ID="B20_BLOK" 
                 onmouseover="javascript:style.backgroundColor=''#E9E9E9''" ');
                 
                 if B20rform(iB20) is null then                   
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#ffffff''" bgcolor="#FFFFFF" ');
                 else 
                    htp.p(' onmouseout="javascript:style.backgroundColor=''#aaccf7''" bgcolor="#aaccf7" ');                   
                 end if;   
                 
        htp.prn(' bordercolorlight="#E9E9E9">
        <INPUT NAME="B20RID_' || iB20 ||
                '" TYPE="hidden" VALUE="' || B20RID(iB20) ||
                '" CLASS="HIDDEN"><INPUT NAME="B20RS_' || iB20 ||
                '" TYPE="hidden" VALUE="' || B20RS(iB20) ||
                '" CLASS="HIDDEN"><INPUT NAME="B20formid_' || iB20 ||
                '" TYPE="hidden" VALUE="' || B20formid(iB20) ||
                '" CLASS="HIDDEN"><INPUT NAME="B20rform_' || iB20 ||
                '" TYPE="hidden" VALUE="' || B20rform(iB20) ||
                '" CLASS="HIDDEN">
<TD><INPUT NAME="B20blockid_' || iB20 || '" VALUE="' ||
                B20blockid(iB20) || '" CLASS="TEXT" style="WIDTH: 87px; HEIGHT: 22px" size="4">');
if   B20vrstnired(iB20) is not null then              
htp.prn('<div class="ordernum">sort num.:'||B20vrstnired(iB20)||'</div>');
end if;
htp.prn('</TD>
<TD><SELECT NAME="B20sqltable_' || iB20 ||
                '" CLASS="SELECT">');
        js_B20sqltable_LOV(B20sqltable(iB20), 'B20sqltable_' || iB20 || '');
        htp.prn('</SELECT></TD>
<TD><INPUT NAME="B20numrows_' || iB20 || '" VALUE="' ||
                B20numrows(iB20) || '" CLASS="TEXT" size="2"></TD>
<TD><INPUT NAME="B20emptyrows_' || iB20 || '" VALUE="' ||
                B20emptyrows(iB20) || '" CLASS="TEXT" size="2"></TD>
<TD><INPUT NAME="B20dbblockyn_' || iB20 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20dbblockyn(iB20),
                              'B20dbblockyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20rowidyn_' || iB20 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20rowidyn(iB20),
                              'B20rowidyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20pagingyn_' || iB20 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20pagingyn(iB20),
                              'B20pagingyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20clearyn_' || iB20 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B20clearyn(iB20),
                              'B20clearyn_' || iB20 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD><INPUT NAME="B20label_' || iB20 || '" VALUE="' ||
                B20label(iB20) ||
                '" CLASS="TEXT" size="30" maxLength="100"></TD>
<TD><A class="A" href="javascript: var p_y = window.open(encodeURI(');
        js_B20LSQL_POV(B20LSQL(iB20), 'B20LSQL_' || iB20 || '');
        htp.prn('),''p_y'',''width=700,height=400,resizable=1'')" name="B20LSQL_' || iB20 || '">' ||
                B20LSQL(iB20) ||
                '</A></TD>
<TD><A class="A" href="javascript: location=encodeURI(');
        js_B20LPROZILCI_POV(B20LPROZILCI(iB20),
                            'B20LPROZILCI_' || iB20 || '');
        htp.prn(')" name="B20LPROZILCI_' || iB20 || '">' ||
                B20LPROZILCI(iB20) ||
                '</A></TD>
<TD>
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<A class="A" href="javascript: document.RASDC_BLOCKSONFORM.KOPIRAJBLOK.value=' || '''' ||
                B20blockid(iB20) || '''' ||
                ';document.RASDC_BLOCKSONFORM.submit();" name="B20LCOPYBLOK_' || iB20 || '">' ||
                B20LCOPYBLOK(iB20) || '</A>
');
end if;
htp.p('
</TD>
<TD>
');
        if B20blockid(iB20) is not null then
          htp.prn('
<img src="rasdc_files.showfile?pfile=pict/gumbrisi.jpg" border="0" title="' ||
                  RASDI_TRNSLT.text('Delete block', lang) || '"
onClick="document.RASDC_BLOCKSONFORM.B20blockid_' || iB20 ||
                  '.value=''''; document.RASDC_BLOCKSONFORM.B20sqltable_' || iB20 ||
                  '.value=''''; document.RASDC_BLOCKSONFORM.B20numrows_' || iB20 ||
                  '.value='''';document.RASDC_BLOCKSONFORM.B20emptyrows_' || iB20 ||
                  '.value=''''; document.RASDC_BLOCKSONFORM.B20label_' || iB20 ||
                  '.value=''''">
');
        end if;
        htp.prn('
</td>
<TD><A class="A" href="javascript: location=encodeURI(');
        js_B20LPOLJA_POV(B20LPOLJA(iB20), 'B20LPOLJA_' || iB20 || '');
        htp.prn(')" name="B20LPOLJA_' || iB20 || '">' || B20LPOLJA(iB20) ||
                '</A></TD>
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
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_BLOCKSONFORM.submit(); this.disabled = true;  ">
<INPUT  class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onclick=" document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_BLOCKSONFORM.submit(); this.disabled = true; ">
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
    --<ON_ACTION formid="5003" blockid="">
    rasdc_library.log('BLOCKSONFORM',pformid, 'START', vcom);
    
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
    begin
      rasdi_client.secCheckPermission('RASDC_BLOCKSONFORM', '');
      psubmit;
      RASDC_LIBRARY.checkPrivileges(PFORMID);

      if kopirajblok is not null then
        RASDC_LIBRARY.copyblock(PFORMID,
                                   kopirajblok,
                                   PFORMID,
                                   substr(kopirajblok, 1, 25) || '_COPY');
        action      := RASDI_TRNSLT.text('Search', lang);
        kopirajblok := '';
      end if;
      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        rasdc_library.RefData(PFORMID);           
        pselect;
        sporocilo := 'Changes are saved.' || rasdc_library.checknumberofsubfields(PFORMID);
        
      elsif action = RASDI_TRNSLT.text('Search', lang) then
        pselect;
      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;
      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        rasdc_library.log('BLOCKSONFORM',pformid, 'COMMIT_S', vcom);       
        pcommit;
        rasdc_library.log('BLOCKSONFORM',pformid, 'COMMIT_E', vcom);       
        commit;
        rasdc_library.log('BLOCKSONFORM',pformid, 'REF_S', vcom);       
        rasdc_library.RefData(PFORMID);           
        rasdc_library.log('BLOCKSONFORM',pformid, 'REF_E', vcom);       
        rasdc_library.log('BLOCKSONFORM',pformid, 'SELECT_S', vcom);       
        pselect;
        rasdc_library.log('BLOCKSONFORM',pformid, 'SELECT_E', vcom);       
        rasdc_library.log('BLOCKSONFORM',pformid, 'COMPILE_S', vcom);       
        begin
          if b10form(1) in ('RASDC_BLOCKSONFORM',
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
                           'begin ' || v_server || '.form(' || b10formid(1) ||
                           ',''' || lang || ''');end;',
                           dbms_sql.native);
            n := dbms_sql.execute(cid);
            dbms_sql.close_cursor(cid);
            sporocilo := RASDI_TRNSLT.text('From is generated.', lang)|| rasdc_library.checknumberofsubfields(PFORMID);
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
        rasdc_library.log('BLOCKSONFORM',pformid, 'COMPILE_E', vcom);               
        pselect_b30;
      end if;

      predogled := '<input type=button class=submitp value="' ||
                   RASDI_TRNSLT.text('Preview', lang) || '" ' ||
                   owa_util.ite(RASDC_LIBRARY.formhaserrors(b10form(1)) = true,
                                'style="background-color: red;" title="' ||
                                RASDI_TRNSLT.text('Program has ERRORS!',
                                                  lang) || '" ',
                                owa_util.ite(RASDC_LIBRARY.formischanged(PFORMID) = true,
                                             'style="background-color: orange;" title="' ||
                                             RASDI_TRNSLT.text('Programa has changes. Compile it.',
                                                               lang) ||
                                             '" onclick="x=window.open(encodeURI(''!' ||
                                             b10form(1) ||
                                             '.webclient''),'''','''')" ',
                                             'style="background-color: green;" onclick="x=window.open(encodeURI(''!' ||
                                             b10form(1) ||
                                             '.webclient''),'''','''')" ')) || '>';
                                             
      rasdc_library.log('BLOCKSONFORM',pformid, 'POUTPUT_S', vcom);       
      phtml;
      rasdc_library.log('BLOCKSONFORM',pformid, 'POUTPUT_E', vcom);       
      rasdc_library.log('BLOCKSONFORM',pformid, 'END', vcom);       
    end;
    --</ON_ACTION>
    --<ON_ERROR formid="5003" blockid="">
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
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
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
end RASDC_BLOCKSONFORM;
/
