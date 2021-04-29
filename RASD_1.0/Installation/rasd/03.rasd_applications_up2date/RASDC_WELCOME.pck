create or replace package RASDC_WELCOME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: WELCOME generated on 13.11.20 by user RASD.     
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | This program is generated form RASD version 1.                       |
// +----------------------------------------------------------------------+
*/    
function version(p_log out varchar2) return varchar2;

  procedure page;
  procedure createForm(name_array in owa.vc_arr, value_array in owa.vc_arr);
   
end;
/
create or replace package body RASDC_WELCOME is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
//   Program: RASDC_WELCOME generated on 13.11.20 by user RASD.    
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

  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20201113 - New
*/';
    return 'v.1.1.20201113225530';

  end;

procedure createForm(name_array in owa.vc_arr, value_array in owa.vc_arr) is
id_form number;  
FORM varchar2(100);
block_1 varchar2(100);
block_typ_1 varchar2(100);
block_obj_1 varchar2(100);
block_2 varchar2(100);
block_typ_2 varchar2(100);
block_obj_2 varchar2(100);
block_3 varchar2(100);
block_typ_3 varchar2(100);
block_obj_3 varchar2(100);
block_4 varchar2(100);
block_typ_4 varchar2(100);
block_obj_4 varchar2(100);
iden number;
bl1 RASD_BLOCKS%rowtype;
bl2 RASD_BLOCKS%rowtype;
bl3 RASD_BLOCKS%rowtype;
bl4 RASD_BLOCKS%rowtype;
add_block1 boolean := false;
add_block2 boolean := false;
add_block3 boolean := false;
add_block4 boolean := false;
lang varchar2(10);
error varchar2(2000);
v_user varchar2(100);
v_lob varchar2(100);
  begin
    
     for i__ in 1 .. nvl(name_array.count, 0) loop
        if  upper(name_array(i__)) = upper('FORM') then
          FORM := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_1') then
          block_1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_typ_1') then
          block_typ_1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_obj_1') then
          block_obj_1 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_2') then
          block_2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_typ_2') then
          block_typ_2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_obj_2') then
          block_obj_2 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_3') then
          block_3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_typ_3') then
          block_typ_3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_obj_3') then
          block_obj_3 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_4') then
          block_4 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_typ_4') then
          block_typ_4 := value_array(i__);
        elsif upper(name_array(i__)) = upper('block_obj_4') then
          block_obj_4 := value_array(i__);

        end if; 
--htp.p(name_array(i__)||'='||value_array(i__)||'<br/>');
     end loop;  
  
