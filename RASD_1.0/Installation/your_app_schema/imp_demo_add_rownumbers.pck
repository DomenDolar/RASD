create or replace package IMP_DEMO_ADD_ROWNUMBERS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_ADD_ROWNUMBERS generated on 30.01.20 by user RASDCLI.     
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

create or replace package body IMP_DEMO_ADD_ROWNUMBERS is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: IMP_DEMO_ADD_ROWNUMBERS generated on 30.01.20 by user RASDCLI.    
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
  ERROR                         varchar2(4000);  GBUTTONBCK                    varchar2(4000) := 'GBUTTONBCK'
;  GBUTTONCLR                    varchar2(4000) := 'GBUTTONCLR'
;  GBUTTONFWD                    varchar2(4000) := 'GBUTTONFWD'
;
  GBUTTONFWD#SET                 set_type;  GBUTTONRES                    varchar2(4000) := 'GBUTTONRES'
;  GBUTTONSAVE                   varchar2(4000) := 'GBUTTONSAVE'
;  GBUTTONSRC                    varchar2(4000) := 'GBUTTONSRC'
;
  MESSAGE                       varchar2(4000);  PAGE                          number := 0
;
  WARNING                       varchar2(4000);
  JSDYN                         varchar2(4000);
  PTEXT                         ctab;
  B10RS                         ctab;
  B10ROWNUMB                    ntab;
  B10ROWNUMB#SET                 stab;
  B10EMPNO                      ntab;
  B10ENAME                      ctab;
  B10JOB                        ctab;
  B10MGR                        ntab;
  B10MGR#SET                     stab;
  B10HIREDATE                   dtab;
  B10SAL                        ntab;
  B10COMM                       ntab;
  B10DEPTNO                     ntab;
  B10NOTE                       ctab;
  B10NOTE#SET                    stab;
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
        rasd_client.callLog('IMP_DEMO_ADD_ROWNUMBERS',v_clob, systimestamp, '' );
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
$(window).bind("load", function() {
       // alert(''Look into -> CSS, JS source -> FORM_JS : Start loading page '');

   showErrorFields();

});

document.onreadystatechange = function(){
     if(document.readyState === ''complete''){
       // alert(''Look into -> CSS, JS source -> FORM_JS : Loading page finihed'');
     }
}



        ';
       end; 
     function form_css return clob is
       begin
        return '
.rasdTxB10NOTE{
 background : lightblue;
}

.rasdTxTypeN {
   text-align : right;   
}

#rasdTxB10ENAME_2 {
 background : red;
}

