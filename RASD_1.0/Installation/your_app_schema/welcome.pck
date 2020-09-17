create or replace package WELCOME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: WELCOME generated on 28.06.20 by user RASDCLI.     
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
  procedure webclient;
  procedure page;
  
end;
/

create or replace package body WELCOME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: WELCOME generated on 28.06.20 by user RASDCLI.    
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
  ERROR                         varchar2(4000);
  MESSAGE                       varchar2(4000);
  WARNING                       varchar2(4000);
  ACTION                        varchar2(4000);
  P1OUTPUT                      ctab;
procedure webclient is
 name_array owa.vc_arr;
 value_array owa.vc_arr; 
begin 

webclient
(
  name_array  ,
  value_array 
);

end;

procedure pagesmall is
  begin
htp.p('
<p>Welcome to one of the top development tools as a service on Oracle platform called <a href="!rasdc_security.logon">Rapid Application Service Development - RASD</a>.</p>
<p>If you know Oracle Forms and would like to try something on web, this is the tool for you. You have blocks, fields, triggers ,...</p>	  
		   <p>
  In upper menu, you have many sample applications development with tool. The documentation of the tool you can find on this <a href="https://sourceforge.net/p/rasd/wiki/Welcome/" target="_blank">Wiki link</a>.
  </p>	  
<p><a href="welcome.page">Click here to visit Home page <i class="fas fa-home"></i></a></p>
	  
<p><a href="TEST_DAD_COMM?GUID=" target="_blank">Click here to see environment settings <i class="fas fa-tools"></i></a></p>
	  
');

  end;
  
procedure page is
  begin

htp.p('

<!DOCTYPE html>
<html lang="en">
<title>Rapid Application Service Development - RASD.</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<LINK REL="SHORTCUT ICON" HREF="rasdc_files.showfile?pfile=pict/rasd.ico" TYPE="text/css">	  
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<style>
body,h1,h2,h3,h4,h5,h6 {font-family: "Lato", sans-serif}
.w3-bar,h1,button {font-family: "Montserrat", sans-serif}
</style>
<body>

<!-- Navbar -->
<div class="w3-top">
  <div class="w3-bar w3-red w3-card w3-left-align w3-large">
    <a class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-red" href="javascript:void(0);" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="#" class="w3-bar-item w3-button w3-padding-large w3-white">Home</a>
    <a href="#welcome" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Welcome</a>
    <a href="#tryit" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Try it</a>
    <a href="#knowledge" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Knowledge</a>
    <a href="#references" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">References</a>
    <a href="#licences" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Licenses</a>    
  </div>

  <!-- Navbar on small screens -->
  <div id="navDemo" class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">

    <a href="#welcome" class="w3-bar-item w3-button w3-padding-large">Welcome</a>
    <a href="#tryit" class="w3-bar-item w3-button w3-padding-large">Try it</a>
    <a href="#knowledge" class="w3-bar-item w3-button w3-padding-large">Knowledge</a>
    <a href="#references" class="w3-bar-item w3-button w3-padding-large">References</a>
    <a href="#licences" class="w3-bar-item w3-button w3-padding-large">Licenses</a>    
  </div>
</div>

<!-- Header -->
<header class="w3-container w3-red w3-center" style="padding:128px 16px">
  <h1 class="w3-margin w3-jumbo">RASD</h1>
  <p class="w3-xlarge">Rapid Application Service Development for Oracle</p>
  <button onclick="window.open(''!rasdc_security.logiranje?1=1&KINBAROPU=demo&BOL=RASD'',''_blank'');" class="w3-button w3-black w3-padding-large w3-large w3-margin-top">Get Started </br>User: demo</br>LineOfBusiness: RASD</button>
</header>

<!-- First Grid -->
<div id="welcome" class="w3-row-padding w3-padding-64 w3-container">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Welcome</h1>
      <h5 class="w3-padding-32">Welcome to one of the top development tools as a service on Oracle platform called <a target="_blank" href="https://sourceforge.net/projects/rasd/">Rapid Application Service Development - RASD</a>.
      <p>If you know Oracle Forms and would like to try something on web, this is the tool for you. You have blocks, fields, triggers ,...</p>
      </h5>
</div>

    <div class="w3-third w3-center">
	  <img width="200px" src="rasdc_files.showfile?pfile=pict/rasd.gif" alt="RASD"/>	  
    </div>
  </div>
</div>


<!-- 2 Grid -->
<div id="tryit" class="w3-row-padding w3-padding-64 w3-container w3-light-grey">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Try it</h1>
      <h5 class="w3-padding-32">
      Enter to development tool (full functional) <a target="_blank" href="!rasdc_security.logiranje?1=1&KINBAROPU=demo&BOL=RASD"> >>>
<i class="fa fa-tools w3-text-red"></i></a>      
     </h5>
<p class="w3-text-grey">
When you try development tool you are logged in as user <b>demo</b> for line of business (LOB) <b>RASD</b>. Because this is a demo page of RASD your credentials are not checked.
</p>

<form name="login">
<p class="w3-text-grey">
You can login with your username <input name="username" value="demo"/> and line of business <input name="lob" value="RASD"/>. All credentials are case sensitive. <a target="_blank" onclick="javascript: window.open(''!rasdc_security.logiranje?1=1&KINBAROPU=''+document.login.username.value+''&BOL=''+document.login.lob.value,''_blank'');">>>><i class="fa fa-tools w3-text-red"></i></a>
</p> 
</form>
     
      <h5 class="w3-padding-32">
      Demo programs <a target="_blank" href="!WELCOME.webclient" > >>>
<i class="fa fa-hand-spock w3-text-red" ></i>
</a>      
     </h5>

<p class="w3-text-grey">
Here you can see created demo programs prepared in RASD.
</p>

	  

      <h5 class="w3-padding-32">
      Usefull links      
     </h5>

<p class="w3-text-grey">
<ul>
  <li><a href="https://sourceforge.net/p/rasd/wiki/Welcome/" target="_blank">Wiki</a></li>
  <li><a href="https://sourceforge.net/p/rasd/wiki/Installation/" target="_blank">Installation</a></li>
  <li><a href="https://sourceforge.net/p/rasd/wiki/Customization/" target="_blank">Customization</a></li>
  <li><a href="https://sourceforge.net/p/rasd/wiki/Documentation/" target="_blank">Documentation</a> >
	<a href="https://sourceforge.net/p/rasd/wiki/RASD_EXECUTE/" target="_blank">RASD programs executing process</a>  
	  </li>
  <li><a href="https://sourceforge.net/p/rasd/discussion/hintsandtipsrasd/" target="_blank">Hints and tips using RASD</a></li>
  <li><a href="https://sourceforge.net/p/rasd/discussion/rasd-step-by-step/" target="_blank">Start using RASD step by step</a></li>
  <li><a href="https://sourceforge.net/p/rasd/tickets/" target="_blank">Tickets</a></li>
</ul>	  
</p>
	  
	  
</div>

    <div class="w3-third w3-center">
      <i class="fa fa-tools fa-9x w3-padding-64 w3-text-red"></i>
    </div>
  </div>
</div>

<!-- 3 Grid -->
<div id="knowledge" class="w3-row-padding w3-padding-64 w3-container">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Recommended knowledge</h1>
      <h5 class="w3-padding-32">
<p>Developer should have basic knowledge of next programming languages:
  <li>PL/SQL for programming additional functionalities (triggers)</li>
  <li>SQL for querying data</li>
  <li>JavaScript (JQuery) with CSS for programing user interface (Default HTML code is generated)</li></p>
</p> 
      </h5>
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-book fa-9x  w3-padding-64 w3-text-red"></i>
    </div>
  </div>
</div>


<!-- 3 Grid -->
<div id="references" class="w3-row-padding w3-padding-64 w3-container w3-light-grey">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>References</h1>
      <h5 class="w3-padding-32">

<p> <a href="/rasddevlib/docs/">Open source libraries used in RASD tool</a>
           </p>
 
      </h5>
	  
	  <h5>
	Open source libraries used in generated applications rasd/rasd_jslib.html
	 <xmp style="background-color: white; font-size: x-small; white-space: pre-wrap; "> 
	  ');

htp.p(
   rasd_client.gethtmljslibrary('','')
);

htp.p('	
	  </xmp>
	  </h5>
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-file-code fa-9x  w3-padding-64 w3-text-red"></i>
    </div>
  </div>
</div>


<!-- Second Grid -->
<div id="licences" class="w3-row-padding w3-padding-64 w3-container">
  <div class="w3-content">
    <div class="w3-third w3-center">
      <i class="fab fa-osi fa-9x w3-padding-64 w3-text-red w3-margin-right"></i>
    </div>

    <div class="w3-twothird">
      <h1>Licenses</h1>
      <h5 class="w3-padding-32">The tool is product of  opensource project <a href="http://rasd.sourceforge.net/" target="_blank">RapidASDev</a> on SourceForge.net.</h5>


    </div>
  </div>
</div>

<div class="w3-container w3-black w3-center w3-opacity w3-padding-64">
    <h1 class="w3-margin w3-xlarge">Make your day easy with things SW can do for you<a onclick="window.open(''test_dad_comm?guid=mySecretToken'',''_blank'')">.</a></h1>
</div>

<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity">  
  <div class="w3-xlarge w3-padding-32">
 </div>
 <p>Running on Oracle Autonomous Database 18c</p>
</footer>

<script>
// Used to toggle the menu on small screens when clicking on the menu button
function myFunction() {
  var x = document.getElementById("navDemo");
  if (x.className.indexOf("w3-show") == -1) {
    x.className += " w3-show";
  } else { 
    x.className = x.className.replace(" w3-show", "");
  }
}
</script>

</body>
</html>
	  	  
');
	   
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
        rasd_client.callLog('WELCOME',v_clob, systimestamp, '' );
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
   return 'v.1.1.20200628171533'; 
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
      elsif  upper(name_array(i__)) = upper('ERROR') then ERROR := value_array(i__);
      elsif  upper(name_array(i__)) = upper('MESSAGE') then MESSAGE := value_array(i__);
      elsif  upper(name_array(i__)) = upper('WARNING') then WARNING := value_array(i__);
      elsif  upper(name_array(i__)) = upper('ACTION') then ACTION := value_array(i__);
      elsif  upper(name_array(i__)) = upper('P1OUTPUT_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        P1OUTPUT(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('P1OUTPUT') and P1OUTPUT.count = 0 and value_array(i__) is not null then
        P1OUTPUT(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if P1OUTPUT.count > v_max then v_max := P1OUTPUT.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not P1OUTPUT.exists(i__) then
        P1OUTPUT(i__) := null;
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
  procedure pclear_P1(pstart number) is
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
        P1OUTPUT(i__) := null;

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
    pclear_P1(0);

  null;
  end;
  procedure pselect_P1 is
    i__ pls_integer;
  begin
      pclear_P1(P1OUTPUT.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_P1 is
  begin
    for i__ in 1..P1OUTPUT.count loop
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
  function ShowBlockP1_DIV return boolean is 
  begin 
    return true;
  end; 
procedure output_P1_DIV is begin htp.p('');  if  ShowBlockP1_DIV  then  
htp.prn('<div  id="P1_DIV" class="rasdblock"><div>
<caption><div id="P1_LAB" class="labelblock"></div></caption>
<table border="0" id="P1_TABLE"><tr id="P1_BLOCK"><td class="rasdTxLab rasdTxLabBlockP1" id="rasdTxLabP1OUTPUT"><span id="P1OUTPUT_LAB" class="label"></span></td><td class="rasdTxP1OUTPUT rasdTxTypeC" id="rasdTxP1OUTPUT_1"><span id="P1OUTPUT_1_RASD">');  pagesmall;  
htp.prn('</span></td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP1() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Welcome to RASD')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="WELCOME_LAB" class="rasdFormLab">Welcome to RASD '|| rasd_client.getHtmlDataTable('WELCOME_LAB') ||'     </div><div id="WELCOME_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('WELCOME_MENU') ||'     </div>
<form name="WELCOME" method="post" action="!welcome.webclient"><div id="WELCOME_DIV" class="rasdForm"><div id="WELCOME_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
</div><div id="WELCOME_BODY" class="rasdFormBody">'); output_P1_DIV; htp.p('</div><div id="WELCOME_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="WELCOME_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="WELCOME_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="WELCOME_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('WELCOME_FOOTER',1,instr('WELCOME_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockP1_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="WELCOME" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('</formfields>'); 
    if ShowBlockp1_DIV then 
    htp.p('<p1>'); 
    htp.p('<element>'); 
    htp.p('<p1output><![CDATA['||P1OUTPUT(1)||']]></p1output>'); 
    htp.p('</element>'); 
  htp.p('</p1>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"WELCOME","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p(',"action":"'||escapeRest(ACTION)||'"'); 
    htp.p('},'); 
    if ShowBlockp1_DIV then 
    htp.p('"p1":['); 
     htp.p('{'); 
    htp.p('"p1output":"'||escapeRest(P1OUTPUT(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p1":[]'); 
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
  rasd_client.secCheckPermission('WELCOME',ACTION);  
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
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','Welcome to RASD')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="WELCOME_LAB" class="rasdFormLab">Welcome to RASD '|| rasd_client.getHtmlDataTable('WELCOME_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">'||sqlerrm||'('||sqlcode||')</div></div><div class="rasdHtmlErrorText">');declare   v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;   v_nl varchar2(2) := chr(10); begin rlog('ERROR:'||v_trace); htp.p ( 'Error trace'||':'||'<br/>'|| replace(v_trace, v_nl ,'<br/>'));htp.p ( '</div><div class="rasdHtmlErrorText">'||'Error stack'||':'||'<br/>'|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,'<br/>'));rlog('ERROR:'||DBMS_UTILITY.FORMAT_ERROR_STACK); htp.p('</div>');rlog('ERROR:...'); declare   v_line  number;  v_x varchar2(32000); begin v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  v_line := substr(v_x,instr(v_x,' ',-1));for r in  (select line, text from user_source s where s.name = 'WELCOME' and line > v_line-5 and line < v_line+5 ) loop rlog('ERROR:'||r.line||' - '||r.text); end loop;  rlog('ERROR:...'); exception when others then null;end;end;htp.p('</div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('WELCOME_FOOTER',1,instr('WELCOME_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('WELCOME',ACTION);  

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
  rasd_client.secCheckPermission('WELCOME',ACTION);  
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
<form name="WELCOME" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"WELCOME","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>17</formid><form>WELCOME</form><version>1</version><change>28.06.2020 05/15/33</change><user>RASDCLI</user><label><![CDATA[Welcome to RASD]]></label><lobid>RASD</lobid><program>!welcome.webclient</program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>19.12.2017 12/45/45</change><compileyn>N</compileyn><application>...</application><owner>rasd</owner><editor>rasd</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
  HTP.p('Content-Disposition: filename="Export_WELCOME_v.1.1.20200628171533.xml"');
  owa_util.http_header_close;
  htp.p('<?xml version="1.0" encoding="UTF-8" ?>');
     v_vc := metadata_xml;
     for i in 1..v_vc.count loop
       htp.prn(v_vc(i));
     end loop;
  end;
end WELCOME;
/

