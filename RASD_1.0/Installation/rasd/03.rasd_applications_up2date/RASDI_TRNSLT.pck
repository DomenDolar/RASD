create or replace package RASDI_TRNSLT is
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
  function text(ptext varchar2, plang varchar2) return varchar2;
  PRAGMA RESTRICT_REFERENCES(text, TRUST);
end;
/

create or replace package body RASDI_TRNSLT is
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

*/';
    return 'v.1.1.20140420225530';
  end;
  /******************************************************************************************/

  function text(ptext varchar2, plang varchar2) return varchar2 is
    v_text rasd_translates.translate%type;
    n      pls_integer;
       procedure addNEwText(p_text varchar2) is
    begin
       select count(*) into n
       from rasd_translates
       where text = p_text
         and lang is null;
       if n = 0 then
          insert into rasd_translates
            (text, lang, translate)
          values
            (p_text, '', '');
          commit;
       end if;
    end;
  begin
      -- addNEwText(ptext);
    if plang is not null then
      begin
        select translate
          into v_text
          from rasd_translates
         where lang = plang
           and text = ptext;
      exception
        when others then
          v_text := ptext;
      end;
    else
      v_text := ptext;
    end if;
    return v_text;

  end;

end;
/

