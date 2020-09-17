create or replace package DEMO_AJAX_CALL is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_AJAX_CALL generated on 08.01.20 by user RASDCLI.     
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

create or replace package body DEMO_AJAX_CALL is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_AJAX_CALL generated on 08.01.20 by user RASDCLI.    
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
  PCASE                         ctab;
  B10CDEPARTMENT                ctab;
  DIN_CONTCODE                  ctab;
  DIN_CONTDESCRIPTION           ctab;
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
        rasd_client.callLog('32','||v_clob||', systimestamp, '' );
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
function call_ajax(pid ) {

//URL returning JSON  ''DEMO_AJAX_CALL.openLOV?PLOV=lov$EMP&call=REST&restrestype=JSON&PID=''+ pid + ''&FIN=''
//Target block DIN_CONT -> DIV name is DIN_CONT_DIV

  $.getJSON( ''!DEMO_AJAX_CALL.openLOV'' , {
    "PLOV": "lov$EMP", 
    "restrestype" : "JSON",
    "call": "REST",
    "PID": pid
  })
    .done(function( data ) {
      var htmlcode = '''';

      $.each( data.openLOV.result, function( i, item ) {

       htmlcode +=  ''<P>'' + item.code + '' '' + item.description +''</P>'';
       
      });
      
      $(''#DIN_CONT_DIV'').html(htmlcode);
    });


 
}
        ';
       end; 
     function form_css return clob is
       begin
        return '
#DIN_CONT_DIV {
  background-color: red;
}
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
cursor c_lov$DEP(p_id varchar2) is 
--<lovsql formid="32" linkid="lov$DEP">
select id, label from (select deptno id, dname label from DEPT t ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
cursor c_lov$EMP(p_id varchar2) is 
--<lovsql formid="32" linkid="lov$EMP">
select id, label from (select deptno id, ename label from emp t
order by id, label ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
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
  if lower(p_lov) = lower('lov$DEP') then
    v_description := 'DEPARTMENTS';
    for r in c_lov$DEP(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('lov$EMP') then
    v_description := 'EMP...';
    for r in c_lov$EMP(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo AJAX call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
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
 htp.formOpen(curl=>'!DEMO_AJAX_CALL.openLOV',
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
   return 'v.1.1.20200108095756'; 
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
if PCASE(i__) is null then vc := rasd_client.sessionGetValue('PCASE'); PCASE(i__)  := vc;  end if; 
if B10CDEPARTMENT(i__) is null then vc := rasd_client.sessionGetValue('B10CDEPARTMENT'); B10CDEPARTMENT(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('PCASE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PCASE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CDEPARTMENT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10CDEPARTMENT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('DIN_CONTITEM_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        DIN_CONTCODE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('DIN_CONTDESCRIPTION_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        DIN_CONTDESCRIPTION(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PCASE') and PCASE.count = 0 and value_array(i__) is not null then
        PCASE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CDEPARTMENT') and B10CDEPARTMENT.count = 0 and value_array(i__) is not null then
        B10CDEPARTMENT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('DIN_CONTITEM') and DIN_CONTCODE.count = 0 and value_array(i__) is not null then
        DIN_CONTCODE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('DIN_CONTDESCRIPTION') and DIN_CONTDESCRIPTION.count = 0 and value_array(i__) is not null then
        DIN_CONTDESCRIPTION(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10CDEPARTMENT.count > v_max then v_max := B10CDEPARTMENT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10CDEPARTMENT.exists(i__) then
        B10CDEPARTMENT(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if DIN_CONTCODE.count > v_max then v_max := DIN_CONTCODE.count; end if;
    if DIN_CONTDESCRIPTION.count > v_max then v_max := DIN_CONTDESCRIPTION.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not DIN_CONTCODE.exists(i__) then
        DIN_CONTCODE(i__) := null;
      end if;
      if not DIN_CONTDESCRIPTION.exists(i__) then
        DIN_CONTDESCRIPTION(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if PCASE.count > v_max then v_max := PCASE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PCASE.exists(i__) then
        PCASE(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="32" blockid="">
PCASE(1) := 'Sample show''s AJAX call of LOV DEPARTMENTS into block DIN_CONT when EMPLOYE is changed!';
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
        PCASE(i__) := null;

      end loop;
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
        B10CDEPARTMENT(i__) := null;

      end loop;
  end;
  procedure pclear_DIN_CONT(pstart number) is
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
        DIN_CONTCODE(i__) := null;
        DIN_CONTDESCRIPTION(i__) := null;

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
    pclear_P(0);
    pclear_B10(0);
    pclear_DIN_CONT(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PCASE.count);
  null; end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10CDEPARTMENT.count);
  null; end;
  procedure pselect_DIN_CONT is
    i__ pls_integer;
  begin
      pclear_DIN_CONT(DIN_CONTCODE.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PCASE.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10CDEPARTMENT.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_DIN_CONT is
  begin
-- Validating field values before DML. Use () to access fields values.
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
  function ShowBlockDIN_CONT_DIV return boolean is 
  begin 
    return true;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  procedure js_Slov$DEP(value varchar2, name varchar2 default null) is
  begin
    htp.p('<script language="JavaScript">');
    htp.p('js_Slov$DEP('''||value||''','''||name||''');');
    htp.p('</script>');
  end;
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock"></div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10CDEPARTMENT"><span id="B10CDEPARTMENT_LAB" class="label">Department</span></td><td class="rasdTxB10CDEPARTMENT rasdTxTypeC" id="rasdTxB10CDEPARTMENT_1"><select name="B10CDEPARTMENT_1" ID="B10CDEPARTMENT_1_RASD" class="rasdSelect" onchange="call_ajax(this.value);">'); js_Slov$DEP(B10CDEPARTMENT(1),'B10CDEPARTMENT_1'); 
htp.prn('</select></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_DIN_CONT_DIV is begin htp.p('');  if  ShowBlockDIN_CONT_DIV  then  
htp.prn('<div  id="DIN_CONT_DIV" class="rasdblock"><div>
<caption><div id="DIN_CONT_LAB" class="labelblock"></div></caption>
<table border="0" id="DIN_CONT_TABLE"><tr id="DIN_CONT_BLOCK"></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPCASE"><span id="PCASE_LAB" class="label"></span></td><td class="rasdTxPCASE rasdTxTypeC" id="rasdTxPCASE_1"><font id="PCASE_1_RASD" class="rasdFont">'||PCASE(1)||'</font></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function js_Slov$DEP(pvalue, pobjectname) {');
      htp.p(' eval(''val_''+pobjectname+''="''+pvalue+''"'');'); 
      htp.p(' var x = document.getElementById(pobjectname+''_RASD''); ');
    begin
    for r__ in (
--<lovsql formid="32" linkid="lov$DEP">
select deptno id, dname label from DEPT t
--</lovsql>
    ) loop
      htp.p('  var option = document.createElement("option"); option.value="'||r__.id||'"; option.text = "'||replace(r__.label,'''','\''')||'"; option.selected = ((pvalue=='''||r__.id||''')?'' selected '':''''); x.add(option);');
    end loop;
    exception when others then
      raise_application_error('-20000','Error in lov$DEP: '||sqlerrm);  
    end;
    htp.p('}');
    htp.prn('</script>');
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFDIN_CONT() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo AJAX call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_AJAX_CALL_LAB" class="rasdFormLab">Demo AJAX call '|| rasd_client.getHtmlDataTable('DEMO_AJAX_CALL_LAB') ||'     </div><div id="DEMO_AJAX_CALL_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_AJAX_CALL_MENU') ||'     </div>
<form name="DEMO_AJAX_CALL" method="post"><div id="DEMO_AJAX_CALL_DIV" class="rasdForm"><div id="DEMO_AJAX_CALL_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
</div><div id="DEMO_AJAX_CALL_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_DIV; htp.p(''); output_DIN_CONT_DIV; htp.p('</div><div id="DEMO_AJAX_CALL_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_AJAX_CALL_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_AJAX_CALL_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_AJAX_CALL_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('DEMO_AJAX_CALL_FOOTER',1,instr('DEMO_AJAX_CALL_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockDIN_CONT_DIV return boolean is 
  begin 
    return true;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DEMO_AJAX_CALL" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<pcase><![CDATA['||PCASE(1)||']]></pcase>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10cdepartment><![CDATA['||B10CDEPARTMENT(1)||']]></b10cdepartment>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockdin_cont_DIV then 
    htp.p('<din_cont>'); 
    htp.p('<element>'); 
    htp.p('</element>'); 
  htp.p('</din_cont>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_AJAX_CALL","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"pcase":"'||escapeRest(PCASE(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
     htp.p('{'); 
    htp.p('"b10cdepartment":"'||escapeRest(B10CDEPARTMENT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b10":[]'); 
  end if; 
    if ShowBlockdin_cont_DIV then 
    htp.p(',"din_cont":['); 
     htp.p('{'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"din_cont":[]'); 
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
  rasd_client.secCheckPermission('DEMO_AJAX_CALL',ACTION);  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo AJAX call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DEMO_AJAX_CALL_LAB" class="rasdFormLab">Demo AJAX call '|| rasd_client.getHtmlDataTable('DEMO_AJAX_CALL_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DEMO_AJAX_CALL_FOOTER',1,instr('DEMO_AJAX_CALL_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DEMO_AJAX_CALL',ACTION);  

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
  rasd_client.secCheckPermission('DEMO_AJAX_CALL',ACTION);  
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
<form name="DEMO_AJAX_CALL" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_AJAX_CALL","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>32</formid><form>DEMO_AJAX_CALL</form><version>1</version><change>08.01.2020 09/57/56</change><user>RASDCLI</user><label><![CDATA[Demo AJAX call]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>Y</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>15.12.2017 11/37/18</change><compileyn>Y</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks><block><blockid>B10</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B10</blockid><fieldid>CDEPARTMENT</fieldid><type>C</type><format></format><element>SELECT_</element><hiddenyn></hiddenyn><orderby>10</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10CDEPARTMENT</nameid><label><![CDATA[Department]]></label><linkid>lov$DEP</linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>DIN_CONT</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>DIN_CONT</blockid><fieldid>CODE</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>100</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>N</elementyn><nameid>DIN_CONTITEM</nameid><label></label><linkid></';
 v_vc(2) := 'linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>DIN_CONT</blockid><fieldid>DESCRIPTION</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>200</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>N</elementyn><nameid>DIN_CONTDESCRIPTION</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>P</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>P</blockid><fieldid>CASE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>1</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>PCASE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block></blocks><fields><field><blockid></blockid><fieldid>ACTION</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ACTION</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>ERROR</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></delet';
 v_vc(3) := 'eyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ERROR</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>MESSAGE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>MESSAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>WARNING</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>WARNING</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields><links><link><linkid>lov$DEP</linkid><link>DEPARTMENTS</link><type>S</type><location></location><text><![CDATA[select deptno id, dname label from DEPT t]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link><link><linkid>lov$EMP</linkid><link>EMP...</link><type>S</type><location></location><text><![CDATA[select deptno id, ename label from emp t
order by id, label]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link></links><pages></pages><triggers><trigger><blockid></blockid><triggerid>FORM_CSS</triggerid><plsql><![CDATA[#DIN_CONT_DIV {
  background-color: red;
}
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>FORM_JS</triggerid><plsql><![CDATA[function call_ajax(pid ) {

//URL returning JSON  ''DEMO_AJAX_CALL.open';
 v_vc(4) := 'LOV?PLOV=lov$EMP&call=REST&restrestype=JSON&PID=''+ pid + ''&FIN=''
//Target block DIN_CONT -> DIV name is DIN_CONT_DIV

  $.getJSON( ''!DEMO_AJAX_CALL.openLOV'' , {
    "PLOV": "lov$EMP", 
    "restrestype" : "JSON",
    "call": "REST",
    "PID": pid
  })
    .done(function( data ) {
      var htmlcode = '''';

      $.each( data.openLOV.result, function( i, item ) {

       htmlcode +=  ''<P>'' + item.code + '' '' + item.description +''</P>'';
       
      });
      
      $(''#DIN_CONT_DIV'').html(htmlcode);
    });


 
}
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_SUBMIT</triggerid><plsql><![CDATA[pcase := ''Sample show''''s AJAX call of LOV DEPARTMENTS into block DIN_CONT when EMPLOYE is changed!'';
]]></plsql><plsqlspec><![CDATA[-- Executing after filling fields on submit.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger></triggers><elements><element><elementid>1</elementid><pelementid>0</pelementid><orderby>1</orderby><element>HTML_</element><type></type><id>HTML</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>2</elementid><pelementid>1</pelementid><orderby>1</orderby><element>HEAD_</element><type></type><id>HEAD</id><nameid>HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></';
 v_vc(5) := 'rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Demo AJAX call'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>''); %>]]></value><valuecode><![CDATA['');  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Demo AJAX call'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>15</elementid><pelementid>1</pelementid><orderby>1</orderby><element>BODY_</element><type></type><id>BODY</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]';
 v_vc(6) := ']></text><name><![CDATA[<body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>16</elementid><pelementid>15</pelementid><orderby>3</orderby><element>FORM_</element><type>F</type><id>DEMO_AJAX_CALL</id><nameid>DEMO_AJAX_CALL</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_ACTION</attribute><type>A</type><text></text><name><![CDATA[action]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_METHOD</attribute><type>A</type><text></text><name><![CDATA[method]]></name><value><![CDATA[post]]></value><valuecode><![CDATA[="post"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[DEMO_AJAX_CALL]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hidde';
 v_vc(7) := 'nyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>17</elementid><pelementid>15</pelementid><orderby>1</orderby><element>FORM_LAB</element><type>F</type><id>DEMO_AJAX_CALL_LAB</id><nameid>DEMO_AJAX_CALL_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormLab]]></value><valuecode><![CDATA[="rasdFormLab"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_LAB]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Demo AJAX call <%= rasd_client.getHtmlDataTable(''DEMO_AJAX_CALL_LAB'') %>     ]]></value><valuecode><![CDATA[Demo AJAX call ''|| rasd_client.getHtmlDataTable(''DEMO_AJAX_CALL_LAB'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hi';
 v_vc(8) := 'ddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>18</elementid><pelementid>15</pelementid><orderby>2</orderby><element>FORM_MENU</element><type>F</type><id>DEMO_AJAX_CALL_MENU</id><nameid>DEMO_AJAX_CALL_MENU</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMenu]]></value><valuecode><![CDATA[="rasdFormMenu"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_MENU]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_MENU"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlMenuList(''DEMO_AJAX_CALL_MENU'') %>     ]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlMenuList(''DEMO_AJAX_CALL_MENU'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></val';
 v_vc(9) := 'ueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>19</elementid><pelementid>16</pelementid><orderby>3</orderby><element>FORM_DIV</element><type>F</type><id>DEMO_AJAX_CALL_DIV</id><nameid>DEMO_AJAX_CALL_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdForm]]></value><valuecode><![CDATA[="rasdForm"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_DIV]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>20</elementid><pelementid>19</pelementid><orderby>1</orderby><element>FORM_HEAD</element><type>F</type><id>DEMO_AJAX_CALL_HEAD</id><nameid>DEMO_AJAX_CALL_HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attri';
 v_vc(10) := 'bute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormHead]]></value><valuecode><![CDATA[="rasdFormHead"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_HEAD]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_HEAD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>21</elementid><pelementid>19</pelementid><orderby>2</orderby><element>FORM_BODY</element><type>F</type><id>DEMO_AJAX_CALL_BODY</id><nameid>DEMO_AJAX_CALL_BODY</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormBody]]></value><valuecode><![CDATA[="rasdFormBody"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_BODY]]></value><valuec';
 v_vc(11) := 'ode><![CDATA[="DEMO_AJAX_CALL_BODY"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>22</elementid><pelementid>19</pelementid><orderby>9998</orderby><element>FORM_MESSAGE</element><type>F</type><id>DEMO_AJAX_CALL_MESSAGE</id><nameid>DEMO_AJAX_CALL_MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage]]></value><valuecode><![CDATA[="rasdFormMessage"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_MESSAGE]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_MESSAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>';
 v_vc(12) := 'N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>23</elementid><pelementid>19</pelementid><orderby>9996</orderby><element>FORM_ERROR</element><type>F</type><id>DEMO_AJAX_CALL_ERROR</id><nameid>DEMO_AJAX_CALL_ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage error]]></value><valuecode><![CDATA[="rasdFormMessage error"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_ERROR]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_ERROR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></';
 v_vc(13) := 'attribute></attributes></element><element><elementid>24</elementid><pelementid>19</pelementid><orderby>9997</orderby><element>FORM_WARNING</element><type>F</type><id>DEMO_AJAX_CALL_WARNING</id><nameid>DEMO_AJAX_CALL_WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage warning]]></value><valuecode><![CDATA[="rasdFormMessage warning"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_WARNING]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_WARNING"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>25</elementid><pelementid>19</pelementid><orderby>9999</orderby><element>FORM_FOOTER</element><type>F</type><id>DEMO_AJAX_CALL_FOOTER</id><nameid>DEMO_AJAX_CALL_FOOTER</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text><';
 v_vc(14) := '/text><name><![CDATA[class]]></name><value><![CDATA[rasdFormFooter]]></value><valuecode><![CDATA[="rasdFormFooter"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_AJAX_CALL_FOOTER]]></value><valuecode><![CDATA[="DEMO_AJAX_CALL_FOOTER"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlFooter(version , substr(''DEMO_AJAX_CALL_FOOTER'',1,instr(''DEMO_AJAX_CALL_FOOTER'', ''_'',-1)-1) , '''') %>]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlFooter(version , substr(''DEMO_AJAX_CALL_FOOTER'',1,instr(''DEMO_AJAX_CALL_FOOTER'', ''_'',-1)-1) , '''') ||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>26</elementid><pelementid>21</pelementid><orderby>102</orderby><element>BLOCK_DIV</element><type>B</type><id>P_DIV</id><nameid>P_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute>';
 v_vc(15) := '<orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_DIV]]></value><valuecode><![CDATA[="P_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockP_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockP_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>27</elementid><pelementid>26</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value';
 v_vc(16) := '><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>28</elementid><pelementid>27</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>P_LAB</id><nameid>P_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_LAB]]></value><valuecode><![CDATA[="P_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform>';
 v_vc(17) := '</rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>29</elementid><pelementid>26</pelementid><orderby>103</orderby><element>TABLE_</element><type></type><id>P_TABLE</id><nameid>P_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_TABLE_RASD]]></value><valuecode><![CDATA[="P_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><end';
 v_vc(18) := 'loop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>30</elementid><pelementid>29</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>P_BLOCK</id><nameid>P_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_BLOCK_RASD]]></value><valuecode><![CDATA[="P_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>31</elementid><pelementid>21</pelementid><orderby>112</orderby><element>BLOCK_DIV</element><type>B</type><id>B10_DIV</id><nameid>B10_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute';
 v_vc(19) := '>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_DIV]]></value><valuecode><![CDATA[="B10_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB10_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB10_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>32</elementid><pelementid>31</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valueco';
 v_vc(20) := 'de><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>33</elementid><pelementid>32</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B10_LAB</id><nameid>B10_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_LAB]]></value><valuecode><![CDATA[="B10_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribu';
 v_vc(21) := 'te><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>34</elementid><pelementid>31</pelementid><orderby>113</orderby><element>TABLE_</element><type></type><id>B10_TABLE</id><nameid>B10_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_TABLE_RASD]]></value><valuecode><![CDATA[="B10_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>35</elementid><pelementid>34</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B10_BLOCK</id><nameid>B10_BLOCK</nameid><endtagelementid>0</endtagelement';
 v_vc(22) := 'id><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_BLOCK_RASD]]></value><valuecode><![CDATA[="B10_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>36</elementid><pelementid>21</pelementid><orderby>122</orderby><element>BLOCK_DIV</element><type>B</type><id>DIN_CONT_DIV</id><nameid>DIN_CONT_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DIN_CONT_DIV]]></value><valuecode><![CDATA[="DIN_CONT_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orde';
 v_vc(23) := 'rby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockDIN_CONT_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockDIN_CONT_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>37</elementid><pelementid>36</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valu';
 v_vc(24) := 'ecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>38</elementid><pelementid>37</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>DIN_CONT_LAB</id><nameid>DIN_CONT_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DIN_CONT_LAB]]></value><valuecode><![CDATA[="DIN_CONT_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element>';
 v_vc(25) := '<element><elementid>39</elementid><pelementid>36</pelementid><orderby>123</orderby><element>TABLE_</element><type></type><id>DIN_CONT_TABLE</id><nameid>DIN_CONT_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DIN_CONT_TABLE_RASD]]></value><valuecode><![CDATA[="DIN_CONT_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>40</elementid><pelementid>39</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>DIN_CONT_BLOCK</id><nameid>DIN_CONT_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DIN_CONT_BLOCK_RASD]]></value><valuecode><![CDATA[="DIN_CON';
 v_vc(26) := 'T_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>41</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>ACTION</id><nameid>ACTION</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ACTION_NAME_RASD]]></value><valuecode><![CDATA[="ACTION_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute';
 v_vc(27) := '><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[ACTION_NAME]]></value><valuecode><![CDATA[="ACTION"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[ACTION_VALUE]]></value><valuecode><![CDATA[="''||ACTION||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloo';
 v_vc(28) := 'p></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>42</elementid><pelementid>22</pelementid><orderby>9998</orderby><element>FONT_</element><type>D</type><id>MESSAGE</id><nameid>MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[MESSAGE_NAME_RASD]]></value><valuecode><![CDATA[="MESSAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type>';
 v_vc(29) := '<text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[MESSAGE_VALUE]]></value><valuecode><![CDATA[''||MESSAGE||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>43</elementid><pelementid>23</pelementid><orderby>9996</orderby><element>FONT_</element><type>D</type><id>ERROR</id><nameid>ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attri';
 v_vc(30) := 'butes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ERROR_NAME_RASD]]></value><valuecode><![CDATA[="ERROR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hid';
 v_vc(31) := 'denyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[ERROR_VALUE]]></value><valuecode><![CDATA[''||ERROR||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>44</elementid><pelementid>24</pelementid><orderby>9997</orderby><element>FONT_</element><type>D</type><id>WARNING</id><nameid>WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF';
 v_vc(32) := ']]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[WARNING_NAME_RASD]]></value><valuecode><![CDATA[="WARNING_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><';
 v_vc(33) := 'attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[WARNING_VALUE]]></value><valuecode><![CDATA[''||WARNING||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>45</elementid><pelementid>30</pelementid><orderby>1</orderby><element>TX_</element><type>E</type><id></id><nameid>PCASE_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockP]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockP"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabPCASE]]></value><valuecode><![CDATA[="rasdTxLabPCASE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><';
 v_vc(34) := 'forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>46</elementid><pelementid>45</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>PCASE_LAB</id><nameid>PCASE_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PCASE_LAB]]></value><valuecode><![CDATA[="PCASE_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribut';
 v_vc(35) := 'e><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>47</elementid><pelementid>29</pelementid><orderby>4</orderby><element>TR_</element><type>B</type><id></id><nameid>P_BLOCK4</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>48</elementid><pelementid>30</pelementid><orderby>2</orderby><element>TX_</element><type>E</type><id></id><nameid>PCASE_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxPCASE rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxPCASE rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxPCASE_NAME]]></value><valuecode><![CDATA[="rasdTxPCASE_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn>';
 v_vc(36) := '<valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>49</elementid><pelementid>48</pelementid><orderby>1</orderby><element>FONT_</element><type>D</type><id>PCASE</id><nameid>PCASE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PCASE_NAME_RASD]]></value><valuecode><![CDATA[="PCASE_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[N';
 v_vc(37) := 'AME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><a';
 v_vc(38) := 'ttribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[PCASE_VALUE]]></value><valuecode><![CDATA[''||PCASE(1)||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>50</elementid><pelementid>35</pelementid><orderby>19</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CDEPARTMENT_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10CDEPARTMENT]]></value><valuecode><![CDATA[="rasdTxLabB10CDEPARTMENT"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>51</elementid><pelementid>50</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10CDE';
 v_vc(39) := 'PARTMENT_LAB</id><nameid>B10CDEPARTMENT_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10CDEPARTMENT_LAB]]></value><valuecode><![CDATA[="B10CDEPARTMENT_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Department]]></value><valuecode><![CDATA[Department]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>52</elementid><pelementid>34</pelementid><orderby>22</orderby><element>TR_</element><type>B</type><id></id><nameid>B10_BLOCK22</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></i';
 v_vc(40) := 'ncludevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>53</elementid><pelementid>35</pelementid><orderby>20</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CDEPARTMENT_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10CDEPARTMENT rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10CDEPARTMENT rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10CDEPARTMENT_NAME]]></value><valuecode><![CDATA[="rasdTxB10CDEPARTMENT_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA';
 v_vc(41) := '[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>54</elementid><pelementid>53</pelementid><orderby>1</orderby><element>SELECT_</element><type>D</type><id>B10CDEPARTMENT</id><nameid>B10CDEPARTMENT</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdSelect]]></value><valuecode><![CDATA[="rasdSelect"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[ID]]></name><value><![CDATA[B10CDEPARTMENT_NAME_RASD]]></value><valuecode><![CDATA[="B10CDEPARTMENT_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10CDEPARTMENT_NAME]]></value><valuecode><![CDATA[="B10CDEPARTMENT_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>A_ONCHANGE</attribute><type>A</type><text></text><name><![CDATA[onchange]]></name><value><![CDATA[call_ajax(this.value);]]></value><valuecode><![CDATA[="call_ajax(this.value);"]]></valuec';
 v_vc(42) := 'ode><forloop></forloop><endloop></endloop><source>V</source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</select]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<select]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text';
 v_vc(43) := '></text><name></name><value><![CDATA[lov$DEP]]></value><valuecode><![CDATA[''); js_Slov$DEP(B10CDEPARTMENT(1),''B10CDEPARTMENT_1''); 
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element></elements></form>';
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
end DEMO_AJAX_CALL;
/

