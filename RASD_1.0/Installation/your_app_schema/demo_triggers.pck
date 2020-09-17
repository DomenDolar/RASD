create or replace package DEMO_TRIGGERS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_TRIGGERS generated on 08.01.20 by user RASDCLI.     
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
  type myNewGlobalProjectType is table of varchar2(10) index by binary_integer;
  myNewGlobalProjectConstant constant number := 0;
  myNewGlobalProjectVariable date;
  function myNewFunction(pParameterIn varchar2 ) return integer;

procedure openLOV(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);
end;
/

create or replace package body DEMO_TRIGGERS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_TRIGGERS generated on 08.01.20 by user RASDCLI.    
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
  RESTRESTYPE varchar2(4000);  RECNUMB30                     varchar2(4000) := 1
;  RECNUMB20                     varchar2(4000) := 1
;  RECNUMB10                     varchar2(4000) := 1
;
  INJOB                         varchar2(4000);  PAGE                          number := 0
;
  ACTION                        varchar2(4000);
  BUTTONNEW                     varchar2(4000);
  ERROR                         varchar2(4000);  GBUTTONBCK                    varchar2(4000) := 'GBUTTONBCK'
;  GBUTTONCLR                    varchar2(4000) := 'GBUTTONCLR'
;  GBUTTONFWD                    varchar2(4000) := 'GBUTTONFWD'
;  GBUTTONRES                    varchar2(4000) := 'GBUTTONRES'
;  GBUTTONSAVE                   varchar2(4000) := 'GBUTTONSAVE'
;  GBUTTONSRC                    varchar2(4000) := 'GBUTTONSRC'
;
  MESSAGE                       varchar2(4000);
  WARNING                       varchar2(4000);
  B10RID                        rtab;
  B10RS                         ctab;
  B10ENAME                      ctab;
  B10JOB                        ctab;
  B10SAL                        ntab;
  B10COMM                       ntab;
  B10INHTML                     ctab;
  B10BUTTON                     ctab;
  B10BUTTON2                    ctab;
  B20RID                        rtab;
  B20RS                         ctab;
  B20EMPNO                      ntab;
  B20ENAME                      ctab;
  B20JOB                        ctab;
  B20MGR                        ntab;
  B20HIREDATE                   dtab;
  B20SAL                        ntab;
  B20COMM                       ntab;
  B20DEPTNO                     ntab;
  B20NOTE                       ctab;
  B30RID                        rtab;
  B30RS                         ctab;
  B30JOB                        ctab;
  B30DESCRIPTION                ctab;
--
-- types should be in your first custom pl/sql procedure
-- otherwise function/procedures will follow generated
-- types and there will be an error in code
--
  type myNewGlobalPackageType is table of varchar2(10) index by binary_integer;
  myNewGlobalPackageConstant constant number := 0;
  myNewGlobalPackageVariable date;
  function myNewFunction(pParameterIn varchar2 ) return integer is
    myNewLocalVariable integer;
  begin
    -- my New Code
    return( myNewLocalVariable );
  end;
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
        rasd_client.callLog('27','||v_clob||', systimestamp, '' );
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
//JS
        ';
       end; 
     function form_css return clob is
       begin
        return '
