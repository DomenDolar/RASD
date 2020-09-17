create or replace package RASDC_UPLOAD is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2014       http://rasd.sourceforge.net                 |
  // +----------------------------------------------------------------------+
  // | This program is free software; you can redistribute it and/or modify |
  // | it under the terms of the GNU General Public License as published by |
  // | the Free Software Foundation; either version 2 of the License, or    |
  // | (at your option) any later version.                                  |
  // |                                                                      |
  // | This program is distributed in the hope that it will be useful       |
  // | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  // | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
  // | GNU General Public License for more details.                         |
  // +----------------------------------------------------------------------+
  // | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
  // +----------------------------------------------------------------------+
  */
  function version(p_log out varchar2) return varchar2;

  procedure page(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );
    procedure upload (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ); 

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr);
 function ConvertBlobXMLToClob(pfile blob, charset varchar2 default 'UTF8'  ) return clob;
   
   procedure insert_xml(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) ;
end;
/

create or replace package body RASDC_UPLOAD is
  /*
  // +----------------------------------------------------------------------+
  // | RASD - Rapid Application Service Development                         |
  // +----------------------------------------------------------------------+
  // | Copyright (C) 2014       http://rasd.sourceforge.net                 |
  // +----------------------------------------------------------------------+
  // | This program is free software; you can redistribute it and/or modify |
  // | it under the terms of the GNU General Public License as published by |
  // | the Free Software Foundation; either version 2 of the License, or    |
  // | (at your option) any later version.                                  |
  // |                                                                      |
  // | This program is distributed in the hope that it will be useful       |
  // | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  // | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
  // | GNU General Public License for more details.                         |
  // +----------------------------------------------------------------------+
  // | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
  // +----------------------------------------------------------------------+
  */

  type rtab is table of rowid index by binary_integer;
  type ntab is table of number index by binary_integer;
  type dtab is table of date index by binary_integer;
  type ctab is table of varchar2(32000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20200130 Updates for referenced forms    
20200129 New upload for .metadata or .xml files   
*/';
    return 'v.1.1.20200129225530';

  end;

 function ConvertBlobXMLToClob(pfile blob, charset varchar2 default 'UTF8'  ) return clob is
   v_message_content blob := pfile;
   v_message_charset varchar2(500) := charset;
   v_content clob;
   v_dest_offset number := 1;
   v_src_offset number := 1;
   v_lang_context number := dbms_lob.default_lang_ctx;
   v_warning number;
   v_x1 number;  
 begin
   -- to CLOB
      dbms_lob.createtemporary(v_content, TRUE);
      v_dest_offset := 1;
      v_src_offset  := 1;
      v_lang_context := dbms_lob.default_lang_ctx;
      DBMS_LOB.CONVERTTOCLOB(v_content, v_message_content, dbms_lob.getlength(v_message_content), v_dest_offset, v_src_offset,
                              nls_charset_id(v_message_charset), v_lang_context, v_warning);
      
      v_x1 := instr(lower(substr(v_content,1,1000)),'encoding="');

      if v_x1 > 0 then
        v_message_charset := replace(substr(v_content,v_x1+10,instr(lower(substr(v_content,1,1000)),'"', v_x1+10)-v_x1-10),'-','');

        dbms_lob.createtemporary(v_content, TRUE);
        v_dest_offset := 1;
        v_src_offset  := 1;
        v_lang_context := dbms_lob.default_lang_ctx;
        DBMS_LOB.CONVERTTOCLOB(v_content, v_message_content, dbms_lob.getlength(v_message_content), v_dest_offset, v_src_offset,
                               nls_charset_id(v_message_charset), v_lang_context, v_warning);
      end if;                             
      
   return v_content;       
 end;  



function insert_xml(v_clob clob, v_lob varchar2, v_user varchar2) return varchar2 is
  v_formid integer;
  v_name varchar2(200);
  v_count number;
  v_rform varchar2(200);
begin

--TEST XML
begin
select 
 'IMP_'||extractvalue(value(a), '/form/form') into v_name
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '/form'))) a;  
  
