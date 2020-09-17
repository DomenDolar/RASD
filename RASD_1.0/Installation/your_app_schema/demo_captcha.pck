create or replace package DEMO_CAPTCHA is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_CAPTCHA generated on 08.01.20 by user RASDCLI.     
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
procedure ShowImage (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);

end;
/

create or replace package body DEMO_CAPTCHA is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_CAPTCHA generated on 08.01.20 by user RASDCLI.    
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
;  GBUTTONSRC                    varchar2(4000) := 'Check'
;
  MESSAGE                       varchar2(4000);  PAGE                          number := 0
;
  WARNING                       varchar2(4000);
  PTEXT                         ctab;
  B10CAPTCHAVALUE               ctab;
  B10CAPTCHAIMAGE               ctab;
  B10CAPTCHATEXT                ctab;
procedure ShowImage (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
 pt raw(100);
 l_lob blob;
 vt varchar2(100);
 FUNCTION namedParam(
  p_searchVal   in varchar2,
  p_name_array  in owa.vc_arr,
  p_value_array in owa.vc_arr
  ) RETURN varchar2 IS
  i integer;
 BEGIN
  FOR i IN 1..nvl(p_name_array.count,0) LOOP
    if p_name_array(i)=p_searchVal then
      return p_value_array(i);
    end if;
  END LOOP;
  return null;
 END;
begin
pt := namedParam(
  'pt',
  name_array ,
  value_array
  );
pt := utl_encode.base64_decode(pt);
vt := utl_raw.cast_to_varchar2(pt);
l_lob := dd_bmp.captcha(vt);
owa_util.mime_header( 'image/bmp', FALSE );
htp.p('Content-length: '  || dbms_lob.getlength( l_lob ));
owa_util.http_header_close;
wpg_docload.download_file( l_lob );

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
        rasd_client.callLog('31','||v_clob||', systimestamp, '' );
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
   return 'v.1.1.20200108100007'; 
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
if B10CAPTCHAVALUE(i__) is null then vc := rasd_client.sessionGetValue('B10CAPTCHAVALUE'); B10CAPTCHAVALUE(i__)  := vc;  end if; 
if B10CAPTCHAIMAGE(i__) is null then vc := rasd_client.sessionGetValue('B10CAPTCHAIMAGE'); B10CAPTCHAIMAGE(i__)  := vc;  end if; 
if B10CAPTCHATEXT(i__) is null then vc := rasd_client.sessionGetValue('B10CAPTCHATEXT'); B10CAPTCHATEXT(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('PTEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PTEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHAVALUE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10CAPTCHAVALUE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHAIMAGE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10CAPTCHAIMAGE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHATEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        B10CAPTCHATEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT') and PTEXT.count = 0 and value_array(i__) is not null then
        PTEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHAVALUE') and B10CAPTCHAVALUE.count = 0 and value_array(i__) is not null then
        B10CAPTCHAVALUE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHAIMAGE') and B10CAPTCHAIMAGE.count = 0 and value_array(i__) is not null then
        B10CAPTCHAIMAGE(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('B10CAPTCHATEXT') and B10CAPTCHATEXT.count = 0 and value_array(i__) is not null then
        B10CAPTCHATEXT(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if B10CAPTCHAVALUE.count > v_max then v_max := B10CAPTCHAVALUE.count; end if;
    if B10CAPTCHAIMAGE.count > v_max then v_max := B10CAPTCHAIMAGE.count; end if;
    if B10CAPTCHATEXT.count > v_max then v_max := B10CAPTCHATEXT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not B10CAPTCHAVALUE.exists(i__) then
        B10CAPTCHAVALUE(i__) := null;
      end if;
      if not B10CAPTCHAIMAGE.exists(i__) then
        B10CAPTCHAIMAGE(i__) := null;
      end if;
      if not B10CAPTCHATEXT.exists(i__) then
        B10CAPTCHATEXT(i__) := null;
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
--<POST_SUBMIT formid="31" blockid="">
PTEXT(1) := 'Demo show''s how to integrate CAPATCHA into the page!';



declare
 x raw(100);
 vct_raw raw(100);
 vcv_raw raw(100);
 v varchar2(100);
begin
   vct_raw :=  utl_raw.cast_to_raw(B10CAPTCHATEXT(1));
   vcv_raw :=  B10CAPTCHAVALUE(1);

--htp.p(utl_encode.base64_encode(vct_raw));
--htp.p(vcv_raw );
begin

if utl_encode.base64_encode(vct_raw) = vcv_raw then
  message := 'Written text is OK.';
else
  message := 'Written text is NOT ok!';
end if;

exception when others then null;
  message := 'Written text is NOT ok!';
end;
 B10CAPTCHATEXT(1) := '';
 
 v := dd_random.rndchar||dd_random.rndchar||dd_random.rndchar||dd_random.rndchar;

 x := utl_raw.cast_to_raw(v);

 B10CAPTCHAVALUE(1) := utl_encode.base64_encode(x);
 B10CAPTCHAIMAGE(1) := '<img src="!DEMO_CAPTCHA.ShowImage?pt='||B10CAPTCHAVALUE(1)||'">';
end;
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
      if 1 = 0 then k__ := i__ + 0;
      else  
       if i__ > 1 then  k__ := i__ + 0;
       else k__ := 0 + 1;
       end if;
      end if;
      j__ := i__;
      for i__ in j__+1..k__ loop
-- Generated initialization of the fields in new record. Use (i__) to access fields values.
        B10CAPTCHAVALUE(i__) := null;
        B10CAPTCHAIMAGE(i__) := null;
        B10CAPTCHATEXT(i__) := null;

      end loop;
  end;
  procedure pclear_form is
  begin
    ERROR := null;
    GBUTTONRES := 'GBUTTONRES';
    GBUTTONSRC := 'Check';
    MESSAGE := null;
    PAGE := 0;
    WARNING := null;
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
      pclear_B10(B10CAPTCHAVALUE.count);
  null; end;
  procedure pselect is
  begin
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
    for i__ in 1..B10CAPTCHAVALUE.count loop
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
  function ShowBlockP_DIV return boolean is 
  begin 
    if  nvl(PAGE,0) = 0 then 
       return true;
    end if;
    return false;
  end; 
procedure output_B10_DIV is begin htp.p('');  if  ShowBlockB10_DIV  then  
htp.prn('<div  id="B10_DIV" class="rasdblock"><div>
<caption><div id="B10_LAB" class="labelblock"></div></caption>
<table border="0" id="B10_TABLE"><tr id="B10_BLOCK"><span id="" value="1" name="" class="hiddenRowItems"><input name="B10CAPTCHAVALUE_1" id="B10CAPTCHAVALUE_1_RASD" type="hidden" value="'||B10CAPTCHAVALUE(1)||'"/>
</span><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10CAPTCHAIMAGE"><span id="B10CAPTCHAIMAGE_LAB" class="label"></span></td><td class="rasdTxB10CAPTCHAIMAGE rasdTxTypeC" id="rasdTxB10CAPTCHAIMAGE_1"><font id="B10CAPTCHAIMAGE_1_RASD" class="rasdFont">'||B10CAPTCHAIMAGE(1)||'</font></td></tr><tr><td class="rasdTxLab rasdTxLabBlockB10" id="rasdTxLabB10CAPTCHATEXT"><span id="B10CAPTCHATEXT_LAB" class="label">Write text from picture:</span></td><td class="rasdTxB10CAPTCHATEXT rasdTxTypeC" id="rasdTxB10CAPTCHATEXT_1"><input name="B10CAPTCHATEXT_1" id="B10CAPTCHATEXT_1_RASD" type="text" value="'||B10CAPTCHATEXT(1)||'" class="rasdTextC"/>
</td></tr><tr></tr></table></div></div>');  end if;  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Captcha sample')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_CAPTCHA_LAB" class="rasdFormLab">Captcha sample '|| rasd_client.getHtmlDataTable('DEMO_CAPTCHA_LAB') ||'     </div><div id="DEMO_CAPTCHA_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_CAPTCHA_MENU') ||'     </div>
<form name="DEMO_CAPTCHA" method="post"><div id="DEMO_CAPTCHA_DIV" class="rasdForm"><div id="DEMO_CAPTCHA_HEAD" class="rasdFormHead"><input name="PAGE" id="PAGE_RASD" type="hidden" value="'||ltrim(to_char(PAGE))||'"/>
<input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
</div><div id="DEMO_CAPTCHA_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_B10_DIV; htp.p('</div><div id="DEMO_CAPTCHA_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_CAPTCHA_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_CAPTCHA_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_CAPTCHA_FOOTER" class="rasdFormFooter">');  
if  ShowFieldGBUTTONSRC  then  
htp.prn('<input onclick=" ACTION.value=this.value; submit();" name="GBUTTONSRC" id="GBUTTONSRC_RASD" type="button" value="'||GBUTTONSRC||'" class="rasdButton"/>');  end if;  
htp.prn('
'|| rasd_client.getHtmlFooter(version , substr('DEMO_CAPTCHA_FOOTER',1,instr('DEMO_CAPTCHA_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DEMO_CAPTCHA" version="1">'); 
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
    htp.p('<ptext><![CDATA['||PTEXT(1)||']]></ptext>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p('<b10>'); 
    htp.p('<element>'); 
    htp.p('<b10captchavalue><![CDATA['||B10CAPTCHAVALUE(1)||']]></b10captchavalue>'); 
    htp.p('<b10captchaimage><![CDATA['||B10CAPTCHAIMAGE(1)||']]></b10captchaimage>'); 
    htp.p('<b10captchatext><![CDATA['||B10CAPTCHATEXT(1)||']]></b10captchatext>'); 
    htp.p('</element>'); 
  htp.p('</b10>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_CAPTCHA","@version":"1",' ); 
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
    htp.p('"ptext":"'||escapeRest(PTEXT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
  end if; 
    if ShowBlockb10_DIV then 
    htp.p(',"b10":['); 
     htp.p('{'); 
    htp.p('"b10captchavalue":"'||escapeRest(B10CAPTCHAVALUE(1))||'"'); 
    htp.p(',"b10captchaimage":"'||escapeRest(B10CAPTCHAIMAGE(1))||'"'); 
    htp.p(',"b10captchatext":"'||escapeRest(B10CAPTCHATEXT(1))||'"'); 
    htp.p('}'); 
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
  rasd_client.secCheckPermission('DEMO_CAPTCHA',ACTION);  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Captcha sample')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DEMO_CAPTCHA_LAB" class="rasdFormLab">Captcha sample '|| rasd_client.getHtmlDataTable('DEMO_CAPTCHA_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DEMO_CAPTCHA_FOOTER',1,instr('DEMO_CAPTCHA_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DEMO_CAPTCHA',ACTION);  

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
  rasd_client.secCheckPermission('DEMO_CAPTCHA',ACTION);  
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
<form name="DEMO_CAPTCHA" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_CAPTCHA","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>31</formid><form>DEMO_CAPTCHA</form><version>1</version><change>08.01.2020 10/00/07</change><user>RASDCLI</user><label><![CDATA[Captcha sample]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>Y</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>15.12.2017 11/37/18</change><compileyn>Y</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks><block><blockid>B10</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>B10</blockid><fieldid>CAPTCHAIMAGE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>11</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10CAPTCHAIMAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>CAPTCHATEXT</fieldid><type>C</type><format></format><element></element><hiddenyn></hiddenyn><orderby>12</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10CAPTCHATEXT</nameid><label><![CDATA[Write text from picture:]]></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid>B10</blockid><fieldid>CAPTCHAVALUE</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>10</orderby><pkyn>N</pkyn><selectyn>N</selec';
 v_vc(2) := 'tyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>B10CAPTCHAVALUE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block><block><blockid>P</blockid><sqltable></sqltable><numrows>1</numrows><emptyrows></emptyrows><dbblockyn>N</dbblockyn><rowidyn>N</rowidyn><pagingyn>N</pagingyn><clearyn>N</clearyn><sqltext>
</sqltext><label></label><source>V</source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid><fields><field><blockid>P</blockid><fieldid>TEXT</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>1</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>PTEXT</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields></block></blocks><fields><field><blockid></blockid><fieldid>ACTION</fieldid><type>C</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ACTION</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>ERROR</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn></pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>ERROR</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><f';
 v_vc(3) := 'ieldid>GBUTTONRES</fieldid><type>C</type><format></format><element>INPUT_RESET</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''GBUTTONRES'']]></defaultval><elementyn>N</elementyn><nameid>GBUTTONRES</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>GBUTTONSRC</fieldid><type>C</type><format></format><element>INPUT_SUBMIT</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[''Check'']]></defaultval><elementyn>Y</elementyn><nameid>GBUTTONSRC</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>MESSAGE</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>MESSAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>PAGE</fieldid><type>N</type><format></format><element>INPUT_HIDDEN</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>N</pkyn><selectyn>N</selectyn><insertyn>N</insertyn><updateyn>N</updateyn><deleteyn>N</deleteyn><insertnnyn>N</insertnnyn><notnullyn>N</notnullyn><lockyn>N</lockyn><defaultval><![CDATA[0]]></defaultval><elementyn>Y</elementyn><nameid>PAGE</nameid><label></label><linkid></linkid><source>V</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field><field><blockid></blockid><fieldid>WARNING</fieldid><type>C</type><format></format><element>FONT_</element><hiddenyn></hiddenyn><orderby>0</orderby><pkyn>';
 v_vc(4) := '</pkyn><selectyn></selectyn><insertyn></insertyn><updateyn></updateyn><deleteyn></deleteyn><insertnnyn></insertnnyn><notnullyn></notnullyn><lockyn></lockyn><defaultval></defaultval><elementyn>Y</elementyn><nameid>WARNING</nameid><label></label><linkid></linkid><source>G</source><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid><includevis></includevis></field></fields><links></links><pages><pagedata><page>0</page><blockid>B10</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid>P</blockid><fieldid></fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid></blockid><fieldid>GBUTTONRES</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid></blockid><fieldid>GBUTTONSRC</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata><pagedata><page>0</page><blockid></blockid><fieldid>MESSAGE</fieldid><rlobid></rlobid><rform></rform><rblockid></rblockid><rfieldid></rfieldid></pagedata></pages><triggers><trigger><blockid></blockid><triggerid>Captcha</triggerid><plsql><![CDATA[procedure ShowImage (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
 pt raw(100);
 l_lob blob;
 vt varchar2(100);
 FUNCTION namedParam(
  p_searchVal   in varchar2,
  p_name_array  in owa.vc_arr,
  p_value_array in owa.vc_arr
  ) RETURN varchar2 IS
  i integer;
 BEGIN
  FOR i IN 1..nvl(p_name_array.count,0) LOOP
    if p_name_array(i)=p_searchVal then
      return p_value_array(i);
    end if;
  END LOOP;
  return null;
 END;
begin
pt := namedParam(
  ''pt'',
  name_array ,
  value_array
  );
pt := utl_encode.base64_decode(pt);
vt := utl_raw.cast_to_varchar2(pt);
l_lob := dd_bmp.captcha(vt);
owa_util.mime_header( ''image/bmp'', FALSE );
htp.p(''Content-length: ''  || dbms_lob.getlength( l_lob ));
owa_util.http_header_close;
wpg_docload.download_file( l_lob );

end;

]]></plsql><plsqlspec><![CDATA[procedure ShowImage (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);

]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger><trigger><blockid></blockid><triggerid>POST_SUBMIT</triggerid><plsql';
 v_vc(5) := '><![CDATA[ptext := ''Demo show''''s how to integrate CAPATCHA into the page!'';



declare
 x raw(100);
 vct_raw raw(100);
 vcv_raw raw(100);
 v varchar2(100);
begin
   vct_raw :=  utl_raw.cast_to_raw(B10CAPTCHATEXT);
   vcv_raw :=  B10CAPTCHAVALUE;

--htp.p(utl_encode.base64_encode(vct_raw));
--htp.p(vcv_raw );
begin

if utl_encode.base64_encode(vct_raw) = vcv_raw then
  message := ''Written text is OK.'';
else
  message := ''Written text is NOT ok!'';
end if;

exception when others then null;
  message := ''Written text is NOT ok!'';
end;
 B10CAPTCHATEXT := '''';
 
 v := dd_random.rndchar||dd_random.rndchar||dd_random.rndchar||dd_random.rndchar;

 x := utl_raw.cast_to_raw(v);

 B10CAPTCHAVALUE := utl_encode.base64_encode(x);
 B10CAPTCHAIMAGE := ''<img src="!DEMO_CAPTCHA.ShowImage?pt=''||B10CAPTCHAVALUE||''">'';
end;
]]></plsql><plsqlspec><![CDATA[-- Executing after filling fields on submit.
]]></plsqlspec><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rblockid></rblockid></trigger></triggers><elements><element><elementid>1</elementid><pelementid>0</pelementid><orderby>1</orderby><element>HTML_</element><type></type><id>HTML</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<html]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>2</elementid><pelementid>1</pelementid><orderby>1</orderby><element>HEAD_</element><type></type><id>HEAD</id><nameid>HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></in';
 v_vc(6) := 'cludevis><attributes><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<head]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<% htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Captcha sample'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>''); %>]]></value><valuecode><![CDATA['');  htpClob(rasd_client.getHtmlJSLibrary(''HEAD'',''Captcha sample'')); htpClob(FORM_UIHEAD); htp.p(''<style type="text/css">''); htpClob(FORM_CSS); htp.p(''</style><script type="text/javascript">''); htpClob(FORM_JS); htp.p(''</script>'');  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>15</elementid><pelementid>1</pelementid><orderby>1</orderby><element>BODY_</element><type></type><id>BODY</id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CD';
 v_vc(7) := 'ATA[<body]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>16</elementid><pelementid>15</pelementid><orderby>3</orderby><element>FORM_</element><type>F</type><id>DEMO_CAPTCHA</id><nameid>DEMO_CAPTCHA</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_ACTION</attribute><type>A</type><text></text><name><![CDATA[action]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_METHOD</attribute><type>A</type><text></text><name><![CDATA[method]]></name><value><![CDATA[post]]></value><valuecode><![CDATA[="post"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[DEMO_CAPTCHA]]></value><valuecode><![CDATA[="DEMO_CAPTCHA"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<form]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></v';
 v_vc(8) := 'alueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>17</elementid><pelementid>15</pelementid><orderby>1</orderby><element>FORM_LAB</element><type>F</type><id>DEMO_CAPTCHA_LAB</id><nameid>DEMO_CAPTCHA_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormLab]]></value><valuecode><![CDATA[="rasdFormLab"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_LAB]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Captcha sample <%= rasd_client.getHtmlDataTable(''DEMO_CAPTCHA_LAB'') %>     ]]></value><valuecode><![CDATA[Captcha sample ''|| rasd_client.getHtmlDataTable(''DEMO_CAPTCHA_LAB'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><t';
 v_vc(9) := 'extid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>18</elementid><pelementid>15</pelementid><orderby>2</orderby><element>FORM_MENU</element><type>F</type><id>DEMO_CAPTCHA_MENU</id><nameid>DEMO_CAPTCHA_MENU</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMenu]]></value><valuecode><![CDATA[="rasdFormMenu"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_MENU]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_MENU"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlMenuList(''DEMO_CAPTCHA_MENU'') %>     ]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlMenuList(''DEMO_CAPTCHA_MENU'') ||''     ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid><';
 v_vc(10) := '/rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>19</elementid><pelementid>16</pelementid><orderby>3</orderby><element>FORM_DIV</element><type>F</type><id>DEMO_CAPTCHA_DIV</id><nameid>DEMO_CAPTCHA_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdForm]]></value><valuecode><![CDATA[="rasdForm"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_DIV]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>20</elementid><pelementid>19</pelementid><orderby>1</orderby><element>FORM_HEAD</element><type>F</type><id>DEMO_CAPTCHA_HEAD</id><nameid>DEMO_CAPTCHA_HEAD</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><v';
 v_vc(11) := 'alue><![CDATA[rasdFormHead]]></value><valuecode><![CDATA[="rasdFormHead"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_HEAD]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_HEAD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>21</elementid><pelementid>19</pelementid><orderby>2</orderby><element>FORM_BODY</element><type>F</type><id>DEMO_CAPTCHA_BODY</id><nameid>DEMO_CAPTCHA_BODY</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormBody]]></value><valuecode><![CDATA[="rasdFormBody"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_BODY]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_BODY"]]></valuecode><forloop></forloop><endloo';
 v_vc(12) := 'p></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>22</elementid><pelementid>19</pelementid><orderby>9998</orderby><element>FORM_MESSAGE</element><type>F</type><id>DEMO_CAPTCHA_MESSAGE</id><nameid>DEMO_CAPTCHA_MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage]]></value><valuecode><![CDATA[="rasdFormMessage"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_MESSAGE]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_MESSAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobi';
 v_vc(13) := 'd><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>23</elementid><pelementid>19</pelementid><orderby>9996</orderby><element>FORM_ERROR</element><type>F</type><id>DEMO_CAPTCHA_ERROR</id><nameid>DEMO_CAPTCHA_ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage error]]></value><valuecode><![CDATA[="rasdFormMessage error"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_ERROR]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_ERROR"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>24</elementid><pelementid>19</pelementi';
 v_vc(14) := 'd><orderby>9997</orderby><element>FORM_WARNING</element><type>F</type><id>DEMO_CAPTCHA_WARNING</id><nameid>DEMO_CAPTCHA_WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormMessage warning]]></value><valuecode><![CDATA[="rasdFormMessage warning"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_WARNING]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_WARNING"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>25</elementid><pelementid>19</pelementid><orderby>9999</orderby><element>FORM_FOOTER</element><type>F</type><id>DEMO_CAPTCHA_FOOTER</id><nameid>DEMO_CAPTCHA_FOOTER</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFormFooter]]></value><valuecode><![CDATA[="rasdF';
 v_vc(15) := 'ormFooter"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[DEMO_CAPTCHA_FOOTER]]></value><valuecode><![CDATA[="DEMO_CAPTCHA_FOOTER"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[<%= rasd_client.getHtmlFooter(version , substr(''DEMO_CAPTCHA_FOOTER'',1,instr(''DEMO_CAPTCHA_FOOTER'', ''_'',-1)-1) , '''') %>]]></value><valuecode><![CDATA[''|| rasd_client.getHtmlFooter(version , substr(''DEMO_CAPTCHA_FOOTER'',1,instr(''DEMO_CAPTCHA_FOOTER'', ''_'',-1)-1) , '''') ||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>26</elementid><pelementid>21</pelementid><orderby>102</orderby><element>BLOCK_DIV</element><type>B</type><id>P_DIV</id><nameid>P_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><!';
 v_vc(16) := '[CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_DIV]]></value><valuecode><![CDATA[="P_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockP_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockP_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>27</elementid><pelementid>26</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hi';
 v_vc(17) := 'ddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>28</elementid><pelementid>27</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>P_LAB</id><nameid>P_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_LAB]]></value><valuecode><![CDATA[="P_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><n';
 v_vc(18) := 'ame><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>29</elementid><pelementid>26</pelementid><orderby>103</orderby><element>TABLE_</element><type></type><id>P_TABLE</id><nameid>P_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_TABLE_RASD]]></value><valuecode><![CDATA[="P_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></t';
 v_vc(19) := 'extcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>30</elementid><pelementid>29</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>P_BLOCK</id><nameid>P_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[P_BLOCK_RASD]]></value><valuecode><![CDATA[="P_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>31</elementid><pelementid>21</pelementid><orderby>112</orderby><element>BLOCK_DIV</element><type>B</type><id>B10_DIV</id><nameid>B10_DIV</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdblock]]></value><valuecode><![CDATA[="rasdblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_DIV]]></value><valuecode>';
 v_vc(20) := '<![CDATA[="B10_DIV"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>999</orderby><attribute>C_</attribute><type>C</type><text></text><name></name><value><![CDATA[><div>]]></value><valuecode><![CDATA[><div>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value><![CDATA[</div></div><% end if; %>]]></value><valuecode><![CDATA[</div></div>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name></name><value><![CDATA[<% if  ShowBlockB10_DIV  then %><div ]]></value><valuecode><![CDATA['');  if  ShowBlockB10_DIV  then  
htp.prn(''<div ]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>32</elementid><pelementid>31</pelementid><orderby>1</orderby><element>CAPTION_</element><type>L</type><id></id><nameid></nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<caption]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></';
 v_vc(21) := 'valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>33</elementid><pelementid>32</pelementid><orderby>1</orderby><element>FONT_</element><type>B</type><id>B10_LAB</id><nameid>B10_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[labelblock]]></value><valuecode><![CDATA[="labelblock"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_LAB]]></value><valuecode><![CDATA[="B10_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<div]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></';
 v_vc(22) := 'valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>34</elementid><pelementid>31</pelementid><orderby>113</orderby><element>TABLE_</element><type></type><id>B10_TABLE</id><nameid>B10_TABLE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_BORDER</attribute><type>A</type><text></text><name><![CDATA[border]]></name><value><![CDATA[0]]></value><valuecode><![CDATA[="0"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_TABLE_RASD]]></value><valuecode><![CDATA[="B10_TABLE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text><![CDATA[
]]></text><name><![CDATA[<table]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode><![CDATA[
]]></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>35</elementid><pelementid>34</pelementid><orderby>3</orderby><element>TR_</element><type>B</type><id>B10_BLOCK</id><nameid>B10_BLOCK</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attrib';
 v_vc(23) := 'utes><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_BLOCK_RASD]]></value><valuecode><![CDATA[="B10_BLOCK"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>36</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>PAGE</id><nameid>PAGE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PAGE_NAME_RASD]]></value><valuecode><![CDATA[="PAGE_RASD"]]></valuecode><forloop></for';
 v_vc(24) := 'loop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[PAGE_NAME]]></value><valuecode><![CDATA[="PAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[PAGE_VALUE]]></value><valuecode><![CDATA[="''||ltrim(to_char(PAGE))||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</o';
 v_vc(25) := 'rderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>37</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>ACTION</id><nameid>ACTION</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ACTION_NAME_RASD]]></value><valuecode><![CDATA[="ACTION_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[ACTION_NAME]]></value><valuecode><![CDATA[="ACTION"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></';
 v_vc(26) := 'source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[ACTION_VALUE]]></value><valuecode><![CDATA[="''||ACTION||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>38</elementid><pelementid>23</pelementid><orderby>9996</orderby><element>FONT_</element><type>D</type><id>ERROR</id><nameid>ERROR</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![C';
 v_vc(27) := 'DATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[ERROR_NAME_RASD]]></value><valuecode><![CDATA[="ERROR_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></ri';
 v_vc(28) := 'd></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[ERROR_VALUE]]></value><valuecode><![CDATA[''||ERROR||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>39</elementid><pelementid>20</pelementid><orderby>1</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSRC</id><nameid>GBUTTONSRC</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><sour';
 v_vc(29) := 'ce></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSRC_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSRC_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSRC_NAME]]></value><valuecode><![CDATA[="GBUTTONSRC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSRC_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSRC||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hidd';
 v_vc(30) := 'enyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFieldGBUTTONSRC  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>40</elementid><pelementid>25</pelementid><orderby>9999</orderby><element>INPUT_SUBMIT</element><type>D</type><id>GBUTTONSRC</id><nameid>GBUTTONSRC</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdButton]]></value><valuecode><![CDATA[="rasdButton"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[GBUTTONSRC_NAME_RASD]]></value><valuecode><![CDATA[="GBUTTONSRC_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>';
 v_vc(31) := '5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[GBUTTONSRC_NAME]]></value><valuecode><![CDATA[="GBUTTONSRC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[onclick]]></name><value><![CDATA[ ACTION.value=this.value; submit();]]></value><valuecode><![CDATA[=" ACTION.value=this.value; submit();"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[button]]></value><valuecode><![CDATA[="button"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[GBUTTONSRC_VALUE]]></value><valuecode><![CDATA[="''||GBUTTONSRC||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA['');  
if  ShowFi';
 v_vc(32) := 'eldGBUTTONSRC  then  
htp.prn(''<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>'');  end if;  
htp.prn('']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>41</elementid><pelementid>24</pelementid><orderby>9997</orderby><element>FONT_</element><type>D</type><id>WARNING</id><nameid>WARNING</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[WARNING_NAME_RASD]]></value><valuecode><![CDATA[="WARNING_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></';
 v_vc(33) := 'textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[WARNING_VALUE]]></value><valuecode><![CDATA[''||WARNING||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>42</elementid><pelementid>22</pelementid><orderby>9998</orderby><element>FONT_</element><type>D</type><id>MESSAGE</id><name';
 v_vc(34) := 'id>MESSAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[MESSAGE_NAME_RASD]]></value><valuecode><![CDATA[="MESSAGE_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attr';
 v_vc(35) := 'ibute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[MESSAGE_VALUE]]></value><valuecode><![CDATA[''||MESSAGE||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>43</elementid><pelementid>30</pelementid><orderby>1</orderby><element>TX_</element><type>E</type><id></id><nameid>PTEXT_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockP]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockP"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></value';
 v_vc(36) := 'id><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabPTEXT]]></value><valuecode><![CDATA[="rasdTxLabPTEXT"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>44</elementid><pelementid>43</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>PTEXT_LAB</id><nameid>PTEXT_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PTEXT_LAB]]></value><valuecode><![CDATA[="PTEXT_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text';
 v_vc(37) := '></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>45</elementid><pelementid>29</pelementid><orderby>4</orderby><element>TR_</element><type>B</type><id></id><nameid>P_BLOCK4</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>46</elementid><pelementid>30</pelementid><orderby>2</orderby><element>TX_</element><type>E</type><id></id><nameid>PTEXT_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><at';
 v_vc(38) := 'tribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxPTEXT rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxPTEXT rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxPTEXT_NAME]]></value><valuecode><![CDATA[="rasdTxPTEXT_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>47</elementid><pelementid>46</pelementid><orderby>1</orderby><element>FONT_</element><type>D</type><id>PTEXT</id><nameid>PTEXT</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop';
 v_vc(39) := '><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[PTEXT_NAME_RASD]]></value><valuecode><![CDATA[="PTEXT_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</';
 v_vc(40) := 'font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[PTEXT_VALUE]]></value><valuecode><![CDATA[''||PTEXT(1)||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>48</elementid><pelementid>35</pelementid><orderby>1</orderby><element>HIDDFIELD_</element><type></type><id></id><nameid>B10</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>4</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[hiddenRowItems]]></value><valuecode><![CDATA[="hiddenRowItems"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10_ROW]]></value><valuecode><![CDATA[=""]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid>';
 v_vc(41) := '</textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[1]]></value><valuecode><![CDATA[="1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>49</elementid><pelementid>48</pelementid><orderby>1</orderby><element>INPUT_HIDDEN</element><type>D</type><id>B10CAPTCHAVALUE</id><nameid>B10CAPTCHAVALUE</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[CLASS]]></name><value><![CDATA[HIDDEN]]></value><valuecode><![CDATA[="HIDDEN"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![C';
 v_vc(42) := 'DATA[B10CAPTCHAVALUE_NAME_RASD]]></value><valuecode><![CDATA[="B10CAPTCHAVALUE_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10CAPTCHAVALUE_NAME]]></value><valuecode><![CDATA[="B10CAPTCHAVALUE_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[hidden]]></value><valuecode><![CDATA[="hidden"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10CAPTCHAVALUE_VALUE]]></value><valuecode><![CDATA[="''||B10CAPTCHAVALUE(1)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>';
 v_vc(43) := 'Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>50</elementid><pelementid>35</pelementid><orderby>21</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CAPTCHAIMAGE_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10CAPTCHAIMAGE]]></value><valuecode><![CDATA[="rasdTxLabB10CAPTCHAIMAGE"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attri';
 v_vc(44) := 'bute></attributes></element><element><elementid>51</elementid><pelementid>50</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10CAPTCHAIMAGE_LAB</id><nameid>B10CAPTCHAIMAGE_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10CAPTCHAIMAGE_LAB]]></value><valuecode><![CDATA[="B10CAPTCHAIMAGE_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>52</elementid><pelementid>34</pelementid><orderby>24</orderby><element>TR_</element><type>B</type><id></id><nameid>B10_BLOCK24</nameid><endtagelementi';
 v_vc(45) := 'd>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>53</elementid><pelementid>35</pelementid><orderby>22</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CAPTCHAIMAGE_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10CAPTCHAIMAGE rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10CAPTCHAIMAGE rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10CAPTCHAIMAGE_NAME]]></value><valuecode><![CDATA[="rasdTxB10CAPTCHAIMAGE_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rfor';
 v_vc(46) := 'm><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>54</elementid><pelementid>53</pelementid><orderby>1</orderby><element>FONT_</element><type>D</type><id>B10CAPTCHAIMAGE</id><nameid>B10CAPTCHAIMAGE</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdFont]]></value><valuecode><![CDATA[="rasdFont"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10CAPTCHAIMAGE_NAME_RASD]]></value><valuecode><![CDATA[="B10CAPTCHAIMAGE_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[NAME]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></f';
 v_vc(47) := 'orloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ONDBLCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[TYPE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[VALUE]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<font]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[B10CAPTCHAIMAGE_VALUE]]></value><valuecode><![CDATA[''||B10CAPTCHAIMAGE(1)||'']]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>55</elemen';
 v_vc(48) := 'tid><pelementid>52</pelementid><orderby>23</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CAPTCHATEXT_TX_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxLab rasdTxLabBlockB10]]></value><valuecode><![CDATA[="rasdTxLab rasdTxLabBlockB10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxLabB10CAPTCHATEXT]]></value><valuecode><![CDATA[="rasdTxLabB10CAPTCHATEXT"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>56</elementid><pelementid>55</pelementid><orderby>1</orderby><element>FONT_</element><type>L</type><id>B10CAPTCHATEXT_LAB</id><nameid>B10CAPTCHATEXT_LAB</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>3</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[label]]></value><valuecode><![CDATA[="label"]]></val';
 v_vc(49) := 'uecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10CAPTCHATEXT_LAB]]></value><valuecode><![CDATA[="B10CAPTCHATEXT_LAB"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<span]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>V_</attribute><type>V</type><text></text><name></name><value><![CDATA[Write text from picture:]]></value><valuecode><![CDATA[Write text from picture:]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>57</elementid><pelementid>34</pelementid><orderby>26</orderby><element>TR_</element><type>B</type><id></id><nameid>B10_BLOCK26</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform>';
 v_vc(50) := '<rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<tr]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>58</elementid><pelementid>52</pelementid><orderby>24</orderby><element>TX_</element><type>E</type><id></id><nameid>B10CAPTCHATEXT_TX</nameid><endtagelementid>0</endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>2</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTxB10CAPTCHATEXT rasdTxTypeC]]></value><valuecode><![CDATA[="rasdTxB10CAPTCHATEXT rasdTxTypeC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[rasdTxB10CAPTCHATEXT_NAME]]></value><valuecode><![CDATA[="rasdTxB10CAPTCHATEXT_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>E_</attribute><type>E</type><text></text><name><![CDATA[</td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<td]]></name><value><![CDATA[>]]></value><valuecode><![CDATA[>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element><element><elementid>59</elementid><pelementid>58</pelementid><orderby>1</o';
 v_vc(51) := 'rderby><element>INPUT_TEXT</element><type>D</type><id>B10CAPTCHATEXT</id><nameid>B10CAPTCHATEXT</nameid><endtagelementid></endtagelementid><source></source><hiddenyn></hiddenyn><rlobid></rlobid><rform></rform><rid></rid><includevis></includevis><attributes><attribute><orderby>9</orderby><attribute>A_CLASS</attribute><type>A</type><text></text><name><![CDATA[class]]></name><value><![CDATA[rasdTextC]]></value><valuecode><![CDATA[="rasdTextC"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>2</orderby><attribute>A_HREF</attribute><type>A</type><text></text><name><![CDATA[HREF]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>6</orderby><attribute>A_ID</attribute><type>A</type><text></text><name><![CDATA[id]]></name><value><![CDATA[B10CAPTCHATEXT_NAME_RASD]]></value><valuecode><![CDATA[="B10CAPTCHATEXT_1_RASD"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>5</orderby><attribute>A_NAME</attribute><type>A</type><text></text><name><![CDATA[name]]></name><value><![CDATA[B10CAPTCHATEXT_NAME]]></value><valuecode><![CDATA[="B10CAPTCHATEXT_1"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>3</orderby><attribute>A_ONCLICK</attribute><type>A</type><text></text><name><![CDATA[ONCLICK]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>4</orderby><attribute>A_ONDBLCLICK</attribute><type>A</type><text></text><name><![CDATA[ondblclick]]></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><v';
 v_vc(52) := 'alueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>10</orderby><attribute>A_SIZE</attribute><type>A</type><text></text><name><![CDATA[size]]></name><value><![CDATA[10]]></value><valuecode><![CDATA[="10"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>7</orderby><attribute>A_TYPE</attribute><type>A</type><text></text><name><![CDATA[type]]></name><value><![CDATA[text]]></value><valuecode><![CDATA[="text"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>8</orderby><attribute>A_VALUE</attribute><type>A</type><text></text><name><![CDATA[value]]></name><value><![CDATA[B10CAPTCHATEXT_VALUE]]></value><valuecode><![CDATA[="''||B10CAPTCHATEXT(1)||''"]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>11</orderby><attribute>E_</attribute><type>E</type><text></text><name></name><value></value><valuecode></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>Y</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute><attribute><orderby>1</orderby><attribute>S_</attribute><type>S</type><text></text><name><![CDATA[<input]]></name><value><![CDATA[/>]]></value><valuecode><![CDATA[/>]]></valuecode><forloop></forloop><endloop></endloop><source></source><hiddenyn>N</hiddenyn><valueid></valueid><textid></textid><textcode></textcode><rlobid></rlobid><rform></rform><rid></rid></attribute></attributes></element></elements></form>';
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
end DEMO_CAPTCHA;
/

