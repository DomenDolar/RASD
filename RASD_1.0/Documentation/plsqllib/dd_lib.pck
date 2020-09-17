create or replace package dd_lib is
/*
STATUS

28.11.2006 - First version - Domen Dolar
*/

procedure HtpPrn(pclob in out nocopy clob);

function ConvertFromHTML(vvv varchar2) return varchar2 ;
function ConvertToHTML(vvv varchar2) return varchar2 ;
  
procedure TestCaptcha (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);

procedure Captcha (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);

procedure CreateXMLFromTable(ptabela varchar2);

procedure ShowWebProperties(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  );

procedure CreateRawAQ (
  qname varchar2,
  is_multi_consumer boolean default false
);
procedure ReadAndShowURL(urllocation varchar2);
/*
create table SHOWSQLCODE
(
  ID          NUMBER not null,
  DESCRIPTION VARCHAR2(200) not null,
  SQLCODE     VARCHAR2(4000) not null,
  VALID_FROM  DATE not null,
  VALID_TO    DATE
)
*/
procedure ShowSQLResults(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
);
procedure MailMessage( from_name varchar2,
                       to_name varchar2,
                       subject varchar2,
                       message varchar2,
                       smtp_server varchar2,
                       smtp_server_port number default 25,
                       max_size number default 9999999999,
                       filename1 varchar2 default null,
                       filename2 varchar2 default null,
                       filename3 varchar2 default null,
                       debug number default 0 );
procedure LogCreateTables;
procedure LogCreateTriggers;
/*
create table DOCUMENTS
(
  NAME         VARCHAR2(256) not null,
  MIME_TYPE    VARCHAR2(128),
  DOC_SIZE     NUMBER,
  DAD_CHARSET  VARCHAR2(128),
  LAST_UPDATED DATE,
  CONTENT_TYPE VARCHAR2(128),
  BLOB_CONTENT BLOB
);
*/
function ConvertBlobXMLToClob(pfile documents.name%type) return clob;
procedure DocumentUploadMulti (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr);
procedure DocumentUpload (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr);
procedure DocumentDownload;
procedure Test;

end dd_lib;
/
create or replace package body dd_lib is

procedure HtpPrn(pclob in out nocopy clob) is
 v_excel varchar2(32000);
 v_clob clob := pclob;
begin
  while length(v_clob) > 0 loop
    begin
      if length(v_clob) > 16000 then
         v_excel:= substr(v_clob,1,16000);
         htp.prn(v_excel);
         v_clob:= substr(v_clob,length(v_excel)+1);
      else
         v_excel := v_clob;
         htp.prn(v_excel);
         v_clob:='';
         v_excel := '';
      end if;
    end;
  end loop;
end; 

  function ConvertFromHTML(vvv varchar2) return varchar2 is
  begin
  return
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(vvv,
     '&','&amp;')
    ,'<','&lt;')
    ,'>','&gt;')
    ,'"','&quot;')
    ,'''','&apos;')
    ,'`','&acute;')
    ;    
  end;
  function ConvertToHTML(vvv varchar2) return varchar2 is
  begin
  return
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(vvv,
     '&amp;','&')
    ,'&lt;','<')
    ,'&gt;','>')
    ,'&quot;','"')
    ,'&apos;','''')
    ,'&acute;','`')
    ;    
  end;

procedure TestCaptcha (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
)
as
 x raw(100);
 vcapchapreveri raw(100);
 vcapchavrednost raw(100);
 v varchar2(100);
begin
    for i__ in 1..nvl(name_array.count,0) loop
      if name_array(i__) = 'capchavrednost' then vcapchavrednost := value_array(i__);
      elsif name_array(i__) = 'capchapreveri' then vcapchapreveri := utl_raw.cast_to_raw(value_array(i__));
      end if;
    end loop;
begin

if utl_encode.base64_encode(vcapchapreveri) = vcapchavrednost then
  htp.p ('OK<BR>');
else
  htp.p ('NOT OK<BR>');  
end if;

exception when others then null;
  htp.p ('NOT OK<BR>');  
end;
 v := dd_random.rndchar||dd_random.rndchar||dd_random.rndchar||dd_random.rndchar;

 x := utl_raw.cast_to_raw(v);
 x := utl_encode.base64_encode(x);

