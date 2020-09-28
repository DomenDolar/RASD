create or replace package DOCUMENTS_API2 is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DOCUMENTS_API2 generated on 10.01.20 by user RASDCLI.     
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
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/

  procedure page(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
    procedure upload (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
  PROCEDURE download_direct (file  IN  VARCHAR2);
  
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
  
end;
/

create or replace package body DOCUMENTS_API2 is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: DOCUMENTS_API2 generated on 10.01.20 by user RASDCLI.    
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
  PLINK                         ctab;
  PFILE                         ctab;
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
   
   procedure page(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is
  RETURNFILE varchar2(1000);
  POSTUPLOADURL varchar2(1000);
  showfilelist varchar2(100);
   begin

         for i in 1..name_array.count loop    
            if upper(name_array(i)) = 'FIN' then RETURNFILE:= value_array(i);
            elsif upper(name_array(i)) = 'POSTUPLOADURL' then POSTUPLOADURL:= value_array(i);
            elsif upper(name_array(i)) = 'SHOWFILES' then showfilelist:= value_array(i);
            end if;
            
           -- htp.p(name_array(i)||'='||value_array(i));
         end loop;

   
      htp.p('
<HTML>
<HEAD>
<meta charset="utf-8" />
<link rel="stylesheet" type="text/css" href="documents_api.download_direct?file=rasd/rasd.css">
<script type="text/javascript" src="documents_api.download_direct?file=rasd/rasd.js"></script>
<script type="text/javascript" src="/rasdlib/docs/jquery-1.11.3.min.js"></script>
<script src="/rasdlib/docs/jquery-ui-1.11.4.custom.zip/jquery-ui-1.11.4.custom/jquery-ui.js"></script>
<link rel="stylesheet" href="/rasdlib/docs/jquery-ui-themes-1.11.4.zip/jquery-ui-themes-1.11.4/themes/redmond/jquery-ui.css">

<script type="text/javascript">

 $(function() {
     addSpinner();   
  });

   var chunkSize = 4000;
   var bytesUploaded = 0;
   
   //$(document).ready(function() {
   //   $("#btnUpload").prop("disabled",true);
   //});

   function sendfile() {
      var files = document.getElementById(''files'').files;
      var datoteka = files[0];
      var reader = new FileReader();

      //progress.style.width = "0%"; //IE ERROR
      progress.textContent = "0%";

      reader.onloadend = function(evt) {
         if(evt.target.readyState == FileReader.DONE) { 
            //console.log("zacetk: "+evt.target.result.byteLength);
            sendChunk(evt.target.result, datoteka);
         }
      };
      reader.readAsArrayBuffer(datoteka);
   }
   
   function outputLink() {
      var files = document.getElementById(''files'').files;
      var datoteka = files[0];
     $("#rasdSpinner").hide(); 
     $("#btnUpload").prop("disabled",false);
     $("#download").html( ''Download file: <A HREF="documents_api2.download_direct?file='||user||'/''+ encodeURIComponent(datoteka.name) +''" target="_bank">'' + datoteka.name+''</A>'');     
');
if POSTUPLOADURL is not null then 

htp.p('      window.location = "'||
  replace(
    replace(
      replace(
       replace(
        replace(POSTUPLOADURL,'RETURNFILE',user||'/"+encodeURIComponent(datoteka.name)+"'),'%3F','?'),'%3D','='),'%26','&'),'%21','!')

        ||'";')
;


end if;

if RETURNFILE is not null then 
htp.p('      window.opener.'||RETURNFILE||'.value = '''||user||'/''+ encodeURIComponent(datoteka.name);');
end if;
htp.p('		
   }   
	
   function _arrayBufferToBase64(buffer) {
      var binary = '''';
      var bytes = new Uint8Array(buffer);
      var len = bytes.byteLength;
      for(var i = 0; i < len; i++) {
         binary += String.fromCharCode(bytes[i]);
      }
      return window.btoa(binary);
   }
   
   function output(perc) {
       // console.log("percentLoaded: "+perc + " %");

       // progress.style.width = perc + ''%''; //IE ERROR
        progress.textContent = perc + ''% uploaded'';
        
        //$("#fileUploadProgress").html(perc + " %");
        //document.getElementById("fileUploadProgress2").value( perc + " %");
        //alert(perc);                   
   }
   
   function sendChunk(fileText, file) {
      var vText = fileText;
      var vSendText = "";
      var txtUrl = "";
      var i = 1;
      var offset = 0;
      var percentLoaded = 0;
   
      while(vText.byteLength > 0 && i <10000000) {
         
         vSendText = vText.slice(0,chunkSize);
         vText = vText.slice(chunkSize);
         off = chunkSize * (i-1);
         
         vSendText = encodeURIComponent(_arrayBufferToBase64(vSendText));
         txtUrl = "!documents_api2.upload?filename="+file.name+"&offset="+off+"&chunksize="+chunkSize+"&chunkNumber="+i+"&contenttype="+file.type+"&page="+vSendText;
         
         $.ajax({
            url: txtUrl,
            type: "GET",
            async: false,
            processData: false,
            success: function (data, status) {
               //console.log(status);
               bytesUploaded += chunkSize;
               if (bytesUploaded > file.size) {bytesUploaded = file.size;}
              // console.log("bytesUploaded="+bytesUploaded);
              // console.log("file.size="+file.size);
               percentLoaded = Math.floor((bytesUploaded / file.size) * 100);
               output(percentLoaded);
            },
            error: function(xhr, desc, err) {
               console.log(desc);
               console.log(err);
            }                 
         });
         i++;
      }
     
     outputLink(); 
   }
</script>

<style>
   #progress_bar {
      margin: 10px 0;
      padding: 3px;
      border: 1px solid #000;
      font-size: 14px;
      clear: both;
      opacity: 0;
      -moz-transition: opacity 1s linear;
      -o-transition: opacity 1s linear;
      -webkit-transition: opacity 1s linear;
   }
   #progress_bar.loading {
      opacity: 1.0;
   }
   #progress_bar .percent {
      background-color: #99ccff;
      height: auto;
      width: 0;
   }
   #fileHandler {
      width: 450px;
      height: auto;
      border-radius: 5px;
      border: 2px solid black;

      padding:10px;
   }
   #fileUploadProgress {
      padding:10px;
   }
   #list {
    font-size: 12;
    margin: 40px;
   } 	  
</style>

</HEAD>

<BODY>
   <div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div> 
   <div id="fileHandler">
      <input type="file" id="files" name="file" />
      <button onclick="abortRead();" id="btnCancel" class="rasdButton">Cancel read</button>
      <button onclick="sendfile(); " id="btnUpload" class="rasdButton">Upload</button>');
if showfilelist = 'true' then
htp.p('
<br />
<br/>
	  These uploaded files are only accessed to your application with documents_api2.download_direct?file= URL. To store objects in library you shoud put object in /rasdlib project.
');
end if;
htp.p('	  <br/>
      <div id="progress_bar">
         <div class="percent">0%</div>
      </div>
      
      <div id="download">
      </div>

         <div id="list">

');   
if showfilelist = 'true' then
for r in (select name from documents  order by name) loop

htp.p('<A HREF="DOCUMENTS_API2.download_direct?file='||r.name||'" target="_bank">'||r.name||'</A></br>');

end loop;
end if;
htp.p('
     </div>	  
	  
   </div>

   <script>
   
      var reader;
      var progress = $(".percent");
      
      function abortRead() {
         $("#download").html("");
         reader.abort();
      }
      
      function errorHandler(evt) {
         switch(evt.target.error.code) {
            case evt.target.error.NOT_FOUND_ERR:
               alert(''File Not Found!'');
               break;
            case evt.target.error.NOT_READABLE_ERR:
               alert(''File is not readable'');
               break;
            case evt.target.error.ABORT_ERR:
               break; // noop
            default:
               alert(''An error occurred reading this file.'');
         };
      }
      
      function updateProgress(evt) {
         if(evt.lengthComputable) {
            var percentLoaded = Math.round((evt.loaded / evt.total) * 100);
            if(percentLoaded < 100) {
               progress.style.width = percentLoaded + ''%'';
               progress.textContent = percentLoaded + ''%'';
            }
         }
      }
      
      function handleFileSelect(evt) {
         $("#download").html("");

         //progress.style.width = ''0%''; //IE ERROR
         //progress.textContent = ''0%'';
         
         reader = new FileReader();
         reader.onerror = errorHandler;
         reader.onprogress = updateProgress;
         reader.onabort = function(e) {
            alert(''File read cancelled'');
         };
         reader.onloadstart = function(e) {
            document.getElementById(''progress_bar'').className = ''loading'';
         };
         reader.onload = function(e) {
            $("#btnUpload").prop("disabled",false);
            $("#btnCancel").prop("disabled",true);
            //progress.style.width = ''100%'';
            //progress.textContent = ''100%'';
         }

         //reader.readAsBinaryString(evt.target.files[0]); //IE error
      }

      var el = document.getElementById(''files'');
      if (el.addEventListener) {
         el.addEventListener(''change'', handleFileSelect, false); 
      } else if (el.attachEvent) {
         el.attachEvent(''onchange'', handleFileSelect);
      }

      
      
   </script>

</BODY>
</HTML>
');
   end page;
  
   procedure upload(name_array  in owa.vc_arr, value_array in owa.vc_arr) is 
   begin
      declare
         p_b blob;
         p_body blob;
         p_offset number;
         p_filename varchar2(4000);
         p_raw long raw;
         p_chunksize varchar2(200);
         p_status varchar2(200);
         offset number;
         filename varchar2(4000);
         chunksize varchar2(200);
         chunkNumber number;
         contenttype documents.CONTENT_TYPE%type;
         page blob;
         x varchar2(32000);
      begin
         
         for i in 1..name_array.count loop    
            if name_array(i) = 'offset' then offset:= value_array(i);
            elsif name_array(i) = 'filename' then filename:= value_array(i);
            elsif name_array(i) = 'chunksize' then chunksize:= value_array(i);
            elsif name_array(i) = 'chunkNumber' then chunkNumber:= value_array(i);
            elsif name_array(i) = 'contenttype' then contenttype:= value_array(i);
            elsif name_array(i) = 'page' then page:= utl_encode.base64_decode(utl_raw.cast_to_raw(value_array(i)));
            end if;
            
   --         htp.p(name_array(i)||'='||value_array(i));
         end loop;
         
         -- pull the binds into locals
         p_offset:= OFFSET + 1;
         p_body:= page;
         p_filename:= filename;
         p_chunksize:= chunksize;
         
         -- if there is already a file with this name nuke it since this is chunk number one.
         if chunkNumber = 1 then
            p_status:= 'DELETING';
            delete from documents where name = user||'/'||p_filename;
         end if;
         
         -- grab the blob storing the first chunks
         select d.blob_content, doc_size into p_b, p_offset
           from documents d
          where name = user||'/'||p_filename 
            for update of blob_content;
         
         p_status:=' WRITING';
         
         -- append it
         dbms_lob.append(p_b, p_body);
         commit;
      exception 
         when no_data_found then
            -- if no blob found above do the first insert
            p_status:=' INSERTING';
            insert into documents(name, blob_content, doc_size, mime_type, last_updated)
            values (user||'/'||p_filename, p_body, p_offset, contenttype, sysdate);
            commit;
         when others then
            -- when something blows out print the error message to the client
            htp.p(p_status);
            htp.p(SQLERRM);
      end;   
   end upload;
   
   PROCEDURE download_direct (file  IN  VARCHAR2) AS

-- ----------------------------------------------------------------------------
  l_blob_content  documents.blob_content%TYPE;
  l_mime_type     documents.content_type%TYPE;
BEGIN

     select x.blob_content, nvl(x.mime_type,'xtext/plain')
    INTO   l_blob_content,
         l_mime_type
           from documents x
          where name = file;

  OWA_UTIL.mime_header(l_mime_type, FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob_content));
  HTP.p('Content-Disposition: filename="dwnld_'||file||'"');

  OWA_UTIL.http_header_close;

  WPG_DOCLOAD.download_file(l_blob_content);
EXCEPTION
  WHEN OTHERS THEN
    HTP.htmlopen;
    HTP.headopen;
    HTP.title('File Downloaded');
    HTP.headclose;
    HTP.bodyopen;
    HTP.header(1, 'Download Status');
    HTP.print('file='||file);
    HTP.print(SQLERRM);
    HTP.bodyclose;
    HTP.htmlclose;
END download_direct;


/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------*/

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
        rasd_client.callLog('50','||v_clob||', systimestamp, '' );
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
   return 'v.1.1.20200110111728'; 
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
if PFILE(i__) is null then vc := rasd_client.sessionGetValue('PFILE'); PFILE(i__)  := vc;  end if; 
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
      elsif  upper(name_array(i__)) = upper('PLINK_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PLINK(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PFILE_'||substr(name_array(i__),instr(name_array(i__),'_',-1)+1)) then
        PFILE(to_number(substr(name_array(i__),instr(name_array(i__),'_',-1)+1))) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PLINK') and PLINK.count = 0 and value_array(i__) is not null then
        PLINK(1) := value_array(i__);
      elsif  upper(name_array(i__)) = upper('PFILE') and PFILE.count = 0 and value_array(i__) is not null then
        PFILE(1) := value_array(i__);
      end if;
    end loop;
-- organize records
-- init fields
    v_max := 0;
    if PLINK.count > v_max then v_max := PLINK.count; end if;
    if PFILE.count > v_max then v_max := PFILE.count; end if;
    if v_max = 0 then v_max := 1; end if;
    for i__ in 1..v_max loop
      if not PLINK.exists(i__) then
        PLINK(i__) := 'Upload FILE';
      end if;
      if not PFILE.exists(i__) then
        PFILE(i__) := null;
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
        PLINK(i__) := 'Upload FILE';
        PFILE(i__) := null;

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

  null;
  end;
  procedure pselect_P is
    i__ pls_integer;
  begin
      pclear_P(PLINK.count);
  null; end;
  procedure pselect is
  begin
  null;
 end;
  procedure pcommit_P is
  begin
    for i__ in 1..PLINK.count loop
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  function js_link$link(value varchar2, name varchar2 default null) return varchar2 is
   v_return varchar2(32000) := '';
  begin
    if 1=2 then null;
    elsif name like 'PLINK%' then
      v_return := v_return || '''!DOCUMENTS_API2.page?FIN=DOCUMENTS_API2.PFILE_1''';
    elsif name is null then
      v_return := v_return ||'''!DOCUMENTS_API2.page?FIN=DOCUMENTS_API2.PFILE_1''';
    end if;
    return v_return;
  end;
  procedure js_link$link(value varchar2, name varchar2 default null) is
  begin
      htp.prn(js_link$link(value, name));
  end;
procedure output_P_DIV is begin htp.p('');  if  ShowBlockP_DIV  then  
htp.prn('<div  id="P_DIV" class="rasdblock"><div>
<caption><div id="P_LAB" class="labelblock"></div></caption>
<table border="0" id="P_TABLE"><tr id="P_BLOCK"><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPLINK"><span id="PLINK_LAB" class="label">Upload call documents_api2.page:</span></td><td class="rasdTxPLINK rasdTxTypeC" id="rasdTxPLINK_1"><input onclick="javascript: var link=window.open(encodeURI('); js_link$link(PLINK(1),'PLINK_1'); 
htp.prn('),''x1'',''resizable,scrollbars,width=680,height=550'');" name="PLINK_1" id="PLINK_1_RASD" type="button" value="'||PLINK(1)||'" class="rasdButton"/>
</td></tr><tr><td class="rasdTxLab rasdTxLabBlockP" id="rasdTxLabPFILE"><span id="PFILE_LAB" class="label">Name of uploaded file in database:</span></td><td class="rasdTxPFILE rasdTxTypeC" id="rasdTxPFILE_1"><input name="PFILE_1" id="PFILE_1_RASD" type="text" value="'||PFILE(1)||'" class="rasdTextC"/>
</td></tr><tr></tr></table></div></div>');  end if;  
htp.prn(''); end;
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
    htp.p('<script language="JavaScript">');
    htp.p('function cMFP() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('function cMF() {');
    htp.p('var i = 0;');
    htp.p('if (i > 0) { return false; } else { return true; }');
    htp.p('}');
    htp.p('</script>');
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','New DOCUMENTS API Library for ORDS')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head>
<body><div id="DOCUMENTS_API2_LAB" class="rasdFormLab">New DOCUMENTS API Library for ORDS '|| rasd_client.getHtmlDataTable('DOCUMENTS_API2_LAB') ||'     </div><div id="DOCUMENTS_API2_MENU" class="rasdFormMenu">'|| rasd_client.getHtmlMenuList('DOCUMENTS_API2_MENU') ||'     </div>
<form name="DOCUMENTS_API2" method="post"><div id="DOCUMENTS_API2_DIV" class="rasdForm"><div id="DOCUMENTS_API2_HEAD" class="rasdFormHead"><input name="ACTION" id="ACTION_RASD" type="hidden" value="'||ACTION||'"/>
</div><div id="DOCUMENTS_API2_BODY" class="rasdFormBody">'); output_P_DIV; htp.p('</div><div id="DOCUMENTS_API2_ERROR" class="rasdFormMessage error"><font id="ERROR_RASD" class="rasdFont">'||ERROR||'</font></div><div id="DOCUMENTS_API2_WARNING" class="rasdFormMessage warning"><font id="WARNING_RASD" class="rasdFont">'||WARNING||'</font></div><div id="DOCUMENTS_API2_MESSAGE" class="rasdFormMessage"><font id="MESSAGE_RASD" class="rasdFont">'||MESSAGE||'</font></div><div id="DOCUMENTS_API2_FOOTER" class="rasdFormFooter">'|| rasd_client.getHtmlFooter(version , substr('DOCUMENTS_API2_FOOTER',1,instr('DOCUMENTS_API2_FOOTER', '_',-1)-1) , '') ||'</div></div></form></body></html>
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
  function ShowBlockP_DIV return boolean is 
  begin 
    return true;
  end; 
  begin
if set_session_block__ is not null then  execute immediate set_session_block__;  end if;
if RESTRESTYPE = 'XML' then
    htp.p('<?xml version="1.0" encoding="UTF-8"?>'); 
    htp.p('<form name="DOCUMENTS_API2" version="1">'); 
    htp.p('<formfields>'); 
    htp.p('<action><![CDATA['||ACTION||']]></action>'); 
    htp.p('<error><![CDATA['||ERROR||']]></error>'); 
    htp.p('<message><![CDATA['||MESSAGE||']]></message>'); 
    htp.p('<warning><![CDATA['||WARNING||']]></warning>'); 
    htp.p('</formfields>'); 
    if ShowBlockp_DIV then 
    htp.p('<p>'); 
    htp.p('<element>'); 
    htp.p('<plink><![CDATA['||PLINK(1)||']]></plink>'); 
    htp.p('<pfile><![CDATA['||PFILE(1)||']]></pfile>'); 
    htp.p('</element>'); 
  htp.p('</p>'); 
  end if; 
    htp.p('</form>'); 
else
    htp.p('{"form":{"@name":"DOCUMENTS_API2","@version":"1",' ); 
    htp.p('"formfields": {'); 
    htp.p('"action":"'||escapeRest(ACTION)||'"'); 
    htp.p(',"error":"'||escapeRest(ERROR)||'"'); 
    htp.p(',"message":"'||escapeRest(MESSAGE)||'"'); 
    htp.p(',"warning":"'||escapeRest(WARNING)||'"'); 
    htp.p('},'); 
    if ShowBlockp_DIV then 
    htp.p('"p":['); 
     htp.p('{'); 
    htp.p('"plink":"'||escapeRest(PLINK(1))||'"'); 
    htp.p(',"pfile":"'||escapeRest(PFILE(1))||'"'); 
    htp.p('}'); 
    htp.p(']'); 
  else 
    htp.p('"p":[]'); 
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
  rasd_client.secCheckPermission('DOCUMENTS_API2',ACTION);  
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
    htp.prn('<html>
<head>');  htpClob(rasd_client.getHtmlJSLibrary('HEAD','New DOCUMENTS API Library for ORDS')); htpClob(FORM_UIHEAD); htp.p('<style type="text/css">'); htpClob(FORM_CSS); htp.p('</style><script type="text/javascript">'); htpClob(FORM_JS); htp.p('</script>');  
htp.prn('</head><body><div id="DOCUMENTS_API2_LAB" class="rasdFormLab">New DOCUMENTS API Library for ORDS '|| rasd_client.getHtmlDataTable('DOCUMENTS_API2_LAB') ||'     </div><div class="rasdForm"><div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton"></div><div class="rasdHtmlError">  <div class="rasdHtmlErrorCode">'||sqlcode||'</div>  <div class="rasdHtmlErrorText">'||sqlerrm||'</div></div><div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="Back" class="rasdButton">'|| rasd_client.getHtmlFooter(version , substr('DOCUMENTS_API2_FOOTER',1,instr('DOCUMENTS_API2_FOOTER', '_',-1)-1) , '') ||'</div></div></body></html>    ');
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
  rasd_client.secCheckPermission('DOCUMENTS_API2',ACTION);  

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
  rasd_client.secCheckPermission('DOCUMENTS_API2',ACTION);  
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
<form name="DOCUMENTS_API2" version="1">');     htp.p('<error>');     htp.p('  <errorcode>'||sqlcode||'</errorcode>');     htp.p('  <errormessage>'||sqlerrm||'</errormessage>');     htp.p('</error>');     htp.p('</form>'); else
    htp.p('{"form":{"@name":"DOCUMENTS_API2","@version":"1",' );     htp.p('"error":{');     htp.p('  "errorcode":"'||sqlcode||'",');     htp.p('  "errormessage":"'||sqlerrm||'"');     htp.p('}');     htp.p('}}'); end if;

end; 
function metadata_xml return cctab is
  v_clob clob := '';
  v_vc cctab;
  begin
 v_vc(1) := '<form><formid>50</formid><form>DOCUMENTS_API2</form><version>1</version><change>10.01.2020 11/17/29</change><user>RASDCLI</user><label><![CDATA[New DOCUMENTS API Library for ORDS]]></label><lobid>RASD</lobid><program></program><referenceyn>N</referenceyn><autodeletehtmlyn>Y</autodeletehtmlyn><autocreaterestyn>Y</autocreaterestyn><autocreatebatchyn>Y</autocreatebatchyn><addmetadatainfoyn>N</addmetadatainfoyn><compiler><engineid>11</engineid><server>rasd_engine11</server><client>rasd_enginehtml11</client><library>rasd_client</library></compiler><compiledInfo><info><engineid>11</engineid><change>19.12.2017 12/45/45</change><compileyn>N</compileyn><application>RASD lib&apos;s</application><owner>rasd</owner><editor>rasd</editor></info></compiledInfo><blocks></blocks><fields></fields><links></links><pages></pages><triggers></triggers><elements></elements></form>';
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
end DOCUMENTS_API2;
/
