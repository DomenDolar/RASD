create or replace package rasdc_references is
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

create or replace package body rasdc_references is
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
20160627 - Included reference form future.  
*/';
    return 'v.1.1.20160627225530';

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
    RFORMID  number;
    message varchar2(4000);
    UNLINKDELETE varchar2(4000);
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
        elsif upper(name_array(i__)) = upper('UNLINKDELETE') then
          UNLINKDELETE := value_array(i__);

        elsif upper(name_array(i__)) = upper('RFORMID') then
          RFORMID := value_array(i__);
          
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
    
    procedure psubmit is
    begin
      on_submit;
    end;

    procedure pselect is
    begin
        for r in (select f.formid from rasd_references r, rasd_forms f where r.formid = pformid and r.rlobid = f.lobid and r.rform = f.form) loop
           rformid := r.formid;                
        end loop;
       


    end;

    procedure pcommit is
       n number;
    begin
      --<pre_commit formid="8" blockid="">
      --</pre_commit>
     select count(*) into n from rasd_references where formid = pformid;
     
     if n > 0 and rformid is null then

       message := RASDI_TRNSLT.text('You would like to delete referenced form. Would you like to delete referenced data or unlink referenced data! ', lang);

       message :=  message ||  RASDI_TRNSLT.text('Delete', lang)||'<input type="radio" name="UNLINKDELETE" value="DELETE"/> / ';
       message :=  message ||  RASDI_TRNSLT.text('Unlink', lang)||'<input type="radio" name="UNLINKDELETE" value="UNLINK"/> / ';
       message :=  message ||  RASDI_TRNSLT.text('No change', lang)||'<input type="radio" name="UNLINKDELETE" value=""/>.';
       
       if UNLINKDELETE is not null then
         if  UNLINKDELETE = 'DELETE' then
             rasdc_library.deleteFormRefData(pformid); 
             message := 'Referenced data is deleted.';
         elsif UNLINKDELETE = 'UNLINK' then
             rasdc_library.unlinkFormRefData(pformid); 
             message := 'Referenced data is unlinked.';
         end if;
           delete from rasd_references where formid = pformid;
           update rasd_forms f set f.referenceyn = 'N' where f.formid = pformid;
         
       end if;
       
     else

      RASDC_LIBRARY.deleteformrefdata(pformid);
      delete from rasd_references where formid = pformid;

      for r in (select * from rasd_forms where formid = rformid) loop
        insert into rasd_references (formid, rlobid, rform) values (pformid, r.lobid, r.form);         
        update rasd_forms f set f.referenceyn = 'Y' where f.formid = pformid;
        RASDC_LIBRARY.copyformrefdata( r.formid , pformid);            
      end loop;
       
     end if;
      
     
     commit;
      --<post_commit formid="8" blockid="">
      --</post_commit>
      null;
    end;
    procedure poutput is
      vform varchar2(1000);
    begin
      
        select upper(form)
      into vform
      from RASD_FORMS f
     where f.formid = PFORMID;
    
    
      htp.prn('<html>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
</SCRIPT>
</HEAD>
<body>
<FONT ID="RASDC_FORMS_LAB">');
      RASDC_LIBRARY.showphead(RASDI_TRNSLT.text('References on form', lang)||' '||vform,
                                 '<li> <a href="!rasdc_blocksonform.program?LANG='||lang||'&PFORMID='||pformid||'" ><span>Form</span></a></li><li> <a href="!rasdc_references.webclient?LANG='||lang||'&PFORMID='||pformid||'" class="active"><span>References</span></a></li>',
                                 rasdi_client.secGetUsername,
                                 LANG,
                                 'RASDC_FORMSpomoc');
                                                                                                  
      htp.prn('</FONT>
<form name="RASDC_REFERENCES" method="post" >
<input name="PAGE" type="hidden" value="' || to_char(PAGE) || '">
<input name="ACTION" id="ACTION" type="hidden" value="' || ACTION || '">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || lang ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID || '" CLASS="HIDDEN">
<P align="right">');

if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT class="SUBMIT" id="ACTION" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" name="ACTION" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_REFERENCES.submit();">
');
end if;


htp.prn('</P>
<P align="center">
<table width="500px">
');
   htp.p('<tr><td>'||RASDI_TRNSLT.text('Reference to:',lang)||'</td><td>
   <select name="RFORMID" class="SELECT" id="RFORMID" value='||rformid||'>
      <option class="selectp" value=""></option>
   ');

for r in (select distinct f.formid, f.form, c2.application
from rasd_forms f, rasd_forms_compiled c1,  rasd_forms_compiled c2
where c1.formid = pformid
  and c1.lobid = c2.lobid
  and c1.engineid = c2.engineid
--  and c2.compileyn = 'Y'
  and c2.formid = f.formid
order by c2.application, f.form) loop

if r.formid = rformid then
htp.p(' <option class="selectp" value="'||r.formid||'" selected>'||r.form||' ('||r.application||')</option>'); 
else     
htp.p(' <option class="selectp" value="'||r.formid||'">'||r.form||' ('||r.application||')</option>'); 
end if;   
end loop;   
   
htp.p('   
   </select>
   
   </td></tr>');
      
htp.p('
   </table>
   
<P align="center">
<table width="500px">
        <tr><td colspan="2"><B>'||RASDI_TRNSLT.text('Forms referenced to the same reference:',lang)||'</B></td></tr>
');
      /*
      SQL

      select 'htp.p(''<tr><td>'||object_name||'</td><td>''||'||object_name||'.version(x)); htp.p(''</td><td title="''||x||''">&nbsp;&nbsp;&nbsp;log&nbsp;&nbsp;&nbsp;</td></tr>''); ' from all_objects where object_type = 'PACKAGE' and owner = 'GENUTLDEV'
      order by object_name

      */
for r in (
select f.form , f.label
from rasd_references r, rasd_forms f
where (r.rlobid, r.rform) in (
select r.rlobid, r.rform 
from rasd_references r
where r.formid = pformid
)
and r.formid = f.formid
order by 1
) loop
        htp.p('<tr><td>'||r.form||'</td><td>'||r.label||'</td></tr>');
end loop;
      
htp.p('
   </table>
</p>
<P align="center">
<table width="500px">
        <tr><td colspan="2"><B>'||RASDI_TRNSLT.text('Forms referenced to this form:',lang)||'</B></td></tr>');

for r in (
select f.form , f.label
from rasd_forms f
where (formid) in (
select x.formid
from rasd_forms f, rasd_references x
where f.formid = pformid
  and f.lobid = x.rlobid
  and f.form = x.rform
)
order by 1  
) loop
        htp.p('<tr><td>'||r.form||'</td><td>'||r.label||'</td></tr>');
end loop;

      htp.prn('
    </table>
</p>
<p>
</p>
<table width="100%" border="0"><tbody><tr>
');

if message is not null then
htp.p('
<td width="1%" class="sporociloh" nowrap=""><font color="green" size="4">'||RASDI_TRNSLT.text('Message', lang)||'</font></td>
<td class="sporocilom">'||message||'</td>');
end if;
htp.p('
<td align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT class="SUBMIT" id="ACTION" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" name="ACTION" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_REFERENCES.submit();">
');
end if;
htp.prn('
</td>
</tr>
</tbody></table>



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
    elsif ACTION = GBUTTONSRC or ACTION is null then
      pselect;
      poutput;
    elsif ACTION = RASDI_TRNSLT.text('Save', lang) then
      
      pcommit; 
      if message is null then
      message := RASDI_TRNSLT.text('Changes are saved.', lang);
      end if;
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