-- insert form, block, generated form ...
begin
            form := trim(upper(rasdc_library.prepareName(form)));
            
            select nvl(max(engineid),10) into iden
            from RASD_ENGINES t
             where exists (select 1 from all_procedures where object_type = 'PACKAGE' and object_name = upper(t.server)) 
             and exists (select 1 from all_procedures where object_type = 'PACKAGE' and object_name = upper(t.client));
            
            select nvl(max(formid), 0) + 1 into id_form from RASD_FORMS;
            
            begin
              v_user := rasdi_client.secGetUsername;
              v_lob := rasdi_client.secGetLOB;
            exception when others then
              v_user := 'demo';
              v_lob := 'RASD';              
            end;             
           
            insert into RASD_FORMS_COMPILED
              (formid,
               engineid,
               change,
               compileyn,
               application,
               owner,
               editor,
               lobid)
            values
              (id_form,
               iden,
               sysdate,
              'Y',
              'wizzard',
               v_user,
               v_user,
               v_lob);

            
            insert into RASD_FORMS
              (formid,
               lobid,
               form,
               version,
               label,
               program,
               text1id,
               text2id,
               referenceyn,
               change)
            values
              (id_form,
               rasdi_client.secGetLOB,
               form ,
               1,
               form||' label',
               '?', 
               null,
               null,
               'N',
               sysdate);
               
              if block_1 is not null then
                
               if block_typ_1 = 'Filter' then
                 bl1.numrows := 1;
                 bl1.dbblockyn := 'N';
                 bl1.rowidyn := 'N';
                 bl1.pagingyn := 'N';
                 bl1.clearyn := 'Y';
                 add_block1 := true;
                 bl1.label := 'Filter label';
               end if;
               
               if block_typ_1 = 'DBBlock' and block_obj_1 is not null then
                 bl1.numrows := 10;
                 bl1.dbblockyn := 'Y';
                 bl1.rowidyn := 'Y';
                 bl1.pagingyn := 'Y';
                 bl1.clearyn := 'N';                 
                 bl1.sqltable := block_obj_1;
                 add_block1 := true;
                 bl1.label := block_1 ||' label';
               end if;               
              
            --</pre_insert>
            if add_block1 then 
              
            insert into RASD_BLOCKS
              (source,
               formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label)
            values
              ('V',
               id_form,
               upper(rasdc_library.prepareName(block_1)),
               bl1.sqltable,
               bl1.numrows,
               0,
               bl1.dbblockyn,
               bl1.rowidyn,
               bl1.pagingyn,
               bl1.clearyn,
               bl1.label);
            --<post_insert formid="5003" blockid="B20">
            RASDC_LIBRARY.insertFields(id_form,upper(rasdc_library.prepareName(block_1)) , lang);              
            
            if block_typ_1 = 'Filter' then
              insert into rasd_fields
                (formid, fieldid, blockid, type, format, element, hiddenyn, orderby, pkyn, selectyn, insertyn, updateyn, deleteyn, insertnnyn, notnullyn, lockyn, defaultval, elementyn, nameid, label, linkid, source)
              values
                (id_form, 'FILFILD', upper(rasdc_library.prepareName(block_1)), 'C' , '', 'INPUT_TEXT', '', 10, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', 'Y', upper(rasdc_library.prepareName(block_1))||'FILFILD', 'Filter text', '', 'V');
              
              
            end if;  
            end if;  
              
              
              
              end if;

              if block_2 is not null then
                
               if block_typ_2 = 'Filter' then
                 bl2.numrows := 1;
                 bl2.dbblockyn := 'N';
                 bl2.rowidyn := 'N';
                 bl2.pagingyn := 'N';
                 bl2.clearyn := 'Y';
                 add_block2 := true;
                 bl2.label := 'Filter label';
               end if;
               
               if block_typ_2 = 'DBBlock' and block_obj_2 is not null then
                 bl2.numrows := 10;
                 bl2.dbblockyn := 'Y';
                 bl2.rowidyn := 'Y';
                 bl2.pagingyn := 'Y';
                 bl2.clearyn := 'N';                 
                 bl2.sqltable := block_obj_2;
                 add_block2 := true;
                 bl2.label := block_2 ||' label';
                 
                 if block_typ_1 = 'Filter' then 
                  bl2.sqltext := 'where ('||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' is null or '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' like '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' ) -- set your own conndition to where clause
order by 1';
                 end if;
               end if;               
              
            --</pre_insert>
            if add_block2 then 
              
            insert into RASD_BLOCKS
              (source,
               formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label,
               sqltext)
            values
              ('V',
               id_form,
               upper(rasdc_library.prepareName(block_2)),
               bl2.sqltable,
               bl2.numrows,
               0,
               bl2.dbblockyn,
               bl2.rowidyn,
               bl2.pagingyn,
               bl2.clearyn,
               bl2.label
               ,bl2.sqltext);
            --<post_insert formid="5003" blockid="B20">
            RASDC_LIBRARY.insertFields(id_form,upper(rasdc_library.prepareName(block_2)) , lang);              
            
            if block_typ_2 = 'Filter' then
              insert into rasd_fields
                (formid, fieldid, blockid, type, format, element, hiddenyn, orderby, pkyn, selectyn, insertyn, updateyn, deleteyn, insertnnyn, notnullyn, lockyn, defaultval, elementyn, nameid, label, linkid, source)
              values
                (id_form, 'FILFILD', upper(rasdc_library.prepareName(block_2)), 'C' , '', 'INPUT_TEXT', '', 10, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', 'Y', upper(rasdc_library.prepareName(block_2))||'FILFILD', 'Filter text', '', 'V');
              
              
            end if;  
            end if;  
              
              
              
              end if;

              if block_3 is not null then
                
               if block_typ_3 = 'Filter' then
                 bl3.numrows := 1;
                 bl3.dbblockyn := 'N';
                 bl3.rowidyn := 'N';
                 bl3.pagingyn := 'N';
                 bl3.clearyn := 'Y';
                 add_block3 := true;
                 bl3.label := 'Filter label';
               end if;
               
               if block_typ_3 = 'DBBlock' and block_obj_3 is not null then
                 bl3.numrows := 10;
                 bl3.dbblockyn := 'Y';
                 bl3.rowidyn := 'Y';
                 bl3.pagingyn := 'Y';
                 bl3.clearyn := 'N';                 
                 bl3.sqltable := block_obj_3;
                 add_block3 := true;
                 bl3.label := block_3 ||' label';
                 if block_typ_1 = 'Filter' then 
                  bl3.sqltext := 'where ('||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' is null or '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' like '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' ) -- set your own conndition to where clause
order by 1';
                 end if;
                 
               end if;               
              
            --</pre_insert>
            if add_block3 then 
              
            insert into RASD_BLOCKS
              (source,
               formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label,
               sqltext)
            values
              ('V',
               id_form,
               upper(rasdc_library.prepareName(block_3)),
               bl3.sqltable,
               bl3.numrows,
               0,
               bl3.dbblockyn,
               bl3.rowidyn,
               bl3.pagingyn,
               bl3.clearyn,
               bl3.label
               ,bl3.sqltext);
            --<post_insert formid="5003" blockid="B20">
            RASDC_LIBRARY.insertFields(id_form,upper(rasdc_library.prepareName(block_3)) , lang);              
            
            if block_typ_3 = 'Filter' then
              insert into rasd_fields
                (formid, fieldid, blockid, type, format, element, hiddenyn, orderby, pkyn, selectyn, insertyn, updateyn, deleteyn, insertnnyn, notnullyn, lockyn, defaultval, elementyn, nameid, label, linkid, source)
              values
                (id_form, 'FILFILD', upper(rasdc_library.prepareName(block_3)), 'C' , '', 'INPUT_TEXT', '', 10, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', 'Y', upper(rasdc_library.prepareName(block_3))||'FILFILD', 'Filter text', '', 'V');
              
              
            end if;  
            end if;  
              
              
              
              end if;

              if block_4 is not null then
                
               if block_typ_4 = 'Filter' then
                 bl4.numrows := 1;
                 bl4.dbblockyn := 'N';
                 bl4.rowidyn := 'N';
                 bl4.pagingyn := 'N';
                 bl4.clearyn := 'Y';
                 add_block4 := true;
                 bl4.label := 'Filter label';
               end if;
               
               if block_typ_4 = 'DBBlock' and block_obj_4 is not null then
                 bl4.numrows := 10;
                 bl4.dbblockyn := 'Y';
                 bl4.rowidyn := 'Y';
                 bl4.pagingyn := 'Y';
                 bl4.clearyn := 'N';                 
                 bl4.sqltable := block_obj_4;
                 add_block4 := true;
                 bl4.label := block_4 ||' label';
                 if block_typ_1 = 'Filter' then 
                  bl4.sqltext := 'where ('||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' is null or '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' like '||upper(rasdc_library.prepareName(block_1))||'FILFILD'||' ) -- set your own conndition to where clause
order by 1';
                 end if;
                 
               end if;               
              
            --</pre_insert>
            if add_block4 then 
              
            insert into RASD_BLOCKS
              (source,
               formid,
               blockid,
               sqltable,
               numrows,
               emptyrows,
               dbblockyn,
               rowidyn,
               pagingyn,
               clearyn,
               label
               ,sqltext)
            values
              ('V',
               id_form,
               upper(rasdc_library.prepareName(block_4)),
               bl4.sqltable,
               bl4.numrows,
               0,
               bl4.dbblockyn,
               bl4.rowidyn,
               bl4.pagingyn,
               bl4.clearyn,
               bl4.label
               ,bl4.sqltext);
            --<post_insert formid="5003" blockid="B20">
            RASDC_LIBRARY.insertFields(id_form,upper(rasdc_library.prepareName(block_4)) , lang);              
            
            if block_typ_4 = 'Filter' then
              insert into rasd_fields
                (formid, fieldid, blockid, type, format, element, hiddenyn, orderby, pkyn, selectyn, insertyn, updateyn, deleteyn, insertnnyn, notnullyn, lockyn, defaultval, elementyn, nameid, label, linkid, source)
              values
                (id_form, 'FILFILD', upper(rasdc_library.prepareName(block_4)), 'C' , '', 'INPUT_TEXT', '', 10, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', 'Y', upper(rasdc_library.prepareName(block_4))||'FILFILD', 'Filter text', '', 'V');
              
              
            end if;  
            end if;  
              
              
              
              end if;


exception when others then
  
error := sqlerrm;

end;


  

htp.p('

<!DOCTYPE html>
<html lang="en">
<title>RASD wizard</title>
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
    <a href="#Form" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Form</a>
  </div>

  <!-- Navbar on small screens -->
  <div id="navDemo" class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">

    <a href="#Form" class="w3-bar-item w3-button w3-padding-large">Form</a>
  </div>
</div>

<!-- Header -->
<header class="w3-container w3-red" style="margin: 50px 0;">
    <div class="w3-third w3-center">
    <img width="150px" src="rasdc_files.showfile?pfile=pict/rasd.gif" alt="RASD"/>    
    </div>  

    <div class="w3-twothird">
        <p class="w3-xlarge">Welcome to the RASD simple wizard</p>
    </div>  


</header>

<!-- First Grid -->
<div id="Form" class="w3-row-padding w3-padding-32 w3-container">
  <div class="w3-content">
    <div >
      <h1>Form</h1>
      <h5>');
      
if error is not null then
htp.p('Your form <b>'||form||'</b> is NOT created.');  
--      <br/>'||error||'
else
htp.p('Your form <b>'||form||'</b> is created.');    
end if;      
           
htp.p('      <p>Click button below to access generated form.
      </p>
      <p>
      Open form then: <br/>
      <ul>
        <li>Execute <input type="button" value="Compile" class="w3-button w3-black"/> and <input type="button" value="Preview" class="w3-button w3-green"/> to see results of your program.</li>
        <li>To change button names, ... change default values of buttons on form (Go to "Fields on Block" and choose Block "F").</li>
      </ul>
      </p>
      </h5>

      <button onclick="javascript: location=encodeURI(''!rasdc_blocksonform.program?PFORMID='||id_form||'&amp;LANG='')" class="w3-button w3-black w3-padding-large w3-large w3-margin-top">Go to form <img width="21" height="20" title="Form source" src="rasdc_files.showfile?pfile=pict/gumbpodred.jpg" border="0"> ...</button>
      
</div>

  </div>
</div>


<!-- Footer -->
<footer class="w3-container w3-padding-32 w3-center w3-opacity w3-black w3-center">  
    <h1 class="w3-margin w3-xlarge">Make your day easy with things SW can do for you<a onclick="window.open(''test_dad_comm?guid=mySecretToken'',''_blank'')">.</a></h1>
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
  
procedure page is
  v_output varchar2(32000) := '';
  begin


      for r__ in (
                  --<LOVSQL formid="5003" linkid="B20sqltable_LOV">
                   select '' id, '' label, 1 x
                    from dual
                  union
                  select /*+ RULE*/ OBJECT_NAME id,
                          OBJECT_NAME || ' ... ' || substr(object_type, 1, 1) label,
                          2 x
                    from all_objects
                   where object_type in ('TABLE', 'VIEW')
                     and (owner = rasdc_library.currentDADUser)
                  union
                  select /*+ RULE*/ distinct SYNONYM_NAME id,
                                   SYNONYM_NAME || ' ... S' label,
                                   2 x
                    from all_synonyms s, all_tab_columns tc
                   where s.table_name = tc.table_name
                     and s.table_owner = tc.owner
                     and (s.owner = rasdc_library.currentDADUser)
                   union
                   select distinct owner||'.'||table_name id,
                          owner||'.'||table_name  /*|| ' ... ' || substr(type, 1, 1) */ label, 2 x
                   from dba_tab_privs x 
                   where --type in ('TABLE', 'VIEW') and
                    grantee = rasdc_library.currentDADUser  
                   order by 3, 1
                   --fetch first 50 rows only 
                  --</LOVSQL>
                  ) loop
        begin                    
        v_output := v_output || '<OPTION CLASS=selectp value="' || r__.id || '">' ||  r__.label || '</OPTION> ';
        exception when others then
          exit;
        end;  
      end loop;


htp.p('

<!DOCTYPE html>
<html lang="en">
<title>RASD wizard</title>
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
    <a href="#Form" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Form</a>
    <a href="#Block" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Blocks</a>
    <a href="#Triggers" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Triggers</a>
    <a href="#LinksLOV" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Links and LOV''s</a>
    <a href="#Pages" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Pages</a>    
    <a href="#CSSJS" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Custom CSS and JavaScript</a>    
    <a href="#Other" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Other</a>    
    <a href="#create" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Create</a>    
  </div>

  <!-- Navbar on small screens -->
  <div id="navDemo" class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">

    <a href="#Form" class="w3-bar-item w3-button w3-padding-large">Form</a>
    <a href="#Block" class="w3-bar-item w3-button w3-padding-large">Blocks</a>
    <a href="#Triggers" class="w3-bar-item w3-button w3-padding-large">Triggers</a>
    <a href="#LinksLOV" class="w3-bar-item w3-button w3-padding-large">Links and LOV''s</a>
    <a href="#Pages" class="w3-bar-item w3-button w3-padding-large">Pages</a>    
    <a href="#CSSJS" class="w3-bar-item w3-button w3-padding-large">Custom CSS and JavaScript</a>    
    <a href="#Other" class="w3-bar-item w3-button w3-padding-large">Other</a>    
    <a href="#create" class="w3-bar-item w3-button w3-padding-large">Create</a>    
  </div>
</div>

<!-- Header -->
<header class="w3-container w3-red" style="margin: 50px 0;">
    <div class="w3-third w3-center">
	  <img width="150px" src="rasdc_files.showfile?pfile=pict/rasd.gif" alt="RASD"/>	  
    </div>  

    <div class="w3-twothird">
        <p class="w3-xlarge">Welcome to the RASD simple wizard</p>
    </div>  


</header>

<form name="PF" id="PF" action="!rasdc_welcome.createform">

<!-- First Grid -->
<div id="Form" class="w3-row-padding w3-padding-32 w3-container">
  <div class="w3-content">
    <div >
      <h1>Form</h1>
      <h5 class="w3-padding-32">Enter the name of your new form:<input name="form" id="form" value="" maxlength="20"/> 
          <small>Allowed are only letters, numbers, character "_". Name can start only with letter.</small>
           
      <p>Form is application stored in PL/SQL package. It can be web, rest or batch application. 
         For form objects inheritance you can use functionality of referencing forms. It is recomended that form should not have more than few pages.
      </p>
      
<p>
More of how you prepare forms is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_FORMS/">this page</a>.<br/> 
</p>      
      </h5>
      
</div>
  </div>

<p>
    <a href="#Block" >>> Next >></a>
</p>

<!-- 2 Grid -->
<div id="Block" class="w3-row-padding w3-padding-32 w3-container w3-light-grey">
  <div class="w3-content">
      <h1>Blocks</h1>
      <h5 class="w3-padding-32">
      Name your block/blocks on your form (Block name must have only letters, numbers, character "_" and can start only with letter):
      <table>
       <tr>
<td><input name="block_1" id="block_1" value="" maxlength="20"/></td>
<td><select name="block_typ_1" id="block_typ_1" onchange="if ( document.getElementById(''block_typ_1'').value ==''DBBlock'') { document.getElementById(''block_obj_1'').style=''display: block''; } else {document.getElementById(''block_obj_1'').style=''display: none'';}">
  <option value=""></option>
  <option value="Filter">Filter Block</option>
  <option value="DBBlock">DB Block</option>
</select></td>
<td><select name="block_obj_1" id="block_obj_1">
  '); htp.p(v_output); htp.p('
</select></td></tr>
       <tr>
<td><input name="block_2" id="block_2" value="" maxlength="20"/></td>
<td><select name="block_typ_2" id="block_typ_2" onchange="if ( document.getElementById(''block_typ_2'').value ==''DBBlock'') { document.getElementById(''block_obj_2'').style=''display: block''; } else {document.getElementById(''block_obj_2'').style=''display: none'';}">
  <option value=""></option>
  <option value="DBBlock">DB Block</option>
</select></td>
<td><select name="block_obj_2" id="block_obj_2">
  '); htp.p(v_output); htp.p('
</select></td></tr>
       <tr>
<td><input name="block_3" id="block_3" value="" maxlength="20"/></td>
<td><select name="block_typ_3" id="block_typ_3" onchange="if ( document.getElementById(''block_typ_3'').value ==''DBBlock'') { document.getElementById(''block_obj_3'').style=''display: block''; } else {document.getElementById(''block_obj_3'').style=''display: none'';}">
  <option value=""></option>
  <option value="DBBlock">DB Block</option>
</select></td>
<td><select name="block_obj_3" id="block_obj_3">
  '); htp.p(v_output); htp.p('
</select></td></tr>     
       <tr>
<td><input name="block_4" id="block_4" value="" maxlength="20"/></td>
<td><select name="block_typ_4" id="block_typ_4" onchange="if ( document.getElementById(''block_typ_4'').value ==''DBBlock'') { document.getElementById(''block_obj_4'').style=''display: block''; } else {document.getElementById(''block_obj_4'').style=''display: none'';}">
  <option value=""></option>
  <option value="DBBlock">DB Block</option>
</select></td>
<td><select name="block_obj_4" id="block_obj_4">
  '); htp.p(v_output); htp.p('
</select></td></tr>

       <tr>
<td>...</td><td></td><td></td></tr>
      </table>
      </h5>
            
      <h5>
Each FORM is composed of one or many BLOCKs. Blocks can be one row size (usually filters) or many rows size (tables).<br/>
All BLOCKs consists of one or more FIELDs (usualy columns). This FIELDS are simple row types. <br/>
On each FORM you can specify special FIELDs (ACTION, PAGE, ...). All this FIELDs are simple types.<br/>
All FIELDs can be different types (number, date, varchar, clob, ...) and can have different presentation (input field, textarea, select, ...).          
     
<p>
More of how you prepare blocks is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_BLOCKSONFORM/">this page</a>.<br/> 
More of how you prepare fields is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_FIELDSONBLOCK/">this page</a>.<br/> 
</p>     
     </h5>
          
  </div>
</div>
<p>
    <a href="#Triggers" >>> Next >></a>
</p>


<!-- 3 Grid -->
<div id="Triggers" class="w3-row-padding w3-padding-32 w3-container">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Triggers</h1>
      <h5 class="w3-padding-32">
<p>Trigges are sniped of code (pl/sql) that you prepare. With trigges you can override generated code prepared with RASD. <br/>
   In trigges section you can prepare your own procedures, functions, types, ... And you can specify if they are public or private.<br/> 
   Use "Form navigator" and searcher to see how your code is executed. <br/> 
   How code is executed and what kind of triggers you have you can see on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASD_EXECUTE/">this page</a>.      
</p>
<p>
More of how you prepare trigges is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_TRIGGERS/">this page</a>. 
</p>
      </h5>

<div class="w3-panel w3-card w3-light-grey">
  <h6>Sample for trigger POST_SUBMIT where you change PAGE number based on field values</h6>
  <div class="w3-code notranslate w3-small">
if FILTERNAME = ''New value'' then<br> 
   PAGE := 1;<br>
elsif FILTERNAME = ''No value'' then <br>
   PAGE := 2;<br>
else <br>
   PAGE := 3;<br>
end if;  <br>
  </div>
</div>


</div>
    <div class="w3-third w3-center">
      <i class="fa fa-book fa-9x  w3-padding-32 w3-text-red"></i>
    </div>

    
  </div>
</div>
<p>
    <a href="#LinksLOV" >>> Next >></a>
</p>


<!-- 3 Grid -->
<div id="LinksLOV" class="w3-row-padding w3-padding-32 w3-container w3-light-grey">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Links and LOV''s</h1>
      <h5 class="w3-padding-32">

<p>In Links and LOV''s section you can prepare custom:
<ul>
 <li>LINKs</li>
 <li>LOV''s - List Of Values</li>
</ul>
</p>
<p>
With LINKs you can prepare links based of values on fields on block or you can specify constants. Links can be prepared to form, other forms or external web applications.
</p>
<p>
With LOV''s you can prepare list of values based on SQL or custom definitions.
</p>
<p>
More of how you prepare Links and LOV''s is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_LINKS/">this page</a>. 
</p>
 
      </h5>
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-file-code fa-9x  w3-padding-32 w3-text-red"></i>
    </div>
   
  </div>
</div>
<p>
    <a href="#Pages" >>> Next >></a>    
</p>


<!-- 3 Grid -->
<div id="Pages" class="w3-row-padding w3-padding-32 w3-container">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Pages</h1>
      <h5 class="w3-padding-32">
<p>On page section you can arange blocks to pages. Page zero (0) has all blocks. Here you can also define session blocks. This means that block field values are stored in sesson (cookies) and then you can share them over the other RASD forms.      
</p>
<p>
More of how you prepare pages is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_PAGES/">this page</a>. 
</p>
      </h5>
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-book fa-9x  w3-padding-32 w3-text-red"></i>
    </div>
  </div>
</div>
<p>
    <a href="#CSSJS" >>> Next >></a>    
</p>
    
<!-- 3 Grid -->
<div id="CSSJS" class="w3-row-padding w3-padding-32 w3-container w3-light-grey">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Custom CSS and JavaScript</h1>
      <h5 class="w3-padding-32">

<p>In CSS, JS you can prepare custom:
<ul>
 <li>CSS - You can override general CSS RASD settings.</li>
 <li>JS  - You can define custom JavaScript code for the form. All functions, you can use are stored in general JS RASD. </li>
</ul>
</p>
<p>
More of how you prepare CSS, JS is on <a target="_blank" href="https://sourceforge.net/p/rasd/wiki/RASDC_CSSJS/">this page</a>. 
</p>
      </h5>
      
<div class="w3-panel w3-card w3-light-grey">
  <h6>Sample for setting spinner and adding init row status for unchanged rows</h6>
  <div class="w3-code notranslate w3-small">
$(function() {<br/>
<br/>
  addSpinner();<br/>
  initRowStatus();<br/>
  <br/>
// transformVerticalTable("B15_TABLE", 4 );<br/>
// setShowHideDiv("BLOCK_NAME_DIV", true);<br/>
// validateNumberFields();<br/>
// showErrorFields();<br/>
// showInfoFields();<br/>
// showMandatoryFields();<br/>
<br/>
 });<br/>
  </div>
</div>
      
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-file-code fa-9x  w3-padding-32 w3-text-red"></i>
    </div>

  </div>
</div>
<p>
    <a href="#Other" >>> Next >></a>    
</p>
   

<!-- 3 Grid -->
<div id="Other" class="w3-row-padding w3-padding-32 w3-container">
  <div class="w3-content">
    <div class="w3-twothird">
      <h1>Other</h1>
      <h5 class="w3-padding-32">
<p>In RASD, you hava many other things you can explore (REST, Debug, SQL Client, ... ). All documentation is on SourceForge or you can use hints in RASD environment. Basic documentation you can find on links below:

<ul>
 <li><a target="_blank" href="https://sourceforge.net/p/rasd/wiki/Documentation/">Documentation</a></li>
 <li><a target="_blank" href="https://sourceforge.net/p/rasd/discussion/hintsandtipsrasd/">Hints and Tips using RASD</a></li>
 <li><a target="_blank" href="https://sourceforge.net/p/rasd/discussion/rasd-step-by-step/">Start using RASD step by step</a></li>
</ul>
</p>
<p>
But first click on  the button below and create you new form.
</p>
      </h5>
</div>
    <div class="w3-third w3-center">
      <i class="fa fa-book fa-9x  w3-padding-32 w3-text-red"></i>
    </div>
 
  </div>
</div>
<p>
    <a href="#create" >>> Next >></a>  
</p>
  

<!-- Second Grid -->
<div id="create" class="w3-row-padding w3-padding-32 w3-container w3-light-grey">
  <div class="w3-content">
    <div class="w3-third w3-center">
      <i class="fab fa-osi fa-9x w3-padding-32 w3-text-red w3-margin-right"></i>
    </div>

    <div class="w3-twothird">
      <h5 >
      <input type="button" value="Create new form" onclick="if ( document.getElementById(''form'').value == '''' || document.getElementById(''block_typ_1'').value == '''' || document.getElementById(''block_1'').value == '''') { alert(''At least form name must be specifiead and one block defined!''); exit;} else {document.getElementById(''PF'').submit();} " class="w3-button w3-black w3-padding-large w3-large w3-margin-top"/>
</h5>


    </div>
  </div>
</div>


</form>

<!-- Footer -->
<footer class="w3-container w3-padding-32 w3-center w3-opacity w3-black w3-center">  
    <h1 class="w3-margin w3-xlarge">Make your day easy with things SW can do for you<a onclick="window.open(''test_dad_comm?guid=mySecretToken'',''_blank'')">.</a></h1>
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


document.getElementById(''block_obj_1'').style=''display: none'';
document.getElementById(''block_obj_2'').style=''display: none'';
document.getElementById(''block_obj_3'').style=''display: none'';
document.getElementById(''block_obj_4'').style=''display: none'';


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

end ;
/
