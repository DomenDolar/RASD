create or replace package DROPME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DROPME generated on 08.01.20 by user RASDCLI.     
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

procedure openLOV(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);
end;
/

create or replace package body DROPME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DROPME generated on 08.01.20 by user RASDCLI.    
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
  RESTRESTYPE varchar2(4000);  RECNUMP                       number := 1
;
  ACTION                        varchar2(4000);
  ERROR                         varchar2(4000);
  MESSAGE                       varchar2(4000);
  WARNING                       varchar2(4000);
  GBUTTSRC                      varchar2(4000);
  PMYFILED                      ctab;
  PMYFILXXX                     ctab;
  PMYSECFIELD                   ctab;
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
        rasd_client.callLog('69','||v_clob||', systimestamp, '' );
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

 procedure on_submit(name_array  in owa.vc_arr, value_array in owa.vc_arr);
 procedure on_session;

function openLOV(
  p_lov varchar2,
  p_value varchar2
) return lovtab__ is
  name_array   owa.vc_arr;
  value_array  owa.vc_arr;
begin
  name_array(1) := 'PLOV';
  value_array(1) := p_lov;
  name_array(2) := 'PID';
  value_array(2) := p_value;
  name_array(3) := 'CALL';
  value_array(3) := 'PLSQL';  
  openLOV(name_array, value_array);
  return lov__;
