create or replace package DEMO_TEXT_EDITOR is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_TEXT_EDITOR generated on 08.01.20 by user RASDCLI.     
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
end;
/

create or replace package body DEMO_TEXT_EDITOR is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_TEXT_EDITOR generated on 08.01.20 by user RASDCLI.    
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
  WARNING                       varchar2(4000);  PAGE                          varchar2(4000) := 1
;
  B10_COPYEDITOR                ctab;
  B10EDITOR                     ctab;
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
        rasd_client.callLog('51','||v_clob||', systimestamp, '' );
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '
	<script src="/rasdlib/docs/ckeditor_4.3_full.zip/ckeditor/ckeditor.js"></script>
	<link rel="stylesheet" href="/rasdlib/docs/ckeditor_4.3_full.zip/ckeditor/samples/sample.css">

';
       end; 
     function form_js return clob is
       begin
        return  '
 $(function() {
     
      CKEDITOR.replace("B10EDITOR_1_RASD");
     
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
   return 'v.1.1.20200108100045'; 
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
if B10EDITOR(i__) is null then vc := rasd_client.sessionGetValue('B10EDITOR'); B10EDITOR(i__)  := vc;  end if; 
if B10_COPYEDITOR(i__) is null then vc := rasd_client.sessionGetValue('B10_COPYEDITOR'); B10_COPYEDITOR(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10_COPYEDITOR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10_COPYEDITOR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10EDITOR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10EDITOR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10_COPYEDITOR') and B10_COPYEDITOR.count = 0 and value_array(i__) is not null then
        B10_COPYEDITOR(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10EDITOR') and B10EDITOR.count = 0 and value_array(i__) is not null then
        B10EDITOR(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10EDITOR.count > v_max then v_max := B10EDITOR.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10EDITOR.exists(i__) then
        B10EDITOR(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B10_COPYEDITOR.count > v_max then v_max := B10_COPYEDITOR.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10_COPYEDITOR.exists(i__) then
        B10_COPYEDITOR(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="51" blockid="">
B10EDITOR(1) := 'Wellcome to the text editor<br>
<BR>
Add CKEditor libs in  FORM_UIHEAD<BR>
<BR>
and javascript in FORM_JS<BR>
<BR>
 $(function() {<BR>
     CKEDITOR.replace("B10EDITOR_1_RASD");<BR>   
  });<BR>
<BR>
';
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
        B10EDITOR(i__) := null;

      end loop;
  end;
  procedure pclear_B10_COPY(pstart number) is
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
        B10_COPYEDITOR(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    ERROR := null;
    MESSAGE := null;
    WARNING := null;
    PAGE := 1;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);
    pclear_B10_COPY(0);

  null;
  end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10EDITOR.count);
  null; end;
  procedure pselect_B10_COPY is
    i__ pls_integer;
  begin
      pclear_B10_COPY(B10_COPYEDITOR.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10EDITOR.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10_COPY is
  begin
    for i__ in 1..B10_COPYEDITOR.count loop
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
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldMESSAGE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldPAGE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldWARNING return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB10_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB10_COPY_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
procedure pre_output_B10_DIV is  begin
--<pre_ui formid="51" blockid="B10">
if ShowBlockB10_DIV then
  htp.p('PRE UI');
end if;
--</pre_ui>
  end;
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock"></div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10EDITOR"><span id="B10EDITOR_LAB" class="label"></span></td><td class="rasdTxB10EDITOR rasdTxTypeC" id="rasdTxB10EDITOR_1"><textarea name="B10EDITOR_1" id="B10EDITOR_1_RASD" class="rasdTextarea">'||B10EDITOR(1)||'</textarea></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure post_output_B10_DIV is  begin
--<post_ui formid="51" blockid="B10">
if ShowBlockB10_DIV then
htp.p('POST UI');
end if;



--</post_ui>
  end;
procedure pre_output_B10_COPY_DIV is  begin
--<pre_ui formid="51" blockid="B10_COPY">
htp.p('PRE UI 2');
--</pre_ui>
  end;
procedure output_B10_COPY_DIV is begin htp.p('');  if  ShowBlockB10_COPY_DIV  then  
htp.prn('<div  id="B10_COPY_DIV" class="rasdblock"><div>
<caption><div id="B10_COPY_LAB" class="labelblock"></div></caption>
<table border="0" id="B10_COPY_TABLE"><tr id="B10_COPY_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10_COPY" id="rasdTxLabB10_COPYEDITOR"><span id="B10_COPYEDITOR_LAB" class="label"></span></td><td class="rasdTxB10_COPYEDITOR rasdTxTypeC" id="rasdTxB10_COPYEDITOR_1"><textarea name="B10_COPYEDITOR_1" id="B10_COPYEDITOR_1_RASD" class="rasdTextarea">'||B10_COPYEDITOR(1)||'</textarea></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure post_output_B10_COPY_DIV is  begin
--<post_ui formid="51" blockid="B10_COPY">
htp.p('POST UI 2');
--</post_ui>
  end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB10_COPY() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo of integrated text editor')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_TEXT_EDITOR_LAB" class="rasdFormLab">Demo of integrated text editor '|| rasd_client.getHtmlDataTable('DEMO_TEXT_EDITOR_LAB') ||'     </div><div id="DEMO_TEXT_EDITOR_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_TEXT_EDITOR_MENU') ||'     </div>
<form name="DEMO_TEXT_EDITOR" method="post"><div id="DEMO_TEXT_EDITOR_DIV" class="rasdForm"><div id="DEMO_TEXT_EDITOR_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldPAGE  then  
htp.prn('<input name="PAGE" id="PAGE_RASD" type="text" value="'||PAGE||'" class="rasdTextC"/>');  end if;  
htp.prn('
</div><div id="DEMO_TEXT_EDITOR_BODY" class="rasdFormBody">'); pre_output_B10_DIV; output_B10_DIV; post_output_B10_DIV; htp.p(''); pre_output_B10_COPY_DIV; output_B10_COPY_DIV; post_output_B10_COPY_DIV; htp.p('</div><div id="DEMO_TEXT_EDITOR_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_TEXT_EDITOR_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_TEXT_EDITOR_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_TEXT_EDITOR_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('DEMO_TEXT_EDITOR_FOOTER',1,instr('DEMO_TEXT_EDITOR_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockB10_COPY_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DEMO_TEXT_EDITOR" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('<page><![CDATA['||PAGE||']]></page>'); 
    htp.p('</formfields>'); 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10editor><![CDATA['||B10EDITOR(1)||']]></b10editor>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockb10_copy_DIV then 
    htp.p('<b10_copy>'); 
    htp.p('<element>'); 
    htp.p('<b10_copyeditor><![CDATA['||B10_COPYEDITOR(1)||']]></b10_copyeditor>'); 
    htp.p('</element>'); 
  htp.p('</b10_copy>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_TEXT_EDITOR","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p(',"page":"'||escapeRest(PAGE)||'"'); 
    htp.p('},'); 
    if ShowBlockb10_DIV then 
    htp.p('"b10":['); 
     htp.p('{'); 
    htp.p('"b10editor":"'||escapeRest(B10EDITOR(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"b10":[]'); 
  end if; 
    if ShowBlockb10_copy_DIV then 
    htp.p(',"b10_copy":['); 
     htp.p('{'); 
    htp.p('"b10_copyeditor":"'||escapeRest(B10_COPYEDITOR(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b10_copy":[]'); 
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
  rasd_client.secCheckPermission('DEMO_TEXT_EDITOR',ACTION);  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo of integrated text editor')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DEMO_TEXT_EDITOR_LAB" class="rasdFormLab">Demo of integrated text editor '|| rasd_client.getHtmlDataTable('DEMO_TEXT_EDITOR_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DEMO_TEXT_EDITOR_FOOTER',1,instr('DEMO_TEXT_EDITOR_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DEMO_TEXT_EDITOR',ACTION);  

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
  rasd_client.secCheckPermission('DEMO_TEXT_EDITOR',ACTION);  
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
<form name="DEMO_TEXT_EDITOR" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_TEXT_EDITOR","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>51</formid><form>DEMO_TEXT_EDITOR</form><version>1</version><change>08.01.2020 10/00/45</change><user>RASDCLI</user><label><![CDATA[Demo of integrated text editor]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>Y</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>15.12.2017 11/37/18</change><compileyn>Y</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks><block><blockid>B10</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B10</blockid><fieldid>EDITOR</fieldid><type>C</type><format></format><element>TEXTAREA_</element><hiddenyn></hiddenyn><orderby>290875</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10EDITOR</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>B10_COPY</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B10_COPY</blockid><fieldid>EDITOR</fieldid><type>C</type><format></format><element>TEXTAREA_</element><hiddenyn></hiddenyn><orderby>290875</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10_COPYEDITOR</nameid><label></label><linkid><';
 v_vc(2) := '/linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block></blocks><fields><field><blockid></blockid><fieldid>ACTION</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ACTION</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis>N</includevis></field><field><blockid></blockid><fieldid>ERROR</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ERROR</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>MESSAGE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>MESSAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis>N</includevis></field><field><blockid></blockid><fieldid>PAGE</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>290875</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[1]]></defaultval><elementyn>Y</elementyn><nameid>PAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis>N</includevis></field><field><blockid></blockid><fieldid>WAR';
 v_vc(3) := 'NING</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>WARNING</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields><links></links><pages><pagedata><page>0</page><blockid>B10</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>2</page><blockid>B10</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid>B10_COPY</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>1</page><blockid>B10_COPY</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>2</page><blockid>B10_COPY</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid></blockid><fieldid>MESSAGE</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>2</page><blockid></blockid><fieldid>MESSAGE</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid></blockid><fieldid>PAGE</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata></pages><triggers><trigger><blockid></blockid><triggerid>FORM_JS</triggerid><plsql><![CDATA[ $(function() {
     
      CKEDITOR.replace("B10EDITOR_1_RASD");
     
  });	
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>FORM_UIHEAD</triggerid><plsql><![CDATA[	<script src="/rasdlib/docs/ckeditor_4.3_full.zip/ckeditor/ckeditor.js"></script>
	<link rel="stylesheet" href="/rasdlib/docs/ckeditor_4.3_full.zip/ckeditor/samples/sample.css">

]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></sour';
 v_vc(4) := 'ce><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_SUBMIT</triggerid><plsql><![CDATA[B10EDITOR := ''Wellcome to the text editor<br>
<BR>
Add CKEditor libs in  FORM_UIHEAD<BR>
<BR>
and javascript in FORM_JS<BR>
<BR>
 $(function() {<BR>
     CKEDITOR.replace("B10EDITOR_1_RASD");<BR>   
  });<BR>
<BR>
'';
]]></plsql><plsqlspec><![CDATA[-- Executing after filling fields on submit.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>POST_UI</triggerid><plsql><![CDATA[if ShowBlockB10_DIV then
htp.p(''POST UI'');
end if;



]]></plsql><plsqlspec><![CDATA[-- Triggers before afther BLOCK content.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10_COPY</blockid><triggerid>POST_UI</triggerid><plsql><![CDATA[htp.p(''POST UI 2'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before afther BLOCK content.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>PRE_UI</triggerid><plsql><![CDATA[if ShowBlockB10_DIV then
  htp.p(''PRE UI'');
end if;
]]></plsql><plsqlspec><![CDATA[-- Triggers before showing BLOCK content.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10_COPY</blockid><triggerid>PRE_UI</triggerid><plsql><![CDATA[htp.p(''PRE UI 2'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before showing BLOCK content.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger></triggers><elements><element><elementid>1</elementid><pelementid>0</pelementid><orderby>1</orderby><element>HTML_</element><type></type><id>HTML</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid';
 v_vc(5) := '><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>2</elementid><pelementid>1</pelementid><orderby>1</orderby><element>HEAD_</element><type></type><id>HEAD</id><nameid>HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Demo of integrated text editor'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>''); %>]]></value><valuecode><![CDATA['');  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Demo of integrated text editor'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute>';
 v_vc(6) := '</attributes></element><element><elementid>15</elementid><pelementid>1</pelementid><orderby>1</orderby><element>BODY_</element><type></type><id>BODY</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>16</elementid><pelementid>15</pelementid><orderby>3</orderby><element>FORM_</element><type>F</type><id>DEMO_TEXT_EDITOR</id><nameid>DEMO_TEXT_EDITOR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_ACTION</attribute><type>A</type><text></text><name><![CDATA[action]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_METHOD</attribute><type>A</type><text></text><name><![CDATA[method]]></name><value><![CDATA[post]]></value><valuecode><![CDATA[="post"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[DEMO_TEXT_EDITOR]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR"]]></valuecode><forloop></forloop><e';
 v_vc(7) := 'ndloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>17</elementid><pelementid>15</pelementid><orderby>1</orderby><element>FORM_LAB</element><type>F</type><id>DEMO_TEXT_EDITOR_LAB</id><nameid>DEMO_TEXT_EDITOR_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormLab]]></value><valuecode><![CDATA[="rasdFormLab"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_LAB]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textco';
 v_vc(8) := 'de><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Demo of integrated text editor <%= rasd_client.getHtmlDataTable(''DEMO_TEXT_EDITOR_LAB'') %>     ]]></value><valuecode><![CDATA[Demo of integrated text editor ''|| rasd_client.getHtmlDataTable(''DEMO_TEXT_EDITOR_LAB'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>18</elementid><pelementid>15</pelementid><orderby>2</orderby><element>FORM_MENU</element><type>F</type><id>DEMO_TEXT_EDITOR_MENU</id><nameid>DEMO_TEXT_EDITOR_MENU</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMenu]]></value><valuecode><![CDATA[="rasdFormMenu"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_MENU]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_MENU"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></va';
 v_vc(9) := 'lueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlMenuList(''DEMO_TEXT_EDITOR_MENU'') %>     ]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlMenuList(''DEMO_TEXT_EDITOR_MENU'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>19</elementid><pelementid>16</pelementid><orderby>3</orderby><element>FORM_DIV</element><type>F</type><id>DEMO_TEXT_EDITOR_DIV</id><nameid>DEMO_TEXT_EDITOR_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdForm]]></value><valuecode><![CDATA[="rasdForm"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_DIV]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><';
 v_vc(10) := '/textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>20</elementid><pelementid>19</pelementid><orderby>1</orderby><element>FORM_HEAD</element><type>F</type><id>DEMO_TEXT_EDITOR_HEAD</id><nameid>DEMO_TEXT_EDITOR_HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormHead]]></value><valuecode><![CDATA[="rasdFormHead"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_HEAD]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_HEAD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>21</elementid><pelementi';
 v_vc(11) := 'd>19</pelementid><orderby>2</orderby><element>FORM_BODY</element><type>F</type><id>DEMO_TEXT_EDITOR_BODY</id><nameid>DEMO_TEXT_EDITOR_BODY</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormBody]]></value><valuecode><![CDATA[="rasdFormBody"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_BODY]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_BODY"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>22</elementid><pelementid>19</pelementid><orderby>9998</orderby><element>FORM_MESSAGE</element><type>F</type><id>DEMO_TEXT_EDITOR_MESSAGE</id><nameid>DEMO_TEXT_EDITOR_MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage]]></value><valuecode><![CDATA[="ra';
 v_vc(12) := 'sdFormMessage"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_MESSAGE]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_MESSAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>23</elementid><pelementid>19</pelementid><orderby>9996</orderby><element>FORM_ERROR</element><type>F</type><id>DEMO_TEXT_EDITOR_ERROR</id><nameid>DEMO_TEXT_EDITOR_ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage error]]></value><valuecode><![CDATA[="rasdFormMessage error"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_ERROR]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_ERROR"]]></valuecode><forloop></forloop><endloop>';
 v_vc(13) := '</endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>24</elementid><pelementid>19</pelementid><orderby>9997</orderby><element>FORM_WARNING</element><type>F</type><id>DEMO_TEXT_EDITOR_WARNING</id><nameid>DEMO_TEXT_EDITOR_WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage warning]]></value><valuecode><![CDATA[="rasdFormMessage warning"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_WARNING]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_WARNING"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textc';
 v_vc(14) := 'ode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>25</elementid><pelementid>19</pelementid><orderby>9999</orderby><element>FORM_FOOTER</element><type>F</type><id>DEMO_TEXT_EDITOR_FOOTER</id><nameid>DEMO_TEXT_EDITOR_FOOTER</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormFooter]]></value><valuecode><![CDATA[="rasdFormFooter"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TEXT_EDITOR_FOOTER]]></value><valuecode><![CDATA[="DEMO_TEXT_EDITOR_FOOTER"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_<';
 v_vc(15) := '/attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlFooter(version , substr(''DEMO_TEXT_EDITOR_FOOTER'',1,instr(''DEMO_TEXT_EDITOR_FOOTER'', ''_'',-1)-1) , '''') %>]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlFooter(version , substr(''DEMO_TEXT_EDITOR_FOOTER'',1,instr(''DEMO_TEXT_EDITOR_FOOTER'', ''_'',-1)-1) , '''') ||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>26</elementid><pelementid>21</pelementid><orderby>102</orderby><element>BLOCK_DIV</element><type>B</type><id>B10_DIV</id><nameid>B10_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_DIV]]></value><valuecode><![CDATA[="B10_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid>';
 v_vc(16) := '<rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB10_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB10_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>27</elementid><pelementid>26</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>28</elementid><pelementid>27</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B10_LAB</id><nameid>B10_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labe';
 v_vc(17) := 'lblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_LAB]]></value><valuecode><![CDATA[="B10_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>29</elementid><pelementid>26</pelementid><orderby>103</orderby><element>TABLE_</element><type></type><id>B10_TABLE</id><nameid>B10_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attri';
 v_vc(18) := 'bute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_TABLE_RASD]]></value><valuecode><![CDATA[="B10_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>30</elementid><pelementid>29</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B10_BLOCK</id><nameid>B10_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_BLOCK_RASD]]></value><valuecode><![CDATA[="B10_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><';
 v_vc(19) := 'endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>31</elementid><pelementid>21</pelementid><orderby>112</orderby><element>BLOCK_DIV</element><type>B</type><id>B10_COPY_DIV</id><nameid>B10_COPY_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPY_DIV]]></value><valuecode><![CDATA[="B10_COPY_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB10_COPY_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB10_COPY_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn>';
 v_vc(20) := '<valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>32</elementid><pelementid>31</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>33</elementid><pelementid>32</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B10_COPY_LAB</id><nameid>B10_COPY_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPY_';
 v_vc(21) := 'LAB]]></value><valuecode><![CDATA[="B10_COPY_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>34</elementid><pelementid>31</pelementid><orderby>113</orderby><element>TABLE_</element><type></type><id>B10_COPY_TABLE</id><nameid>B10_COPY_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPY_TABLE_RASD]]></value><valuecode><![CDATA[="B10_COPY_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rfo';
 v_vc(22) := 'rm></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>35</elementid><pelementid>34</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B10_COPY_BLOCK</id><nameid>B10_COPY_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPY_BLOCK_RASD]]></value><valuecode><![CDATA[="B10_COPY_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>36</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</el';
 v_vc(23) := 'ement><type>D</type><id>ACTION</id><nameid>ACTION</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ACTION_NAME_RASD]]></value><valuecode><![CDATA[="ACTION_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[ACTION_NAME]]></value><valuecode><![CDATA[="ACTION"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><';
 v_vc(24) := 'rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[ACTION_VALUE]]></value><valuecode><![CDATA[="''||ACTION||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>37</elementid><pelementid>22</pelementid><orderby>9998</orderby><element>FONT_</element><type>D</type><id>MESSAGE</id><nameid>MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloo';
 v_vc(25) := 'p></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[MESSAGE_NAME_RASD]]></value><valuecode><![CDATA[="MESSAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]';
 v_vc(26) := '></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[MESSAGE_VALUE]]></value><valuecode><![CDATA[''||MESSAGE||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>38</elementid><pelementid>24</pelementid><orderby>9997</orderby><element>FONT_</element><type>D</type><id>WARNING</id><nameid>WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[WARNING_NAME_RASD]]></value><valuecode><![CDATA[="WARNING_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode>';
 v_vc(27) := '</textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source';
 v_vc(28) := '><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[WARNING_VALUE]]></value><valuecode><![CDATA[''||WARNING||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>39</elementid><pelementid>23</pelementid><orderby>9996</orderby><element>FONT_</element><type>D</type><id>ERROR</id><nameid>ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ERROR_NAME_RASD]]></value><valuecode><![CDATA[="ERROR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><';
 v_vc(29) := 'name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[ERROR_VALUE]]></value><valuecode><![CDATA[''||ERROR||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attri';
 v_vc(30) := 'bute></attributes></element><element><elementid>40</elementid><pelementid>20</pelementid><orderby>290876</orderby><element>INPUT_TEXT</element><type>D</type><id>PAGE</id><nameid>PAGE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PAGE_NAME_RASD]]></value><valuecode><![CDATA[="PAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[PAGE_NAME]]></value><valuecode><![CDATA[="PAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloo';
 v_vc(31) := 'p><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[PAGE_VALUE]]></value><valuecode><![CDATA[="''||PAGE||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldPAGE  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>41</elementid><pelementid>30</pelementid><orderby>581749</orderby><element>TX_</element><type>E</type><id></id><nameid>B10EDITOR_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><at';
 v_vc(32) := 'tribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10EDITOR]]></value><valuecode><![CDATA[="rasdTxLabB10EDITOR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>42</elementid><pelementid>41</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10EDITOR_LAB</id><nameid>B10EDITOR_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><val';
 v_vc(33) := 'ue><![CDATA[B10EDITOR_LAB]]></value><valuecode><![CDATA[="B10EDITOR_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>43</elementid><pelementid>29</pelementid><orderby>581752</orderby><element>TR_</element><type>B</type><id></id><nameid>B10_BLOCK581752</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute';
 v_vc(34) := '></attributes></element><element><elementid>44</elementid><pelementid>30</pelementid><orderby>581750</orderby><element>TX_</element><type>E</type><id></id><nameid>B10EDITOR_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10EDITOR rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10EDITOR rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10EDITOR_NAME]]></value><valuecode><![CDATA[="rasdTxB10EDITOR_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>45</elementid><pelementid>44</pelementid><orderby>1</orderby><element>TEXTAREA_</element><type>D</type><id>B10EDITOR</id><nameid>B10EDITOR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextarea]]></value><va';
 v_vc(35) := 'luecode><![CDATA[="rasdTextarea"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10EDITOR_NAME_RASD]]></value><valuecode><![CDATA[="B10EDITOR_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10EDITOR_NAME]]></value><valuecode><![CDATA[="B10EDITOR_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><';
 v_vc(36) := 'rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</textarea]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<textarea]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[B10EDITOR_VALUE]]></value><valuecode><![CDATA[''||B10EDITOR(1)||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>46</elementid><pelementid>35</pelementid><orderby>581749</orderby><element>TX_</element><type>E</type><id></id><nameid>B10_COPYEDITOR_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10_COPY]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10_COPY"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[';
 v_vc(37) := 'rasdTxLabB10_COPYEDITOR]]></value><valuecode><![CDATA[="rasdTxLabB10_COPYEDITOR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>47</elementid><pelementid>46</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10_COPYEDITOR_LAB</id><nameid>B10_COPYEDITOR_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPYEDITOR_LAB]]></value><valuecode><![CDATA[="B10_COPYEDITOR_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N<';
 v_vc(38) := '/hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>48</elementid><pelementid>34</pelementid><orderby>581752</orderby><element>TR_</element><type>B</type><id></id><nameid>B10_COPY_BLOCK581752</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>49</elementid><pelementid>35</pelementid><orderby>581750</orderby><element>TX_</element><type>E</type><id></id><nameid>B10_COPYEDITOR_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10_COPYEDITOR rasdTxTypeC]]></va';
 v_vc(39) := 'lue><valuecode><![CDATA[="rasdTxB10_COPYEDITOR rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10_COPYEDITOR_NAME]]></value><valuecode><![CDATA[="rasdTxB10_COPYEDITOR_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>50</elementid><pelementid>49</pelementid><orderby>1</orderby><element>TEXTAREA_</element><type>D</type><id>B10_COPYEDITOR</id><nameid>B10_COPYEDITOR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextarea]]></value><valuecode><![CDATA[="rasdTextarea"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></val';
 v_vc(40) := 'ueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_COPYEDITOR_NAME_RASD]]></value><valuecode><![CDATA[="B10_COPYEDITOR_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10_COPYEDITOR_NAME]]></value><valuecode><![CDATA[="B10_COPYEDITOR_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![C';
 v_vc(41) := 'DATA[</textarea]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<textarea]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[B10_COPYEDITOR_VALUE]]></value><valuecode><![CDATA[''||B10_COPYEDITOR(1)||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element></elements></form>';
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
end DEMO_TEXT_EDITOR;
/