exception when no_data_found then 
  raise_application_error (-20002, 'XML is wrong format!');
end;

--TEST REFERENCES
for r in (
select distinct 
 extractvalue(value(a), '/rform') rform
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '//rform'))) a
 where  extractvalue(value(a), '/rform') is not null
) loop

select count(*) into v_count from rasd_forms f where f.form = r.rform and f.lobid = v_lob;
v_rform := r.rform;
if v_count = 0 then 
  raise_application_error (-20002, 'Missing referenced form '||r.rform||' in LOB '||v_lob||'. If you would like to load form anyway delete element /rform in XML.');
end if;


end loop;


select nvl(max(formid), 0) + 1 into v_formid 
from RASD_FORMS;


insert into rasd_forms
  (formid, lobid, form, version, label, program, change, referenceyn, autodeletehtmlyn, autocreaterestyn, autocreatebatchyn)
  (
select 
 v_formid, 
 v_lob,
 'IMP_'||extractvalue(value(a), '/form/form'),
 extractvalue(value(a), '/form/version'),
 extractvalue(value(a), '/form/label'),
 extractvalue(value(a), '/form/program'),
 sysdate,
 extractvalue(value(a), '/form/referenceyn'),
 extractvalue(value(a), '/form/autodeletehtmlyn'),
 extractvalue(value(a), '/form/autocreaterestyn'),
 extractvalue(value(a), '/form/autocreatebatchyn') 
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '/form'))) a  
);

if v_count > 0 then
insert into rasd_references
  (formid,  rlobid, rform)
values
  (v_formid,  v_lob, v_rform);
end if;


insert into rasd_forms_compiled
  (formid, engineid, change, compileyn, application, owner, editor, lobid)
  (
select 
 v_formid, 
 nvl(extractvalue(value(a), '/form/compiler/engineid'),10),
 sysdate,
 'N',
 'imported form',
 v_user,
 v_user,
 v_lob
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '/form'))) a  
);

insert into rasd_blocks
  (formid, blockid, sqltable, numrows, emptyrows, dbblockyn, rowidyn, pagingyn, clearyn, sqltext, label, source, hiddenyn, rlobid, rform, rblockid)
(
select
 v_formid,  
 extractvalue(value(a), '/block/blockid'),
 extractvalue(value(a), '/block/sqltable'),
 extractvalue(value(a), '/block/numrows'),
 extractvalue(value(a), '/block/emptyrows'),
 extractvalue(value(a), '/block/dbblockyn'),
 extractvalue(value(a), '/block/rowidyn'),
 extractvalue(value(a), '/block/pagingyn'),
 extractvalue(value(a), '/block/clearyn'),
 extractvalue(value(a), '/block/sqltext'),
 extractvalue(value(a), '/block/label'),
 extractvalue(value(a), '/block/source'),
 extractvalue(value(a), '/block/hiddenyn')
, extractvalue(value(a), '/block/rlobid')
, extractvalue(value(a), '/block/rform')
, extractvalue(value(a), '/block/rblockid')
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '//blocks/block'))) a  
);


insert into rasd_fields
  (formid, fieldid, blockid, type, format, element, hiddenyn, orderby, pkyn, selectyn, insertyn, updateyn, deleteyn, insertnnyn, notnullyn, lockyn, defaultval, 
   elementyn, nameid, label, linkid, source,rlobid,rform,rblockid,rfieldid,includevis)
