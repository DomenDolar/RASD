create or replace package rasdc_versions is
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
  function metadata return clob;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/

create or replace package body RASDC_VERSIONS is
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
20160413 - Added RSS forum feed    
20151202 - Included session variables in filters        
20141027 - Added footer on all pages
*/';
    return 'v.1.1.20160413225530';

  end;

  function metadata return clob is
    v_clob clob := ' ';
  begin
    return v_clob;
  end;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    NSELECT      number := 0;
    PAGE         number := 0;
    GBUTTONRES   varchar2(4000) := 'Reset';
    GBUTTONSRC   varchar2(4000) := 'Submit';
    PFORMID      varchar2(4000);
    LANG         varchar2(4000);
    ACTION       varchar2(4000);
    B10TEXTAREA  ctab;
    B10BUFFER    ctab;
    B30RESULT    ctab;
    B30SPOROCILO ctab;
    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      -- submit fields
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('NSELECT') then
          NSELECT := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('PAGE') then
          PAGE := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONRES') then
          GBUTTONRES := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONSRC') then
          GBUTTONSRC := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10TEXTAREA_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10TEXTAREA(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10BUFFER_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10BUFFER(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30RESULT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30RESULT(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B30SPOROCILO_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B30SPOROCILO(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      -- init fields
      v_max := 0;
      if B10TEXTAREA.count > v_max then
        v_max := B10TEXTAREA.count;
      end if;
      if B10BUFFER.count > v_max then
        v_max := B10BUFFER.count;
      end if;
      if v_max = 0 then
        v_max := 1;
      end if;
      for i__ in 1 .. v_max loop
        if not B10TEXTAREA.exists(i__) then
          B10TEXTAREA(i__) := null;
        end if;
        if not B10BUFFER.exists(i__) then
          B10BUFFER(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if B30RESULT.count > v_max then
        v_max := B30RESULT.count;
      end if;
      if B30SPOROCILO.count > v_max then
        v_max := B30SPOROCILO.count;
      end if;
      if v_max = 0 then
        v_max := 1;
      end if;
      for i__ in 1 .. v_max loop
        if not B30RESULT.exists(i__) then
          B30RESULT(i__) := null;
        end if;
        if not B30SPOROCILO.exists(i__) then
          B30SPOROCILO(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      --<POST_SUBMIT formid="8" blockid="">
      if b10textarea(1) is not null then
        declare
          cid     pls_integer;
          n       pls_integer;
          ninsert number;
          ndelete number;
          nupdate number;
        begin
          if instr(upper(b10textarea(1)), 'DESCR') = 1 then
            b10textarea(1) := 'select column_name, data_type,data_length, decode(nullable,''N'',''NOT NULL'','''')
      from user_tab_cols t
      where table_name = ''' ||
                              upper(ltrim(rtrim(substr(b10textarea(1), 6)))) || '''';
          end if;
          cid := dbms_sql.open_cursor;
          dbms_sql.parse(cid, b10textarea(1), dbms_sql.native);
          n := dbms_sql.execute(cid);
          if n >= 0 then
            nselect := instr(upper(b10textarea(1)), 'SELECT');
            ninsert := instr(upper(b10textarea(1)), 'INSERT');
            nupdate := instr(upper(b10textarea(1)), 'UPDATE');
            ndelete := instr(upper(b10textarea(1)), 'DELETE');
            if nselect = 1 then
              -- PLSQL CODE run on UI
              b30sporocilo(1) := 'Only first 100 rows are shown.';
            elsif ninsert = 1 then
              b30sporocilo(1) := '' || n || ' rows were inserted.';
            elsif ndelete = 1 then
              b30sporocilo(1) := '' || n || ' rows were deleted.';
            elsif nupdate = 1 then
              b30sporocilo(1) := '' || n || ' rows were updated.';
            end if;
          end if;
          b10buffer(1) := b10textarea(1) || '
;
' || b10buffer(1);

        exception
          when others then
            b30sporocilo(1) := '<FONT color=red>' || sqlerrm || '</FONT>';
        end;
      end if;

      --</POST_SUBMIT>
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
        B10TEXTAREA(j__) := null;
        B10BUFFER(j__) := null;

      end loop;
    end;
    procedure pclear_B30(pstart number) is
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
        B30RESULT(j__) := null;
        B30SPOROCILO(j__) := null;

      end loop;
    end;
    procedure pclear_form is
    begin
      NSELECT    := 0;
      PAGE       := 0;
      GBUTTONRES := 'Reset';
      GBUTTONSRC := 'Submit';
      ACTION     := null;
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
      pclear_B10(B10TEXTAREA.count);
      null;
    end;
    procedure pselect_B30 is
      i__ pls_integer;
    begin
      pclear_B30(B30RESULT.count);
      null;
    end;
    procedure pselect is
    begin
      if nvl(PAGE, 0) = 0 then
        pselect_B10;
      end if;
      if nvl(PAGE, 0) = 0 then
        pselect_B30;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. B10TEXTAREA.count loop
        --<on_validate formid="8" blockid="B10">
        --</on_validate>
        null;
      end loop;
      null;
    end;
    procedure pcommit_B30 is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. B30RESULT.count loop
        --<on_validate formid="8" blockid="B30">
        --</on_validate>
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="8" blockid="">
      --</pre_commit>
      if nvl(PAGE, 0) = 0 then
        pcommit_B10;
      end if;
      if nvl(PAGE, 0) = 0 then
        pcommit_B30;
      end if;
      --<post_commit formid="8" blockid="">
      --</post_commit>
      null;
    end;
    procedure poutput is
    begin
      htp.prn('<html>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
</HEAD>
<body>
<FONT ID="RASDC_FORMS_LAB">');
      RASDC_LIBRARY.showphead(RASDI_TRNSLT.text('Versions', lang),
                                 '<li> <a href="!rasdc_forms.program?LANG='||lang||'" ><span>'||RASDI_TRNSLT.text('List of forms',lang)||'</span></a></li><li> <a href="!rasdc_versions.webclient?LANG='||lang||'" class="active"><span>'||RASDI_TRNSLT.text('Versions',lang)||'</span></a></li><li> <a href="!rasdc_stats.webclient?LANG='||lang||'" ><span>'||RASDI_TRNSLT.text('Statistics',lang)||'</span></a></li>',
                                 rasdi_client.secGetUsername,
                                 LANG,
                                 'RASDC_FORMSpomoc');
      htp.prn('</FONT>
<form name="" method="post" action="!rasdc_sqlclient.webclient">
<input name="PAGE" type="hidden" value="' || to_char(PAGE) || '">
<input name="ACTION" type="hidden" value="' || ACTION || '">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || lang ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID || '" CLASS="HIDDEN">
<P align="right">
</P>
<P align="center">
<table>
');
      /*
      SQL

      select 'htp.p(''<tr><td>'||object_name||'</td><td>''||'||object_name||'.version(x)); htp.p(''</td><td title="''||x||''">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>''); ' from all_objects where object_type = 'PACKAGE' and owner = 'GENUTLDEV'
      order by object_name

      */
      declare
        x varchar2(4000);
      begin
        htp.p('<tr><td>RASDC_ATTRIBUTES</td><td>' ||
              ''); x:=''; htp.p( RASDC_ATTRIBUTES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_BLOCKSONFORM</td><td>' ||
              ''); x:=''; htp.p(RASDC_BLOCKSONFORM.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_CSSJS</td><td>' || ''); x:=''; htp.p(RASDC_CSSJS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_ERRORS</td><td>' || ''); x:=''; htp.p(RASDC_ERRORS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FIELDSONBLOCK</td><td>' ||
              ''); x:=''; htp.p(RASDC_FIELDSONBLOCK.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FILES</td><td>' || ''); x:=''; htp.p(RASDC_FILES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_FORMS</td><td>' || ''); x:=''; htp.p(RASDC_FORMS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_HINTS</td><td>' || ''); x:=''; htp.p(RASDC_HINTS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_HTML</td><td>' || ''); x:=''; htp.p(RASDC_HTML.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_LIBRARY</td><td>' || ''); x:=''; htp.p(RASDC_LIBRARY.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_LINKS</td><td>' || ''); x:=''; htp.p(RASDC_LINKS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_PAGES</td><td>' || ''); x:=''; htp.p(RASDC_PAGES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_REFERENCES</td><td>' ||
              ''); x:=''; htp.p(RASDC_REFERENCES.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SECURITY</td><td>' ||
              ''); x:=''; htp.p(RASDC_SECURITY.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SQL</td><td>' || ''); x:=''; htp.p(RASDC_SQL.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_SQLCLIENT</td><td>' ||
              ''); x:=''; htp.p(RASDC_SQLCLIENT.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_TEST</td><td>' ||
              ''); x:=''; htp.p(RASDC_TEST.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_TRIGGERS</td><td>' ||
              ''); x:=''; htp.p(RASDC_TRIGGERS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_VERSIONS</td><td>' ||
              ''); x:=''; htp.p(RASDC_VERSIONS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_STATS</td><td>' ||
              ''); x:=''; htp.p(RASDC_STATS.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDC_EXECUTION</td><td>' ||
              ''); x:=''; htp.p(RASDC_EXECUTION.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDI_CLIENT</td><td>' || ''); x:=''; htp.p(rasdi_client.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASDI_TRNSLT</td><td>' || ''); x:=''; htp.p(RASDI_TRNSLT.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASD_ENGINE10</td><td>' || ''); x:=''; htp.p(RASD_ENGINE10.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        
        htp.p('<tr><td>RASD_ENGINEHTML10</td><td>' ||
              ''); x:=''; htp.p(RASD_ENGINEHTML10.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr><tr>
              <td>RASD_ENGINE11</td><td>' || ''); x:=''; htp.p(RASD_ENGINE11.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>');
        htp.p('<tr><td>RASD_ENGINEHTML11</td><td>' ||
              ''); x:=''; htp.p(RASD_ENGINEHTML11.version(x));
        htp.p('</td><td title="' || x ||
              '">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td>
              </tr>');

        htp.p('<tr><td>jQuery</td><td>1.9.1</td><td></td></tr>');
        htp.p('<tr><td>jQuery UI</td><td>1.10.3</td><td></td></tr>');
        htp.p('<tr><td>CKEditor</td><td>4.3</td><td></td></tr>');
        htp.p('<tr><td>CodeMirror</td><td>5.10</td><td></td></tr>');

      end;

      htp.prn('
    </table>
</p>
<p>
<table>
<tbody>
<td class="label" align="center">Last changes of RASD</td>
<td class="label" align="center">Date of change</td>
</tbody>
');
declare
  v_project clob := '';
  v_code clob := '';
  v_forum clob := '';
begin
  
  declare
     req   UTL_HTTP.REQ;
     resp  UTL_HTTP.RESP;  
     value VARCHAR2(1024);
  begin
    utl_http.set_wallet( rasdi_client.c_WalletLocation , rasdi_client.c_WalletPwd);
 
    req := UTL_HTTP.BEGIN_REQUEST('https://sourceforge.net/p/rasd/code-0/feed');
    UTL_HTTP.SET_HEADER(req, 'User-Agent', 'Mozilla/4.0');
    resp := UTL_HTTP.GET_RESPONSE(req);
    LOOP
      UTL_HTTP.READ_LINE(resp, value, TRUE);
      v_project := v_project || value;
    END LOOP;
    UTL_HTTP.END_RESPONSE(resp);    

    req := UTL_HTTP.BEGIN_REQUEST('https://sourceforge.net/projects/rasd/rss?path=/');
    UTL_HTTP.SET_HEADER(req, 'User-Agent', 'Mozilla/4.0');
    resp := UTL_HTTP.GET_RESPONSE(req);
    LOOP
      UTL_HTTP.READ_LINE(resp, value, TRUE);
      v_code := v_code || value;
    END LOOP;
    UTL_HTTP.END_RESPONSE(resp);    

    req := UTL_HTTP.BEGIN_REQUEST('https://sourceforge.net/p/rasd/discussion/hintsandtipsrasd/feed.rss');
    UTL_HTTP.SET_HEADER(req, 'User-Agent', 'Mozilla/4.0');
    resp := UTL_HTTP.GET_RESPONSE(req);
    LOOP
      UTL_HTTP.READ_LINE(resp, value, TRUE);
      v_forum := v_forum || value;
    END LOOP;
    UTL_HTTP.END_RESPONSE(resp); 
    
    /*  
    select URIFACTORY.getUri('https://sourceforge.net/p/rasd/code-0/feed').getClob() , 
     URIFACTORY.getUri('https://sourceforge.net/projects/rasd/rss?path=/').getClob() ,
     URIFACTORY.getUri('https://sourceforge.net/p/rasd/discussion/hintsandtipsrasd/feed.rss').getClob()
     into v_project, v_code , v_forum
    from dual; 
    */
  exception when others then 
  v_project  := '<?xml version="1.0" encoding="utf-8"?>
<rss><channel><item><title>RSS feed is not connected ('||sqlerrm||') - show in browser</title><link>http://sourceforge.net/p/rasd/code-0/HEAD/tree/trunk/RASD_1.0/Installation/rasd/03.rasd_applications/</link><pubDate> </pubDate></item></channel></rss>';
  v_code  := '<rss><channel><item><title></title><link></link><pubDate> </pubDate></item></channel></rss>';     
  v_forum  := '<?xml version="1.0" encoding="utf-8"?>
<rss><channel><item><title>RSS forum feed is not connected ('||sqlerrm||') - show in browser</title><link>https://sourceforge.net/p/rasd/discussion/hintsandtipsrasd/</link><pubDate> </pubDate></item></channel></rss>';
  end;

for r in (
select
  0 vr,
  extractvalue(value(a), '//item/title' ) title,
  extractvalue(value(a),'//item/link') linkx,
  extractvalue(value(a),'//item/pubDate') datex
from table (xmlsequence
           (extract( xmltype( v_forum
              )
              , '//rss/channel/item'
           ))) a
where rownum < 2           
union all  
select
  1 vr,
  extractvalue(value(a), '//item/title' ) title,
  extractvalue(value(a),'//item/link') linkx,
  extractvalue(value(a),'//item/pubDate') datex
from table (xmlsequence
           (extract( xmltype( v_project
              )
              , '//rss/channel/item'
           ))) a
where rownum < 2           
union all           
select
 2 vr,
  extractvalue(value(a), '//item/title' ) title,
  extractvalue(value(a),'//item/link') linkx,
  extractvalue(value(a),'//item/pubDate') datex
from table (xmlsequence
           (extract( xmltype( v_code
              )
              , '//rss/channel/item'
           ))) a
where rownum < 5 ) loop
 htp.p('<tr><td><a href="'||r.linkx||'" target="_blank">'||r.title||'</a></td><td>'||r.datex||'</td></tr>');
end loop;

end;
htp.p('</table></p><P align="right">
</P>
</form>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</body>
</html>
    ');

      null;
    end;
  begin
    psubmit;

    if 1 = 2 then
      null;
    elsif ACTION = GBUTTONSRC then
      pselect;
      poutput;
    end if;

    if ACTION is null or ACTION not in (GBUTTONSRC) then

      pselect;
      poutput;

    end if;

  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.prn('<html><head>
<meta http-equiv="content-type" content="text/html; charset=WINDOWS-1250">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="-1"><meta name="DESCRIPTION" content="description of the site"><meta name="KEYWORDS" content="keywords of the site">
<title></title>
'||RASDC_LIBRARY.RASD_UI_Libs||'</head><body><div class="htmlerror"><div class="htmlerrorcode">' ||
              sqlcode || '</div><div class="htmlerrortext">' || sqlerrm ||
              '</div></body><html>
    ');
  end;
end;
/

