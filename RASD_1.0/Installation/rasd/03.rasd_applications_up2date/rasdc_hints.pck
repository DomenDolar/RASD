create or replace package rasdc_hints is
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
function getHint(pprogramid varchar2,
                   plang      varchar2,
                   phintid    in out number ) return varchar2 ;
  function getHint(pprogramid varchar2,
                   plang      varchar2 ) return varchar2;  
  function linkDialog(labelid varchar2, lang varchar2 default null, pprogramid varchar2 default null) return varchar2;
                                    
  procedure izpisi(pprogramid varchar2,
                   plang      varchar2,
                   pakcija    varchar2 default 'Nov',
                   phintid    number default 0);
  procedure link(programid varchar2, lang varchar2);
  procedure izklopi(programid varchar2, lang varchar2);

end;
/

create or replace package body rasdc_hints is
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

  procedure link(programid varchar2, lang varchar2) is
    n pls_integer;
  begin
    htp.prn('<A href="javascript: var x = window.open(''rasdc_hints.izpisi?pprogramid=' ||
            programid || '&plang=' || lang ||
            '&pakcija=Nov&phintid=1000'','''',''scrollbars=1,width=400,height=200'');"><IMG height=20 alt="HINT" src="rasdc_files.showfile?pfile=pict/hint.jpg" width=21 border=0 ></A>');
  end;

  function getHint(pprogramid varchar2,
                   plang      varchar2,
                   phintid    in out number ) return varchar2 is
    v_hintid number;
    v_text   varchar2(4000);
    x        number := 0;
  begin
    -- hinto so po Id jih do 1000 so sistemski pr iprvih prijavah
    -- od 1000 -> ostali
    for r in (select *
                from rasd_hints p
               where (p.form = pprogramid or p.form is null)
                 and p.hintid > phintid
               order by hintid) loop
      phintid := r.hintid;
      return   r.text;
    end loop;

  end;

  function getHint(pprogramid varchar2,
                   plang      varchar2 ) return varchar2 is
    v_hintid number;
    v_text   varchar2(32000);
    x        number := 0;
  begin
    -- hinto so po Id jih do 1000 so sistemski pr iprvih prijavah
    -- od 1000 -> ostali
    for r in (select *
                from rasd_hints p
               where (p.form = pprogramid )
                 and p.hintid > 0
               order by hintid) loop
        return   r.text;
    end loop;
    return '';
  end;


  function linkDialog(labelid varchar2, lang varchar2 default null, pprogramid varchar2 default null) return varchar2 is
    n pls_integer;
  begin
    return '<a onclick="$(''#d_'||labelid||''').dialog(''open'');"><img height="15" alt="HINT" src="rasdc_files.showfile?pfile=pict/hint_label.jpg" width="15" border="0"></a>';              
  end;


  procedure izpisi(pprogramid varchar2,
                   plang      varchar2,
                   pakcija    varchar2 default 'Nov',
                   phintid    number default 0) is
    v_hintid number := phintid;
    v_text   varchar2(4000);
    x        number := 0;
  begin
    -- hinto so po Id jih do 1000 so sistemski pr iprvih prijavah
    -- od 1000 -> ostali
    for r in (select *
                from rasd_hints p
               where (p.form = pprogramid or p.form is null)
                 and p.hintid > phintid
               order by hintid) loop
      v_text   := r.text;
      v_hintid := r.hintid;
      exit;
    end loop;

v_text := getHint(pprogramid,
                   plang    ,
                    v_hintid);

    select count(1)
      into x
      from rasd_hints p
     where (p.form = pprogramid or p.form is null)
       and p.hintid > v_hintid;

    htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<TITLE>HINT</TITLE>
</HEAD>
<BODY>
<DIV class="hint">
<FORM NAME="HINT" METHOD="post" ACTION="rasdc_hints.izpisi">

       <TABLE width="100%" summary="" border="0" cellspacing="0" cellpadding="0"><TR>
             <TD>
             <img height="20" alt="HINT" src="rasdc_files.showfile?pfile=pict/hint.jpg" width="21" border="0">
             </TD></TR></TABLE>
        <table>  <tr>
             <TD>' || RASDI_TRNSLT.text(v_text, plang) ||
          '</TD></TR><TR>
            <TD></BR>');
    if x > 0 then
      htp.prn('              <A href="rasdc_hints.izpisi?pprogramid=' ||
              pprogramid || '&plang=' || plang || '&pakcija=Nov&phintid=' ||
              v_hintid || '"><IMG height=20 alt="' ||
              RASDI_TRNSLT.text('Naslednji hint', plang) ||
              '" src="rasdc_files.showfile?pfile=pict/gumbpod.jpg" width=21 border=0 ></A>');
    end if;
    htp.prn('           </TD>
          </TR></TABLE>

 </form>
 </body>
 </HTML>
');
  end;

  procedure izklopi(programid varchar2, lang varchar2) is
  begin
    htp.p('Izklop');
  end;

end;
/

