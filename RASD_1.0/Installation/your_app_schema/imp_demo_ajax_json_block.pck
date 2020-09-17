create or replace package IMP_DEMO_AJAX_JSON_BLOCK is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_AJAX_JSON_BLOCK generated on 18.08.20 by user RASDCLI.     
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

create or replace package body IMP_DEMO_AJAX_JSON_BLOCK is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_AJAX_JSON_BLOCK generated on 18.08.20 by user RASDCLI.    
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
  RESTRESTYPE varchar2(4000);  RECNUMA99                     varchar2(4000) := 1
;
  ACTION                        varchar2(4000);
  ERROR                         varchar2(4000);  GBUTTONBCK                    varchar2(4000) := 'GBUTTONBCK'
;  GBUTTONCLR                    varchar2(4000) := 'GBUTTONCLR'
;  GBUTTONFWD                    varchar2(4000) := 'GBUTTONFWD'
;  GBUTTONRES                    varchar2(4000) := 'GBUTTONRES'
;  GBUTTONSAVE                   varchar2(4000) := 'GBUTTONSAVE'
;  GBUTTONSRC                    varchar2(4000) := 'GBUTTONSRC'
;
  MESSAGE                       varchar2(4000);  PAGE                          number := 1
;
  WARNING                       varchar2(4000);
  FEMPNO                        varchar2(4000);
  B10EMPLOYEE                   ctab;
  B10EMPLOYEE#SET                stab;
  SITEBLOCKEMPNO                ntab;
  A99EMPNO                      ntab;
  A99ENAME                      ctab;
  SITEBLOCKENAME                ctab;
  A99JOB                        ctab;
  SITEBLOCKJOB                  ctab;
  SITEBLOCKMGR                  ntab;
  A99MGR                        ntab;
  SITEBLOCKHIREDATE             ctab;
  A99HIREDATE                   dtab;
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
        rasd_client.callLog('IMP_DEMO_AJAX_JSON_BLOCK',v_clob, systimestamp, '' );
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

