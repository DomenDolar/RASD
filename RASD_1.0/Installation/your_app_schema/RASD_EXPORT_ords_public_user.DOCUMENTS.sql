/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
// | Program: Export DOCUMENT table for Insert's.                                           |
// +----------------------------------------------------------------------+
// | http://rasd.sourceforge.net                                          |
// +----------------------------------------------------------------------+
// | Basic source from: http://stackoverflow.com/questions/13531576/oracle-export-a-table-with-blobs-to-an-sql-file-that-can-be-imported-again.                       |
// +----------------------------------------------------------------------+
*/ 
--Steps:
-- 1. Set serveroutput on and max size 99999999999999
-- 2. Run script
-- 3. Copy output to new sql file
-- 4. Use and run script on any other database...
declare
  lob_in blob;
  i integer := 0;
  lob_size integer;
  buffer_size integer := 1200;
  buffer raw(32767);
begin
for r in ( 
  select blob_content lob_in, dbms_lob.getlength(blob_content) lob_size, 
         name, mime_type, doc_size, dad_charset, last_updated, content_type
  from documents
  where dbms_lob.getlength(blob_content) > 0
    and name not like '%.zip'
  order by nvl(dbms_lob.getlength(blob_content),0)
  )
loop
dbms_output.put_line('delete from ords_public_user.documents where name = '''||r.name||''';');  
dbms_output.put('insert into ords_public_user.documents (name, mime_type, doc_size, dad_charset, last_updated, content_type, blob_content)');  
dbms_output.put_line(' values ('''||r.name||''', '''||r.mime_type||''', '||r.doc_size||', '''||r.dad_charset||''', to_date('''||to_char(r.last_updated,'ddmmyyyyhh24miss')||''',''ddmmyyyyhh24miss''), '''||r.content_type||''', empty_blob());');
dbms_output.put_line('declare');
dbms_output.put_line('  lob_out blob;');
dbms_output.put_line('begin');
dbms_output.put_line('  select blob_content into lob_out');
dbms_output.put_line('  from ords_public_user.documents');
dbms_output.put_line('  where name = '''||r.name||'''');
dbms_output.put_line('  for update;');    
  for i in 0 .. (r.lob_size / buffer_size) loop
    buffer := dbms_lob.substr(r.lob_in, buffer_size, i * buffer_size + 1);
    if length(buffer) > 0 then
    dbms_output.put('dbms_lob.append(lob_out, hextoraw(''');
    dbms_output.put(rawtohex(buffer));
    dbms_output.put_line('''));');
    end if;
  end loop;
dbms_output.put_line('end;');
dbms_output.put_line('/');
dbms_output.put_line('commit;'); 

end loop;

end;