(
select
 v_formid, 
 extractvalue(value(a), '/field/fieldid'),
 extractvalue(value(a), '/field/blockid'),
 extractvalue(value(a), '/field/type'),
 extractvalue(value(a), '/field/format'),
 extractvalue(value(a), '/field/element'),
 extractvalue(value(a), '/field/hiddenyn'),
 extractvalue(value(a), '/field/orderby'),
 extractvalue(value(a), '/field/pkyn'),
 extractvalue(value(a), '/field/selectyn'),
 extractvalue(value(a), '/field/insertyn'),
 extractvalue(value(a), '/field/updateyn'),
 extractvalue(value(a), '/field/deleteyn'),
 extractvalue(value(a), '/field/insertnnyn'),
 extractvalue(value(a), '/field/notnullyn'),
 extractvalue(value(a), '/field/lockyn'),
 extractvalue(value(a), '/field/defaultval'),
 extractvalue(value(a), '/field/elementyn'),
 extractvalue(value(a), '/field/nameid'),
 extractvalue(value(a), '/field/label'),
 extractvalue(value(a), '/field/linkid'),
 extractvalue(value(a), '/field/source')
 , extractvalue(value(a), '/field/rlobid')
, extractvalue(value(a), '/field/rform')
, extractvalue(value(a), '/field/rblockid')
, extractvalue(value(a), '/field/rfieldid')
, extractvalue(value(a), '/field/includevis')
from 
 table (xmlsequence(extract(xmltype(trim(v_clob)), '//fields/field'))) a  
);

insert into rasd_links
  (formid, linkid, link, type, location, text, source, hiddenyn,rlobid,rform,rlinkid)
(
select
 v_formid, 
 extractvalue(value(a), '/link/linkid'),
 extractvalue(value(a), '/link/link'),
 extractvalue(value(a), '/link/type'),
 extractvalue(value(a), '/link/location'),
 extractvalue(value(a), '/link/text'),
 extractvalue(value(a), '/link/source'),
 extractvalue(value(a), '/link/hiddenyn')
, extractvalue(value(a), '/link/rlobid')
, extractvalue(value(a), '/link/rform')
, extractvalue(value(a), '/link/rlinkid')
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//links/link'))) a 
);

insert into rasd_link_params
  (linkid, paramid, type, orderby, formid, blockid, fieldid, namecid, code, value,rlobid,rform,rlinkid)
(
select a1,
 extractvalue(value(b), '/param/paramid'),
 extractvalue(value(b), '/param/type'),
 extractvalue(value(b), '/param/orderby'),
 v_formid,
 extractvalue(value(b), '/param/blockid'),
 extractvalue(value(b), '/param/fieldid'),
 extractvalue(value(b), '/param/namecid'),
 extractvalue(value(b), '/param/code'),
 extractvalue(value(b), '/param/value')
, extractvalue(value(b), '/param/rlobid')
, extractvalue(value(b), '/param/rform')
, extractvalue(value(b), '/param/rlinkid')
from
(
select 
 extractvalue(value(a), '/link/linkid') a1,
 value(a) par
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//links/link'))) a
) c, table (xmlsequence(extract(c.par
 , '//params/param'))) b 
)
;

insert into rasd_pages
  (formid, page, blockid, fieldid,rlobid,rform,rblockid,rfieldid)
(
select 
 v_formid , 
 extractvalue(value(a), '/pagedata/page'),
 extractvalue(value(a), '/pagedata/blockid'),
 extractvalue(value(a), '/pagedata/fieldid')
 , extractvalue(value(a), '/pagedata/rlobid')
, extractvalue(value(a), '/pagedata/rform')
, extractvalue(value(a), '/pagedata/rblockid')
, extractvalue(value(a), '/pagedata/rfieldid') 
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//pages/pagedata'))) a
);


insert into rasd_triggers
  (formid, blockid, triggerid, plsql, plsqlspec, source, hiddenyn,rlobid,rform,rblockid)
(
select 
 v_formid,
 extractvalue(value(a), '/trigger/blockid'),
 extractvalue(value(a), '/trigger/triggerid'),
 extractvalue(value(a), '/trigger/plsql'),
 extractvalue(value(a), '/trigger/plsqlspec'),
 extractvalue(value(a), '/trigger/source'),
 extractvalue(value(a), '/trigger/hiddenyn')
  , extractvalue(value(a), '/trigger/rlobid')
, extractvalue(value(a), '/trigger/rform')
, extractvalue(value(a), '/trigger/rblockid') 
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//triggers/trigger'))) a
);


