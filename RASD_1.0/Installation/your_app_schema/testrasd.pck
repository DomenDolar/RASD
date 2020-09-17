create or replace package TESTRASD is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: TESTRASD generated on 08.01.20 by user RASDCLI.     
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

create or replace package body TESTRASD is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: TESTRASD generated on 08.01.20 by user RASDCLI.    
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
  ERROR                         varchar2(4000);  GBUTTONRES                    varchar2(4000) := 'GBUTTONRES'
;  GBUTTONSRC                    varchar2(4000) := 'Run'
;
  MESSAGE                       varchar2(4000);  PAGE                          number := 0
;
  WARNING                       varchar2(4000);
  EX                            varchar2(4000);
  PLIMIT                        ntab;
  PCHARCTERS                    ntab;
  PCOUNT                        ntab;
  B20OUT                        ctab;
  PCHARS                        ntab;
  B30_COPYPARAMETER             ctab;
  B30_COPY_COPYPARAMETER        ctab;
  B30PARAMETER                  ctab;
  B30_COPY_COPYVALUE            ctab;
  B30_COPYVALUE                 ctab;
  B30VALUE                      ctab;
  B10OBJECT_NAME                cctab;
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
        rasd_client.callLog('66','||v_clob||', systimestamp, '' );
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
   return 'v.1.1.20200108095731'; 
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
if PLIMIT(i__) is null then vc := rasd_client.sessionGetValue('PLIMIT'); PLIMIT(i__)  := rasd_client.varchr2number(vc);  end if; 
if PCHARCTERS(i__) is null then vc := rasd_client.sessionGetValue('PCHARCTERS'); PCHARCTERS(i__)  := rasd_client.varchr2number(vc);  end if; 
if PCOUNT(i__) is null then vc := rasd_client.sessionGetValue('PCOUNT'); PCOUNT(i__)  := rasd_client.varchr2number(vc);  end if; 
if PCHARS(i__) is null then vc := rasd_client.sessionGetValue('PCHARS'); PCHARS(i__)  := rasd_client.varchr2number(vc);  end if; 
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
      elsif  upper(name_array(i__)) = upper('GBUTTONRES') then GBUTTONRES := value_array(i__);
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('EX') then EX := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PLIMIT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PLIMIT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('PCHARCTERS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PCHARCTERS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('PCOUNT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PCOUNT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20OUT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B20OUT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PCHARS_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PCHARS(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B30_COPYPARAMETER_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30_COPYPARAMETER(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPY_COPYPARAMETER_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30_COPY_COPYPARAMETER(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30PARAMETER_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30PARAMETER(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPY_COPYVALUE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30_COPY_COPYVALUE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPYVALUE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30_COPYVALUE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30VALUE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B30VALUE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10OBJECT_NAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10OBJECT_NAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PLIMIT') and PLIMIT.count = 0 and value_array(i__) is not null then
        PLIMIT(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('PCHARCTERS') and PCHARCTERS.count = 0 and value_array(i__) is not null then
        PCHARCTERS(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('PCOUNT') and PCOUNT.count = 0 and value_array(i__) is not null then
        PCOUNT(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B20OUT') and B20OUT.count = 0 and value_array(i__) is not null then
        B20OUT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PCHARS') and PCHARS.count = 0 and value_array(i__) is not null then
        PCHARS(1) := rasd_client.varchr2number(value_array(i__));
      elsif  upper(name_array(i__)) = upper('B30_COPYPARAMETER') and B30_COPYPARAMETER.count = 0 and value_array(i__) is not null then
        B30_COPYPARAMETER(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPY_COPYPARAMETER') and B30_COPY_COPYPARAMETER.count = 0 and value_array(i__) is not null then
        B30_COPY_COPYPARAMETER(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30PARAMETER') and B30PARAMETER.count = 0 and value_array(i__) is not null then
        B30PARAMETER(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPY_COPYVALUE') and B30_COPY_COPYVALUE.count = 0 and value_array(i__) is not null then
        B30_COPY_COPYVALUE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30_COPYVALUE') and B30_COPYVALUE.count = 0 and value_array(i__) is not null then
        B30_COPYVALUE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B30VALUE') and B30VALUE.count = 0 and value_array(i__) is not null then
        B30VALUE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10OBJECT_NAME') and B10OBJECT_NAME.count = 0 and value_array(i__) is not null then
        B10OBJECT_NAME(1) := value_array(i__);
      end if;
    end loop;
-- organize records
declare
v_last number := 
B30_COPYPARAMETER
.last;
v_curr number := 
B30_COPYPARAMETER
.first;
i__ number;
begin
 if v_last <> 
B30_COPYPARAMETER
.count then 
   v_curr := 
B30_COPYPARAMETER
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B30_COPYPARAMETER.exists(v_curr) then B30_COPYPARAMETER(i__) := B30_COPYPARAMETER(v_curr); end if;
      if B30_COPYVALUE.exists(v_curr) then B30_COPYVALUE(i__) := B30_COPYVALUE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B30_COPYPARAMETER
.NEXT(v_curr);  
   END LOOP;
      B30_COPYPARAMETER.DELETE(i__ , v_last);
      B30_COPYVALUE.DELETE(i__ , v_last);
end if;
end;
declare
v_last number := 
B30_COPY_COPYPARAMETER
.last;
v_curr number := 
B30_COPY_COPYPARAMETER
.first;
i__ number;
begin
 if v_last <> 
B30_COPY_COPYPARAMETER
.count then 
   v_curr := 
B30_COPY_COPYPARAMETER
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B30_COPY_COPYPARAMETER.exists(v_curr) then B30_COPY_COPYPARAMETER(i__) := B30_COPY_COPYPARAMETER(v_curr); end if;
      if B30_COPY_COPYVALUE.exists(v_curr) then B30_COPY_COPYVALUE(i__) := B30_COPY_COPYVALUE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B30_COPY_COPYPARAMETER
.NEXT(v_curr);  
   END LOOP;
      B30_COPY_COPYPARAMETER.DELETE(i__ , v_last);
      B30_COPY_COPYVALUE.DELETE(i__ , v_last);
end if;
end;
declare
v_last number := 
B30PARAMETER
.last;
v_curr number := 
B30PARAMETER
.first;
i__ number;
begin
 if v_last <> 
B30PARAMETER
.count then 
   v_curr := 
B30PARAMETER
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B30PARAMETER.exists(v_curr) then B30PARAMETER(i__) := B30PARAMETER(v_curr); end if;
      if B30VALUE.exists(v_curr) then B30VALUE(i__) := B30VALUE(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B30PARAMETER
.NEXT(v_curr);  
   END LOOP;
      B30PARAMETER.DELETE(i__ , v_last);
      B30VALUE.DELETE(i__ , v_last);
end if;
end;
declare
v_last number := 
B10OBJECT_NAME
.last;
v_curr number := 
B10OBJECT_NAME
.first;
i__ number;
begin
 if v_last <> 
B10OBJECT_NAME
.count then 
   v_curr := 
B10OBJECT_NAME
.FIRST;  
   i__ := 1;
   WHILE v_curr IS NOT NULL LOOP
      if B10OBJECT_NAME.exists(v_curr) then B10OBJECT_NAME(i__) := B10OBJECT_NAME(v_curr); end if;
      i__ := i__ + 1;
      v_curr := 
B10OBJECT_NAME
.NEXT(v_curr);  
   END LOOP;
      B10OBJECT_NAME.DELETE(i__ , v_last);
end if;
end;
-- init fields
    v_max := 0;
    if B10OBJECT_NAME.count > v_max then v_max := B10OBJECT_NAME.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B10OBJECT_NAME.exists(i__) then
        B10OBJECT_NAME(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B20OUT.count > v_max then v_max := B20OUT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B20OUT.exists(i__) then
        B20OUT(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B30PARAMETER.count > v_max then v_max := B30PARAMETER.count; end if;
    if B30VALUE.count > v_max then v_max := B30VALUE.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B30PARAMETER.exists(i__) then
        B30PARAMETER(i__) := null;
      end if;
      if not B30VALUE.exists(i__) then
        B30VALUE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B30_COPYPARAMETER.count > v_max then v_max := B30_COPYPARAMETER.count; end if;
    if B30_COPYVALUE.count > v_max then v_max := B30_COPYVALUE.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B30_COPYPARAMETER.exists(i__) then
        B30_COPYPARAMETER(i__) := null;
      end if;
      if not B30_COPYVALUE.exists(i__) then
        B30_COPYVALUE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B30_COPY_COPYPARAMETER.count > v_max then v_max := B30_COPY_COPYPARAMETER.count; end if;
    if B30_COPY_COPYVALUE.count > v_max then v_max := B30_COPY_COPYVALUE.count; end if;
    if v_max = 0 then v_max := 0; end if;
    for i__ in 1..v_max loop
      if not B30_COPY_COPYPARAMETER.exists(i__) then
        B30_COPY_COPYPARAMETER(i__) := null;
      end if;
      if not B30_COPY_COPYVALUE.exists(i__) then
        B30_COPY_COPYVALUE(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if PLIMIT.count > v_max then v_max := PLIMIT.count; end if;
    if PCHARCTERS.count > v_max then v_max := PCHARCTERS.count; end if;
    if PCOUNT.count > v_max then v_max := PCOUNT.count; end if;
    if PCHARS.count > v_max then v_max := PCHARS.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PLIMIT.exists(i__) then
        PLIMIT(i__) := 1;
      end if;
      if not PCHARCTERS.exists(i__) then
        PCHARCTERS(i__) := 0;
      end if;
      if not PCOUNT.exists(i__) then
        PCOUNT(i__) := to_number(null);
      end if;
      if not PCHARS.exists(i__) then
        PCHARS(i__) := to_number(null);
      end if;
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="66" blockid="">
begin
PCOUNT(1) := B10OBJECT_NAME.count; 
PCHARS(1) := (B10OBJECT_NAME.count * length(B10OBJECT_NAME(1)) ) ; 
exception when others then null;
end;

if PCHARCTERS(1) > 32767 then
    
	PCHARCTERS(1) := 32767;

end if;


    declare
      vc OWA_COOKIE.cookie; 
	  x varchar2(1000);
    begin
      vc := owa_cookie.get('myCookie');
      x := vc.vals(1);
      ex := 'Read COOKIE myCookie OK: '||x; 
    exception when others then
      ex := '<font color="red">Read COOKIES error (COOKIE myCookie not exists).'; 
      x := '';
    end;
    if instr(ex,'OK:') = 0 then   
    begin
        owa_util.mime_header('text/html', FALSE);        
        OWA_COOKIE.SEND('myCookie', 'my cookie value' , null,null);
        --owa_util.redirect_url('zpizrasd.TEST_DAD_COMM?GUID='||guid);
        owa_util.http_header_close;
	  ex := 'COOKIE myCookie saved OK';
    exception when others then
      ex := 'Save COOKIE myCookie error!'; 
    end;
	end if;
--</POST_SUBMIT>
    null;
  end;
  procedure psubmit(name_array  in owa.vc_arr, value_array in owa.vc_arr) is
  begin
--<ON_SUBMIT formid="66" blockid="">
-- Reading post variables into fields.
    on_submit(name_array ,value_array); 
--</ON_SUBMIT>
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
        PLIMIT(i__) := 1;
        PCHARCTERS(i__) := 0;
        PCOUNT(i__) := null;
        PCHARS(i__) := null;

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
        B20OUT(i__) := null;

      end loop;
  end;
  procedure pclear_B30_COPY(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 0 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B30_COPYPARAMETER
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
        B30_COPYPARAMETER(i__) := null;
        B30_COPYVALUE(i__) := null;

      end loop;
  end;
  procedure pclear_B30_COPY_COPY(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 0 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B30_COPY_COPYPARAMETER
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
        B30_COPY_COPYPARAMETER(i__) := null;
        B30_COPY_COPYVALUE(i__) := null;

      end loop;
  end;
  procedure pclear_B30(pstart number) is
    i__ pls_integer;
    j__ pls_integer;
    k__ pls_integer;
  begin
      i__ := pstart;
      if 0 = 0 then k__ := i__ + 0;
 if pstart = 0 then k__ := k__ + 
B30PARAMETER
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
        B30PARAMETER(i__) := null;
        B30VALUE(i__) := null;

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
B10OBJECT_NAME
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
        B10OBJECT_NAME(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    ERROR := null;
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSRC := 'Run';
    MESSAGE := null;
    PAGE := 0;
    WARNING := null;
    EX := null;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);
    pclear_B20(0);
    pclear_B30_COPY(0);
    pclear_B30_COPY_COPY(0);
    pclear_B30(0);
    pclear_B10(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PLIMIT.count);
  null; end;
  procedure pselect_B20 is
    i__ pls_integer;
  begin
      pclear_B20(B20OUT.count);
  null; end;
  procedure pselect_B30_COPY is
    i__ pls_integer;
  begin
      B30_COPYPARAMETER.delete;
      B30_COPYVALUE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
select  t.parameter, t.value
from nls_session_parameters t;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B30_COPYPARAMETER(i__)
           ,B30_COPYVALUE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B30_COPYPARAMETER.delete(1);
          B30_COPYVALUE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B30_COPY(B30_COPYPARAMETER.count);
  null; end;
  procedure pselect_B30_COPY_COPY is
    i__ pls_integer;
  begin
      B30_COPY_COPYPARAMETER.delete;
      B30_COPY_COPYVALUE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
select  t.parameter, t.value
from nls_instance_parameters t;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B30_COPY_COPYPARAMETER(i__)
           ,B30_COPY_COPYVALUE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B30_COPY_COPYPARAMETER.delete(1);
          B30_COPY_COPYVALUE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B30_COPY_COPY(B30_COPY_COPYPARAMETER.count);
  null; end;
  procedure pselect_B30 is
    i__ pls_integer;
  begin
      B30PARAMETER.delete;
      B30VALUE.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
select  t.parameter, t.value
from nls_database_parameters t;
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B30PARAMETER(i__)
           ,B30VALUE(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.


            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B30PARAMETER.delete(1);
          B30VALUE.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B30(B30PARAMETER.count);
  null; end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      B10OBJECT_NAME.delete;

      declare 
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
-- Generated SELECT code. Use (i__) to access fields values.
OPEN c__ FOR 
select 

lpad('X', PCHARCTERS(1) , 'Q' )

object_name

from all_objects where rownum <= PLIMIT(1);
        i__ := 1;
        LOOP 
          FETCH c__ INTO
            B10OBJECT_NAME(i__)
          ;
          exit when c__%notfound;
           if c__%rowcount >=  1 then
-- Generated code for setting lock value based on fiels checked Locked (combination with ON_LOCK trigger). Use (i__) to access fields values.

--<post_select formid="66" blockid="B10">
--
--B10OBJECT_NAME(i__) := lpad('X', PCHARCTERS(1) , 'Q' );

--DBMS_LOB.append ( B10OBJECT_NAME(i__) ,  lpad('X', PCHARCTERS(1) , 'Q' ) );
--DBMS_LOB.append ( B10OBJECT_NAME(i__) ,  lpad('X', PCHARCTERS(1) , 'Q' ) );

null;
--</post_select>
            exit when i__ =0;
            i__ := i__ + 1;
          end if;
        END LOOP;
         if c__%rowcount <  1 then
          B10OBJECT_NAME.delete(1);
          i__ := 0;
        end if; 
        CLOSE c__;
      end;
      pclear_B10(B10OBJECT_NAME.count);
  null; end;
  procedure pselect is
  begin
    if  nvl(PAGE,0) = 0 then 
      pselect_B30_COPY;
    end if;
    if  nvl(PAGE,0) = 0 then 
      pselect_B30_COPY_COPY;
    end if;
    if  nvl(PAGE,0) = 0 then 
      pselect_B30;
    end if;
    if  nvl(PAGE,0) = 0 then 
      pselect_B10;
    end if;
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PLIMIT.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B20 is
  begin
    for i__ in 1..B20OUT.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B30_COPY is
  begin
    for i__ in 1..B30_COPYPARAMETER.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if 1=2 then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B30_COPY_COPY is
  begin
    for i__ in 1..B30_COPY_COPYPARAMETER.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if 1=2 then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B30 is
  begin
    for i__ in 1..B30PARAMETER.count loop
-- Validating field values before DML. Use (i__) to access fields values.
      if 1=2 then --INSERT
      null; else -- UPDATE or DELETE;
-- Generated code for lock value based on fields checked Locked (combination with ON_LOCK_VALUE trigger). Use (i__) to access fields values.

-- Generated code for mandatory statment based on fiels checked Mandatory. Use (i__) to access fields values.

      null; end if;
    null; end loop;
  null; end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10OBJECT_NAME.count loop
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

    if  nvl(PAGE,0) = 0 then 
       pcommit_B30_COPY;
    end if;
    if  nvl(PAGE,0) = 0 then 
       pcommit_B30_COPY_COPY;
    end if;
    if  nvl(PAGE,0) = 0 then 
       pcommit_B30;
    end if;
    if  nvl(PAGE,0) = 0 then 
       pcommit_B10;
    end if;

  null; 
  end;
  procedure poutput is
    iB30_COPY pls_integer;
    iB30_COPY_COPY pls_integer;
    iB30 pls_integer;
    iB10 pls_integer;
  function ShowFieldERROR return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldEX return boolean is 
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
    if  nvl(PAGE,0) = 0 then 
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
  function ShowBlockB30_COPY_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_COPY_COPY_DIV return boolean is 
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
<caption><div id="B10_LAB" class="labelblock"></div></caption><table border="1" id="B10_TABLE" class="rasdTableN display"><thead><tr></tr></thead>'); for iB10 in 1..B10OBJECT_NAME.count loop 
htp.prn('<tr id="B10_BLOCK"><span id="" value="'||iB10||'" name="" class="hiddenRowItems"><input name="B10OBJECT_NAME_'||iB10||'" id="B10OBJECT_NAME_'||iB10||'_RASD" type="hidden" value="');  htpClob( B10OBJECT_NAME(iB10) );  
htp.prn('"/>
</span></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B20_DIV is begin htp.p('');  if  ShowBlockB20_DIV  then  
htp.prn('<div  id="B20_DIV" class="rasdblock"><div>
<caption><div id="B20_LAB" class="labelblock">TEST_DAD_COMM</div></caption>
<table border="0" id="B20_TABLE"><tr id="B20_BLOCK"><td class="rasdTxLab rasdTxLabBlockB20" id="rasdTxLabB20OUT"><span id="B20OUT_LAB" class="label"></span></td><td class="rasdTxB20OUT rasdTxTypeC" id="rasdTxB20OUT_1"><span id="B20OUT_1_RASD">');  declare 
  test varchar2(1000);
begin 

    htp.p('Welcome '||user||'. </br>');
    htp.p(ex||'.</br>');
    test:= owa_util.get_cgi_env('HTTP_USER_AGENT');
    htp.p(test||'.</br>');
    owa_util.print_cgi_env;  

end;	  
htp.prn('</span></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B30_DIV is begin htp.p('');  if  ShowBlockB30_DIV  then  
htp.prn('<div  id="B30_DIV" class="rasdblock"><div>
<caption><div id="B30_LAB" class="labelblock">nls_database_parameters</div></caption><table border="1" id="B30_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30PARAMETER"><span id="B30PARAMETER_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB30" id="rasdTxLabB30VALUE"><span id="B30VALUE_LAB" class="label"></span></td></tr></thead>'); for iB30 in 1..B30PARAMETER.count loop 
htp.prn('<tr id="B30_BLOCK"><td class="rasdTxB30PARAMETER rasdTxTypeC" id="rasdTxB30PARAMETER_'||iB30||'"><font id="B30PARAMETER_'||iB30||'_RASD" class="rasdFont">'||B30PARAMETER(iB30)||'</font></td><td class="rasdTxB30VALUE rasdTxTypeC" id="rasdTxB30VALUE_'||iB30||'"><font id="B30VALUE_'||iB30||'_RASD" class="rasdFont">'||B30VALUE(iB30)||'</font></td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B30_COPY_DIV is begin htp.p('');  if  ShowBlockB30_COPY_DIV  then  
htp.prn('<div  id="B30_COPY_DIV" class="rasdblock"><div>
<caption><div id="B30_COPY_LAB" class="labelblock">nls_session_parameters</div></caption><table border="1" id="B30_COPY_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB30_COPY" id="rasdTxLabB30_COPYPARAMETER"><span id="B30_COPYPARAMETER_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB30_COPY" id="rasdTxLabB30_COPYVALUE"><span id="B30_COPYVALUE_LAB" class="label"></span></td></tr></thead>'); for iB30_COPY in 1..B30_COPYPARAMETER.count loop 
htp.prn('<tr id="B30_COPY_BLOCK"><td class="rasdTxB30_COPYPARAMETER rasdTxTypeC" id="rasdTxB30_COPYPARAMETER_'||iB30_COPY||'"><font id="B30_COPYPARAMETER_'||iB30_COPY||'_RASD" class="rasdFont">'||B30_COPYPARAMETER(iB30_COPY)||'</font></td><td class="rasdTxB30_COPYVALUE rasdTxTypeC" id="rasdTxB30_COPYVALUE_'||iB30_COPY||'"><font id="B30_COPYVALUE_'||iB30_COPY||'_RASD" class="rasdFont">'||B30_COPYVALUE(iB30_COPY)||'</font></td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B30_COPY_COPY_DIV is begin htp.p('');  if  ShowBlockB30_COPY_COPY_DIV  then  
htp.prn('<div  id="B30_COPY_COPY_DIV" class="rasdblock"><div>
<caption><div id="B30_COPY_COPY_LAB" class="labelblock">nls_instance_parameters</div></caption><table border="1" id="B30_COPY_COPY_TABLE" class="rasdTableN display"><thead><tr><td class="rasdTxLab rasdTxLabBlockB30_COPY_COPY" id="rasdTxLabB30_COPY_COPYPARAMETER"><span id="B30_COPY_COPYPARAMETER_LAB" class="label"></span></td><td class="rasdTxLab rasdTxLabBlockB30_COPY_COPY" id="rasdTxLabB30_COPY_COPYVALUE"><span id="B30_COPY_COPYVALUE_LAB" class="label"></span></td></tr></thead>'); for iB30_COPY_COPY in 1..B30_COPY_COPYPARAMETER.count loop 
htp.prn('<tr id="B30_COPY_COPY_BLOCK"><td class="rasdTxB30_COPY_COPYPARAMETER rasdTxTypeC" id="rasdTxB30_COPY_COPYPARAMETER_'||iB30_COPY_COPY||'"><font id="B30_COPY_COPYPARAMETER_'||iB30_COPY_COPY||'_RASD" class="rasdFont">'||B30_COPY_COPYPARAMETER(iB30_COPY_COPY)||'</font></td><td class="rasdTxB30_COPY_COPYVALUE rasdTxTypeC" id="rasdTxB30_COPY_COPYVALUE_'||iB30_COPY_COPY||'"><font id="B30_COPY_COPYVALUE_'||iB30_COPY_COPY||'_RASD" class="rasdFont">'||B30_COPY_COPYVALUE(iB30_COPY_COPY)||'</font></td></tr>'); end loop; 
htp.prn('</table></div></div>');  end if;  
htp.prn(''); end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPLIMIT"><span id="PLIMIT_LAB" class="label">Number of objects (limit 9995+ button + 2 x input < 10000) :</span></td><td class="rasdTxPLIMIT rasdTxTypeN" id="rasdTxPLIMIT_1"><input name="PLIMIT_1" id="PLIMIT_1_RASD" type="text" value="'||ltrim(to_char(PLIMIT(1)))||'" class="rasdTextN"/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPCHARCTERS"><span id="PCHARCTERS_LAB" class="label">Chars on object (read back max 32767 ):</span></td><td class="rasdTxPCHARCTERS rasdTxTypeN" id="rasdTxPCHARCTERS_1"><input name="PCHARCTERS_1" id="PCHARCTERS_1_RASD" type="text" value="'||ltrim(to_char(PCHARCTERS(1)))||'" class="rasdTextN"/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPCOUNT"><span id="PCOUNT_LAB" class="label">Read objects:</span></td><td class="rasdTxPCOUNT rasdTxTypeN" id="rasdTxPCOUNT_1"><font id="PCOUNT_1_RASD" class="rasdFont">'||ltrim(to_char(PCOUNT(1),'999G999G990'))||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPCHARS"><span id="PCHARS_LAB" class="label">Chars transferred (working 115,667,510 posted chars):</span></td><td class="rasdTxPCHARS rasdTxTypeN" id="rasdTxPCHARS_1"><font id="PCHARS_1_RASD" class="rasdFont">'||ltrim(to_char(PCHARS(1),'999G999G990'))||'</font></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB20() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB30_COPY() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB30_COPY_COPY() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMFB30() {');
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','TEST ORDS FOR RASD')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="TESTRASD_LAB" class="rasdFormLab">TEST ORDS FOR RASD '|| rasd_client.getHtmlDataTable('TESTRASD_LAB') ||'     </div><div id="TESTRASD_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('TESTRASD_MENU') ||'     </div>
<form name="TESTRASD" method="post" action="?"><div id="TESTRASD_DIV" class="rasdForm"><div id="TESTRASD_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
<input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="TESTRASD_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B20_DIV; htp.p(''); output_B30_COPY_DIV; htp.p(''); output_B30_COPY_COPY_DIV; htp.p(''); output_B30_DIV; htp.p(''); output_B10_DIV; htp.p('</div><div id="TESTRASD_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="TESTRASD_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="TESTRASD_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="TESTRASD_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('TESTRASD_FOOTER',1,instr('TESTRASD_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockB30_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_COPY_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockB30_COPY_COPY_DIV return boolean is 
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
    htp.p('<form name="TESTRASD" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<gbuttonsrc><![CDATA['||GBUTTONSRC||']]></gbuttonsrc>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<page>'||PAGE||'</page>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<plimit>'||PLIMIT(1)||'</plimit>'); 
    htp.p('<pcharcters>'||PCHARCTERS(1)||'</pcharcters>'); 
    htp.p('<pcount>'||PCOUNT(1)||'</pcount>'); 
    htp.p('<pchars>'||PCHARS(1)||'</pchars>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p('<b20>'); 
    htp.p('<element>'); 
    htp.p('<b20out><![CDATA['||B20OUT(1)||']]></b20out>'); 
    htp.p('</element>'); 
  htp.p('</b20>'); 
  end if; 
    if ShowBlockb30_copy_DIV then 
    htp.p('<b30_copy>'); 
  for i__ in 1..
B30_COPYPARAMETER
.count loop 
    htp.p('<element>'); 
    htp.p('<b30_copyparameter><![CDATA['||B30_COPYPARAMETER(i__)||']]></b30_copyparameter>'); 
    htp.p('<b30_copyvalue><![CDATA['||B30_COPYVALUE(i__)||']]></b30_copyvalue>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b30_copy>'); 
  end if; 
    if ShowBlockb30_copy_copy_DIV then 
    htp.p('<b30_copy_copy>'); 
  for i__ in 1..
B30_COPY_COPYPARAMETER
.count loop 
    htp.p('<element>'); 
    htp.p('<b30_copy_copyparameter><![CDATA['||B30_COPY_COPYPARAMETER(i__)||']]></b30_copy_copyparameter>'); 
    htp.p('<b30_copy_copyvalue><![CDATA['||B30_COPY_COPYVALUE(i__)||']]></b30_copy_copyvalue>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b30_copy_copy>'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p('<b30>'); 
  for i__ in 1..
B30PARAMETER
.count loop 
    htp.p('<element>'); 
    htp.p('<b30parameter><![CDATA['||B30PARAMETER(i__)||']]></b30parameter>'); 
    htp.p('<b30value><![CDATA['||B30VALUE(i__)||']]></b30value>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b30>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
  for i__ in 1..
B10OBJECT_NAME
.count loop 
    htp.p('<element>'); 
    htp.p('<b10object_name><![CDATA['||B10OBJECT_NAME(i__)||']]></b10object_name>'); 
    htp.p('</element>'); 
  end loop; 
  htp.p('</b10>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"TESTRASD","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"gbuttonsrc":"'||escapeRest(GBUTTONSRC)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"page":"'||PAGE||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"plimit":"'||PLIMIT(1)||'"'); 
    htp.p(',"pcharcters":"'||PCHARCTERS(1)||'"'); 
    htp.p(',"pcount":"'||PCOUNT(1)||'"'); 
    htp.p(',"pchars":"'||PCHARS(1)||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb20_DIV then 
    htp.p(',"b20":['); 
     htp.p('{'); 
    htp.p('"b20out":"'||escapeRest(B20OUT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b20":[]'); 
  end if; 
    if ShowBlockb30_copy_DIV then 
    htp.p(',"b30_copy":['); 
  v_firstrow__ := true;
  for i__ in 1..
B30_COPYPARAMETER
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b30_copyparameter":"'||escapeRest(B30_COPYPARAMETER(i__))||'"'); 
    htp.p(',"b30_copyvalue":"'||escapeRest(B30_COPYVALUE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b30_copy":[]'); 
  end if; 
    if ShowBlockb30_copy_copy_DIV then 
    htp.p(',"b30_copy_copy":['); 
  v_firstrow__ := true;
  for i__ in 1..
B30_COPY_COPYPARAMETER
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b30_copy_copyparameter":"'||escapeRest(B30_COPY_COPYPARAMETER(i__))||'"'); 
    htp.p(',"b30_copy_copyvalue":"'||escapeRest(B30_COPY_COPYVALUE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b30_copy_copy":[]'); 
  end if; 
    if ShowBlockb30_DIV then 
    htp.p(',"b30":['); 
  v_firstrow__ := true;
  for i__ in 1..
B30PARAMETER
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b30parameter":"'||escapeRest(B30PARAMETER(i__))||'"'); 
    htp.p(',"b30value":"'||escapeRest(B30VALUE(i__))||'"'); 
    htp.p('}'); 
  end loop; 
    htp.p(']'); 
  else 
    htp.p(',"b30":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
  v_firstrow__ := true;
  for i__ in 1..
B10OBJECT_NAME
.count loop 
    if v_firstrow__ then
     htp.p('{'); 
     v_firstrow__ := false;
    else
     htp.p(',{'); 
    end if;
    htp.p('"b10object_name":"'||escapeRest(B10OBJECT_NAME(i__))||'"'); 
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
--<PRE_ACTION formid="66" blockid="">
--  rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
--<ON_ACTION formid="66" blockid="">
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
 -- rasd_client.secCheckPermission('TESTRASD',ACTION);  
  if ACTION is null then null;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC then     pselect;
    poutput;
  end if;

--</ON_ACTION>
  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

    pLog;
exception
  when rasd_client.e_finished then pLog;
  when others then
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','TEST ORDS FOR RASD')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="TESTRASD_LAB" class="rasdFormLab">TEST ORDS FOR RASD '|| rasd_client.getHtmlDataTable('TESTRASD_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('TESTRASD_FOOTER',1,instr('TESTRASD_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
    pLog;
end; 
procedure main(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
begin  
--<PRE_ACTION formid="66" blockid="">
--  rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('TESTRASD',ACTION);  

  -- The execution after default execution based on  ACTION.
  -- Delete this code (if) when you have new actions and add your oown.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC ) then 
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
--<PRE_ACTION formid="66" blockid="">
--  rasd_client.secCheckCredentials(  name_array , value_array ); 

--</PRE_ACTION>
  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('TESTRASD',ACTION);  
  if ACTION is null then null;
    pselect;
    poutputrest;
  elsif ACTION = GBUTTONSRC or ACTION is null  then     pselect;
    poutputrest;
  end if;

  -- The execution after default execution based on  ACTION.
  -- Delete this code when you have new actions and add your own.
  if  nvl(ACTION,GBUTTONSRC) not in (  GBUTTONSRC ) then 
    raise_application_error('-20000', 'ACTION="'||ACTION||'" is not defined. Define it in POST_ACTION trigger.');
  end if;

-- Error handler for the rest program.
 exception
  when rasd_client.e_finished then null;
  when others then
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>
<form name="TESTRASD" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"TESTRASD","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>66</formid><form>TESTRASD</form><version>1</version><change>08.01.2020 09/57/32</change><user>RASDCLI</user><label><![CDATA[TEST ORDS FOR RASD]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>23.05.2019 11/47/50</change><compileyn>N</compileyn><application>Test</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
end TESTRASD;
/

