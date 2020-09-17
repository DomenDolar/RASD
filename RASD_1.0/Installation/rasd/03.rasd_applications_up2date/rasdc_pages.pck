create or replace package RASDC_PAGES is
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

  procedure IzvediLOV(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/

create or replace package body RASDC_PAGES is
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
20170105 - Modified filter on Pages page
20161207 - Added filter on Pages page
20161124 - Added possibility to check blocks and form fields for setting SESSION variables. Default setting is - not checked. Be careful with programs using SESSION variables in past.      
20160627 - Included reference form future.
20160607 - Added 10 more pages to select.
20160406 - Problem when field type was null, it was not shown on pages. Solved.
20151202 - Included session variables in filters    
20150814 - Added superuser     
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20170105225530';

  end;

  procedure IzvediLOV(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
    TYPE PListeType IS RECORD(
      izpis varchar2(300),
      p1    varchar2(200));
    TYPE tab_pliste_type IS TABLE OF PListeType INDEX BY BINARY_INTEGER;
    vlista   tab_pliste_type;
    vstevec  number := 1;
    v_opis   varchar2(100);
    p_lov    varchar2(100);
    p_nameid varchar2(100);
    v_izpisi boolean;
  begin
    for i in 1 .. num_entries loop
      if name_array(i) = 'P_LOV' then
        p_lov := value_array(i);
      elsif name_array(i) = 'P_nameid' then
        p_nameid := value_array(i);
      end if;
    end loop;
    if p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    elsif p_lov = 'INPUT_CHECKBOX_DEF' then
      v_opis := 'INPUT_CHECKBOX_DEF';
      vlista(1).izpis := 'N';
      vlista(1).p1 := 'N';
      vlista(2).izpis := 'Y';
      vlista(2).p1 := 'Y';
    else
      return;
    end if;
    htp.p('
  <SCRIPT LANGUAGE="JAVASCRIPT"><!--
   function zapri() {
     this.close ();
   }
   function izberi() {
     var value = window.document.' || P_LOV ||
          '.theList.options[window.document.' || P_LOV ||
          '.theList.selectedIndex].value;
     var text = window.document.' || P_LOV ||
          '.theList.options[window.document.' || P_LOV ||
          '.theList.selectedIndex].text;');
    htp.p('this.close ();
   }
  with (document) {
  if (screen.availWidth < 900){
    moveTo(-4,-4)}
  }
// --></SCRIPT>');
    htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" NAME="" CONTENT="text/html;CHARSET=WINDOWS-1250">');
htp.p(''||RASDC_LIBRARY.RASD_UI_Libs||'');
    htp.p('<TITLE>' || v_opis || '</TITLE>
</HEAD>');
    htp.bodyOpen('', 'bgcolor="#C0C0C0"');
    htp.p('<H2 ALIGN="CENTER">' || v_opis || '</H2>');
    htp.formOpen(curl        => '!RASDC_PAGES.IzvediLOV',
                 cattributes => 'NAME="' || p_lov || '"');
    htp.p('<font face="Courier New">');
    htp.p('<div align="center"><center>');
    htp.formselectOpen('theList', cattributes => 'SIZE=15 WIDTH="100%"');
    for i in 1 .. vstevec loop
      if i = 1 then
        -- fokus na prvem
        htp.formSelectOption(cvalue      => vlista(i).izpis,
                             cselected   => 1,
                             Cattributes => 'VALUE="' || vlista(i).p1 || '"');
      else
        htp.formSelectOption(cvalue      => vlista(i).izpis,
                             Cattributes => 'VALUE="' || vlista(i).p1 || '"');
      end if;
    end loop;
    htp.formselectClose;
    htp.p('</font>');
    htp.line;
    htp.p('<INPUT TYPE=button VALUE="Izberi in Potrdi" onClick="izberi();">');
    htp.p('<INPUT TYPE=button VALUE="Prekli?i" onClick="zapri();">');
    htp.p('</center></div>');
    htp.p('</FORM>');
    htp.p('</BODY>');
    htp.p('</HTML>');
  end;
  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    ACTION     varchar2(4000);
    LANG       varchar2(4000);
    PFORMID    number;
    SPOROCILO  varchar2(4000);
    rform  varchar2(4000);
    pageFilter varchar2(1000);
    
    B10formid  ctab;
    B10blockid ctab;
    B10blok    ctab;
    B10fieldid  ctab;
    B10page0   ctab;
    B10page1   ctab;
    B10page2   ctab;
    B10page3   ctab;
    B10page4   ctab;
    B10page5   ctab;
    B10page6   ctab;
    B10page7   ctab;
    B10page8   ctab;
    B10page9   ctab;
    B10page10   ctab;
    B10page11   ctab;
    B10page12   ctab;
    B10page13   ctab;
    B10page14   ctab;
    B10page15   ctab;
    B10page16   ctab;
    B10page17   ctab;
    B10page18   ctab;
    B10page19   ctab;
    B10page99   ctab;
    
    B10fpage1   ctab;
    B10fpage2   ctab;
    B10fpage3   ctab;
    B10fpage4   ctab;
    B10fpage5   ctab;
    B10fpage6   ctab;
    B10fpage7   ctab;
    B10fpage8   ctab;
    B10fpage9   ctab;
    B10fpage10   ctab;
    B10fpage11   ctab;
    B10fpage12   ctab;
    B10fpage13   ctab;
    B10fpage14   ctab;
    B10fpage15   ctab;
    B10fpage16   ctab;
    B10fpage17   ctab;
    B10fpage18   ctab;
    B10fpage19   ctab;
    B10fpage99   ctab;
    unlink   varchar2(4000);
   
    
    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('SPOROCILO') then
          SPOROCILO := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFILTER') then
          pageFilter := value_array(i__);
        elsif upper(name_array(i__)) = upper('UNLINK') then
          unlink := value_array(i__);
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
              upper('B10BLOK_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10blok(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10FIELDID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10fieldid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page0_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page0(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page1_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page1(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page2_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page2(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page3_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page3(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page4_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page4(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page5_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page5(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page6_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page6(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page7_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page7(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page8_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page8(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page9_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page9(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page10_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page10(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page11_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page11(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page12_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page12(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page13_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page13(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page14_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page14(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page15_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page15(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page16_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page16(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page17_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page17(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page18_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page18(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page19_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page19(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10page99_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10page99(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage1_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage1(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage2_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage2(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage3_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage3(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage4_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage4(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage5_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage5(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage6_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage6(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage7_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage7(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage8_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage8(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage9_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage9(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage10_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage10(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage11_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage11(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage12_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage12(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage13_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage13(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage14_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage14(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage15_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage15(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage16_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage16(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage17_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage17(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage18_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage18(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage19_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage19(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('b10fpage99_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10fpage99(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10formid.count > v_max then
        v_max := B10formid.count;
      end if;
      if B10blockid.count > v_max then
        v_max := B10blockid.count;
      end if;
      if B10blok.count > v_max then
        v_max := B10blok.count;
      end if;
      if B10fieldid.count > v_max then
        v_max := B10fieldid.count;
      end if;
      if B10page0.count > v_max then
        v_max := B10page0.count;
      end if;
      if B10page1.count > v_max then
        v_max := B10page1.count;
      end if;
      if B10page2.count > v_max then
        v_max := B10page2.count;
      end if;
      if B10page3.count > v_max then
        v_max := B10page3.count;
      end if;
      if B10page4.count > v_max then
        v_max := B10page4.count;
      end if;
      if B10page5.count > v_max then
        v_max := B10page5.count;
      end if;
      if B10page6.count > v_max then
        v_max := B10page6.count;
      end if;
      if B10page7.count > v_max then
        v_max := B10page7.count;
      end if;
      if B10page8.count > v_max then
        v_max := B10page8.count;
      end if;
      if B10page9.count > v_max then
        v_max := B10page9.count;
      end if;
      if B10page10.count > v_max then
        v_max := B10page10.count;
      end if;
      if B10page11.count > v_max then
        v_max := B10page11.count;
      end if;
      if B10page12.count > v_max then
        v_max := B10page12.count;
      end if;
      if B10page13.count > v_max then
        v_max := B10page13.count;
      end if;
      if B10page14.count > v_max then
        v_max := B10page14.count;
      end if;
      if B10page15.count > v_max then
        v_max := B10page15.count;
      end if;
      if B10page16.count > v_max then
        v_max := B10page16.count;
      end if;
      if B10page17.count > v_max then
        v_max := B10page17.count;
      end if;
      if B10page18.count > v_max then
        v_max := B10page18.count;
      end if;
      if B10page19.count > v_max then
        v_max := B10page19.count;
      end if;
      if B10page99.count > v_max then
        v_max := B10page99.count;
      end if;
      if b10fpage1.count > v_max then
        v_max := b10fpage1.count;
      end if;
      if b10fpage2.count > v_max then
        v_max := b10fpage2.count;
      end if;
      if b10fpage3.count > v_max then
        v_max := b10fpage3.count;
      end if;
      if b10fpage4.count > v_max then
        v_max := b10fpage4.count;
      end if;
      if b10fpage5.count > v_max then
        v_max := b10fpage5.count;
      end if;
      if b10fpage6.count > v_max then
        v_max := b10fpage6.count;
      end if;
      if b10fpage7.count > v_max then
        v_max := b10fpage7.count;
      end if;
      if b10fpage8.count > v_max then
        v_max := b10fpage8.count;
      end if;
      if b10fpage9.count > v_max then
        v_max := b10fpage9.count;
      end if;
      if b10fpage10.count > v_max then
        v_max := b10fpage10.count;
      end if;
      if b10fpage11.count > v_max then
        v_max := b10fpage11.count;
      end if;
      if b10fpage12.count > v_max then
        v_max := b10fpage12.count;
      end if;
      if b10fpage13.count > v_max then
        v_max := b10fpage13.count;
      end if;
      if b10fpage14.count > v_max then
        v_max := b10fpage14.count;
      end if;
      if b10fpage15.count > v_max then
        v_max := b10fpage15.count;
      end if;
      if b10fpage16.count > v_max then
        v_max := b10fpage16.count;
      end if;
      if b10fpage17.count > v_max then
        v_max := b10fpage17.count;
      end if;
      if b10fpage18.count > v_max then
        v_max := b10fpage18.count;
      end if;
      if b10fpage19.count > v_max then
        v_max := b10fpage19.count;
      end if;
      if b10fpage99.count > v_max then
        v_max := b10fpage99.count;
      end if;
      
      for i__ in 1 .. v_max loop
        if not B10formid.exists(i__) then
          B10formid(i__) := null;
        end if;
        if not B10blockid.exists(i__) then
          B10blockid(i__) := null;
        end if;
        if not B10blok.exists(i__) then
          B10blok(i__) := null;
        end if;
        if not B10fieldid.exists(i__) then
          B10fieldid(i__) := null;
        end if;        
        if not B10page0.exists(i__) or B10page0(i__) is null then
          B10page0(i__) := 'N';
        end if;
        if not B10page1.exists(i__) or B10page1(i__) is null then
          B10page1(i__) := 'N';
        end if;
        if not B10page2.exists(i__) or B10page2(i__) is null then
          B10page2(i__) := 'N';
        end if;
        if not B10page3.exists(i__) or B10page3(i__) is null then
          B10page3(i__) := 'N';
        end if;
        if not B10page4.exists(i__) or B10page4(i__) is null then
          B10page4(i__) := 'N';
        end if;
        if not B10page5.exists(i__) or B10page5(i__) is null then
          B10page5(i__) := 'N';
        end if;
        if not B10page6.exists(i__) or B10page6(i__) is null then
          B10page6(i__) := 'N';
        end if;
        if not B10page7.exists(i__) or B10page7(i__) is null then
          B10page7(i__) := 'N';
        end if;
        if not B10page8.exists(i__) or B10page8(i__) is null then
          B10page8(i__) := 'N';
        end if;
        if not B10page9.exists(i__) or B10page9(i__) is null then
          B10page9(i__) := 'N';
        end if;
        if not B10page10.exists(i__) or B10page10(i__) is null then
          B10page10(i__) := 'N';
        end if;
        if not B10page11.exists(i__) or B10page11(i__) is null then
          B10page11(i__) := 'N';
        end if;
        if not B10page12.exists(i__) or B10page12(i__) is null then
          B10page12(i__) := 'N';
        end if;
        if not B10page13.exists(i__) or B10page13(i__) is null then
          B10page13(i__) := 'N';
        end if;
        if not B10page14.exists(i__) or B10page14(i__) is null then
          B10page14(i__) := 'N';
        end if;
        if not B10page15.exists(i__) or B10page15(i__) is null then
          B10page15(i__) := 'N';
        end if;
        if not B10page16.exists(i__) or B10page16(i__) is null then
          B10page16(i__) := 'N';
        end if;
        if not B10page17.exists(i__) or B10page17(i__) is null then
          B10page17(i__) := 'N';
        end if;
        if not B10page18.exists(i__) or B10page18(i__) is null then
          B10page18(i__) := 'N';
        end if;
        if not B10page19.exists(i__) or B10page19(i__) is null then
          B10page19(i__) := 'N';
        end if;        
        if not B10page99.exists(i__) or B10page99(i__) is null then
          B10page99(i__) := 'N';
        end if; 
        if not b10fpage1.exists(i__) or b10fpage1(i__) is null then
          b10fpage1(i__) := null;
        end if;
        if not b10fpage2.exists(i__) or b10fpage2(i__) is null then
          b10fpage2(i__) := null;
        end if;
        if not b10fpage3.exists(i__) or b10fpage3(i__) is null then
          b10fpage3(i__) := null;
        end if;
        if not b10fpage4.exists(i__) or b10fpage4(i__) is null then
          b10fpage4(i__) := null;
        end if;
        if not b10fpage5.exists(i__) or b10fpage5(i__) is null then
          b10fpage5(i__) := null;
        end if;
        if not b10fpage6.exists(i__) or b10fpage6(i__) is null then
          b10fpage6(i__) := null;
        end if;
        if not b10fpage7.exists(i__) or b10fpage7(i__) is null then
          b10fpage7(i__) := null;
        end if;
        if not b10fpage8.exists(i__) or b10fpage8(i__) is null then
          b10fpage8(i__) := null;
        end if;
        if not b10fpage9.exists(i__) or b10fpage9(i__) is null then
          b10fpage9(i__) := null;
        end if;
        if not b10fpage10.exists(i__) or b10fpage10(i__) is null then
          b10fpage10(i__) := null;
        end if;
        if not b10fpage11.exists(i__) or b10fpage11(i__) is null then
          b10fpage11(i__) := null;
        end if;
        if not b10fpage12.exists(i__) or b10fpage12(i__) is null then
          b10fpage12(i__) := null;
        end if;
        if not b10fpage13.exists(i__) or b10fpage13(i__) is null then
          b10fpage13(i__) := null;
        end if;
        if not b10fpage14.exists(i__) or b10fpage14(i__) is null then
          b10fpage14(i__) := null;
        end if;
        if not b10fpage15.exists(i__) or b10fpage15(i__) is null then
          b10fpage15(i__) := null;
        end if;
        if not b10fpage16.exists(i__) or b10fpage16(i__) is null then
          b10fpage16(i__) := null;
        end if;
        if not b10fpage17.exists(i__) or b10fpage17(i__) is null then
          b10fpage17(i__) := null;
        end if;
        if not b10fpage18.exists(i__) or b10fpage18(i__) is null then
          b10fpage18(i__) := null;
        end if;
        if not b10fpage19.exists(i__) or b10fpage19(i__) is null then
          b10fpage19(i__) := null;
        end if;        
        if not b10fpage99.exists(i__) or b10fpage99(i__) is null then
          b10fpage99(i__) := null;
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
      post_submit;
    end;
    procedure pclear_B10(pstart number) is
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
        B10formid(j__) := null;
        B10blockid(j__) := null;
        B10blok(j__) := null;
        B10fieldid(j__) := null;
        B10page0(j__) := null;
        B10page1(j__) := null;
        B10page2(j__) := null;
        B10page3(j__) := null;
        B10page4(j__) := null;
        B10page5(j__) := null;
        B10page6(j__) := null;
        B10page7(j__) := null;
        B10page8(j__) := null;
        B10page9(j__) := null;
        B10page10(j__) := null;
        B10page11(j__) := null;
        B10page12(j__) := null;
        B10page13(j__) := null;
        B10page14(j__) := null;
        B10page15(j__) := null;
        B10page16(j__) := null;
        B10page17(j__) := null;
        B10page18(j__) := null;
        B10page19(j__) := null;
        B10page99(j__) := null;
        b10fpage1(j__) := null;
        b10fpage2(j__) := null;
        b10fpage3(j__) := null;
        b10fpage4(j__) := null;
        b10fpage5(j__) := null;
        b10fpage6(j__) := null;
        b10fpage7(j__) := null;
        b10fpage8(j__) := null;
        b10fpage9(j__) := null;
        b10fpage10(j__) := null;
        b10fpage11(j__) := null;
        b10fpage12(j__) := null;
        b10fpage13(j__) := null;
        b10fpage14(j__) := null;
        b10fpage15(j__) := null;
        b10fpage16(j__) := null;
        b10fpage17(j__) := null;
        b10fpage18(j__) := null;
        b10fpage19(j__) := null;
        b10fpage99(j__) := null;
      end loop;
    end;
    procedure pclear_form is
    begin
      ACTION    := null;
      LANG      := null;
      PFORMID   := null;
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
      B10formid.delete;
      B10blockid.delete;
      B10blok.delete;
      B10fieldid.delete;
      B10page0.delete;
      B10page1.delete;
      B10page2.delete;
      B10page3.delete;
      B10page4.delete;
      B10page5.delete;
      B10page6.delete;
      B10page7.delete;
      B10page8.delete;
      B10page9.delete;
      B10page10.delete;
      B10page11.delete;
      B10page12.delete;
      B10page13.delete;
      B10page14.delete;
      B10page15.delete;
      B10page16.delete;
      B10page17.delete;
      B10page18.delete;
      B10page19.delete;      
      B10page99.delete;      
      b10fpage1.delete;
      b10fpage2.delete;
      b10fpage3.delete;
      b10fpage4.delete;
      b10fpage5.delete;
      b10fpage6.delete;
      b10fpage7.delete;
      b10fpage8.delete;
      b10fpage9.delete;
      b10fpage10.delete;
      b10fpage11.delete;
      b10fpage12.delete;
      b10fpage13.delete;
      b10fpage14.delete;
      b10fpage15.delete;
      b10fpage16.delete;
      b10fpage17.delete;
      b10fpage18.delete;
      b10fpage19.delete;      
      b10fpage99.delete;      
      --<pre_select formid="102" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select b.formid,
                 b.blockid,
                 b.blockid||' '||b.label blok,
                 '' fieldid,
                 decode(s0.page,
                        0,
                        'Y',
                        decode(s1.page,
                               to_number(null),
                               decode(s2.page,
                                      to_number(null),
                                      decode(s3.page,
                                             to_number(null),
                                             decode(s4.page,
                                                    to_number(null),
                                                    decode(s5.page,
                                                           to_number(null),
                                                           decode(s6.page,
                                                                  to_number(null),
                                                                  decode(s7.page,
                                                                         to_number(null),
                                                                         decode(s8.page,
                                                                                to_number(null),
                                                                                decode(s9.page,
                                                                                       to_number(null),
                                        decode(s10.page,
                        to_number(null),
                        decode(s11.page,
                               to_number(null),
                               decode(s12.page,
                                      to_number(null),
                                      decode(s13.page,
                                             to_number(null),
                                             decode(s14.page,
                                                    to_number(null),
                                                    decode(s15.page,
                                                           to_number(null),
                                                           decode(s16.page,
                                                                  to_number(null),
                                                                  decode(s17.page,
                                                                         to_number(null),
                                                                         decode(s18.page,
                                                                                to_number(null),
                                                                                decode(s19.page,
                                                                                       to_number(null),
                        'Y',
                                                                                       'N'),
                                                                                'N'),
                                                                         'N'),
                                                                  'N'),
                                                           'N'),
                                                    'N'),
                                             'N'),
                                      'N'),
                               'N')),
                                                                                       'N'),
                                                                                'N'),
                                                                         'N'),
                                                                  'N'),
                                                           'N'),
                                                    'N'),
                                             'N'),
                                      'N'),
                               'N')) page0,
                 decode(s1.page, 1, 'Y', 'N') page1,
                 decode(s2.page, 2, 'Y', 'N') page2,
                 decode(s3.page, 3, 'Y', 'N') page3,
                 decode(s4.page, 4, 'Y', 'N') page4,
                 decode(s5.page, 5, 'Y', 'N') page5,
                 decode(s6.page, 6, 'Y', 'N') page6,
                 decode(s7.page, 7, 'Y', 'N') page7,
                 decode(s8.page, 8, 'Y', 'N') page8,
                 decode(s9.page, 9, 'Y', 'N') page9,
                 decode(s10.page, 10, 'Y', 'N') page10,
                 decode(s11.page, 11, 'Y', 'N') page11,
                 decode(s12.page, 12, 'Y', 'N') page12,
                 decode(s13.page, 13, 'Y', 'N') page13,
                 decode(s14.page, 14, 'Y', 'N') page14,
                 decode(s15.page, 15, 'Y', 'N') page15,
                 decode(s16.page, 16, 'Y', 'N') page16,
                 decode(s17.page, 17, 'Y', 'N') page17,
                 decode(s18.page, 18, 'Y', 'N') page18,
                 decode(s19.page, 19, 'Y', 'N') page19,
                 decode(s99.page, 99, 'Y', 'N') page99,
                 s1.rform rf1,
                 s2.rform rf2,
                 s3.rform rf3,
                 s4.rform rf4,
                 s5.rform rf5,
                 s6.rform rf6,
                 s7.rform rf7,
                 s8.rform rf8,
                 s9.rform rf9,
                 s10.rform rf10,
                 s11.rform rf11,
                 s12.rform rf12,
                 s13.rform rf13,
                 s14.rform rf14,
                 s15.rform rf15,
                 s16.rform rf16,
                 s17.rform rf17,
                 s18.rform rf18,
                 s19.rform rf19,
                 s99.rform rf99
            from RASD_BLOCKS b,
                 RASD_PAGES  s0,
                 RASD_PAGES  s1,
                 RASD_PAGES  s2,
                 RASD_PAGES  s3,
                 RASD_PAGES  s4,
                 RASD_PAGES  s5,
                 RASD_PAGES  s6,
                 RASD_PAGES  s7,
                 RASD_PAGES  s8,
                 RASD_PAGES  s9,
                 RASD_PAGES  s10,
                 RASD_PAGES  s11,
                 RASD_PAGES  s12,
                 RASD_PAGES  s13,
                 RASD_PAGES  s14,
                 RASD_PAGES  s15,
                 RASD_PAGES  s16,
                 RASD_PAGES  s17,
                 RASD_PAGES  s18,
                 RASD_PAGES  s19,
                 RASD_PAGES  s99
           where b.formid = PFORMID
             and b.blockid like upper(pageFilter)||'%' 
             and b.formid = s0.formid(+)
             and b.blockid = s0.blockid(+)
             and s0.page(+) = 0
             and b.formid = s1.formid(+)
             and b.blockid = s1.blockid(+)
             and s1.page(+) = 1
             and b.formid = s2.formid(+)
             and b.blockid = s2.blockid(+)
             and s2.page(+) = 2
             and b.formid = s3.formid(+)
             and b.blockid = s3.blockid(+)
             and s3.page(+) = 3
             and b.formid = s4.formid(+)
             and b.blockid = s4.blockid(+)
             and s4.page(+) = 4
             and b.formid = s5.formid(+)
             and b.blockid = s5.blockid(+)
             and s5.page(+) = 5
             and b.formid = s6.formid(+)
             and b.blockid = s6.blockid(+)
             and s6.page(+) = 6
             and b.formid = s7.formid(+)
             and b.blockid = s7.blockid(+)
             and s7.page(+) = 7
             and b.formid = s8.formid(+)
             and b.blockid = s8.blockid(+)
             and s8.page(+) = 8
             and b.formid = s9.formid(+)
             and b.blockid = s9.blockid(+)
             and s9.page(+) = 9
             and b.formid = s10.formid(+)
             and b.blockid = s10.blockid(+)
             and s10.page(+) = 10
             and b.formid = s11.formid(+)
             and b.blockid = s11.blockid(+)
             and s11.page(+) = 11
             and b.formid = s12.formid(+)
             and b.blockid = s12.blockid(+)
             and s12.page(+) = 12
             and b.formid = s13.formid(+)
             and b.blockid = s13.blockid(+)
             and s13.page(+) = 13
             and b.formid = s14.formid(+)
             and b.blockid = s14.blockid(+)
             and s14.page(+) = 14
             and b.formid = s15.formid(+)
             and b.blockid = s15.blockid(+)
             and s15.page(+) = 15
             and b.formid = s16.formid(+)
             and b.blockid = s16.blockid(+)
             and s16.page(+) = 16
             and b.formid = s17.formid(+)
             and b.blockid = s17.blockid(+)
             and s17.page(+) = 17
             and b.formid = s18.formid(+)
             and b.blockid = s18.blockid(+)
             and s18.page(+) = 18
             and b.formid = s19.formid(+)
             and b.blockid = s19.blockid(+)
             and s19.page(+) = 19
             and b.formid = s99.formid(+)
             and b.blockid = s99.blockid(+)
             and s99.page(+) = 99
union
          select f.formid,
                 f.blockid,
                 lower(f.fieldid) blok,
                 f.fieldid fieldid,
                 decode(s0.page,
                        0,
                        'Y',
                        decode(s1.page,
                               to_number(null),
                               decode(s2.page,
                                      to_number(null),
                                      decode(s3.page,
                                             to_number(null),
                                             decode(s4.page,
                                                    to_number(null),
                                                    decode(s5.page,
                                                           to_number(null),
                                                           decode(s6.page,
                                                                  to_number(null),
                                                                  decode(s7.page,
                                                                         to_number(null),
                                                                         decode(s8.page,
                                                                                to_number(null),
                                                                                decode(s9.page,
                                                                                       to_number(null),
                      decode(s10.page,
                        to_number(null),
                        decode(s11.page,
                               to_number(null),
                               decode(s12.page,
                                      to_number(null),
                                      decode(s13.page,
                                             to_number(null),
                                             decode(s14.page,
                                                    to_number(null),
                                                    decode(s15.page,
                                                           to_number(null),
                                                           decode(s16.page,
                                                                  to_number(null),
                                                                  decode(s17.page,
                                                                         to_number(null),
                                                                         decode(s18.page,
                                                                                to_number(null),
                                                                                decode(s19.page,
                                                                                       to_number(null),
                        'Y',
                                                                                       'N'),
                                                                                'N'),
                                                                         'N'),
                                                                  'N'),
                                                           'N'),
                                                    'N'),
                                             'N'),
                                      'N'),
                               'N')),
                                                                                       'N'),
                                                                                'N'),
                                                                         'N'),
                                                                  'N'),
                                                           'N'),
                                                    'N'),
                                             'N'),
                                      'N'),
                               'N')) page0,
                 decode(s1.page, 1, 'Y', 'N') page1,
                 decode(s2.page, 2, 'Y', 'N') page2,
                 decode(s3.page, 3, 'Y', 'N') page3,
                 decode(s4.page, 4, 'Y', 'N') page4,
                 decode(s5.page, 5, 'Y', 'N') page5,
                 decode(s6.page, 6, 'Y', 'N') page6,
                 decode(s7.page, 7, 'Y', 'N') page7,
                 decode(s8.page, 8, 'Y', 'N') page8,
                 decode(s9.page, 9, 'Y', 'N') page9,
                 decode(s10.page, 10, 'Y', 'N') page10,
                 decode(s11.page, 11, 'Y', 'N') page11,
                 decode(s12.page, 12, 'Y', 'N') page12,
                 decode(s13.page, 13, 'Y', 'N') page13,
                 decode(s14.page, 14, 'Y', 'N') page14,
                 decode(s15.page, 15, 'Y', 'N') page15,
                 decode(s16.page, 16, 'Y', 'N') page16,
                 decode(s17.page, 17, 'Y', 'N') page17,
                 decode(s18.page, 18, 'Y', 'N') page18,
                 decode(s19.page, 19, 'Y', 'N') page19,
                 decode(s99.page, 99, 'Y', 'N') page99,
                 s1.rform rf1,
                 s2.rform rf2,
                 s3.rform rf3,
                 s4.rform rf4,
                 s5.rform rf5,
                 s6.rform rf6,
                 s7.rform rf7,
                 s8.rform rf8,
                 s9.rform rf9,
                 s10.rform rf10,
                 s11.rform rf11,
                 s12.rform rf12,
                 s13.rform rf13,
                 s14.rform rf14,
                 s15.rform rf15,
                 s16.rform rf16,
                 s17.rform rf17,
                 s18.rform rf18,
                 s19.rform rf19,
                 s99.rform rf99
            from rasd_fields f,
                 RASD_PAGES  s0,
                 RASD_PAGES  s1,
                 RASD_PAGES  s2,
                 RASD_PAGES  s3,
                 RASD_PAGES  s4,
                 RASD_PAGES  s5,
                 RASD_PAGES  s6,
                 RASD_PAGES  s7,
                 RASD_PAGES  s8,
                 RASD_PAGES  s9,
                 RASD_PAGES  s10,
                 RASD_PAGES  s11,
                 RASD_PAGES  s12,
                 RASD_PAGES  s13,
                 RASD_PAGES  s14,
                 RASD_PAGES  s15,
                 RASD_PAGES  s16,
                 RASD_PAGES  s17,
                 RASD_PAGES  s18,
                 RASD_PAGES  s19,
                 RASD_PAGES  s99
           where f.formid = PFORMID
             and f.blockid is null 
             and f.fieldid like upper(pageFilter)||'%' 
             and nvl(f.element,'INPUT_TEXT') not in ('INPUT_HIDDEN')
             and f.formid = s0.formid(+)
             and f.fieldid = s0.fieldid(+)
             and s0.page(+) = 0
             and f.formid = s1.formid(+)
             and f.fieldid = s1.fieldid(+)
             and s1.page(+) = 1
             and f.formid = s2.formid(+)
             and f.fieldid = s2.fieldid(+)
             and s2.page(+) = 2
             and f.formid = s3.formid(+)
             and f.fieldid = s3.fieldid(+)
             and s3.page(+) = 3
             and f.formid = s4.formid(+)
             and f.fieldid = s4.fieldid(+)
             and s4.page(+) = 4
             and f.formid = s5.formid(+)
             and f.fieldid = s5.fieldid(+)
             and s5.page(+) = 5
             and f.formid = s6.formid(+)
             and f.fieldid = s6.fieldid(+)
             and s6.page(+) = 6
             and f.formid = s7.formid(+)
             and f.fieldid = s7.fieldid(+)
             and s7.page(+) = 7
             and f.formid = s8.formid(+)
             and f.fieldid = s8.fieldid(+)
             and s8.page(+) = 8
             and f.formid = s9.formid(+)
             and f.fieldid = s9.fieldid(+)
             and s9.page(+) = 9       
             and f.formid = s10.formid(+)
             and f.fieldid = s10.fieldid(+)
             and s10.page(+) = 10
             and f.formid = s11.formid(+)
             and f.fieldid = s11.fieldid(+)
             and s11.page(+) = 11
             and f.formid = s12.formid(+)
             and f.fieldid = s12.fieldid(+)
             and s12.page(+) = 12
             and f.formid = s13.formid(+)
             and f.fieldid = s13.fieldid(+)
             and s13.page(+) = 13
             and f.formid = s14.formid(+)
             and f.fieldid = s14.fieldid(+)
             and s14.page(+) = 14
             and f.formid = s15.formid(+)
             and f.fieldid = s15.fieldid(+)
             and s15.page(+) = 15
             and f.formid = s16.formid(+)
             and f.fieldid = s16.fieldid(+)
             and s16.page(+) = 16
             and f.formid = s17.formid(+)
             and f.fieldid = s17.fieldid(+)
             and s17.page(+) = 17
             and f.formid = s18.formid(+)
             and f.fieldid = s18.fieldid(+)
             and s18.page(+) = 18
             and f.formid = s19.formid(+)
             and f.fieldid = s19.fieldid(+)
             and s19.page(+) = 19       
             and f.formid = s99.formid(+)
             and f.fieldid = s99.fieldid(+)
             and s99.page(+) = 99 
             
           order by blockid, fieldid;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10formid(i__),
                 B10blockid(i__),
                 B10blok(i__),
                 B10fieldid(i__),
                 B10page0(i__),
                 B10page1(i__),
                 B10page2(i__),
                 B10page3(i__),
                 B10page4(i__),
                 B10page5(i__),
                 B10page6(i__),
                 B10page7(i__),
                 B10page8(i__),
                 B10page9(i__),
                 B10page10(i__),
                 B10page11(i__),
                 B10page12(i__),
                 B10page13(i__),
                 B10page14(i__),
                 B10page15(i__),
                 B10page16(i__),
                 B10page17(i__),
                 B10page18(i__),
                 B10page19(i__),
                 B10page99(i__),
                 b10fpage1(i__),
                 b10fpage2(i__),
                 b10fpage3(i__),
                 b10fpage4(i__),
                 b10fpage5(i__),
                 b10fpage6(i__),
                 b10fpage7(i__),
                 b10fpage8(i__),
                 b10fpage9(i__),
                 b10fpage10(i__),
                 b10fpage11(i__),
                 b10fpage12(i__),
                 b10fpage13(i__),
                 b10fpage14(i__),
                 b10fpage15(i__),
                 b10fpage16(i__),
                 b10fpage17(i__),
                 b10fpage18(i__),
                 b10fpage19(i__),                 
                 B10fpage99(i__);                 
          exit when c__%notfound;
          if c__%rowcount >= 1 then


                 if    B10fpage1(i__) is not null
                   or  B10fpage2(i__) is not null
                   or  B10fpage3(i__) is not null
                   or  B10fpage4(i__) is not null
                   or  B10fpage5(i__) is not null
                   or  B10fpage6(i__) is not null
                   or  B10fpage7(i__) is not null
                   or  B10fpage8(i__) is not null
                   or  B10fpage9(i__) is not null
                   or  B10fpage10(i__) is not null
                   or  B10fpage11(i__) is not null
                   or  B10fpage12(i__) is not null
                   or  B10fpage13(i__) is not null
                   or  B10fpage14(i__) is not null
                   or  B10fpage15(i__) is not null
                   or  B10fpage16(i__) is not null
                   or  B10fpage17(i__) is not null
                   or  B10fpage18(i__) is not null
                   or  B10fpage19(i__) is not null
                   or  B10fpage99(i__) is not null
                 then 
                   rform := 'Y';  
                 end if;

            --<post_select formid="102" blockid="B10">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10formid.delete(1);
          B10blockid.delete(1);
          B10blok.delete(1);
          B10fieldid.delete(1);
          B10page0.delete(1);
          B10page1.delete(1);
          B10page2.delete(1);
          B10page3.delete(1);
          B10page4.delete(1);
          B10page5.delete(1);
          B10page6.delete(1);
          B10page7.delete(1);
          B10page8.delete(1);
          B10page9.delete(1);
          B10page10.delete(1);
          B10page11.delete(1);
          B10page12.delete(1);
          B10page13.delete(1);
          B10page14.delete(1);
          B10page15.delete(1);
          B10page16.delete(1);
          B10page17.delete(1);
          B10page18.delete(1);
          B10page19.delete(1);
          B10page99.delete(1);
          b10fpage1.delete(1);
          b10fpage2.delete(1);
          b10fpage3.delete(1);
          b10fpage4.delete(1);
          b10fpage5.delete(1);
          b10fpage6.delete(1);
          b10fpage7.delete(1);
          b10fpage8.delete(1);
          b10fpage9.delete(1);
          b10fpage10.delete(1);
          b10fpage11.delete(1);
          b10fpage12.delete(1);
          b10fpage13.delete(1);
          b10fpage14.delete(1);
          b10fpage15.delete(1);
          b10fpage16.delete(1);
          b10fpage17.delete(1);
          b10fpage18.delete(1);
          b10fpage19.delete(1);
          b10fpage99.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10formid.count);
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
      for i__ in 1 .. B10formid.count loop
        --<on_validate formid="102" blockid="B10">
        --</on_validate>
        if 1 = 2 then
          --INSERT
          null;
        else
          -- UPDATE ali DELETE;
          --<on_update formid="102" blockid="B10">
          if (b10blockid(i__) is not null or b10fieldid(i__) is not null) and b10formid(i__) is not null then
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 0 ;
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 1 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 2 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 3 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 4 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 5 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 6 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 7 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 8 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 9 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            
                        begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 10 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 11 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 12 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 13 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 14 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 15 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 16 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 17 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 18 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 19 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;
            begin
              delete from RASD_PAGES
               where formid = b10formid(i__)
                 and (blockid = b10blockid(i__) or fieldid = b10fieldid(i__))
                 and page = 99 and (rform is null or unlink = 'Y');
            exception
              when others then
                null;
            end;  
            
                      
            if b10page0(i__) = 'Y'  then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 0, b10fieldid(i__));
            end if;
            if b10page1(i__) = 'Y' and  (b10fpage1(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 1, b10fieldid(i__));
            end if;
            if b10page2(i__) = 'Y' and  (b10fpage2(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 2, b10fieldid(i__));
            end if;
            if b10page3(i__) = 'Y' and  (b10fpage3(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 3, b10fieldid(i__));
            end if;
            if b10page4(i__) = 'Y' and  (b10fpage4(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 4, b10fieldid(i__));
            end if;
            if b10page5(i__) = 'Y' and  (b10fpage5(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 5, b10fieldid(i__));
            end if;
            if b10page6(i__) = 'Y' and  (b10fpage6(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 6, b10fieldid(i__));
            end if;
            if b10page7(i__) = 'Y' and  (b10fpage7(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 7, b10fieldid(i__));
            end if;
            if b10page8(i__) = 'Y' and  (b10fpage8(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 8, b10fieldid(i__));
            end if;
            if b10page9(i__) = 'Y' and  (b10fpage9(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 9, b10fieldid(i__));
            end if;
            
            if b10page10(i__) = 'Y' and  (b10fpage10(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 10, b10fieldid(i__));
            end if;
            if b10page11(i__) = 'Y' and  (b10fpage11(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 11, b10fieldid(i__));
            end if;
            if b10page12(i__) = 'Y' and  (b10fpage12(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 12, b10fieldid(i__));
            end if;
            if b10page13(i__) = 'Y' and  (b10fpage13(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 13, b10fieldid(i__));
            end if;
            if b10page14(i__) = 'Y' and  (b10fpage14(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 14, b10fieldid(i__));
            end if;
            if b10page15(i__) = 'Y' and  (b10fpage15(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 15, b10fieldid(i__));
            end if;
            if b10page16(i__) = 'Y' and  (b10fpage16(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 16, b10fieldid(i__));
            end if;
            if b10page17(i__) = 'Y' and  (b10fpage17(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 17, b10fieldid(i__));
            end if;
            if b10page18(i__) = 'Y' and  (b10fpage18(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 18, b10fieldid(i__));
            end if;
            if b10page19(i__) = 'Y' and  (b10fpage19(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 19, b10fieldid(i__));
            end if;            
                 if b10page99(i__) = 'Y' and  (b10fpage99(i__) is null or unlink = 'Y') then
              insert into RASD_PAGES
                (formid, blockid, page, fieldid)
              values
                (b10formid(i__), b10blockid(i__), 99, b10fieldid(i__));
            end if;      
          end if;
          --</on_update>
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="102" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
      end if;
      --<post_commit formid="102" blockid="">
      update RASD_FORMS set change = sysdate where formid = PFORMID;
      --</post_commit>
      null;
    end;
    procedure phtml is
      iB10 pls_integer;
      ix number;
      --povezavein
      --SQL
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
function js_kliksubmit() {
  document.getElementById(''ACTION'').value=''' || RASDI_TRNSLT.text('Search', lang) ||''';
  document.RASDC_PAGES.submit();
}
function disableAll() {
  var stBlokov = '||B10blok.count||';
  for(i = 0; i < 20; i++) { 
     for(j = 1; j <= stBlokov; j++) { 
        var ime = ''B10page''+i+''_''+j;
        var x = document.getElementsByName(ime);
        x[0].disabled="disabled";
        if(i>0) {
          var ime2 = ''B10fpage''+i+''_''+j;
          var y = document.getElementsByName(ime2);
          y[0].disabled="disabled";
        }
     }
  }
}
</SCRIPT>
</HEAD>
<BODY><FONT ID="RASDC_PAGES_LAB">');
      RASDC_LIBRARY.showhead('RASDC_PAGES',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                LANG);
      htp.prn('</FONT>
      

<FORM NAME="RASDC_PAGES" METHOD="post" ACTION="!rasdc_pages.program">
<INPUT NAME="LANG" TYPE="hidden" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="hidden" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<P align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT id="ACTION" NAME="ACTION" TYPE="submit" CLASS="SUBMIT" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '">
');
end if;
htp.p('
</P>

<table border="0"><tr><td>' ||
RASDI_TRNSLT.text('Blok', LANG)||'</td><td><input type="text" size="30" name="PFILTER" id="PFILTER" value="'||pageFilter||'" /></td>
<td><img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||RASDI_TRNSLT.text('Search', lang) || '" onClick="disableAll(); js_kliksubmit();"></td></tr></table>
<TABLE BORDER="0" align="center">
<CAPTION><FONT ID="B10_LAB"></FONT></CAPTION><TR>
<TD class="label" align="middle"><FONT ID="B10BLOK_LAB">' ||
              RASDI_TRNSLT.text('BLOCK-field/Page', lang) ||
              '</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page0_LAB">0</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page1_LAB">1</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page2_LAB">2</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page3_LAB">3</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page4_LAB">4</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page5_LAB">5</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page6_LAB">6</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page7_LAB">7</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page8_LAB">8</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page9_LAB">9</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page10_LAB">10</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page11_LAB">11</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page12_LAB">12</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page13_LAB">13</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page14_LAB">14</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page15_LAB">15</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page16_LAB">16</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page17_LAB">17</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page18_LAB">18</FONT></TD>
<TD class="label" align="middle"><FONT ID="B10page19_LAB">19</FONT></TD>
<TD class="label" align="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
<TD class="label" style="color: red;" align="middle"><FONT ID="B10page19_LAB">SESSION</FONT></TD>
</TR>');
      for iB10 in 1 .. B10blok.count loop
        htp.prn('<TR ID="B10_BLOK" onmouseover="javascript:style.backgroundColor=''#E9E9E9''" onmouseout="javascript:style.backgroundColor=''#ffffff''">
<INPUT NAME="B10formid_' || iB10 ||
                '" TYPE="hidden" VALUE="' || B10formid(iB10) ||
                '" CLASS="HIDDEN">
<INPUT NAME="B10blockid_' || iB10 ||
                '" TYPE="hidden" VALUE="' || B10blockid(iB10) ||
                '" CLASS="HIDDEN">
<INPUT NAME="B10fieldid_' || iB10 ||
                '" TYPE="hidden" VALUE="' || B10fieldid(iB10) ||
                '" CLASS="HIDDEN">                
<TD><FONT ID="B10BLOK_' || iB10 || '" CLASS="FONT">' ||
                B10blok(iB10) || '</FONT></TD>
<TD><INPUT NAME="B10page0_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page0(iB10), 'B10page0_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage1(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage1_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage1(iB10)||'">'); htp.prn('<INPUT NAME="B10page1_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page1(iB10), 'B10page1_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage2(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage2_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage2(iB10)||'">'); htp.prn('<INPUT NAME="B10page2_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page2(iB10), 'B10page2_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage3(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage3_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage3(iB10)||'">'); htp.prn('<INPUT NAME="B10page3_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page3(iB10), 'B10page3_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage4(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage4_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage4(iB10)||'">'); htp.prn('<INPUT NAME="B10page4_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page4(iB10), 'B10page4_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage5(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage5_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage5(iB10)||'">'); htp.prn('<INPUT NAME="B10page5_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page5(iB10), 'B10page5_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage6(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage6_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage6(iB10)||'">'); htp.prn('<INPUT NAME="B10page6_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page6(iB10), 'B10page6_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage7(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage7_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage7(iB10)||'">'); htp.prn('<INPUT NAME="B10page7_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page7(iB10), 'B10page7_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage8(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage8_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage8(iB10)||'">'); htp.prn('<INPUT NAME="B10page8_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page8(iB10), 'B10page8_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage9(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage9_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage9(iB10)||'">'); htp.prn('<INPUT NAME="B10page9_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page9(iB10), 'B10page9_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage10(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage10_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage10(iB10)||'">'); htp.prn('<INPUT NAME="B10page10_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page10(iB10), 'B10page10_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage11(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage11_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage11(iB10)||'">'); htp.prn('<INPUT NAME="B10page11_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page11(iB10), 'B10page11_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage12(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage12_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage12(iB10)||'">'); htp.prn('<INPUT NAME="B10page12_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page12(iB10), 'B10page12_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage13(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage13_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage13(iB10)||'">'); htp.prn('<INPUT NAME="B10page13_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page13(iB10), 'B10page13_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage14(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage14_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage14(iB10)||'">'); htp.prn('<INPUT NAME="B10page14_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page14(iB10), 'B10page14_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage15(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage15_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage15(iB10)||'">'); htp.prn('<INPUT NAME="B10page15_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page15(iB10), 'B10page15_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage16(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage16_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage16(iB10)||'">'); htp.prn('<INPUT NAME="B10page16_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page16(iB10), 'B10page16_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage17(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage17_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage17(iB10)||'">'); htp.prn('<INPUT NAME="B10page17_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page17(iB10), 'B10page17_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage18(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage18_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage18(iB10)||'">'); htp.prn('<INPUT NAME="B10page18_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page18(iB10), 'B10page18_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD>
<TD ');if b10fpage19(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; htp.prn('><INPUT NAME="B10fpage19_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage19(iB10)||'">'); htp.prn('<INPUT NAME="B10page19_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page19(iB10), 'B10page19_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX"></TD> 
<td>&nbsp;</td>
<TD align="center" ');if b10fpage99(ib10) is not null then htp.prn('style="background-color: #aaccf7; border-color: #aaccf7;"'); end if; 

htp.prn('>');

ix := 0;

select count(*) into ix
from rasd_blocks rb where nvl(rb.numrows, 1) = 1  
 and nvl(rb.emptyrows, 0) = 0 
 and nvl(rb.pagingyn,'N') = 'N' 
 and nvl(rb.dbblockyn,'N') = 'N'
 and rb.formid = pformid
 and rb.blockid = b10blockid(ib10);
 
select count(*)+ix into ix  
from rasd_fields rp
where nvl(rp.element,'INPUT_TEXT') not in ('FONT_' , 'A_' , 'IMG_' ,'PLSQL_', 'INPUT_BUTTON', 'INPUT_SUBMIT', 'INPUT_RESET')
  and rp.fieldid <> rasd_engine10.c_page 
           and rp.fieldid <> rasd_engine10.c_message 
           and rp.fieldid <> rasd_engine10.c_action 
           and rp.fieldid <> rasd_engine10.c_restrestype 
           and rp.fieldid <> rasd_engine10.c_fin 
           and rp.fieldid <> rasd_engine10.c_fin 
           and instr(rp.fieldid, rasd_engine10.c_recnum) = 0
           and rp.elementyn = rasd_engine10.c_true 
           and rp.formid = pformid
           and rp.blockid is null
           and rp.fieldid = b10fieldid(ib10);
  
if ix = 1 then 
htp.prn('<INPUT NAME="B10fpage99_' || iB10 ||'" TYPE="hidden" VALUE="'||B10fpage99(iB10)||'">'); htp.prn('<INPUT NAME="B10page99_' || iB10 ||
                '" TYPE="checkbox" VALUE="');
        js_INPUT_CHECKBOX_DEF(B10page99(iB10), 'B10page99_' || iB10 || '');
        htp.prn('" CLASS="CHECKBOX">');
end if;

htp.prn('</TD>                 
        </TR>
');
      end loop;
      htp.prn('
</TABLE>

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
    --<ON_ACTION formid="102" blockid="">
    declare
      v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
      v_form   varchar2(100);
    begin
      rasdi_client.secCheckPermission('RASDC_PAGES', '');
      psubmit;
      RASDC_LIBRARY.checkprivileges(PFORMID);

      if action = RASDI_TRNSLT.text('Save', lang) then
        pcommit;
        rasdc_library.RefData(PFORMID);
        pselect;
        sporocilo := RASDI_TRNSLT.text('Changes are saved.', lang);
        
        if rform = 'Y' then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if; 
        
        phtml;
      elsif action = RASDI_TRNSLT.text('Search', lang) then
        pselect;
        phtml;
      elsif action = RASDI_TRNSLT.text('Clear', lang) then
        pclear;
        phtml;
      elsif action = RASDI_TRNSLT.text('Compile', lang) then
        pcommit;
        commit;
        rasdc_library.RefData(PFORMID);        
        pselect;
        begin
          select upper(form)
            into v_form
            from RASD_FORMS
           where formid = PFORMID;

          if v_form in ('RASDC_BLOCKSONFORM',
                        'RASDC_FIELDSONBLOCK',
                        'RASDC_TRIGGERS',
                        'RASDC_LINKS',
                        'RASDC_PAGES',
                        'F_FORME',
                        'RASDC_FORMS') then
            sporocilo := 'From is not generated.';
          else
            select server
              into v_server
              from RASD_FORMS_COMPILED fg, RASD_ENGINES g
             where fg.engineid = g.engineid
               and fg.formid = PFORMID
               and fg.editor = vup
               and fg.lobid = rasdi_client.secGetLOB;
            cid := dbms_sql.open_cursor;
            dbms_sql.parse(cid,
                           'begin ' || v_server || '.form(' || v_form ||
                           ');end;',
                           dbms_sql.native);
            n := dbms_sql.execute(cid);
            dbms_sql.close_cursor(cid);
            sporocilo := 'From is generated.';

        if rform = 'Y' then
           sporocilo :=  sporocilo ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if; 
            
          end if;
        exception
          when others then
            sporocilo := 'begin ' || v_server || '.form(' || PFORMID ||
                         ',''' || lang || ''');end;' ||
                         ' - Program is not generated.<br>' ||
                         replace(sqlerrm,
                                 '
',
                                 '<br>');
        end;

        phtml;
      end if;
    end;
    --</ON_ACTION>
    --<ON_ERROR formid="102" blockid="">
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
            RASDI_TRNSLT.text('Nazaj', lang) || ' " class=submit onClick="javascript:history.go(-1)">
<script language="JavaScript">
  document.SPOROCILA.NAZAJ.focus();
</script>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</FORM></BODY></HTML>');

    --</ON_ERROR>
  end;
end RASDC_PAGES;
/

