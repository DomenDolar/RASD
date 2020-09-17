create or replace package IMP_DEMO_FIELDS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_FIELDS generated on 30.01.20 by user RASDCLI.     
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

create or replace package body IMP_DEMO_FIELDS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_FIELDS generated on 30.01.20 by user RASDCLI.    
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
  ACTION                        varchar2(4000);  PAGE                          number := 0
;  RECNUMB10                     number := 1
;
  ERROR                         varchar2(4000);
  MESSAGE                       varchar2(4000);
  WARNING                       varchar2(4000);  GBUTTONSRC                    varchar2(4000) := 'Search'
;  GBUTTONRES                    varchar2(4000) := 'Reset'
;  GBUTTONBCK                    varchar2(4000) := 'Back'
;  GBUTTONFWD                    varchar2(4000) := 'Forward'
;  GBUTTONCLR                    varchar2(4000) := 'Clear'
;  GBUTTONSAVE                   varchar2(4000) := 'Save-Commit'
;  GBUTTONCUSTOM                 varchar2(4000) := 'Create error'
;
  ROWVALUE                      varchar2(4000);
  PENAME                        ctab;
  B10RS                         ctab;
  B10RID                        rtab;
  B10EMPNO                      ntab;
  B10ENAME                      ctab;
  B10JOB                        ctab;
  B10MGR                        ntab;
  B10HIREDATE                   dtab;
  B20RESET_DATA                 ctab;
  B10SAL                        ntab;
  B20SUBMIT_DATA                ctab;
  B10SALCALC                    ctab;
  B10COMM                       ntab;
  B10DEPTNO                     ntab;
  B10HIREDATECALC               dtab;
  B10NOTE                       ctab;
  B25CHECKBOX_DEF               ctab;
  B25CHECKBOX_CUST              ctab;
  B10JOB2                       ctab;
  B10JOB3                       ctab;
  B10BTNSUB                     ctab;
  B30MESSAG1                    ctab;
  B30EXECPLSQLONUI              ctab;
  PXXXX                         dtab;
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
        rasd_client.callLog('IMP_DEMO_FIELDS',v_clob, systimestamp, '' );
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '
<link />
<script></script>

';
       end; 
     function form_js return clob is
       begin
        return  '
      $(document).ready(function() {
       $("#B10_TABLE").removeClass( "rasdTableN" );

        xTable = $("#B10_TABLE").dataTable({
		  "responsive": true,
          "retrieve": true,
          "bJQueryUI": true,
          "aaSorting": [],
          "oLanguage": {
            "sSearch": "Search on table - Custom text",
            "sZeroRecords": "No data available in table - Custom text",
            "oPaginate": {
               "sNext":       "NeXt",
            }         
		  },
        "paginate": true,
        "pageLength": 5,
        "bLengthChange": true,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false //have to be false because otherwise radio buttons on first line are not checked - known bug in 1.9.4
        });       
	  } );

  $(function() { 
    validateNumberFields();	
	
    setShowHideDiv("B10_DIV");  
  });


//  $(function() {
//     addSpinner();
//  });



        ';
       end; 
     function form_css return clob is
       begin
        return '
