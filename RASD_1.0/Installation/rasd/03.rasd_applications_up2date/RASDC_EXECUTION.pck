create or replace package RASDC_EXECUTION is
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
create or replace package body RASDC_EXECUTION is
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
20210303 - Changes because change type of SQLTEXT    
20201022 - Added triggers PRE_SELECT and POST_SELECT on FORM level.    
20200120 - First version
*/';
    return 'v.1.1.20210303225530';

  end;

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
  vaddlink varchar2(1000) ;
  PCHK varchar2(2) := 'N';
  v_txt varchar2(32000);
  ppages varchar2(10) := '';
  pf varchar2(200) := '';
  ACTION varchar2(100);
  pformid number;
  lang varchar2(10);
begin
  
      rasdi_client.secCheckPermission('RASDC_EXECUTION', '');
 
      for i__ in 1 .. nvl(name_array.count, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          pformid := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('PF') then
          PF := value_array(i__);
        elsif upper(name_array(i__)) = upper('PCHK') then
          PCHK := value_array(i__);
        elsif upper(name_array(i__)) = upper('PPAGES') then
          PPAGES := value_array(i__);
        end if;
     end loop;
      vaddlink := '&LANG='||lang||'&PFORMID='||pformid;
      if PCHK is null then PCHK := 'N'; end if;
      
      RASDC_LIBRARY.checkprivileges(PFORMID);

htp.p('
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">  <META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'

<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
}
function onLoad() {
  onResize();
}
</SCRIPT>
<style>


h2 {
   color: red;
   font-size: medium;
       margin: 0px;
}

h3 {
   font-size: medium;
       margin: 0px;
}

a {
color: black;
}

.join{
display: flex;
}

.aright{
margin-left: 10px;
}


.hintx {
    margin: 15 auto;
    padding: 5;
    background-color: red; 
    font-family: Arial, Helvetica, sans-serif;
    width: 770px;
}

.hinty {
      font-family: monospace;
}


.start {
 display: inline-grid;
 width:770px;
   background-color: white; 
}



.trigger {
    width: 110px;
    height: 30px;
    background-color: rgb(201, 218, 248);
    color: rgba(108, 145, 209, 1);
    margin: 3px;
    padding: 3px;
    float: left;
    border-radius: 5px;
}

.namesize {

}

.execution {
 width:770px;
 text-align: -webkit-center;
   background-color: white; 
}

.execution TABLE {
    width: 500px;
    background-color: azure;
}

.blocks {
background: #e2e2e2;
    margin: 6px;
    display:inline-block;
        padding: 6px;
    border-radius: 5px;        
}

.blocks A{
    display:block;
}


.submitcode {
    background-color:   rgba(251, 228, 213);
    display: inline-grid;
        width:770px;
}


.commit {
    background-color:   rgba(222, 234, 246);
    display: inline-grid;
    width:770px;
}

.selectcode {
    background-color:   rgba(226, 239, 217);
    display: inline-grid;
    width:770px;
}

.output {
    background-color:   rgba(255, 242, 204);
    display: inline-grid;
    width:770px;
}


.finish {
  display: inline-grid;
  width:770px;
   background-color: white; 
}

h1{
      font-size: larger;
      margin: 0px;
}

.headform {
    text-align-last: center;
    color: white;     
}

</style>
<SCRIPT LANGUAGE="Javascript1.2">
function js_kliksubmit() {
  document.getElementById("RASDC_EXECUTION").submit();
}
</SCRIPT>

');


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
htp.p('      
</HEAD>
<BODY  onload="onLoad();" onresize="onResize();">');  
htp.p('
<div class="hintx">
<div class="hinty">
<div>
<div class="headform">
    <h1><a href="https://sourceforge.net/p/rasd/wiki/RASD_EXECUTE/" target="_blank"><img src="rasdc_files.showfile?pfile=pict/rasd.gif" alt="RASD" width="5%"></a>RASD EXECUTION NAVIGATOR - WEBCLIENT</h1>
</div>
<form id="RASDC_EXECUTION" name="RASDC_EXECUTION" method="post" action="!RASDC_EXECUTION.program">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<b><font id="B20_LAB">Filter</font></b> &nbsp;<select name="PPAGES" class="SELECT" onchange="js_kliksubmit();"><script language="JavaScript">
js_PPAGES_LOV('''||ppages||''');
</script>
</select>
<input type="text" size="30" onchange="js_kliksubmit();" name="PF" id="PF" value="'||PF||'" title="Form searcher ..."> 
<input type="checkbox" onchange="js_kliksubmit();" ');
if PCHK = 'Y' then htp.p(' checked '); end if;
htp.p(' name="PCHK" id="PCHK" value="Y" title="Show all triggers,...">      
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="Submit" onclick="js_kliksubmit();">
</form>
</div>
');
  
htp.p('<div class="start">'); 
htp.p('<h2>--CUSTOM PROCEDURES, FUNCTIONS, TYPES</h2>');     
htp.p('<div>');      
      for r in ( 
      select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
                     from rasd_triggers t
                    where formid = pformid
                      and blockid is null
                      and upper(triggerid) not in
                       (select tctype from RASD_TRIGGERS_CODE_TYPES t where (language = 'P' and tclevel = 'F' or language = 'J' and tclevel = 'F' or language = 'C' and tclevel = 'F' or language = 'H' and tclevel = 'F'))
                      and upper(triggerid) not like '%REF(%'
                     and plsql is not null
                     and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
                     order by triggerid
      ) loop 
htp.p('<div class="trigger">');           
htp.p('<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >'||r.triggerid||'</a>');     
htp.p('</div>');
      end loop;
htp.p('</div>');


htp.p('</div>'); 
--SUBMIT     
htp.p('<div class="submitcode">');      
htp.p('<h2>--SUBMIT</h2>');
htp.p('<h3>psubmit</h3>');
v_txt := '<div class="trigger"><div class="namesize">&lt;PRE_SUBMIT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'PRE_SUBMIT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

v_txt := '<div class="trigger"><div class="namesize">&lt;ON_SUBMIT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'ON_SUBMIT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

v_txt := '<div class="trigger"><div class="namesize">&lt;POST_SUBMIT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'POST_SUBMIT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;


htp.p('</div>');
--COMMIT      
htp.p('<div class="commit">');      
htp.p('<h2>--COMMIT</h2>');
htp.p('<h3>pcommit</h3>');

v_txt := '<div class="trigger"><div class="namesize">&lt;PRE_COMMIT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'PRE_COMMIT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;
     

      for rb in (
    select b.formid,
           b.blockid,
           to_char(substr(b.sqltext,1,1)) sqltext,
           b.label,
           min(p.orderby) orderby,
           '!rasdc_fieldsonblock.program?Pblockid='||b.blockid||vaddlink link
      from rasd_blocks b, rasd_fields p
     where b.formid = pformid
       and b.formid = p.formid
       and b.blockid = p.blockid
       and (b.blockid in 
(select a.blockid from rasd_pages a where a.page = to_number(ppages) and formid = pformid )    or ppages is null )                 

     group by b.formid,
              b.blockid,
              to_char(substr(b.sqltext,1,1)),
              b.label
     order by orderby, b.blockid) loop
v_txt := '<div class="blocks">';      

v_txt := v_txt ||'<a target="_parent" onclick="javascript: window.opener.location = '''||rb.link||'''" >'||rb.blockid||' - '||rb.label||'</a>';     
v_txt := v_txt ||'<h3>pcommit_'||rb.blockid||'</h3>';
     
      for r in ( 
          select x.tctype, t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||t.blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t, rasd_triggers_code_types x 
          where formid(+) =  pformid   and blockid(+) = rb.blockid and plsql(+) is not null
               and x.tctype = t.triggerid(+)
               and x.tclevel = 'B'
               and upper(triggerid(+)||':'||plsql(+)||':'||plsqlspec(+)) like upper('%'||pf||'%')
               and x.tctype in ('ON_VALIDATE','PRE_INSERT','ON_MANDATORY','ON_INSERT','POST_INSERT', 'ON_LOCK','PRE_DELETE','ON_DELETE','POST_DELETE','PRE_UPDATE','ON_UPDATE','POST_UPDATE')
               and (PCHK = 'Y' or PCHK='N' and t.triggerid is not null)
          order by decode(x.tctype ,'ON_VALIDATE', 1 ,'PRE_INSERT', 2 ,'ON_MANDATORY', 3 ,'ON_INSERT', 4,'POST_INSERT', 5 , 'ON_LOCK', 6 ,'PRE_DELETE', 7,'ON_DELETE', 8,'POST_DELETE', 9,'PRE_UPDATE', 10,'ON_UPDATE', 11,'POST_UPDATE', 12, 99 )                 
      ) loop 
v_txt := v_txt ||'<div class="trigger">';      
v_txt := v_txt ||'<div class="namesize">&lt;'||r.tctype||'&gt;</div>';           
if r.triggerid is not null then
v_txt := v_txt ||'<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';     
end if;
v_txt := v_txt ||'</div>';      
      end loop;
     
     
v_txt := v_txt ||'</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'>Source<') > 0 then htp.p(v_txt); end if;
     end loop;
     


v_txt := '<div class="trigger"><div class="namesize">&lt;POST_COMMIT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'POST_COMMIT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

     
htp.p('</div>');   
--SELECT  
htp.p('<div class="selectcode">');      
htp.p('<h2>--SELECT</h2>');
htp.p('<h3>pselect</h3>');

v_txt := '<div class="trigger"><div class="namesize">&lt;PRE_SELECT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'PRE_SELECT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;


      for rb in (
    select b.formid,
           b.blockid,
           to_char(substr(b.sqltext,1,1)) sqltext,
           b.label,
           min(p.orderby) orderby,
           '!rasdc_fieldsonblock.program?Pblockid='||b.blockid||vaddlink link,
           '!rasdc_sql.program?ACTION=Search&Pblockid='||b.blockid||vaddlink linksql
     from rasd_blocks b, rasd_fields p
     where b.formid = pformid
       and b.formid = p.formid
       and b.blockid = p.blockid
                            and (b.blockid in 
(select a.blockid from rasd_pages a where a.page = to_number(ppages) and formid = pformid )    or ppages is null )                 
     group by b.formid,
              b.blockid,
              to_char(substr(b.sqltext,1,1)),
              b.label
     order by orderby, b.blockid) loop
v_txt := '<div class="blocks">';      
v_txt := v_txt|| '<div class="join">'; 
v_txt := v_txt||'<a target="_parent" onclick="javascript: window.opener.location = '''||rb.link||'''" >'||rb.blockid||' - '||rb.label||'</a>';  

if PCHK = 'Y' or (PCHK = 'N' and rb.sqltext is not null ) then
if rb.sqltext is not null  then
v_txt := v_txt||'<a target="_parent" class="aright" onclick="javascript: window.opener.location = '''||rb.linksql||'''" ><img height="20" title="SQL" src="rasdc_files.showfile?pfile=pict/gumbsqlred.jpg" width="21" border="0"></a>';     
else
v_txt := v_txt||'<a target="_parent" class="aright" onclick="javascript: window.opener.location = '''||rb.linksql||'''" ><img height="20" title="SQL" src="rasdc_files.showfile?pfile=pict/gumbsql.jpg" width="21" border="0"></a>';     
end if;
end if;
v_txt := v_txt||'</div>';
v_txt := v_txt ||'<h3>pselect_'||rb.blockid||'</h3>';
     
      for r in ( 
          select x.tctype, t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||t.blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t, rasd_triggers_code_types x 
          where formid(+) =  pformid   and blockid(+) = rb.blockid and plsql(+) is not null
               and x.tctype = t.triggerid(+)
               and x.tclevel = 'B'
               and x.tctype in ('PRE_SELECT','ON_SELECT','ON_LOCK_VALUE','POST_SELECT','XX', 'YY')
               and upper(triggerid(+)||':'||plsql(+)||':'||plsqlspec(+)) like upper('%'||pf||'%')
               --and (PCHK = 'Y' or PCHK='N' and t.triggerid is not null)
          order by decode(x.tctype ,'PRE_SELECT', 1 ,'ON_SELECT', 2 ,'ON_LOCK_VALUE', 3 ,'POST_SELECT', 4,'XX', 5 , 'YY', 6 , 99 )                 
      ) loop 
v_txt := v_txt||'<div class="trigger">';      
v_txt := v_txt||'<div class="namesize">&lt;'||r.tctype||'&gt;</div>';           
if r.triggerid is not null then
v_txt := v_txt||'<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';     
end if;
v_txt := v_txt||'</div>';      
      end loop;

v_txt := v_txt||'</div>';      
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'>Source<') > 0 or PCHK = 'N' and instr(v_txt,'gumbsqlred.jpg') > 0  then htp.p(v_txt); end if;

     end loop;

v_txt := '<div class="trigger"><div class="namesize">&lt;POST_SELECT&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'POST_SELECT'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;



--CLEAR
htp.p('<h3>pclear</h3>');

v_txt := '<div class="trigger"><div class="namesize">&lt;ON_CLEAR&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'ON_CLEAR'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;


      for rb in (
    select b.formid,
           b.blockid,
           to_char(substr(b.sqltext,1,1)) sqltext,
           b.label,
           min(p.orderby) orderby,
           '!rasdc_fieldsonblock.program?Pblockid='||b.blockid||vaddlink link
     from rasd_blocks b, rasd_fields p
     where b.formid = pformid
       and b.formid = p.formid
       and b.blockid = p.blockid
                     and (b.blockid in 
(select a.blockid from rasd_pages a where a.page = to_number(ppages) and formid = pformid )    or ppages is null )                        
     group by b.formid,
              b.blockid,
              to_char(substr(b.sqltext,1,1)),
              b.label
     order by orderby, b.blockid) loop
v_txt := '<div class="blocks">';      
v_txt := v_txt|| '<div class="join">'; 
v_txt := v_txt||'<a target="_parent" onclick="javascript: window.opener.location = '''||rb.link||'''" >'||rb.blockid||' - '||rb.label||'</a>';  

v_txt := v_txt||'</div>';
v_txt := v_txt ||'<h3>pclear_'||rb.blockid||'</h3>';
     
      for r in ( 
          select x.tctype, t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||t.blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t, rasd_triggers_code_types x 
          where formid(+) =  pformid   and blockid(+) = rb.blockid and plsql(+) is not null
               and x.tctype = t.triggerid(+)
               and x.tclevel = 'B'
               and x.tctype in ('ON_NEW_RECORD', 'ON_CLEAR')
               and upper(triggerid(+)||':'||plsql(+)||':'||plsqlspec(+)) like upper('%'||pf||'%')
               --and (PCHK = 'Y' or PCHK='N' and t.triggerid is not null)
          order by decode(x.tctype ,'ON_NEW_RECORD', 5 , 'ON_CLEAR', 6 , 99 )                 
      ) loop 
v_txt := v_txt||'<div class="trigger">';      
v_txt := v_txt||'<div class="namesize">&lt;'||r.tctype||'&gt;</div>';           
if r.triggerid is not null then
v_txt := v_txt||'<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';     
end if;
v_txt := v_txt||'</div>';      
      end loop;

v_txt := v_txt||'</div>';      
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'>Source<') > 0 or PCHK = 'N' and instr(v_txt,'gumbsqlred.jpg') > 0  then htp.p(v_txt); end if;

     end loop;
     
     
     
     
htp.p('</div>');
--OUTPUT      
htp.p('<div class="output">');      
htp.p('<h2>--OUTPUT</h2>');
htp.p('<h3>poutput</h3>');

for r in (select l.linkid,
       l.link,
       '!rasdc_links.program?Plinkid='||l.linkid||vaddlink linkx
from rasd_links l
where l.type in ('S','T')
  and l.formid = pformid
  order by l.link) loop


htp.p('<a target="_parent" onclick="javascript: window.opener.location = '''||r.linkx||'''" >'||r.linkid||'('||r.link||')</a>');

end loop;


v_txt := '<div class="trigger"><div class="namesize">&lt;FORM_UIHEAD&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_cssjs.webclient?PBLOKPROZILECNOV=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'FORM_UIHEAD'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

v_txt := '<div class="trigger"><div class="namesize">&lt;FORM_CSS&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_cssjs.webclient?PBLOKPROZILECNOV=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'FORM_CSS'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

v_txt := '<div class="trigger"><div class="namesize">&lt;FORM_JS&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_cssjs.webclient?PBLOKPROZILECNOV=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'FORM_JS'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;
    
      for rb in (
    select b.formid,
           b.blockid,
           to_char(substr(b.sqltext,1,1)) sqltext,
           b.label,
           min(p.orderby) orderby,
           '!rasdc_fieldsonblock.program?Pblockid='||b.blockid||vaddlink link
     from rasd_blocks b, rasd_fields p
     where b.formid = pformid
       and b.formid = p.formid
       and b.blockid = p.blockid
                     and (b.blockid in 
(select a.blockid from rasd_pages a where a.page = to_number(ppages) and formid = pformid )    or ppages is null )                        
     group by b.formid,
              b.blockid,
              to_char(substr(b.sqltext,1,1)),
              b.label
     order by orderby, b.blockid) loop

v_txt := '<div class="blocks">';      

v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||rb.link||'''" >'||rb.blockid||' - '||rb.label||'</a>';     

v_txt := v_txt || '<h3>output_'||rb.blockid||'_DIV</h3>';

v_txt := v_txt || '<div class="trigger"><div class="namesize">&lt;PRE_UI&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid = rb.blockid  and t.triggerid = 'PRE_UI'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';

 for rp in (
    select p.formid,
           p.blockid,
           p.fieldid,
           p.label,
           '!rasdc_fieldsonblock.program?Pblockid='||p.blockid||vaddlink link
     from rasd_fields p
     where p.formid = pformid
       and p.blockid = rb.blockid
       and p.element = 'PLSQL_'
     order by p.orderby) loop
     
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid = rb.blockid||rp.fieldid  and t.triggerid = 'ON_UI'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt ||'<div class="trigger">';      
v_txt := v_txt ||'<div class="namesize">&lt;ON_UI&gt; '||rp.fieldid||'</div>';
v_txt := v_txt ||'<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';     
v_txt := v_txt ||'</div>';      
      end loop;     
     
     end loop;

 
v_txt := v_txt || '<div class="trigger"><div class="namesize">&lt;POST_UI&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid='||blockid||'/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid = rb.blockid  and t.triggerid = 'POST_UI'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
     
v_txt := v_txt || '</div>';

if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'>Source<') > 0 then htp.p(v_txt); end if;
     
     end loop;  
htp.p('</div>');      
--
htp.p('<div class="finish">');      

htp.p('<h2>--EXECUTING PART</h2>'); 
htp.p('<h2>--START</h2>'); 

v_txt := '<div class="trigger"><div class="namesize">&lt;PRE_ACTION&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'PRE_ACTION'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

      
v_txt := '<div class="trigger"><div class="namesize">&lt;ON_ACTION&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'ON_ACTION'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

htp.p('
<div class="execution">
<table>
<thead>
<tr>
<th>ACTION</th>
<th>Procedures</th>
</tr>
</thead>
<tbody>
<tr>
<td>not defined</td>
<td>pselect, poutput</td>
</tr>
<tr>
<td>GBUTTONBCK</td>
<td>pselect, poutput</td>
</tr>
<tr>
<td>GBUTTONFWD</td>
<td>pselect, poutput</td>
</tr>
<tr>
<td>GBUTTONSRC</td>
<td>pselect, poutput</td>
</tr>
<tr>
<td>GBUTTONSAVE</td>
<td>pcommit, pselect, poutput</td>
</tr>
<tr>
<td>GBUTTONCLR</td>
<td>pclear, poutput</td>
</tr>
</tbody>
</table>
</div>
');


v_txt := '<div class="trigger"><div class="namesize">&lt;POST_ACTION&gt;</div>'; 
      for r in ( 
          select t.triggerid, '!rasdc_triggers.program?pBLOKtriggerid=/.../'||t.triggerid||vaddlink link
          from rasd_triggers t where formid =  pformid   and blockid is null  and t.triggerid = 'POST_ACTION'  and plsql is not null and upper(triggerid||':'||plsql||':'||plsqlspec) like upper('%'||pf||'%')
      ) loop      
v_txt := v_txt || '<a target="_parent" onclick="javascript: window.opener.location = '''||r.link||'''" >Source</a>';
      end loop;
v_txt := v_txt || '</div>';
if PCHK = 'Y' or PCHK = 'N' and instr(v_txt,'<a') > 0 then htp.p(v_txt); end if;

htp.p('<h2>--END</h2>');  
htp.p('</div>');

htp.p('</div>');      
htp.p('
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT> 
</div>
</BODY> </HTML>
');  

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
end ;
/
