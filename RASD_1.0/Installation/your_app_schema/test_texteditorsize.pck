create or replace package TEST_TEXTEDITORSIZE is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: TEST_TEXTEDITORSIZE generated on 08.01.20 by user RASDCLI.     
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

create or replace package body TEST_TEXTEDITORSIZE is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: TEST_TEXTEDITORSIZE generated on 08.01.20 by user RASDCLI.    
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
  WARNING                       varchar2(4000);  GBUTTONSRC                    varchar2(4000) := 'Run '
;  PAGE                          varchar2(4000) := 1
;
  PSIZETEXT                     ctab;
  PSIZETEXTPREP                 ctab;
  PREADSIZETEXT                 ctab;
  PCP                           ctab;
  PRUNME                        ctab;
  B10TEXTFIELD                  cctab;
  B10_COPYTEXTFIELD             ctab;
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
        rasd_client.callLog('70','||v_clob||', systimestamp, '' );
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
   return 'v.1.1.20200108095715'; 
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
if PSIZETEXT(i__) is null then vc := rasd_client.sessionGetValue('PSIZETEXT'); PSIZETEXT(i__)  := vc;  end if; 
if PSIZETEXTPREP(i__) is null then vc := rasd_client.sessionGetValue('PSIZETEXTPREP'); PSIZETEXTPREP(i__)  := vc;  end if; 
if PREADSIZETEXT(i__) is null then vc := rasd_client.sessionGetValue('PREADSIZETEXT'); PREADSIZETEXT(i__)  := vc;  end if; 
if PCP(i__) is null then vc := rasd_client.sessionGetValue('PCP'); PCP(i__)  := vc;  end if; 
if B10TEXTFIELD(i__) is null then vc := rasd_client.sessionGetValue('B10TEXTFIELD'); B10TEXTFIELD(i__)  := vc;  end if; 
if B10_COPYTEXTFIELD(i__) is null then vc := rasd_client.sessionGetValue('B10_COPYTEXTFIELD'); B10_COPYTEXTFIELD(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('GBUTTONSRC') then GBUTTONSRC := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PAGE') then PAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PSIZETEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PSIZETEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PSIZETEXTPREP_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PSIZETEXTPREP(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PREADSIZETEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PREADSIZETEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PCP_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PCP(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PRUNME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PRUNME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10TEXTFIELD_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10TEXTFIELD(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10_COPYTEXTFIELD_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10_COPYTEXTFIELD(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PSIZETEXT') and PSIZETEXT.count = 0 and value_array(i__) is not null then
        PSIZETEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PSIZETEXTPREP') and PSIZETEXTPREP.count = 0 and value_array(i__) is not null then
        PSIZETEXTPREP(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PREADSIZETEXT') and PREADSIZETEXT.count = 0 and value_array(i__) is not null then
        PREADSIZETEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PCP') and PCP.count = 0 and value_array(i__) is not null then
        PCP(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PRUNME') and PRUNME.count = 0 and value_array(i__) is not null then
        PRUNME(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10TEXTFIELD') and B10TEXTFIELD.count = 0 and value_array(i__) is not null then
        B10TEXTFIELD(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10_COPYTEXTFIELD') and B10_COPYTEXTFIELD.count = 0 and value_array(i__) is not null then
        B10_COPYTEXTFIELD(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10TEXTFIELD.count > v_max then v_max := B10TEXTFIELD.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10TEXTFIELD.exists(i__) then
        B10TEXTFIELD(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if B10_COPYTEXTFIELD.count > v_max then v_max := B10_COPYTEXTFIELD.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10_COPYTEXTFIELD.exists(i__) then
        B10_COPYTEXTFIELD(i__) := null;
      end if;
    null; end loop;
    v_max := 0;
    if PSIZETEXT.count > v_max then v_max := PSIZETEXT.count; end if;
    if PSIZETEXTPREP.count > v_max then v_max := PSIZETEXTPREP.count; end if;
    if PREADSIZETEXT.count > v_max then v_max := PREADSIZETEXT.count; end if;
    if PCP.count > v_max then v_max := PCP.count; end if;
    if PRUNME.count > v_max then v_max := PRUNME.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PSIZETEXT.exists(i__) then
        PSIZETEXT(i__) := 1000;
      end if;
      if not PSIZETEXTPREP.exists(i__) then
        PSIZETEXTPREP(i__) := null;
      end if;
      if not PREADSIZETEXT.exists(i__) then
        PREADSIZETEXT(i__) := null;
      end if;
      if not PCP.exists(i__) then
        PCP(i__) := null;
      end if;
      if not PRUNME.exists(i__) then
        PRUNME(i__) := GBUTTONSRC;
      end if;
--<on_new_record formid="70" blockid="P">
PCP(1) := 'Choose <a href="?page=1" >Type L - CLOB<a> or <a href="?page=2" >Type C - Varchar2<a>';
--</on_new_record>
    null; end loop;
  end;
  procedure post_submit is
  begin
--<POST_SUBMIT formid="70" blockid="">
if PAGE = 1 then
PREADSIZETEXT(1) := length(B10TEXTFIELD(1));

declare
 i number := 1;
 s number;
 c number := PSIZETEXT(1);
begin 
B10TEXTFIELD(1) := '';

while  length(nvl(B10TEXTFIELD(1),' ')) <  PSIZETEXT(1) loop
   if c <= 4000 then s := c; 
   else
     s := 4000;
     c := c - s;
   end if;
    
    B10TEXTFIELD(1) := B10TEXTFIELD(1) || DBMS_RANDOM.STRING('', s );
    i := i +1;
  exit when i > 50;
end loop;
end;

PSIZETEXTPREP(1) := length(B10TEXTFIELD(1));

elsif page = 2 then
rlog('POST SUBMIT 1');
PREADSIZETEXT(1) := length(B10_COPYTEXTFIELD(1));

rlog('POST SUBMIT 2');

declare
 i number := 1;
 s number;
 c number := PSIZETEXT(1);
begin 
B10_COPYTEXTFIELD(1) := '';

while  length(nvl(B10_COPYTEXTFIELD(1),' ')) <  PSIZETEXT(1) loop
   if c <= 4000 then s := c; 
   else
     s := 4000;
     c := c - s;
   end if;
    
rlog('POST SUBMIT 3'||i);
    B10_COPYTEXTFIELD(1) := B10_COPYTEXTFIELD(1) || DBMS_RANDOM.STRING('', s );
rlog('POST SUBMIT 4'||i);
    i := i +1;
  exit when i > 50;
end loop;
rlog('POST SUBMIT 5');
end;

PSIZETEXTPREP(1) := length(B10_COPYTEXTFIELD(1));
rlog('POST SUBMIT 6');


end if;
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
        PSIZETEXT(i__) := 1000;
        PSIZETEXTPREP(i__) := null;
        PREADSIZETEXT(i__) := null;
        PCP(i__) := null;
        PRUNME(i__) := GBUTTONSRC;

--<on_new_record formid="70" blockid="P">
PCP(1) := 'Choose <a href="?page=1" >Type L - CLOB<a> or <a href="?page=2" >Type C - Varchar2<a>';
--</on_new_record>
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
        B10TEXTFIELD(i__) := null;

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
        B10_COPYTEXTFIELD(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    ERROR := null;
    MESSAGE := null;
    WARNING := null;
    GBUTTONSRC := 'Run ';
    PAGE := 1;
  null; end;
  procedure pclear is
  begin
-- Clears all fields on form and blocks.
    pclear_form;
    pclear_P(0);
    pclear_B10(0);
    pclear_B10_COPY(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PSIZETEXT.count);
  null; end;
  procedure pselect_B10 is
    i__ pls_integer;
  begin
      pclear_B10(B10TEXTFIELD.count);
  null; end;
  procedure pselect_B10_COPY is
    i__ pls_integer;
  begin
      pclear_B10_COPY(B10_COPYTEXTFIELD.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PSIZETEXT.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10 is
  begin
    for i__ in 1..B10TEXTFIELD.count loop
-- Validating field values before DML. Use (i__) to access fields values.
    null; end loop;
  null; end;
  procedure pcommit_B10_COPY is
  begin
    for i__ in 1..B10_COPYTEXTFIELD.count loop
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
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldGBUTTONSRC return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldMESSAGE return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowFieldWARNING return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 then 
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
  function ShowBlockB10_COPY_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 or nvl(PAGE,0) = 1 or nvl(PAGE,0) = 2 then 
       return true;
    end if;
    return false;
  end; 
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock">TextArea Type L</div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10TEXTFIELD"><span id="B10TEXTFIELD_LAB" class="label"></span></td><td class="rasdTxB10TEXTFIELD rasdTxTypeL" id="rasdTxB10TEXTFIELD_1"><textarea name="B10TEXTFIELD_1" id="B10TEXTFIELD_1_RASD" class="rasdTextarea" cols="132" rows="20">');  htpClob( B10TEXTFIELD(1) );  
htp.prn('</textarea></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_B10_COPY_DIV is begin htp.p('');  if  ShowBlockB10_COPY_DIV  then  
htp.prn('<div  id="B10_COPY_DIV" class="rasdblock"><div>
<caption><div id="B10_COPY_LAB" class="labelblock">TextArea Type C </div></caption>
<table border="0" id="B10_COPY_TABLE"><tr id="B10_COPY_BLOCK"><td class="rasdTxLab rasdTxLabBlockB10_COPY" id="rasdTxLabB10_COPYTEXTFIELD"><span id="B10_COPYTEXTFIELD_LAB" class="label"></span></td><td class="rasdTxB10_COPYTEXTFIELD rasdTxTypeC" id="rasdTxB10_COPYTEXTFIELD_1"><textarea name="B10_COPYTEXTFIELD_1" id="B10_COPYTEXTFIELD_1_RASD" class="rasdTextarea" cols="132" rows="20">'||B10_COPYTEXTFIELD(1)||'</textarea></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPSIZETEXT"><span id="PSIZETEXT_LAB" class="label">New text size (limit 32767 type L, 4000 type C):</span></td><td class="rasdTxPSIZETEXT rasdTxTypeC" id="rasdTxPSIZETEXT_1"><input name="PSIZETEXT_1" id="PSIZETEXT_1_RASD" type="text" value="'||PSIZETEXT(1)||'" class="rasdTextC"/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPSIZETEXTPREP"><span id="PSIZETEXTPREP_LAB" class="label">Text size prepared:</span></td><td class="rasdTxPSIZETEXTPREP rasdTxTypeC" id="rasdTxPSIZETEXTPREP_1"><font id="PSIZETEXTPREP_1_RASD" class="rasdFont">'||PSIZETEXTPREP(1)||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPREADSIZETEXT"><span id="PREADSIZETEXT_LAB" class="label">Text size read:</span></td><td class="rasdTxPREADSIZETEXT rasdTxTypeC" id="rasdTxPREADSIZETEXT_1"><font id="PREADSIZETEXT_1_RASD" class="rasdFont">'||PREADSIZETEXT(1)||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPCP"><span id="PCP_LAB" class="label"> </span></td><td class="rasdTxPCP rasdTxTypeC" id="rasdTxPCP_1"><font id="PCP_1_RASD" class="rasdFont">'||PCP(1)||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPRUNME"><span id="PRUNME_LAB" class="label"></span></td><td class="rasdTxPRUNME rasdTxTypeC" id="rasdTxPRUNME_1"><input onclick=" ACTION.value=this.value; submit();" name="PRUNME_1" id="PRUNME_1_RASD" type="button" value="'||PRUNME(1)||'" class="rasdButton"/>
</td></tr><tr></tr></table></div></div>');  end if;  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','TEXT EDITOR test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="TEST_TEXTEDITORSIZE_LAB" class="rasdFormLab">TEXT EDITOR test '|| rasd_client.getHtmlDataTable('TEST_TEXTEDITORSIZE_LAB') ||'     </div><div id="TEST_TEXTEDITORSIZE_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('TEST_TEXTEDITORSIZE_MENU') ||'     </div>
<form name="TEST_TEXTEDITORSIZE" method="post" action="?"><div id="TEST_TEXTEDITORSIZE_DIV" class="rasdForm"><div id="TEST_TEXTEDITORSIZE_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
<input name="PAGE" id="PAGE_RASD" type="hidden" value="'||PAGE||'"/>
</div><div id="TEST_TEXTEDITORSIZE_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_COPY_DIV; htp.p(''); output_B10_DIV; htp.p('</div><div id="TEST_TEXTEDITORSIZE_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="TEST_TEXTEDITORSIZE_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="TEST_TEXTEDITORSIZE_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="TEST_TEXTEDITORSIZE_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('TEST_TEXTEDITORSIZE_FOOTER',1,instr('TEST_TEXTEDITORSIZE_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="TEST_TEXTEDITORSIZE" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('<page><![CDATA['||PAGE||']]></page>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<psizetext><![CDATA['||PSIZETEXT(1)||']]></psizetext>'); 
    htp.p('<psizetextprep><![CDATA['||PSIZETEXTPREP(1)||']]></psizetextprep>'); 
    htp.p('<preadsizetext><![CDATA['||PREADSIZETEXT(1)||']]></preadsizetext>'); 
    htp.p('<pcp><![CDATA['||PCP(1)||']]></pcp>'); 
    htp.p('<prunme><![CDATA['||PRUNME(1)||']]></prunme>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10textfield><![CDATA['||B10TEXTFIELD(1)||']]></b10textfield>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    if ShowBlockb10_copy_DIV then 
    htp.p('<b10_copy>'); 
    htp.p('<element>'); 
    htp.p('<b10_copytextfield><![CDATA['||B10_COPYTEXTFIELD(1)||']]></b10_copytextfield>'); 
    htp.p('</element>'); 
  htp.p('</b10_copy>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"TEST_TEXTEDITORSIZE","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p(',"page":"'||escapeRest(PAGE)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"psizetext":"'||escapeRest(PSIZETEXT(1))||'"'); 
    htp.p(',"psizetextprep":"'||escapeRest(PSIZETEXTPREP(1))||'"'); 
    htp.p(',"preadsizetext":"'||escapeRest(PREADSIZETEXT(1))||'"'); 
    htp.p(',"pcp":"'||escapeRest(PCP(1))||'"'); 
    htp.p(',"prunme":"'||escapeRest(PRUNME(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
     htp.p('{'); 
    htp.p('"b10textfield":"'||escapeRest(B10TEXTFIELD(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"b10":[]'); 
  end if; 
    if ShowBlockb10_copy_DIV then 
    htp.p(',"b10_copy":['); 
     htp.p('{'); 
    htp.p('"b10_copytextfield":"'||escapeRest(B10_COPYTEXTFIELD(1))||'"'); 
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
  rasd_client.secCheckPermission('TEST_TEXTEDITORSIZE',ACTION);  
  if ACTION is null then null;
    pselect;
    poutput;
  elsif ACTION = GBUTTONSRC then     pselect;
    poutput;
  end if;

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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','TEXT EDITOR test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="TEST_TEXTEDITORSIZE_LAB" class="rasdFormLab">TEXT EDITOR test '|| rasd_client.getHtmlDataTable('TEST_TEXTEDITORSIZE_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('TEST_TEXTEDITORSIZE_FOOTER',1,instr('TEST_TEXTEDITORSIZE_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('TEST_TEXTEDITORSIZE',ACTION);  

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
  rasd_client.secCheckCredentials(  name_array , value_array ); 

  -- The program execution sequence based on  ACTION defined.
  psubmit(name_array ,value_array);
  rasd_client.secCheckPermission('TEST_TEXTEDITORSIZE',ACTION);  
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
<form name="TEST_TEXTEDITORSIZE" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"TEST_TEXTEDITORSIZE","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>70</formid><form>TEST_TEXTEDITORSIZE</form><version>1</version><change>08.01.2020 09/57/15</change><user>RASDCLI</user><label><![CDATA[TEXT EDITOR test]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>09.12.2019 10/50/20</change><compileyn>N</compileyn><application>Test</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
end TEST_TEXTEDITORSIZE;
/

