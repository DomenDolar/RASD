create or replace package DEMO_PHASER is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_PHASER generated on 05.02.20 by user RASDCLI.     
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

create or replace package body DEMO_PHASER is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DEMO_PHASER generated on 05.02.20 by user RASDCLI.    
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
  PTEXT                         ctab;
  CANVASGAME                    ctab;
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
        rasd_client.callLog('DEMO_PHASER',v_clob, systimestamp, '' );
       end; 
procedure pLog is begin htpClob('<div class="debug">'||log__||'</div>'); end;
     function FORM_UIHEAD return clob is
       begin
        return  '
<script src="https://cdn.jsdelivr.net/npm/phaser@3.15.1/dist/phaser-arcade-physics.min.js"></script>

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
   return 'v.1.1.20200205142453'; 
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
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PTEXT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('CANVASGAME_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        CANVASGAME(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PTEXT') and PTEXT.count = 0 and value_array(i__) is not null then
        PTEXT(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('CANVASGAME') and CANVASGAME.count = 0 and value_array(i__) is not null then
        CANVASGAME(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if CANVASGAME.count > v_max then v_max := CANVASGAME.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not CANVASGAME.exists(i__) then
        CANVASGAME(i__) := null;
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
--<POST_SUBMIT formid="71" blockid="">
PTEXT(1) := 'Sample of Phaser animation. Documentation on <a target="_blank" href="https://phaser.io/examples">https://phaser.io//</a>';
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
  procedure pclear_CANVAS(pstart number) is
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
        CANVASGAME(i__) := null;

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
    pclear_CANVAS(0);

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PTEXT.count);
  null; end;
  procedure pselect_CANVAS is
    i__ pls_integer;
  begin
      pclear_CANVAS(CANVASGAME.count);
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
  procedure pcommit_CANVAS is
  begin
    for i__ in 1..CANVASGAME.count loop
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
  function ShowFieldMESSAGE return boolean is 
  begin 
    return true;
  end; 
  function ShowFieldWARNING return boolean is 
  begin 
    return true;
  end; 
  function ShowBlockCANVAS_DIV return boolean is 
  begin 
    return true;
  end; 
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
procedure output_CANVAS_DIV is begin htp.p('');  if  ShowBlockCANVAS_DIV  then  
htp.prn('<div  id="CANVAS_DIV" class="rasdblock"><div>
<caption><div id="CANVAS_LAB" class="labelblock">My canvas application</div></caption>
<table border="0" id="CANVAS_TABLE"><tr id="CANVAS_BLOCK"><td class="rasdTxLab rasdTxLabBlockCANVAS" id="rasdTxLabCANVASGAME"><span id="CANVASGAME_LAB" class="label"></span></td><td class="rasdTxCANVASGAME rasdTxTypeC" id="rasdTxCANVASGAME_1"><span id="CANVASGAME_1_RASD">');  Htp.p('
	  	 <div id="my-game" ></div> 
	  
	  
	
	  <script>
    var config = {
        type: Phaser.AUTO,
        width: 800,
        height: 300,
	    parent:''my-game'', 
        physics: {
            default: ''arcade'',
            arcade: {
                gravity: { y: 300 }
            }
        },
        scene: {
            preload: preload,
            create: create
        }
    };

    var game = new Phaser.Game(config);

    function preload ()
    {
  
	  //  this.load.setBaseURL(''http://labs.phaser.io'');

        this.load.image(''sky'', ''http://labs.phaser.io/assets/skies/space3.png'');
        //this.load.image(''logo'', ''assets/sprites/phaser3-logo.png'');
	    this.load.image(''logo'', ''rasdc_files.showfile?pfile=pict/rasd.gif'');        
        this.load.image(''red'', ''http://labs.phaser.io/assets/particles/red.png'');
    }

    function create ()
    {
        this.add.image(400, 300, ''sky'');

        var particles = this.add.particles(''red'');

        var emitter = particles.createEmitter({
            speed: 100,
            scale: { start: 1, end: 0 },
            blendMode: ''ADD''
        });

        var logo = this.physics.add.image(400, 100, ''logo'');

        logo.setVelocity(100, 200);
        logo.setBounce(1, 1);
        logo.setCollideWorldBounds(true);

        emitter.startFollow(logo);
    }
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
    htp.p('function cMFCANVAS() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Phaser animation test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DEMO_PHASER_LAB" class="rasdFormLab">Phaser animation test '|| rasd_client.getHtmlDataTable('DEMO_PHASER_LAB') ||'     </div><div id="DEMO_PHASER_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DEMO_PHASER_MENU') ||'     </div>
<form name="DEMO_PHASER" method="post" action="?"><div id="DEMO_PHASER_DIV" class="rasdForm"><div id="DEMO_PHASER_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
</div><div id="DEMO_PHASER_BODY" class="rasdFormBody">'); output_P_DIV; htp.p(''); output_CANVAS_DIV; htp.p('</div><div id="DEMO_PHASER_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DEMO_PHASER_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DEMO_PHASER_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DEMO_PHASER_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('DEMO_PHASER_FOOTER',1,instr('DEMO_PHASER_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockCANVAS_DIV return boolean is 
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
    htp.p('<form name="DEMO_PHASER" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<ptext><![CDATA['||PTEXT(1)||']]></ptext>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    if ShowBlockcanvas_DIV then 
    htp.p('<canvas>'); 
    htp.p('<element>'); 
    htp.p('<canvasgame><![CDATA['||CANVASGAME(1)||']]></canvasgame>'); 
    htp.p('</element>'); 
  htp.p('</canvas>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DEMO_PHASER","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
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
    if ShowBlockcanvas_DIV then 
    htp.p(',"canvas":['); 
     htp.p('{'); 
    htp.p('"canvasgame":"'||escapeRest(CANVASGAME(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p(',"canvas":[]'); 
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
  rasd_client.secCheckPermission('DEMO_PHASER',ACTION);  
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
    htp.p('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Phaser animation test')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DEMO_PHASER_LAB" class="rasdFormLab">Phaser animation test '|| rasd_client.getHtmlDataTable('DEMO_PHASER_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'DEMO_PHASER' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DEMO_PHASER_FOOTER',1,instr('DEMO_PHASER_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DEMO_PHASER',ACTION);  

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
  rasd_client.secCheckPermission('DEMO_PHASER',ACTION);  
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
<form name="DEMO_PHASER" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DEMO_PHASER","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>71</formid><form>DEMO_PHASER</form><version>1</version><change>05.02.2020 02/24/53</change><user>RASDCLI</user><label><![CDATA[Phaser animation test]]></label><lobid>RASD</lobid><program>?</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>05.02.2020 09/30/10</change><compileyn>N</compileyn><application>Demo</application><owner>demo</owner><editor>demo</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  HTP.p('Content-Disposition: filename="Export_DEMO_PHASER_v.1.1.20200205142453.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end DEMO_PHASER;
/