end;
procedure openLOV(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
  num_entries number := name_array.count;
TYPE pLOVType IS RECORD (
output varchar2(300),
p1 varchar2(200)
);
  TYPE tab_pLOVType IS TABLE OF pLOVType INDEX BY BINARY_INTEGER;
  v_lov tab_pLOVType;
  v_counter number := 1;
  v_description varchar2(100);
  p_lov varchar2(100);
  p_nameid varchar2(100);
  p_id varchar2(100);
  v_output boolean;
  v_call varchar2(10);
  v_hidden_fields varchar2(32000) := '';
  v_opener_tekst  varchar2(32000) := '';
  RESTRESTYPE varchar2(10);
begin
  on_submit(name_array, value_array);
  for i in 1..num_entries loop
    if name_array(i) = 'PLOV' then p_lov := value_array(i);
    elsif name_array(i) = 'FIN' then p_nameid := value_array(i);
    elsif name_array(i) = 'PID' then p_id := value_array(i);
    elsif upper(name_array(i)) = 'CALL' then v_call := value_array(i);
    elsif upper(name_array(i)) = upper('RESTRESTYPE') then RESTRESTYPE := value_array(i);
    else 
      if name_array(i) not in ('LOVlist') then
        v_hidden_fields := v_hidden_fields||'<input type="hidden" name="'||name_array(i)||'" value="'||value_array(i)||'" />'; 
      end if;
    end if;
  end loop;
    if v_call <> 'PLSQL' then 
      on_session;              
    end if;                   
  if lower(p_lov) = lower('link$CHKBXD') then
    v_description := 'CHKBXD';
        v_lov(1).output := 'N';
        v_lov(1).p1 := 'N';
        v_lov(2).output := 'Y';
        v_lov(2).p1 := 'Y';
        v_counter := 2; 
        if 1=2 then null;
        end if;          
  else
   return;
  end if;
if v_call = 'PLSQL' then 
  lov__.delete;
  for i in 1..v_lov.count loop
   lov__(i).id := v_lov(i).p1;
   lov__(i).label := v_lov(i).output;   
  end loop;  
elsif v_call = 'REST' then 
if RESTRESTYPE = 'XML' then 
 htp.p('<?xml version="1.0" encoding="UTF-8"?>
<openLOV LOV="'||p_lov||'" filter="'||p_id||'">');      
 htp.p('<result>');
 for i in 1..v_counter loop
 htp.p('<element><code>'||v_lov(i).p1||'</code><description>'||v_lov(i).output||'</description></element>');
 end loop; 
 htp.p('</result></openLOV>');
else 
 htp.p('{"openLOV":{"@LOV":"'||p_lov||'","@filter":"'||p_id||'",' );      
 htp.p('"result":[');
 for i in 1..v_counter loop
  if i = 1 then 
 htp.p('{"code":"'||v_lov(i).p1||'","description":"'||v_lov(i).output||'"}');
  else
 htp.p(',{"code":"'||v_lov(i).p1||'","description":"'||v_lov(i).output||'"}');
  end if;
 end loop; 
 htp.p(']}}');
end if;
else
 htp.p('
<html>');
    htp.prn('<head>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Test form for fixing bugs')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head></head>
    ');
 htp.bodyOpen('','');
htp.p('
<script language="JavaScript">
        $(function() {
        document.getElementById("PID").select();
        });
   function closeLOV() {
     this.close();
   }
   function selectLOV() {
     var value = window.document.'||p_lov||'.LOVlist.options[window.document.'||p_lov||'.LOVlist.selectedIndex].value;
     var tekst = window.document.'||p_lov||'.LOVlist.options[window.document.'||p_lov||'.LOVlist.selectedIndex].text;
     window.opener.'||p_nameid||'.value = value;
     '||v_opener_tekst||'
     event = new Event(''change'');
     window.opener.'||p_nameid||'.dispatchEvent(event);
     ');
htp.p('this.close ();
   }
  with (document) {
  if (screen.availWidth < 900){
    moveTo(-4,-4)}
  }
</script>');
 htp.p('<div class="rasdLovName">'||v_description||'</div>');
 htp.formOpen(curl=>'!DROPME.openLOV',
                 cattributes=>'name="'||p_lov||'"');
 htp.p('<input type="hidden" name="PLOV" value="'||p_lov||'">');
 htp.p('<input type="hidden" name="FIN" value="'||p_nameid||'">');
 htp.p(v_hidden_fields);
 htp.p('<div class="rasdLov" align="center"><center>');
 htp.p('Filter:<input type="text" id="PID" autofocus="autofocus" name="PID" value="'||p_id||'" ></BR><input type="submit" class="rasdButton" value="Search"><input class="rasdButton" type="button" value="Clear" onclick="document.'||p_lov||'.PID.value=''''; document.'||p_lov||'.submit();"></BR>');
 htp.formselectOpen('LOVlist',cattributes=>'size=15 width="100%"');
 for i in 1..v_counter loop
  if i = 1 then -- fokus na prvem
    htp.formSelectOption(cvalue=>v_lov(i).output,cselected=>1,Cattributes => 'value="'||v_lov(i).p1||'"');
  else
    htp.formSelectOption(cvalue=>v_lov(i).output,Cattributes => 'value="'||v_lov(i).p1||'"');
  end if;
 end loop;
 htp.formselectClose;
 htp.p('');
 htp.line;
 htp.p('<input type="button" class="rasdButton" value="Select and Confirm" onClick="selectLOV();">');
 htp.p('<input type="button" class="rasdButton" value="Close" onClick="closeLOV();">');
 htp.p('</center></div>');
 htp.p('</form>');
 htp.p('</body>');
 htp.p('</html>');
end if;
end;
  function version return varchar2 is
  begin
   return 'v.1.1.20200108095704'; 
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
      elsif  upper(name_array(i__)) = upper('RECNUMP') then RECNUMP := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTSRC') then GBUTTSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYFILED_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PMYFILED(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYFILXXX_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PMYFILXXX(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYSECFIELD_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PMYSECFIELD(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYFILED') and PMYFILED.count = 0 and value_array(i__) is not null then
        PMYFILED(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYFILXXX') and PMYFILXXX.count = 0 and value_array(i__) is not null then
        PMYFILXXX(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PMYSECFIELD') and PMYSECFIELD.count = 0 and value_array(i__) is not null then
        PMYSECFIELD(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if PMYFILED.count > v_max then v_max := PMYFILED.count; end if;
    if PMYFILXXX.count > v_max then v_max := PMYFILXXX.count; end if;
    if PMYSECFIELD.count > v_max then v_max := PMYSECFIELD.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PMYFILED.exists(i__) or PMYFILED(i__) is null then
        PMYFILED(i__) := 'N';
      end if;
      if not PMYFILXXX.exists(i__) then
        PMYFILXXX(i__) := null;
      end if;
      if not PMYSECFIELD.exists(i__) then
        PMYSECFIELD(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="69" blockid="">
--PMYFILED(1)#SET.visible := false;
--PMYFILXXX(1)#SET.visible := false;
--</POST_SUBMIT>
    null;
  end;
  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
  begin
-- Reading post variables into fields.
    on_submit(name_array ,value_array); on_session;
    post_submit;
  end;
  procedure pclear_P(pstart number) is
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
        PMYFILED(i__) := null;
        PMYFILXXX(i__) := null;
        PMYSECFIELD(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    RECNUMP := 1;
    ERROR := null;
    MESSAGE := null;
    WARNING := null;
    GBUTTSRC := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PMYFILED.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PMYFILED.count loop
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
  function ShowFieldGBUTTSRC return boolean is 
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><thead><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPMYFILED"><span id="PMYFILED_LAB" class="label">f1</span></td><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPMYSECFIELD"><span id="PMYSECFIELD_LAB" class="label">f2</span></td><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPMYFILXXX"><span id="PMYFILXXX_LAB" class="label">f3</span></td></tr></thead><tr id="P_BLOCK"><td class="rasdTxPMYSECFIELD rasdTxTypeC" id="rasdTxPMYSECFIELD_1"><font id="PMYSECFIELD_1_RASD" class="rasdRadio"></font></td><td class="rasdTxPMYFILXXX rasdTxTypeC" id="rasdTxPMYFILXXX_1"><input name="PMYFILXXX_1" id="PMYFILXXX_1_RASD" type="text" value="'||PMYFILXXX(1)||'" class="rasdTextC"/>
</td><td class="rasdTxPMYFILED rasdTxTypeC" id="rasdTxPMYFILED_1"><input ONCLICK="js_Clink$CHKBXDclick(this.value, ''PMYFILED_1'');" name="PMYFILED_1" id="PMYFILED_1_RASD" type="checkbox" value="'||PMYFILED(1)||'" class="rasdCheckbox"/><SCRIPT LANGUAGE="JavaScript"> document.addEventListener(''DOMContentLoaded'', function(event) {  js_Clink$CHKBXDinit( '''||PMYFILED(1)||''' , ''PMYFILED_1'' ); }) </SCRIPT>
</td></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.prn('<script language="JavaScript">');
    htp.p('function js_Clink$CHKBXDinit(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.value == ''Y'') {  element.checked = true;  }  ');
    htp.p('          else { element.checked = false;  } ');
    htp.p('}');
    htp.p('function js_Clink$CHKBXDclick(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.checked) { element.value=''Y''; } else { element.value=''N'';}  ');
    htp.p('}');
    htp.p('</script>');
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Test form for fixing bugs')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DROPME_LAB" class="rasdFormLab">Test form for fixing bugs '|| rasd_client.getHtmlDataTable('DROPME_LAB') ||'     </div><div id="DROPME_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DROPME_MENU') ||'     </div>
<form name="DROPME" method="post" action="?"><div id="DROPME_DIV" class="rasdForm"><div id="DROPME_HEAD" class="rasdFormHead"><input name="RECNUMP" id="RECNUMP_RASD" type="hidden" value="'||ltrim(to_char(RECNUMP))||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldGBUTTSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTSRC" id="GBUTTSRC_RASD" type="button" value="'||GBUTTSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="DROPME_BODY" class="rasdFormBody">'); output_P_DIV; htp.p('</div><div id="DROPME_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DROPME_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DROPME_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DROPME_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTSRC" id="GBUTTSRC_RASD" type="button" value="'||GBUTTSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('DROPME_FOOTER',1,instr('DROPME_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DROPME" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<recnump>'||RECNUMP||'</recnump>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('<gbuttsrc><![CDATA['||GBUTTSRC||']]></gbuttsrc>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<pmyfiled><![CDATA['||PMYFILED(1)||']]></pmyfiled>'); 
    htp.p('<pmyfilxxx><![CDATA['||PMYFILXXX(1)||']]></pmyfilxxx>'); 
    htp.p('<pmysecfield><![CDATA['||PMYSECFIELD(1)||']]></pmysecfield>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DROPME","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"recnump":"'||RECNUMP||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p(',"gbuttsrc":"'||escapeRest(GBUTTSRC)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"pmyfiled":"'||escapeRest(PMYFILED(1))||'"'); 
    htp.p(',"pmyfilxxx":"'||escapeRest(PMYFILXXX(1))||'"'); 
    htp.p(',"pmysecfield":"'||escapeRest(PMYSECFIELD(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
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
  rasd_client.secCheckPermission('DROPME',ACTION);  
  if ACTION is null then null;
    RECNUMP := 1;
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Test form for fixing bugs')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DROPME_LAB" class="rasdFormLab">Test form for fixing bugs '|| rasd_client.getHtmlDataTable('DROPME_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DROPME_FOOTER',1,instr('DROPME_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DROPME',ACTION);  

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
  rasd_client.secCheckPermission('DROPME',ACTION);  
  if ACTION is null then null;
    RECNUMP := 1;
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
<form name="DROPME" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DROPME","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>69</formid><form>DROPME</form><version>1</version><change>08.01.2020 09/57/04</change><user>RASDCLI</user><label><![CDATA[Test form for fixing bugs]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>12.11.2019 11/49/31</change><compileyn>N</compileyn><application>Test</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
end DROPME;
/