'|| jsdyn ||'

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
   return 'v.1.1.20200130093249'; 
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
      elsif  upper(name_array(i__)) = upper('GBUTTONBCK') then GBUTTONBCK := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONCLR') then GBUTTONCLR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONFWD') then GBUTTONFWD := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSAVE') then GBUTTONSAVE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('JSDYN') then JSDYN := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PTEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10RS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ROWNUMB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10ROWNUMB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10EMPNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10EMPNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10ENAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10ENAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10JOB(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10MGR_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10MGR(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10HIREDATE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('B10SAL_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10SAL(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10COMM_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10COMM(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10DEPTNO(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10NOTE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10NOTE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT') and PTEXT.count = 0 and value_array(i__) is not null then
        PTEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10RS') and B10RS.count = 0 and value_array(i__) is not null then
        B10RS(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10ROWNUMB') and B10ROWNUMB.count = 0 and value_array(i__) is not null then
        B10ROWNUMB(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10EMPNO') and B10EMPNO.count = 0 and value_array(i__) is not null then
        B10EMPNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10ENAME') and B10ENAME.count = 0 and value_array(i__) is not null then
        B10ENAME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10JOB') and B10JOB.count = 0 and value_array(i__) is not null then
        B10JOB(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10MGR') and B10MGR.count = 0 and value_array(i__) is not null then
        B10MGR(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10HIREDATE') and B10HIREDATE.count = 0 and value_array(i__) is not null then
        B10HIREDATE(1) := to_date(value_array(i__), rasd_client.c_date_format);
      elsif  upper(name_array(i__)) = upper('B10SAL') and B10SAL.count = 0 and value_array(i__) is not null then
        B10SAL(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10COMM') and B10COMM.count = 0 and value_array(i__) is not null then
        B10COMM(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10DEPTNO') and B10DEPTNO.count = 0 and value_array(i__) is not null then
        B10DEPTNO(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B10NOTE') and B10NOTE.count = 0 and value_array(i__) is not null then
        B10NOTE(1) := value_array(i__);
      end if;
    end loop;
-- organize records
declare
v_last number := 
B10EMPNO
.last;
v_curr number := 
B10EMPNO
.first;
i__ number;
begin
 if v_last <> 
B10EMPNO
.count then 
   v_curr := 
B10EMPNO
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B10RS.exists(v_curr) then B10RS(i__) := B10RS(v_curr); end if;
      if B10ROWNUMB.exists(v_curr) then B10ROWNUMB(i__) := B10ROWNUMB(v_curr); end if;
      if B10EMPNO.exists(v_curr) then B10EMPNO(i__) := B10EMPNO(v_curr); end if;
      if B10ENAME.exists(v_curr) then B10ENAME(i__) := B10ENAME(v_curr); end if;
      if B10JOB.exists(v_curr) then B10JOB(i__) := B10JOB(v_curr); end if;
      if B10MGR.exists(v_curr) then B10MGR(i__) := B10MGR(v_curr); end if;
      if B10HIREDATE.exists(v_curr) then B10HIREDATE(i__) := B10HIREDATE(v_curr); end if;
      if B10SAL.exists(v_curr) then B10SAL(i__) := B10SAL(v_curr); end if;
      if B10COMM.exists(v_curr) then B10COMM(i__) := B10COMM(v_curr); end if;
      if B10DEPTNO.exists(v_curr) then B10DEPTNO(i__) := B10DEPTNO(v_curr); end if;
      if B10NOTE.exists(v_curr) then B10NOTE(i__) := B10NOTE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B10EMPNO
.NEXT(v_curr);  
   END LOOP;
      B10RS.DELETE(i__ , v_last);
      B10ROWNUMB.DELETE(i__ , v_last);
      B10EMPNO.DELETE(i__ , v_last);
      B10ENAME.DELETE(i__ , v_last);
      B10JOB.DELETE(i__ , v_last);
      B10MGR.DELETE(i__ , v_last);
      B10HIREDATE.DELETE(i__ , v_last);
      B10SAL.DELETE(i__ , v_last);
      B10COMM.DELETE(i__ , v_last);
      B10DEPTNO.DELETE(i__ , v_last);
      B10NOTE.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if B10RS.count > v_max then v_max := B10RS.count; end if;
    if B10ROWNUMB.count > v_max then v_max := B10ROWNUMB.count; end if;
    if B10EMPNO.count > v_max then v_max := B10EMPNO.count; end if;
    if B10ENAME.count > v_max then v_max := B10ENAME.count; end if;
    if B10JOB.count > v_max then v_max := B10JOB.count; end if;
    if B10MGR.count > v_max then v_max := B10MGR.count; end if;
    if B10HIREDATE.count > v_max then v_max := B10HIREDATE.count; end if;
    if B10SAL.count > v_max then v_max := B10SAL.count; end if;
    if B10COMM.count > v_max then v_max := B10COMM.count; end if;
    if B10DEPTNO.count > v_max then v_max := B10DEPTNO.count; end if;
    if B10NOTE.count > v_max then v_max := B10NOTE.count; end if;
    if v_max = 0 then v_max := 10; end if;
    for i__ in 1..v_max loop
      if not B10RS.exists(i__) then
        B10RS(i__) := null;
      end if;
      if not B10ROWNUMB.exists(i__) then
        B10ROWNUMB(i__) := to_number(null);
      end if;
      if not B10ROWNUMB#SET.exists(i__) then
        B10ROWNUMB#SET(i__).visible := true;
      end if;
      if not B10EMPNO.exists(i__) then
        B10EMPNO(i__) := 9999;
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
      if not B10MGR#SET.exists(i__) then
        B10MGR#SET(i__).visible := true;
      end if;
      if not B10HIREDATE.exists(i__) then
        B10HIREDATE(i__) := to_date(null);
      end if;
      if not B10SAL.exists(i__) then
        B10SAL(i__) := to_number(null);
      end if;
      if not B10COMM.exists(i__) then
        B10COMM(i__) := to_number(null);
      end if;
      if not B10DEPTNO.exists(i__) then
        B10DEPTNO(i__) := to_number(null);
      end if;
      if not B10NOTE.exists(i__) then
        B10NOTE(i__) := null;
      end if;
      if not B10NOTE#SET.exists(i__) then
        B10NOTE#SET(i__).visible := true;
      end if;
--<on_new_record formid="71" blockid="B10">
B10EMPNO.delete(B10EMPNO.count); -- first selected element on block 
exit;



--</on_new_record>
    null; end loop;
    v_max := 0;
    if PTEXT.count > v_max then v_max := PTEXT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PTEXT.exists(i__) then
        PTEXT(i__) := 'Rownum added in field RN. SELECTed values are set in trigger POST_SELECT, new in ON_NEW_RECORD.';
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
        PTEXT(i__) := 'Rownum added in field RN. SELECTed values are set in trigger POST_SELECT, new in ON_NEW_RECORD.';

      end loop;
  end;
  procedure pclear_B10(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 10 = 0 then k__ := i__ + 1;
 if pstart = 0 then k__ := k__ + 
B10EMPNO
.count(); end if;
      else  
       if i__ > 10 then  k__ := i__ + 1;
       else k__ := 1 + 10;
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
      B10ROWNUMB(i__) := B10ROWNUMB(i__);
      exception when others then
        B10ROWNUMB(i__) := null;

      end;
      begin
      B10COMM(i__) := B10COMM(i__);
      exception when others then
        B10COMM(i__) := null;

      end;
      begin
      B10DEPTNO(i__) := B10DEPTNO(i__);
      exception when others then
        B10DEPTNO(i__) := null;

      end;
      begin
      B10ROWNUMB#SET(i__) := B10ROWNUMB#SET(i__);
      exception when others then
        B10ROWNUMB#SET(i__).visible := true;

      end;
      begin
      B10MGR#SET(i__) := B10MGR#SET(i__);
      exception when others then
        B10MGR#SET(i__).visible := true;

      end;
      begin
      B10NOTE#SET(i__) := B10NOTE#SET(i__);
      exception when others then
        B10NOTE#SET(i__).visible := true;

      end;
      null;
      end loop;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10RS(i__) := null;
        B10ROWNUMB(i__) := null;
        B10EMPNO(i__) := 9999;
        B10ENAME(i__) := null;
        B10JOB(i__) := null;
        B10MGR(i__) := null;
        B10HIREDATE(i__) := null;
        B10SAL(i__) := null;
        B10COMM(i__) := null;
        B10DEPTNO(i__) := null;
        B10NOTE(i__) := null;
        B10ROWNUMB#SET(i__).visible := true;
        B10MGR#SET(i__).visible := true;
        B10NOTE#SET(i__).visible := true;

--<on_new_record formid="71" blockid="B10">
B10EMPNO.delete(B10EMPNO.count); -- first selected element on block 
exit;



--</on_new_record>
      end loop;
  end;
  procedure pclear_form is
  begin
    RECNUMB10 := 1;
    ERROR := null;
    GBUTTONBCK := 'GBUTTONBCK';
    GBUTTONCLR := 'GBUTTONCLR';
    GBUTTONFWD := 'GBUTTONFWD';
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSAVE := 'GBUTTONSAVE';
    GBUTTONSRC := 'GBUTTONSRC';
    MESSAGE := null;
    PAGE := 0;
    WARNING := null;
    JSDYN := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);
    pclear_B10(0);

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
      B10EMPNO.delete;
      B10ENAME.delete;
      B10JOB.delete;
      B10MGR.delete;
      B10HIREDATE.delete;
      B10SAL.delete;
      B10NOTE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
--<SQL formid="71" blockid="B10">
SELECT 
EMPNO,
ENAME,
JOB,
MGR,
HIREDATE,
SAL,
NOTE FROM EMP 

--</SQL>
;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B10EMPNO(i__)
           ,B10ENAME(i__)
           ,B10JOB(i__)
           ,B10MGR(i__)
           ,B10HIREDATE(i__)
           ,B10SAL(i__)
           ,B10NOTE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  nvl(RECNUMB10,1) then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.

--<post_select formid="71" blockid="B10">
B10ROWNUMB(i__) := i__ + RECNUMB10 - 1 ;

if B10NOTE(i__) <> 'note' then
   B10NOTE#SET(i__).visible := false;
--else
  -- B10NOTE#SET(i__).info := 'Info note';
end if;

if B10ENAME(i__) = 'SMITH' then


B10MGR#SET(i__).required := true;

B10MGR#SET(i__).error := 'Error on SMITH';
B10MGR#SET(i__).info := 'Info MGR on SMITH';

B10NOTE#SET(i__).info := 'Info NOTE on SMITH';

end if;


if B10ENAME(i__) = 'MARTIN' then


B10MGR#SET(i__).error := 'Error on MARTIN';
B10NOTE#SET(i__).error := 'Error on MARTIN note';


end if;



if B10ROWNUMB(i__) > 1 then
  B10ROWNUMB#SET(i__).visible := true;
  B10ROWNUMB#SET(i__).custom := 'style="background: red;" ';
  
  JSDYN := jsdyn || '  
#rasdTxB10ROWNUMB_'||i__||' {
 background : lightblue;
} 
  ';
  
end if;

if B10ROWNUMB(i__) = 13 then

  GBUTTONFWD#SET.visible := false;
  
end if;

message := 'Page '||(floor( RECNUMB10 /10)+1) ||'.';

--</post_select>
            exit when i__ =10;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  nvl(RECNUMB10,1) then
          B10RS.delete(1);
          B10ROWNUMB.delete(1);
          B10EMPNO.delete(1);
          B10ENAME.delete(1);
          B10JOB.delete(1);
          B10MGR.delete(1);
          B10HIREDATE.delete(1);
          B10SAL.delete(1);
          B10COMM.delete(1);
          B10DEPTNO.delete(1);
          B10NOTE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B10(B10EMPNO.count);
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
    for i__ in 1..B10RS.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if substr(B10RS(i__),1,1) = 'I' then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
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
  function ShowFieldJSDYN return boolean is 
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
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock"></div></caption><table border="1" id="B10_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10ROWNUMB"><span id="B10ROWNUMB_LAB" class="label">RN</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10EMPNO"><span id="B10EMPNO_LAB" class="label">Empno</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10ENAME"><span id="B10ENAME_LAB" class="label">Ename</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10JOB"><span id="B10JOB_LAB" class="label">Job</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10MGR"><span id="B10MGR_LAB" class="label">Mgr</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10HIREDATE"><span id="B10HIREDATE_LAB" class="label">Hiredate</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10SAL"><span id="B10SAL_LAB" class="label">Sal</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10COMM"><span id="B10COMM_LAB" class="label">Comm</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10DEPTNO"><span id="B10DEPTNO_LAB" class="label">Deptno</span></td><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10NOTE"><span id="B10NOTE_LAB" class="label">Note</span></td></tr></thead>'); for iB10 in 1..B10EMPNO.count loop 
htp.prn('<tr id="B10_BLOCK"><span id="" value="'||iB10||'" name="" class="hiddenRowItems"><input name="B10RS_'||iB10||'" id="B10RS_'||iB10||'_RASD" type="hidden" value="'||B10RS(iB10)||'"/>
</span><td class="rasdTxB10ROWNUMB rasdTxTypeN" id="rasdTxB10ROWNUMB_'||iB10||'">');  if B10ROWNUMB#SET(iB10).visible then  
htp.prn('<font id="B10ROWNUMB_'||iB10||'_RASD" class="rasdFont');  if B10ROWNUMB#SET(iB10).error is not null then htp.p(' errorField'); end if;  
htp.prn('');  if B10ROWNUMB#SET(iB10).info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  if B10ROWNUMB#SET(iB10).disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('');  if B10ROWNUMB#SET(iB10).readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if B10ROWNUMB#SET(iB10).info is not null then htp.p(' title="'||B10ROWNUMB#SET(iB10).info||'"'); end if;  
htp.prn('');  if B10ROWNUMB#SET(iB10).required then htp.p(' required="required"'); end if;  
htp.prn('');  htp.p(B10ROWNUMB#SET(iB10).custom);  
htp.prn('');  if B10ROWNUMB#SET(iB10).error is not null then htp.p(' title="'||B10ROWNUMB#SET(iB10).error||'"'); end if;  
htp.prn('>'||ltrim(to_char(B10ROWNUMB(iB10)))||'</font>');  end if;  
htp.prn('</td><td class="rasdTxB10EMPNO rasdTxTypeN" id="rasdTxB10EMPNO_'||iB10||'"><font id="B10EMPNO_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10EMPNO(iB10)))||'</font></td><td class="rasdTxB10ENAME rasdTxTypeC" id="rasdTxB10ENAME_'||iB10||'"><font id="B10ENAME_'||iB10||'_RASD" class="rasdFont">'||B10ENAME(iB10)||'</font>
</td><td class="rasdTxB10JOB rasdTxTypeC" id="rasdTxB10JOB_'||iB10||'"><font id="B10JOB_'||iB10||'_RASD" class="rasdFont">'||B10JOB(iB10)||'</font></td><td class="rasdTxB10MGR rasdTxTypeN" id="rasdTxB10MGR_'||iB10||'">');  if B10MGR#SET(iB10).visible then  
htp.prn('<input name="B10MGR_'||iB10||'" id="B10MGR_'||iB10||'_RASD" type="text" value="'||ltrim(to_char(B10MGR(iB10)))||'" class="rasdTextN');  if B10MGR#SET(iB10).error is not null then htp.p(' errorField'); end if;  
htp.prn('');  if B10MGR#SET(iB10).info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  htp.p(B10MGR#SET(iB10).custom);  
htp.prn('');  if B10MGR#SET(iB10).required then htp.p(' required="required"'); end if;  
htp.prn('');  if B10MGR#SET(iB10).disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('');  if B10MGR#SET(iB10).readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if B10MGR#SET(iB10).error is not null then htp.p(' title="'||B10MGR#SET(iB10).error||'"'); end if;  
htp.prn('');  if B10MGR#SET(iB10).info is not null then htp.p(' title="'||B10MGR#SET(iB10).info||'"'); end if;  
htp.prn('/>');  end if;  
htp.prn('
</td><td class="rasdTxB10HIREDATE rasdTxTypeD" id="rasdTxB10HIREDATE_'||iB10||'"><font id="B10HIREDATE_'||iB10||'_RASD" class="rasdFont">'||to_char(B10HIREDATE(iB10),rasd_client.C_DATE_FORMAT)||'</font></td><td class="rasdTxB10SAL rasdTxTypeN" id="rasdTxB10SAL_'||iB10||'"><font id="B10SAL_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10SAL(iB10)))||'</font></td><td class="rasdTxB10COMM rasdTxTypeN" id="rasdTxB10COMM_'||iB10||'"><font id="B10COMM_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10COMM(iB10)))||'</font></td><td class="rasdTxB10DEPTNO rasdTxTypeN" id="rasdTxB10DEPTNO_'||iB10||'"><font id="B10DEPTNO_'||iB10||'_RASD" class="rasdFont">'||ltrim(to_char(B10DEPTNO(iB10)))||'</font></td><td class="rasdTxB10NOTE rasdTxTypeC" id="rasdTxB10NOTE_'||iB10||'">');  if B10NOTE#SET(iB10).visible then  
htp.prn('<font id="B10NOTE_'||iB10||'_RASD" class="rasdFont');  if B10NOTE#SET(iB10).error is not null then htp.p(' errorField'); end if;  
htp.prn('');  if B10NOTE#SET(iB10).info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  if B10NOTE#SET(iB10).disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('');  if B10NOTE#SET(iB10).readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if B10NOTE#SET(iB10).info is not null then htp.p(' title="'||B10NOTE#SET(iB10).info||'"'); end if;  
htp.prn('');  if B10NOTE#SET(iB10).required then htp.p(' required="required"'); end if;  
htp.prn('');  htp.p(B10NOTE#SET(iB10).custom);  
htp.prn('');  if B10NOTE#SET(iB10).error is not null then htp.p(' title="'||B10NOTE#SET(iB10).error||'"'); end if;  
htp.prn('>'||B10NOTE(iB10)||'</font>');  end if;  
htp.prn('</td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
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
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','How to add rownumbers')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="IMP_DEMO_ADD_ROWNUMBERS_LAB" class="rasdFormLab">How to add rownumbers '|| rasd_client.getHtmlDataTable('IMP_DEMO_ADD_ROWNUMBERS_LAB') ||'     </div><div id="IMP_DEMO_ADD_ROWNUMBERS_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('IMP_DEMO_ADD_ROWNUMBERS_MENU') ||'     </div>
<form name="IMP_DEMO_ADD_ROWNUMBERS" method="post"><div id="IMP_DEMO_ADD_ROWNUMBERS_DIV" class="rasdForm"><div id="IMP_DEMO_ADD_ROWNUMBERS_HEAD" class="rasdFormHead"><input name="RECNUMB10" id="RECNUMB10_RASD" type="hidden" value="'||RECNUMB10||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
<input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('');  if GBUTTONFWD#SET.visible then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton');  if GBUTTONFWD#SET.error is not null then htp.p(' errorField'); end if;  
htp.prn('');  if GBUTTONFWD#SET.info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  if GBUTTONFWD#SET.info is not null then htp.p(' title="'||GBUTTONFWD#SET.info||'"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.error is not null then htp.p(' title="'||GBUTTONFWD#SET.error||'"'); end if;  
htp.prn('');  htp.p(GBUTTONFWD#SET.custom);  
htp.prn('');  if GBUTTONFWD#SET.required then htp.p(' required="required"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('/>');  end if;  
htp.prn('
');  end if;  
htp.prn('');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="IMP_DEMO_ADD_ROWNUMBERS_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_DIV; htp.p('</div><div id="IMP_DEMO_ADD_ROWNUMBERS_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="IMP_DEMO_ADD_ROWNUMBERS_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="IMP_DEMO_ADD_ROWNUMBERS_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="IMP_DEMO_ADD_ROWNUMBERS_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONFWD  then  
htp.prn('');  if GBUTTONFWD#SET.visible then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONFWD" id="GBUTTONFWD_RASD" type="button" value="'||GBUTTONFWD||'" class="rasdButton');  if GBUTTONFWD#SET.error is not null then htp.p(' errorField'); end if;  

htp.prn('');  if GBUTTONFWD#SET.info is not null then htp.p(' infoField'); end if;  
htp.prn('"');  if GBUTTONFWD#SET.error is not null then htp.p(' title="'||GBUTTONFWD#SET.error||'"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.info is not null then htp.p(' title="'||GBUTTONFWD#SET.info||'"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.readonly then htp.p(' readonly="readonly"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.disabled then htp.p(' disabled="disabled"'); end if;  
htp.prn('');  if GBUTTONFWD#SET.required then htp.p(' required="required"'); end if;  
htp.prn('');  htp.p(GBUTTONFWD#SET.custom);  
htp.prn('/>');  end if;  
htp.prn('
');  end if;  
htp.prn('');  
if  ShowFieldGBUTTONBCK  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONBCK" id="GBUTTONBCK_RASD" type="button" value="'||GBUTTONBCK||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_ADD_ROWNUMBERS_FOOTER',1,instr('IMP_DEMO_ADD_ROWNUMBERS_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
    htp.p('<form name="IMP_DEMO_ADD_ROWNUMBERS" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<recnumb10><![CDATA['||RECNUMB10||']]></recnumb10>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<gbuttonbck><![CDATA['||GBUTTONBCK||']]></gbuttonbck>'); 
    htp.p('<gbuttonfwd><![CDATA['||GBUTTONFWD||']]></gbuttonfwd>'); 
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
B10EMPNO
.count loop 
    htp.p('<element>'); 
    htp.p('<b10rs><![CDATA['||B10RS(i__)||']]></b10rs>'); 
    htp.p('<b10rownumb>'||B10ROWNUMB(i__)||'</b10rownumb>'); 
    htp.p('<b10empno>'||B10EMPNO(i__)||'</b10empno>'); 
    htp.p('<b10ename><![CDATA['||B10ENAME(i__)||']]></b10ename>'); 
    htp.p('<b10job><![CDATA['||B10JOB(i__)||']]></b10job>'); 
    htp.p('<b10mgr>'||B10MGR(i__)||'</b10mgr>'); 
    htp.p('<b10hiredate>'||B10HIREDATE(i__)||'</b10hiredate>'); 
    htp.p('<b10sal>'||B10SAL(i__)||'</b10sal>'); 
    htp.p('<b10comm>'||B10COMM(i__)||'</b10comm>'); 
    htp.p('<b10deptno>'||B10DEPTNO(i__)||'</b10deptno>'); 
    htp.p('<b10note><![CDATA['||B10NOTE(i__)||']]></b10note>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b10>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"IMP_DEMO_ADD_ROWNUMBERS","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"recnumb10":"'||escapeRest(RECNUMB10)||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"gbuttonbck":"'||escapeRest(GBUTTONBCK)||'"'); 
    htp.p(',"gbuttonfwd":"'||escapeRest(GBUTTONFWD)||'"'); 
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
B10EMPNO
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b10rs":"'||escapeRest(B10RS(i__))||'"'); 
    htp.p(',"b10rownumb":"'||B10ROWNUMB(i__)||'"'); 
    htp.p(',"b10empno":"'||B10EMPNO(i__)||'"'); 
    htp.p(',"b10ename":"'||escapeRest(B10ENAME(i__))||'"'); 
    htp.p(',"b10job":"'||escapeRest(B10JOB(i__))||'"'); 
    htp.p(',"b10mgr":"'||B10MGR(i__)||'"'); 
    htp.p(',"b10hiredate":"'||B10HIREDATE(i__)||'"'); 
    htp.p(',"b10sal":"'||B10SAL(i__)||'"'); 
    htp.p(',"b10comm":"'||B10COMM(i__)||'"'); 
    htp.p(',"b10deptno":"'||B10DEPTNO(i__)||'"'); 
    htp.p(',"b10note":"'||escapeRest(B10NOTE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b10":[]'); 
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
  rasd_client.secCheckPermission('IMP_DEMO_ADD_ROWNUMBERS',ACTION);  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','How to add rownumbers')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="IMP_DEMO_ADD_ROWNUMBERS_LAB" class="rasdFormLab">How to add rownumbers '|| rasd_client.getHtmlDataTable('IMP_DEMO_ADD_ROWNUMBERS_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'IMP_DEMO_ADD_ROWNUMBERS' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('IMP_DEMO_ADD_ROWNUMBERS_FOOTER',1,instr('IMP_DEMO_ADD_ROWNUMBERS_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('IMP_DEMO_ADD_ROWNUMBERS',ACTION);  
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
  rasd_client.secCheckPermission('IMP_DEMO_ADD_ROWNUMBERS',ACTION);  
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
<form name="IMP_DEMO_ADD_ROWNUMBERS" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"IMP_DEMO_ADD_ROWNUMBERS","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>71</formid><form>IMP_DEMO_ADD_ROWNUMBERS</form><version>1</version><change>30.01.2020 09/32/50</change><user>RASDCLI</user><label><![CDATA[How to add rownumbers]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>30.01.2020 09/32/27</change><compileyn>N</compileyn><application>imported form</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  HTP.p('Content-Disposition: filename="Export_IMP_DEMO_ADD_ROWNUMBERS_v.1.1.20200130093250.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end IMP_DEMO_ADD_ROWNUMBERS;
/