htp.p('


<form method=post>
<img src="p_htmldokumenti.capcha?pt='||x||'">
<input type="text" name="capchapreveri" value="" size="4" maxlength="4">
<input type="hidden" name="capchavrednost" value="'||x||'">

<input type="submit" name="nnnn" value="Preveri">
</form>
');

exception when others then htp.p(sqlerrm);
end;

procedure Captcha (
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
htp.p('Content-length: ' || dbms_lob.getlength( l_lob ));
owa_util.http_header_close;
wpg_docload.download_file( l_lob );

end;

procedure CreateXMLFromTable(ptabela varchar2) is
 v_plsql varchar2(4000);
 v_tabela varchar2(30) := upper(ptabela);
 v_statussend varchar2(1) := 'N';
begin

v_plsql := 'declare 
  v_result clob := '''';
  v_resultrid xmltype;
begin
savepoint sp;
select xmlelement(
"XYZ", xmlagg(xmlelement(
  "ROWID", rowidtochar(r.rid))))
  ,
xmlelement("'||v_tabela||'", xmlagg(xmlelement("POST"
';
for r in
(select 
'
      , xmlelement("'||u.COLUMN_NAME||'", '||
   decode(u.DATA_TYPE,
    'NUMBER','to_char(r.'||u.COLUMN_NAME||',''FM99999999999999999990.00000'')',
    'DATE','to_char(r.'||u.COLUMN_NAME||',''dd.mm.yyyy hh24:mi:ss'')',
    'r.'||u.COLUMN_NAME
   )||')' polje, u.COLUMN_NAME
from user_tab_columns u
where u.TABLE_NAME = v_tabela
order by u.column_id) loop

if r.column_name = 'STATUSSEND' then
v_statussend := 'D';
end if;

if r.column_name <> 'RID' then 
v_plsql := v_plsql ||r.polje;
end if;

end loop;
    
v_plsql := v_plsql ||'))).getclobval()
into v_resultrid, v_result
from '||v_tabela||' r';
if v_statussend = 'D' then
v_plsql := v_plsql ||'
;
for r in (select
  chartorowid(extractvalue(value(x), ''ROWID'')) rid
from table(xmlsequence(extract(v_resultrid,''XYZ/ROWID''))) x) loop
  update '||v_tabela||' set statusprepisa = 1 where rowid in r.rid;
end loop;';
else
v_plsql := v_plsql ||'
;';
end if;
/*v_plsql := v_plsql ||'
if instr(v_result,''<POST>'') > 0 then
insert into save_data
  (id, table, sourcexml, statussend)
values
  (prenos_produkcija_seq.nextval, '''||v_tabela||''', v_result, 0);
end if;';*/
v_plsql := v_plsql ||'
commit;
exception when others then 
rollback to sp;
raise;
end;';
--htp.p(v_plsql);
execute immediate v_plsql;
end;



procedure ShowWebProperties(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
  ) is
  v_baza varchar2(100);
  x varchar2(50); 
begin
  select user||'@'||global_name into v_baza from global_name;
  htp.p('user@baza  = '||v_baza);
  htp.p('<hr>');
  for r in (select * from nls_session_parameters
            order by parameter)
  loop
    htp.p(r.parameter||' = ' ||r.value||'<br>');
  end loop;
  htp.p('<hr>');
  for r in (select * from nls_database_parameters
            order by parameter)
  loop
    htp.p(r.parameter||' = ' ||r.value||'<br>');
  end loop;
  htp.p('<hr>');
  owa_util.print_cgi_env;
  htp.p('<hr>');
end;


procedure CreateRawAQ (
  qname varchar2,
  is_multi_consumer boolean default false
)
as
  qtablename varchar2(110) := qname;
begin
 null; --you must have abms_aqadm execute privileges
/*  dbms_aqadm.stop_queue (queue_name => qname);
  dbms_aqadm.drop_queue (queue_name => qname);
  dbms_aqadm.drop_queue_table (Queue_table => qtablename);
  EXCEPTION
  WHEN OTHERS THEN
    null;

  dbms_aqadm.create_queue_table (Queue_table => qtablename, Queue_payload_type=> 'RAW', 
                                 multiple_consumers => is_multi_consumer);
  dbms_aqadm.create_queue (Queue_name => qname, Queue_table => qtablename);
  dbms_aqadm.start_queue(qname);*/
end;

procedure ReadAndShowURL(urllocation varchar2) as
  http_req  utl_http.req;
  http_resp utl_http.resp;
  x varchar2(30000);
begin
    http_req := utl_http.begin_request(urllocation, 'POST','HTTP/1.0');
    http_resp := utl_http.get_response(http_req);
    utl_http.read_text(http_resp,x);
    htp.p(x);
end;

procedure ShowSQLResults(
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) as
  v_execimedv  varchar2(32000);
  v_execimed owa.vc_arr;
  v_show boolean := true;
  v_limit varchar2(2000);
  p_showd varchar2(10);
  p_show_only_results varchar2(10);
  p_show_no_buttons  varchar2(10);
  xlen number;
  v_sql varchar2(32000);
  type rcolumn is record
  (
    name varchar(4000)
  );
  type rbind is record
  (
    name varchar(4000),
    var varchar(4000)
  );
  TYPE tcolumns IS TABLE OF rcolumn index by binary_integer;
  TYPE tbinds IS TABLE OF rbind index by binary_integer;
  vcolumns tcolumns;
  vbinds tbinds;

  function get_vred(poljeime varchar2,name_array owa.vc_arr,value_array owa.vc_arr)  return varchar2 is
  begin
    for i in 1..nvl(name_array.count,0) loop
      if  upper(name_array(i)) = upper(poljeime) then
        return value_array(i);
      end if;
    end loop;
    return '';
  end;


begin
  p_showd := get_vred('pshowd',name_array,value_array);
  p_show_only_results := nvl(get_vred('pshow_only_results',name_array,value_array),'N');
  p_show_no_buttons := nvl(get_vred('pshow_no_buttons',name_array,value_array),'N');
--    for i in 1..nvl(name_array.count,0) loop
--      htp.p( name_array(i)||'='||value_array(i)||'<br>');
--    end loop;
  if p_showd is null then
htp.p('<P><TABLE>');
for r in ( select * from SHOWSQLCODE order by description ) loop
htp.p('<TR><TD>&nbsp;&nbsp;&nbsp;&nbsp;</TD><TD><A CLASS=link href="?pshowd='||r.id||'">'||r.description||'</A></TD></TR>');
end loop;
htp.p('</TABLE></P>');
  else -- show SQL
  if p_showd = 'SQL' then
    v_sql := get_vred('psql',name_array,value_array);
  else
    select d.sqlcode into v_sql
    from SHOWSQLCODE d
    where d.id = p_showd;
  end if;
  if length(v_sql) > 0 then
  --PREBERI COLUMNS
  declare
    v_sqlpod varchar2(4000) := substr (v_sql,
                                       instr(upper(v_sql),'SELECT'),
                                       instr(upper(v_sql),'FROM')-instr(upper(v_sql),'SELECT'));
   i pls_integer := 0;
   v_z pls_integer;
   v_k pls_integer;
   v_sqlpod1 varchar2(4000);
  begin
    if instr(v_sqlpod,'* ') > 0 or instr(v_sqlpod,'*,') > 0 then
      v_sqlpod  := substr (v_sql,
                                       instr(upper(v_sql),'SELECT',1,1),
                                       instr(upper(v_sql),'FROM',1,2)-instr(upper(v_sql),'SELECT',1,1));
      v_sqlpod1 := substr (v_sql,
                                       instr(upper(v_sql),'SELECT',1,2),
                                       instr(upper(v_sql),'FROM',1,2)-instr(upper(v_sql),'SELECT',1,2));
    end if;
    if instr(v_sqlpod1,'* ') > 0 or instr(v_sqlpod1,'*,') > 0 then
      v_sqlpod  := substr (v_sql,
                                       instr(upper(v_sql),'SELECT',1,1),
                                       instr(upper(v_sql),'FROM',1,3)-instr(upper(v_sql),'SELECT',1,1));
    end if;
    while instr(v_sqlpod,'"') > 0 loop
      i := i+1;
      v_z := instr(v_sqlpod,'"')+1;
      v_k := instr(v_sqlpod,'"',v_z);
      vcolumns(i).name := substr(v_sqlpod,v_z, v_k-v_z);
      v_sqlpod := substr(v_sqlpod,v_k+1);
    end loop;
  end;
  --READ BIND
  declare
   v_sqlpod varchar2(4000) := v_sql;
   i pls_integer := 0;
   v_z pls_integer;
   v_k pls_integer;
  begin
    while instr(v_sqlpod,'&"') > 0 loop
      i := i+1;
      v_z := instr(v_sqlpod,'&"')+2;
      v_k := instr(v_sqlpod,'"',v_z);
      vbinds(i).name := substr(v_sqlpod,v_z, v_k-v_z);
      vbinds(i).var :=  replace(translate(substr(v_sqlpod,v_z, v_k-v_z),'!"#$%&/()=?*+''<>,.-_:;','                      '),' ','');
      v_sqlpod := substr(v_sqlpod,v_k+1);
    end loop;
  end;
  --READ SQL
  for i in 1..vbinds.count loop
    v_sql := replace(v_sql,'&"'||vbinds(i).name||'"',':'||vbinds(i).var);
  end loop;

  --EXECUTE IMMEDIATE CODE
v_execimed(nvl(v_execimed.count+1,1)) := '
DECLARE
';
for i in 1..vbinds.count loop
v_show := true;
for j in i+1..vbinds.count loop
  if vbinds(i).var = vbinds(j).var then v_show := false; end if;
end loop;
if v_show then
v_execimed(nvl(v_execimed.count+1,1)) := 'b' ||vbinds(i).var||' varchar2(4000) := '''||get_vred('b'||vbinds(i).var,name_array,value_array)||''';
';
end if;

end loop;

if instr(v_sql,'#NAVIGATION#') > 0 then
v_execimed(nvl(v_execimed.count+1,1)) :=
'    vprowindex number := '||nvl(get_vred('bprowindex',name_array,value_array),1)||';
     vprows number := '||nvl(get_vred('bprows',name_array,value_array),10)||';
';
end if;
v_execimed(nvl(v_execimed.count+1,1)) := '
     vpaction varchar2(100) := nvl('''||get_vred('bpaction',name_array,value_array)||''',''Search'');
';

v_execimed(nvl(v_execimed.count+1,1)) :=  '
   type rowsa is record
   (';
for i in 1..vcolumns.count loop
if i = 1 then
v_execimed(nvl(v_execimed.count+1,1)) :=  '   s'||i||' varchar2(4000)
';
else
v_execimed(nvl(v_execimed.count+1,1)) :=  '  ,s'||i||' varchar2(4000)
';
end if;
end loop;

v_execimed(nvl(v_execimed.count+1,1)) :=  '   );
   TYPE rowse IS TABLE OF rowsa index by binary_integer;
   zapisicur   rowse;
   zapisi   rowse;
   TYPE CurTyp IS REF CURSOR;
   cur_dyn   CurTyp;
   v_limit pls_integer;
   c_limit pls_integer := 5000;
   v_sprlimit varchar2(2000) := '''';
   v_j pls_integer;
BEGIN
-- execute immediate ''alter session set nls_language=''''SLOVENIAN'''''';
-- execute immediate ''alter session set nls_territory=''''SLOVENIA'''''';
if vpaction = ''File'' then
  owa_util.mime_header(''send'');
end if;
';
if p_show_only_results <> 'Y' and p_show_no_buttons <> 'Y' then
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
  htp.p(''<FORM  METHOD="POST" NAME="F1">'');
end if;
';
end if;
if instr(v_sql,'#NAVIGATION#') > 0 then
 v_execimed(nvl(v_execimed.count+1,1)) :=  '
   if vpaction in ('||substr(v_sql,instr(v_sql,'#NAVIGATION#')+13,instr(v_sql,'*/')-instr(v_sql,'#NAVIGATION#')-13 )||') then
     v_limit := vprowindex+vprows-1;
   else
     v_limit := c_limit;
   end if;
';
else
v_execimed(nvl(v_execimed.count+1,1)) := '
     v_limit := c_limit;
';
end if;
v_execimed(nvl(v_execimed.count+1,1)) := '
   OPEN cur_dyn FOR
      '''||replace(v_sql,'''','''''')||'''';
if vbinds.count > 0  then
  v_execimed(nvl(v_execimed.count+1,1)) :=  '
      USING ';
  for i in 1..vbinds.count loop
  if i = 1 then
  v_execimed(nvl(v_execimed.count+1,1)) := 'b' ||vbinds(i).var;
  else
  v_execimed(nvl(v_execimed.count+1,1)) := ',b'||vbinds(i).var;
  end if;
  end loop;
end if;
v_execimed(nvl(v_execimed.count+1,1)) :=  '
      ;
   FETCH cur_dyn BULK COLLECT INTO zapisicur ';
if instr(v_sql,'#NAVIGATION#') > 0 then
v_execimed(nvl(v_execimed.count+1,1)) := ' LIMIT v_limit';
end if;
v_execimed(nvl(v_execimed.count+1,1)) :=  ';
   CLOSE cur_dyn;
';
if instr(v_sql,'#NAVIGATION#') > 0 then
 v_execimed(nvl(v_execimed.count+1,1)) :=  '
   if vpaction in ('||substr(v_sql,instr(v_sql,'#NAVIGATION#')+13,instr(v_sql,'*/')-instr(v_sql,'#NAVIGATION#')-13 )||') then
   v_j := 1;
   for v_i in vprowindex..zapisicur.count loop
     zapisi(v_j) := zapisicur(v_i);
     v_j := v_j + 1;
   end loop;
   else
     zapisi := zapisicur;
     if zapisi.count >= c_limit then
     v_sprlimit := ''To many results (more than ''||c_limit||'' rows)!'';
     end if;
   end if;
';
else
v_execimed(nvl(v_execimed.count+1,1)) :=  '
   zapisi := zapisicur;
   if zapisi.count >= c_limit then
     v_sprlimit := ''To many results (more than ''||c_limit||'' rows)!'';
   end if;
';
end if;
if p_show_only_results <> 'Y' and p_show_no_buttons <> 'Y' then
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
htp.p(''        <BR>
                <INPUT TYPE="submit" NAME="action" CLASS=submit VALUE="Search">
                <INPUT TYPE="button" NAME="xx" CLASS=submit VALUE="Back" onclick="window.location=''''?1=1''''">
                <hr>'');
end if;
';
end if;
if p_show_only_results <> 'Y' then
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
  htp.p(''<TABLE>'');
end if;
';
for i in 1..vbinds.count loop
v_show := true;
for j in i+1..vbinds.count loop
  if vbinds(i).var = vbinds(j).var then v_show := false; end if;
end loop;
if vbinds(i).var in ('prows','prowindex','paction') then
  v_show := false;
end if;
if v_show then
v_execimed(nvl(v_execimed.count+1,1)) := 'if vpaction <> ''File'' then ';
v_execimed(nvl(v_execimed.count+1,1)) := 'htp.p(''<tr> <td CLASS=labela1>' ||vbinds(i).name||': </td>'');
';
v_execimed(nvl(v_execimed.count+1,1)) := 'htp.p(''<td><input type=input name="b' ||vbinds(i).var||'" value="'||get_vred('b'||vbinds(i).var,name_array,value_array)||'"></td></tr>'');
';
v_execimed(nvl(v_execimed.count+1,1)) := 'end if;';
end if;
end loop;

v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
   htp.p(''</TABLE><BR>'');
end if;
';
end if;
v_execimed(nvl(v_execimed.count+1,1)) := '
if vpaction <> ''File'' then
   htp.p(''<TABLE CLASS=okvirb border="1" width="100%" cellspacing="0" cellpading="3"><TR CLASS=izpistabela>'');
end if;
';
for i in 1..vcolumns.count loop
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
  htp.p(''<TD  CLASS=labela >'||vcolumns(i).name||'</TD>'');
else
  htp.prn(''"'||vcolumns(i).name||'";'');
end if;
';
end loop;
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
   htp.p(''</TR>'');
else
   htp.p('''');
end if;
   FOR i in 1..zapisi.count LOOP
if vpaction <> ''File'' then
     htp.p(''<TR CLASS=izpistabela>'');
end if;
';
for i in 1..vcolumns.count loop
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
  htp.p(''<TD'');
  declare
   yxd number;
  begin
    yxd := to_number(replace(replace(zapisi(i).s'||i||','','',''''),''.'',''''),''999G999G999G999G990D00'');
    if yxd = 0 then
      htp.p ('' align="right" '');
    end if;
  exception when others then null;
  end;
  htp.p(''>&nbsp;''||zapisi(i).s'||i||'||''</TD>'');
else
  htp.prn(''"''||zapisi(i).s'||i||'||''";'');
end if;
';
end loop;
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
     htp.p(''</TR>'');
else
   htp.p('''');
end if;
   END LOOP;
if vpaction <> ''File'' then
htp.p(''</TABLE>
<BR>
 <P>
 ''||v_sprlimit||''
 </P>
'');
end if;
';


if p_show_only_results <> 'Y' and p_show_no_buttons <> 'Y' then

v_execimed(nvl(v_execimed.count+1,1)) := '
if vpaction <> ''File'' then
htp.p(''
        <hr>
        <INPUT TYPE="submit" NAME="action" CLASS=submit VALUE="Search">
        <INPUT TYPE="button" NAME="xx" CLASS=submit VALUE="Back" onclick="window.location=''''?1=1''''">
'');
end if;
';
v_execimed(nvl(v_execimed.count+1,1)) :=  '
if vpaction <> ''File'' then
 htp.p(''         </FORM>
   '');
end if;
';
end if;
v_execimed(nvl(v_execimed.count+1,1)) :=  '
END;';
begin
v_execimedv := '';
xlen := 0;
for i in 1..v_execimed.count loop
v_execimedv := v_execimedv||v_execimed(i);
xlen := xlen + length(v_execimed(i));
end loop;

execute immediate v_execimedv;
--htp.p(v_execimedv);
end;
  end if;
end if;
exception when others then
htp.p('<Tr><TD nowrap><font color=red>');
htp.p(substr(sqlerrm,1,11)||' '||sqlerrm);
htp.p('</font></Td><TR>');
end;



procedure MailMessage( from_name varchar2,
                       to_name varchar2,
                       subject varchar2,
                       message varchar2,
                       smtp_server varchar2,
                       smtp_server_port number default 25,
                       max_size number default 9999999999,
                       filename1 varchar2 default null,
                       filename2 varchar2 default null,
                       filename3 varchar2 default null,
                       debug number default 0 ) is

v_smtp_server      varchar2(50) := smtp_server;
v_smtp_server_port number  := smtp_server_port;

v_directory_name   varchar2(100);
v_file_name        varchar2(100);
v_line             varchar2(1000);
crlf               varchar2(2):= '
';
mesg               varchar2(32767);
conn               UTL_SMTP.CONNECTION;
type varchar2_table is table of varchar2(200) index by binary_integer;
file_array         varchar2_table;
i                  binary_integer;
v_file_handle      utl_file.file_type;
v_slash_pos        number;
mesg_len           number;
mesg_too_long      exception;
invalid_path       exception;

mesg_length_exceeded boolean := false;
begin
 file_array(1) := filename1;
 file_array(2) := filename2;
 file_array(3) := filename3;
 conn:= utl_smtp.open_connection( v_smtp_server, v_smtp_server_port );
 utl_smtp.helo( conn, v_smtp_server );
 utl_smtp.mail( conn, from_name );
 utl_smtp.rcpt( conn, to_name );
 utl_smtp.open_data ( conn );
 mesg:=
  'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || crlf ||
  'From: ' || from_name || crlf ||
  'Subject: ' || subject || crlf ||
  'To: ' || to_name || crlf ||
  'Mime-Version: 1.0' || crlf ||
  'Content-Type: multipart/mixed; boundary="DMW.Boundary.605592468"' || crlf ||
  '' || crlf ||
  'text besedilo' || crlf ||
  '' || crlf ||
  '--DMW.Boundary.605592468' || crlf ||
  '' || crlf ||
  message || crlf;
  mesg_len := length(mesg);
  if mesg_len > max_size then
   mesg_length_exceeded := true;
 end if;
  utl_smtp.write_data ( conn, mesg );
for i in  1..3 loop
 exit when mesg_length_exceeded;
  if file_array(i) is not null then
   begin
     v_slash_pos := instr(file_array(i), '/', -1 );
     if v_slash_pos = 0 then
        v_slash_pos := instr(file_array(i), '\', -1 );
     end if;
     v_directory_name := substr(file_array(i), 1, v_slash_pos - 1 );
     v_file_name      := substr(file_array(i), v_slash_pos + 1 );
     v_file_handle := utl_file.fopen(v_directory_name, v_file_name, 'r' );
     mesg := crlf || '--DMW.Boundary.605592468' || crlf ||
      'Content-Type: application/octet-stream;  name="' || v_file_name || '"' || crlf ||
      'Content-Disposition: attachment; filename="' || v_file_name || '"' || crlf ||
      'Content-Transfer-Encoding: 8bit' || crlf || crlf ;
      mesg_len := mesg_len + length(mesg);
      utl_smtp.write_data ( conn, mesg );
    loop
      utl_file.get_line(v_file_handle, v_line);
      if mesg_len + length(v_line) > max_size then
         mesg := '*** truncated ***' || crlf;
         utl_smtp.write_data ( conn, mesg );
         mesg_length_exceeded := true;
         raise mesg_too_long;
      end if;
      mesg := v_line || crlf;
      utl_smtp.write_data ( conn, mesg );
     mesg_len := mesg_len + length(mesg);
    end loop;
    exception
     when utl_file.invalid_path then
       if debug > 0 then
          dbms_output.put_line('Error in opening attachment '||
          file_array(i) );
       end if;
     when others then
       null;
     end;
     mesg := crlf;
   utl_smtp.write_data ( conn, mesg );
   utl_file.fclose(v_file_handle);
  end if;
 end loop;
 mesg := crlf || '--DMW.Boundary.605592468--' || crlf;
 utl_smtp.write_data ( conn, mesg );
 utl_smtp.close_data( conn );
 utl_smtp.quit( conn );
end;



procedure LogCreateTables as
v_vred varchar2(4000);
v_ime varchar2(4000);
begin
  -- Test statements here
  for r in (select t.table_name
            from user_tables t
            order by t.table_name) loop
htp.p('create table log$'||r.table_name||' as select * from '||r.table_name||' where 1=2;');
htp.p('alter table log$'||r.table_name||' add logczsp date not null;');
htp.p('alter table log$'||r.table_name||' add logoper varchar2(50) not null;');
htp.p('alter table log$'||r.table_name||' add logakcija varchar2(50) not null;');
  end loop;
end;

procedure LogCreateTriggers as
v_vred varchar2(4000);
v_ime varchar2(4000);
begin
  -- Test statements here
  for r in (select t.table_name
            from user_tables t
            order by t.table_name) loop
htp.p('create or replace trigger '||substr(r.table_name,1,26)||'_gbu');
htp.p('  before update on '||r.table_name||'  ');
htp.p('  for each row');
htp.p('declare');
htp.p('  -- local variables here');
htp.p('begin');
htp.p('  -- Generated: '||to_char(sysdate,'dd.mm.yyyy hh:mi:ss')||'.');
htp.p('  -- When you change trigger rename it with deleteing char "g" in trigger name.');
htp.p('  if 1=2');
  for r1 in (select t.table_name,t.column_name,t.data_type
            from user_tab_cols t
            where t.table_name = r.table_name
            order by t.column_id) loop
if r1.data_type = 'VARCHAR2' then
htp.p(' or nvl(:new.'||r1.column_name||','' '') <> nvl(:old.'||r1.column_name||','' '')');
elsif r1.data_type = 'NUMBER' then
htp.p(' or nvl(:new.'||r1.column_name||',-111111111111111111111) <> nvl(:old.'||r1.column_name||',-111111111111111111111)');
elsif r1.data_type = 'DATE' then
htp.p(' or nvl(:new.'||r1.column_name||',to_date(''01011900'',''ddmmyyyy'')) <> nvl(:old.'||r1.column_name||',to_date(''01011900'',''ddmmyyyy''))');
end if;
  end loop;
htp.p('  then');
v_ime := '';
v_vred := '';

for rx in (
select ','||column_name ime, ',:old.'||column_name vred
from user_tab_cols
where table_name = r.table_name
order by column_id
) loop
  v_ime := v_ime || rx.ime;
  v_vred := v_vred || rx.vred;
end loop;

htp.p('  insert into log$'||r.table_name);
htp.p('    ('||substr(v_ime,2)||',logczsp, logoper, logakcija)');
htp.p('  values');
htp.p('    ('||substr(v_vred,2)||',sysdate, :new.aoper, ''U'');');
htp.p('  end if;');
htp.p('end;');
htp.p('/');
  end loop;
end;

 function ConvertBlobXMLToClob(pfile documents.name%type) return clob is
   type message_type is record (
        content blob,
        charset varchar2(30),
        typ varchar2(20)
   );
   v_message message_type;
   v_content clob;
   v_dest_offset number := 1;
   v_src_offset number := 1;
   v_lang_context number := dbms_lob.default_lang_ctx;
   v_warning number;
   v_x1 number;  
 begin
   -- preberimo dokument
   select t.blob_content, 'UTF8' --t.dad_charset 
        , t.mime_type
       into v_message.content, v_message.charset, v_message.typ
   from documents t
   where t.name = pfile;

   -- to CLOB
      dbms_lob.createtemporary(v_content, TRUE);
      v_dest_offset := 1;
      v_src_offset  := 1;
      v_lang_context := dbms_lob.default_lang_ctx;
      DBMS_LOB.CONVERTTOCLOB(v_content, v_message.content, dbms_lob.getlength(v_message.content), v_dest_offset, v_src_offset,
                              nls_charset_id(v_message.charset), v_lang_context, v_warning);
      
      v_x1 := instr(lower(substr(v_content,1,1000)),'encoding="');

      if v_x1 > 0 then
        v_message.charset := replace(substr(v_content,v_x1+10,instr(lower(substr(v_content,1,1000)),'"', v_x1+10)-v_x1-10),'-','');

        dbms_lob.createtemporary(v_content, TRUE);
        v_dest_offset := 1;
        v_src_offset  := 1;
        v_lang_context := dbms_lob.default_lang_ctx;
        DBMS_LOB.CONVERTTOCLOB(v_content, v_message.content, dbms_lob.getlength(v_message.content), v_dest_offset, v_src_offset,
                               nls_charset_id(v_message.charset), v_lang_context, v_warning);
      end if;                             
      
   return v_content;       
 end;  


procedure DocumentUploadMulti (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr)
is
 pdatoteka Documents.name%type;
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
 pdatoteka := namedParam('pdatoteka',name_array,value_array);
 htp.p('
<html>
 <HEAD>
   <META HTTP-EQUIV="Content-Type" NAME="" CONTENT="text/html;CHARSET=WINDOWS-1250">  
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="-1">  
   <SCRIPT LANGUAGE="JavaScript">
// Multiple file selector by Stickman 
-- http://www.the-stickman.com
// with thanks to: [for Safari fixes] Luis Torrefranca 
-- http://www.law.pitt.edu and Shawn Parker & John Pennypacker 
-- http://www.fuzzycoconut.com [for duplicate name bug] ''neal''
function MultiSelector( list_target, max ){
  this.list_target = list_target;
  this.count = 0;
  this.id = 0;
  if( max ){this.max = max;} 
  else {this.max = -1;};
  this.addElement = function( element ){
    if( element.tagName == ''INPUT'' && element.type == ''file'' ){
      element.name = ''file_'' + this.id++;element.multi_selector = this;element.onchange = function(){
        var new_element = document.createElement( ''input'' );
        new_element.type = ''file'';
        this.parentNode.insertBefore( new_element, this );
        this.multi_selector.addElement( new_element );
        this.multi_selector.addListRow( this );
        this.style.position = ''absolute'';
        this.style.left = ''-1000px'';};
        if( this.max != -1 && this.count >= this.max ){
          element.disabled = true;};
        this.count++;this.current_element = element;} 
      else {alert( ''Error: not a file input element'' );};};
   this.addListRow = function( element ){
   var new_row = document.createElement( ''div'' );
   var new_row_button = document.createElement( ''input'' );
   new_row_button.type = ''button'';new_row_button.value = ''Delete'';
   new_row.element = element;new_row_button.onclick= function(){
   this.parentNode.element.parentNode.removeChild( this.parentNode.element );
   this.parentNode.parentNode.removeChild( this.parentNode );
   this.parentNode.element.multi_selector.count--;
   this.parentNode.element.multi_selector.current_element.disabled = false;
   return false;};
   new_row.innerHTML = element.value;
   new_row.appendChild( new_row_button );
   this.list_target.appendChild( new_row );};
};
    </SCRIPT>
    <title>Upload</title> 
 </HEAD> 
 <body>  
  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFF99" summary="">  
   <tr><td><font size="5">Upload</font></TD></TR>  
  </TABLE>');  
 if pdatoteka is not null then
 htp.p('   
  <BR>   File "'||substr(pdatoteka, instr(pdatoteka,'/',-1,1)+1
      )||'"  is uploaded.   <BR>');  
 else
 htp.p('  
  <FORM  enctype="multipart/form-data" action="!dd_lib.DocumentUploadMulti" method="POST">   
    <p>File:<INPUT type="file" id="my_file_element" name="pdatoteka"></p>   
    <p><INPUT type="submit" class=submit value="Submit" ></p>
  </FORM>
Files:
<!-- This is where the output will appear -->
<div id="files_list"></div>
<script>
	<!-- Create an instance of the multiSelector class, pass it the output target and the max number of files -->
	var multi_selector = new MultiSelector( document.getElementById( ''files_list'' ), 200 );
	<!-- Pass in the file element -->
	multi_selector.addElement( document.getElementById( ''my_file_element'' ) );
</script>
  <BR>');  
 end if;
 htp.p(' 
 </body>
</html>');
exception when others then
 htp.p('
<HTML>
 <HEAD>
   <META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">  
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="-1">  
   <TITLE>Message</TITLE>
 </HEAD> 
 <BODY bgcolor="#C0C0C0">');
 htp.p('   
   <table>   
     <tr><td><FONT COLOR="red" size="4">Error: </FONT></td>
         <td>'||replace(sqlerrm,'','<BR>')||'</td>
     </tr>
   </table>
   <BR>   
   <INPUT TYPE="button" VALUE="Back" class=submit onClick="javascript:history.go(-1)"> 
 </BODY>
</HTML>');
end;



procedure DocumentUpload (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr)
is
 pdatoteka Documents.name%type;
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
 pdatoteka := namedParam('pdatoteka',name_array,value_array);
 htp.p('
<html>
 <HEAD>
   <META HTTP-EQUIV="Content-Type" NAME="" CONTENT="text/html;CHARSET=WINDOWS-1250">  
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="-1">  
   <title>Upload</title> 
 </HEAD> 
 <body>  
  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFF99" summary="">  
   <tr><td><font size="5">Upload</font></TD></TR>  
  </TABLE>');  
 if pdatoteka is not null then
 htp.p('   
  <BR>   File "'||substr(pdatoteka, instr(pdatoteka,'/',-1,1)+1
      )||'"  is uploaded.   <BR>');  
 else
 htp.p('  
  <FORM  enctype="multipart/form-data" action="!dd_lib.DocumentUpload" method="POST">   
    <p>File:<INPUT type="file" name="pdatoteka"></p>   
    <p><INPUT type="submit" class=submit value="Submit" ></p>
  </FORM>
  <BR>');  
 end if;
 htp.p(' 
 </body>
</html>');
exception when others then
 htp.p('
<HTML>
 <HEAD>
   <META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">  
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="-1">  
   <TITLE>Message</TITLE>
 </HEAD> 
 <BODY bgcolor="#C0C0C0">');
 htp.p('   
   <table>   
     <tr><td><FONT COLOR="red" size="4">Error: </FONT></td>
         <td>'||replace(sqlerrm,'','<BR>')||'</td>
     </tr>
   </table>
   <BR>   
   <INPUT TYPE="button" VALUE="Back" class=submit onClick="javascript:history.go(-1)"> 
 </BODY>
</HTML>');
end;

procedure DocumentDownload is
 v_filename Documents.name%type;
 function getfilepath return varchar2 is
   script_name             varchar2(255) default owa_util.get_cgi_env( 'SCRIPT_NAME' );
   path_info               varchar2(255) default owa_util.get_cgi_env( 'PATH_INFO' );
   pos                     number;
   x varchar2(50) := 'docs'; --variable from PlsqlDocumentPath 
 begin
   script_name := script_name || path_info;
   pos := instr(script_name, x);
   script_name :=  substr(script_name, pos+length(x)+1, length(script_name)-pos-length(x));
   return script_name;
 end getfilepath;
begin
 v_filename := upper(getfilepath);
 select name into v_filename
 from Documents
 where UPPER(name) = v_filename;
 wpg_docload.download_file(v_filename);
end;

procedure Test is
begin
  htp.p('This is a test!');
end;

end dd_lib;
/