function FillDynamicData(FEMPNO) {
  
   $.getJSON( ''!''+document.forms[0].name+''.rest?FEMPNO=''+FEMPNO+''&PAGE=19'', {
    "restrestype" : "JSON",
    "call": "REST"
  })
    .done(function( data ) {
	//SET DATA FROM JSON TO ELEMENTS ON PAGE
    var x = document.getElementById(''SITEBLOCKEMPNO_1_RASD'').value=data.form.a99[0].a99empno;
    var y = document.getElementById(''SITEBLOCKENAME_1_RASD'').value=data.form.a99[0].a99ename;
    var w = document.getElementById(''SITEBLOCKJOB_1_RASD'').value=data.form.a99[0].a99job;
    var q = document.getElementById(''SITEBLOCKMGR_1_RASD'').innerText=data.form.a99[0].a99mgr;     
    var u = document.getElementById(''SITEBLOCKHIREDATE_1_RASD'').value=data.form.a99[0].a99hiredate;     
    }); 
  }

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
cursor c_lov$Employess(p_id varchar2) is 
--<lovsql formid="75" linkid="lov$Employess">
select id, label from (SELECT 
 EMPNO id
,ENAME label 
FROM EMP ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
TYPE pLOVType IS RECORD (
output varchar2(500),
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
  if lower(p_lov) = lower('lov$Employess') then
    v_description := 'EMPLOYESS';
    for r in c_lov$Employess(p_id) loop
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo of block JSON call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
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
 htp.formOpen(curl=>'!IMP_DEMO_AJAX_JSON_BLOCK.openLOV',
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
   return 'v.1.1.20200818133043'; 
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
if B10EMPLOYEE(i__) is null then vc := rasd_client.sessionGetValue('B10EMPLOYEE'); B10EMPLOYEE(i__)  := vc;  end if; 
if SITEBLOCKEMPNO(i__) is null then vc := rasd_client.sessionGetValue('SITEBLOCKEMPNO'); SITEBLOCKEMPNO(i__)  := rasd_client.varchr2number(vc);  end if; 
if SITEBLOCKENAME(i__) is null then vc := rasd_client.sessionGetValue('SITEBLOCKENAME'); SITEBLOCKENAME(i__)  := vc;  end if; 
if SITEBLOCKJOB(i__) is null then vc := rasd_client.sessionGetValue('SITEBLOCKJOB'); SITEBLOCKJOB(i__)  := vc;  end if; 
if SITEBLOCKMGR(i__) is null then vc := rasd_client.sessionGetValue('SITEBLOCKMGR'); SITEBLOCKMGR(i__)  := rasd_client.varchr2number(vc);  end if; 
if SITEBLOCKHIREDATE(i__) is null then vc := rasd_client.sessionGetValue('SITEBLOCKHIREDATE'); SITEBLOCKHIREDATE(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('RECNUMA99') then RECNUMA99 := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONBCK') then GBUTTONBCK := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCLR') then GBUTTONCLR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONFWD') then GBUTTONFWD := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSAVE') then GBUTTONSAVE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('FEMPNO') then FEMPNO := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10EMPLOYEE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10EMPLOYEE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKEMPNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        SITEBLOCKEMPNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99EMPNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        A99EMPNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        A99ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        SITEBLOCKENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('A99JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        A99JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKJOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        SITEBLOCKJOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKMGR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        SITEBLOCKMGR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99MGR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        A99MGR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('SITEBLOCKHIREDATE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        SITEBLOCKHIREDATE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('A99HIREDATE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        A99HIREDATE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('B10EMPLOYEE') and B10EMPLOYEE.count = 0 and value_array(i__) is not null then
        B10EMPLOYEE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKEMPNO') and SITEBLOCKEMPNO.count = 0 and value_array(i__) is not null then
        SITEBLOCKEMPNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99EMPNO') and A99EMPNO.count = 0 and value_array(i__) is not null then
        A99EMPNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99ENAME') and A99ENAME.count = 0 and value_array(i__) is not null then
        A99ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKENAME') and SITEBLOCKENAME.count = 0 and value_array(i__) is not null then
        SITEBLOCKENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('A99JOB') and A99JOB.count = 0 and value_array(i__) is not null then
        A99JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKJOB') and SITEBLOCKJOB.count = 0 and value_array(i__) is not null then
        SITEBLOCKJOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('SITEBLOCKMGR') and SITEBLOCKMGR.count = 0 and value_array(i__) is not null then
        SITEBLOCKMGR(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('A99MGR') and A99MGR.count = 0 and value_array(i__) is not null then
        A99MGR(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('SITEBLOCKHIREDATE') and SITEBLOCKHIREDATE.count = 0 and value_array(i__) is not null then
        SITEBLOCKHIREDATE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('A99HIREDATE') and A99HIREDATE.count = 0 and value_array(i__) is not null then
        A99HIREDATE(1) := to_date(value_array(i__), rasd_client.c_date_format);
      end if;
    end loop;
-- organize records
declare
v_last number := 
A99EMPNO
.last;
v_curr number := 
A99EMPNO
.first;
i__ number;
begin
 if v_last <> 
A99EMPNO
.count then 
   v_curr := 
A99EMPNO
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if A99EMPNO.exists(v_curr) then A99EMPNO(i__) := A99EMPNO(v_curr); end if;
      if A99ENAME.exists(v_curr) then A99ENAME(i__) := A99ENAME(v_curr); end if;
      if A99JOB.exists(v_curr) then A99JOB(i__) := A99JOB(v_curr); end if;
      if A99MGR.exists(v_curr) then A99MGR(i__) := A99MGR(v_curr); end if;
      if A99HIREDATE.exists(v_curr) then A99HIREDATE(i__) := A99HIREDATE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
A99EMPNO
.NEXT(v_curr);  
   END LOOP;
      A99EMPNO.DELETE(i__ , v_last);
      A99ENAME.DELETE(i__ , v_last);
      A99JOB.DELETE(i__ , v_last);
      A99MGR.DELETE(i__ , v_last);
      A99HIREDATE.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if A99EMPNO.count > v_max then v_max := A99EMPNO.count; end if;
    if A99ENAME.count > v_max then v_max := A99ENAME.count; end if;
    if A99JOB.count > v_max then v_max := A99JOB.count; end if;
    if A99MGR.count > v_max then v_max := A99MGR.count; end if;
    if A99HIREDATE.count > v_max then v_max := A99HIREDATE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not A99EMPNO.exists(i__) then
        A99EMPNO(i__) := to_number(null);
      end if;
      if not A99ENAME.exists(i__) then
        A99ENAME(i__) := null;
      end if;
      if not A99JOB.exists(i__) then
        A99JOB(i__) := null;
      end if;
      if not A99MGR.exists(i__) then
        A99MGR(i__) := to_number(null);
      end if;
      if not A99HIREDATE.exists(i__) then
        A99HIREDATE(i__) := to_date(null);
      end if;
    null; end loop;
    v_max := 0;
    if B10EMPLOYEE.count > v_max then v_max := B10EMPLOYEE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10EMPLOYEE.exists(i__) then
        B10EMPLOYEE(i__) := null;
      end if;
      if not B10EMPLOYEE#SET.exists(i__) then
        B10EMPLOYEE#SET(i__).visible := true;
      end if;
    null; end loop;
    v_max := 0;
    if SITEBLOCKEMPNO.count > v_max then v_max := SITEBLOCKEMPNO.count; end if;
    if SITEBLOCKENAME.count > v_max then v_max := SITEBLOCKENAME.count; end if;
    if SITEBLOCKJOB.count > v_max then v_max := SITEBLOCKJOB.count; end if;
    if SITEBLOCKMGR.count > v_max then v_max := SITEBLOCKMGR.count; end if;
    if SITEBLOCKHIREDATE.count > v_max then v_max := SITEBLOCKHIREDATE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not SITEBLOCKEMPNO.exists(i__) then
        SITEBLOCKEMPNO(i__) := to_number(null);
      end if;
      if not SITEBLOCKENAME.exists(i__) then
        SITEBLOCKENAME(i__) := null;
      end if;
      if not SITEBLOCKJOB.exists(i__) then
        SITEBLOCKJOB(i__) := null;
      end if;
      if not SITEBLOCKMGR.exists(i__) then
        SITEBLOCKMGR(i__) := to_number(null);
      end if;
      if not SITEBLOCKHIREDATE.exists(i__) then
        SITEBLOCKHIREDATE(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin

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
        B10EMPLOYEE(i__) := null;
        B10EMPLOYEE#SET(i__).visible := true;

      end loop;
  end;
  procedure pclear_SITEBLOCK(pstart number) is
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
        SITEBLOCKEMPNO(i__) := null;
        SITEBLOCKENAME(i__) := null;
        SITEBLOCKJOB(i__) := null;
        SITEBLOCKMGR(i__) := null;
        SITEBLOCKHIREDATE(i__) := null;

      end loop;
  end;
  procedure pclear_A99(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 1 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
A99EMPNO
.count(); end if;
      else  
       if i__ > 1 then  k__ := i__ + 0;
       else k__ := 0 + 1;
       end if;
      end if;
      j__ := i__;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        A99EMPNO(i__) := null;
        A99ENAME(i__) := null;
        A99JOB(i__) := null;
        A99MGR(i__) := null;
        A99HIREDATE(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    RECNUMA99 := 1;
    ERROR := null;
    GBUTTONBCK := 'GBUTTONBCK';
    GBUTTONCLR := 'GBUTTONCLR';
    GBUTTONFWD := 'GBUTTONFWD';
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSAVE := 'GBUTTONSAVE';
    GBUTTONSRC := 'GBUTTONSRC';
    MESSAGE := null;
    PAGE := 1;
    WARNING := null;
    FEMPNO := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);
    pclear_SITEBLOCK(0);
    pclear_A99(0);

  null;
  end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10EMPLOYEE.count);
  null; end;
  procedure pselect_SITEBLOCK is
    i__ pls_integer;
  begin
      pclear_SITEBLOCK(SITEBLOCKEMPNO.count);
  null; end;
  procedure pselect_A99 is
    i__ pls_integer;
  begin
      A99EMPNO.delete;
      A99ENAME.delete;
      A99JOB.delete;
      A99MGR.delete;
      A99HIREDATE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="75" blockid="A99">
SELECT 
EMPNO,
ENAME,
JOB,
MGR,
HIREDATE FROM EMP where EMPNO = FEMPNO
--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            A99EMPNO(i__)
           ,A99ENAME(i__)
           ,A99JOB(i__)
           ,A99MGR(i__)
           ,A99HIREDATE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =1;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          A99EMPNO.delete(1);
          A99ENAME.delete(1);
          A99JOB.delete(1);
          A99MGR.delete(1);
          A99HIREDATE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_A99(A99EMPNO.count);
  null; end;
  procedure pselect is
  begin
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 19 then 
      pselect_A99;
    end if;
  null;
 end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10EMPLOYEE.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_SITEBLOCK is
  begin
    for i__ in 1..SITEBLOCKEMPNO.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_A99 is
  begin
    for i__ in 1..A99EMPNO.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if 1=2 then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
    null; end loop;
  null; end;
  procedure pcommit is
  begin

    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 19 then 
       pcommit_A99;
    end if;

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
  function ShowFieldFEMPNO return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONBCK return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONCLR return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONFWD return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONRES return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONSAVE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONSRC return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldMESSAGE return boolean is 
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
  function ShowBlockA99_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 19 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB10_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockSITEBLOCK_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  procedure js_Slov$Employess(value varchar2, name varchar2 default null) is
  begin
    htp.p('<script language="JavaScript">');
    htp.p('js_Slov$Employess('''||value||''','''||name||''');');
    htp.p('</script>');
  end;
procedure output_A99_DIV is begin htp.p('');  if  ShowBlockA99_DIV  then  
htp.prn('<div  id="A99_DIV" class="rasdblock"><div>
<caption><div id="A99_LAB" class="labelblock">Ajax service for Emp data</div></caption>
<table border="0" id="A99_TABLE"><tr id="A99_BLOCK"><td class="rasdTxLab rasdTxLabBlockA99" id="rasdTxLabA99EMPNO"><span id="A99EMPNO_LAB" class="label">Empno</span></td><td class="rasdTxA99EMPNO rasdTxTypeN" id="rasdTxA99EMPNO_1"><input name="A99EMPNO_1" id="A99EMPNO_1_RASD" type="text" value="'||ltrim(to_char(A99EMPNO(1)))||'" class="rasdTextN "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockA99" id="rasdTxLabA99ENAME"><span id="A99ENAME_LAB" class="label">Ename</span></td><td class="rasdTxA99ENAME rasdTxTypeC" id="rasdTxA99ENAME_1"><input name="A99ENAME_1" id="A99ENAME_1_RASD" type="text" value="'||A99ENAME(1)||'" class="rasdTextC "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockA99" id="rasdTxLabA99JOB"><span id="A99JOB_LAB" class="label">Job</span></td><td class="rasdTxA99JOB rasdTxTypeC" id="rasdTxA99JOB_1"><input name="A99JOB_1" id="A99JOB_1_RASD" type="text" value="'||A99JOB(1)||'" class="rasdTextC "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockA99" id="rasdTxLabA99MGR"><span id="A99MGR_LAB" class="label">Mgr</span></td><td class="rasdTxA99MGR rasdTxTypeN" id="rasdTxA99MGR_1"><font id="A99MGR_1_RASD" class="rasdFont">'||ltrim(to_char(A99MGR(1)))||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockA99" id="rasdTxLabA99HIREDATE"><span id="A99HIREDATE_LAB" class="label">Hiredate</span></td><td class="rasdTxA99HIREDATE rasdTxTypeD" id="rasdTxA99HIREDATE_1"><span id="A99HIREDATE_1_RASD" autocomplete="off">'|| rasd_client.getHtmlDatePicker('A99HIREDATE_1', '') ||' 
<input id="A99HIREDATE_1" name="A99HIREDATE_1" type="text" value="'||to_char(A99HIREDATE(1),rasd_client.C_DATE_FORMAT)||'" class="rasdTextD " autocomplete="off" />
</span></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure pre_output_B10_DIV is  begin
--<pre_ui formid="75" blockid="B10">
 
B10EMPLOYEE#SET(1).custom := 'onchange="FillDynamicData(this.value);"';

--</pre_ui>
  end;
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock">Select employee</div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10EMPLOYEE">');  if B10EMPLOYEE#SET(1).visible then  
htp.prn('<span id="B10EMPLOYEE_LAB" class="label"></span>');  end if;  
htp.prn('</td><td class="rasdTxB10EMPLOYEE rasdTxTypeC" id="rasdTxB10EMPLOYEE_1">');  if B10EMPLOYEE#SET(1).visible then  
htp.prn('<select name="B10EMPLOYEE_1" ID="B10EMPLOYEE_1_RASD" class="rasdSelect ');  if B10EMPLOYEE#SET(1).error is not null then htp.p(' errorField'); end if;  
htp.prn('');  if B10EMPLOYEE#SET(1).info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  if B10EMPLOYEE#SET(1).readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if B10EMPLOYEE#SET(1).info is not null then htp.p(' title="'||B10EMPLOYEE#SET(1).info||'"'); end if;  
htp.prn('');  if B10EMPLOYEE#SET(1).disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('');  if B10EMPLOYEE#SET(1).required then htp.p(' required="required"'); end if;  
htp.prn('');  htp.p(B10EMPLOYEE#SET(1).custom);  
htp.prn('');  if B10EMPLOYEE#SET(1).error is not null then htp.p(' title="'||B10EMPLOYEE#SET(1).error||'"'); end if;  
htp.prn('>'); js_Slov$Employess(B10EMPLOYEE(1),'B10EMPLOYEE_1'); 
htp.prn('</select>');  end if;  
htp.prn('</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_SITEBLOCK_DIV is begin htp.p('');  if  ShowBlockSITEBLOCK_DIV  then  
htp.prn('<div  id="SITEBLOCK_DIV" class="rasdblock"><div>
<caption><div id="SITEBLOCK_LAB" class="labelblock">Elements field with Ajax call</div></caption>
<table border="0" id="SITEBLOCK_TABLE"><tr id="SITEBLOCK_BLOCK"><td class="rasdTxLab rasdTxLabBlockSITEBLOCK" id="rasdTxLabSITEBLOCKEMPNO"><span id="SITEBLOCKEMPNO_LAB" class="label">Empno</span></td><td class="rasdTxSITEBLOCKEMPNO rasdTxTypeN" id="rasdTxSITEBLOCKEMPNO_1"><input name="SITEBLOCKEMPNO_1" id="SITEBLOCKEMPNO_1_RASD" type="text" value="'||ltrim(to_char(SITEBLOCKEMPNO(1)))||'" class="rasdTextN "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockSITEBLOCK" id="rasdTxLabSITEBLOCKENAME"><span id="SITEBLOCKENAME_LAB" class="label">Ename</span></td><td class="rasdTxSITEBLOCKENAME rasdTxTypeC" id="rasdTxSITEBLOCKENAME_1"><input name="SITEBLOCKENAME_1" id="SITEBLOCKENAME_1_RASD" type="text" value="'||SITEBLOCKENAME(1)||'" class="rasdTextC "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockSITEBLOCK" id="rasdTxLabSITEBLOCKJOB"><span id="SITEBLOCKJOB_LAB" class="label">Job</span></td><td class="rasdTxSITEBLOCKJOB rasdTxTypeC" id="rasdTxSITEBLOCKJOB_1"><input name="SITEBLOCKJOB_1" id="SITEBLOCKJOB_1_RASD" type="text" value="'||SITEBLOCKJOB(1)||'" class="rasdTextC "/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockSITEBLOCK" id="rasdTxLabSITEBLOCKMGR"><span id="SITEBLOCKMGR_LAB" class="label">Mgr</span></td><td class="rasdTxSITEBLOCKMGR rasdTxTypeN" id="rasdTxSITEBLOCKMGR_1"><font id="SITEBLOCKMGR_1_RASD" class="rasdFont">'||ltrim(to_char(SITEBLOCKMGR(1)))||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockSITEBLOCK" id="rasdTxLabSITEBLOCKHIREDATE"><span id="SITEBLOCKHIREDATE_LAB" class="label">Hiredate</span></td><td class="rasdTxSITEBLOCKHIREDATE rasdTxTypeC" id="rasdTxSITEBLOCKHIREDATE_1"><input name="SITEBLOCKHIREDATE_1" id="SITEBLOCKHIREDATE_1_RASD" type="text" value="'||SITEBLOCKHIREDATE(1)||'" class="rasdTextC "/>
</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function js_Slov$Employess(pvalue, pobjectname) {');
      htp.p(' eval(''val_''+pobjectname+''="''+pvalue+''"'');'); 
      htp.p(' var x = document.getElementById(pobjectname+''_RASD''); ');
    begin
    for r__ in (
--<lovsql formid="75" linkid="lov$Employess">
SELECT 
 EMPNO id
,ENAME label 
FROM EMP
--</lovsql>
    ) loop
      htp.p('  var option = document.createElement("option"); option.value="'||r__.id||'"; option.text = "'||replace(r__.label,'''','\''')||'"; option.selected = ((pvalue=='''||r__.id||''')?'' selected '':''''); x.add(option);');
    end loop;
    exception when others then
      raise_application_error('-20000','Error in lov$Employess: '||sqlerrm);  
    end;
    htp.p('}');
    htp.prn('</script>');
    htp.p('<script language="JavaScript">');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFSITEBLOCK() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFA99() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo of block JSON call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="IMP_DEMO_AJAX_JSON_BLOCK_LAB" class="rasdFormLab">Demo of block JSON call '|| rasd_client.getHtmlDataTable('IMP_DEMO_AJAX_JSON_BLOCK_LAB') ||'     </div><div id="IMP_DEMO_AJAX_JSON_BLOCK_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('IMP_DEMO_AJAX_JSON_BLOCK_MENU') ||'     </div>
<form name="IMP_DEMO_AJAX_JSON_BLOCK" method="post" action="?"><div id="IMP_DEMO_AJAX_JSON_BLOCK_DIV" class="rasdForm"><div id="IMP_DEMO_AJAX_JSON_BLOCK_HEAD" class="rasdFormHead"><input name="RECNUMA99" id="RECNUMA99_RASD" type="hidden" value="'||RECNUMA99||'"/>
<input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="IMP_DEMO_AJAX_JSON_BLOCK_BODY" class="rasdFormBody">'); pre_output_B10_DIV; output_B10_DIV; htp.p(''); output_SITEBLOCK_DIV; htp.p(''); output_A99_DIV; htp.p('</div><div id="IMP_DEMO_AJAX_JSON_BLOCK_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="IMP_DEMO_AJAX_JSON_BLOCK_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="IMP_DEMO_AJAX_JSON_BLOCK_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="IMP_DEMO_AJAX_JSON_BLOCK_FOOTER" class="rasdFormFooter">');  

if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_AJAX_JSON_BLOCK_FOOTER',1,instr('IMP_DEMO_AJAX_JSON_BLOCK_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockA99_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 19 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB10_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockSITEBLOCK_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="IMP_DEMO_AJAX_JSON_BLOCK" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<recnuma99><![CDATA['||RECNUMA99||']]></recnuma99>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<gbuttonbck><![CDATA['||GBUTTONBCK||']]></gbuttonbck>'); 
    htp.p('<gbuttonclr><![CDATA['||GBUTTONCLR||']]></gbuttonclr>'); 
    htp.p('<gbuttonfwd><![CDATA['||GBUTTONFWD||']]></gbuttonfwd>'); 
    htp.p('<gbuttonres><![CDATA['||GBUTTONRES||']]></gbuttonres>'); 
    htp.p('<gbuttonsave><![CDATA['||GBUTTONSAVE||']]></gbuttonsave>'); 
    htp.p('<gbuttonsrc><![CDATA['||GBUTTONSRC||']]></gbuttonsrc>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<page>'||PAGE||'</page>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10employee><![CDATA['||B10EMPLOYEE(1)||']]></b10employee>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    if ShowBlocksiteblock_DIV then 
    htp.p('<siteblock>'); 
    htp.p('<element>'); 
    htp.p('<siteblockempno>'||SITEBLOCKEMPNO(1)||'</siteblockempno>'); 
    htp.p('<siteblockename><![CDATA['||SITEBLOCKENAME(1)||']]></siteblockename>'); 
    htp.p('<siteblockjob><![CDATA['||SITEBLOCKJOB(1)||']]></siteblockjob>'); 
    htp.p('<siteblockmgr>'||SITEBLOCKMGR(1)||'</siteblockmgr>'); 
    htp.p('<siteblockhiredate><![CDATA['||SITEBLOCKHIREDATE(1)||']]></siteblockhiredate>'); 
    htp.p('</element>'); 
  htp.p('</siteblock>'); 
  end if; 
    if ShowBlocka99_DIV then 
    htp.p('<a99>'); 
  for i__ in 1..
A99EMPNO
.count loop 
    htp.p('<element>'); 
    htp.p('<a99empno>'||A99EMPNO(i__)||'</a99empno>'); 
    htp.p('<a99ename><![CDATA['||A99ENAME(i__)||']]></a99ename>'); 
    htp.p('<a99job><![CDATA['||A99JOB(i__)||']]></a99job>'); 
    htp.p('<a99mgr>'||A99MGR(i__)||'</a99mgr>'); 
    htp.p('<a99hiredate>'||A99HIREDATE(i__)||'</a99hiredate>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</a99>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"IMP_DEMO_AJAX_JSON_BLOCK","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"recnuma99":"'||escapeRest(RECNUMA99)||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"gbuttonbck":"'||escapeRest(GBUTTONBCK)||'"'); 
    htp.p(',"gbuttonclr":"'||escapeRest(GBUTTONCLR)||'"'); 
    htp.p(',"gbuttonfwd":"'||escapeRest(GBUTTONFWD)||'"'); 
    htp.p(',"gbuttonres":"'||escapeRest(GBUTTONRES)||'"'); 
    htp.p(',"gbuttonsave":"'||escapeRest(GBUTTONSAVE)||'"'); 
    htp.p(',"gbuttonsrc":"'||escapeRest(GBUTTONSRC)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"page":"'||PAGE||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockb10_DIV then 
    htp.p('"b10":['); 
     htp.p('{'); 
    htp.p('"b10employee":"'||escapeRest(B10EMPLOYEE(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"b10":[]'); 
  end if; 
    if ShowBlocksiteblock_DIV then 
    htp.p(',"siteblock":['); 
     htp.p('{'); 
    htp.p('"siteblockempno":"'||SITEBLOCKEMPNO(1)||'"'); 
    htp.p(',"siteblockename":"'||escapeRest(SITEBLOCKENAME(1))||'"'); 
    htp.p(',"siteblockjob":"'||escapeRest(SITEBLOCKJOB(1))||'"'); 
    htp.p(',"siteblockmgr":"'||SITEBLOCKMGR(1)||'"'); 
    htp.p(',"siteblockhiredate":"'||escapeRest(SITEBLOCKHIREDATE(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"siteblock":[]'); 
  end if; 
    if ShowBlocka99_DIV then 
    htp.p(',"a99":['); 
  v_firstrow__ := true;
  for i__ in 1..
A99EMPNO
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"a99empno":"'||A99EMPNO(i__)||'"'); 
    htp.p(',"a99ename":"'||escapeRest(A99ENAME(i__))||'"'); 
    htp.p(',"a99job":"'||escapeRest(A99JOB(i__))||'"'); 
    htp.p(',"a99mgr":"'||A99MGR(i__)||'"'); 
    htp.p(',"a99hiredate":"'||A99HIREDATE(i__)||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"a99":[]'); 
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
  rasd_client.secCheckPermission('IMP_DEMO_AJAX_JSON_BLOCK',ACTION);  
  if ACTION is null then null;
    RECNUMA99 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONBCK then     pselect;
    poutput;
  elsif ACTION = GBUTTONFWD then     pselect;
    poutput;
  elsif ACTION = GBUTTONSRC then     RECNUMA99 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    --if MESSAGE is null then
    --MESSAGE := 'Form is changed.';
    --end if;
    poutput;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutput;
  end if;

  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.p('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo of block JSON call')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="IMP_DEMO_AJAX_JSON_BLOCK_LAB" class="rasdFormLab">Demo of block JSON call '|| rasd_client.getHtmlDataTable('IMP_DEMO_AJAX_JSON_BLOCK_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'IMP_DEMO_AJAX_JSON_BLOCK' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_AJAX_JSON_BLOCK_FOOTER',1,instr('IMP_DEMO_AJAX_JSON_BLOCK_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('IMP_DEMO_AJAX_JSON_BLOCK',ACTION);  
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your oown.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR, GBUTTONSAVE ) then 
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
  rasd_client.secCheckPermission('IMP_DEMO_AJAX_JSON_BLOCK',ACTION);  
  if ACTION is null then null;
    RECNUMA99 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONBCK then     pselect;
    poutputrest;
  elsif ACTION = GBUTTONFWD then     pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC or ACTION is null  then     RECNUMA99 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    --if MESSAGE is null then
    --MESSAGE := 'Form is changed.';
    --end if;
    poutputrest;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutputrest;
  end if;

  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="IMP_DEMO_AJAX_JSON_BLOCK" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"IMP_DEMO_AJAX_JSON_BLOCK","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>75</formid><form>IMP_DEMO_AJAX_JSON_BLOCK</form><version>1</version><change>18.08.2020 01/30/44</change><user>RASDCLI</user><label><![CDATA[Demo of block JSON call]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>18.08.2020 01/30/25</change><compileyn>N</compileyn><application>imported form</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  owa_util.mime_header('application/xml', FALSE);
  HTP.p('Content-Disposition: filename="Export_IMP_DEMO_AJAX_JSON_BLOCK_v.1.1.20200818133044.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end IMP_DEMO_AJAX_JSON_BLOCK;
/