//CSS
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
cursor c_sql(p_id varchar2) is 
--<lovsql formid="27" linkid="sql">
select id, label from (select 'Code or Id stored in DB' id, 'Description shown insted of code' label from dual ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
cursor c_lov3(p_id varchar2) is 
--<lovsql formid="27" linkid="lov3">
select id, label from (select 'Code or Id stored in DB' id, 'Description shown insted of code' label from dual ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
cursor c_lov2(p_id varchar2) is 
--<lovsql formid="27" linkid="lov2">
select id, label from (select 'Code or Id stored in DB' id, 'Description shown insted of code' label from dual ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
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
  if lower(p_lov) = lower('sql') then
    v_description := 'LOV';
    for r in c_sql(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('lov3') then
    v_description := 'LOV3';
    for r in c_lov3(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('lov2') then
    v_description := 'LOV2';
    for r in c_lov2(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('ddd') then
    v_description := 'DD';
        v_lov(1).output := 'descrerewrwer';
        v_lov(1).p1 := 'ddd';
        v_lov(2).output := 'descr';
        v_lov(2).p1 := '343';
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Trigger test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
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
 htp.formOpen(curl=>'!DEMO_TRIGGERS.openLOV',
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
   return 'v.1.1.20200108100129'; 
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
if INJOB is null then vc := rasd_client.sessionGetValue('INJOB'); INJOB  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('RECNUMB30') then RECNUMB30 := value_array(i__);
      elsif  upper(name_array(i__)) = upper('RECNUMB20') then RECNUMB20 := value_array(i__);
      elsif  upper(name_array(i__)) = upper('RECNUMB10') then RECNUMB10 := value_array(i__);
      elsif  upper(name_array(i__)) = upper('INJOB') then INJOB := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('BUTTONNEW') then BUTTONNEW := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONBCK') then GBUTTONBCK := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCLR') then GBUTTONCLR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONFWD') then GBUTTONFWD := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSAVE') then GBUTTONSAVE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RID_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10RID(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10RS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10RS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10SAL(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10COMM_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10COMM(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10INHTML_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10INHTML(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BUTTON_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10BUTTON(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BUTTON2_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10BUTTON2(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20RID_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20RID(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20RS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20RS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20EMPNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20EMPNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20MGR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20MGR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20HIREDATE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20HIREDATE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('B20SAL_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20SAL(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20COMM_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20COMM(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20DEPTNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20DEPTNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20NOTE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20NOTE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30RID_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30RID(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B30RS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30RS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30DESCRIPTION_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30DESCRIPTION(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RID') and B10RID.count = 0 and value_array(i__) is not null then
        B10RID(1) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10RS') and B10RS.count = 0 and value_array(i__) is not null then
        B10RS(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ENAME') and B10ENAME.count = 0 and value_array(i__) is not null then
        B10ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB') and B10JOB.count = 0 and value_array(i__) is not null then
        B10JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL') and B10SAL.count = 0 and value_array(i__) is not null then
        B10SAL(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10COMM') and B10COMM.count = 0 and value_array(i__) is not null then
        B10COMM(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10INHTML') and B10INHTML.count = 0 and value_array(i__) is not null then
        B10INHTML(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BUTTON') and B10BUTTON.count = 0 and value_array(i__) is not null then
        B10BUTTON(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BUTTON2') and B10BUTTON2.count = 0 and value_array(i__) is not null then
        B10BUTTON2(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20RID') and B20RID.count = 0 and value_array(i__) is not null then
        B20RID(1) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20RS') and B20RS.count = 0 and value_array(i__) is not null then
        B20RS(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20EMPNO') and B20EMPNO.count = 0 and value_array(i__) is not null then
        B20EMPNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20ENAME') and B20ENAME.count = 0 and value_array(i__) is not null then
        B20ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20JOB') and B20JOB.count = 0 and value_array(i__) is not null then
        B20JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20MGR') and B20MGR.count = 0 and value_array(i__) is not null then
        B20MGR(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20HIREDATE') and B20HIREDATE.count = 0 and value_array(i__) is not null then
        B20HIREDATE(1) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('B20SAL') and B20SAL.count = 0 and value_array(i__) is not null then
        B20SAL(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20COMM') and B20COMM.count = 0 and value_array(i__) is not null then
        B20COMM(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20DEPTNO') and B20DEPTNO.count = 0 and value_array(i__) is not null then
        B20DEPTNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20NOTE') and B20NOTE.count = 0 and value_array(i__) is not null then
        B20NOTE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30RID') and B30RID.count = 0 and value_array(i__) is not null then
        B30RID(1) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B30RS') and B30RS.count = 0 and value_array(i__) is not null then
        B30RS(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30JOB') and B30JOB.count = 0 and value_array(i__) is not null then
        B30JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30DESCRIPTION') and B30DESCRIPTION.count = 0 and value_array(i__) is not null then
        B30DESCRIPTION(1) := value_array(i__);
      end if;
    end loop;
-- organize records
declare
v_last number := 
B10RID
.last;
v_curr number := 
B10RID
.first;
i__ number;
begin
 if v_last <> 
B10RID
.count then 
   v_curr := 
B10RID
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B10RID.exists(v_curr) then B10RID(i__) := B10RID(v_curr); end if;
      if B10RS.exists(v_curr) then B10RS(i__) := B10RS(v_curr); end if;
      if B10ENAME.exists(v_curr) then B10ENAME(i__) := B10ENAME(v_curr); end if;
      if B10JOB.exists(v_curr) then B10JOB(i__) := B10JOB(v_curr); end if;
      if B10SAL.exists(v_curr) then B10SAL(i__) := B10SAL(v_curr); end if;
      if B10COMM.exists(v_curr) then B10COMM(i__) := B10COMM(v_curr); end if;
      if B10INHTML.exists(v_curr) then B10INHTML(i__) := B10INHTML(v_curr); end if;
      if B10BUTTON.exists(v_curr) then B10BUTTON(i__) := B10BUTTON(v_curr); end if;
      if B10BUTTON2.exists(v_curr) then B10BUTTON2(i__) := B10BUTTON2(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B10RID
.NEXT(v_curr);  
   END LOOP;
      B10RID.DELETE(i__ , v_last);
      B10RS.DELETE(i__ , v_last);
      B10ENAME.DELETE(i__ , v_last);
      B10JOB.DELETE(i__ , v_last);
      B10SAL.DELETE(i__ , v_last);
      B10COMM.DELETE(i__ , v_last);
      B10INHTML.DELETE(i__ , v_last);
      B10BUTTON.DELETE(i__ , v_last);
      B10BUTTON2.DELETE(i__ , v_last);
end if;
end;
declare
v_last number := 
B20RID
.last;
v_curr number := 
B20RID
.first;
i__ number;
begin
 if v_last <> 
B20RID
.count then 
   v_curr := 
B20RID
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B20RID.exists(v_curr) then B20RID(i__) := B20RID(v_curr); end if;
      if B20RS.exists(v_curr) then B20RS(i__) := B20RS(v_curr); end if;
      if B20EMPNO.exists(v_curr) then B20EMPNO(i__) := B20EMPNO(v_curr); end if;
      if B20ENAME.exists(v_curr) then B20ENAME(i__) := B20ENAME(v_curr); end if;
      if B20JOB.exists(v_curr) then B20JOB(i__) := B20JOB(v_curr); end if;
      if B20MGR.exists(v_curr) then B20MGR(i__) := B20MGR(v_curr); end if;
      if B20HIREDATE.exists(v_curr) then B20HIREDATE(i__) := B20HIREDATE(v_curr); end if;
      if B20SAL.exists(v_curr) then B20SAL(i__) := B20SAL(v_curr); end if;
      if B20COMM.exists(v_curr) then B20COMM(i__) := B20COMM(v_curr); end if;
      if B20DEPTNO.exists(v_curr) then B20DEPTNO(i__) := B20DEPTNO(v_curr); end if;
      if B20NOTE.exists(v_curr) then B20NOTE(i__) := B20NOTE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B20RID
.NEXT(v_curr);  
   END LOOP;
      B20RID.DELETE(i__ , v_last);
      B20RS.DELETE(i__ , v_last);
      B20EMPNO.DELETE(i__ , v_last);
      B20ENAME.DELETE(i__ , v_last);
      B20JOB.DELETE(i__ , v_last);
      B20MGR.DELETE(i__ , v_last);
      B20HIREDATE.DELETE(i__ , v_last);
      B20SAL.DELETE(i__ , v_last);
      B20COMM.DELETE(i__ , v_last);
      B20DEPTNO.DELETE(i__ , v_last);
      B20NOTE.DELETE(i__ , v_last);
end if;
end;
declare
v_last number := 
B30RID
.last;
v_curr number := 
B30RID
.first;
i__ number;
begin
 if v_last <> 
B30RID
.count then 
   v_curr := 
B30RID
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B30RID.exists(v_curr) then B30RID(i__) := B30RID(v_curr); end if;
      if B30RS.exists(v_curr) then B30RS(i__) := B30RS(v_curr); end if;
      if B30JOB.exists(v_curr) then B30JOB(i__) := B30JOB(v_curr); end if;
      if B30DESCRIPTION.exists(v_curr) then B30DESCRIPTION(i__) := B30DESCRIPTION(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B30RID
.NEXT(v_curr);  
   END LOOP;
      B30RID.DELETE(i__ , v_last);
      B30RS.DELETE(i__ , v_last);
      B30JOB.DELETE(i__ , v_last);
      B30DESCRIPTION.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if B10RID.count > v_max then v_max := B10RID.count; end if;
    if B10RS.count > v_max then v_max := B10RS.count; end if;
    if B10ENAME.count > v_max then v_max := B10ENAME.count; end if;
    if B10JOB.count > v_max then v_max := B10JOB.count; end if;
    if B10SAL.count > v_max then v_max := B10SAL.count; end if;
    if B10COMM.count > v_max then v_max := B10COMM.count; end if;
    if B10INHTML.count > v_max then v_max := B10INHTML.count; end if;
    if B10BUTTON.count > v_max then v_max := B10BUTTON.count; end if;
    if B10BUTTON2.count > v_max then v_max := B10BUTTON2.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B10RID.exists(i__) then
        B10RID(i__) := null;
      end if;
      if not B10RS.exists(i__) then
        B10RS(i__) := null;
      end if;
      if not B10ENAME.exists(i__) then
        B10ENAME(i__) := null;
      end if;
      if not B10JOB.exists(i__) then
        B10JOB(i__) := null;
      end if;
      if not B10SAL.exists(i__) then
        B10SAL(i__) := to_number(null);
      end if;
      if not B10COMM.exists(i__) then
        B10COMM(i__) := to_number(null);
      end if;
      if not B10INHTML.exists(i__) then
        B10INHTML(i__) := null;
      end if;
      if not B10BUTTON.exists(i__) then
        B10BUTTON(i__) := 'Details';
      end if;
      if not B10BUTTON2.exists(i__) then
        B10BUTTON2(i__) := 'Details2';
      end if;
--<on_new_record formid="27" blockid="B10">
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        
        B10BUTTON(i__) := 'Details33';
        B10BUTTON2(i__) := 'Details233';
        

--</on_new_record>
    null; end loop;
    v_max := 0;
    if B20RID.count > v_max then v_max := B20RID.count; end if;
    if B20RS.count > v_max then v_max := B20RS.count; end if;
    if B20EMPNO.count > v_max then v_max := B20EMPNO.count; end if;
    if B20ENAME.count > v_max then v_max := B20ENAME.count; end if;
    if B20JOB.count > v_max then v_max := B20JOB.count; end if;
    if B20MGR.count > v_max then v_max := B20MGR.count; end if;
    if B20HIREDATE.count > v_max then v_max := B20HIREDATE.count; end if;
    if B20SAL.count > v_max then v_max := B20SAL.count; end if;
    if B20COMM.count > v_max then v_max := B20COMM.count; end if;
    if B20DEPTNO.count > v_max then v_max := B20DEPTNO.count; end if;
    if B20NOTE.count > v_max then v_max := B20NOTE.count; end if;
    if v_max = 0 then v_max := 5; end if;
    for i__ in 1..v_max loop
      if not B20RID.exists(i__) then
        B20RID(i__) := null;
      end if;
      if not B20RS.exists(i__) then
        B20RS(i__) := null;
      end if;
      if not B20EMPNO.exists(i__) then
        B20EMPNO(i__) := to_number(null);
      end if;
      if not B20ENAME.exists(i__) then
        B20ENAME(i__) := null;
      end if;
      if not B20JOB.exists(i__) then
        B20JOB(i__) := null;
      end if;
      if not B20MGR.exists(i__) then
        B20MGR(i__) := to_number(null);
      end if;
      if not B20HIREDATE.exists(i__) then
        B20HIREDATE(i__) := to_date(null);
      end if;
      if not B20SAL.exists(i__) then
        B20SAL(i__) := to_number(null);
      end if;
      if not B20COMM.exists(i__) then
        B20COMM(i__) := to_number(null);
      end if;
      if not B20DEPTNO.exists(i__) then
        B20DEPTNO(i__) := to_number(null);
      end if;
      if not B20NOTE.exists(i__) then
        B20NOTE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B30RID.count > v_max then v_max := B30RID.count; end if;
    if B30RS.count > v_max then v_max := B30RS.count; end if;
    if B30JOB.count > v_max then v_max := B30JOB.count; end if;
    if B30DESCRIPTION.count > v_max then v_max := B30DESCRIPTION.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B30RID.exists(i__) then
        B30RID(i__) := null;
      end if;
      if not B30RS.exists(i__) then
        B30RS(i__) := null;
      end if;
      if not B30JOB.exists(i__) then
        B30JOB(i__) := null;
      end if;
      if not B30DESCRIPTION.exists(i__) then
        B30DESCRIPTION(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="27" blockid="">
-- Executing after filling fields on submit.
rlog('POST_SUBMIT');
--</POST_SUBMIT>
    null;
  end;
  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
  begin
--<ON_SUBMIT formid="27" blockid="">
-- Reading post variables into fields.
    on_submit(name_array ,value_array);
--</ON_SUBMIT>
    post_submit;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 0 = 0 then k__ := i__ + 1;
 if pstart = 0 then k__ := k__ + 
B10RID
.count(); end if;
      else  
       if i__ > 0 then  k__ := i__ + 1;
       else k__ := 1 + 0;
       end if;
      end if;
      j__ := i__;
      for i__ in 1..j__ loop
      begin
      B10RS(i__) := B10RS(i__);
      exception when others then
        B10RS(i__) := null;

      end;
      begin
      B10INHTML(i__) := B10INHTML(i__);
      exception when others then
        B10INHTML(i__) := null;

      end;
      begin
      B10BUTTON(i__) := B10BUTTON(i__);
      exception when others then
        B10BUTTON(i__) := 'Details';

      end;
      begin
      B10BUTTON2(i__) := B10BUTTON2(i__);
      exception when others then
        B10BUTTON2(i__) := 'Details2';

      end;
      null;
      end loop;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10RID(i__) := null;
        B10RS(i__) := null;
        B10ENAME(i__) := null;
        B10JOB(i__) := null;
        B10SAL(i__) := null;
        B10COMM(i__) := null;
        B10INHTML(i__) := null;
        B10BUTTON(i__) := 'Details';
        B10BUTTON2(i__) := 'Details2';
        B10RS(i__) := 'I';

--<on_new_record formid="27" blockid="B10">
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        
        B10BUTTON(i__) := 'Details33';
        B10BUTTON2(i__) := 'Details233';
        

--</on_new_record>
      end loop;
  end;
  procedure pclear_B20(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 5 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B20RID
.count(); end if;
      else  
       if i__ > 5 then  k__ := i__ + 0;
       else k__ := 0 + 5;
       end if;
      end if;
      j__ := i__;
      for i__ in 1..j__ loop
      begin
      B20RS(i__) := B20RS(i__);
      exception when others then
        B20RS(i__) := null;

      end;
      null;
      end loop;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B20RID(i__) := null;
        B20RS(i__) := null;
        B20EMPNO(i__) := null;
        B20ENAME(i__) := null;
        B20JOB(i__) := null;
        B20MGR(i__) := null;
        B20HIREDATE(i__) := null;
        B20SAL(i__) := null;
        B20COMM(i__) := null;
        B20DEPTNO(i__) := null;
        B20NOTE(i__) := null;
        B20RS(i__) := 'I';

      end loop;
  end;
  procedure pclear_B30(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 1 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B30RID
.count(); end if;
      else  
       if i__ > 1 then  k__ := i__ + 0;
       else k__ := 0 + 1;
       end if;
      end if;
      j__ := i__;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B30RID(i__) := null;
        B30RS(i__) := null;
        B30JOB(i__) := null;
        B30DESCRIPTION(i__) := null;
        B30RS(i__) := 'I';

      end loop;
  end;
  procedure pclear_form is
  begin
    RECNUMB30 := 1;
    RECNUMB20 := 1;
    RECNUMB10 := 1;
    INJOB := null;
    PAGE := 0;
    BUTTONNEW := null;
    ERROR := null;
    GBUTTONBCK := 'GBUTTONBCK';
    GBUTTONCLR := 'GBUTTONCLR';
    GBUTTONFWD := 'GBUTTONFWD';
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSAVE := 'GBUTTONSAVE';
    GBUTTONSRC := 'GBUTTONSRC';
    MESSAGE := null;
    WARNING := null;
  null; end;
  procedure pclear is
  begin
--<on_clear formid="27" blockid="">
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);
    pclear_B20(0);
--</on_clear>
  null;
  end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      B10RID.delete;
      B10ENAME.delete;
      B10JOB.delete;
      B10SAL.delete;
      B10COMM.delete;
--<pre_select formid="27" blockid="B10">
-- Triggers before executing SQL. Use (i__) to access fields values.
rlog('B10 PRE_SELECT');
--</pre_select>
      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
--<on_select formid="27" blockid="B10">
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR
--<SQL formid="27" blockid="B10">
SELECT
 ROWID RID,
ENAME,
JOB,
SAL,
COMM FROM BONUS
--</SQL>
;
--</on_select>
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B10RID(i__)
           ,B10ENAME(i__)
           ,B10JOB(i__)
           ,B10SAL(i__)
           ,B10COMM(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
            B10RS(i__) := 'U';
--<on_lock_value formid="27" blockid="B10">
-- Setting of the locked values. Use (i__) to access fields values.
            B10RS(i__) := B10RS(i__) ||','||B10ENAME(i__);
            B10RS(i__) := B10RS(i__) ||','||B10JOB(i__);

--</on_lock_value>
--<post_select formid="27" blockid="B10">
-- Triggers after executing SQL. Use (i__) to access fields values.
rlog('B10 POST_SELECT');
B10BUTTON(i__) := 'Button';
B10BUTTON2(i__) := 'Button2';
--</post_select>
            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B10RID.delete(1);
          B10RS.delete(1);
          B10ENAME.delete(1);
          B10JOB.delete(1);
          B10SAL.delete(1);
          B10COMM.delete(1);
          B10INHTML.delete(1);
          B10BUTTON.delete(1);
          B10BUTTON2.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B10(B10RID.count);
  null; end;
  procedure pselect_B20 is
    i__ pls_integer;
  begin
      B20RID.delete;
      B20EMPNO.delete;
      B20ENAME.delete;
      B20JOB.delete;
      B20MGR.delete;
      B20HIREDATE.delete;
      B20SAL.delete;
      B20COMM.delete;
      B20DEPTNO.delete;
      B20NOTE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="27" blockid="B20">
SELECT 
 ROWID RID,
EMPNO,
ENAME,
JOB,
MGR,
HIREDATE,
SAL,
COMM,
DEPTNO,
NOTE FROM EMP where job = injob
--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B20RID(i__)
           ,B20EMPNO(i__)
           ,B20ENAME(i__)
           ,B20JOB(i__)
           ,B20MGR(i__)
           ,B20HIREDATE(i__)
           ,B20SAL(i__)
           ,B20COMM(i__)
           ,B20DEPTNO(i__)
           ,B20NOTE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  nvl(RECNUMB20,1) then
            B20RS(i__) := 'U';
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =5;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  nvl(RECNUMB20,1) then
          B20RID.delete(1);
          B20RS.delete(1);
          B20EMPNO.delete(1);
          B20ENAME.delete(1);
          B20JOB.delete(1);
          B20MGR.delete(1);
          B20HIREDATE.delete(1);
          B20SAL.delete(1);
          B20COMM.delete(1);
          B20DEPTNO.delete(1);
          B20NOTE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B20(B20RID.count);
  null; end;
  procedure pselect_B30 is
    i__ pls_integer;
  begin
      B30RID.delete;
      B30JOB.delete;
      B30DESCRIPTION.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="27" blockid="B30">
SELECT 
 ROWID RID,
JOB,
DESCRIPTION FROM JOBS 
--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B30RID(i__)
           ,B30JOB(i__)
           ,B30DESCRIPTION(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  nvl(RECNUMB30,1) then
            B30RS(i__) := 'U';
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =1;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  nvl(RECNUMB30,1) then
          B30RID.delete(1);
          B30RS.delete(1);
          B30JOB.delete(1);
          B30DESCRIPTION.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B30(B30RID.count);
  null; end;
  procedure pselect is
  begin
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
      pselect_B10;
    end if;
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
      pselect_B20;
    end if;
    if  nvl(PAGE,0) = 0 then 
      pselect_B30;
    end if;
  null;
 end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10RID.count loop
--<on_validate formid="27" blockid="B10">
-- Validating field values before DML. Use (i__) to access fields values.
rlog('B10 ON_VALIDATE');
--</on_validate>
      if substr(B10RS(i__),1,1) = 'I' then --INSERT
        if B10ENAME(i__) is not null
 or B10JOB(i__) is not null
 or B10SAL(i__) is not null
 or B10COMM(i__) is not null
 then 
--<pre_insert formid="27" blockid="B10">
-- Triggers before INSERT. Use (i__) to access fields values.
rlog('B10 PRE_INSERT');
--</pre_insert>
--<on_mandatory formid="27" blockid="B10">
-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10SAL(i__) is null
 or B10COMM(i__) is null
 then
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
--</on_mandatory>
--<on_insert formid="27" blockid="B10">
--Generated INSERT statement. Use (i__) to access fields values.
insert into BONUS (
  ENAME
 ,JOB
 ,SAL
 ,COMM
) values (
  B10ENAME(i__)
 ,B10JOB(i__)
 ,B10SAL(i__)
 ,B10COMM(i__)
);
--</on_insert>
--<post_insert formid="27" blockid="B10">
-- Triggers after INSERT. Use (i__) to access fields values.
rlog('B10 POST_INSERT');
--</post_insert>
        null; end if;
      null; else -- UPDATE or DELETE;
--<on_lock formid="27" blockid="B10">
-- Generated code for lock value based on fiels checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.
declare
  v_locking varchar2(4000);
 begin
  select 'U'||','||ENAME||','||JOB into v_locking
from BONUS
where ROWID = B10RID(i__) for update;
  if B10RS(i__) <> v_locking then
    raise_application_error('-20002','Data has been changed! Refresh data.');
  end if;
end;


--</on_lock>
        if B10ENAME(i__) is null
 and B10JOB(i__) is null
 and B10SAL(i__) is null
 and B10COMM(i__) is null
 then --DELETE
--<pre_delete formid="27" blockid="B10">
-- Triggers before DELETE. Use (i__) to access fields values.
rlog('B10 PRE_DELETE');
--</pre_delete>
--<on_delete formid="27" blockid="B10">
--Generated DELETE statement. Use (i__) to access fields values.
delete BONUS
where ROWID = B10RID(i__);
--</on_delete>
--<post_delete formid="27" blockid="B10">
-- Triggers after DELETE. Use (i__) to access fields values.
rlog('B10 POST_DELETE');
--</post_delete>
        else --UPDATE
--<pre_update formid="27" blockid="B10">
-- Triggers before UPDATE. Use (i__) to access fields values.
rlog('B10 PRE_UPDATE');
--</pre_update>
--<on_mandatory formid="27" blockid="B10">
-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10SAL(i__) is null
 or B10COMM(i__) is null
 then
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
--</on_mandatory>
--<on_update formid="27" blockid="B10">
--Generated UPDATE statement. Use (i__) to access fields values.
update BONUS set
  ENAME = B10ENAME(i__)
 ,JOB = B10JOB(i__)
 ,SAL = B10SAL(i__)
 ,COMM = B10COMM(i__)
where ROWID = B10RID(i__);
--</on_update>
--<post_update formid="27" blockid="B10">
-- Triggers after UPDATE. Use (i__) to access fields values.
rlog('B10 POST_UPDATE');
--</post_update>
       null;  end if;
      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B20 is
  begin
    for i__ in 1..B20RID.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if substr(B20RS(i__),1,1) = 'I' then --INSERT
        if B20EMPNO(i__) is not null
 or B20ENAME(i__) is not null
 or B20JOB(i__) is not null
 or B20MGR(i__) is not null
 or B20HIREDATE(i__) is not null
 or B20SAL(i__) is not null
 or B20COMM(i__) is not null
 or B20DEPTNO(i__) is not null
 or B20NOTE(i__) is not null
 then 

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B20EMPNO(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated INSERT statement. Use (i__) to access fields values.
if substr(B20RS(i__),1,1) = 'I' then
insert into EMP (
  EMPNO
 ,ENAME
 ,JOB
 ,MGR
 ,HIREDATE
 ,SAL
 ,COMM
 ,DEPTNO
 ,NOTE
) values (
  B20EMPNO(i__)
 ,B20ENAME(i__)
 ,B20JOB(i__)
 ,B20MGR(i__)
 ,B20HIREDATE(i__)
 ,B20SAL(i__)
 ,B20COMM(i__)
 ,B20DEPTNO(i__)
 ,B20NOTE(i__)
);
 MESSAGE := 'Data is changed.';
end if;

        null; end if;
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

        if B20EMPNO(i__) is null
 and B20ENAME(i__) is null
 and B20JOB(i__) is null
 and B20MGR(i__) is null
 and B20HIREDATE(i__) is null
 and B20SAL(i__) is null
 and B20COMM(i__) is null
 and B20DEPTNO(i__) is null
 and B20NOTE(i__) is null
 then --DELETE

-- Generated DELETE statement. Use (i__) to access fields values.
if substr(B20RS(i__),1,1) = 'U' then
delete EMP
where ROWID = B20RID(i__);
 MESSAGE := 'Data is changed.';
end if;

        else --UPDATE

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B20EMPNO(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated UPDATE statement. Use (i__) to access fields values.
if substr(B20RS(i__),1,1) = 'U' then
update EMP set
  EMPNO = B20EMPNO(i__)
 ,ENAME = B20ENAME(i__)
 ,JOB = B20JOB(i__)
 ,MGR = B20MGR(i__)
 ,HIREDATE = B20HIREDATE(i__)
 ,SAL = B20SAL(i__)
 ,COMM = B20COMM(i__)
 ,DEPTNO = B20DEPTNO(i__)
 ,NOTE = B20NOTE(i__)
where ROWID = B20RID(i__);
 MESSAGE := 'Data is changed.';
end if;


       null;  end if;
      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B30 is
  begin
    for i__ in 1..B30RID.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if substr(B30RS(i__),1,1) = 'I' then --INSERT
        if B30JOB(i__) is not null
 or B30DESCRIPTION(i__) is not null
 then 

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B30JOB(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated INSERT statement. Use (i__) to access fields values.
if substr(B30RS(i__),1,1) = 'I' then
insert into JOBS (
  JOB
 ,DESCRIPTION
) values (
  B30JOB(i__)
 ,B30DESCRIPTION(i__)
);
 MESSAGE := 'Data is changed.';
end if;

        null; end if;
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

        if B30JOB(i__) is null
 and B30DESCRIPTION(i__) is null
 then --DELETE

-- Generated DELETE statement. Use (i__) to access fields values.
if substr(B30RS(i__),1,1) = 'U' then
delete JOBS
where ROWID = B30RID(i__);
 MESSAGE := 'Data is changed.';
end if;

        else --UPDATE

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B30JOB(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated UPDATE statement. Use (i__) to access fields values.
if substr(B30RS(i__),1,1) = 'U' then
update JOBS set
  JOB = B30JOB(i__)
 ,DESCRIPTION = B30DESCRIPTION(i__)
where ROWID = B30RID(i__);
 MESSAGE := 'Data is changed.';
end if;


       null;  end if;
      null; end if;
    null; end loop;
  null; end;
  procedure pcommit is
  begin
--<pre_commit formid="27" blockid="">
-- Triggers before executing DML operations on DB blocks.
rlog('PRE_COMMIT');
--</pre_commit>
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       pcommit_B10;
    end if;
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       pcommit_B20;
    end if;
    if  nvl(PAGE,0) = 0 then 
       pcommit_B30;
    end if;
--<post_commit formid="27" blockid="">
-- Triggers after executing DML operations on DB blocks.
rlog('POST_COMMIT');
--</post_commit>
  null; 
  end;
  procedure poutput is
    iB10 pls_integer;
    iB20 pls_integer;
  function ShowFieldBUTTONNEW return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldERROR return boolean is 
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
  function ShowFieldINJOB return boolean is 
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
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB20_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function js_button2link(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'B10BUTTON2%' then
      v_return := v_return || '''!demo_triggers.webclient?dsds=sds&vvv=fff&PAGE=2&XXXX=''+document.DEMO_TRIGGERS.B10ENAME_'||substr(name,instr(name,'_',-1)+1)||'.value+
''&INJOB=''+document.DEMO_TRIGGERS.B10JOB_'||substr(name,instr(name,'_',-1)+1)||'.value+
''&YYYY='||replace(value,'"','&quot;')||'&GBUTTONRES='||replace(value,'"','&quot;')||'''';
    elsif name is null then
      v_return := v_return ||'''!demo_triggers.webclient?dsds=sds&vvv=fff&PAGE=2&XXXX=''+document.DEMO_TRIGGERS.B10ENAME_1.value+
''&INJOB=''+document.DEMO_TRIGGERS.B10JOB_1.value+
''&YYYY='||replace(value,'"','&quot;')||'&GBUTTONRES='||replace(value,'"','&quot;')||'''';
    end if;
    return v_return;
  end;
  procedure js_button2link(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_button2link(value, name));
  end;
  function js_ewe(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    end if;
    return v_return;
  end;
  procedure js_ewe(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_ewe(value, name));
  end;
  procedure js_lov2(value varchar2, name varchar2 default null) is
  begin
    if 1=2 then null;
    elsif name like 'B10JOB%' then
      htp.prn('javascript: var link=window.open(encodeURI(''!DEMO_TRIGGERS.openLOV?PLOV=lov2&FIN=DEMO_TRIGGERS.'||name||'&PID=''+document.DEMO_TRIGGERS.'||name||'.value+''''),''openLOV'',''resizable,scrollbars,width=680,height=550'');');
    end if;
  end;
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock">Bonus</div></caption><table border="1" id="B10_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10ENAME"><span id="B10ENAME_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10JOB"><span id="B10JOB_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10SAL"><span id="B10SAL_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10COMM"><span id="B10COMM_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10INHTML"><span id="B10INHTML_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10BUTTON"><span id="B10BUTTON_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10BUTTON2"><span id="B10BUTTON2_LAB" class="label"></span></td></tr></thead>'); for iB10 in 1..B10RID.count loop 
htp.prn('<tr id="B10_BLOCK"><span id="" value="'||iB10||'" name="" class="hiddenRowItems"><input name="B10RS_'||iB10||'" id="B10RS_'||iB10||'_RASD" type="hidden" value="'||B10RS(iB10)||'"/>
<input name="B10RID_'||iB10||'" id="B10RID_'||iB10||'_RASD" type="hidden" value="'||to_char(B10RID(iB10))||'"/>
</span><td class="rasdTxB10ENAME rasdTxTypeC" id="rasdTxB10ENAME_'||iB10||'"><input name="B10ENAME_'||iB10||'" id="B10ENAME_'||iB10||'_RASD" type="text" value="'||B10ENAME(iB10)||'" class="rasdTextC"/>
</td><td class="rasdTxB10JOB rasdTxTypeC" id="rasdTxB10JOB_'||iB10||'"><input ondblclick="'); js_lov2(B10JOB(iB10),'B10JOB_'||iB10||''); 
htp.prn('" name="B10JOB_'||iB10||'" id="B10JOB_'||iB10||'_RASD" type="text" value="'||B10JOB(iB10)||'" class="rasdTextC"/>
</td><td class="rasdTxB10SAL rasdTxTypeN" id="rasdTxB10SAL_'||iB10||'"><input name="B10SAL_'||iB10||'" id="B10SAL_'||iB10||'_RASD" type="text" value="'||ltrim(to_char(B10SAL(iB10)))||'" class="rasdTextN"/>
</td><td class="rasdTxB10COMM rasdTxTypeN" id="rasdTxB10COMM_'||iB10||'"><input name="B10COMM_'||iB10||'" id="B10COMM_'||iB10||'_RASD" type="text" value="'||ltrim(to_char(B10COMM(iB10)))||'" class="rasdTextN"/>
</td><td class="rasdTxB10INHTML rasdTxTypeC" id="rasdTxB10INHTML_'||iB10||'"><span id="B10INHTML_'||iB10||'_RASD">');  htp.p('Code in button: onclick="document.getElementById(''PAGE_RASD'').value = ''2''; document.getElementById(''INJOB_RASD'').value = ''B10JOB_VALUE''; submit();"');  
htp.prn('</span></td><td class="rasdTxB10BUTTON rasdTxTypeC" id="rasdTxB10BUTTON_'||iB10||'"><input onclick="document.getElementById(''PAGE_RASD'').value = ''2''; document.getElementById(''INJOB_RASD'').value = '''||B10JOB(iB10)||'''; submit();" name="B10BUTTON_'||iB10||'" id="B10BUTTON_'||iB10||'_RASD" type="button" value="'||B10BUTTON(iB10)||'" class="rasdButton"/>
</td><td class="rasdTxB10BUTTON2 rasdTxTypeC" id="rasdTxB10BUTTON2_'||iB10||'"><input onclick="javascript: location=encodeURI('); js_button2link(B10BUTTON2(iB10),'B10BUTTON2_'||iB10||''); 
htp.prn(');" name="B10BUTTON2_'||iB10||'" id="B10BUTTON2_'||iB10||'_RASD" type="button" value="'||B10BUTTON2(iB10)||'" class="rasdButton"/>
</td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B20_DIV is begin htp.p('');  if  ShowBlockB20_DIV  then  
htp.prn('<div  id="B20_DIV" class="rasdblock"><div>
<caption><div id="B20_LAB" class="labelblock">Employe</div></caption><table border="1" id="B20_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20EMPNO"><span id="B20EMPNO_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20ENAME"><span id="B20ENAME_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20JOB"><span id="B20JOB_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20MGR"><span id="B20MGR_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20HIREDATE"><span id="B20HIREDATE_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20SAL"><span id="B20SAL_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20COMM"><span id="B20COMM_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20DEPTNO"><span id="B20DEPTNO_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20NOTE"><span id="B20NOTE_LAB" class="label"></span></td></tr></thead>'); for iB20 in 1..B20RID.count loop 
htp.prn('<tr id="B20_BLOCK"><span id="" value="'||iB20||'" name="" class="hiddenRowItems"><input name="B20RID_'||iB20||'" id="B20RID_'||iB20||'_RASD" type="hidden" value="'||to_char(B20RID(iB20))||'"/>
<input name="B20RS_'||iB20||'" id="B20RS_'||iB20||'_RASD" type="hidden" value="'||B20RS(iB20)||'"/>
</span><td class="rasdTxB20EMPNO rasdTxTypeN" id="rasdTxB20EMPNO_'||iB20||'"><input name="B20EMPNO_'||iB20||'" id="B20EMPNO_'||iB20||'_RASD" type="text" value="'||ltrim(to_char(B20EMPNO(iB20)))||'" class="rasdTextN"/>
</td><td class="rasdTxB20ENAME rasdTxTypeC" id="rasdTxB20ENAME_'||iB20||'"><input name="B20ENAME_'||iB20||'" id="B20ENAME_'||iB20||'_RASD" type="text" value="'||B20ENAME(iB20)||'" class="rasdTextC"/>
</td><td class="rasdTxB20JOB rasdTxTypeC" id="rasdTxB20JOB_'||iB20||'"><input name="B20JOB_'||iB20||'" id="B20JOB_'||iB20||'_RASD" type="text" value="'||B20JOB(iB20)||'" class="rasdTextC"/>
</td><td class="rasdTxB20MGR rasdTxTypeN" id="rasdTxB20MGR_'||iB20||'"><input name="B20MGR_'||iB20||'" id="B20MGR_'||iB20||'_RASD" type="text" value="'||ltrim(to_char(B20MGR(iB20)))||'" class="rasdTextN"/>
</td><td class="rasdTxB20HIREDATE rasdTxTypeD" id="rasdTxB20HIREDATE_'||iB20||'"><span id="B20HIREDATE_'||iB20||'_RASD" autocomplete="off">'|| rasd_client.getHtmlDatePicker('B20HIREDATE_'||iB20||'', '') ||' 
<input id="B20HIREDATE_'||iB20||'" name="B20HIREDATE_'||iB20||'" type="text" value="'||to_char(B20HIREDATE(iB20),rasd_client.C_DATE_FORMAT)||'" class="rasdTextD" autocomplete="off" />
</span></td><td class="rasdTxB20SAL rasdTxTypeN" id="rasdTxB20SAL_'||iB20||'"><input name="B20SAL_'||iB20||'" id="B20SAL_'||iB20||'_RASD" type="text" value="'||ltrim(to_char(B20SAL(iB20)))||'" class="rasdTextN"/>
</td><td class="rasdTxB20COMM rasdTxTypeN" id="rasdTxB20COMM_'||iB20||'"><input name="B20COMM_'||iB20||'" id="B20COMM_'||iB20||'_RASD" type="text" value="'||ltrim(to_char(B20COMM(iB20)))||'" class="rasdTextN"/>
</td><td class="rasdTxB20DEPTNO rasdTxTypeN" id="rasdTxB20DEPTNO_'||iB20||'"><input name="B20DEPTNO_'||iB20||'" id="B20DEPTNO_'||iB20||'_RASD" type="text" value="'||ltrim(to_char(B20DEPTNO(iB20)))||'" class="rasdTextN"/>
</td><td class="rasdTxB20NOTE rasdTxTypeC" id="rasdTxB20NOTE_'||iB20||'"><input name="B20NOTE_'||iB20||'" id="B20NOTE_'||iB20||'_RASD" type="text" value="'||B20NOTE(iB20)||'" class="rasdTextC"/>
</td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B30_DIV is begin htp.p('');  if  ShowBlockB30_DIV  then  
htp.prn('<div  id="B30_DIV" class="rasdblock"><div>
<caption><div id="B30_LAB" class="labelblock">Jobs</div></caption>
<table border="0" id="B30_TABLE"><thead><tr><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30JOB"><span id="B30JOB_LAB" class="label">Job</span></td><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30DESCRIPTION"><span id="B30DESCRIPTION_LAB" class="label">Description</span></td></tr></thead><tr id="B30_BLOCK"><span id="" value="1" name="" class="hiddenRowItems"><input name="B30RID_1" id="B30RID_1_RASD" type="hidden" value="'||to_char(B30RID(1))||'"/>
<input name="B30RS_1" id="B30RS_1_RASD" type="hidden" value="'||B30RS(1)||'"/>
</span><td class="rasdTxB30JOB rasdTxTypeC" id="rasdTxB30JOB_1"><input name="B30JOB_1" id="B30JOB_1_RASD" type="text" value="'||B30JOB(1)||'" class="rasdTextC"/>
</td><td class="rasdTxB30DESCRIPTION rasdTxTypeC" id="rasdTxB30DESCRIPTION_1"><input name="B30DESCRIPTION_1" id="B30DESCRIPTION_1_RASD" type="text" value="'||B30DESCRIPTION(1)||'" class="rasdTextC"/>
</td></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('  try { for (j__ = 1; j__ <= 9999; j__++) { ');
    htp.p(' if (  1==2 ');
    htp.p('	   || CheckFieldValue(''B10ENAME_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10JOB_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10SAL_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10COMM_''+j__+''_RASD'','''') ');
    htp.p('  )');
    htp.p('  {');
    htp.p('   i = i + CheckFieldMandatory(''B10SAL_''+j__+''_RASD'', '''');');
    htp.p('   i = i + CheckFieldMandatory(''B10COMM_''+j__+''_RASD'', '''');');
    htp.p('  }');
    htp.p('  } } catch(err) {');
    htp.p('      //alert(err.message);');
    htp.p('  }');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB20() {');
    htp.p('var i = 0;');
    htp.p('  try { for (j__ = 1; j__ <= 5; j__++) { ');
    htp.p(' if (  1==2 ');
    htp.p('	   || CheckFieldValue(''B20EMPNO_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20ENAME_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20JOB_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20MGR_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20HIREDATE_''+j__+'''','''') ');
    htp.p('	   || CheckFieldValue(''B20SAL_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20COMM_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20DEPTNO_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B20NOTE_''+j__+''_RASD'','''') ');
    htp.p('  )');
    htp.p('  {');
    htp.p('   i = i + CheckFieldMandatory(''B20EMPNO_''+j__+''_RASD'', '''');');
    htp.p('  }');
    htp.p('  } } catch(err) {');
    htp.p('      //alert(err.message);');
    htp.p('  }');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB30() {');
    htp.p('var i = 0;');
    htp.p('  try { for (j__ = 1; j__ <= 1; j__++) { ');
    htp.p(' if (  1==2 ');
    htp.p('	   || CheckFieldValue(''B30JOB_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B30DESCRIPTION_''+j__+''_RASD'','''') ');
    htp.p('  )');
    htp.p('  {');
    htp.p('   i = i + CheckFieldMandatory(''B30JOB_''+j__+''_RASD'', '''');');
    htp.p('  }');
    htp.p('  } } catch(err) {');
    htp.p('      //alert(err.message);');
    htp.p('  }');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('  if ( cMFB10() == false ) { i++; } ');
    htp.p('  if ( cMFB20() == false ) { i++; } ');
    htp.p('  if ( cMFB30() == false ) { i++; } ');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Trigger test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_TRIGGERS_LAB" class="rasdFormLab">Trigger test '|| rasd_client.getHtmlDataTable('DEMO_TRIGGERS_LAB') ||'     </div><div id="DEMO_TRIGGERS_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_TRIGGERS_MENU') ||'     </div>
<form name="DEMO_TRIGGERS" method="post" action="!demo_triggers.webclient"><div id="DEMO_TRIGGERS_DIV" class="rasdForm"><div id="DEMO_TRIGGERS_HEAD" class="rasdFormHead"><input name="RECNUMB30" id="RECNUMB30_RASD" type="hidden" value="'||RECNUMB30||'"/>
<input name="RECNUMB20" id="RECNUMB20_RASD" type="hidden" value="'||RECNUMB20||'"/>
<input name="RECNUMB10" id="RECNUMB10_RASD" type="hidden" value="'||RECNUMB10||'"/>
');  
if  ShowFieldINJOB  then  
htp.prn('<input name="INJOB" id="INJOB_RASD" type="text" value="'||INJOB||'" class="rasdTextC"/>');  end if;  
htp.prn('
');  
if  ShowFieldPAGE  then  
htp.prn('<input name="PAGE" id="PAGE_RASD" type="text" value="'||ltrim(to_char(PAGE))||'" class="rasdTextN"/>');  end if;  
htp.prn('
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldBUTTONNEW  then  
htp.prn('<span id="BUTTONNEW_RASD">');  htp.p('ON_UI BUTTON TEXT');  
htp.prn('</span>');  end if;  
htp.prn('');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="DEMO_TRIGGERS_BODY" class="rasdFormBody">'); output_B10_DIV; htp.p(''); output_B20_DIV; htp.p(''); output_B30_DIV; htp.p('</div><div id="DEMO_TRIGGERS_ERROR" class="rasdFormMessage error">
<font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_TRIGGERS_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_TRIGGERS_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_TRIGGERS_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldBUTTONNEW  then  
htp.prn('<span id="BUTTONNEW_RASD">');  htp.p('ON_UI BUTTON TEXT');  
htp.prn('</span>');  end if;  
htp.prn('');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('DEMO_TRIGGERS_FOOTER',1,instr('DEMO_TRIGGERS_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB20_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DEMO_TRIGGERS" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<recnumb30><![CDATA['||RECNUMB30||']]></recnumb30>'); 
    htp.p('<recnumb20><![CDATA['||RECNUMB20||']]></recnumb20>'); 
    htp.p('<recnumb10><![CDATA['||RECNUMB10||']]></recnumb10>'); 
    htp.p('<injob><![CDATA['||INJOB||']]></injob>'); 
    htp.p('<page>'||PAGE||'</page>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<buttonnew><![CDATA['||BUTTONNEW||']]></buttonnew>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<gbuttonbck><![CDATA['||GBUTTONBCK||']]></gbuttonbck>'); 
    htp.p('<gbuttonclr><![CDATA['||GBUTTONCLR||']]></gbuttonclr>'); 
    htp.p('<gbuttonfwd><![CDATA['||GBUTTONFWD||']]></gbuttonfwd>'); 
    htp.p('<gbuttonres><![CDATA['||GBUTTONRES||']]></gbuttonres>'); 
    htp.p('<gbuttonsave><![CDATA['||GBUTTONSAVE||']]></gbuttonsave>'); 
    htp.p('<gbuttonsrc><![CDATA['||GBUTTONSRC||']]></gbuttonsrc>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
  for i__ in 1..
B10RID
.count loop 
    htp.p('<element>'); 
    htp.p('<b10rid>'||B10RID(i__)||'</b10rid>'); 
    htp.p('<b10rs><![CDATA['||B10RS(i__)||']]></b10rs>'); 
    htp.p('<b10ename><![CDATA['||B10ENAME(i__)||']]></b10ename>'); 
    htp.p('<b10job><![CDATA['||B10JOB(i__)||']]></b10job>'); 
    htp.p('<b10sal>'||B10SAL(i__)||'</b10sal>'); 
    htp.p('<b10comm>'||B10COMM(i__)||'</b10comm>'); 
    htp.p('<b10inhtml><![CDATA['||B10INHTML(i__)||']]></b10inhtml>'); 
    htp.p('<b10button><![CDATA['||B10BUTTON(i__)||']]></b10button>'); 
    htp.p('<b10button2><![CDATA['||B10BUTTON2(i__)||']]></b10button2>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p('<b20>'); 
  for i__ in 1..
B20RID
.count loop 
    htp.p('<element>'); 
    htp.p('<b20rid>'||B20RID(i__)||'</b20rid>'); 
    htp.p('<b20rs><![CDATA['||B20RS(i__)||']]></b20rs>'); 
    htp.p('<b20empno>'||B20EMPNO(i__)||'</b20empno>'); 
    htp.p('<b20ename><![CDATA['||B20ENAME(i__)||']]></b20ename>'); 
    htp.p('<b20job><![CDATA['||B20JOB(i__)||']]></b20job>'); 
    htp.p('<b20mgr>'||B20MGR(i__)||'</b20mgr>'); 
    htp.p('<b20hiredate>'||B20HIREDATE(i__)||'</b20hiredate>'); 
    htp.p('<b20sal>'||B20SAL(i__)||'</b20sal>'); 
    htp.p('<b20comm>'||B20COMM(i__)||'</b20comm>'); 
    htp.p('<b20deptno>'||B20DEPTNO(i__)||'</b20deptno>'); 
    htp.p('<b20note><![CDATA['||B20NOTE(i__)||']]></b20note>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b20>'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p('<b30>'); 
  for i__ in 1..
B30RID
.count loop 
    htp.p('<element>'); 
    htp.p('<b30rid>'||B30RID(i__)||'</b30rid>'); 
    htp.p('<b30rs><![CDATA['||B30RS(i__)||']]></b30rs>'); 
    htp.p('<b30job><![CDATA['||B30JOB(i__)||']]></b30job>'); 
    htp.p('<b30description><![CDATA['||B30DESCRIPTION(i__)||']]></b30description>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b30>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_TRIGGERS","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"recnumb30":"'||escapeRest(RECNUMB30)||'"'); 
    htp.p(',"recnumb20":"'||escapeRest(RECNUMB20)||'"'); 
    htp.p(',"recnumb10":"'||escapeRest(RECNUMB10)||'"'); 
    htp.p(',"injob":"'||escapeRest(INJOB)||'"'); 
    htp.p(',"page":"'||PAGE||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"buttonnew":"'||escapeRest(BUTTONNEW)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"gbuttonbck":"'||escapeRest(GBUTTONBCK)||'"'); 
    htp.p(',"gbuttonclr":"'||escapeRest(GBUTTONCLR)||'"'); 
    htp.p(',"gbuttonfwd":"'||escapeRest(GBUTTONFWD)||'"'); 
    htp.p(',"gbuttonres":"'||escapeRest(GBUTTONRES)||'"'); 
    htp.p(',"gbuttonsave":"'||escapeRest(GBUTTONSAVE)||'"'); 
    htp.p(',"gbuttonsrc":"'||escapeRest(GBUTTONSRC)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockb10_DIV then 
    htp.p('"b10":['); 
  v_firstrow__ := true;
  for i__ in 1..
B10RID
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b10rid":"'||B10RID(i__)||'"'); 
    htp.p(',"b10rs":"'||escapeRest(B10RS(i__))||'"'); 
    htp.p(',"b10ename":"'||escapeRest(B10ENAME(i__))||'"'); 
    htp.p(',"b10job":"'||escapeRest(B10JOB(i__))||'"'); 
    htp.p(',"b10sal":"'||B10SAL(i__)||'"'); 
    htp.p(',"b10comm":"'||B10COMM(i__)||'"'); 
    htp.p(',"b10inhtml":"'||escapeRest(B10INHTML(i__))||'"'); 
    htp.p(',"b10button":"'||escapeRest(B10BUTTON(i__))||'"'); 
    htp.p(',"b10button2":"'||escapeRest(B10BUTTON2(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p('"b10":[]'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p(',"b20":['); 
  v_firstrow__ := true;
  for i__ in 1..
B20RID
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b20rid":"'||B20RID(i__)||'"'); 
    htp.p(',"b20rs":"'||escapeRest(B20RS(i__))||'"'); 
    htp.p(',"b20empno":"'||B20EMPNO(i__)||'"'); 
    htp.p(',"b20ename":"'||escapeRest(B20ENAME(i__))||'"'); 
    htp.p(',"b20job":"'||escapeRest(B20JOB(i__))||'"'); 
    htp.p(',"b20mgr":"'||B20MGR(i__)||'"'); 
    htp.p(',"b20hiredate":"'||B20HIREDATE(i__)||'"'); 
    htp.p(',"b20sal":"'||B20SAL(i__)||'"'); 
    htp.p(',"b20comm":"'||B20COMM(i__)||'"'); 
    htp.p(',"b20deptno":"'||B20DEPTNO(i__)||'"'); 
    htp.p(',"b20note":"'||escapeRest(B20NOTE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b20":[]'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p(',"b30":['); 
  v_firstrow__ := true;
  for i__ in 1..
B30RID
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b30rid":"'||B30RID(i__)||'"'); 
    htp.p(',"b30rs":"'||escapeRest(B30RS(i__))||'"'); 
    htp.p(',"b30job":"'||escapeRest(B30JOB(i__))||'"'); 
    htp.p(',"b30description":"'||escapeRest(B30DESCRIPTION(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b30":[]'); 
  end if; 
    htp.p('}}'); 
end if;
  null; end;
procedure webclient(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
--<PRE_ACTION formid="27" blockid="">

rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
--<ON_ACTION formid="27" blockid="">
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if 1=2 then null;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      RECNUMB30 := 1;
    end if;
    pselect;
    poutput;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC or ACTION is null then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    if MESSAGE is null then
    MESSAGE := 'Form is changed.';
    end if;
    poutput;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutput;
  end if;

--</ON_ACTION>
--<POST_ACTION formid="27" blockid="">
  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,'GBUTTONSRC') not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    raise_application_error('-20000', 'ACTION is not defined. Define it in POST_ACTION trigger.');
  end if;

--</POST_ACTION>
    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
--<ON_ERROR formid="27" blockid="">
--
  htp.prn('<html>
<head>');
  htpClob(rasd_client.getHtmlJSLibrary('HEAD', 'Trigger test'));
  htpClob(FORM_UIHEAD);
  htp.p('<style type="text/css">');
  htpClob(FORM_CSS);
  htp.p('</style><script type="text/javascript">');
  htpClob(FORM_JS);
  htp.p('</script>');
  htp.prn('</head><body><div id="DEMO_TRIGGERS_LAB" class="rasdFormLab">Trigger test ' ||
          rasd_client.getHtmlDataTable('DEMO_TRIGGERS_LAB') ||
          '     </div><div class="rasdForm"><div class="rasdFormHead">
    <input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div>
    <div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">' ||
          sqlcode || '</div>  <div class="rasdHtmlErrorText">' || sqlerrm ||
          '</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div></div>
          </body><html>    ');
--
--</ON_ERROR>
    pLog;
end; 
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
--<PRE_ACTION formid="27" blockid="">

rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
--<ON_ACTION_MAIN formid="27" blockid="">
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

--</ON_ACTION_MAIN>
--<POST_ACTION formid="27" blockid="">
  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,'GBUTTONSRC') not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    raise_application_error('-20000', 'ACTION is not defined. Define it in POST_ACTION trigger.');
  end if;

--</POST_ACTION>
--<ON_ERROR_MAIN formid="27" blockid="">
-- Error handler for the main program.
 exception
  when rasd_client.e_finished then null;

--</ON_ERROR_MAIN>
end; 
procedure rest(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
--<PRE_ACTION formid="27" blockid="">

rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
--<ON_ACTION_REST formid="27" blockid="">
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if 1=2 then null;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      RECNUMB30 := 1;
    end if;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    if MESSAGE is null then
    MESSAGE := 'Form is changed.';
    end if;
    poutputrest;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutputrest;
  end if;
  if  ACTION is null or ACTION not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    pselect;
    poutputrest;
  end if;

--</ON_ACTION_REST>
--<POST_ACTION formid="27" blockid="">
  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,'GBUTTONSRC') not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    raise_application_error('-20000', 'ACTION is not defined. Define it in POST_ACTION trigger.');
  end if;

--</POST_ACTION>
--<ON_ERROR_REST formid="27" blockid="">
-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="DEMO_TRIGGERS" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_TRIGGERS","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

--</ON_ERROR_REST>
end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>27</formid><form>DEMO_TRIGGERS</form><version>1</version><change>08.01.2020 10/01/31</change><user>RASDCLI</user><label><![CDATA[Trigger test]]></label><lobid>RASD</lobid><program>!demo_triggers.webclient</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>Y</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>15.12.2017 11/37/18</change><compileyn>Y</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks><block><blockid>B10</blockid><sqltable>BONUS</sqltable><numrows>0</numrows><emptyrows>1</emptyrows><dbblockyn>Y</dbblockyn><rowidyn>Y</rowidyn><pagingyn>N</pagingyn><clearyn>Y</clearyn><sqltext>
</sqltext><label><![CDATA[Bonus]]></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B10</blockid><fieldid>BUTTON</fieldid><type>C</type><format></format><element>INPUT_BUTTON</element><hiddenyn></hiddenyn><orderby>20</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''Details'']]></defaultval><elementyn>Y</elementyn><nameid>B10BUTTON</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>BUTTON2</fieldid><type>C</type><format></format><element>INPUT_BUTTON</element><hiddenyn></hiddenyn><orderby>22</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''Details2'']]></defaultval><elementyn>Y</elementyn><nameid>B10BUTTON2</nameid><label></label><linkid>button2link</linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>COMM</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>1';
 v_vc(2) := '8</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>Y</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10COMM</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>ENAME</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>12</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>Y</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10ENAME</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>INHTML</fieldid><type>C</type><format></format><element>PLSQL_</element><hiddenyn></hiddenyn><orderby>19</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10INHTML</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>JOB</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>14</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>Y</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10JOB</nameid><label></label><linkid>lov2</linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>RID</fieldid><type>R</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>10</orderby><pkyn>Y</pkyn><selectyn>Y</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defa';
 v_vc(3) := 'ultval><elementyn>Y</elementyn><nameid>B10RID</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>RS</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>10</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10RS</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>SAL</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>16</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>Y</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10SAL</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>B20</blockid><sqltable>EMP</sqltable><numrows>5</numrows><emptyrows></emptyrows><dbblockyn>Y</dbblockyn><rowidyn>Y</rowidyn><pagingyn>Y</pagingyn><clearyn>Y</clearyn><sqltext>&lt;![CDATA[where job = injob]]&gt;
</sqltext><label><![CDATA[Employe]]></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B20</blockid><fieldid>COMM</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>124</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20COMM</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>DEPTNO</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>126</orderby><pkyn>N</pkyn><';
 v_vc(4) := 'selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20DEPTNO</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>EMPNO</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>112</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>Y</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20EMPNO</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>ENAME</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>114</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20ENAME</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>HIREDATE</fieldid><type>D</type><format></format><element></element><hiddenyn></hiddenyn><orderby>120</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20HIREDATE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>JOB</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>116</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><na';
 v_vc(5) := 'meid>B20JOB</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>MGR</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>118</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20MGR</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>NOTE</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>128</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20NOTE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>RID</fieldid><type>R</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>110</orderby><pkyn>Y</pkyn><selectyn>Y</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20RID</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blockid><fieldid>RS</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>110</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20RS</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B20</blocki';
 v_vc(6) := 'd><fieldid>SAL</fieldid><type>N</type><format></format><element></element><hiddenyn></hiddenyn><orderby>122</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B20SAL</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>B30</blockid><sqltable>JOBS</sqltable><numrows>1</numrows><emptyrows>0</emptyrows><dbblockyn>Y</dbblockyn><rowidyn>Y</rowidyn><pagingyn>Y</pagingyn><clearyn>Y</clearyn><sqltext>
</sqltext><label><![CDATA[Jobs]]></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B30</blockid><fieldid>DESCRIPTION</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>1114</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>N</notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B30DESCRIPTION</nameid><label><![CDATA[Description]]></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B30</blockid><fieldid>JOB</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>1112</orderby><pkyn>N</pkyn><selectyn>Y</selectyn><insertyn>Y</insertyn><updateyn>Y</updateyn><deleteyn>Y</deleteyn><insertnnyn>Y</insertnnyn><notnullyn>Y</notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B30JOB</nameid><label><![CDATA[Job]]></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B30</blockid><fieldid>RID</fieldid><type>R</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>1110</orderby><pkyn>Y</pkyn><selectyn>Y</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B30RID</n';
 v_vc(7) := 'ameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B30</blockid><fieldid>RS</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>1110</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B30RS</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block></blocks><fields><field><blockid></blockid><fieldid>ACTION</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ACTION</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>BUTTONNEW</fieldid><type>C</type><format></format><element>PLSQL_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>BUTTONNEW</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>ERROR</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ERROR</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><';
 v_vc(8) := 'blockid></blockid><fieldid>GBUTTONBCK</fieldid><type>C</type><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONBCK'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONBCK</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONCLR</fieldid><type>C</type><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONCLR'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONCLR</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONFWD</fieldid><type>C</type><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONFWD'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONFWD</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONRES</fieldid><type>C</type><format></format><element>INPUT_RESET</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONRES'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONRES</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONSAVE</fieldid><type>C</type';
 v_vc(9) := '><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONSAVE'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONSAVE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONSRC</fieldid><type>C</type><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONSRC'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONSRC</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>INJOB</fieldid><type>C</type><format></format><element>INPUT_TEXT</element><hiddenyn></hiddenyn><orderby>-2</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>INJOB</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>MESSAGE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>MESSAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>PAGE</fieldid><type>N</type><format></format><element>INPUT_TEXT</element><hiddenyn></hiddenyn><orderby>-1</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N';
 v_vc(10) := '</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[0]]></defaultval><elementyn>Y</elementyn><nameid>PAGE</nameid><label><![CDATA[Page]]></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>RECNUMB10</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>-10</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[1]]></defaultval><elementyn>Y</elementyn><nameid>RECNUMB10</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>RECNUMB20</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>-110</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[1]]></defaultval><elementyn>Y</elementyn><nameid>RECNUMB20</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>RECNUMB30</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>-1110</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[1]]></defaultval><elementyn>Y</elementyn><nameid>RECNUMB30</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>WARNING</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lo';
 v_vc(11) := 'ckyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>WARNING</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields><links><link><linkid>button2link</linkid><link>BUTTON2LINK</link><type>F</type><location><![CDATA[I]]></location><text><![CDATA[!demo_triggers.webclient?dsds=sds&vvv=fff]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params><param><paramid>228</paramid><type>OUT</type><orderby>228</orderby><blockid></blockid><fieldid></fieldid><namecid></namecid><code></code><value><![CDATA[PAGE=2]]></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param><param><paramid>B10ENAME227</paramid><type>OUT</type><orderby>227</orderby><blockid>B10</blockid><fieldid>ENAME</fieldid><namecid></namecid><code></code><value><![CDATA[XXXX=B10ENAME_VALUE]]></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param><param><paramid>B10JOB229</paramid><type>OUT</type><orderby>229</orderby><blockid>B10</blockid><fieldid>JOB</fieldid><namecid>INJOB</namecid><code></code><value></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param><param><paramid>THIS225</paramid><type>OUT</type><orderby>225</orderby><blockid></blockid><fieldid>THIS</fieldid><namecid></namecid><code></code><value><![CDATA[YYYY=THIS_VALUE]]></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param><param><paramid>THIS226</paramid><type>OUT</type><orderby>226</orderby><blockid></blockid><fieldid>THIS</fieldid><namecid>GBUTTONRES</namecid><code></code><value></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param></params></link><link><linkid>ddd</linkid><link>DD</link><type>T</type><location></location><text></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params><param><paramid>TEXT1</paramid><type>TEXT</type><orderby>1</orderby><blockid></blockid><fieldid></fieldid><namecid></namecid><code>ddd</code><value><![CDATA[descrerewrwer]]></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param><param><paramid>TEXT2</paramid><type>TEXT</type><orderby>2</orderby><blockid></blockid><fieldid></fieldid><namecid></namecid><code>343</code><value><![CDATA[descr]]></value><rlobid></rlobid><rform></rform><rlinkid></rlinkid></param></par';
 v_vc(12) := 'ams></link><link><linkid>ewe</linkid><link>WEWE</link><type>F</type><location></location><text></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link><link><linkid>lov2</linkid><link>LOV2</link><type>S</type><location></location><text><![CDATA[select ''Code or Id stored in DB'' id, ''Description shown insted of code'' label from dual]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link><link><linkid>lov3</linkid><link>LOV3</link><type>S</type><location></location><text><![CDATA[select ''Code or Id stored in DB'' id, ''Description shown insted of code'' label from dual]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link><link><linkid>sql</linkid><link>LOV</link><type>S</type><location></location><text><![CDATA[select ''Code or Id stored in DB'' id, ''Description shown insted of code'' label from dual]]></text><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rlinkid></rlinkid><params></params></link></links><pages><pagedata><page>0</page><blockid>B10</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>1</page><blockid>B10</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid>B20</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>2</page><blockid>B20</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid>B30</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata></pages><triggers><trigger><blockid></blockid><triggerid>FORM_CSS</triggerid><plsql><![CDATA[//CSS
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>FORM_JS</triggerid><plsql><![CDATA[//JS
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><tri';
 v_vc(13) := 'ggerid>FuncProcBlockName</triggerid><plsql><![CDATA[--
-- types should be in your first custom pl/sql procedure
-- otherwise function/procedures will follow generated
-- types and there will be an error in code
--
  type myNewGlobalPackageType is table of varchar2(10) index by binary_integer;
  myNewGlobalPackageConstant constant number := 0;
  myNewGlobalPackageVariable date;
  function myNewFunction(pParameterIn varchar2 ) return integer is
    myNewLocalVariable integer;
  begin
    -- my New Code
    return( myNewLocalVariable );
  end;
]]></plsql><plsqlspec><![CDATA[  type myNewGlobalProjectType is table of varchar2(10) index by binary_integer;
  myNewGlobalProjectConstant constant number := 0;
  myNewGlobalProjectVariable date;
  function myNewFunction(pParameterIn varchar2 ) return integer;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ACTION</triggerid><plsql><![CDATA[  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if 1=2 then null;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      RECNUMB30 := 1;
    end if;
    pselect;
    poutput;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC or ACTION is null then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    if MESSAGE is null then
    MESSAGE := ''Form is changed.'';
    end if;
    poutput;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutput;
  end if;

]]></plsql><plsqlspec><![CDATA[  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission(''DEMO_TRIGGERS'',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      R';
 v_vc(14) := 'ECNUMB30 := 1;
    end if;
    pselect;
    poutput;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    --if MESSAGE is null then
    --MESSAGE := ''Form is changed.'';
    --end if;
    poutput;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutput;
  end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ACTION_MAIN</triggerid><plsql><![CDATA[  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

]]></plsql><plsqlspec><![CDATA[  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission(''DEMO_TRIGGERS'',ACTION);  
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ACTION_REST</triggerid><plsql><![CDATA[  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  if 1=2 then null;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      RECNUMB30 := 1;
    end if;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    if MESSAGE is null then
    MESSAGE := ''Form is changed.'';
    end if;
    poutputrest;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutputrest;
  end if;
  if  ACTION is null or ACTION not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    pselect;
    poutputrest;
  end if;

]]></plsql><plsqlspec><![CDATA[  -- The program execution sequence ';
 v_vc(15) := 'based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission(''DEMO_TRIGGERS'',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONBCK then     if RECNUMB20 > 5 then
      RECNUMB20 := RECNUMB20-5;
    else
      RECNUMB20 := 1;
    end if;
    if RECNUMB30 > 1 then
      RECNUMB30 := RECNUMB30-1;
    else
      RECNUMB30 := 1;
    end if;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONFWD then     RECNUMB20 := RECNUMB20+5;
    RECNUMB30 := RECNUMB30+1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC or ACTION is null  then     RECNUMB10 := 1;
    RECNUMB20 := 1;
    RECNUMB30 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSAVE then     pcommit;
    pselect;
    --if MESSAGE is null then
    --MESSAGE := ''Form is changed.'';
    --end if;
    poutputrest;
  elsif ACTION = GBUTTONCLR then     pclear;
    poutputrest;
  end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_CLEAR</triggerid><plsql><![CDATA[-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);
    pclear_B20(0);
]]></plsql><plsqlspec><![CDATA[-- Clears all fields on form and blocks.
    pclear_form;
    pclear_B10(0);
    pclear_B20(0);
    pclear_B30(0);

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_DELETE</triggerid><plsql><![CDATA[--Generated DELETE statement. Use (i__) to access fields values.
delete BONUS
where ROWID = B10RID(i__);
]]></plsql><plsqlspec><![CDATA[-- Generated DELETE statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = ''U'' then
delete BONUS
where ROWID = B10RID(i__);
 MESSAGE := ''Data is changed.'';
end if;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ERROR</triggerid><plsql><![CDATA[--
  htp.prn(''<html>
<head>'');
  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'', ''Trigger test''));
  htpClob(FORM_UIHEAD);
  htp.p(''<style type="text/css">'');
  htpClob(FORM_CSS);
  htp.p(''</style><script type="text/javascript">'');
  htpClob(FORM_JS);
';
 v_vc(16) := '
  htp.p(''</script>'');
  htp.prn(''</head><body><div id="DEMO_TRIGGERS_LAB" class="rasdFormLab">Trigger test '' ||
          rasd_client.getHtmlDataTable(''DEMO_TRIGGERS_LAB'') ||
          ''     </div><div class="rasdForm"><div class="rasdFormHead">
    <input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div>
    <div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'' ||
          sqlcode || ''</div>  <div class="rasdHtmlErrorText">'' || sqlerrm ||
          ''</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div></div>
          </body><html>    '');
--
]]></plsql><plsqlspec><![CDATA[    htp.prn(''<html>
<head>'');  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Trigger test'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>'');  
htp.prn(''</head><body><div id="DEMO_TRIGGERS_LAB" class="rasdFormLab">Trigger test ''|| rasd_client.getHtmlDataTable(''DEMO_TRIGGERS_LAB'') ||''     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">''||sqlcode||''</div>  <div class="rasdHtmlErrorText">''||sqlerrm||''</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">''|| rasd_client.getHtmlFooter(version , substr(''DEMO_TRIGGERS_FOOTER'',1,instr(''DEMO_TRIGGERS_FOOTER'', ''_'',-1)-1) , '''') ||''</div></div></body></html>    '');
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ERROR_MAIN</triggerid><plsql><![CDATA[-- Error handler for the main program.
 exception
  when rasd_client.e_finished then null;

]]></plsql><plsqlspec><![CDATA[-- Error handler for the main program.
 exception
  when rasd_client.e_finished then null;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_ERROR_REST</triggerid><plsql><![CDATA[-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = ''XML'' then
    htp.p(''<?';
 v_vc(17) := 'xml version="1.0" encoding="UTF-8"?>
<form name="DEMO_TRIGGERS" version="1">'');     htp.p(''<error>'');     htp.p(''  <errorcode>''||sqlcode||''</errorcode>'');     htp.p(''  <errormessage>''||sqlerrm||''</errormessage>'');     htp.p(''</error>'');     htp.p(''</form>''); else
    htp.p(''{"form":{"@name":"DEMO_TRIGGERS","@version":"1",'' );     htp.p(''"error":{'');     htp.p(''  "errorcode":"''||sqlcode||''",'');     htp.p(''  "errormessage":"''||sqlerrm||''"'');     htp.p(''}'');     htp.p(''}}''); end if;

]]></plsql><plsqlspec><![CDATA[-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = ''XML'' then
    htp.p(''<?xml version="1.0" encoding="UTF-8"?>
<form name="DEMO_TRIGGERS" version="1">'');     htp.p(''<error>'');     htp.p(''  <errorcode>''||sqlcode||''</errorcode>'');     htp.p(''  <errormessage>''||sqlerrm||''</errormessage>'');     htp.p(''</error>'');     htp.p(''</form>''); else
    htp.p(''{"form":{"@name":"DEMO_TRIGGERS","@version":"1",'' );     htp.p(''"error":{'');     htp.p(''  "errorcode":"''||sqlcode||''",'');     htp.p(''  "errormessage":"''||sqlerrm||''"'');     htp.p(''}'');     htp.p(''}}''); end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_INSERT</triggerid><plsql><![CDATA[--Generated INSERT statement. Use (i__) to access fields values.
insert into BONUS (
  ENAME
 ,JOB
 ,SAL
 ,COMM
) values (
  B10ENAME(i__)
 ,B10JOB(i__)
 ,B10SAL(i__)
 ,B10COMM(i__)
);
]]></plsql><plsqlspec><![CDATA[-- Generated INSERT statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = ''I'' then
insert into BONUS (
  ENAME
 ,JOB
 ,SAL
 ,COMM
) values (
  B10ENAME(i__)
 ,B10JOB(i__)
 ,B10SAL(i__)
 ,B10COMM(i__)
);
 MESSAGE := ''Data is changed.'';
end if;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_LOCK</triggerid><plsql><![CDATA[-- Generated code for lock value based on fiels checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.
declare
  v_locking varchar2(4000);
 begin
  select ''U''||'',''||ENAME||'',''||JOB into v_locking
from BONUS
where ROWID = B10RID(i__) for update;
  if B10RS(i__) <> v_locking then
    raise_application_error(''-20002'',''Data has been cha';
 v_vc(18) := 'nged! Refresh data.'');
  end if;
end;


]]></plsql><plsqlspec><![CDATA[-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.
 declare
   v_locking varchar2(4000);
 begin  
  select ''U''||'',''||ENAME||'',''||JOB into v_locking
from BONUS
where ROWID = B10RID(i__) for update;
  if B10RS(i__) <> v_locking then
    raise_application_error(''-20002'',''Data has been changed! Refresh data.'');
  end if;
 end;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_LOCK_VALUE</triggerid><plsql><![CDATA[-- Setting of the locked values. Use (i__) to access fields values.
            B10RS(i__) := B10RS(i__) ||'',''||B10ENAME(i__);
            B10RS(i__) := B10RS(i__) ||'',''||B10JOB(i__);

]]></plsql><plsqlspec><![CDATA[-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.
            B10RS(i__) := B10RS(i__) ||'',''||B10ENAME(i__);
            B10RS(i__) := B10RS(i__) ||'',''||B10JOB(i__);

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_MANDATORY</triggerid><plsql><![CDATA[-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10SAL(i__) is null
 or B10COMM(i__) is null
 then
   raise_application_error(''-20001'',''Mandatory data is missing!'');
 end if;
]]></plsql><plsqlspec><![CDATA[-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10SAL(i__) is null
 or B10COMM(i__) is null
 then 
   raise_application_error(''-20001'',''Mandatory data is missing!'');
 end if;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_NEW_RECORD</triggerid><plsql><![CDATA[-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        
        B10BUTTON := ''Details33'';
        B10BUTTON2 := ''Details233'';
        

]]></plsql><plsqlspec><![CDATA[-- Triggers after setting default values. Use (i__) to access fields values.
]]></plsqlspec><source></source';
 v_vc(19) := '><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_SELECT</triggerid><plsql><![CDATA[-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR
--<SQL formid="27" blockid="B10">
SELECT
 ROWID RID,
ENAME,
JOB,
SAL,
COMM FROM BONUS
--</SQL>
;
]]></plsql><plsqlspec><![CDATA[-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="27" blockid="B10">
SELECT 
 ROWID RID,
ENAME,
JOB,
SAL,
COMM FROM BONUS 
--</SQL>
;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>ON_SUBMIT</triggerid><plsql><![CDATA[-- Reading post variables into fields.
    on_submit(name_array ,value_array);
]]></plsql><plsqlspec><![CDATA[-- Reading post variables into fields.
    on_submit(name_array ,value_array); on_session;
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10INHTML</blockid><triggerid>ON_UI</triggerid><plsql><![CDATA[htp.p(''Code in button: onclick="document.getElementById(''''PAGE_RASD'''').value = ''''2''''; document.getElementById(''''INJOB_RASD'''').value = ''''B10JOB_VALUE''''; submit();"'');
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>BUTTONNEW</blockid><triggerid>ON_UI</triggerid><plsql><![CDATA[htp.p(''ON_UI BUTTON TEXT'');
]]></plsql><plsqlspec><![CDATA[
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>ON_UPDATE</triggerid><plsql><![CDATA[--Generated UPDATE statement. Use (i__) to access fields values.
update BONUS set
  ENAME = B10ENAME(i__)
 ,JOB = B10JOB(i__)
 ,SAL = B10SAL(i__)
 ,COMM = B10COMM(i__)
where ROWID = B10RID(i__);
]]></plsql><plsqlspec><![CDATA[-- Generated UPDATE statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = ''U'' then
update BONUS set
  ENAME = B10ENAME(i__)
 ,JOB = B10JOB(i__)
 ,SAL = B10SAL(i__)
 ,COMM = B10COMM(i__)
where ROWID = B10RID(i__);
 MESSAGE := ''Data is changed.'';
end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></tr';
 v_vc(20) := 'igger><trigger><blockid>B10</blockid><triggerid>ON_VALIDATE</triggerid><plsql><![CDATA[-- Validating field values before DML. Use (i__) to access fields values.
rlog(''B10 ON_VALIDATE'');
]]></plsql><plsqlspec><![CDATA[-- Validating field values before DML. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_ACTION</triggerid><plsql><![CDATA[  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,''GBUTTONSRC'') not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then
    raise_application_error(''-20000'', ''ACTION is not defined. Define it in POST_ACTION trigger.'');
  end if;

]]></plsql><plsqlspec><![CDATA[  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONBCK, GBUTTONFWD, GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then 
    raise_application_error(''-20000'', ''ACTION="''||ACTION||''" is not defined. Define it in POST_ACTION trigger.'');
  end if;

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_COMMIT</triggerid><plsql><![CDATA[-- Triggers after executing DML operations on DB blocks.
rlog(''POST_COMMIT'');
]]></plsql><plsqlspec><![CDATA[-- Triggers after executing DML operations on DB blocks.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>POST_DELETE</triggerid><plsql><![CDATA[-- Triggers after DELETE. Use (i__) to access fields values.
rlog(''B10 POST_DELETE'');
]]></plsql><plsqlspec><![CDATA[-- Triggers after DELETE. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>POST_INSERT</triggerid><plsql><![CDATA[-- Triggers after INSERT. Use (i__) to access fields values.
rlog(''B10 POST_INSERT'');
]]></plsql><plsqlspec><![CDATA[-- Triggers after INSERT. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlo';
 v_vc(21) := 'bid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>POST_SELECT</triggerid><plsql><![CDATA[-- Triggers after executing SQL. Use (i__) to access fields values.
rlog(''B10 POST_SELECT'');
B10BUTTON(i__) := ''Button'';
B10BUTTON2(i__) := ''Button2'';
]]></plsql><plsqlspec><![CDATA[-- Triggers after executing SQL. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_SUBMIT</triggerid><plsql><![CDATA[-- Executing after filling fields on submit.
rlog(''POST_SUBMIT'');
]]></plsql><plsqlspec><![CDATA[-- Executing after filling fields on submit.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>POST_UPDATE</triggerid><plsql><![CDATA[-- Triggers after UPDATE. Use (i__) to access fields values.
rlog(''B10 POST_UPDATE'');
]]></plsql><plsqlspec><![CDATA[-- Triggers after UPDATE. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>PRE_ACTION</triggerid><plsql><![CDATA[
rasd_client.secCheckCredentials(  name_array , value_array ); 

]]></plsql><plsqlspec><![CDATA[  rasd_client.secCheckCredentials(  name_array , value_array ); 

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>PRE_COMMIT</triggerid><plsql><![CDATA[-- Triggers before executing DML operations on DB blocks.
rlog(''PRE_COMMIT'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before executing DML operations on DB blocks.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>PRE_DELETE</triggerid><plsql><![CDATA[-- Triggers before DELETE. Use (i__) to access fields values.
rlog(''B10 PRE_DELETE'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before DELETE. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>PRE_INSERT</triggerid><plsql><![CDATA[-- Triggers b';
 v_vc(22) := 'efore INSERT. Use (i__) to access fields values.
rlog(''B10 PRE_INSERT'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before INSERT. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>PRE_SELECT</triggerid><plsql><![CDATA[-- Triggers before executing SQL. Use (i__) to access fields values.
rlog(''B10 PRE_SELECT'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before executing SQL.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid>B10</blockid><triggerid>PRE_UPDATE</triggerid><plsql><![CDATA[-- Triggers before UPDATE. Use (i__) to access fields values.
rlog(''B10 PRE_UPDATE'');
]]></plsql><plsqlspec><![CDATA[-- Triggers before UPDATE. Use (i__) to access fields values.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger></triggers><elements><element><elementid>1</elementid><pelementid>0</pelementid><orderby>1</orderby><element>HTML_</element><type></type><id>HTML</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>2</elementid><pelementid>1</pelementid><orderby>1</orderby><element>HEAD_</element><type></type><id>HEAD</id><nameid>HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attr';
 v_vc(23) := 'ibute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Trigger test'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>''); %>]]></value><valuecode><![CDATA['');  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Trigger test'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>15</elementid><pelementid>1</pelementid><orderby>1</orderby><element>BODY_</element><type></type><id>BODY</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<body]]></name><value><![C';
 v_vc(24) := 'DATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>16</elementid><pelementid>15</pelementid><orderby>3</orderby><element>FORM_</element><type>F</type><id>DEMO_TRIGGERS</id><nameid>DEMO_TRIGGERS</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_ACTION</attribute><type>A</type><text></text><name><![CDATA[action]]></name><value><![CDATA[!demo_triggers.webclient]]></value><valuecode><![CDATA[="!demo_triggers.webclient"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_METHOD</attribute><type>A</type><text></text><name><![CDATA[method]]></name><value><![CDATA[post]]></value><valuecode><![CDATA[="post"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[DEMO_TRIGGERS]]></value><valuecode><![CDATA[="DEMO_TRIGGERS"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><s';
 v_vc(25) := 'ource></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>17</elementid><pelementid>15</pelementid><orderby>1</orderby><element>FORM_LAB</element><type>F</type><id>DEMO_TRIGGERS_LAB</id><nameid>DEMO_TRIGGERS_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormLab]]></value><valuecode><![CDATA[="rasdFormLab"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_LAB]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Trigger test <%= rasd_client.getHtmlDataTable(''DEMO_TRIGGERS_LAB'') %>     ]]></value><valuecode><![CDATA[Trigger test ''|| rasd_client.getHtmlDataTable(''DEMO_TRIGGERS_LAB'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source><';
 v_vc(26) := '/source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>18</elementid><pelementid>15</pelementid><orderby>2</orderby><element>FORM_MENU</element><type>F</type><id>DEMO_TRIGGERS_MENU</id><nameid>DEMO_TRIGGERS_MENU</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMenu]]></value><valuecode><![CDATA[="rasdFormMenu"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_MENU]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_MENU"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlMenuList(''DEMO_TRIGGERS_MENU'') %>     ]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlMenuList(''DEMO_TRIGGERS_MENU'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid>';
 v_vc(27) := '</valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>19</elementid><pelementid>16</pelementid><orderby>3</orderby><element>FORM_DIV</element><type>F</type><id>DEMO_TRIGGERS_DIV</id><nameid>DEMO_TRIGGERS_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdForm]]></value><valuecode><![CDATA[="rasdForm"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_DIV]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>20</elementid><pelementid>19</pelementid><orderby>1</orderby><element>FORM_HEAD</element><type>F</type><id>DEMO_TRIGGERS_HEAD</id><nameid>DEMO_TRIGGERS_HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attrib';
 v_vc(28) := 'ute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormHead]]></value><valuecode><![CDATA[="rasdFormHead"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_HEAD]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_HEAD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>21</elementid><pelementid>19</pelementid><orderby>2</orderby><element>FORM_BODY</element><type>F</type><id>DEMO_TRIGGERS_BODY</id><nameid>DEMO_TRIGGERS_BODY</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormBody]]></value><valuecode><![CDATA[="rasdFormBody"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_BODY]]></value><valuecode><!';
 v_vc(29) := '[CDATA[="DEMO_TRIGGERS_BODY"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>22</elementid><pelementid>19</pelementid><orderby>9998</orderby><element>FORM_MESSAGE</element><type>F</type><id>DEMO_TRIGGERS_MESSAGE</id><nameid>DEMO_TRIGGERS_MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage]]></value><valuecode><![CDATA[="rasdFormMessage"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_MESSAGE]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_MESSAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn';
 v_vc(30) := '><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>23</elementid><pelementid>19</pelementid><orderby>9996</orderby><element>FORM_ERROR</element><type>F</type><id>DEMO_TRIGGERS_ERROR</id><nameid>DEMO_TRIGGERS_ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage error]]></value><valuecode><![CDATA[="rasdFormMessage error"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_ERROR]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_ERROR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></att';
 v_vc(31) := 'ributes></element><element><elementid>24</elementid><pelementid>19</pelementid><orderby>9997</orderby><element>FORM_WARNING</element><type>F</type><id>DEMO_TRIGGERS_WARNING</id><nameid>DEMO_TRIGGERS_WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage warning]]></value><valuecode><![CDATA[="rasdFormMessage warning"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_WARNING]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_WARNING"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>25</elementid><pelementid>19</pelementid><orderby>9999</orderby><element>FORM_FOOTER</element><type>F</type><id>DEMO_TRIGGERS_FOOTER</id><nameid>DEMO_TRIGGERS_FOOTER</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[';
 v_vc(32) := 'class]]></name><value><![CDATA[rasdFormFooter]]></value><valuecode><![CDATA[="rasdFormFooter"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_TRIGGERS_FOOTER]]></value><valuecode><![CDATA[="DEMO_TRIGGERS_FOOTER"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlFooter(version , substr(''DEMO_TRIGGERS_FOOTER'',1,instr(''DEMO_TRIGGERS_FOOTER'', ''_'',-1)-1) , '''') %>]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlFooter(version , substr(''DEMO_TRIGGERS_FOOTER'',1,instr(''DEMO_TRIGGERS_FOOTER'', ''_'',-1)-1) , '''') ||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>26</elementid><pelementid>21</pelementid><orderby>102</orderby><element>BLOCK_DIV</element><type>B</type><id>B10_DIV</id><nameid>B10_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><at';
 v_vc(33) := 'tribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_DIV]]></value><valuecode><![CDATA[="B10_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB10_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB10_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>27</elementid><pelementid>26</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]><';
 v_vc(34) := '/value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>28</elementid><pelementid>27</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B10_LAB</id><nameid>B10_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_LAB]]></value><valuecode><![CDATA[="B10_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform';
 v_vc(35) := '><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Bonus]]></value><valuecode><![CDATA[Bonus]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>29</elementid><pelementid>26</pelementid><orderby>103</orderby><element>TABLE_N</element><type></type><id>B10_TABLE</id><nameid>B10_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[1]]></value><valuecode><![CDATA[="1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTableN display]]></value><valuecode><![CDATA[="rasdTableN display"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_TABLE_RASD]]></value><valuecode><![CDATA[="B10_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></v';
 v_vc(36) := 'alue><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>30</elementid><pelementid>29</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B10_BLOCK</id><nameid>B10_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_BLOCK_RASD]]></value><valuecode><![CDATA[="B10_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop><![CDATA[''); end loop; 
htp.prn('']]></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop><![CDATA[''); for iB10 in 1..B10RID.count loop 
htp.prn('']]></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>31</elementid><pelementid>29</pelementid><orderby>2</orderby><element>THEAD_</element><type></type><id>B10_THEAD</id><nameid>B10_THEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></h';
 v_vc(37) := 'iddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>1</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</thead]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<thead]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>32</elementid><pelementid>31</pelementid><orderby>2</orderby><element>TR_</element><type></type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>33</elementid><pelementid>32</pelementid><orderby>1</orderby><element>TX_</element><type>E</type><id></id><nameid>B10ENAME_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="';
 v_vc(38) := 'rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10ENAME]]></value><valuecode><![CDATA[="rasdTxLabB10ENAME"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>34</elementid><pelementid>33</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10ENAME_LAB</id><nameid>B10ENAME_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10ENAME_LAB]]></value><valuecode><![CDATA[="B10ENAME_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></text';
 v_vc(39) := 'id><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>35</elementid><pelementid>32</pelementid><orderby>2</orderby><element>TX_</element><type>E</type><id></id><nameid>B10JOB_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10JOB]]></value><valuecode><![CDATA[="rasdTxLabB10JOB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></nam';
 v_vc(40) := 'e><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>36</elementid><pelementid>35</pelementid><orderby>2</orderby><element>FONT_</element><type>L</type><id>B10JOB_LAB</id><nameid>B10JOB_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10JOB_LAB]]></value><valuecode><![CDATA[="B10JOB_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></te';
 v_vc(41) := 'xtcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>37</elementid><pelementid>32</pelementid><orderby>3</orderby><element>TX_</element><type>E</type><id></id><nameid>B10SAL_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10SAL]]></value><valuecode><![CDATA[="rasdTxLabB10SAL"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>38</elementid><pelementid>37</pelementid><orderby>3</orderby><element>FONT_</element><ty';
 v_vc(42) := 'pe>L</type><id>B10SAL_LAB</id><nameid>B10SAL_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10SAL_LAB]]></value><valuecode><![CDATA[="B10SAL_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>39</elementid><pelementid>32</pelementid><orderby>4</orderby><element>TX_</element><type>E</type><id></id><nameid>B10COMM_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby>';
 v_vc(43) := '<attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10COMM]]></value><valuecode><![CDATA[="rasdTxLabB10COMM"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>40</elementid><pelementid>39</pelementid><orderby>4</orderby><element>FONT_</element><type>L</type><id>B10COMM_LAB</id><nameid>B10COMM_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10COMM_LAB]]></value><v';
 v_vc(44) := 'aluecode><![CDATA[="B10COMM_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>41</elementid><pelementid>32</pelementid><orderby>5</orderby><element>TX_</element><type>E</type><id></id><nameid>B10INHTML_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10INHTML]]></value><valuecode><![CDATA[="rasdTxLabB10INHTML"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode';
 v_vc(45) := '><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>42</elementid><pelementid>41</pelementid><orderby>5</orderby><element>FONT_</element><type>L</type><id>B10INHTML_LAB</id><nameid>B10INHTML_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10INHTML_LAB]]></value><valuecode><![CDATA[="B10INHTML_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDA';
 v_vc(46) := 'TA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>43</elementid><pelementid>32</pelementid><orderby>6</orderby><element>TX_</element><type>E</type><id></id><nameid>B10BUTTON_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10BUTTON]]></value><valuecode><![CDATA[="rasdTxLabB10BUTTON"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode';
 v_vc(47) := '><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>44</elementid><pelementid>43</pelementid><orderby>6</orderby><element>FONT_</element><type>L</type><id>B10BUTTON_LAB</id><nameid>B10BUTTON_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10BUTTON_LAB]]></value><valuecode><![CDATA[="B10BUTTON_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>45</elementid><pelementid>32</pelementid><orderby>7</orderby><element>TX_</element><type>E</type><id></id><nameid>B10BUTTON';
 v_vc(48) := '2_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10BUTTON2]]></value><valuecode><![CDATA[="rasdTxLabB10BUTTON2"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>46</elementid><pelementid>45</pelementid><orderby>7</orderby><element>FONT_</element><type>L</type><id>B10BUTTON2_LAB</id><nameid>B10BUTTON2_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></te';
 v_vc(49) := 'xtcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10BUTTON2_LAB]]></value><valuecode><![CDATA[="B10BUTTON2_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>47</elementid><pelementid>21</pelementid><orderby>112</orderby><element>BLOCK_DIV</element><type>B</type><id>B20_DIV</id><nameid>B20_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20_DIV]]></value><valuecode';
 v_vc(50) := '><![CDATA[="B20_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB20_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB20_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>48</elementid><pelementid>47</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid><';
 v_vc(51) := '/valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>49</elementid><pelementid>48</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B20_LAB</id><nameid>B20_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20_LAB]]></value><valuecode><![CDATA[="B20_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Employe]]><';
 v_vc(52) := '/value><valuecode><![CDATA[Employe]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>50</elementid><pelementid>47</pelementid><orderby>113</orderby><element>TABLE_N</element><type></type><id>B20_TABLE</id><nameid>B20_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[1]]></value><valuecode><![CDATA[="1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTableN display]]></value><valuecode><![CDATA[="rasdTableN display"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20_TABLE_RASD]]></value><valuecode><![CDATA[="B20_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><tex';
 v_vc(53) := 'tid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>51</elementid><pelementid>50</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B20_BLOCK</id><nameid>B20_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20_BLOCK_RASD]]></value><valuecode><![CDATA[="B20_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop><![CDATA[''); end loop; 
htp.prn('']]></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop><![CDATA[''); for iB20 in 1..B20RID.count loop 
htp.prn('']]></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>52</elementid><pelementid>50</pelementid><orderby>2</orderby><element>THEAD_</element><type></type><id>B20_THEAD</id><nameid>B20_THEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>1</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</thead]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attrib';
 v_vc(54) := 'ute><type>S</type><text></text><name><![CDATA[<thead]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>53</elementid><pelementid>52</pelementid><orderby>2</orderby><element>TR_</element><type></type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>54</elementid><pelementid>53</pelementid><orderby>1</orderby><element>TX_</element><type>E</type><id></id><nameid>B20EMPNO_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20EMPNO]]></value><valuecode><![CDATA[="rasdTxLabB20EMPNO"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>';
 v_vc(55) := 'N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>55</elementid><pelementid>54</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B20EMPNO_LAB</id><nameid>B20EMPNO_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20EMPNO_LAB]]></value><valuecode><![CDATA[="B20EMPNO_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>';
 v_vc(56) := 'S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>56</elementid><pelementid>53</pelementid><orderby>2</orderby><element>TX_</element><type>E</type><id></id><nameid>B20ENAME_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20ENAME]]></value><valuecode><![CDATA[="rasdTxLabB20ENAME"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hidd';
 v_vc(57) := 'enyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>57</elementid><pelementid>56</pelementid><orderby>2</orderby><element>FONT_</element><type>L</type><id>B20ENAME_LAB</id><nameid>B20ENAME_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20ENAME_LAB]]></value><valuecode><![CDATA[="B20ENAME_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>58</elementid><pelementid>53</pelementid><orderby>3</orderby><elem';
 v_vc(58) := 'ent>TX_</element><type>E</type><id></id><nameid>B20JOB_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20JOB]]></value><valuecode><![CDATA[="rasdTxLabB20JOB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>59</elementid><pelementid>58</pelementid><orderby>3</orderby><element>FONT_</element><type>L</type><id>B20JOB_LAB</id><nameid>B20JOB_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></va';
 v_vc(59) := 'lueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20JOB_LAB]]></value><valuecode><![CDATA[="B20JOB_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>60</elementid><pelementid>53</pelementid><orderby>4</orderby><element>TX_</element><type>E</type><id></id><nameid>B20MGR_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[';
 v_vc(60) := 'id]]></name><value><![CDATA[rasdTxLabB20MGR]]></value><valuecode><![CDATA[="rasdTxLabB20MGR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>61</elementid><pelementid>60</pelementid><orderby>4</orderby><element>FONT_</element><type>L</type><id>B20MGR_LAB</id><nameid>B20MGR_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20MGR_LAB]]></value><valuecode><![CDATA[="B20MGR_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid><';
 v_vc(61) := '/valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>62</elementid><pelementid>53</pelementid><orderby>5</orderby><element>TX_</element><type>E</type><id></id><nameid>B20HIREDATE_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20HIREDATE]]></value><valuecode><![CDATA[="rasdTxLabB20HIREDATE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><tex';
 v_vc(62) := 't></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>63</elementid><pelementid>62</pelementid><orderby>5</orderby><element>FONT_</element><type>L</type><id>B20HIREDATE_LAB</id><nameid>B20HIREDATE_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20HIREDATE_LAB]]></value><valuecode><![CDATA[="B20HIREDATE_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid>';
 v_vc(63) := '<textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>64</elementid><pelementid>53</pelementid><orderby>6</orderby><element>TX_</element><type>E</type><id></id><nameid>B20SAL_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20SAL]]></value><valuecode><![CDATA[="rasdTxLabB20SAL"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>65</elementid><pelementid>64</pelementid><orderby>6</orderby><element>FONT_</element><type>L</type><id>B20SAL_LAB</id><nameid>B20SAL_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![C';
 v_vc(64) := 'DATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20SAL_LAB]]></value><valuecode><![CDATA[="B20SAL_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>66</elementid><pelementid>53</pelementid><orderby>7</orderby><element>TX_</element><type>E</type><id></id><nameid>B20COMM_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid';
 v_vc(65) := '></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20COMM]]></value><valuecode><![CDATA[="rasdTxLabB20COMM"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>67</elementid><pelementid>66</pelementid><orderby>7</orderby><element>FONT_</element><type>L</type><id>B20COMM_LAB</id><nameid>B20COMM_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20COMM_LAB]]></value><valuecode><![CDATA[="B20COMM_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><te';
 v_vc(66) := 'xt></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>68</elementid><pelementid>53</pelementid><orderby>8</orderby><element>TX_</element><type>E</type><id></id><nameid>B20DEPTNO_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20DEPTNO]]></value><valuecode><![CDATA[="rasdTxLabB20DEPTNO"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn>';
 v_vc(67) := '<valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>69</elementid><pelementid>68</pelementid><orderby>8</orderby><element>FONT_</element><type>L</type><id>B20DEPTNO_LAB</id><nameid>B20DEPTNO_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20DEPTNO_LAB]]></value><valuecode><![CDATA[="B20DEPTNO_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type';
 v_vc(68) := '><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>70</elementid><pelementid>53</pelementid><orderby>9</orderby><element>TX_</element><type>E</type><id></id><nameid>B20NOTE_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB20]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB20NOTE]]></value><valuecode><![CDATA[="rasdTxLabB20NOTE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>71</elementid><pelementid>70</pelementid><orderby>9</orderby><element>FONT_</element><type>L</type><id>B20NOTE_LAB</id><nameid>B20NOTE_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hidd';
 v_vc(69) := 'enyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20NOTE_LAB]]></value><valuecode><![CDATA[="B20NOTE_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>72</elementid><pelementid>21</pelementid><orderby>122</orderby><element>BLOCK_DIV</element><type>B</type><id>B30_DIV</id><nameid>B30_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]><';
 v_vc(70) := '/value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30_DIV]]></value><valuecode><![CDATA[="B30_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB30_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB30_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>73</elementid><pelementid>72</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hi';
 v_vc(71) := 'ddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>74</elementid><pelementid>73</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B30_LAB</id><nameid>B30_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30_LAB]]></value><valuecode><![CDATA[="B30_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name>';
 v_vc(72) := '<![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Jobs]]></value><valuecode><![CDATA[Jobs]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>75</elementid><pelementid>72</pelementid><orderby>123</orderby><element>TABLE_</element><type></type><id>B30_TABLE</id><nameid>B30_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30_TABLE_RASD]]></value><valuecode><![CDATA[="B30_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid';
 v_vc(73) := '></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>76</elementid><pelementid>75</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B30_BLOCK</id><nameid>B30_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30_BLOCK_RASD]]></value><valuecode><![CDATA[="B30_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>77</elementid><pelementid>75</pelementid><orderby>2</orderby><element>THEAD_</element><type></type><id>B30_THEAD</id><nameid>B30_THEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>1</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</thead]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<thead]]></name><value><![CDATA[>]]></v';
 v_vc(74) := 'alue><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>78</elementid><pelementid>77</pelementid><orderby>2</orderby><element>TR_</element><type></type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>79</elementid><pelementid>78</pelementid><orderby>1</orderby><element>TX_</element><type>E</type><id></id><nameid>B30JOB_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB30]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB30"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB30JOB]]></value><valuecode><![CDATA[="rasdTxLabB30JOB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rfor';
 v_vc(75) := 'm></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>80</elementid><pelementid>79</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B30JOB_LAB</id><nameid>B30JOB_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30JOB_LAB]]></value><valuecode><![CDATA[="B30JOB_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[';
 v_vc(76) := '>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Job]]></value><valuecode><![CDATA[Job]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>81</elementid><pelementid>78</pelementid><orderby>2</orderby><element>TX_</element><type>E</type><id></id><nameid>B30DESCRIPTION_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB30]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB30"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB30DESCRIPTION]]></value><valuecode><![CDATA[="rasdTxLabB30DESCRIPTION"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode>';
 v_vc(77) := '</textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>82</elementid><pelementid>81</pelementid><orderby>2</orderby><element>FONT_</element><type>L</type><id>B30DESCRIPTION_LAB</id><nameid>B30DESCRIPTION_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30DESCRIPTION_LAB]]></value><valuecode><![CDATA[="B30DESCRIPTION_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Description]]></value><valuecode><![CDATA[Description]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>83</elementid><pelementid>20</pelementid><order';
 v_vc(78) := 'by>-1109</orderby><element>INPUT_HIDDEN</element><type>D</type><id>RECNUMB30</id><nameid>RECNUMB30</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[RECNUMB30_NAME_RASD]]></value><valuecode><![CDATA[="RECNUMB30_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[RECNUMB30_NAME]]></value><valuecode><![CDATA[="RECNUMB30"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></';
 v_vc(79) := 'textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[RECNUMB30_VALUE]]></value><valuecode><![CDATA[="''||RECNUMB30||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>84</elementid><pelementid>20</pelementid><orderby>-109</orderby><element>INPUT_HIDDEN</element><type>D</type><id>RECNUMB20</id><nameid>RECNUMB20</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]';
 v_vc(80) := ']></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[RECNUMB20_NAME_RASD]]></value><valuecode><![CDATA[="RECNUMB20_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[RECNUMB20_NAME]]></value><valuecode><![CDATA[="RECNUMB20"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[RECNUMB20_VALUE]]></value><valuecode><![CDATA[="''||RECNUMB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hidde';
 v_vc(81) := 'nyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>85</elementid><pelementid>20</pelementid><orderby>-9</orderby><element>INPUT_HIDDEN</element><type>D</type><id>RECNUMB10</id><nameid>RECNUMB10</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[RECNUMB10_NAME_RASD]]></value><valuecode><![CDATA[="RECNUMB10_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><v';
 v_vc(82) := 'alue><![CDATA[RECNUMB10_NAME]]></value><valuecode><![CDATA[="RECNUMB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[RECNUMB10_VALUE]]></value><valuecode><![CDATA[="''||RECNUMB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode';
 v_vc(83) := '><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>86</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>ACTION</id><nameid>ACTION</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ACTION_NAME_RASD]]></value><valuecode><![CDATA[="ACTION_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[ACTION_NAME]]></value><valuecode><![CDATA[="ACTION"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valu';
 v_vc(84) := 'ecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[ACTION_VALUE]]></value><valuecode><![CDATA[="''||ACTION||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>87</elementid><pelementid>20</pelementid><orderby>-1</orderby><element>INPUT_TEXT</element><type>D</type><id>INJOB</id><nameid>INJOB</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attri';
 v_vc(85) := 'bute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[INJOB_NAME_RASD]]></value><valuecode><![CDATA[="INJOB_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[INJOB_NAME]]></value><valuecode><![CDATA[="INJOB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop';
 v_vc(86) := '></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[INJOB_VALUE]]></value><valuecode><![CDATA[="''||INJOB||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldINJOB  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>88</elementid><pelementid>20</pelementid><orderby>0</orderby><element>INPUT_TEXT</element><type>D</type><id>PAGE</id><nameid>PAGE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute';
 v_vc(87) := '><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PAGE_NAME_RASD]]></value><valuecode><![CDATA[="PAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[PAGE_NAME]]></value><valuecode><![CDATA[="PAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[PAGE_VALUE]]></value><valuecode><![C';
 v_vc(88) := 'DATA[="''||ltrim(to_char(PAGE))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldPAGE  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>89</elementid><pelementid>22</pelementid><orderby>9998</orderby><element>FONT_</element><type>D</type><id>MESSAGE</id><nameid>MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[MESSAGE_NAME_RASD]]></value><valuecode><![CDATA[="MESSAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></tex';
 v_vc(89) := 'tcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hid';
 v_vc(90) := 'denyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[MESSAGE_VALUE]]></value><valuecode><![CDATA[''||MESSAGE||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>90</elementid><pelementid>23</pelementid><orderby>9996</orderby><element>FONT_</element><type>D</type><id>ERROR</id><nameid>ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ERROR_NAME_RASD]]></value><valuecode><![CDATA[="ERROR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name>';
 v_vc(91) := '<![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[ERROR_VALUE]]></value><valuecode><![CDATA[''||ERROR||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute>';
 v_vc(92) := '</attributes></element><element><elementid>91</elementid><pelementid>24</pelementid><orderby>9997</orderby><element>FONT_</element><type>D</type><id>WARNING</id><nameid>WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[WARNING_NAME_RASD]]></value><valuecode><![CDATA[="WARNING_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn>';
 v_vc(93) := '<valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[WARNING_VALUE]]></value><valuecode><![CDATA[''||WARNING||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>92</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONCLR</id><nameid>GBUTTONCLR</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton';
 v_vc(94) := ']]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONCLR_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONCLR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONCLR_NAME]]></value><valuecode><![CDATA[="GBUTTONCLR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop>';
 v_vc(95) := '<endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONCLR_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONCLR||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONCLR  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>93</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONCLR</id><nameid>GBUTTONCLR</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform';
 v_vc(96) := '><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONCLR_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONCLR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONCLR_NAME]]></value><valuecode><![CDATA[="GBUTTONCLR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONCLR_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONCLR||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></att';
 v_vc(97) := 'ribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONCLR  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>94</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONFWD</id><nameid>GBUTTONFWD</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONFWD_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONFWD_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONFWD_NA';
 v_vc(98) := 'ME]]></value><valuecode><![CDATA[="GBUTTONFWD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONFWD_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONFWD||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONFWD  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]>';
 v_vc(99) := '</valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>95</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONFWD</id><nameid>GBUTTONFWD</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONFWD_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONFWD_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONFWD_NAME]]></value><valuecode><![CDATA[="GBUTTONFWD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hidd';
 v_vc(100) := 'enyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONFWD_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONFWD||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONFWD  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>96</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONBCK</id><nameid>GBUTTONBCK</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderb';
 v_vc(101) := 'y>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONBCK_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONBCK_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONBCK_NAME]]></value><valuecode><![CDATA[="GBUTTONBCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text';
 v_vc(102) := '><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONBCK_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONBCK||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONBCK  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>97</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONBCK</id><nameid>GBUTTONBCK</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><';
 v_vc(103) := 'source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONBCK_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONBCK_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONBCK_NAME]]></value><valuecode><![CDATA[="GBUTTONBCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONBCK_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONBCK||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><';
 v_vc(104) := 'hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONBCK  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>98</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSAVE</id><nameid>GBUTTONSAVE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSAVE_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSAVE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><ord';
 v_vc(105) := 'erby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSAVE_NAME]]></value><valuecode><![CDATA[="GBUTTONSAVE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSAVE_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSAVE||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
i';
 v_vc(106) := 'f  ShowFieldGBUTTONSAVE  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>99</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSAVE</id><nameid>GBUTTONSAVE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSAVE_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSAVE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSAVE_NAME]]></value><valuecode><![CDATA[="GBUTTONSAVE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]>';
 v_vc(107) := '</value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSAVE_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSAVE||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>100</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_RESET</element><type>D</type><id>GBUTTONRES</id><nameid>GBUTTONRES</nameid><endtagelementid></endtagel';
 v_vc(108) := 'ementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONRES_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONRES_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONRES_NAME]]></value><valuecode><![CDATA[="GBUTTONRES"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribu';
 v_vc(109) := 'te>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[reset]]></value><valuecode><![CDATA[="reset"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONRES_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONRES||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONRES  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>101</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_RESET</element><type>D</type><id>GBUTTONRES</id><nameid>GBUTTONRES</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valu';
 v_vc(110) := 'ecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONRES_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONRES_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONRES_NAME]]></value><valuecode><![CDATA[="GBUTTONRES"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[reset]]></value><valuecode><![CDATA[="reset"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONRES_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONRES||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></text';
 v_vc(111) := 'id><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONRES  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>102</elementid><pelementid>20</pelementid><orderby>1</orderby><element>PLSQL_</element><type>D</type><id>BUTTONNEW</id><nameid>BUTTONNEW</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[BUTTONNEW_NAME_RASD]]></value><valuecode><![CDATA[="BUTTONNEW_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldBUTTONNEW  then  
htp.prn(''<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><';
 v_vc(112) := 'orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% BUTTONNEW_VALUE %>]]></value><valuecode><![CDATA['');  htp.p(''ON_UI BUTTON TEXT'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>103</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>PLSQL_</element><type>D</type><id>BUTTONNEW</id><nameid>BUTTONNEW</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[BUTTONNEW_NAME_RASD]]></value><valuecode><![CDATA[="BUTTONNEW_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldBUTTONNEW  then  
htp.prn(''<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% BUTTONNEW_VALUE %>]]></value><valuecode><![CDATA['');  htp.p(''ON_UI BUTTON TEXT'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><eleme';
 v_vc(113) := 'ntid>104</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSRC</id><nameid>GBUTTONSRC</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSRC_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSRC_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSRC_NAME]]></value><valuecode><![CDATA[="GBUTTONSRC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDB';
 v_vc(114) := 'LCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSRC_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSRC||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONSRC  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>105</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSRC</id><nameid>GBUTTONSRC</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></sour';
 v_vc(115) := 'ce><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSRC_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSRC_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSRC_NAME]]></value><valuecode><![CDATA[="GBUTTONSRC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textc';
 v_vc(116) := 'ode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSRC_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSRC||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONSRC  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>106</elementid><pelementid>30</pelementid><orderby>1</orderby><element>HIDDFIELD_</element><type></type><id></id><nameid>B10</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[hiddenRowItems]]></value><valuecode><![CDATA[="hiddenRowItems"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_NAME</attribute><type>A</t';
 v_vc(117) := 'ype><text></text><name><![CDATA[name]]></name><value><![CDATA[B10_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[<%=iB10%>]]></value><valuecode><![CDATA[="''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>107</elementid><pelementid>106</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B10RS</id><nameid>B10RS</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></val';
 v_vc(118) := 'ueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10RS_NAME_RASD]]></value><valuecode><![CDATA[="B10RS_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10RS_NAME]]></value><valuecode><![CDATA[="B10RS_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10RS_VALUE]]></value><valuecode><![CDATA[="''||B10RS(iB10)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderb';
 v_vc(119) := 'y>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>108</elementid><pelementid>106</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B10RID</id><nameid>B10RID</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10RID_NAME_RASD]]></value><valuecode><![CDATA[="B10RID_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10RID_NAME]]></value><valuecode><![CDATA[="B10RID_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><sour';
 v_vc(120) := 'ce></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10RID_VALUE]]></value><valuecode><![CDATA[="''||to_char(B10RID(iB10))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>109</elementid><pelem';
 v_vc(121) := 'entid>30</pelementid><orderby>24</orderby><element>TX_</element><type>E</type><id></id><nameid>B10ENAME_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10ENAME rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10ENAME rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10ENAME_NAME]]></value><valuecode><![CDATA[="rasdTxB10ENAME_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>110</elementid><pelementid>109</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B10ENAME</id><nameid>B10ENAME</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><end';
 v_vc(122) := 'loop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10ENAME_NAME_RASD]]></value><valuecode><![CDATA[="B10ENAME_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10ENAME_NAME]]></value><valuecode><![CDATA[="B10ENAME_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><a';
 v_vc(123) := 'ttribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10ENAME_VALUE]]></value><valuecode><![CDATA[="''||B10ENAME(iB10)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>111</elementid><pelementid>30</pelementid><orderby>28</orderby><element>TX_</element><type>E</type><id></id><nameid>B10JOB_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10JOB rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10JOB rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10JOB_NAME]]></value><valuecode><![CDAT';
 v_vc(124) := 'A[="rasdTxB10JOB_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>112</elementid><pelementid>111</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B10JOB</id><nameid>B10JOB</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10JOB_NAME_RASD]]></value><valuecode><![CDATA[="B10JOB_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid>';
 v_vc(125) := '<rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10JOB_NAME]]></value><valuecode><![CDATA[="B10JOB_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value><![CDATA[lov2]]></value><valuecode><![CDATA[="''); js_lov2(B10JOB(iB10),''B10JOB_''||iB10||''''); 
htp.prn(''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10JOB_VALUE]]></value><valuecode><![CDATA[="''||B10JOB(iB10)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><order';
 v_vc(126) := 'by>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>113</elementid><pelementid>30</pelementid><orderby>32</orderby><element>TX_</element><type>E</type><id></id><nameid>B10SAL_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10SAL rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB10SAL rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10SAL_NAME]]></value><valuecode><![CDATA[="rasdTxB10SAL_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop';
 v_vc(127) := '></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>114</elementid><pelementid>113</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B10SAL</id><nameid>B10SAL</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10SAL_NAME_RASD]]></value><valuecode><![CDATA[="B10SAL_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10SAL_NAME]]></value><valuecode><![CDATA[="B10SAL_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><or';
 v_vc(128) := 'derby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10SAL_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(B10SAL(iB10)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>115</elementid><pelementid>30</pelementid><orderby>36</orderby><element>TX_</element><type>E</type><id></id><nameid>B10COMM_TX</nameid><endtagelementid>';
 v_vc(129) := '0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10COMM rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB10COMM rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10COMM_NAME]]></value><valuecode><![CDATA[="rasdTxB10COMM_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>116</elementid><pelementid>115</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B10COMM</id><nameid>B10COMM</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></r';
 v_vc(130) := 'form><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10COMM_NAME_RASD]]></value><valuecode><![CDATA[="B10COMM_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10COMM_NAME]]></value><valuecode><![CDATA[="B10COMM_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></val';
 v_vc(131) := 'ue><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10COMM_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(B10COMM(iB10)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>117</elementid><pelementid>30</pelementid><orderby>38</orderby><element>TX_</element><type>E</type><id></id><nameid>B10INHTML_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10INHTML rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10INHTML rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10INHTML_NAME]]></value><valuecode><![CDATA[="rasdTxB10INHTML_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hi';
 v_vc(132) := 'ddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>118</elementid><pelementid>117</pelementid><orderby>1</orderby><element>PLSQL_</element><type>D</type><id>B10INHTML</id><nameid>B10INHTML</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10INHTML_NAME_RASD]]></value><valuecode><![CDATA[="B10INHTML_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V<';
 v_vc(133) := '/type><text></text><name></name><value><![CDATA[<% B10INHTML_VALUE %>]]></value><valuecode><![CDATA['');  htp.p(''Code in button: onclick="document.getElementById(''''PAGE_RASD'''').value = ''''2''''; document.getElementById(''''INJOB_RASD'''').value = ''''B10JOB_VALUE''''; submit();"'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>119</elementid><pelementid>30</pelementid><orderby>40</orderby><element>TX_</element><type>E</type><id></id><nameid>B10BUTTON_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10BUTTON rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10BUTTON rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10BUTTON_NAME]]></value><valuecode><![CDATA[="rasdTxB10BUTTON_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes>';
 v_vc(134) := '</element><element><elementid>120</elementid><pelementid>119</pelementid><orderby>1</orderby><element>INPUT_BUTTON</element><type>D</type><id>B10BUTTON</id><nameid>B10BUTTON</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10BUTTON_NAME_RASD]]></value><valuecode><![CDATA[="B10BUTTON_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10BUTTON_NAME]]></value><valuecode><![CDATA[="B10BUTTON_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[document.getElementById(''''PAGE_RASD'''').value = ''''2''''; document.getElementById(''''INJOB_RASD'''').value = ''''B10JOB_VALUE''''; submit();]]></value><valuecode><![CDATA[="document.getElementById(''''PAGE_RASD'''').value = ''''2''''; document.getElementById(''''INJOB_RASD'''').value = ''''''||B10JOB(iB10)||''''''; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source>V</source><hiddenyn';
 v_vc(135) := '>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10BUTTON_VALUE]]></value><valuecode><![CDATA[="''||B10BUTTON(iB10)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>121</elementid><pelementid>30</pelementid><orderby>44</orderby><element>TX_</element><type>E</type><id></id><nameid>B10BUTTON2_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA';
 v_vc(136) := '[class]]></name><value><![CDATA[rasdTxB10BUTTON2 rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10BUTTON2 rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10BUTTON2_NAME]]></value><valuecode><![CDATA[="rasdTxB10BUTTON2_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>122</elementid><pelementid>121</pelementid><orderby>1</orderby><element>INPUT_BUTTON</element><type>D</type><id>B10BUTTON2</id><nameid>B10BUTTON2</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endlo';
 v_vc(137) := 'op><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10BUTTON2_NAME_RASD]]></value><valuecode><![CDATA[="B10BUTTON2_''||iB10||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10BUTTON2_NAME]]></value><valuecode><![CDATA[="B10BUTTON2_''||iB10||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[button2link]]></value><valuecode><![CDATA[="javascript: location=encodeURI(''); js_button2link(B10BUTTON2(iB10),''B10BUTTON2_''||iB10||''''); 
htp.prn('');"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10BUTTON2_VALUE]]></value><valuecode><![CDATA[="''||B10BUTTON2(iB';
 v_vc(138) := '10)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>123</elementid><pelementid>51</pelementid><orderby>1</orderby><element>HIDDFIELD_</element><type></type><id></id><nameid>B20</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[hiddenRowItems]]></value><valuecode><![CDATA[="hiddenRowItems"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orde';
 v_vc(139) := 'rby>3</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[<%=iB20%>]]></value><valuecode><![CDATA[="''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>124</elementid><pelementid>123</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B20RID</id><nameid>B20RID</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20RID_NAME_RASD]]></value><valuecode><![CDATA[="B20RID_''||iB20||''_RASD"]]></valuecode><forloop';
 v_vc(140) := '></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20RID_NAME]]></value><valuecode><![CDATA[="B20RID_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20RID_VALUE]]></value><valuecode><![CDATA[="''||to_char(B20RID(iB20))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute>';
 v_vc(141) := '<attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>125</elementid><pelementid>123</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B20RS</id><nameid>B20RS</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20RS_NAME_RASD]]></value><valuecode><![CDATA[="B20RS_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20RS_NAME]]></value><valuecode><![CDATA[="B20RS_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forlo';
 v_vc(142) := 'op></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20RS_VALUE]]></value><valuecode><![CDATA[="''||B20RS(iB20)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>126</elementid><pelementid>51</pelementid><orderby>224</orderby><element>TX_</element><type>E</type><id></id><nameid>B20EMPNO_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</at';
 v_vc(143) := 'tribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20EMPNO rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB20EMPNO rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20EMPNO_NAME]]></value><valuecode><![CDATA[="rasdTxB20EMPNO_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>127</elementid><pelementid>126</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20EMPNO</id><nameid>B20EMPNO</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><f';
 v_vc(144) := 'orloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20EMPNO_NAME_RASD]]></value><valuecode><![CDATA[="B20EMPNO_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20EMPNO_NAME]]></value><valuecode><![CDATA[="B20EMPNO_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><';
 v_vc(145) := 'rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20EMPNO_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(B20EMPNO(iB20)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>128</elementid><pelementid>51</pelementid><orderby>228</orderby><element>TX_</element><type>E</type><id></id><nameid>B20ENAME_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20ENAME rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB20ENAME rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20ENAME_NAME]]></value><valuecode><![CDATA[="rasdTxB20ENAME_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E';
 v_vc(146) := '</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>129</elementid><pelementid>128</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20ENAME</id><nameid>B20ENAME</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20ENAME_NAME_RASD]]></value><valuecode><![CDATA[="B20ENAME_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20ENAME_NAME]]></value><valuecode><![CDATA[="B20ENAME_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloo';
 v_vc(147) := 'p><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20ENAME_VALUE]]></value><valuecode><![CDATA[="''||B20ENAME(iB20)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><typ';
 v_vc(148) := 'e>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>130</elementid><pelementid>51</pelementid><orderby>232</orderby><element>TX_</element><type>E</type><id></id><nameid>B20JOB_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20JOB rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB20JOB rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20JOB_NAME]]></value><valuecode><![CDATA[="rasdTxB20JOB_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>131</elementid><pelementid>130</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20JOB</id><nameid>B20JOB</nameid><endtagelementid>';
 v_vc(149) := '</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20JOB_NAME_RASD]]></value><valuecode><![CDATA[="B20JOB_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20JOB_NAME]]></value><valuecode><![CDATA[="B20JOB_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</o';
 v_vc(150) := 'rderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20JOB_VALUE]]></value><valuecode><![CDATA[="''||B20JOB(iB20)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>132</elementid><pelementid>51</pelementid><orderby>236</orderby><element>TX_</element><type>E</type><id></id><nameid>B20MGR_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20MGR rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB20MGR rasdTxTypeN"]]></valuecode><forloop></for';
 v_vc(151) := 'loop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20MGR_NAME]]></value><valuecode><![CDATA[="rasdTxB20MGR_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>133</elementid><pelementid>132</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20MGR</id><nameid>B20MGR</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><order';
 v_vc(152) := 'by>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20MGR_NAME_RASD]]></value><valuecode><![CDATA[="B20MGR_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20MGR_NAME]]></value><valuecode><![CDATA[="B20MGR_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20MGR_VALUE]]></value><';
 v_vc(153) := 'valuecode><![CDATA[="''||ltrim(to_char(B20MGR(iB20)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>134</elementid><pelementid>51</pelementid><orderby>240</orderby><element>TX_</element><type>E</type><id></id><nameid>B20HIREDATE_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20HIREDATE rasdTxTypeD]]></value><valuecode><![CDATA[="rasdTxB20HIREDATE rasdTxTypeD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20HIREDATE_NAME]]></value><valuecode><![CDATA[="rasdTxB20HIREDATE_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></';
 v_vc(154) := 'valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>135</elementid><pelementid>134</pelementid><orderby>1</orderby><element>INPUT_TEXTD</element><type>D</type><id>B20HIREDATE</id><nameid>B20HIREDATE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>7</orderby><attribute>A_AUTOCOMPLETE</attribute><type>A</type><text></text><name><![CDATA[autocomplete]]></name><value><![CDATA[off]]></value><valuecode><![CDATA[="off"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20HIREDATE_NAME_RASD]]></value><valuecode><![CDATA[="B20HIREDATE_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><att';
 v_vc(155) := 'ribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlDatePicker(''B20HIREDATE_NAME'', '''') %> 
<input id="B20HIREDATE_NAME" name="B20HIREDATE_NAME" type="text" value="B20HIREDATE_VALUE" class="rasdTextD" autocomplete="off" />]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlDatePicker(''B20HIREDATE_''||iB20||'''', '''') ||'' 
<input id="B20HIREDATE_''||iB20||''" name="B20HIREDATE_''||iB20||''" type="text" value="''||to_char(B20HIREDATE(iB20),rasd_client.C_DATE_FORMAT)||''" class="rasdTextD" autocomplete="off" />]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>136</elementid><pelementid>51</pelementid><orderby>244</orderby><element>TX_</element><type>E</type><id></id><nameid>B20SAL_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20SAL rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB20SAL rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20SAL_NAME]]></value><valuecode><![CDATA[="rasdTxB20SAL_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value>';
 v_vc(156) := '<![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>137</elementid><pelementid>136</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20SAL</id><nameid>B20SAL</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20SAL_NAME_RASD]]></value><valuecode><![CDATA[="B20SAL_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20SAL_NAME]]></value><valuecode><![CDATA[="B20SAL_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid>';
 v_vc(157) := '</textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20SAL_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(B20SAL(iB20)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><v';
 v_vc(158) := 'alue><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>138</elementid><pelementid>51</pelementid><orderby>248</orderby><element>TX_</element><type>E</type><id></id><nameid>B20COMM_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20COMM rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB20COMM rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20COMM_NAME]]></value><valuecode><![CDATA[="rasdTxB20COMM_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>139</elementid><pelementid>138</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20COMM</id><nameid>B20COMM</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hi';
 v_vc(159) := 'ddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20COMM_NAME_RASD]]></value><valuecode><![CDATA[="B20COMM_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20COMM_NAME]]></value><valuecode><![CDATA[="B20COMM_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</';
 v_vc(160) := 'type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20COMM_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(B20COMM(iB20)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>140</elementid><pelementid>51</pelementid><orderby>252</orderby><element>TX_</element><type>E</type><id></id><nameid>B20DEPTNO_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20DEPTNO rasdTxTypeN]]></value><valuecode><![CDATA[="rasdTxB20DEPTNO rasdTxTypeN"]]></valuecode><forloop></forloop><endloop></en';
 v_vc(161) := 'dloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20DEPTNO_NAME]]></value><valuecode><![CDATA[="rasdTxB20DEPTNO_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>141</elementid><pelementid>140</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20DEPTNO</id><nameid>B20DEPTNO</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextN]]></value><valuecode><![CDATA[="rasdTextN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</';
 v_vc(162) := 'orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20DEPTNO_NAME_RASD]]></value><valuecode><![CDATA[="B20DEPTNO_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20DEPTNO_NAME]]></value><valuecode><![CDATA[="B20DEPTNO_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20DEPTNO_VALUE]]>';
 v_vc(163) := '</value><valuecode><![CDATA[="''||ltrim(to_char(B20DEPTNO(iB20)))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>142</elementid><pelementid>51</pelementid><orderby>256</orderby><element>TX_</element><type>E</type><id></id><nameid>B20NOTE_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB20NOTE rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB20NOTE rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB20NOTE_NAME]]></value><valuecode><![CDATA[="rasdTxB20NOTE_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid>';
 v_vc(164) := '<textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>143</elementid><pelementid>142</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B20NOTE</id><nameid>B20NOTE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B20NOTE_NAME_RASD]]></value><valuecode><![CDATA[="B20NOTE_''||iB20||''_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B20NOTE_NAME]]></value><valuecode><![CDATA[="B20NOTE_''||iB20||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute';
 v_vc(165) := '><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B20NOTE_VALUE]]></value><valuecode><![CDATA[="''||B20NOTE(iB20)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><';
 v_vc(166) := 'textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>144</elementid><pelementid>76</pelementid><orderby>1</orderby><element>HIDDFIELD_</element><type></type><id></id><nameid>B30</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[hiddenRowItems]]></value><valuecode><![CDATA[="hiddenRowItems"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B30_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[1]]></value><valuecode><![CDATA[="1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><nam';
 v_vc(167) := 'e><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>145</elementid><pelementid>144</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B30RID</id><nameid>B30RID</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30RID_NAME_RASD]]></value><valuecode><![CDATA[="B30RID_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B30RID_NAME]]></value><valuecode><![CDATA[="B30RID_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></te';
 v_vc(168) := 'xtid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B30RID_VALUE]]></value><valuecode><![CDATA[="''||to_char(B30RID(1))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>146</elementid><pelementid>144</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B30RS</id><nameid>B30RS</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]';
 v_vc(169) := ']></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30RS_NAME_RASD]]></value><valuecode><![CDATA[="B30RS_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B30RS_NAME]]></value><valuecode><![CDATA[="B30RS_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rl';
 v_vc(170) := 'obid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B30RS_VALUE]]></value><valuecode><![CDATA[="''||B30RS(1)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>147</elementid><pelementid>76</pelementid><orderby>2224</orderby><element>TX_</element><type>E</type><id></id><nameid>B30JOB_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB30JOB rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB30JOB rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB30JOB_NAME]]></value><valuecode><![CDATA[="rasdTxB30JOB_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></n';
 v_vc(171) := 'ame><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>148</elementid><pelementid>147</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B30JOB</id><nameid>B30JOB</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30JOB_NAME_RASD]]></value><valuecode><![CDATA[="B30JOB_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B30JOB_NAME]]></value><valuecode><![CDATA[="B30JOB_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></texti';
 v_vc(172) := 'd><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B30JOB_VALUE]]></value><valuecode><![CDATA[="''||B30JOB(1)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value';
 v_vc(173) := '><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>149</elementid><pelementid>76</pelementid><orderby>2228</orderby><element>TX_</element><type>E</type><id></id><nameid>B30DESCRIPTION_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB30DESCRIPTION rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB30DESCRIPTION rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB30DESCRIPTION_NAME]]></value><valuecode><![CDATA[="rasdTxB30DESCRIPTION_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>150</elementid><pelementid>149</pelementid><orderby>1</orderby><element>INPUT_TEXT</element><type>D</type><id>B30DESCRIPTION</id><nameid>B30DESCRIPTION</nameid><endtagelementid></endtagelementid><source></source';
 v_vc(174) := '><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B30DESCRIPTION_NAME_RASD]]></value><valuecode><![CDATA[="B30DESCRIPTION_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B30DESCRIPTION_NAME]]></value><valuecode><![CDATA[="B30DESCRIPTION_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_';
 v_vc(175) := 'SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B30DESCRIPTION_VALUE]]></value><valuecode><![CDATA[="''||B30DESCRIPTION(1)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element></elements></form>';
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
end DEMO_TRIGGERS;
/

