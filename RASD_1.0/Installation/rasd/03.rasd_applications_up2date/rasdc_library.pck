create or replace package RASDC_LIBRARY is
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

  function currentDADUser return varchar2;

  function formHasErrors(pprogram varchar2) return boolean;
  function formIsChanged(PFORMID number) return boolean;
  

  function RASD_UI_Libs return varchar2;
    
  
  procedure showPhead(pnaslov   varchar2,
                         pmeni     varchar2,
                         peditor   varchar2,
                         plang     varchar2,
                         ppomocurl varchar2 default '');
  procedure showNhead(pnaslov   varchar2,
                         pmeni     varchar2,
                         peditor   varchar2,
                         plang     varchar2,
                         ppomocurl varchar2 default '');
  procedure showHead(pprogram varchar2,
                        PFORMID  number,
                        peditor  varchar2,
                        plang    varchar2);
  procedure insertFields(PFORMID  number,
                      pblockid varchar2,
                      p_lang   RASD_FIELDS.fieldid%type default 'SL');
  procedure instruction(p_formid      RASD_ELEMENTS.formid%type,
                        p_elementid   RASD_ELEMENTS.elementid%type,
                        p_instruction in varchar2);

  procedure copyForm(p_formidfrom number,
                          p_formidto   number,
                          p_formato    varchar2 default null,
                          p_versionto  number default 1);

  procedure copyFormRefData(p_formidfrom number,
                          p_formidto   number);

  procedure deleteForm(p_formid number);

  procedure deleteFormRefData(p_formid number);

  procedure unlinkFormRefData(p_formid number);
    
  procedure RefData(p_formid number);  
  
  procedure copyBlock(p_formidfrom  number,
                         p_blockidfrom varchar2,
                         p_formidto    number,
                         p_blockidto   varchar2);
  procedure changeBlock(p_formidfrom  number,
                          p_blockidfrom varchar2,
                          p_formidto    number,
                          p_blockidto   varchar2,
                          p_label       varchar2);

  procedure changeField(p_formid      number,
                           p_fieldidfrom varchar2,
                           p_fieldidto   varchar2,
                           p_nameidfrom  varchar2,
                           p_nameidto    varchar2,
                           p_elementfrom varchar2,
                           p_elementto   varchar2,
                           p_label       varchar2);
  procedure deleteBlock(p_formid number, p_blockid varchar2);
  procedure refBlock(p_formidfrom  number,
                     p_blockidfrom varchar2,
                     p_formidto    number,
                     p_blockidto   varchar2);
  procedure deleteLink(p_formid number, p_linkid varchar2);

  function checknumberofsubfields(pformid number) return varchar2;

  procedure checkPrivileges(p_id number);
  function allowEditing(p_id number) return boolean;
 procedure log(p_program varchar2, p_formid number, p_action varchar2, p_compid in out number, p_other varchar2 default null ) ;
 function RASDVersionChanges(d date default sysdate) return varchar2;
  function prepareName(p_value varchar2) return varchar2;

end;
/

create or replace package body RASDC_LIBRARY is
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

  cursor c_tabele_forme is
    select 1 vr, 'RASD_FORMS' table_name 
      from dual
    union
    select 2 vr, 'RASD_BLOCKS' table_name
      from dual
    union
    select 3 vr, 'RASD_FIELDS' table_name
      from dual
    union
    select 4 vr, 'RASD_LINKS' table_name
      from dual
    union
    select 5 vr, 'RASD_LINK_PARAMS' table_name
      from dual
    union
    select 6 vr, 'RASD_TRIGGERS' table_name
      from dual
    union
    select 7 vr, 'RASD_PAGES' table_name
      from dual
    union
    select 8 vr, 'RASD_REFERENCES' table_name
      from dual
    union
    select 9 vr, 'RASD_ELEMENTS' table_name
      from dual
    union
    select 10 vr, 'RASD_ATTRIBUTES' table_name
      from dual
    union
    select 11 vr, 'RASD_ATTRIBUTES_TEMPORARY' table_name
      from dual
    union
    select 12 vr, 'RASD_ELEMENTS_TEMPORARY' table_name
      from dual
    order by vr;

  cursor c_tabele_forme_ref is
--    select 1 vr, 'RASD_FORMS' table_name 
  --    from dual
    --union
    select 2 vr, 'RASD_BLOCKS' table_name
      from dual
    union
    select 3 vr, 'RASD_FIELDS' table_name
      from dual
    union
    select 4 vr, 'RASD_LINKS' table_name
      from dual
    union
    select 5 vr, 'RASD_LINK_PARAMS' table_name
      from dual
    union
    select 6 vr, 'RASD_TRIGGERS' table_name
      from dual
    union
    select 7 vr, 'RASD_PAGES' table_name
      from dual
  --  union
--    select 8 vr, 'RASD_REFERENCES' table_name
  --    from dual
   -- union
   -- select 9 vr, 'RASD_ELEMENTS' table_name
   --   from dual
   -- union
   -- select 10 vr, 'RASD_ATTRIBUTES' table_name
   --   from dual
    order by vr
    ;


  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20200528 - Added function prepareName    
20200131 - Added QR Code to the header.    
20200130 - Changed output length in rasdversionchanges    
20191126 - Added common UI lib for all RASD Tool programs (using CDN)    
20191117 - Package DBMS_EPG was commented (it is not availabe in ATP database version 19)   
20171210 - Changed RASDVersionChanges - added exception    
20170119 - Added reference FORM_UIHEAD    
20161128 - Added function RASDVersionChanges
20160629 - Added log function for RASD.      
20160629 - Fixed errors on ref froms.      
20160627 - Included reference form future.      
20151202 - Included session variables in filters    
20151029 - Added function checknumberofsubfields    
20150921 - Fixed bug when you create block and choose ROWIDYN
20150814 - Added superuser
*/';
    return 'v.1.1.20200528225530';

  end;

  function currentDADUser return varchar2 is
    --d DBMS_EPG.VARCHAR2_TABLE;
    --x DBMS_EPG.VARCHAR2_TABLE;
    -- DBMS_EPG is not in ATP database 19
  begin
    /*
    if user = 'ANONYMOUS' then
      begin
        DBMS_EPG.get_dad_list(d);
        for i in 1 .. d.count loop
          DBMS_EPG.get_all_dad_mappings(d(i), x);
          for j in 1 .. x.count loop
            if '/' || OWA_UTIL.get_cgi_env('DAD_NAME') || '/*' = x(j) then
              return DBMS_EPG.GET_DAD_ATTRIBUTE(d(i), 'database-username');
            end if;
          end loop;
        end loop;
      exception
        when others then
          return user;
      end;
    end if;*/
    return user;
  end;

  function formHasErrors(pprogram varchar2) return boolean is
    n pls_integer;
  begin

    select nvl(sum(decode(u.status, 'VALID', 0, 'INVALID', 1)), -1)
      into n
      from all_objects u
     where u.object_name = upper(pprogram)
       and u.owner = currentDADUser;
    /*  select count(*) into n
    from user_errors
    where name = pprogram;*/
    if n > 0 then
      return true;
    elsif n = -1 then
      return true;
    else
      return false;
    end if;
  end;

  function formIsChanged(PFORMID number) return boolean is
    n pls_integer;
  begin
    select count(*)
      into n
      from RASD_FORMS f, all_objects o
     where f.formid = PFORMID
       and upper(f.form) = o.object_name
       and o.last_ddl_time < f.change
       and o.object_type = 'PACKAGE BODY'
       and o.owner = currentDADUser;
    if n > 0 then
      return true;
    else
      return false;
    end if;
  end;
  
function RASD_UI_Libs return varchar2 is
  begin

return '
<!--ALL LIBS are included by CDN-->
<LINK REL="SHORTCUT ICON" HREF="rasdc_files.showfile?pfile=pict/rasd.ico" TYPE="text/css">

<script  src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="  crossorigin="anonymous"></script>

