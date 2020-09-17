create or replace package DEMO_CHARTSJS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_CHARTSJS generated on 05.02.20 by user RASDCLI.     
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

create or replace package body DEMO_CHARTSJS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_CHARTSJS generated on 05.02.20 by user RASDCLI.    
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
  RESTRESTYPE varchar2(4000);  RECNUMB10                     varchar2(4000) := 1
;
  ACTION                        varchar2(4000);
  ERROR                         varchar2(4000);  GBUTTONCLR                    varchar2(4000) := 'GBUTTONCLR'
;  GBUTTONRES                    varchar2(4000) := 'GBUTTONRES'
;  GBUTTONSAVE                   varchar2(4000) := 'GBUTTONSAVE'
;  GBUTTONSRC                    varchar2(4000) := 'GBUTTONSRC'
;
  MESSAGE                       varchar2(4000);  PAGE                          number := 0
;
  WARNING                       varchar2(4000);
  GRAPH_DATA                    varchar2(4000);
  GRAPH_LABELS                  varchar2(4000);
  PTEXT                         ctab;
  B10ENAME                      ctab;
  B10SAL                        ntab;
  B10DEPTNO                     ntab;
  B10NOTE                       ctab;
  B20LINE                       ctab;
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
        rasd_client.callLog('DEMO_CHARTSJS',v_clob, systimestamp, '' );
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>  
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
   return 'v.1.1.20200205142115'; 
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
if PTEXT(i__) is null then vc := rasd_client.sessionGetValue('PTEXT'); PTEXT(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('RECNUMB10') then RECNUMB10 := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCLR') then GBUTTONCLR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSAVE') then GBUTTONSAVE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GRAPH_DATA') then GRAPH_DATA := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GRAPH_LABELS') then GRAPH_LABELS := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PTEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10SAL(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10DEPTNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10NOTE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10NOTE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20LINE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20LINE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT') and PTEXT.count = 0 and value_array(i__) is not null then
        PTEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ENAME') and B10ENAME.count = 0 and value_array(i__) is not null then
        B10ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10SAL') and B10SAL.count = 0 and value_array(i__) is not null then
        B10SAL(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO') and B10DEPTNO.count = 0 and value_array(i__) is not null then
        B10DEPTNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10NOTE') and B10NOTE.count = 0 and value_array(i__) is not null then
        B10NOTE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B20LINE') and B20LINE.count = 0 and value_array(i__) is not null then
        B20LINE(1) := value_array(i__);
      end if;
    end loop;
-- organize records
declare
v_last number := 
B10ENAME
.last;
v_curr number := 
B10ENAME
.first;
i__ number;
begin
 if v_last <> 
B10ENAME
.count then 
   v_curr := 
B10ENAME
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B10ENAME.exists(v_curr) then B10ENAME(i__) := B10ENAME(v_curr); end if;
      if B10SAL.exists(v_curr) then B10SAL(i__) := B10SAL(v_curr); end if;
      if B10DEPTNO.exists(v_curr) then B10DEPTNO(i__) := B10DEPTNO(v_curr); end if;
      if B10NOTE.exists(v_curr) then B10NOTE(i__) := B10NOTE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B10ENAME
.NEXT(v_curr);  
   END LOOP;
      B10ENAME.DELETE(i__ , v_last);
      B10SAL.DELETE(i__ , v_last);
      B10DEPTNO.DELETE(i__ , v_last);
      B10NOTE.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if B10ENAME.count > v_max then v_max := B10ENAME.count; end if;
    if B10SAL.count > v_max then v_max := B10SAL.count; end if;
    if B10DEPTNO.count > v_max then v_max := B10DEPTNO.count; end if;
    if B10NOTE.count > v_max then v_max := B10NOTE.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B10ENAME.exists(i__) then
        B10ENAME(i__) := null;
      end if;
      if not B10SAL.exists(i__) then
        B10SAL(i__) := to_number(null);
      end if;
      if not B10DEPTNO.exists(i__) then
        B10DEPTNO(i__) := to_number(null);
      end if;
      if not B10NOTE.exists(i__) then
        B10NOTE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B20LINE.count > v_max then v_max := B20LINE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B20LINE.exists(i__) then
        B20LINE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if PTEXT.count > v_max then v_max := PTEXT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PTEXT.exists(i__) then
        PTEXT(i__) := null;
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="72" blockid="">
PTEXT(1) := 'Sample of ChartJS. Documentation on <a target="_blank" href="https://www.chartjs.org/docs/latest/charts/">https://www.chartjs.org/</a>';
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
        PTEXT(i__) := null;

      end loop;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 0 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B10ENAME
.count(); end if;
      else  
       if i__ > 0 then  k__ := i__ + 0;
       else k__ := 0 + 0;
       end if;
      end if;
      j__ := i__;
      for i__ in 1..j__ loop
      null;
      end loop;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10ENAME(i__) := null;
        B10SAL(i__) := null;
        B10DEPTNO(i__) := null;
        B10NOTE(i__) := null;

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
        B20LINE(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    RECNUMB10 := 1;
    ERROR := null;
    GBUTTONCLR := 'GBUTTONCLR';
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSAVE := 'GBUTTONSAVE';
    GBUTTONSRC := 'GBUTTONSRC';
    MESSAGE := null;
    PAGE := 0;
    WARNING := null;
    GRAPH_DATA := null;
    GRAPH_LABELS := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);
    pclear_B10(0);
    pclear_B20(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PTEXT.count);
  null; end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      B10ENAME.delete;
      B10SAL.delete;
      B10DEPTNO.delete;
      B10NOTE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="72" blockid="B10">
SELECT 
ENAME,
SAL,
DEPTNO,
NOTE FROM EMP 
--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B10ENAME(i__)
           ,B10SAL(i__)
           ,B10DEPTNO(i__)
           ,B10NOTE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.

--<post_select formid="72" blockid="B10">
graph_labels := graph_labels||','''||B10ENAME(i__)||'''';
graph_data := graph_data||','||B10SAL(i__);




--</post_select>
            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B10ENAME.delete(1);
          B10SAL.delete(1);
          B10DEPTNO.delete(1);
          B10NOTE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B10(B10ENAME.count);
  null; end;
  procedure pselect_B20 is
    i__ pls_integer;
  begin
      pclear_B20(B20LINE.count);
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
    for i__ in 1..PTEXT.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10ENAME.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if 1=2 then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B20 is
  begin
    for i__ in 1..B20LINE.count loop
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
  function ShowFieldGBUTTONCLR return boolean is 
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
  function ShowFieldGRAPH_DATA return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGRAPH_LABELS return boolean is 
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
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock">Employees salary</div></caption><table border="1" id="B10_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10ENAME"><span id="B10ENAME_LAB" class="label">Ename</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10SAL"><span id="B10SAL_LAB" class="label">Sal</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10DEPTNO"><span id="B10DEPTNO_LAB" class="label">Deptno</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10NOTE"><span id="B10NOTE_LAB" class="label">Note</span></td></tr></thead>'); for iB10 in 1..B10ENAME.count loop 
htp.prn('<tr id="B10_BLOCK"><td class="rasdTxB10ENAME rasdTxTypeC" id="rasdTxB10ENAME_'||iB10||'"><font id="B10ENAME_'||iB10||'_RASD" class="rasdFont">'||B10ENAME(iB10)||'</font></td><td class="rasdTxB10SAL rasdTxTypeN" id="rasdTxB10SAL_'||iB10||'"><font id="B10SAL_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10SAL(iB10)))||'</font></td><td class="rasdTxB10DEPTNO rasdTxTypeN" id="rasdTxB10DEPTNO_'||iB10||'"><font id="B10DEPTNO_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10DEPTNO(iB10)))||'</font></td><td class="rasdTxB10NOTE rasdTxTypeC" id="rasdTxB10NOTE_'||iB10||'"><font id="B10NOTE_'||iB10||'_RASD" class="rasdFont">'||B10NOTE(iB10)||'</font></td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure pre_output_B20_DIV is  begin
--<pre_ui formid="72" blockid="B20">
--vv
null;
--</pre_ui>
  end;
procedure output_B20_DIV is begin htp.p('');  if  ShowBlockB20_DIV  then  
htp.prn('<div  id="B20_DIV" class="rasdblock"><div>
<caption><div id="B20_LAB" class="labelblock">Chart</div><div><canvas id=myChart>GRAF</canvas></div></caption>
<table border="0" id="B20_TABLE"><tr id="B20_BLOCK"><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20LINE"><span id="B20LINE_LAB" class="label"></span></td><td class="rasdTxB20LINE rasdTxTypeC" id="rasdTxB20LINE_1"><span id="B20LINE_1_RASD">');  htp.p('
<script type="text/javascript">
  $(function() {
  
var ctx = document.getElementById(''myChart'').getContext(''2d'');
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: ''line'',

    // The data for our dataset
    data: {
        labels: ['||substr(graph_labels,2)||'],
        datasets: [{
            label: ''My graph'',
            borderColor: ''rgb(255, 99, 132)'',
            data: ['||substr(graph_data,2)||']
        }         ]
    },
    // Configuration options go here
    options: {}
});  
  
  });	  
	  
	  
</script>
');  
htp.prn('</span></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPTEXT"><span id="PTEXT_LAB" class="label"></span></td><td class="rasdTxPTEXT rasdTxTypeC" id="rasdTxPTEXT_1"><font id="PTEXT_1_RASD" class="rasdFont">'||PTEXT(1)||'</font></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB10() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB20() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo ChartsJS')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_CHARTSJS_LAB" class="rasdFormLab">Demo ChartsJS '|| rasd_client.getHtmlDataTable('DEMO_CHARTSJS_LAB') ||'     </div><div id="DEMO_CHARTSJS_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_CHARTSJS_MENU') ||'     </div>
<form name="DEMO_CHARTSJS" method="post" action="?"><div id="DEMO_CHARTSJS_DIV" class="rasdForm"><div id="DEMO_CHARTSJS_HEAD" class="rasdFormHead"><input name="RECNUMB10" id="RECNUMB10_RASD" type="hidden" value="'||RECNUMB10||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
<input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
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
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="DEMO_CHARTSJS_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_DIV; htp.p(''); pre_output_B20_DIV; output_B20_DIV; htp.p('</div><div id="DEMO_CHARTSJS_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_CHARTSJS_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_CHARTSJS_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_CHARTSJS_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
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
if  ShowFieldGBUTTONCLR  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONCLR" id="GBUTTONCLR_RASD" type="button" value="'||GBUTTONCLR||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('DEMO_CHARTSJS_FOOTER',1,instr('DEMO_CHARTSJS_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockP_DIV return boolean is 
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
    htp.p('<form name="DEMO_CHARTSJS" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<recnumb10><![CDATA['||RECNUMB10||']]></recnumb10>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<gbuttonclr><![CDATA['||GBUTTONCLR||']]></gbuttonclr>'); 
    htp.p('<gbuttonres><![CDATA['||GBUTTONRES||']]></gbuttonres>'); 
    htp.p('<gbuttonsave><![CDATA['||GBUTTONSAVE||']]></gbuttonsave>'); 
    htp.p('<gbuttonsrc><![CDATA['||GBUTTONSRC||']]></gbuttonsrc>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<page>'||PAGE||'</page>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<ptext><![CDATA['||PTEXT(1)||']]></ptext>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
  for i__ in 1..
B10ENAME
.count loop 
    htp.p('<element>'); 
    htp.p('<b10ename><![CDATA['||B10ENAME(i__)||']]></b10ename>'); 
    htp.p('<b10sal>'||B10SAL(i__)||'</b10sal>'); 
    htp.p('<b10deptno>'||B10DEPTNO(i__)||'</b10deptno>'); 
    htp.p('<b10note><![CDATA['||B10NOTE(i__)||']]></b10note>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p('<b20>'); 
    htp.p('<element>'); 
    htp.p('<b20line><![CDATA['||B20LINE(1)||']]></b20line>'); 
    htp.p('</element>'); 
  htp.p('</b20>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_CHARTSJS","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"recnumb10":"'||escapeRest(RECNUMB10)||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"gbuttonclr":"'||escapeRest(GBUTTONCLR)||'"'); 
    htp.p(',"gbuttonres":"'||escapeRest(GBUTTONRES)||'"'); 
    htp.p(',"gbuttonsave":"'||escapeRest(GBUTTONSAVE)||'"'); 
    htp.p(',"gbuttonsrc":"'||escapeRest(GBUTTONSRC)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"page":"'||PAGE||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"ptext":"'||escapeRest(PTEXT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
  v_firstrow__ := true;
  for i__ in 1..
B10ENAME
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b10ename":"'||escapeRest(B10ENAME(i__))||'"'); 
    htp.p(',"b10sal":"'||B10SAL(i__)||'"'); 
    htp.p(',"b10deptno":"'||B10DEPTNO(i__)||'"'); 
    htp.p(',"b10note":"'||escapeRest(B10NOTE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b10":[]'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p(',"b20":['); 
     htp.p('{'); 
    htp.p('"b20line":"'||escapeRest(B20LINE(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b20":[]'); 
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
  rasd_client.secCheckPermission('DEMO_CHARTSJS',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
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

  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.p('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Demo ChartsJS')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DEMO_CHARTSJS_LAB" class="rasdFormLab">Demo ChartsJS '|| rasd_client.getHtmlDataTable('DEMO_CHARTSJS_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'DEMO_CHARTSJS' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DEMO_CHARTSJS_FOOTER',1,instr('DEMO_CHARTSJS_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DEMO_CHARTSJS',ACTION);  
  if ACTION = GBUTTONSAVE then     pselect;
    pcommit;
  end if;

  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your oown.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR, GBUTTONSAVE ) then 
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
  rasd_client.secCheckPermission('DEMO_CHARTSJS',ACTION);  
  if ACTION is null then null;
    RECNUMB10 := 1;
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

  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC, GBUTTONSAVE, GBUTTONCLR ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="DEMO_CHARTSJS" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_CHARTSJS","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>72</formid><form>DEMO_CHARTSJS</form><version>1</version><change>05.02.2020 02/21/15</change><user>RASDCLI</user><label><![CDATA[Demo ChartsJS]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>05.02.2020 09/35/44</change><compileyn>N</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  HTP.p('Content-Disposition: filename="Export_DEMO_CHARTSJS_v.1.1.20200205142115.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end DEMO_CHARTSJS;
/

