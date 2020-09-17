create or replace package EXECUTESQL is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: EXECUTESQL generated on 08.01.20 by user RASDCLI.     
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | This program is generated form RASD version 1.                       |
// +----------------------------------------------------------------------+
*/    
function version return varchar2;
function metadata return clob;
procedure metadata;
procedure webclient(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure rest(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure rlog(v_clob clob);
procedure form_js(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
procedure form_css(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/

function run(vsql varchar2,  n out number) return varchar2;
procedure output(vsql varchar2, lang varchar2) ;

/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/

end;
/

create or replace package body EXECUTESQL is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: EXECUTESQL generated on 08.01.20 by user RASDCLI.    
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | This program is generated form RASD version 1.                       |
// +----------------------------------------------------------------------+
*/    
  type rtab is table of rowid          index by binary_integer;
  type ntab is table of number         index by binary_integer;
  type dtab is table of date           index by binary_integer;
  type ttab is table of timestamp      index by binary_integer;
  type ctab is table of varchar2(4000) index by binary_integer;
  type cctab is table of clob index by binary_integer;
  type itab is table of pls_integer    index by binary_integer;
  type set_type is record
  (
    visible boolean default true,
    readonly boolean default false,
    disabled boolean default false,
    required boolean default false,
    error varchar2(4000) ,
    info varchar2(4000) ,
    custom   varchar2(256)
  );
  type stab is table of set_type index by binary_integer;
  log__ clob := '';
  set_session_block__ clob := '';
  TYPE LOVrec__ IS RECORD (label varchar2(4000),id varchar2(4000) );
  TYPE LOVtab__ IS TABLE OF LOVrec__ INDEX BY BINARY_INTEGER;
  LOV__ LOVtab__;
  RESTRESTYPE varchar2(4000);
  ACTION                        varchar2(4000);
  ERROR                         varchar2(4000);
  MESSAGE                       varchar2(4000);
  WARNING                       varchar2(4000);
  B10X1                         ctab;
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/


function run(vsql varchar2,  n out number) return varchar2 is
          cid     pls_integer;
        begin

          cid := dbms_sql.open_cursor;
          dbms_sql.parse(cid, vsql, dbms_sql.native);
          n := dbms_sql.execute(cid);
--htp.p(n);
		return   '';
        exception
          when others then
		   return sqlerrm;
        end;
		
procedure output(vsql varchar2, lang varchar2) is
          cid1 pls_integer;
        begin
          cid1 := owa_util.bind_variables(vsql);
          htp.p('<div class="sqlresults"><table>');
        
		owa_util.cellsprint(cid1, 100);
        
		htp.p('</table></div>');
end;

/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/

     procedure htpClob(v_clob clob) is
        i number := 0;
        v clob := v_clob;
       begin
       while length(v) > 0 and i < 100000 loop
        htp.prn(substr(v,1,10000));
        i := i + 1;
        v := substr(v,10001);
       end loop; 
       end; 
     procedure rlog(v_clob clob) is
       begin
        log__ := log__ ||systimestamp||':'||v_clob||'<br/>';
        rasd_client.callLog('52','||v_clob||', systimestamp, '' );
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '

';
       end; 
     function form_js return clob is
       begin
        return  '
$(function() {

  addSpinner();
//   initRowStatus();
//   transformVerticalTable("B15_TABLE", 4 );
//   setShowHideDiv("BLOCK_NAME_DIV", true);
//   CheckFieldValue(pid , pname)
//   CheckFieldMandatory(pid , pname)
 });
        ';
       end; 
     function form_css return clob is
       begin
        return '

        ';
       end; 
procedure form_js(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is begin htpClob(form_js); end;
procedure form_css(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is begin htpClob(form_css); end;
  function version return varchar2 is
  begin
   return 'v.1.1.20200108112125'; 
  end;
  procedure on_session is
    i__ pls_integer := 1;
  begin
  if ACTION is not null then 
set_session_block__ := set_session_block__ || 'begin ';
set_session_block__ := set_session_block__ || 'rasd_client.sessionStart;';
set_session_block__ := set_session_block__ || ' rasd_client.sessionClose;';
set_session_block__ := set_session_block__ || 'exception when others then null; end;';
  else 
 rasd_client.sessionStart;
declare vc varchar2(2000); begin
null;
if B10X1(i__) is null then vc := rasd_client.sessionGetValue('B10X1'); B10X1(i__)  := vc;  end if; 
exception when others then  null; end;    rasd_client.sessionClose;  end if;
  end;
  procedure on_submit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
    v_max  pls_integer := 0;
  begin
-- submit fields
    for i__ in 1..nvl(num_entries,0) loop
      if 1 = 2 then null;
      elsif  upper(name_array(i__)) = 'RESTRESTYPE' then RESTRESTYPE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10X1_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10X1(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10X1') and B10X1.count = 0 and value_array(i__) is not null then
        B10X1(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10X1.count > v_max then v_max := B10X1.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10X1.exists(i__) then
        B10X1(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="52" blockid="">
B10X1(1) := 'Client for running SQL exists.<Br/>';
B10X1(1) := B10X1(1) ||'Client is granted to RASD schema:<Br/>';
    declare
      n number;
    begin 
	  for r in (select owner from all_objects o where o.object_name = 'RASDC_SQLCLIENT' 
		    and o.object_type = 'PACKAGE') loop

execute immediate 'grant execute on '||user||'.EXECUTESQL to '||r.owner||'';
B10X1(1) := B10X1(1) ||r.owner||'<BR/>';
			
    end loop;
            
    end;
--</POST_SUBMIT>
    null;
  end;
  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
  begin
-- Reading post variables into fields.
    on_submit(name_array ,value_array); on_session;
    post_submit;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 1 = 0 then k__ := i__ + 0;
      else  
       if i__ > 1 then  k__ := i__ + 0;
       else k__ := 0 + 1;
       end if;
      end if;
      j__ := i__;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10X1(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    ERROR := null;
    MESSAGE := null;
    WARNING := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);

  null;
  end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10X1.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10X1.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit is
  begin


  null; 
  end;
  procedure poutput is
  function ShowFieldERROR return boolean is 
  begin 
    return true;
  end; 
  function ShowFieldMESSAGE return boolean is 
  begin 
    return true;
  end; 
  function ShowFieldWARNING return boolean is 
  begin 
    return true;
  end; 
  function ShowBlockB10_DIV return boolean is 
  begin 
    return true;
  end; 
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock"></div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10X1"><span id="B10X1_LAB" class="label"></span></td><td class="rasdTxB10X1 rasdTxTypeC" id="rasdTxB10X1_1"><font id="B10X1_1_RASD" class="rasdFont">'||B10X1(1)||'</font></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Execute SQL client')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="EXECUTESQL_LAB" class="rasdFormLab">Execute SQL client '|| rasd_client.getHtmlDataTable('EXECUTESQL_LAB') ||'     </div><div id="EXECUTESQL_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('EXECUTESQL_MENU') ||'     </div>
<form name="EXECUTESQL" method="post"><div id="EXECUTESQL_DIV" class="rasdForm"><div id="EXECUTESQL_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
</div><div id="EXECUTESQL_BODY" class="rasdFormBody">'); output_B10_DIV; htp.p('</div><div id="EXECUTESQL_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="EXECUTESQL_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="EXECUTESQL_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="EXECUTESQL_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('EXECUTESQL_FOOTER',1,instr('EXECUTESQL_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
    ');
  null; end;
  procedure poutputrest is
    v_firstrow__ boolean;
    function escapeRest(v_str varchar2) return varchar2 is 
    begin
      return replace(v_str,'"','&quot;');
    end;
    function escapeRest(v_str clob) return clob is 
    begin
      return replace(v_str,'"','&quot;');
    end;
  function ShowBlockB10_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="EXECUTESQL" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10x1><![CDATA['||B10X1(1)||']]></b10x1>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"EXECUTESQL","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockb10_DIV then 
    htp.p('"b10":['); 
     htp.p('{'); 
    htp.p('"b10x1":"'||escapeRest(B10X1(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"b10":[]'); 
  end if; 
    htp.p('}}'); 
end if;
  null; end;
procedure webclient(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('EXECUTESQL',ACTION);  
  if ACTION is null then null;
    pselect;
    poutput;
  end if;

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Execute SQL client')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="EXECUTESQL_LAB" class="rasdFormLab">Execute SQL client '|| rasd_client.getHtmlDataTable('EXECUTESQL_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('EXECUTESQL_FOOTER',1,instr('EXECUTESQL_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
    pLog;
end; 
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('EXECUTESQL',ACTION);  

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
    poutput;
  end if;

-- Error handler for the main program.
 exception
  when rasd_client.e_finished then null;

end; 
procedure rest(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('EXECUTESQL',ACTION);  
  if ACTION is null then null;
    pselect;
    poutputrest;
  end if;

  -- The execution after default execution based on  ACTION.
  if  ACTION is not null then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="EXECUTESQL" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"EXECUTESQL","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>52</formid><form>EXECUTESQL</form><version>1</version><change>08.01.2020 11/21/25</change><user>RASDCLI</user><label><![CDATA[Execute SQL client]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>19.12.2017 12/45/45</change><compileyn>N</compileyn><application>RASD lib&apos;s</application><owner>rasd</owner><editor>rasd</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
     return v_vc;
  end;
function metadata return clob is
  v_clob clob := '';
  v_vc cctab;
  begin
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       v_clob := v_clob || v_vc(i);
     end loop;
     return v_clob;
  end;
procedure metadata is
  v_clob clob := '';
  v_vc cctab;
  begin
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end EXECUTESQL;
/