<script  src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"  integrity="sha256-T0Vest3yCU7pafRw9r+settMBX6JkKN06dqBnpQ8d30="  crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/redmond/jquery-ui.css" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/codemirror.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/codemirror.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/mode/javascript/javascript.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/mode/css/css.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/mode/sql/sql.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/addon/hint/show-hint.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/addon/hint/show-hint.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/addon/hint/javascript-hint.js"></script>  
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/addon/hint/css-hint.js"></script>  
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/addon/hint/sql-hint.js"></script>

<script src="https://cdn.ckeditor.com/4.13.0/standard/ckeditor.js"></script>


<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

<!--RASD LIBS -->
<LINK rel="STYLESHEET" type="text/css" href="rasdc_files.showfile?pfile=css/rasd.css">
<SCRIPT LANGUAGE="JavaScript" src="rasdc_files.showfile?pfile=js/rasd.js"></SCRIPT>
';

/* FIXED VERSIONS REPLACED WITH CDN
return '
<LINK REL="SHORTCUT ICON" HREF="rasdc_files.showfile?pfile=pict/rasd.ico" TYPE="text/css">

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
<script LANGUAGE="JavaScript" src="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/ui/jquery.ui.tabs.js"></script>
<link rel="stylesheet" type="text/css" href="/rasddevlib/docs/jquery-ui-1.10.3.custom.zip/jquery-ui-1.10.3.custom/development-bundle/demos/demos.css">

<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/lib/codemirror.js"></script>
<link rel="stylesheet" href="/rasddevlib/docs/codemirror.zip/codemirror-5.10/lib/codemirror.css">
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/mode/javascript/javascript.js"></script>
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/mode/css/css.js"></script>
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/mode/sql/sql.js"></script>
<link rel="stylesheet" href="/rasddevlib/docs/codemirror.zip/codemirror-5.10/addon/hint/show-hint.css">
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/addon/hint/show-hint.js"></script>
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/addon/hint/javascript-hint.js"></script>  
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/addon/hint/css-hint.js"></script>  
<script src="/rasddevlib/docs/codemirror.zip/codemirror-5.10/addon/hint/sql-hint.js"></script>

	<script src="/rasddevlib/docs/ckeditor_4.3_full.zip/ckeditor/ckeditor.js"></script>
	<link rel="stylesheet" href="/rasddevlib/docs/ckeditor_4.3_full.zip/ckeditor/samples/sample.css">


<LINK rel="STYLESHEET" type="text/css" href="rasdc_files.showfile?pfile=css/rasd.css">
<SCRIPT LANGUAGE="JavaScript" src="rasdc_files.showfile?pfile=js/rasd.js"></SCRIPT>
';
*/


/*
<!-- RASDC_FORMS.pck RASDC_LINKS.pck rasdc_sqlclient.pck rasdc_test.pck - old versions ----
<link rel="stylesheet" href="/rasddevlib/docs/jquery-ui-themes-1.11.4.zip/jquery-ui-themes-1.11.4/themes/blitzer/jquery-ui.css">
<link rel="stylesheet" href="/rasddevlib/docs/jquery-ui-themes-1.11.4.zip/jquery-ui-themes-1.11.4/themes/blitzer/theme.css">
<script src="/rasddevlib/docs/jquery-ui-1.11.4.zip/jquery-ui-1.11.4/external/jquery/jquery.js"></script>    
<script src="/rasddevlib/docs/jquery-ui-1.11.4.zip/jquery-ui-1.11.4/jquery-ui.js"></script>
-->
*/

  end;
  

  procedure showPhead(pnaslov   varchar2,
                         pmeni     varchar2,
                         peditor   varchar2,
                         plang     varchar2,
                         ppomocurl varchar2 default '') is
    vnl   varchar2(2) := '