.test {
color: red;
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
cursor c_LOV_DEPARTMENT(p_id varchar2) is 
--<lovsql formid="71" linkid="LOV_DEPARTMENT">
select id, label from (select deptno id, dname label from DEPT
order by 1 ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
--</lovsql>
;
cursor c_LOV_JOBS(p_id varchar2) is 
--<lovsql formid="71" linkid="LOV_JOBS">
select id, label from (select job id, description label from JOBS t order by 1 
 ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' fetch first 100 rows only
--</lovsql>
;
cursor c_LOV_MANAGER(p_id varchar2) is 
--<lovsql formid="71" linkid="LOV_MANAGER">
select id, label from (select '' id, '' label, 1 from dual
union
select to_char(empno) id, ename label, 2 from EMP t
order by 3, 1 ) where upper(id) like '%'||upper(p_id)||'%' or upper(label) like '%'||upper(p_id)||'%' 
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
  if lower(p_lov) = lower('LOV_DEPARTMENT') then
    v_description := 'Departments';
    for r in c_LOV_DEPARTMENT(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('LOV_JOBS') then
    v_description := 'Jobs';
    for r in c_LOV_JOBS(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('LOV_MANAGER') then
    v_description := 'Managers';
    for r in c_LOV_MANAGER(p_id) loop
        v_lov(v_counter).p1 := r.id;
        v_lov(v_counter).output := r.label;
        v_counter := v_counter + 1;
    end loop;
    v_counter := v_counter - 1;
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('CLOV') then
    v_description := 'CUSTOM LOV';
        v_lov(1).output := 'Value 1';
        v_lov(1).p1 := 'V1';
        v_lov(2).output := 'Value 2';
        v_lov(2).p1 := 'VV2';
        v_lov(3).output := 'Value 3';
        v_lov(3).p1 := 'VC3';
        v_counter := 3; 
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('INPUT_CHECKBOX_DEF') then
    v_description := 'INPUT_CHECKBOX_DEF';
        v_lov(1).output := 'N';
        v_lov(1).p1 := 'N';
        v_lov(2).output := 'Y';
        v_lov(2).p1 := 'Y';
        v_counter := 2; 
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('LOV_MF') then
    v_description := 'Male/Female';
        v_lov(1).output := 'Female';
        v_lov(1).p1 := 'F';
        v_lov(2).output := 'Male';
        v_lov(2).p1 := 'M';
        v_counter := 2; 
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('LOV_YN') then
    v_description := 'Yes/No';
        v_lov(1).output := 'No';
        v_lov(1).p1 := 'N';
        v_lov(2).output := 'Yes';
        v_lov(2).p1 := 'Y';
        v_counter := 2; 
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('link$CHKBXD') then
    v_description := 'CHKBXD';
        v_lov(1).output := 'N';
        v_lov(1).p1 := 'N';
        v_lov(2).output := 'Y';
        v_lov(2).p1 := 'Y';
        v_counter := 2; 
        if 1=2 then null;
        end if;          
  elsif lower(p_lov) = lower('lov$SALCAL') then
    v_description := 'SALARY CALCULATED';
        v_lov(1).output := 'Lower';
        v_lov(1).p1 := 'L';
        v_lov(2).output := 'Higher';
        v_lov(2).p1 := 'H';
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','⛺ Demo - find employee')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
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
 htp.formOpen(curl=>'!IMP_DEMO_FIELDS.openLOV',
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
   return 'v.1.1.20200130003005'; 
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
if ROWVALUE is null then vc := rasd_client.sessionGetValue('ROWVALUE'); ROWVALUE  := vc;  end if; 
if PENAME(i__) is null then vc := rasd_client.sessionGetValue('PENAME'); PENAME(i__)  := vc;  end if; 
if PXXXX(i__) is null then vc := rasd_client.sessionGetValue('PXXXX'); PXXXX(i__)  := to_date(vc,rasd_client.c_date_format);  end if; 
if B25CHECKBOX_DEF(i__) is null then vc := rasd_client.sessionGetValue('B30CHECKBOX_DEF'); B25CHECKBOX_DEF(i__)  := vc;  end if; 
if B25CHECKBOX_CUST(i__) is null then vc := rasd_client.sessionGetValue('B30CHECKBOX_CUST'); B25CHECKBOX_CUST(i__)  := vc;  end if; 
if B30MESSAG1(i__) is null then vc := rasd_client.sessionGetValue('B30MESSAG1'); B30MESSAG1(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('RECNUMB10') then RECNUMB10 := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONBCK') then GBUTTONBCK := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONFWD') then GBUTTONFWD := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCLR') then GBUTTONCLR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSAVE') then GBUTTONSAVE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCUSTOM') then GBUTTONCUSTOM := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ROWVALUE') then ROWVALUE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10RS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RID_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10RID(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10EMPNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10EMPNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10MGR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10MGR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10HIREDATE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), 'yyyy/mm/dd');
      elsif  upper(name_array(i__)) = upper('B20RESET_DATA_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20RESET_DATA(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10SAL(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20SUBMIT_DATA_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20SUBMIT_DATA(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SALCALC_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10SALCALC(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10COMM_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10COMM(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10DEPTNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATECALC_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10HIREDATECALC(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), rasd_client.C_DATE_FORMAT);
      elsif  upper(name_array(i__)) = upper('B10NOTE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10NOTE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30CHECKBOX_DEF_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B25CHECKBOX_DEF(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30CHECKBOX_CUST_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B25CHECKBOX_CUST(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB2_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10JOB2(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB3_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10JOB3(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BTNSUB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10BTNSUB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30MESSAG1_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30MESSAG1(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30EXECPLSQLONUI_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30EXECPLSQLONUI(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PXXXX_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PXXXX(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('PENAME') and PENAME.count = 0 and value_array(i__) is not null then
        PENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RS') and B10RS.count = 0 and value_array(i__) is not null then
        B10RS(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RID') and B10RID.count = 0 and value_array(i__) is not null then
        B10RID(1) := chartorowid(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10EMPNO') and B10EMPNO.count = 0 and value_array(i__) is not null then
        B10EMPNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10ENAME') and B10ENAME.count = 0 and value_array(i__) is not null then
        B10ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB') and B10JOB.count = 0 and value_array(i__) is not null then
        B10JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10MGR') and B10MGR.count = 0 and value_array(i__) is not null then
        B10MGR(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATE') and B10HIREDATE.count = 0 and value_array(i__) is not null then
        B10HIREDATE(1) := to_date(value_array(i__), 'yyyy/mm/dd');
      elsif  upper(name_array(i__)) = upper('B20RESET_DATA') and B20RESET_DATA.count = 0 and value_array(i__) is not null then
        B20RESET_DATA(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL') and B10SAL.count = 0 and value_array(i__) is not null then
        B10SAL(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20SUBMIT_DATA') and B20SUBMIT_DATA.count = 0 and value_array(i__) is not null then
        B20SUBMIT_DATA(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SALCALC') and B10SALCALC.count = 0 and value_array(i__) is not null then
        B10SALCALC(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10COMM') and B10COMM.count = 0 and value_array(i__) is not null then
        B10COMM(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO') and B10DEPTNO.count = 0 and value_array(i__) is not null then
        B10DEPTNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATECALC') and B10HIREDATECALC.count = 0 and value_array(i__) is not null then
        B10HIREDATECALC(1) := to_date(value_array(i__), rasd_client.C_DATE_FORMAT);
      elsif  upper(name_array(i__)) = upper('B10NOTE') and B10NOTE.count = 0 and value_array(i__) is not null then
        B10NOTE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30CHECKBOX_DEF') and B25CHECKBOX_DEF.count = 0 and value_array(i__) is not null then
        B25CHECKBOX_DEF(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30CHECKBOX_CUST') and B25CHECKBOX_CUST.count = 0 and value_array(i__) is not null then
        B25CHECKBOX_CUST(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB2') and B10JOB2.count = 0 and value_array(i__) is not null then
        B10JOB2(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB3') and B10JOB3.count = 0 and value_array(i__) is not null then
        B10JOB3(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10BTNSUB') and B10BTNSUB.count = 0 and value_array(i__) is not null then
        B10BTNSUB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30MESSAG1') and B30MESSAG1.count = 0 and value_array(i__) is not null then
        B30MESSAG1(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30EXECPLSQLONUI') and B30EXECPLSQLONUI.count = 0 and value_array(i__) is not null then
        B30EXECPLSQLONUI(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PXXXX') and PXXXX.count = 0 and value_array(i__) is not null then
        PXXXX(1) := to_date(value_array(i__), rasd_client.c_date_format);
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
      if B10RS.exists(v_curr) then B10RS(i__) := B10RS(v_curr); end if;
      if B10RID.exists(v_curr) then B10RID(i__) := B10RID(v_curr); end if;
      if B10EMPNO.exists(v_curr) then B10EMPNO(i__) := B10EMPNO(v_curr); end if;
      if B10ENAME.exists(v_curr) then B10ENAME(i__) := B10ENAME(v_curr); end if;
      if B10JOB.exists(v_curr) then B10JOB(i__) := B10JOB(v_curr); end if;
      if B10MGR.exists(v_curr) then B10MGR(i__) := B10MGR(v_curr); end if;
      if B10HIREDATE.exists(v_curr) then B10HIREDATE(i__) := B10HIREDATE(v_curr); end if;
      if B10SAL.exists(v_curr) then B10SAL(i__) := B10SAL(v_curr); end if;
      if B10SALCALC.exists(v_curr) then B10SALCALC(i__) := B10SALCALC(v_curr); end if;
      if B10COMM.exists(v_curr) then B10COMM(i__) := B10COMM(v_curr); end if;
      if B10DEPTNO.exists(v_curr) then B10DEPTNO(i__) := B10DEPTNO(v_curr); end if;
      if B10HIREDATECALC.exists(v_curr) then B10HIREDATECALC(i__) := B10HIREDATECALC(v_curr); end if;
      if B10NOTE.exists(v_curr) then B10NOTE(i__) := B10NOTE(v_curr); end if;
      if B10JOB2.exists(v_curr) then B10JOB2(i__) := B10JOB2(v_curr); end if;
      if B10JOB3.exists(v_curr) then B10JOB3(i__) := B10JOB3(v_curr); end if;
      if B10BTNSUB.exists(v_curr) then B10BTNSUB(i__) := B10BTNSUB(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B10RID
.NEXT(v_curr);  
   END LOOP;
      B10RS.DELETE(i__ , v_last);
      B10RID.DELETE(i__ , v_last);
      B10EMPNO.DELETE(i__ , v_last);
      B10ENAME.DELETE(i__ , v_last);
      B10JOB.DELETE(i__ , v_last);
      B10MGR.DELETE(i__ , v_last);
      B10HIREDATE.DELETE(i__ , v_last);
      B10SAL.DELETE(i__ , v_last);
      B10SALCALC.DELETE(i__ , v_last);
      B10COMM.DELETE(i__ , v_last);
      B10DEPTNO.DELETE(i__ , v_last);
      B10HIREDATECALC.DELETE(i__ , v_last);
      B10NOTE.DELETE(i__ , v_last);
      B10JOB2.DELETE(i__ , v_last);
      B10JOB3.DELETE(i__ , v_last);
      B10BTNSUB.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if B10RS.count > v_max then v_max := B10RS.count; end if;
    if B10RID.count > v_max then v_max := B10RID.count; end if;
    if B10EMPNO.count > v_max then v_max := B10EMPNO.count; end if;
    if B10ENAME.count > v_max then v_max := B10ENAME.count; end if;
    if B10JOB.count > v_max then v_max := B10JOB.count; end if;
    if B10MGR.count > v_max then v_max := B10MGR.count; end if;
    if B10HIREDATE.count > v_max then v_max := B10HIREDATE.count; end if;
    if B10SAL.count > v_max then v_max := B10SAL.count; end if;
    if B10SALCALC.count > v_max then v_max := B10SALCALC.count; end if;
    if B10COMM.count > v_max then v_max := B10COMM.count; end if;
    if B10DEPTNO.count > v_max then v_max := B10DEPTNO.count; end if;
    if B10HIREDATECALC.count > v_max then v_max := B10HIREDATECALC.count; end if;
    if B10NOTE.count > v_max then v_max := B10NOTE.count; end if;
    if B10JOB2.count > v_max then v_max := B10JOB2.count; end if;
    if B10JOB3.count > v_max then v_max := B10JOB3.count; end if;
    if B10BTNSUB.count > v_max then v_max := B10BTNSUB.count; end if;
    if v_max = 0 then v_max := 10; end if;
    for i__ in 1..v_max loop
      if not B10RS.exists(i__) then
        B10RS(i__) := null;
      end if;
      if not B10RID.exists(i__) then
        B10RID(i__) := null;
      end if;
      if not B10EMPNO.exists(i__) then
        B10EMPNO(i__) := to_number(null);
      end if;
      if not B10ENAME.exists(i__) then
        B10ENAME(i__) := null;
      end if;
      if not B10JOB.exists(i__) then
        B10JOB(i__) := null;
      end if;
      if not B10MGR.exists(i__) then
        B10MGR(i__) := to_number(null);
      end if;
      if not B10HIREDATE.exists(i__) then
        B10HIREDATE(i__) := to_date(null);
      end if;
      if not B10SAL.exists(i__) then
        B10SAL(i__) := to_number(null);
      end if;
      if not B10SALCALC.exists(i__) or B10SALCALC(i__) is null then
        B10SALCALC(i__) := 'L';
      end if;
      if not B10COMM.exists(i__) then
        B10COMM(i__) := to_number(null);
      end if;
      if not B10DEPTNO.exists(i__) then
        B10DEPTNO(i__) := to_number(null);
      end if;
      if not B10HIREDATECALC.exists(i__) then
        B10HIREDATECALC(i__) := to_date(null);
      end if;
      if not B10NOTE.exists(i__) then
        B10NOTE(i__) := null;
      end if;
      if not B10JOB2.exists(i__) then
        B10JOB2(i__) := null;
      end if;
      if not B10JOB3.exists(i__) then
        B10JOB3(i__) := null;
      end if;
      if not B10BTNSUB.exists(i__) then
        B10BTNSUB(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B20RESET_DATA.count > v_max then v_max := B20RESET_DATA.count; end if;
    if B20SUBMIT_DATA.count > v_max then v_max := B20SUBMIT_DATA.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B20RESET_DATA.exists(i__) then
        B20RESET_DATA(i__) := 'Reset values';
      end if;
      if not B20SUBMIT_DATA.exists(i__) then
        B20SUBMIT_DATA(i__) := 'Submit me';
      end if;
    null; end loop;
    v_max := 0;
    if B25CHECKBOX_DEF.count > v_max then v_max := B25CHECKBOX_DEF.count; end if;
    if B25CHECKBOX_CUST.count > v_max then v_max := B25CHECKBOX_CUST.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B25CHECKBOX_DEF.exists(i__) or B25CHECKBOX_DEF(i__) is null then
        B25CHECKBOX_DEF(i__) := 'N';
      end if;
      if not B25CHECKBOX_CUST.exists(i__) or B25CHECKBOX_CUST(i__) is null then
        B25CHECKBOX_CUST(i__) := 'F';
      end if;
    null; end loop;
    v_max := 0;
    if B30MESSAG1.count > v_max then v_max := B30MESSAG1.count; end if;
    if B30EXECPLSQLONUI.count > v_max then v_max := B30EXECPLSQLONUI.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B30MESSAG1.exists(i__) then
        B30MESSAG1(i__) := null;
      end if;
      if not B30EXECPLSQLONUI.exists(i__) then
        B30EXECPLSQLONUI(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if PENAME.count > v_max then v_max := PENAME.count; end if;
    if PXXXX.count > v_max then v_max := PXXXX.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PENAME.exists(i__) then
        PENAME(i__) := null;
      end if;
      if not PXXXX.exists(i__) then
        PXXXX(i__) := to_date(null);
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
        PENAME(i__) := null;
        PXXXX(i__) := null;

      end loop;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 10 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B10RID
.count(); end if;
      else  
       if i__ > 10 then  k__ := i__ + 0;
       else k__ := 0 + 10;
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
      B10SALCALC(i__) := B10SALCALC(i__);
      exception when others then
        B10SALCALC(i__) := null;

      end;
      begin
      B10HIREDATECALC(i__) := B10HIREDATECALC(i__);
      exception when others then
        B10HIREDATECALC(i__) := null;

      end;
      begin
      B10JOB2(i__) := B10JOB2(i__);
      exception when others then
        B10JOB2(i__) := null;

      end;
      begin
      B10JOB3(i__) := B10JOB3(i__);
      exception when others then
        B10JOB3(i__) := null;

      end;
      begin
      B10BTNSUB(i__) := B10BTNSUB(i__);
      exception when others then
        B10BTNSUB(i__) := null;

      end;
      null;
      end loop;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10RS(i__) := null;
        B10RID(i__) := null;
        B10EMPNO(i__) := null;
        B10ENAME(i__) := null;
        B10JOB(i__) := null;
        B10MGR(i__) := null;
        B10HIREDATE(i__) := null;
        B10SAL(i__) := null;
        B10SALCALC(i__) := null;
        B10COMM(i__) := null;
        B10DEPTNO(i__) := null;
        B10HIREDATECALC(i__) := null;
        B10NOTE(i__) := null;
        B10JOB2(i__) := null;
        B10JOB3(i__) := null;
        B10BTNSUB(i__) := null;
        B10RS(i__) := 'I';

      end loop;
  end;
  procedure pclear_B20(pstart number) is
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
        B20RESET_DATA(i__) := 'Reset values';
        B20SUBMIT_DATA(i__) := 'Submit me';

      end loop;
  end;
  procedure pclear_B25(pstart number) is
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
        B25CHECKBOX_DEF(i__) := null;
        B25CHECKBOX_CUST(i__) := null;

      end loop;
  end;
  procedure pclear_B30(pstart number) is
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
        B30MESSAG1(i__) := null;
        B30EXECPLSQLONUI(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    PAGE := 0;
    RECNUMB10 := 1;
    ERROR := null;
    MESSAGE := null;
    WARNING := null;
    GBUTTONSRC := 'Search';
    GBUTTONRES := 'Reset';
    GBUTTONBCK := 'Back';
    GBUTTONFWD := 'Forward';
    GBUTTONCLR := 'Clear';
    GBUTTONSAVE := 'Save-Commit';
    GBUTTONCUSTOM := 'Create error';
    ROWVALUE := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);
    pclear_B10(0);
    pclear_B20(0);
    pclear_B25(0);
    pclear_B30(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PENAME.count);
  null; end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      B10RID.delete;
      B10EMPNO.delete;
      B10ENAME.delete;
      B10JOB.delete;
      B10MGR.delete;
      B10HIREDATE.delete;
      B10SAL.delete;
      B10COMM.delete;
      B10DEPTNO.delete;
      B10NOTE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="71" blockid="B10">
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
NOTE FROM EMP where upper(ename) like '%'||upper(PENAME(1))||'%'
order by ename
--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B10RID(i__)
           ,B10EMPNO(i__)
           ,B10ENAME(i__)
           ,B10JOB(i__)
           ,B10MGR(i__)
           ,B10HIREDATE(i__)
           ,B10SAL(i__)
           ,B10COMM(i__)
           ,B10DEPTNO(i__)
           ,B10NOTE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  nvl(RECNUMB10,1) then
            B10RS(i__) := 'U';
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.
            B10RS(i__) := B10RS(i__) ||','||B10ENAME(i__);

--<post_select formid="71" blockid="B10">
declare
begin
  B10HIREDATECALC(i__) := B10HIREDATE(i__) + 10; -- add 10 days
  B10JOB2(i__) := B10JOB(i__);
  
  B10BTNSUB(i__) := 'Submit row!'; --GBUTTONSAVE;
end;

if B10SAL(i__) > 1000 then B10SALCALC(i__) := 'H'; else B10SALCALC(i__) := 'L'; end if;



--</post_select>
            exit when i__ =10;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  nvl(RECNUMB10,1) then
          B10RS.delete(1);
          B10RID.delete(1);
          B10EMPNO.delete(1);
          B10ENAME.delete(1);
          B10JOB.delete(1);
          B10MGR.delete(1);
          B10HIREDATE.delete(1);
          B10SAL.delete(1);
          B10SALCALC.delete(1);
          B10COMM.delete(1);
          B10DEPTNO.delete(1);
          B10HIREDATECALC.delete(1);
          B10NOTE.delete(1);
          B10JOB2.delete(1);
          B10JOB3.delete(1);
          B10BTNSUB.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B10(B10RID.count);
  null; end;
  procedure pselect_B20 is
    i__ pls_integer;
  begin
      pclear_B20(B20RESET_DATA.count);
  null; end;
  procedure pselect_B25 is
    i__ pls_integer;
  begin
      pclear_B25(B25CHECKBOX_DEF.count);
  null; end;
  procedure pselect_B30 is
    i__ pls_integer;
  begin
      pclear_B30(B30MESSAG1.count);
  null; end;
  procedure pselect is
  begin
    if  nvl(PAGE,0) = 0 then 
      pselect_B10;
    end if;
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PENAME.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10RS.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if substr(B10RS(i__),1,1) = 'I' then --INSERT
        if B10ENAME(i__) is not null
 or B10JOB(i__) is not null
 or B10MGR(i__) is not null
 or B10HIREDATE(i__) is not null
 or B10SAL(i__) is not null
 or B10COMM(i__) is not null
 or B10DEPTNO(i__) is not null
 or B10NOTE(i__) is not null
 then 
--<pre_insert formid="71" blockid="B10">
declare
  v_empno number;
begin

  select max(empno)+10 into v_empno  from emp;
  B10EMPNO(i__) := v_empno;
end;

--</pre_insert>
-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10ENAME(i__) is null
 or B10JOB(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated INSERT statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = 'I' then
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
  B10EMPNO(i__)
 ,B10ENAME(i__)
 ,B10JOB(i__)
 ,B10MGR(i__)
 ,B10HIREDATE(i__)
 ,B10SAL(i__)
 ,B10COMM(i__)
 ,B10DEPTNO(i__)
 ,B10NOTE(i__)
);
 MESSAGE := 'Data is changed.';
end if;

        null; end if;
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.
 declare
   v_locking varchar2(4000);
 begin  
  select 'U'||','||ENAME into v_locking
from EMP
where ROWID = B10RID(i__) for update;
  if B10RS(i__) <> v_locking then
    raise_application_error('-20002','Data has been changed! Refresh data.');
  end if;
 end;
        if B10ENAME(i__) is null
 and B10JOB(i__) is null
 then --DELETE

-- Generated DELETE statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = 'U' then
delete EMP
where ROWID = B10RID(i__);
 MESSAGE := 'Data is changed.';
end if;

        else --UPDATE

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.
 if B10ENAME(i__) is null
 or B10JOB(i__) is null
 then 
   raise_application_error('-20001','Mandatory data is missing!');
 end if;
-- Generated UPDATE statement. Use (i__) to access fields values.
if substr(B10RS(i__),1,1) = 'U' then
update EMP set
  ENAME = B10ENAME(i__)
 ,JOB = B10JOB(i__)
 ,MGR = B10MGR(i__)
 ,HIREDATE = B10HIREDATE(i__)
 ,SAL = B10SAL(i__)
 ,COMM = B10COMM(i__)
 ,DEPTNO = B10DEPTNO(i__)
 ,NOTE = B10NOTE(i__)
where ROWID = B10RID(i__);
 MESSAGE := 'Data is changed.';
end if;


       null;  end if;
      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B20 is
  begin
    for i__ in 1..B20RESET_DATA.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B25 is
  begin
    for i__ in 1..B25CHECKBOX_DEF.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B30 is
  begin
    for i__ in 1..B30MESSAG1.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit is
  begin

    if  nvl(PAGE,0) = 0 then 
       pcommit_B10;
    end if;

  null; 
  end;
  procedure poutput is
    iB10 pls_integer;
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
  function ShowFieldGBUTTONCUSTOM return boolean is 
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
  function ShowBlockB10_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB20_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 or nvl(PAGE,0) = 4 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB25_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 3 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 or nvl(PAGE,0) = 4 then 
       return true;
    end if;
    return false;
  end; 
  function js_link$link_save2(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'B10BTNSUB%' then
      v_return := v_return || 'document.IMP_DEMO_FIELDS.ROWVALUE.value='''||replace(B10EMPNO(to_number(substr(name,instr(name,'_',-1)+1))),'"','&quot;')||
''';if (cMFB10()== false){return}';
    elsif name is null then
      v_return := v_return ||'''!DEMO_FIELDS.webclient?ROWVALUE='||replace(B10EMPNO(1),'"','&quot;')||
'&if (cMFB10()== false){return}''';
    end if;
    return v_return;
  end;
  procedure js_link$link_save2(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_link$link_save2(value, name));
  end;
  function js_link$submitcode(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'B20SUBMIT_DATA%' then
      v_return := v_return || '';
    elsif name is null then
      v_return := v_return ||'''''';
    end if;
    return v_return;
  end;
  procedure js_link$submitcode(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_link$submitcode(value, name));
  end;
  function js_link$link_save(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'GBUTTONSAVE%' then
      v_return := v_return || 'if (cMF()== false){return}';
    elsif name is null then
      v_return := v_return ||'''!DEMO_FIELDS.webclient?if (cMF()== false){return}''';
    end if;
    return v_return;
  end;
  procedure js_link$link_save(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_link$link_save(value, name));
  end;
  function js_LINK_CALL_DEMO_CFORM(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'B10JOB2%' then
      v_return := v_return || '''!demo_cform.webclient?GBUTTONRES=''+document.IMP_DEMO_FIELDS.B10JOB_'||substr(name,instr(name,'_',-1)+1)||'.value+
''&B10JOB_1=''+document.IMP_DEMO_FIELDS.B10JOB2_'||substr(name,instr(name,'_',-1)+1)||'.value+
''&B30MESSAGE_1=Send message from form 1&FIN=opener.js_LINK_CALL_DEMO_CFORM(\'''||name||'\'',this.document)&PFILTER_1='||replace(value,'"','&quot;')||'''';
    elsif name is null then
      v_return := v_return ||'''!demo_cform.webclient?GBUTTONRES=''+document.IMP_DEMO_FIELDS.B10JOB_1.value+
''&B10JOB_1=''+document.IMP_DEMO_FIELDS.B10JOB2_1.value+
''&B30MESSAGE_1=Send message from form 1&FIN=opener.js_LINK_CALL_DEMO_CFORM(\'''||name||'\'',this.document)&PFILTER_1='||replace(value,'"','&quot;')||'''';
    end if;
    return v_return;
  end;
  procedure js_LINK_CALL_DEMO_CFORM(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_LINK_CALL_DEMO_CFORM(value, name));
  end;
  procedure js_RLOV_DEPARTMENT(value varchar2, name varchar2 default null) is
  begin
    htp.p('<script language="JavaScript">');
    htp.p('js_RLOV_DEPARTMENT('''||name||''','''||value||''');');
    htp.p('</script>');
  end;
  procedure js_SLOV_MANAGER(value varchar2, name varchar2 default null) is
  begin
    htp.p('<script language="JavaScript">');
    htp.p('js_SLOV_MANAGER('''||value||''','''||name||''');');
    htp.p('</script>');
  end;
  procedure js_LOV_JOBS(value varchar2, name varchar2 default null) is
  begin
    if 1=2 then null;
    elsif name like 'B10JOB%' then
      htp.prn('javascript: var link=window.open(encodeURI(''!IMP_DEMO_FIELDS.openLOV?PLOV=LOV_JOBS&FIN=IMP_DEMO_FIELDS.'||name||'&PID=''+document.IMP_DEMO_FIELDS.'||name||'.value+''''),''openLOV'',''resizable,scrollbars,width=680,height=550'');');
    end if;
  end;
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock">Tabel of users</div></caption><table border="1" id="B10_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10EMPNO"><span id="B10EMPNO_LAB" class="label">Number</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10ENAME"><span id="B10ENAME_LAB" class="label">Name</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10JOB"><span id="B10JOB_LAB" class="label">Job</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10MGR"><span id="B10MGR_LAB" class="label">Manager</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10HIREDATE"><span id="B10HIREDATE_LAB" class="label">Hired</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10SAL"><span id="B10SAL_LAB" class="label">Salary</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10SALCALC"><span id="B10SALCALC_LAB" class="label">Sal. > 1000</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10COMM"><span id="B10COMM_LAB" class="label">Comm.</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10DEPTNO"><span id="B10DEPTNO_LAB" class="label">Department</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10HIREDATECALC"><span id="B10HIREDATECALC_LAB" class="label">Hired calculated</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10NOTE"><span id="B10NOTE_LAB" class="label">Note</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10JOB2"><span id="B10JOB2_LAB" class="label">Job2</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10JOB3"><span id="B10JOB3_LAB" class="label">Job3_ON_UI</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10BTNSUB"><span id="B10BTNSUB_LAB" class="label"></span></td></tr></thead>'); for iB10 in 1..B10RID.count loop 
htp.prn('<tr id="B10_BLOCK"><span id="" value="'||iB10||'" name="" class="hiddenRowItems"><input name="B10RS_'||iB10||'" id="B10RS_'||iB10||'_RASD" type="hidden" value="'||B10RS(iB10)||'"/>
<input name="B10RID_'||iB10||'" id="B10RID_'||iB10||'_RASD" type="hidden" value="'||to_char(B10RID(iB10))||'"/>
</span><td class="rasdTxB10EMPNO rasdTxTypeN" id="rasdTxB10EMPNO_'||iB10||'"><font id="B10EMPNO_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10EMPNO(iB10)))||'</font></td><td class="rasdTxB10ENAME rasdTxTypeC" id="rasdTxB10ENAME_'||iB10||'"><input name="B10ENAME_'||iB10||'" id="B10ENAME_'||iB10||'_RASD" type="text" value="'||B10ENAME(iB10)||'" class="rasdTextC"/>
</td><td class="rasdTxB10JOB rasdTxTypeC" id="rasdTxB10JOB_'||iB10||'"><input ondblclick="'); js_LOV_JOBS(B10JOB(iB10),'B10JOB_'||iB10||''); 
htp.prn('" name="B10JOB_'||iB10||'" id="B10JOB_'||iB10||'_RASD" type="text" value="'||B10JOB(iB10)||'" class="rasdTextC"/>

</td><td class="rasdTxB10MGR rasdTxTypeN" id="rasdTxB10MGR_'||iB10||'"><select name="B10MGR_'||iB10||'" ID="B10MGR_'||iB10||'_RASD" class="rasdSelect">'); js_SLOV_MANAGER(ltrim(to_char(B10MGR(iB10))),'B10MGR_'||iB10||''); 
htp.prn('</select></td><td class="rasdTxB10HIREDATE rasdTxTypeD" id="rasdTxB10HIREDATE_'||iB10||'"><span id="B10HIREDATE_'||iB10||'_RASD" autocomplete="off">'|| rasd_client.getHtmlDatePicker('B10HIREDATE_'||iB10||'', 'yyyy/mm/dd') ||' 
<input id="B10HIREDATE_'||iB10||'" name="B10HIREDATE_'||iB10||'" type="text" value="'||to_char(B10HIREDATE(iB10),'yyyy/mm/dd')||'" class="rasdTextD" autocomplete="off" />
</span></td><td class="rasdTxB10SAL rasdTxTypeN" id="rasdTxB10SAL_'||iB10||'"><input name="B10SAL_'||iB10||'" id="B10SAL_'||iB10||'_RASD" type="text" value="'||ltrim(to_char(B10SAL(iB10),'999G990D00'))||'" class="rasdTextN"/>
</td><td class="rasdTxB10SALCALC rasdTxTypeC" id="rasdTxB10SALCALC_'||iB10||'"><input ONCLICK="js_Clov$SALCALclick(this.value, ''B10SALCALC_'||iB10||''');" name="B10SALCALC_'||iB10||'" id="B10SALCALC_'||iB10||'_RASD" type="checkbox" value="'||B10SALCALC(iB10)||'" class="rasdCheckbox"/><SCRIPT LANGUAGE="JavaScript"> document.addEventListener(''DOMContentLoaded'', function(event) {  js_Clov$SALCALinit( '''||B10SALCALC(iB10)||''' , ''B10SALCALC_'||iB10||''' ); }) </SCRIPT>
</td><td class="rasdTxB10COMM rasdTxTypeN" id="rasdTxB10COMM_'||iB10||'"><input name="B10COMM_'||iB10||'" id="B10COMM_'||iB10||'_RASD" type="text" value="'||ltrim(to_char(B10COMM(iB10)))||'" class="rasdTextN"/>
</td><td class="rasdTxB10DEPTNO rasdTxTypeN" id="rasdTxB10DEPTNO_'||iB10||'"><font id="B10DEPTNO_'||iB10||'_RASD" class="rasdRadio">'); js_RLOV_DEPARTMENT(ltrim(to_char(B10DEPTNO(iB10))),'B10DEPTNO_'||iB10||''); 
htp.prn('</font></td><td class="rasdTxB10HIREDATECALC rasdTxTypeD" id="rasdTxB10HIREDATECALC_'||iB10||'"><font id="B10HIREDATECALC_'||iB10||'_RASD" class="rasdFont">'||to_char(B10HIREDATECALC(iB10),rasd_client.C_DATE_FORMAT)||'</font></td><td class="rasdTxB10NOTE rasdTxTypeC" id="rasdTxB10NOTE_'||iB10||'"><textarea name="B10NOTE_'||iB10||'" id="B10NOTE_'||iB10||'_RASD" class="rasdTextarea">'||B10NOTE(iB10)||'</textarea></td><td class="rasdTxB10JOB2 rasdTxTypeC" id="rasdTxB10JOB2_'||iB10||'"><input ondblclick="javascript: var link=window.open(encodeURI('); js_LINK_CALL_DEMO_CFORM(B10JOB2(iB10),'B10JOB2_'||iB10||''); 
htp.prn('),''x1'',''resizable,scrollbars,width=680,height=550'');" name="B10JOB2_'||iB10||'" id="B10JOB2_'||iB10||'_RASD" type="text" value="'||B10JOB2(iB10)||'" class="rasdTextC"/>
</td><td class="rasdTxB10JOB3 rasdTxTypeC" id="rasdTxB10JOB3_'||iB10||'"><span id="B10JOB3_'||iB10||'_RASD">');  htp.p('JOB03 ON UI');

htp.p( B10ENAME(iB10) );

htp.p( B10HIREDATE(iB10) );

htp.p( PENAME(1) );
  
htp.prn('</span></td><td class="rasdTxB10BTNSUB rasdTxTypeC" id="rasdTxB10BTNSUB_'||iB10||'"><input onclick="javascript: '); js_link$link_save2(B10BTNSUB(iB10),'B10BTNSUB_'||iB10||''); 
htp.prn(' ACTION.value=this.value; submit();" name="B10BTNSUB_'||iB10||'" id="B10BTNSUB_'||iB10||'_RASD" type="button" value="'||B10BTNSUB(iB10)||'" class="rasdButton"/>

</td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B20_DIV is begin htp.p('');  if  ShowBlockB20_DIV  then  
htp.prn('<div  id="B20_DIV" class="rasdblock"><div>
<caption><div id="B20_LAB" class="labelblock"></div></caption>
<table border="0" id="B20_TABLE"><tr id="B20_BLOCK"><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20RESET_DATA"><span id="B20RESET_DATA_LAB" class="label">Custom reset</span></td><td class="rasdTxB20RESET_DATA rasdTxTypeC" id="rasdTxB20RESET_DATA_1"><input name="B20RESET_DATA_1" id="B20RESET_DATA_1_RASD" type="reset" value="'||B20RESET_DATA(1)||'" class="rasdButton"/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20SUBMIT_DATA"><span id="B20SUBMIT_DATA_LAB" class="label">Custom SUBMIT</span></td><td class="rasdTxB20SUBMIT_DATA rasdTxTypeC" id="rasdTxB20SUBMIT_DATA_1"><input onclick="javascript: alert(''Hello'');  '); js_link$submitcode(B20SUBMIT_DATA(1),'B20SUBMIT_DATA_1'); 
htp.prn(' ACTION.value=this.value; submit();" name="B20SUBMIT_DATA_1" id="B20SUBMIT_DATA_1_RASD" type="button" value="'||B20SUBMIT_DATA(1)||'" class="rasdButton"/>
</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B25_DIV is begin htp.p('');  if  ShowBlockB25_DIV  then  
htp.prn('<div  id="B25_DIV" class="rasdblock"><div>
<caption><div id="B25_LAB" class="labelblock">Check boxes</div></caption>
<table border="0" id="B25_TABLE"><tr id="B25_BLOCK"><td class="rasdTxLab rasdTxLabBlockB25" id="rasdTxLabB30CHECKBOX_DEF"><span id="B30CHECKBOX_DEF_LAB" class="label">Checkbox default</span></td><td class="rasdTxB30CHECKBOX_DEF rasdTxTypeC" id="rasdTxB30CHECKBOX_DEF_1"><input ONCLICK="js_CLOV_YNclick(this.value, ''B30CHECKBOX_DEF_1'');" name="B30CHECKBOX_DEF_1" id="B30CHECKBOX_DEF_1_RASD" type="checkbox" value="'||B25CHECKBOX_DEF(1)||'" class="rasdCheckbox"/><SCRIPT LANGUAGE="JavaScript"> document.addEventListener(''DOMContentLoaded'', function(event) {  js_CLOV_YNinit( '''||B25CHECKBOX_DEF(1)||''' , ''B30CHECKBOX_DEF_1'' ); }) </SCRIPT>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockB25" id="rasdTxLabB30CHECKBOX_CUST"><span id="B30CHECKBOX_CUST_LAB" class="label">Checkbox Male/Female</span></td><td class="rasdTxB30CHECKBOX_CUST rasdTxTypeC" id="rasdTxB30CHECKBOX_CUST_1"><input ONCLICK="js_CLOV_MFclick(this.value, ''B30CHECKBOX_CUST_1'');" name="B30CHECKBOX_CUST_1" id="B30CHECKBOX_CUST_1_RASD" type="checkbox" value="'||B25CHECKBOX_CUST(1)||'" class="rasdCheckbox"/><SCRIPT LANGUAGE="JavaScript"> document.addEventListener(''DOMContentLoaded'', function(event) {  js_CLOV_MFinit( '''||B25CHECKBOX_CUST(1)||''' , ''B30CHECKBOX_CUST_1'' ); }) </SCRIPT>
</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B30_DIV is begin htp.p('');  if  ShowBlockB30_DIV  then  
htp.prn('<div  id="B30_DIV" class="rasdblock"><div>
<caption><div id="B30_LAB" class="labelblock">Output text area</div></caption>
<table border="0" id="B30_TABLE"><tr id="B30_BLOCK"><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30MESSAG1"><span id="B30MESSAG1_LAB" class="label"></span></td><td class="rasdTxB30MESSAG1 rasdTxTypeC" id="rasdTxB30MESSAG1_1"><font id="B30MESSAG1_1_RASD" class="rasdFont">'||B30MESSAG1(1)||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30EXECPLSQLONUI"><span id="B30EXECPLSQLONUI_LAB" class="label"></span></td><td class="rasdTxB30EXECPLSQLONUI rasdTxTypeC" id="rasdTxB30EXECPLSQLONUI_1"><span id="B30EXECPLSQLONUI_1_RASD">');  declare
begin
  htp.p('<FONT color="red">This text is from ON UI Trigger</FONT>');
end;
  
htp.prn('</span></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" style="rrrrrrrrrrrr" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><span id="" value="1" name="" class="hiddenRowItems"><input name="PXXXX_1" id="PXXXX_1_RASD" type="hidden" value="'||to_char(PXXXX(1),rasd_client.C_DATE_FORMAT)||'"/>
</span><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPENAME"><span id="PENAME_LAB" class="label">Employee:</span></td><td class="rasdTxPENAME rasdTxTypeC" id="rasdTxPENAME_1"><input name="PENAME_1" id="PENAME_1_RASD" type="text" value="'||PENAME(1)||'" class="rasdTextC"/>
</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<SCRIPT LANGUAGE="JavaScript">');
    htp.p('function js_LINK_CALL_DEMO_CFORM(p,w) {');
    htp.p('  var i = 0;');
    htp.p('  var pi;');
    htp.p('  if (p.indexOf(''_'') == -1) pi = '''';');
    htp.p('  else pi = p.substring(p.indexOf(''_''));');
    htp.p('  while(i < document.IMP_DEMO_FIELDS.elements.length){');
    htp.p('    if (document.IMP_DEMO_FIELDS.elements[i].name == ''B10JOB''+pi) {');
    htp.p('     document.IMP_DEMO_FIELDS.elements[i].value = w.DEMO_CFORM.WEBCLIENT.B10JOB.value;}');
    htp.p('    if (document.IMP_DEMO_FIELDS.elements[i].name == ''B10JOB2''+pi) {');
    htp.p('     document.IMP_DEMO_FIELDS.elements[i].value = w.DEMO_CFORM.WEBCLIENT.B10JOB.value;}');
    htp.p('    i++;');
    htp.p('  }');
    htp.p('}');
    htp.p('</SCRIPT>');
    htp.p('<script language="JavaScript">');
    htp.p('function js_RLOV_DEPARTMENT(pname, pvalue) {');
      htp.p(' var x = document.getElementById(pname+''_RASD''); ');
    for r__ in (
--<lovsql formid="71" linkid="LOV_DEPARTMENT">
select deptno id, dname label from DEPT
order by 1
--</lovsql>
    ) loop
       htp.p('   var option = document.createElement("input"); option.type = "radio"; option.className = "rasdRadio"; option.name = pname; option.type = "radio"; option.value = "'||r__.id||'"; option.checked = ((pvalue=='''||r__.id||''')?'' checked '':''''); x.appendChild(option);');
       htp.p('   var tekst = document.createTextNode("'||replace(r__.label,'''','\''')||'"); x.appendChild(tekst); ');
    end loop;
    htp.p('}');
    htp.prn('</script>');
    htp.p('<script language="JavaScript">');
    htp.p('function js_SLOV_MANAGER(pvalue, pobjectname) {');
      htp.p(' eval(''val_''+pobjectname+''="''+pvalue+''"'');'); 
      htp.p(' var x = document.getElementById(pobjectname+''_RASD''); ');
    begin
    for r__ in (
--<lovsql formid="71" linkid="LOV_MANAGER">
select '' id, '' label, 1 from dual
union
select to_char(empno) id, ename label, 2 from EMP t
order by 3, 1
--</lovsql>
    ) loop
      htp.p('  var option = document.createElement("option"); option.value="'||r__.id||'"; option.text = "'||replace(r__.label,'''','\''')||'"; option.selected = ((pvalue=='''||r__.id||''')?'' selected '':''''); x.add(option);');
    end loop;
    exception when others then
      raise_application_error('-20000','Error in LOV_MANAGER: '||sqlerrm);  
    end;
    htp.p('}');
    htp.prn('</script>');
    htp.prn('<script language="JavaScript">');
    htp.p('function js_CLOV_MFinit(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.value == ''M'') {  element.checked = true;  }  ');
    htp.p('          else { element.checked = false;  } ');
    htp.p('}');
    htp.p('function js_CLOV_MFclick(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.checked) { element.value=''M''; } else { element.value=''F'';}  ');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<script language="JavaScript">');
    htp.p('function js_CLOV_YNinit(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.value == ''Y'') {  element.checked = true;  }  ');
    htp.p('          else { element.checked = false;  } ');
    htp.p('}');
    htp.p('function js_CLOV_YNclick(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.checked) { element.value=''Y''; } else { element.value=''N'';}  ');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<script language="JavaScript">');
    htp.p('function js_Clov$SALCALinit(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.value == ''H'') {  element.checked = true;  }  ');
    htp.p('          else { element.checked = false;  } ');
    htp.p('}');
    htp.p('function js_Clov$SALCALclick(pvalue, pobjectname) {');
    htp.p('          var element = document.getElementById(pobjectname + ''_RASD'');  ');
    htp.p('          if (element.checked) { element.value=''H''; } else { element.value=''L'';}  ');
    htp.p('}');
    htp.p('</script>');
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('  try { for (j__ = 1; j__ <= 10; j__++) { ');
    htp.p(' if (  1==2 ');
    htp.p('	   || CheckFieldValue(''B10ENAME_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10JOB_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10MGR_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10HIREDATE_''+j__+'''','''') ');
    htp.p('	   || CheckFieldValue(''B10SAL_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10COMM_''+j__+''_RASD'','''') ');
    htp.p('	   || CheckFieldValue(''B10DEPTNO_''+j__+''_RASD'',''B10DEPTNO_''+j__+'''') ');
    htp.p('	   || CheckFieldValue(''B10NOTE_''+j__+''_RASD'','''') ');
    htp.p('  )');
    htp.p('  {');
    htp.p('   i = i + CheckFieldMandatory(''B10ENAME_''+j__+''_RASD'', '''');');
    htp.p('   i = i + CheckFieldMandatory(''B10JOB_''+j__+''_RASD'', '''');');
    htp.p('  }');
    htp.p('  } } catch(err) {');
    htp.p('      //alert(err.message);');
    htp.p('  }');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB20() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB25() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB30() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('  if ( cMFB10() == false ) { i++; } ');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','⛺ Demo - find employee')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="IMP_DEMO_FIELDS_LAB" class="rasdFormLab">⛺ Demo - find employee '|| rasd_client.getHtmlDataTable('IMP_DEMO_FIELDS_LAB') ||'     </div><div id="IMP_DEMO_FIELDS_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('IMP_DEMO_FIELDS_MENU') ||'     </div>
<form name="IMP_DEMO_FIELDS" method="post" action="!demo_fields.webclient"><div id="IMP_DEMO_FIELDS_DIV" class="rasdForm"><div id="IMP_DEMO_FIELDS_HEAD" class="rasdFormHead"><input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
<input name="RECNUMB10" id="RECNUMB10_RASD" type="hidden" value="'||ltrim(to_char(RECNUMB10))||'"/>
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick="javascript: '); js_link$link_save(GBUTTONSAVE,'GBUTTONSAVE'); 
htp.prn(' ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCUSTOM  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCUSTOM" id="GBUTTONCUSTOM_RASD" type="button" value="'||GBUTTONCUSTOM||'" class="rasdButton"/>');  end if;  
htp.prn('
<input name="ROWVALUE" id="ROWVALUE_RASD" type="hidden" value="'||ROWVALUE||'"/>
</div><div id="IMP_DEMO_FIELDS_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_DIV; htp.p(''); output_B20_DIV; htp.p(''); output_B25_DIV; htp.p(''); output_B30_DIV; htp.p('</div><div id="IMP_DEMO_FIELDS_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font>
</div><div id="IMP_DEMO_FIELDS_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="IMP_DEMO_FIELDS_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="IMP_DEMO_FIELDS_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONRES  then  
htp.prn('<input name="GBUTTONRES" id="GBUTTONRES_RASD" type="reset" value="'||GBUTTONRES||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONSAVE  then  
htp.prn('<input onclick="javascript: '); js_link$link_save(GBUTTONSAVE,'GBUTTONSAVE'); 
htp.prn(' ACTION.value=this.value; submit();" name="GBUTTONSAVE" id="GBUTTONSAVE_RASD" type="button" value="'||GBUTTONSAVE||'" class="rasdButton"/>');  end if;  
htp.prn('
');  
if  ShowFieldGBUTTONCUSTOM  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCUSTOM" id="GBUTTONCUSTOM_RASD" type="button" value="'||GBUTTONCUSTOM||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_FIELDS_FOOTER',1,instr('IMP_DEMO_FIELDS_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB20_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 or nvl(PAGE,0) = 4 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB25_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 3 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 or nvl(PAGE,0) = 3 or nvl(PAGE,0) = 4 then 
       return true;
    end if;
    return false;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="IMP_DEMO_FIELDS" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<page>'||PAGE||'</page>'); 
    htp.p('<recnumb10>'||RECNUMB10||'</recnumb10>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('<gbuttonsrc><![CDATA['||GBUTTONSRC||']]></gbuttonsrc>'); 
    htp.p('<gbuttonres><![CDATA['||GBUTTONRES||']]></gbuttonres>'); 
    htp.p('<gbuttonbck><![CDATA['||GBUTTONBCK||']]></gbuttonbck>'); 
    htp.p('<gbuttonfwd><![CDATA['||GBUTTONFWD||']]></gbuttonfwd>'); 
    htp.p('<gbuttonclr><![CDATA['||GBUTTONCLR||']]></gbuttonclr>'); 
    htp.p('<gbuttonsave><![CDATA['||GBUTTONSAVE||']]></gbuttonsave>'); 
    htp.p('<gbuttoncustom><![CDATA['||GBUTTONCUSTOM||']]></gbuttoncustom>'); 
    htp.p('<rowvalue><![CDATA['||ROWVALUE||']]></rowvalue>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<pename><![CDATA['||PENAME(1)||']]></pename>'); 
    htp.p('<pxxxx>'||PXXXX(1)||'</pxxxx>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
  for i__ in 1..
B10RID
.count loop 
    htp.p('<element>'); 
    htp.p('<b10rs><![CDATA['||B10RS(i__)||']]></b10rs>'); 
    htp.p('<b10rid>'||B10RID(i__)||'</b10rid>'); 
    htp.p('<b10empno>'||B10EMPNO(i__)||'</b10empno>'); 
    htp.p('<b10ename><![CDATA['||B10ENAME(i__)||']]></b10ename>'); 
    htp.p('<b10job><![CDATA['||B10JOB(i__)||']]></b10job>'); 
    htp.p('<b10mgr>'||B10MGR(i__)||'</b10mgr>'); 
    htp.p('<b10hiredate>'||B10HIREDATE(i__)||'</b10hiredate>'); 
    htp.p('<b10sal>'||B10SAL(i__)||'</b10sal>'); 
    htp.p('<b10salcalc><![CDATA['||B10SALCALC(i__)||']]></b10salcalc>'); 
    htp.p('<b10comm>'||B10COMM(i__)||'</b10comm>'); 
    htp.p('<b10deptno>'||B10DEPTNO(i__)||'</b10deptno>'); 
    htp.p('<b10hiredatecalc>'||B10HIREDATECALC(i__)||'</b10hiredatecalc>'); 
    htp.p('<b10note><![CDATA['||B10NOTE(i__)||']]></b10note>'); 
    htp.p('<b10job2><![CDATA['||B10JOB2(i__)||']]></b10job2>'); 
    htp.p('<b10job3><![CDATA['||B10JOB3(i__)||']]></b10job3>'); 
    htp.p('<b10btnsub><![CDATA['||B10BTNSUB(i__)||']]></b10btnsub>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p('<b20>'); 
    htp.p('<element>'); 
    htp.p('<b20reset_data><![CDATA['||B20RESET_DATA(1)||']]></b20reset_data>'); 
    htp.p('<b20submit_data><![CDATA['||B20SUBMIT_DATA(1)||']]></b20submit_data>'); 
    htp.p('</element>'); 
  htp.p('</b20>'); 
  end if; 
    if ShowBlockb25_DIV then 
    htp.p('<b25>'); 
    htp.p('<element>'); 
    htp.p('<b25checkbox_def><![CDATA['||B25CHECKBOX_DEF(1)||']]></b25checkbox_def>'); 
    htp.p('<b25checkbox_cust><![CDATA['||B25CHECKBOX_CUST(1)||']]></b25checkbox_cust>'); 
    htp.p('</element>'); 
  htp.p('</b25>'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p('<b30>'); 
    htp.p('<element>'); 
    htp.p('<b30messag1><![CDATA['||B30MESSAG1(1)||']]></b30messag1>'); 
    htp.p('<b30execplsqlonui><![CDATA['||B30EXECPLSQLONUI(1)||']]></b30execplsqlonui>'); 
    htp.p('</element>'); 
  htp.p('</b30>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"IMP_DEMO_FIELDS","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"page":"'||PAGE||'"'); 
    htp.p(',"recnumb10":"'||RECNUMB10||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p(',"gbuttonsrc":"'||escapeRest(GBUTTONSRC)||'"'); 
    htp.p(',"gbuttonres":"'||escapeRest(GBUTTONRES)||'"'); 
    htp.p(',"gbuttonbck":"'||escapeRest(GBUTTONBCK)||'"'); 
    htp.p(',"gbuttonfwd":"'||escapeRest(GBUTTONFWD)||'"'); 
    htp.p(',"gbuttonclr":"'||escapeRest(GBUTTONCLR)||'"'); 
    htp.p(',"gbuttonsave":"'||escapeRest(GBUTTONSAVE)||'"'); 
    htp.p(',"gbuttoncustom":"'||escapeRest(GBUTTONCUSTOM)||'"'); 
    htp.p(',"rowvalue":"'||escapeRest(ROWVALUE)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"pename":"'||escapeRest(PENAME(1))||'"'); 
    htp.p(',"pxxxx":"'||PXXXX(1)||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
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
    htp.p('"b10rs":"'||escapeRest(B10RS(i__))||'"'); 
    htp.p(',"b10rid":"'||B10RID(i__)||'"'); 
    htp.p(',"b10empno":"'||B10EMPNO(i__)||'"'); 
    htp.p(',"b10ename":"'||escapeRest(B10ENAME(i__))||'"'); 
    htp.p(',"b10job":"'||escapeRest(B10JOB(i__))||'"'); 
    htp.p(',"b10mgr":"'||B10MGR(i__)||'"'); 
    htp.p(',"b10hiredate":"'||B10HIREDATE(i__)||'"'); 
    htp.p(',"b10sal":"'||B10SAL(i__)||'"'); 
    htp.p(',"b10salcalc":"'||escapeRest(B10SALCALC(i__))||'"'); 
    htp.p(',"b10comm":"'||B10COMM(i__)||'"'); 
    htp.p(',"b10deptno":"'||B10DEPTNO(i__)||'"'); 
    htp.p(',"b10hiredatecalc":"'||B10HIREDATECALC(i__)||'"'); 
    htp.p(',"b10note":"'||escapeRest(B10NOTE(i__))||'"'); 
    htp.p(',"b10job2":"'||escapeRest(B10JOB2(i__))||'"'); 
    htp.p(',"b10job3":"'||escapeRest(B10JOB3(i__))||'"'); 
    htp.p(',"b10btnsub":"'||escapeRest(B10BTNSUB(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b10":[]'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p(',"b20":['); 
     htp.p('{'); 
    htp.p('"b20reset_data":"'||escapeRest(B20RESET_DATA(1))||'"'); 
    htp.p(',"b20submit_data":"'||escapeRest(B20SUBMIT_DATA(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b20":[]'); 
  end if; 
    if ShowBlockb25_DIV then 
    htp.p(',"b25":['); 
     htp.p('{'); 
    htp.p('"b25checkbox_def":"'||escapeRest(B25CHECKBOX_DEF(1))||'"'); 
    htp.p(',"b25checkbox_cust":"'||escapeRest(B25CHECKBOX_CUST(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b25":[]'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p(',"b30":['); 
     htp.p('{'); 
    htp.p('"b30messag1":"'||escapeRest(B30MESSAG1(1))||'"'); 
    htp.p(',"b30execplsqlonui":"'||escapeRest(B30EXECPLSQLONUI(1))||'"'); 
    htp.p('}'); 
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
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('IMP_DEMO_FIELDS',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
    pselect;
    poutput;
  elsif ACTION = GBUTTONBCK then     if RECNUMB10 > 10 then
      RECNUMB10 := RECNUMB10-10;
    else
      RECNUMB10 := 1;
    end if;
    pselect;
    poutput;
  elsif ACTION = GBUTTONFWD then     RECNUMB10 := RECNUMB10+10;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC then     RECNUMB10 := 1;
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

--<POST_ACTION formid="71" blockid="">
if ACTION = 'Submit me' then
  pselect;
  B30MESSAG1(1) := 'You pressed custom submit button! Checkbox default is '||B25CHECKBOX_DEF(1)|| ' and Checkbox Male/Female is '||B25CHECKBOX_CUST(1);
  message := 'You have clicked "Submit me"';
  poutput;
elsif ACTION = 'Create error' then
raise_application_error('-20000', 'Program error!!!!');

elsif ACTION = 'Submit row!' then
  pselect;
  if ROWVALUE is not null then
     message := 'You submitted row with EMP number '||ROWVALUE;
  end if;  
  poutput;
end if;

--</POST_ACTION>
    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.p('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','⛺ Demo - find employee')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="IMP_DEMO_FIELDS_LAB" class="rasdFormLab">⛺ Demo - find employee '|| rasd_client.getHtmlDataTable('IMP_DEMO_FIELDS_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'IMP_DEMO_FIELDS' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_FIELDS_FOOTER',1,instr('IMP_DEMO_FIELDS_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('IMP_DEMO_FIELDS',ACTION);  
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

--<POST_ACTION formid="71" blockid="">
if ACTION = 'Submit me' then
  pselect;
  B30MESSAG1(1) := 'You pressed custom submit button! Checkbox default is '||B25CHECKBOX_DEF(1)|| ' and Checkbox Male/Female is '||B25CHECKBOX_CUST(1);
  message := 'You have clicked "Submit me"';
  poutput;
elsif ACTION = 'Create error' then
raise_application_error('-20000', 'Program error!!!!');

elsif ACTION = 'Submit row!' then
  pselect;
  if ROWVALUE is not null then
     message := 'You submitted row with EMP number '||ROWVALUE;
  end if;  
  poutput;
end if;

--</POST_ACTION>
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
  rasd_client.secCheckPermission('IMP_DEMO_FIELDS',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONBCK then     if RECNUMB10 > 10 then
      RECNUMB10 := RECNUMB10-10;
    else
      RECNUMB10 := 1;
    end if;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONFWD then     RECNUMB10 := RECNUMB10+10;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC or ACTION is null  then     RECNUMB10 := 1;
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

--<POST_ACTION formid="71" blockid="">
if ACTION = 'Submit me' then
  pselect;
  B30MESSAG1(1) := 'You pressed custom submit button! Checkbox default is '||B25CHECKBOX_DEF(1)|| ' and Checkbox Male/Female is '||B25CHECKBOX_CUST(1);
  message := 'You have clicked "Submit me"';
  poutput;
elsif ACTION = 'Create error' then
raise_application_error('-20000', 'Program error!!!!');

elsif ACTION = 'Submit row!' then
  pselect;
  if ROWVALUE is not null then
     message := 'You submitted row with EMP number '||ROWVALUE;
  end if;  
  poutput;
end if;

--</POST_ACTION>
-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="IMP_DEMO_FIELDS" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"IMP_DEMO_FIELDS","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>71</formid><form>IMP_DEMO_FIELDS</form><version>1</version><change>30.01.2020 12/30/06</change><user>RASDCLI</user><label><![CDATA[⛺ Demo - find employee]]></label><lobid>RASD</lobid><program>!demo_fields.webclient</program><referenceyn></referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>30.01.2020 12/27/17</change><compileyn>N</compileyn><application>imported form</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  HTP.p('Content-Disposition: filename="Export_IMP_DEMO_FIELDS_v.1.1.20200130003006.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end IMP_DEMO_FIELDS;
/