insert into rasd_elements
  (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn,rlobid,rform,rid,includevis)
(select 
 v_formid,
 extractvalue(value(a), '/element/elementid'),
 extractvalue(value(a), '/element/pelementid'),
 extractvalue(value(a), '/element/orderby'),
 extractvalue(value(a), '/element/element'),
 extractvalue(value(a), '/element/type'),
 extractvalue(value(a), '/element/id'),
 extractvalue(value(a), '/element/nameid'),
 extractvalue(value(a), '/element/endtagelementid'),
 extractvalue(value(a), '/element/source'),
 extractvalue(value(a), '/element/hiddenyn')
  , extractvalue(value(a), '/element/rlobid')
, extractvalue(value(a), '/element/rform')
, extractvalue(value(a), '/element/rid') 
, extractvalue(value(a), '/element/includevis') 
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//elements/element'))) a
)
;


insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode,rlobid,rform,rid)
(
select 
 v_formid,
 a1,
 extractvalue(value(b), '/attribute/orderby'),
 extractvalue(value(b), '/attribute/attribute'),
 extractvalue(value(b), '/attribute/type'),
 extractvalue(value(b), '/attribute/text'),
 extractvalue(value(b), '/attribute/name'),
 extractvalue(value(b), '/attribute/value'),
 extractvalue(value(b), '/attribute/valuecode'),
 extractvalue(value(b), '/attribute/forloop'),
 extractvalue(value(b), '/attribute/endloop'),
 extractvalue(value(b), '/attribute/source'),
 extractvalue(value(b), '/attribute/hiddenyn'),
 extractvalue(value(b), '/attribute/valueid'),
 extractvalue(value(b), '/attribute/textid'),
 extractvalue(value(b), '/attribute/textcode')
, extractvalue(value(b), '/attribute/rlobid')
, extractvalue(value(b), '/attribute/rform')
, extractvalue(value(b), '/attribute/rid')  
from
(
select 
 extractvalue(value(a), '/element/elementid') a1,
 value(a) par
from 
 table (xmlsequence(extract(xmltype(trim(v_clob))
 , '//elements/element'))) a
) c, table (xmlsequence(extract(c.par
 , '//attributes/attribute'))) b 
);
commit;
return 'uploaded';
end;    
 


   procedure insert_xml(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is
  RETURNFILE varchar2(1000);
      begin 
        
         for i in 1..name_array.count loop    
            if upper(name_array(i)) = 'FILE' then RETURNFILE:= value_array(i);
            end if;
            
            --htp.p(name_array(i)||'='||value_array(i));
  
        end loop;      
 

htp.p('
<HTML>
<HEAD>
<meta charset="utf-8" />
'||RASDC_LIBRARY.RASD_UI_Libs||'

<style>
.hint {
    margin: 15 auto;
    padding: 5;
    background-color: red;
    font-family: Arial, Helvetica, sans-serif;
    width: 470px;
}

   #fileHandler {
      width: 450px;
      height: auto;
      border-radius: 5px;
      //border: 2px solid black;
      background-color: white;
      padding:10px;
   }
   
</style>

</HEAD>

<BODY>
   <div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div> 
<div class="hint">   
   <div id="fileHandler">
');

     
declare 
  XX varchar2(100);
begin
  htp.p('<br/>Start importing procedure for file '||returnfile);
  for r in (select rasdc_upload.ConvertBlobXMLToClob(blob_content,'UTF8') XCLOB
           from rasd_files f
           where name = RETURNFILE
           order by name ) loop
    htp.p('<br/>Importing file '||RETURNFILE||' ...')    ;   
    XX := RASDC_UPLOAD.insert_xml(r.XCLOB,rasdi_client.secGetLOB,rasdi_client.secGetUsername);
    htp.p(xx);
  end loop;  
  delete from rasd_files f where name = RETURNFILE;                
  commit;

   htp.p('<br/>File '||RETURNFILE||' was imported. Close this program and refresh data on "List of forms".');

  exception when others then  
   htp.p('<br/><font color="red">File '||RETURNFILE||' was NOT imported ('||sqlerrm||').</font>');
           
  end;
htp.p('<p> <button onclick="window.close(); " id="" class="SUBMIT">Close</button></p>  
</div>
</div>
</BODY>
</HTML>
');  

end;
    


   procedure page(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is
  RETURNFILE varchar2(1000);
   begin

         for i in 1..name_array.count loop    
            if name_array(i) = 'FIN' then RETURNFILE:= value_array(i);
            end if;
            
           -- htp.p(name_array(i)||'='||value_array(i));
         end loop;

   
      htp.p('
<HTML>
<HEAD>
<meta charset="utf-8" />
'||RASDC_LIBRARY.RASD_UI_Libs||'

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
     $("#download").html( ''Import file: <A HREF="!rasdc_upload.insert_xml?file='||lower(user)||'/''+ encodeURIComponent(datoteka.name) +''" >'' + datoteka.name+''</A>'');     

');

htp.p('      window.location = ''!rasdc_upload.insert_xml?file='||lower(user)||'/''+ encodeURIComponent(datoteka.name);')
;


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
         txtUrl = "!rasdc_upload.upload?filename="+file.name+"&offset="+off+"&chunksize="+chunkSize+"&chunkNumber="+i+"&contenttype="+file.type+"&page="+vSendText;
         
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
.hint {
    margin: 15 auto;
    padding: 5;
    background-color: red;
    font-family: Arial, Helvetica, sans-serif;
    width: 470px;
}

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
      //border: 2px solid black;
      background-color: white;
      padding:10px;
   }
   #fileUploadProgress {
      padding:10px;
   }
   #list {
    font-size: 12;
    margin: 40px;
   }   
   
   
.submit1 {
    padding: 5px 11px 5px !important;
    font-size: 11px !important;
    background-color: grey;
    font-weight: bold;
    color: white;
    border-radius: 100px;
    -moz-border-radius: 100px;
    -webkit-border-radius: 100px;
    border: 1px solid #8B8889;
    cursor: pointer;
    box-shadow: 0 1px 0 rgba(255, 255, 255, 0.5) inset;
    -moz-box-shadow: 0 1px 0 rgba(255, 255, 255, 0.5) inset;
    -webkit-box-shadow: 0 1px 0 rgba(255, 255, 255, 0.5) inset;
}   
</style>

</HEAD>

<BODY>
   <div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div> 
<div class="hint">   
   <div id="fileHandler">
      <input class="SUBMIT1" type="file" id="files" name="file" />
      <input type="button" onclick="abortRead();" id="btnCancel" class="SUBMIT1" value="Cancel read">
      <input type="button" onclick="sendfile(); " id="btnUpload" class="SUBMIT" value="Upload">
      <br />
      <br />
      Upload Form to your RASD environment. The file should be .xml or .metadata type.
       <br />   
      <div id="progress_bar">
         <div class="percent">0%</div>
      </div>
      
      <div id="download">
      </div>
    
         <div id="list">

');   
for r in (select name from rasd_files where upper(name) like '%.METADATA%' or upper(name) like '%.XML%' order by name) loop

htp.p('<A HREF="!rasdc_upload.insert_xml?file='||r.name||'" >'||r.name||'</A></br>');

end loop;

htp.p('
     </div>
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
</div>
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
         contenttype RASD_FILES.CONTENT_TYPE%type;
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
            delete from rasd_files where name = user||'/'||p_filename;
         end if;
         
         -- grab the blob storing the first chunks
         select d.blob_content, doc_size into p_b, p_offset
           from rasd_files d
          where name = lower(user)||'/'|| decode( nvl(instr(lower(p_filename),'.png'),0)+nvl(instr(lower(p_filename),'.gif'),0)+nvl(instr(lower(p_filename),'.jpg'),0)+nvl(instr(lower(p_filename),'.ico'),0) , 0 , '','pict/' )||decode(nvl(instr(lower(p_filename),'.js'),0) , 0 , '','js/' )||decode(nvl(instr(lower(p_filename),'.css'),0) , 0 , '','css/' )||p_filename 
            for update of blob_content;
         
         p_status:=' WRITING';
         
         -- append it
         dbms_lob.append(p_b, p_body);
         commit;
      exception 
         when no_data_found then
            -- if no blob found above do the first insert
            p_status:=' INSERTING';
            insert into rasd_files(name, blob_content, doc_size, mime_type, last_updated)
            values (lower(user)||'/'||decode( nvl(instr(lower(p_filename),'.png'),0)+nvl(instr(lower(p_filename),'.gif'),0)+nvl(instr(lower(p_filename),'.jpg'),0)+nvl(instr(lower(p_filename),'.ico'),0) , 0 , '','pict/' )||decode(nvl(instr(lower(p_filename),'.js'),0) , 0 , '','js/' )||decode(nvl(instr(lower(p_filename),'.css'),0) , 0 , '','css/' )||p_filename, p_body, p_offset, contenttype, sysdate);
            commit;
         when others then
            -- when something blows out print the error message to the client
            htp.p(p_status);
            htp.p(SQLERRM);
      end;   
   end upload;
   

  procedure Program(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    GBUTTON1   varchar2(4000) := 'Search';
    GBUTTON2   varchar2(4000) := 'Reset';
    GBUTTON3   varchar2(4000) := 'Save';
    PFORMID    number;
    Pblockid   varchar2(4000);
    LANG       varchar2(4000);
    ACTION     varchar2(4000);
    SPOROCILO  varchar2(32500);
    FILE  varchar2(32500);
    B10RS      ctab;
    B10rid     rtab;
    B10sqltext ctab;
    B10source  ctab;

    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('GBUTTON1') then
          GBUTTON1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON2') then
          GBUTTON2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTON3') then
          GBUTTON3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('Pblockid') then
          Pblockid := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('FILE') then
          FILE  := value_array(i__);
        elsif upper(name_array(i__)) = upper('') then
          SPOROCILO := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10rid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10sqltext_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10sqltext(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B10source(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        end if;
      end loop;
      v_max := 0;
      if B10RS.count > v_max then
        v_max := B10RS.count;
      end if;
      if B10rid.count > v_max then
        v_max := B10rid.count;
      end if;
      if B10sqltext.count > v_max then
        v_max := B10sqltext.count;
      end if;
      if B10source.count > v_max then
        v_max := B10source.count;
      end if;
      for i__ in 1 .. v_max loop
        if not B10RS.exists(i__) then
          B10RS(i__) := null;
        end if;
        if not B10rid.exists(i__) then
          B10rid(i__) := null;
        end if;
        if not B10sqltext.exists(i__) then
          B10sqltext(i__) := null;
        end if;
        if not B10source.exists(i__) then
          B10source(i__) := null;
        end if;
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      null;
    end;
    procedure psubmit is
    begin
      on_submit;
      post_submit;
    end;
    procedure pclear_B10(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 1 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 1 then
          k__ := i__ + 0;
        else
          k__ := 0 + 1;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B10RS(j__) := null;
        B10rid(j__) := null;
        B10sqltext(j__) := null;
        B10source(j__) := null;

      end loop;
    end;
    procedure pclear_form is
    begin
      GBUTTON1  := 'Search';
      GBUTTON2  := 'Reset';
      GBUTTON3  := 'Save';
      PFORMID   := null;
      Pblockid  := null;
      LANG      := null;
      ACTION    := null;
      SPOROCILO := null;
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_B10(0);
      null;
    end;
    procedure pselect_B10 is
      i__ pls_integer;
    begin
      B10RS.delete;
      B10rid.delete;
      B10sqltext.delete;
      B10source.delete;
      --<pre_select formid="101" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
        --<SQL formid="101" blockid="B10">
          SELECT ROWID rid, sqltext
            FROM RASD_BLOCKS
           where formid = PFORMID
             and blockid = pblockid

          --</SQL>
          ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B10rid(i__), B10sqltext(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B10RS(i__) := null;
            B10source(i__) := null;
            B10RS(i__) := 'U';

            --<post_select formid="101" blockid="B10">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B10RS.delete(1);
          B10rid.delete(1);
          B10sqltext.delete(1);
          B10source.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B10(B10rid.count);
      null;
    end;
    procedure pselect is
    begin
      if 1 = 1 then
        pselect_B10;
      end if;
      null;
    end;
    procedure pcommit_B10 is
      v_zaklepanje varchar2(4000);
    begin
      for i__ in 1 .. B10RS.count loop
        --<on_validate formid="101" blockid="B10">
        --</on_validate>
        if substr(B10RS(i__), 1, 1) = 'I' then
          --INSERT
          null;
        else
          -- UPDATE ali DELETE;

          --<pre_update formid="101" blockid="B10">
          --</pre_update>
          update RASD_BLOCKS
             set sqltext = B10sqltext(i__), source = B10source(i__)
           where ROWID = B10rid(i__);
          --<post_update formid="101" blockid="B10">
          --</post_update>
          null;
        end if;
        null;
      end loop;
      null;
    end;
    procedure pcommit is
    begin
      --<pre_commit formid="101" blockid="">
      --</pre_commit>
      if 1 = 1 then
        pcommit_B10;
      end if;
      --<post_commit formid="101" blockid="">
      --</post_commit>
      null;
    end;
    procedure phtml is
      --povezavein
      --SQL
      --TEXT
      --TF
      --SQL-T
    begin
      --js povezavein
      --js SQL
      --js TEXT
      --js TF
      htp.prn('<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">  <META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
<SCRIPT LANGUAGE="Javascript1.2">
function onResize() {
  resizeTA(document.RASDC_SQL.B10sqltext_1);
}
function onLoad() {
  onResize();
}
</SCRIPT>
</HEAD>');
htp.p('<BODY  onload="onLoad();" onresize="onResize();">
<DIV class="hint">
<FONT ID="RASDC_UPLOAD_LAB"></FONT>
<FORM NAME="RASDC_UPLOAD" METHOD="post" ACTION="!rasdc_upload.program" enctype="multipart/form-data">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || LANG ||
              '" CLASS="HIDDEN">
<P align="right">
');
--if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT NAME="ACTION" TYPE="submit" CLASS="SUBMIT" value="' ||
              RASDI_TRNSLT.text('Upload', lang) ||
              '">
');
--end if;
htp.p('
</P>
<TABLE BORDER="1" width="100%">
<CAPTION>
</CAPTION> <TR>
<TD> <FONT ID="B10sqltext_LAB">Select file to upload:</FONT> </TD> </TR> <TR ID="B10_BLOK"> 
<TD><input type="file" name="FILE"/>
 </TD> </TR> </TABLE>
<table width="100%" border="0"><tr>
');
      if sporocilo is not null then
        htp.prn('
<td width="1%" class="sporociloh" nowrap><FONT COLOR="green" size="4">' ||
                RASDI_TRNSLT.text('Message', lang) ||
                ': </FONT></td>
<td class="sporocilom">' ||
               RASDI_TRNSLT.text( substr(sporocilo,1,1000), lang) || 
                '</td>');
      end if;
      htp.prn('
<td  align="right">
');
--if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT NAME="ACTION" TYPE="submit" CLASS="SUBMIT" value="' ||
              RASDI_TRNSLT.text('Upload', lang) || '">
');
--end if;
htp.p('
</td>
</tr>
</table>
 </FORM>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT> </BODY> </HTML>
    ');
  
    exception
      when others then
        htp.p('<font color="red">' ||
              replace(replace(sqlerrm,
                              '
',
                              '\n'),
                      '"',
                      '\"') || '</font>');
        htp.p('<script language="JavaScript">');
        htp.p('<!--');
        htp.p('  alert("' || replace(replace(sqlerrm,
                                             '
',
                                             '\n'),
                                     '"',
                                     '\"') || '");');
        htp.p('history.go(-1);');
        htp.p('// -->');
        htp.p('</script>');

        null;
    end;
  begin
    --<ON_ACTION formid="101" blockid="">
    declare
      vup    varchar2(30) := rasdi_client.secGetUsername;
      v_form varchar2(100);
      v_table varchar2(1000);
    begin
      rasdi_client.secCheckPermission('RASDC_UPLOAD', '');
      psubmit;
      if action = RASDI_TRNSLT.text('Upload', lang) then
        
if instr(upper(file),'.XML') > 0 or  instr(upper(file),'.METADATA') > 0 then
      begin 
              if instr(owa_util.get_cgi_env('DOCUMENT_TABLE'),'.') = 0 
              then v_table := owa_util.get_cgi_env('REMOTE_USER')||'.'||owa_util.get_cgi_env('DOCUMENT_TABLE'); 
              else v_table:=owa_util.get_cgi_env('DOCUMENT_TABLE'); 
              end if;      

        execute immediate '
declare 
  XX varchar2(100);
begin
  for r in (select RASDC_UPLOAD.ConvertBlobXMLToClob(blob_content,''UTF8'') XCLOB
           from '||v_table||'
           where name = '''||file||'''
           order by name ) loop
    XX := RASDC_UPLOAD.insert_xml(r.XCLOB,'''||rasdi_client.secGetLOB||''','''||rasdi_client.secGetUsername||''');
  end loop;                
--  delete from '||v_table||' where name = '''||file||''';
  commit;
end;
    ';
           sporocilo := 'File '||file||' was uploaded. Refresh data on "List of forms".';
      exception when others then  
           sporocilo := 'File '||file||' was NOT uploaded ('||sqlerrm||').';
           
      end;
elsif  instr(upper(file),'.PNG') > 0    
   or  instr(upper(file),'.GIF') > 0    
   or  instr(upper(file),'.JPG') > 0    
   or  instr(upper(file),'.AVI') > 0    then                  
      begin 
              if instr(owa_util.get_cgi_env('DOCUMENT_TABLE'),'.') = 0 
              then v_table := owa_util.get_cgi_env('REMOTE_USER')||'.'||owa_util.get_cgi_env('DOCUMENT_TABLE'); 
              else v_table:=owa_util.get_cgi_env('DOCUMENT_TABLE'); 
              end if;      

        execute immediate '
declare 
  XX varchar2(100);
begin
  update '||v_table||' set name = ''rasd/'||lower(rasdi_client.secGetLOB)||'/images/'||substr(file, instr(file,'/',-1)+1 )||''' where name = '''||file||''';
  commit;
end; 
    ';
           sporocilo := 'File '||file||' was uploaded. Link <A href="'||owa_util.get_cgi_env('DOC_ACCESS_PATH')||'/rasd/'||lower(rasdi_client.secGetLOB)||'/images/'||substr(file, instr(file,'/',-1)+1 )||'" target="_blank">'||owa_util.get_cgi_env('DOC_ACCESS_PATH')||'/rasd/'||lower(rasdi_client.secGetLOB)||'/images/'||substr(file, instr(file,'/',-1)+1 )||'</A>.';
      exception when others then  
           sporocilo := 'File '||file||' was NOT uploaded ('||sqlerrm||').';
           
      end;
else
  sporocilo := 'File must be METADATA, XML, PNG, GIF, JPG, AVI type.';
end if; 
      
      phtml;
        
      else
        phtml;
      end if;
    end;

   
    
    --</ON_ACTION>
  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.p('<script language="JavaScript">');
      htp.p('<!--');
      htp.p('  alert("' || replace(replace(sqlerrm,
                                           '
',
                                           '\n'),
                                   '"',
                                   '\"') || '");');
      htp.p('history.go(-1);');
      htp.p('// -->');
      htp.p('</script>');

  end;
end ;
/