';
    vurl  varchar2(2000) := '';
    vname varchar2(100) := '';
  begin
    null;

    vurl := '<A HREF="!rasdc_forms.program?LANG=' || plang || '" title="' ||
            RASDI_TRNSLT.text('application', plang) ||
            '"><img src="rasdc_files.showfile?pfile=pict/form.jpg"  border=0></A>';
    if peditor is not null then
      vname := '' || rasdi_client.secGetUsername || '/' ||
               rasdi_client.secGetLOB;
    end if;
    vurl := vurl || '<A HREF="' || RASDI_TRNSLT.text(ppomocurl, plang) ||
            '" target="blank_"><img src="rasdc_files.showfile?pfile=pict/pomoc.jpg"  border=0></A>';
    htp.p('
<SCRIPT LANGUAGE="JavaScript">
izpis_glave(''' || pnaslov || ''',''' || vname || ''',
''' || '''
,''' || pmeni || ''',
''' || RASDI_TRNSLT.text('Welcome', plang) ||
          ''',''(<A href="!rasdc_security.logout">' ||
          RASDI_TRNSLT.text('logout', plang) || ')</A>'');
</SCRIPT>');
  exception
    when no_data_found then
      null;
  end;

  procedure showNhead(pnaslov   varchar2,
                         pmeni     varchar2,
                         peditor   varchar2,
                         plang     varchar2,
                         ppomocurl varchar2 default '') is
    vnl   varchar2(2) := '
';
    vurl  varchar2(2000) := '';
    vname varchar2(100) := '';
  begin
    null;
    vurl := vurl || '<A HREF="' || RASDI_TRNSLT.text(ppomocurl, plang) ||
            '" target="blank_"><img src="rasdc_files.showfile?pfile=pict/pomoc.jpg"  border=0></A>';
    htp.p('
<SCRIPT LANGUAGE="JavaScript">
izpis_glave(''' || pnaslov || ''',''' || vname || ''',
''' || '''
,''' || pmeni || ''',
'''','''');
</SCRIPT>');
  exception
    when no_data_found then
      null;
  end;

  procedure showHead(pprogram varchar2,
                        PFORMID  number,
                        peditor  varchar2,
                        plang    varchar2) is
    vform    RASD_FORMS.form%type;
    vversion RASD_FORMS.version%type;
    path varchar2(500);
    vnl      varchar2(2) := '
';
    function izpis_postavke_old(peditor   varchar2,
                                pgprogram varchar2,
                                pprogram  varchar2,
                                ptext     varchar2,
                                purl      varchar2) return varchar2 is
    begin
      return '''   <td align=center nowrap ' || owa_util.ite(pgprogram =
                                                             pprogram,
                                                             'bgcolor="#316592" class="meniizbran"',
                                                             'class="meni"') || '><img src="rasdc_files.showfile?pfile=pict/pred.gif" width="11" height="19">' || owa_util.ite(pgprogram =
                                                                                                                                                                               pprogram,
                                                                                                                                                                               ptext,
                                                                                                                                                                               '<a href="' || purl || '">' ||
                                                                                                                                                                               ptext ||
                                                                                                                                                                               '</A>') || '<img src="rasdc_files.showfile?pfile=pict/po.gif" width="10" height="19"></td>''+' || vnl;
    end;
    function izpis_postavke(peditor   varchar2,
                            pgprogram varchar2,
                            pprogram  varchar2,
                            ptext     varchar2,
                            purl      varchar2) return varchar2 is
    begin
      return '''   <li> ' || owa_util.ite(pgprogram = pprogram,
                                          '<a href="' || purl ||
                                          '" class="active"><span>' ||
                                          ptext || '</span></a>',
                                          '<a href="' || purl || '"><span>' ||
                                          ptext || '</span></a>') || '</li>''+' || vnl;
    end;

  begin
    select upper(form), version
      into vform, vversion
      from RASD_FORMS f
     where f.formid = PFORMID;
     
    path := utl_url.escape(owa_util.get_cgi_env('HTTP_REFERER'),true);
     
    htp.p('
<SCRIPT LANGUAGE="JavaScript">
izpis_glave(''' || RASDI_TRNSLT.text('Form: ', plang) || vform || '(' ||
          vversion || ')'||'&nbsp;<img width="10%" src="rasdc_files.showQRCode?ptext='||path||'"/>'||''',''' || rasdi_client.secGetUsername || '/' ||
          rasdi_client.secGetLOB || ''',
''' || 
          --rasdc_security.get_avntxt(peditor,'F_ADMIN','<A HREF="!f_admin.program?LANG='||plang||'" title="'||RASDI_TRNSLT.text('Administracija',plang)||'"><img src="rasdc_files.showfile?pfile=pict/admin.jpg"  border=0></A>')||
          --rasdc_security.get_avntxt(peditor,'F_DBADMIN','<A HREF="!f_dbadmin.program?LANG='||plang||'" title="'||RASDI_TRNSLT.text('Baza podatkov',plang)||'"><img src="rasdc_files.showfile?pfile=pict/dbadmin.jpg"  border=0></A>')||
          --rasdc_security.get_avntxt(peditor,'RASDC_FORMS','<A HREF="!rasdc_forms.program?LANG='||plang||'" title="'||RASDI_TRNSLT.text('application',plang)||'"><img src="rasdc_files.showfile?pfile=pict/form.jpg"  border=0></A>')||
          --rasdc_security.get_avntxt(peditor,'PROFIL',owa_util.ite(peditor is not null,'<A HREF="!profil.program?LANG='||plang||'" title="'||RASDI_TRNSLT.text('Osebne nastavitve',plang)||'">','''')||'<img src="rasdc_files.showfile?pfile=pict/profil.jpg"  border=0></A>')||'<A HREF="'||RASDI_TRNSLT.text('pomoc'||pprogram,plang)||'" title="'||RASDI_TRNSLT.text('Pomo?',plang)||'" target="blank_"><img src="rasdc_files.showfile?pfile=pict/pomoc.jpg"  border=0></A>'
          ''',' ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_FORMS',
                         RASDI_TRNSLT.text('List of forms', plang),
                         '!rasdc_forms.program?LANG=' || plang 
                         --||'&ACTION=' || RASDI_TRNSLT.text('Search', plang)
                         ) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_BLOCKSONFORM',
                         RASDI_TRNSLT.text('Form', plang),
                         '!rasdc_blocksonform.program?LANG=' || plang ||
--                         '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_FIELDSONBLOCK',
                         RASDI_TRNSLT.text('Fields on Block', plang),
                         '!rasdc_fieldsonblock.program?LANG=' || plang ||
--                         '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_TRIGGERS',
                         RASDI_TRNSLT.text('Triggers', plang),
                         '!rasdc_triggers.program?LANG=' || plang ||
--                         '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_LINKS',
                         RASDI_TRNSLT.text('Links - LOV', plang),
                         '!rasdc_links.program?LANG=' || plang ||
--                         '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_PAGES',
                         RASDI_TRNSLT.text('Pages', plang),
                         '!rasdc_pages.program?LANG=' || plang ||
--                         '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          
--          izpis_postavke(peditor,pprogram,'RASDC_REFERENCES' ,RASDI_TRNSLT.text('References'     ,plang),'!rasdc_references.program?LANG='||plang||'&ACTION='||RASDI_TRNSLT.text('Search',plang)||'&PFORMID='||PFORMID )||
          
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_HTML',
                         RASDI_TRNSLT.text('HTML source', plang),
                         '!rasdc_html.program?LANG=' || plang 
--                         || '&ACTION=' || RASDI_TRNSLT.text('Search', plang) 
                         || '&PFORMID=' ||
                         PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_CSSJS',
                         RASDI_TRNSLT.text('CSS, JS source', plang),
                         '!rasdc_cssjs.webclient?LANG=' || plang ||
  --                       '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_SQLCLIENT',
                         RASDI_TRNSLT.text('SQL client', plang),
                         '!rasdc_sqlclient.webclient?LANG=' || plang ||
    --                     '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) ||
          izpis_postavke(peditor,
                         pprogram,
                         'RASDC_TEST',
                         RASDI_TRNSLT.text('Testing', plang),
                         '!rasdc_test.webclient?LANG=' || plang ||
      --                   '&ACTION=' || RASDI_TRNSLT.text('Search', plang) ||
                         '&PFORMID=' || PFORMID) || ''''',
''' || RASDI_TRNSLT.text('Welcome', plang) ||
          ''',''<a href="!rasdc_security.logout">' ||
          RASDI_TRNSLT.text('logout', plang) || '</a>'');
</SCRIPT>');
  exception
    when no_data_found then
      null;
  end;

  procedure insertFields(PFORMID  number,
                      pblockid varchar2,
                      p_lang   RASD_FIELDS.fieldid%type default 'SL') is
    v_st      pls_integer;
    v_name    varchar2(30);
    v_default varchar2(2000);
    v_sql     varchar2(2000);
    v_col     varchar2(2000);
    v_orderby pls_integer := 0;
    v_count_RECNUM pls_integer := 0;
  begin
    rasd_engine10.addFields(PFORMID, p_lang);

    select count(*)
      into v_st
      from RASD_BLOCKS gb, RASD_FIELDS gp
     where gb.blockid = gp.blockid
       and gb.formid = gp.formid
       and gb.formid = PFORMID
       and gb.blockid = pblockid
       and gp.fieldid not in (rasd_engine10.c_rs, rasd_engine10.c_rid );

    if v_st = 0 then
      select sqltable
        into v_name
        from RASD_BLOCKS gb
       where gb.formid = PFORMID
         and gb.blockid = pblockid;

      if v_name is not null then
        -- set order by
        select (nvl(max(ob), 0) + 1) * 10
          into v_orderby
          from (select min(gf.orderby) ob, gb.blockid
                  from RASD_BLOCKS gb, rasd_fields gf
                 where gb.formid = PFORMID
                   and gb.formid = gf.formid
                   and gb.blockid = gf.blockid
                 group by gb.blockid);

        
       select count(*)
        into v_st
        from RASD_BLOCKS gb, RASD_FIELDS gp
       where gb.blockid = gp.blockid
         and gb.formid = gp.formid
         and gb.formid = PFORMID
         and gb.blockid = pblockid
         and gp.fieldid in ( rasd_engine10.c_rid );
        if v_st = 0 then
        insert into RASD_FIELDS
          (blockid,
           formid,
           fieldid,
           type,
           orderby,
           selectyn,
           insertyn,
           updateyn,
           pkyn,
           deleteyn,
           notnullyn,
           insertnnyn,
           nameid,
           elementyn,
           element,
           source)
        values
          (upper(pblockid),
           PFORMID,
           rasd_engine10.c_rid,
           'R',
           v_orderby,
           'Y',
           'N',
           'N',
           'Y',
           'N',
           'N',
           'N',
           upper(pblockid || rasd_engine10.c_rid),
           'Y',
           'INPUT_HIDDEN',
           'G');
        else
          update RASD_FIELDS set orderby =  v_orderby  
          where fieldid in ( rasd_engine10.c_rid )
            and formid = PFORMID
            and blockid = pblockid;
        end if;
        
         
       select count(*)
        into v_st
        from RASD_BLOCKS gb, RASD_FIELDS gp
       where gb.blockid = gp.blockid
         and gb.formid = gp.formid
         and gb.formid = PFORMID
         and gb.blockid = pblockid
         and gp.fieldid in ( rasd_engine10.c_rs );
        if v_st = 0 then
        insert into RASD_FIELDS
          (blockid,
           formid,
           fieldid,
           type,
           orderby,
           selectyn,
           insertyn,
           updateyn,
           pkyn,
           deleteyn,
           notnullyn,
           insertnnyn,
           nameid,
           elementyn,
           element,
           source)
        values
          (upper(pblockid),
           PFORMID,
           rasd_engine10.c_rs,
           'C',
           v_orderby,
           'N',
           'N',
           'N',
           'N',
           'N',
           'N',
           'N',
           upper(pblockid || rasd_engine10.c_rs),
           'Y',
           'INPUT_HIDDEN',
           'G');
        else
          update RASD_FIELDS set orderby =  v_orderby  
          where fieldid in ( rasd_engine10.c_rs )
            and formid = PFORMID
            and blockid = pblockid;           
        end if;
        
        select count(*) into v_count_RECNUM
        from RASD_FIELDS
        where blockid is null
          and formid = PFORMID
          and fieldid = rasd_engine10.c_recnum || upper(pblockid);
        if v_count_RECNUM = 0 then
        insert into RASD_FIELDS
          (blockid,
           formid,
           fieldid,
           type,
           orderby,
           selectyn,
           insertyn,
           updateyn,
           pkyn,
           deleteyn,
           notnullyn,
           insertnnyn,
           nameid,
           elementyn,
           element,
           source,
           Defaultval)
        values
          (null,
           PFORMID,
           rasd_engine10.c_recnum || upper(pblockid),
           'C',
           v_orderby * -1,
           'N',
           'N',
           'N',
           'N',
           'N',
           'N',
           'N',
           rasd_engine10.c_recnum || upper(pblockid),
           'Y',
           'INPUT_HIDDEN',
           'G',
           1);
        end if;
        
        update RASD_BLOCKS
           set dbblockyn = 'Y',
               clearyn   = 'Y',
               rowidyn   = 'Y',
               pagingyn  = decode(numrows, 0, 'N', 'Y')
         where formid = PFORMID
           and blockid = pblockid;

        for r in (select /*+ RULE*/ upper(column_name) polje,
                         decode(data_type,
                                'VARCHAR2',
                                'C',
                                'NUMBER',
                                'N',
                                'DATE',
                                'D',
                                'CLOB',
                                'L',
                                'TIMESTAMP(6)',
                                'T',
                                'C') type,
                         column_id orderby,
                         decode(nullable, 'N', 'Y', 'Y', 'N', 'N') notnullyn,
                         owner,
                         table_name,
                         data_length ,
                         upper(substr(column_name, 1,1))||lower(substr(column_name, 2)) label
                    from ALL_TAB_COLUMNS c
                   where  ( instr(v_name,'.') > 0 and owner||'.'||table_name = v_name
                           or instr(v_name,'.') = 0 and table_name = v_name and currentDADUser = owner
                           )
                /*union
                  select /*+ RULE/ upper(tc.column_name) polje,
                         decode(tc.data_type,
                                'VARCHAR2',
                                'C',
                                'NUMBER',
                                'N',
                                'DATE',
                                'D',
                                'CLOB',
                                'L',
                                'C') type,
                         tc.column_id orderby,
                         decode(tc.nullable, 'N', 'Y', 'Y', 'N', 'N') notnullyn,
                         tc.owner,
                         tc.table_name,
                         tc.data_length,
                         upper(substr(tc.column_name, 1,1))||lower(substr(tc.column_name, 2)) label
                    from user_synonyms s, all_tab_columns tc
                   where s.table_owner = tc.owner
                     and s.table_name = tc.table_name
                     and  ( instr(v_name,'.') > 0 and /*s.owner/ user||'.'||s.synonym_name = v_name
                           or instr(v_name,'.') = 0 and s.synonym_name = v_name and currentDADUser = user --s.owner
                           )*/
                   order by orderby) loop
          v_default := '';
          select data_default
            into v_default
            from all_tab_columns
           where table_name = r.table_name
             and column_name = r.polje
             and owner = r.owner;
          if v_default is not null then
            if length(v_default) > 99 then
              v_default := '';
            end if;
          end if;

          insert into RASD_FIELDS
            (blockid,
             formid,
             fieldid,
             type,
             orderby,
             selectyn,
             insertyn,
             updateyn,
             pkyn,
             deleteyn,
             notnullyn,
             insertnnyn,
             elementyn,
             defaultval,
             nameid,
             source,
             label)
          values
            (upper(pblockid),
             PFORMID,
             r.polje,
             r.type,
             v_orderby + r.orderby * 2,
             'Y',
             'Y',
             'Y',
             'N',
             'Y',
             r.notnullyn,
             decode(v_default, null, 'Y', 'N'),
             'Y',
             v_default,
             upper(pblockid || r.polje),
             'G',
             r.label);

        end loop;

        --SQL
     /*   for c in (select u2.table_name || '_LOV' linkid,
                         u2.table_name TABSQL,
                         u2.constraint_name TABSQLPK
                    from user_constraints u1, user_constraints u2
                   where u1.owner = substr(upper(v_name),1,instr(upper(v_name),'.')-1)  --upper(v_name)
                     and u1.table_name = substr(upper(v_name),instr(upper(v_name),'.')+1)
                     and u1.r_constraint_name = u2.constraint_name ) loop
          select count(linkid)
            into v_st
            from RASD_LINKS
           where linkid = c.linkid;
          if v_st = 0 then
            v_col := '';
            for c1 in (select decode(cx.data_type,
                                     'NUMBER',
                                     'to_char(' || cx.column_name || ')',
                                     'DATE',
                                     'to_char(' || cx.column_name || ')',
                                     cx.column_name) col
                         from user_cons_columns ccx, user_tab_cols cx
                        where ccx.table_name = c.tabsql
                          and ccx.constraint_name = c.tabsqlpk
                          and ccx.table_name = cx.table_name
                          and ccx.column_name = cx.column_name) loop
              v_col := v_col || c1.col || '#,#';
            end loop;
            v_col := substr(v_col, 1, length(v_col) - 3);
            if length(v_col) > 0 then
              v_sql := '      SELECT ' || v_col || ' value, ' || v_col ||
                       ' text
      FROM ' || c.tabsql;
              begin
                insert into RASD_LINKS
                  (formid, linkid, link, type, location, text)
                values
                  (PFORMID, c.linkid, c.linkid, 'S', 'N', v_sql);
              exception
                when others then
                  null;
              end;
            end if;
          end if;
        end loop;*/

      end if;
    end if;
  end;

  function newElementid(p_formid in number) return number is
    v_elementid number;
  begin
    select nvl(max(elementid), 0) + 1 into v_elementid from RASD_ELEMENTS;
    return v_elementid;
  end;

  procedure instruction(p_formid      RASD_ELEMENTS.formid%type,
                        p_elementid   RASD_ELEMENTS.elementid%type,
                        p_instruction in varchar2) is
    p_action    varchar2(10);
    p_plementid varchar2(10);
    p_orderby   varchar2(10);
    s           number;
    e           number;
    v_elementid rasd_elements.elementid%type;
  begin
    s           := 1;
    e           := instr(ltrim(upper(p_instruction)), ' ');
    p_action    := nvl(substr(ltrim(upper(p_instruction)), s, e - 1),
                       trim(upper(p_instruction)));
    s           := e + 1;
    e           := instr(ltrim(upper(p_instruction)), ' ', s);
    p_plementid := substr(ltrim(upper(p_instruction)), s, e - s);
    s           := e + 1;
    p_orderby   := substr(trim(upper(p_instruction)), s);

    --htp.p(p_action ||':'||p_plementid||':'||p_orderby);

    if p_action = 'M' then
      update rasd_elements t
         set t.pelementid = p_plementid,
             t.orderby    = nvl(p_orderby, 1),
             t.source     = 'V'
       where t.formid = p_formid
         and t.elementid = p_elementid;
    end if;

    if p_action = 'C' then

      --rasd_enginehtml10.getNextElementid
      select nvl(max(elementid), 0) + 1
        into v_elementid
        from rasd_elements
       where formid = p_formid;

      insert into rasd_elements
        (formid,
         elementid,
         pelementid,
         orderby,
         element,
         type,
         id,
         nameid,
         endtagelementid,
         source,
         hiddenyn,
         rlobid,
         rform,
         rid)
        (select formid,
                v_elementid,
                p_plementid,
                orderby,
                element,
                type,
                id,
                nameid,
                endtagelementid,
                'V',
                hiddenyn,
                rlobid,
                rform,
                rid
           from rasd_elements
          where formid = p_formid
            and elementid = p_elementid);

    end if;

    if p_action = 'D' then

      delete from rasd_elements
       where formid = p_formid
         and elementid = p_elementid;

    end if;

    null;
  end;

  --Z vejico lo?en seznam stolpcev tabele po id
  function getColumnList(p_table_name in varchar2) return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    for rc in (select *
                 from user_tab_columns a
                where table_name = p_table_name
                order by column_id) loop
      v_col := v_col || ',' || rc.column_name;
    end loop;
    return substr(v_col, 2);
  end;

  procedure copyForm(p_formidfrom number,
                          p_formidto   number,
                          p_formato    varchar2 default null,
                          p_versionto  number default 1) is
    v_colinto varchar2(32000);
    v_col     varchar2(32000);
  begin
    for rt in (select 1 vr, 'RASD_FORMS' table_name
                 from dual
               union
               select 2 vr, 'RASD_BLOCKS' table_name
                 from dual
               union
               select 3 vr, 'RASD_FIELDS' table_name
                 from dual
               union
               select 4 vr, 'RASD_LINKS' table_name
                 from dual
               union
               select 5 vr, 'RASD_LINK_PARAMS' table_name
                 from dual
               union
               select 6 vr, 'RASD_TRIGGERS' table_name
                 from dual
               union
               select 7 vr, 'RASD_PAGES' table_name
                 from dual
               union
               select 8 vr, 'RASD_REFERENCES' table_name
                 from dual
               union
               select 9 vr, 'RASD_ELEMENTS' table_name
                 from dual
               union
               select 10 vr, 'RASD_ATTRIBUTES' table_name
                 from dual
                order by vr) loop

      v_colinto := getcolumnlist(rt.table_name);
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      if rt.table_name = 'RASD_FORMS' then
        v_col := replace(v_col,
                         ',FORM,',
                         ',' || nvl('''' || p_formato || '''',
                                    'substr(form||''_COPY'',1,30)') || ',');
        v_col := replace(v_col,
                         ',VERSION,',
                         ',' || nvl(p_versionto, 1) || ',');
      end if;
      v_col     := substr(v_col, 2, length(v_col) - 2);
      v_colinto := 'insert into ' || rt.table_name || ' (' || v_colinto || ')' ||
                   ' select ' || v_col || ' from ' || rt.table_name ||
                   ' where formid=' || p_formidfrom;

      execute immediate v_colinto;
    end loop;
  end;

  procedure copyFormRefData(p_formidfrom number,
                          p_formidto   number) is
    v_colinto varchar2(32000);
    v_col     varchar2(32000);
    v_where   varchar2(32000);

  begin
    for rt in (select 2 vr, 'RASD_BLOCKS' table_name
                 from dual
               union
               select 3 vr, 'RASD_FIELDS' table_name
                 from dual
               union
               select 4 vr, 'RASD_LINKS' table_name
                 from dual
               union
               select 5 vr, 'RASD_LINK_PARAMS' table_name
                 from dual
               union
               select 6 vr, 'RASD_TRIGGERS' table_name
                 from dual
               union
               select 7 vr, 'RASD_PAGES' table_name
                 from dual
         --      union  
         --      select 9 vr, 'RASD_ELEMENTS' table_name
         ----        from dual
         --      union
         --      select 10 vr, 'RASD_ATTRIBUTES' table_name
         --        from dual
                order by vr) loop

      v_colinto := getcolumnlist(rt.table_name);
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      v_col     := replace(v_col, ',RLOBID,', ',(select max(lobid) from rasd_forms_compiled where formid = ' || p_formidfrom ||'),');
      v_col     := replace(v_col, ',RFORM,', ',(select form from rasd_forms where formid=' || p_formidfrom ||'),');

      if rt.table_name = 'RASD_BLOCKS' then
        v_col := replace(v_col,
                         ',RBLOCKID,',
                         ',BLOCKID,');
        v_where := 'and not exists (select 1 from RASD_BLOCKS x where  x.formid = ' || p_formidto || ' and x.blockid = y.blockid )';                 
                         
      elsif rt.table_name = 'RASD_FIELDS' then
        v_col := replace(v_col,
                         ',RBLOCKID,',
                         ',BLOCKID,');
        v_col := replace(v_col,
                         ',RFIELDID,',
                         ',FIELDID,');
        v_where := 'and not exists (select 1 from RASD_FIELDS x where  x.formid = ' || p_formidto || ' and nvl(x.blockid,''-X'') = nvl(y.blockid,''-X'') and x.fieldid = y.fieldid)';                 
      elsif rt.table_name in ('RASD_LINKS') then
        v_col := replace(v_col,
                         ',RLINKID,',
                         ',LINKID,');
        v_where := 'and not exists (select 1 from RASD_LINKS x where  x.formid = ' || p_formidto || ' and x.linkid = y.linkid )';                 
      elsif rt.table_name in ('RASD_LINK_PARAMS') then
        v_col := replace(v_col,
                         ',RLINKID,',
                         ',LINKID,');
        v_where := 'and not exists (select 1 from RASD_LINK_PARAMS x where  x.formid = ' || p_formidto || ' and x.linkid = y.linkid and x.paramid = y.paramid)';                 
      elsif rt.table_name = 'RASD_TRIGGERS' then
        v_col := replace(v_col,
                         ',RBLOCKID,',
                         ',BLOCKID,');

        v_col := replace(v_col,
                         ',TRIGGERID,',
                         ',decode(triggerid,''FORM_UIHEAD'',''FORM_UIHEAD_REF('||p_formidfrom||')'',''FORM_CSS'',''FORM_CSS_REF('||p_formidfrom||')'',''FORM_JS'',''FORM_JS_REF('||p_formidfrom||')'',triggerid),');
                         
        v_where := 'and not exists (select 1 from RASD_TRIGGERS x where  x.formid = ' || p_formidto || ' and nvl(x.blockid,''-X'') = nvl(y.blockid,''-X'') and x.triggerid = decode(y.triggerid,''FORM_UIHEAD'',''FORM_UIHEAD_REF'',''FORM_CSS'',''FORM_CSS_REF'',''FORM_JS'',''FORM_JS_REF'',y.triggerid))';                 
        
      elsif rt.table_name = 'RASD_PAGES' then
        v_col := replace(v_col,
                         ',RBLOCKID,',
                         ',BLOCKID,');
        v_col := replace(v_col,
                         ',RFIELDID,',
                         ',FIELDID,');
        v_where := 'and not exists (select 1 from RASD_PAGES x where  x.formid = ' || p_formidto || ' and nvl(x.blockid,''-X'') = nvl(y.blockid,''-X'') and nvl(x.fieldid,''-X'') = nvl(y.fieldid,''-X'') and x.page = y.page)';                 
     -- elsif rt.table_name = 'RASD_ELEMENTS' then
     --   v_col := replace(v_col,
     --                    ',RID,',
     --                    ',ID,');
      --  v_where := 'and not exists (select 1 from RASD_ELEMENTS x where  x.formid = ' || p_formidto || ' and nvl(x.id,''-X'') = nvl(y.id,''-X'') )';                 
    --  elsif rt.table_name = 'RASD_ATTRIBUTES' then
      --  v_col := replace(v_col,
     --                    ',RID,',
    --                     ',ID,');
     --   v_where := 'and not exists (select 1 from RASD_ATTRIBUTES x where  x.formid = ' || p_formidto || ' and nvl(x.id,''-X'') = nvl(y.id,''-X'') and nvl(x.name,''-X'') = nvl(y.name,''-X''))';                 
      end if;
      v_col     := substr(v_col, 2, length(v_col) - 2);
      v_colinto := 'insert into ' || rt.table_name || ' (' || v_colinto || ')' ||
                   ' select ' || v_col || ' from ' || rt.table_name ||' y '||
                   ' where y.formid=' || p_formidfrom||' '||v_where;

      execute immediate v_colinto;
      --htp.p(v_colinto||';');
    end loop;
  end;


  procedure deleteForm(p_formid number) is
  begin
    for rt in c_tabele_forme loop
      execute immediate 'delete ' || rt.table_name || ' where formid=' ||
                        p_formid || '';
    end loop;
  end;

  procedure countFormRefData(p_formid number) is
    x number := 0;
    y number := 0;
    z number := 0;
  begin
    for rt in c_tabele_forme_ref loop
      execute immediate 'select count(*) from ' || rt.table_name || ' where formid=' ||
                        p_formid || ' and rform is not null' into x;
--        htp.p('delete ' || rt.table_name || ' where formid=' ||
  --                      p_formid || ' and rform is not null;');
     y := y + x;
    end loop;
    
    select count(*), sum(decode(f.formid, null, 0)) into x, z from rasd_references r, rasd_forms f 
    where r.formid = p_formid
    and r.rform = f.form(+) and r.rlobid = f.lobid(+);
    
    if x > 0 and z = 0 and y > 0 then
      
        raise_application_error('-20000',
                                'Reference form was deleted. Delete or unlink ref. data on Reference program.');    
      
    end if;
    
  end;

  procedure deleteFormRefData(p_formid number) is
  begin
    countFormRefData(p_formid);
  
    for rt in c_tabele_forme_ref loop
      execute immediate 'delete ' || rt.table_name || ' where formid=' ||
                        p_formid || ' and rform is not null';
--        htp.p('delete ' || rt.table_name || ' where formid=' ||
  --                      p_formid || ' and rform is not null;');
    end loop;
  end;

  procedure unlinkFormRefData(p_formid number) is
  begin
    for rt in c_tabele_forme_ref loop
      execute immediate 'update ' || rt.table_name || ' set rform = null where formid=' ||
                        p_formid || ' and rform is not null';
--        htp.p('delete ' || rt.table_name || ' where formid=' ||
  --                      p_formid || ' and rform is not null;');
    end loop;
  end;


  procedure RefData(p_formid number) is
  begin
      deleteformrefdata(p_formid);
      for r in (
      select f.formid from rasd_references s, rasd_forms f
      where s.rform = f.form and s.rlobid = f.lobid  and s.formid = p_formid) loop
      
      copyformrefdata( r.formid , p_formid);   
      
      end loop;
      commit;   
  end;


  procedure copyBlock(p_formidfrom  number,
                         p_blockidfrom varchar2,
                         p_formidto    number,
                         p_blockidto   varchar2) is
    v_colinto varchar2(32000);
    v_col     varchar2(32000);
  begin
    if p_blockidto is not null and p_formidto is not null then
      v_colinto := getcolumnlist('RASD_BLOCKS');
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      v_col     := replace(v_col,
                           ',BLOCKID,',
                           ',''' || p_blockidto || ''',');
      v_col     := replace(v_col, ',RLOBID,', ','''',');
      v_col     := replace(v_col, ',RFORM,', ','''',');
      v_col     := replace(v_col, ',RBLOCKID,', ','''',');

      v_col     := substr(v_col, 2, length(v_col) - 2);
      v_colinto := 'insert into RASD_BLOCKS (' || v_colinto || ')' ||
                   ' select ' || v_col || ' from RASD_BLOCKS where formid=' ||
                   p_formidfrom || ' and blockid=''' || p_blockidfrom || '''';
      execute immediate v_colinto;
      v_colinto := getcolumnlist('RASD_FIELDS');
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      v_col     := replace(v_col,
                           ',BLOCKID,',
                           ',''' || p_blockidto || ''',');
      v_col     := replace(v_col,
                           ',NAMEID,',
                           ',replace(NAMEID,''' || p_blockidfrom || ''',''' ||
                           p_blockidto || '''),');

      v_col     := replace(v_col, ',RLOBID,', ','''',');
      v_col     := replace(v_col, ',RFORM,', ','''',');
      v_col     := replace(v_col, ',RBLOCKID,', ','''',');
      v_col     := replace(v_col, ',RFIELDID,', ','''',');

      v_col     := substr(v_col, 2, length(v_col) - 2);
      v_colinto := 'insert into RASD_FIELDS (' || v_colinto || ')' ||
                   ' select ' || v_col || ' from RASD_FIELDS where formid=' ||
                   p_formidfrom || ' and blockid=''' || p_blockidfrom || '''';
      execute immediate v_colinto;
      v_colinto := getcolumnlist('RASD_TRIGGERS');
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      v_col     := replace(v_col,
                           ',BLOCKID,',
                           ',replace( BLOCKID, ''' || p_blockidfrom || ''','''||p_blockidto||'''),');

      v_col     := replace(v_col, ',RLOBID,', ','''',');
      v_col     := replace(v_col, ',RFORM,', ','''',');
      v_col     := replace(v_col, ',RBLOCKID,', ','''',');

      v_col     := substr(v_col, 2, length(v_col) - 2);
      v_colinto := 'insert into RASD_TRIGGERS (' || v_colinto || ')' ||
                   ' select ' || v_col ||
                   ' from RASD_TRIGGERS where formid=' || p_formidfrom ||
                   ' and ((blockid=''' || p_blockidfrom || ''') or (blockid like ''' || p_blockidfrom || '%'' and triggerid = ''ON_UI''))';
      execute immediate v_colinto;
      v_colinto := getcolumnlist('RASD_PAGES');
      v_col     := ',' || v_colinto || ',';
      v_col     := replace(v_col, ',FORMID,', ',' || p_formidto || ',');
      v_col     := replace(v_col,
                           ',BLOCKID,',
                           ',''' || p_blockidto || ''',');

      v_col     := replace(v_col, ',RLOBID,', ','''',');
      v_col     := replace(v_col, ',RFORM,', ','''',');
      v_col     := replace(v_col, ',RBLOCKID,', ','''',');
      v_col     := replace(v_col, ',RFIELDID,', ','''',');

      v_col     := substr(v_col, 2, length(v_col) - 2);
      
      v_colinto := 'insert into RASD_PAGES (' || v_colinto || ')' ||
                   ' select ' || v_col || ' from RASD_PAGES where formid=' ||
                   p_formidfrom || ' and blockid=''' || p_blockidfrom || '''';
      execute immediate v_colinto;
    end if;
  end;

  procedure changeBlock(p_formidfrom  number,
                          p_blockidfrom varchar2,
                          p_formidto    number,
                          p_blockidto   varchar2,
                          p_label       varchar2) is
    v_elementid number;
    type ntab_type is table of number;
    t_elementid ntab_type;
  begin
    if p_blockidto is not null and p_formidto is not null then
      update RASD_FIELDS p
         set p.blockid = p_blockidto, p.formid = p_formidto
       where p.formid = p_formidfrom
         and p.blockid = p_blockidfrom;

      update RASD_FIELDS p
         set p.nameid  = 'RECNUM' || upper(p_blockidto),
             p.fieldid = 'RECNUM' || upper(p_blockidto),
             p.formid  = p_formidto
       where p.formid = p_formidfrom
         and p.blockid is null
         and fieldid = 'RECNUM' || p_blockidfrom;

      update RASD_PAGES p
         set p.blockid = p_blockidto, p.formid = p_formidto
       where p.formid = p_formidfrom
         and p.blockid = p_blockidfrom;

      update RASD_TRIGGERS p
         set p.blockid = p_blockidto, p.formid = p_formidto
       where p.formid = p_formidfrom
         and p.blockid = p_blockidfrom;
      --refernce
      declare
        v_formato  RASD_FORMS.form%type;
        v_formfrom RASD_FORMS.form%type;
        v_lobid    RASD_PRVS_LOB.lobid%type := rasdi_client.secGetLOB;
      begin
        select upper(form)
          into v_formfrom
          from RASD_FORMS
         where formid = p_formidfrom;
        select upper(form)
          into v_formato
          from RASD_FORMS
         where formid = p_formidto;

        update RASD_BLOCKS p
           set p.rblockid = p_blockidto, p.rform = v_formato
         where upper(p.rform) = v_formfrom
           and p.rblockid = p_blockidfrom
           and p.rlobid = v_lobid;

        update RASD_FIELDS p
           set p.rblockid = p_blockidto, p.rform = v_formato
         where upper(p.rform) = v_formfrom
           and p.rblockid = p_blockidfrom
           and p.rlobid = v_lobid;

        update RASD_TRIGGERS p
           set p.rblockid = p_blockidto, p.rform = v_formato
         where upper(p.rform) = v_formfrom
           and p.rblockid = p_blockidfrom
           and p.rlobid = v_lobid;

      end;

      --elementi in attributei
      --blok
      update RASD_ELEMENTS
         set id = p_blockidto || '_BLOK', nameid = p_blockidto || '_BLOK'
       where formid = p_formidfrom
         and nameid = p_blockidfrom || '_BLOK' return elementid into
       v_elementid;

      update RASD_ATTRIBUTES
         set value = p_blockidto || '_BLOK', source = 'G'
       where formid = p_formidfrom
         and elementid = v_elementid
         and attribute = 'A_ID';
      update RASD_ATTRIBUTES
         set value = p_blockidto || '_BLOK', source = 'G'
       where formid = p_formidfrom
         and elementid = v_elementid
         and attribute = 'A_NAME';

      --label bloka
      update RASD_ELEMENTS
         set id = p_blockidto || '_LAB', nameid = p_blockidto || '_LAB'
       where formid = p_formidfrom
         and nameid = p_blockidfrom || '_LAB' return elementid into
       v_elementid;

      update RASD_ATTRIBUTES
         set value = p_blockidto || '_LAB', source = 'G'
       where formid = p_formidfrom
         and elementid = v_elementid
         and attribute = 'A_ID';
      update RASD_ATTRIBUTES
         set value = p_blockidto || '_LAB', source = 'G'
       where formid = p_formidfrom
         and elementid = v_elementid
         and attribute = 'A_NAME';
      update RASD_ATTRIBUTES
         set value = p_label, source = 'G'
       where formid = p_formidfrom
         and elementid = v_elementid
         and attribute = 'V_';

      --polja bloka
      update RASD_ELEMENTS
         set id     = p_blockidto || substr(id, length(p_blockidto) + 1),
             nameid = p_blockidto || substr(nameid, length(p_blockidto) + 1)
       where formid = p_formidfrom
         and nameid like p_blockidfrom || '%' return elementid bulk
       collect into t_elementid;

      forall i in t_elementid.first .. t_elementid.last
        update RASD_ATTRIBUTES
           set value  = p_blockidto ||
                        substr(value, length(p_blockidto) + 1),
               source = 'G'
         where formid = p_formidfrom
           and elementid = t_elementid(i)
           and attribute = 'A_ID';
      forall i in t_elementid.first .. t_elementid.last
        update RASD_ATTRIBUTES
           set value  = p_blockidto ||
                        substr(value, length(p_blockidto) + 1),
               source = 'G'
         where formid = p_formidfrom
           and elementid = t_elementid(i)
           and attribute = 'A_NAME';

      --labele polj bloka
      update RASD_ELEMENTS
         set id     = p_blockidto || substr(id, length(p_blockidto) + 1),
             nameid = p_blockidto || substr(nameid, length(p_blockidto) + 1)
       where formid = p_formidfrom
         and nameid like p_blockidfrom || '%/_LAB' escape '/' return
       elementid bulk collect into t_elementid;

      forall i in t_elementid.first .. t_elementid.last
        update RASD_ATTRIBUTES
           set value  = p_blockidto ||
                        substr(value, length(p_blockidto) + 1),
               source = 'G'
         where formid = p_formidfrom
           and elementid = t_elementid(i)
           and attribute = 'A_ID';
      forall i in t_elementid.first .. t_elementid.last
        update RASD_ATTRIBUTES
           set value  = p_blockidto ||
                        substr(value, length(p_blockidto) + 1),
               source = 'G'
         where formid = p_formidfrom
           and elementid = t_elementid(i)
           and attribute = 'A_NAME';

    end if;
  end;

  procedure changeField(p_formid      number,
                           p_fieldidfrom varchar2,
                           p_fieldidto   varchar2,
                           p_nameidfrom  varchar2,
                           p_nameidto    varchar2,
                           p_elementfrom varchar2,
                           p_elementto   varchar2,
                           p_label       varchar2) is
    v_elementid number;
  begin
    --polje

    --elementi
    if not (p_nameidto = p_nameidfrom and p_elementto = p_elementfrom) then

      for r in (select elementid from RASD_ELEMENTS
                where formid = p_formid
                 and nameid = p_nameidfrom) loop

      update RASD_ELEMENTS
         set element  = nvl(p_elementto, 'INPUT_TEXT'),
             id       = upper(p_nameidto),
             nameid   = upper(p_nameidto),
             source   = 'G',
             hiddenyn = decode(p_elementto, 'INPUT_HIDDEN', 'Y', 'N')
       where formid = p_formid
         and nameid like p_nameidfrom
         and elementid = r.elementid;
       v_elementid := r.elementid;

      --attributei
      /*
        if p_elementto = p_elementfrom then
          update RASD_ATTRIBUTES set
            value = upper(p_nameidto),
            source = 'G'
          where formid = p_formid
            and elementid = v_elementid
            and attribute = 'A_ID';
          update RASD_ATTRIBUTES set
            value = upper(p_nameidto),
            source = 'G'
          where formid = p_formid
            and elementid = v_elementid
            and attribute = 'A_NAME';
        else
          update RASD_ATTRIBUTES set source = 'G' where elementid = v_elementid;
        end if;
      */
      end loop;
      --label
      for r in (select elementid from RASD_ELEMENTS
                where formid = p_formid
                 and nameid = p_nameidfrom|| '_LAB') loop

      update RASD_ELEMENTS
         set id       = upper(p_nameidto) || '_LAB',
             nameid   = upper(p_nameidto) || '_LAB',
             source   = 'G',
             hiddenyn = decode(p_elementto, 'INPUT_HIDDEN', 'Y', 'N')
       where formid = p_formid
         and nameid like p_nameidfrom || '_LAB'
         and elementid = r.elementid;
       v_elementid := r.elementid;

      update RASD_ATTRIBUTES
         set value = upper(p_nameidto) || '_LAB', source = 'G'
       where formid = p_formid
         and elementid = v_elementid
         and attribute = 'A_ID';
      update RASD_ATTRIBUTES
         set value = upper(p_nameidto) || '_LAB', source = 'G'
       where formid = p_formid
         and elementid = v_elementid
         and attribute = 'A_NAME';
      update RASD_ATTRIBUTES
         set value = p_label, source = 'G'
       where formid = p_formid
         and elementid = v_elementid
         and attribute = 'V_';
      end loop;
    end if;
  end;

  procedure deleteBlock(p_formid number, p_blockid varchar2) is
  begin
    delete RASD_FIELDS
     where formid = p_formid
       and blockid = p_blockid;
    delete RASD_BLOCKS
     where formid = p_formid
       and upper(blockid) = upper(p_blockid);
    delete RASD_TRIGGERS
     where formid = p_formid
       and (upper(blockid) = upper(p_blockid) or blockid like upper(p_blockid)||'%' and triggerid = 'ON_UI' );
    delete RASD_PAGES
     where formid = p_formid
       and upper(blockid) = upper(p_blockid);
    delete RASD_LINK_PARAMS
     where formid = p_formid
       and upper(blockid) = upper(p_blockid);
  end;

  procedure refBlock(p_formidfrom  number,
                     p_blockidfrom varchar2,
                     p_formidto    number,
                     p_blockidto   varchar2) is
    v_colinto varchar2(32000);
    v_col     varchar2(32000);
    v_rlobid  varchar2(30);
    v_rform   varchar2(30);
  begin
    begin
      select lobid, form
        into v_rlobid, v_rform
        from RASD_FORMS
       where formid = p_formidfrom;
    exception
      when no_data_found then
        raise_application_error('-20000',
                                'Referen?na form ' || p_formidfrom ||
                                ' ne bostaja.');
    end;
    v_colinto := getcolumnlist('RASD_BLOCKS');
    v_col     := ',' || v_colinto || ',';
    v_col     := replace(v_col, ',formid,', ',' || p_formidto || ',');
    v_col     := replace(v_col, ',blockid,', ',''' || p_blockidto || ''',');
    v_col     := replace(v_col, ',Rlobid,', ',''' || v_rlobid || ''',');
    v_col     := replace(v_col, ',Rform,', ',''' || v_rform || ''',');
    v_col     := replace(v_col, ',Rblockid,', ',blockid,');
    v_col     := replace(v_col, ',source,', ',''R'',');
    v_col     := substr(v_col, 2, length(v_col) - 2);
    v_colinto := 'insert into RASD_BLOCKS (' || v_colinto || ')' ||
                 ' select ' || v_col || ' from RASD_BLOCKS where formid=' ||
                 p_formidfrom || ' and blockid=''' || p_blockidfrom || '''';
    execute immediate v_colinto;
    v_colinto := getcolumnlist('RASD_FIELDS');
    v_col     := ',' || v_colinto || ',';
    v_col     := replace(v_col, ',formid,', ',' || p_formidto || ',');
    v_col     := replace(v_col, ',blockid,', ',''' || p_blockidto || ''',');
    v_col     := replace(v_col,
                         ',nameid,',
                         ',replace(nameid,''' || p_blockidfrom || ''',''' ||
                         p_blockidto || '''),');
    v_col     := replace(v_col, ',Rlobid,', ',''' || v_rlobid || ''',');
    v_col     := replace(v_col, ',Rform,', ',''' || v_rform || ''',');
    v_col     := replace(v_col, ',Rblockid,', ',blockid,');
    v_col     := replace(v_col, ',Rfieldid,', ',fieldid,');
    v_col     := replace(v_col, ',source,', ',''R'',');
    v_col     := substr(v_col, 2, length(v_col) - 2);
    v_colinto := 'insert into RASD_FIELDS (' || v_colinto || ')' ||
                 ' select ' || v_col || ' from RASD_FIELDS where formid=' ||
                 p_formidfrom || ' and blockid=''' || p_blockidfrom || '''';
    execute immediate v_colinto;
  end;

  procedure deleteLink(p_formid number, p_linkid varchar2) is
  begin
    delete RASD_LINK_PARAMS
     where formid = p_formid
       and linkid = p_linkid;
    update RASD_FIELDS
       set linkid = null
     where formid = p_formid
       and linkid = p_linkid;
  end;
  
  function checknumberofsubfields(pformid number) return varchar2 is
     v varchar2(1000) := '';
  begin
    for r in (select page, numberof, block0
from (
select page,  sum(numberof) numberof , max(block0) block0  
from (
select nvl(p.page, 0) page, 1 numberof, null blockid, '' block0 from  rasd_fields f, rasd_pages p
where f.formid = pformid
  and( f.blockid is null)
  and f.formid = p.formid(+)
  and f.fieldid = p.fieldid (+)
  and nvl(f.elementyn, 'N') = 'Y'
  and nvl(element,'INPUT_TEXT') in ('INPUT_TEXT', 'TEXTAREA_','INPUT_PASSWORD','INPUT_SUBMIT','INPUT_HIDDEN','SELECT_',
                  'FONT_RADIO','INPUT_CHECKBOX')
union all
select nvl(p.page, 0) page, decode(b.numrows,0,50,b.numrows) +  nvl(b.emptyrows,0) , f.blockid, decode(b.numrows,0,'*','') block0  from rasd_blocks b, rasd_fields f, rasd_pages p
where b.formid = pformid
  and b.formid = f.formid
  and (b.blockid = f.blockid)
  and b.formid = p.formid(+)
  and b.blockid= p.blockid (+)  
  and nvl(f.elementyn, 'N') = 'Y'
  and nvl(element,'INPUT_TEXT') in ('INPUT_TEXT', 'TEXTAREA_','INPUT_PASSWORD','INPUT_SUBMIT','INPUT_HIDDEN','SELECT_',
                  'FONT_RADIO','INPUT_CHECKBOX')
)                                    
group by page )
where numberof > 1000
order by page) loop
      
  v:=  v || ', page '||r.page||' ('||r.numberof||''||r.block0||' elements) ' ;
      
    end loop;

if length(v) > 0 then
  if instr(v, '*') > 0 then
      return ' Warning. Potencial problem on submitting '||substr(v,2)||' *for blocks with Rows=0 number of rows is app. 50.';
  else
      return ' Warning. Potencial problem on submitting '||substr(v,2)||'.';
  end if;      
else 
  return '';
end if;  
  
  end;

  procedure checkPrivileges(p_id number) is
    n number;
    --p_id -> ID FORME KI KONTROLIRAMO ?E IMA editor PRAVICE ZA NJO!!!
    venota RASD_PRVS_LOB.lobid%type;
    vuname RASD_FORMS_COMPILED.editor%type;
  begin
    venota := rasdi_client.secGetLOB;
    vuname := rasdi_client.secGetUsername;

    if vuname is not null then
      select count(*)
        into n --id od forme
        from RASD_FORMS_COMPILED fg
       where fg.formid = p_id
         and fg.editor = vuname
         and (fg.lobid = venota or fg.lobid is null and venota is null);
         
       if n = 0 and instr(','||rasdi_client.secSuperUsers||',', ','||vuname||',')  > 0 then n := 1; end if; 
    else
      n := 0;
    end if;

    if n > 0 then
      return;
    end if;

    owa_util.redirect_url('!rasdc_security.logon');
  end;

  function allowEditing(p_id number) return boolean is
    n number;
    --p_id -> ID FORME KI KONTROLIRAMO ?E IMA editor PRAVICE ZA NJO!!!
    venota RASD_PRVS_LOB.lobid%type;
    vuname RASD_FORMS_COMPILED.editor%type;
  begin
    venota := rasdi_client.secGetLOB;
    vuname := rasdi_client.secGetUsername;

    if vuname is not null then
      select count(*)
        into n --id od forme
        from RASD_FORMS_COMPILED fg
       where fg.formid = p_id
         and fg.editor = vuname
         and (fg.lobid = venota or fg.lobid is null and venota is null);
    else
     return false;
    end if;

    if n > 0 then
      return true;
    end if;
    
    return false;
  end;

  procedure log(p_program varchar2, p_formid number, p_action varchar2, p_compid in out number, p_other varchar2 default null )  is
    n number := p_compid;
  begin
    if p_compid is null then 
      select compseq.nextval into n from dual;
    end if; 
     
    insert into rasd_log
      (formid, action, timstmp, compid, other, program)
    values
      (p_formid, p_action, systimestamp , n , p_other, p_program);
            
    p_compid := n;
  end;
  
 function RASDVersionChanges(d date default sysdate) return varchar2 is
  i integer;
  x varchar2(32000); 
  y varchar2(32000);
function filterDate(s varchar2, d date) return varchar2 is
  l number;
  r varchar2(2000);
begin
l := 2;
while l > 1 loop
  l := instr(s, '
' , l);
  begin
    if d < to_date(substr(s,l+1,8),'yyyymmdd') then
       r := r ||'
'|| substr(s,l+1, instr(s,'
',l+1)-l-1);
    end if;  
  exception when others then null; end;
  l := l + 1;

end loop;  
  return r;
end; 

 
begin

for r in (select object_name
from user_objects where object_name like 'RASD%' and object_type = 'PACKAGE') loop 

--execute immediate 'select '||r.object_name||'.version( s )  from dual' into x;
begin
  EXECUTE IMMEDIATE 'declare c varchar2(100); begin c := '||r.object_name||'.version( :x ); end;'
  USING IN OUT x;
exception when others then null;
end; 

if length(filterDate(x, d)) > 0 then
  y:= y || '
  
'||r.object_name||''||filterDate(x, d);  
end if;
  end loop;
  
  return y;
end;

 function prepareName(p_value varchar2) return varchar2 is
 begin
   --valid chars:
 
   return replace(p_value, ' ', '');
 end ;


  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    procedure on_submit is
      num_entries number := name_array.count;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        end if;
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
    procedure pclear_form is
    begin
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      null;
    end;
    procedure pselect is
    begin
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="6" blockid="">
      --</pre_commit>
      --<post_commit formid="6" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
    begin
      htp.prn('<HTML>
<BODY><FONTID="RASDC_LIBRARY_LAB"></FONT>
<FORMNAME="RASDC_LIBRARY"METHOD="POST"ACTION></FORM></BODY></HTML>
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

        null;
    end;
  begin
    phtml;

  exception
    when rasdi_client.e_finished then
      null;
    when others then
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

  end;
end RASDC_LIBRARY;
/
