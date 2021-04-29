--Steps:
-- Edited 3.1.2019
-- 1. Set serveroutput on and max size 99999999999999
-- 2. Run script
-- 3. Copy output to 02.rasd_app_db_data.sql file

declare 
  source_rasd_schema varchar2(1000) := 'RASDDEV';
  v_select_prompt varchar2(32000);
  v_delete_prompt varchar2(32000);
begin
dbms_output.put_line('set define off');
dbms_output.put_line('SET serveroutput ON');
dbms_output.put_line('spool 02.rasd_app_db_data.log');
dbms_output.put_line('/*');
dbms_output.put_line('// +----------------------------------------------------------------------+');
dbms_output.put_line('// | RASD - Rapid Application Service Development                         |');
dbms_output.put_line('// | Program: Export RASD DATA AND PACKAGES                               |');
dbms_output.put_line('// | Version: 1.0                                                         |');
dbms_output.put_line('// | Date: '||sysdate||'                                                         |');
dbms_output.put_line('// +----------------------------------------------------------------------+');
dbms_output.put_line('// | http://rasd.sourceforge.net                                          |');
dbms_output.put_line('// +----------------------------------------------------------------------+');
dbms_output.put_line('// |                                                                      |');
dbms_output.put_line('// +----------------------------------------------------------------------+');
dbms_output.put_line('*/');

dbms_output.put_line('prompt +------------------------------------------------------------------------+');
dbms_output.put_line('prompt | RASD - Rapid Application Service Development                           |');
dbms_output.put_line('prompt | Program: Export RASD DATA AND PACKAGES                                 |');
dbms_output.put_line('prompt | Version: 1.0                                                           |');
dbms_output.put_line('prompt | Date: '||sysdate||'                                                         |');
dbms_output.put_line('prompt +----------------------------------------------------------------------  +');
dbms_output.put_line('prompt | http://rasd.sourceforge.net                                            |');
dbms_output.put_line('prompt +------------------------------------------------------------------------+');
dbms_output.put_line('prompt + Updateing data with GEN DATA, DEMO and support RASD programs           +');
dbms_output.put_line('prompt + Watch out! If you changed RASD_CLIENT, RASDI_CLIENT or RASDI_TRNSLT    +');
dbms_output.put_line('prompt +           delete them from the script or store yours to recompile them +');
dbms_output.put_line('prompt + RASD_ATTRIBUTES_TEMPLATE  -> RASD GENERATOR SUPPORT                    +');
dbms_output.put_line('prompt + RASD_ELEMENTS_TEMPLATE    -> RASD GENERATOR SUPPORT                    +');
dbms_output.put_line('prompt + RASD_HINTS                -> RASD GENERATOR SUPPORT                    +');
dbms_output.put_line('prompt + RASD_TRIGGERS_CODE_TYPES  -> RASD GENERATOR SUPPORT                    +');
dbms_output.put_line('prompt + RASD_ENGINES              -> RASD GENERATOR SUPPORT                    +');
dbms_output.put_line('prompt + RASD_TRIGGERS_TEMPLATE    -> RASD GENERATOR SUPPORT - NEW in V.11      +');
dbms_output.put_line('prompt + RASD_HTML_TEMPLATE  -> RASD GENERATOR SUPPORT - NOT USED PLAN IN V.12  +');
dbms_output.put_line('prompt + RASD_FORMS_COMPILED       -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_ATTRIBUTES           -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_ATTRIBUTES_TEMPORARY -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_BLOCKS               -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_ELEMENTS             -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_ELEMENTS_TEMPORARY   -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_FIELDS               -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_FORMS                -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_LINK_PARAMS          -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_LINKS                -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_PAGES                -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_REFERENCES           -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_TRIGGERS_TMP         -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_VW_FIELDS            -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_FILES                -> RASD FORMS STORED  - CUSTOMIZED           +');
dbms_output.put_line('prompt + RASD_LOG                  -> NOT INCLUDED IN SCRIPT                    +');
dbms_output.put_line('prompt + RASD_PRIVS_LOB            -> NOT INCLUDED IN SCRIPT                    +');
dbms_output.put_line('prompt + RASD_TEXTS                -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_TRIGGERS             -> RASD FORMS STORED                         +');
dbms_output.put_line('prompt + RASD_TRANSLATES           -> RASD GENERATOR SUPPORT - CUSTOMIZED       +');
dbms_output.put_line('prompt + RASDC_% PACKAGES          -> RASD FORMS EDITING                        +');
dbms_output.put_line('prompt + RASD_% PACKAGE            -> RASD GENERATOR ENGINE                     +');
dbms_output.put_line('prompt + RASDI_CLIENT              -> RASD GENERATOR SUPORT - CUSTOMIZED        +');
dbms_output.put_line('prompt + RASDI_TRNSLT              -> RASD GENERATOR SUPORT - CUSTOMIZED        +');
dbms_output.put_line('prompt +------------------------------------------------------------------------+');

dbms_output.put_line(' prompt  '); 
dbms_output.put_line( 'prompt DROPING TRIGGERS, DISABLING FK, ...');
dbms_output.put_line( 'prompt drop trigger RASD_ATTR_TEMP_BUID');
dbms_output.put_line( 'drop trigger RASD_ATTR_TEMP_BUID;');
dbms_output.put_line( 'prompt drop trigger RASD_ELEM_TEMP_BUID');
dbms_output.put_line( 'drop trigger RASD_ELEM_TEMP_BUID;');

dbms_output.put_line( 'prompt drop trigger rasd_engine_buid');
dbms_output.put_line( 'drop trigger rasd_engine_buid;');

dbms_output.put_line( 'prompt drop trigger rasd_html_temp_buid');
dbms_output.put_line( 'drop trigger rasd_html_temp_buid;');

dbms_output.put_line( 'prompt drop trigger rasd_trigg_code_types_buid');
dbms_output.put_line( 'drop trigger rasd_trigg_code_types_buid;');

dbms_output.put_line( 'prompt drop trigger rasd_trigger_temp_buid');
dbms_output.put_line( 'drop trigger rasd_trigger_temp_buid;');

dbms_output.put_line(' prompt  ');  

dbms_output.put_line(' prompt INSERTING DATA... '); 
dbms_output.put_line('declare');
dbms_output.put_line('   v_rasd_translates boolean;');
dbms_output.put_line('   v_rasd_translatesPackage boolean;');
dbms_output.put_line('   v_rasd_IClientPackage boolean;');
dbms_output.put_line('   v_rasd_ClientPackage boolean;');
dbms_output.put_line('   v_RASD_CLIENT_out varchar2(10) := '''';');
dbms_output.put_line('   v_target_rasd_schema varchar2(100) := user;');
dbms_output.put_line('   i number;');
dbms_output.put_line('begin');

  declare
    v_colinto varchar2(32000);
    v_col     varchar2(32000);
  function getColumnList(p_table_name in varchar2) return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    for rc in (select *
                 from user_tab_columns a
                where table_name = p_table_name
                order by column_id) loop
      v_col := v_col || ',' || rc.column_name;
    end loop;
    return substr(v_col, 2);
  end;    

  function getColumnListValues(p_table_name in varchar2) return varchar2 is
    v_col varchar2(32000);
    v_formid varchar2(1000) := '''XXX''';
    v_xxx varchar2(1000) := '0';    
  begin
    v_col := '';
    for rc in (select *
                 from user_tab_columns a
                where table_name = p_table_name
                order by column_id) loop
      if rc.column_name = 'FORMID' then
        v_formid := ' (select a.form from rasd_forms a where a.formid = x.formid)';
        v_xxx := 'FORMID'; 
      end if;
             
      if rc.data_type = 'NUMBER' then          
         v_col := v_col ||  '||'',''||nvl(to_char('||rc.column_name||'),''to_number(null)'')';
      elsif rc.data_type = 'DATE' then 
         v_col := v_col || '||'', to_date(''''''||to_char('||rc.column_name||',''ddmmyyyy'')||'''''',''''ddmmyyyy'''')''';
      else
--         v_col := v_col || '||'',''''''||replace('|| rc.column_name||','''''''','''''''''''')||''''''''';   
         v_col := v_col || '||'',''''''||replace(replace(replace('|| rc.column_name||','''''''',''''''''''''), chr(10) , ''''''||
chr(10)||'''''' ), chr(13) , ''''''||
chr(13)||'''''')||''''''''';        
      end if;   
    end loop;
    
    return ''''||substr(v_col, 5)||'xxx, '||v_formid||' yyy, '||v_xxx||' zzz';
  end;   
  function getForms return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    for rc in (select *
                 from rasd_forms a
                order by formid) loop
      if rc.form = 'RASD_CLIENT' then
      v_col := v_col || ',''' || rc.form||'''||v_RASD_CLIENT_out';
      else            
      v_col := v_col || ',''' || rc.form||'''';
      end if;
    end loop;
    
    return substr(v_col, 2);
  end;   
  function getTranslatesCount return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    select count(*) into v_col
    from RASD_TRANSLATES;
    return v_col;
  end;   
  function getTranslatesPackageCount return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    select count(*) into v_col
    from all_source s
    where owner = source_rasd_schema
      and name = 'RASDI_TRNSLT';
    return v_col;
  end;   
  function getRasdIClientPackageCount return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
    select count(*) into v_col
    from all_source s
    where owner = source_rasd_schema
      and name = 'RASDI_CLIENT';
    return v_col;
  end;   
  function getRasdClientPackageCount return varchar2 is
    v_col varchar2(32000);
  begin
    v_col := '';
   select sum(length(t.plsql) + length(t.plsqlspec)) into v_col
    from rasd_forms f, rasd_triggers t
    where f.formid = t.formid
      and f.form = 'RASD_CLIENT';
    return v_col;
  end; 
     
  begin
/*    
// +-------------------------------------------------------------------------------------------------+
// |   CHECK USER ENVIORMENT ABOUT RASDI_CLIENT, RASD_CLIENT, RASDI_TRNSLT and RASD_TRANSLATES       |
// +-------------------------------------------------------------------------------------------------+   
*/ 
     dbms_output.put_line('--CHECK TRANSLATE CHANGES');    
     dbms_output.put_line('  select count(*) into i from RASD_TRANSLATES; if i <= '||getTranslatesCount||' 
  then v_rasd_translates := true; else v_rasd_translates := false; end if;');       
     dbms_output.put_line('  select count(*) into i from all_source s where owner = v_target_rasd_schema and name = ''RASDI_TRNSLT''; if i <= '||getTranslatesPackageCount||' 
  then v_rasd_translatesPackage := true; else v_rasd_translatesPackage := false; end if;');       
     
     dbms_output.put_line('--CHECK RASD_CLIENT CHANGES');    
     dbms_output.put_line('  select count(*) into i from all_source s where owner = v_target_rasd_schema and name = ''RASDI_CLIENT''; if i <= '||getRasdIClientPackageCount||' 
  then v_rasd_IClientPackage := true; else v_rasd_IClientPackage := false; end if;');       
     dbms_output.put_line('  select sum(length(t.plsql) + length(t.plsqlspec)) into i from rasd_forms f, rasd_triggers t where f.formid = t.formid and f.form = ''RASD_CLIENT''; if i <= '||getRasdClientPackageCount||' 
  then v_rasd_ClientPackage := true; else v_rasd_ClientPackage := false; v_RASD_CLIENT_out := ''''; end if;');    
  
  
     dbms_output.put_line('if v_rasd_translates = false then');   
     dbms_output.put_line('dbms_output.put_line(''Watch out!!! The numbers of rows in your table RASD_TRANSLATES is higher than in script RASD_TRANSLATES table. Import will be done. Check your data in package! '');');   
     dbms_output.put_line('end if;');   
     dbms_output.put_line('if v_rasd_translates = false then');   
     dbms_output.put_line('dbms_output.put_line(''Watch out!!! The numbers of rows in your RASD support data program RASD_CLIENT is higher than in this script. Import will be done. With no compile. Check your data in package! '');  ');   
     dbms_output.put_line('end if;');   
     dbms_output.put_line('if v_rasd_translates = false then');   
     dbms_output.put_line('dbms_output.put_line(''Watch out!!! The numbers of rows in your RASD support data program RASD_CLIENT is higher than in this script. Import RASD_CLIENT data manualy and build it for your application. '');  ');   
     dbms_output.put_line('end if;');   
     dbms_output.put_line('if v_rasd_translatesPackage = false then');   
     dbms_output.put_line('dbms_output.put_line(''Watch out!!! The program RASDI_TRNSLT in your schema is diferent than that in script!!! The program will be generated anyway. '');  ');   
     dbms_output.put_line('end if;');   
     dbms_output.put_line('if v_rasd_IClientPackage = false then');   
     dbms_output.put_line('dbms_output.put_line(''Watch out!!! The program RASDI_CLIENT in your schema is diferent than that in script!!! The program will be generated anyway. '');  ');   
     dbms_output.put_line('end if;  ');   
     dbms_output.put_line('dbms_output.put_line('''');  ');   

/*    
// +-------------------------------------------------------------------------------------------------+
// |   DELETE TABLES                                                                                 |
// |   RASD DEMO DATA: 'RASD_FORMS_COMPILED' , 'RASD_ATTRIBUTES','RASD_ATTRIBUTES_TEMPORARY','RASD_BLOCKS','RASD_ELEMENTS', 'RASD_ELEMENTS_TEMPORARY','RASD_FIELDS','RASD_FORMS','RASD_LINK_PARAMS','RASD_LINKS','RASD_PAGES','RASD_REFERENCES', 'RASD_TRIGGERS_TMP'                                                                                 |
// |               DATA of FORM RASD_CLIENT is CHECKED
// |   RASD GENERATOR DATA: RASD_ATTRIBUTES_TEMPLATE, RASD_ELEMENTS_TEMPLATE,  RASD_HINTS,  RASD_TRIGGERS_CODE_TYPES,  RASD_ENGINES                                                                              |
// |   RASD TRANSLATE - CHECKED : RASD_TRANSLATES                                                                                 |
// +-------------------------------------------------------------------------------------------------+   
*/     

     dbms_output.put_line('--DELETE TABLES');   
     dbms_output.put_line( 'dbms_output.put_line(''DELETING RASD tables data (just for sample and support RASD forms-programs)'');');
        
    -- DELETE RASD DEMO forms tables
    for rt in (select t.table_name from all_tables t 
               where owner = source_rasd_schema 
               and t.table_name in ( 'RASD_FORMS_COMPILED' , 'RASD_ATTRIBUTES','RASD_ATTRIBUTES_TEMPORARY','RASD_BLOCKS','RASD_ELEMENTS',
               'RASD_ELEMENTS_TEMPORARY','RASD_FIELDS','RASD_FORMS','RASD_LINK_PARAMS','RASD_LINKS','RASD_PAGES','RASD_REFERENCES',
               'RASD_TRIGGERS_TMP')
               order by 
                      decode(t.table_name , 'RASD_ENGINES', -5, 'RASD_FORMS' , -10 , 'RASD_FORMS_COMPILED', -15, 'RASD_BLOCKS', -20, 'RASD_FIELDS' , -30 , 'RASD_LINKS' , -40 , 'RASD_LINK_PARAMS', -50, 'RASD_TRIGGERS' , -60 ,
                             'RASD_PAGES' , -70 , 'RASD_REFERENCES' , -80, 'RASD_ELEMENTS' , -90 , 'RASD_ATTRIBUTES' , -100 , -200),  table_name
              ) loop

     dbms_output.put_line( 'delete from ' || rt.table_name || ' where FORMID  in (select formid from rasd_forms where form in ('||getForms||') );');   
     dbms_output.put_line( 'dbms_output.put_line(''    ' || rt.table_name || ' -> deleted rows:''||sql%rowcount);');
    end loop;
    -- DELETE RASD GEN tables
     dbms_output.put_line('
delete from RASD_ATTRIBUTES_TEMPLATE;
dbms_output.put_line(''    RASD_ATTRIBUTES_TEMPLATE -> deleted rows:''||sql%rowcount);
delete from RASD_ELEMENTS_TEMPLATE;
dbms_output.put_line(''    RASD_ELEMENTS_TEMPLATE -> deleted rows:''||sql%rowcount);
delete from RASD_HINTS;
dbms_output.put_line(''    RASD_HINTS -> deleted rows:''||sql%rowcount);
delete from RASD_TRIGGERS_CODE_TYPES;
dbms_output.put_line(''    RASD_TRIGGERS_CODE_TYPES -> deleted rows:''||sql%rowcount);
delete from RASD_ENGINES;
dbms_output.put_line(''    RASD_ENGINES -> deleted rows:''||sql%rowcount);
    ');
   -- Table where customer can do changes
     dbms_output.put_line('if v_rasd_translates then delete from RASD_TRANSLATES; dbms_output.put_line(''RASD_TRANSLATES -> deleted rows:''||sql%rowcount); end if;');
dbms_output.put_line('end;');
dbms_output.put_line('/');
     
/*    
// +-------------------------------------------------------------------------------------------------+
// |   INSERT TABLES                                                                                 |
// |   RASD DATA: 'RASD_FORMS_COMPILED' , 'RASD_ATTRIBUTES','RASD_ATTRIBUTES_TEMPORARY','RASD_BLOCKS','RASD_ELEMENTS', 'RASD_ELEMENTS_TEMPORARY','RASD_FIELDS','RASD_FORMS','RASD_LINK_PARAMS','RASD_LINKS','RASD_PAGES','RASD_REFERENCES', 'RASD_TRIGGERS_TMP'                                                                                 |
// |               DATA of FORM RASD_CLIENT is CHECKED
// |   RASD GENERATOR DATA: RASD_ATTRIBUTES_TEMPLATE, RASD_ELEMENTS_TEMPLATE,  RASD_HINTS,  RASD_TRIGGERS_CODE_TYPES,  RASD_ENGINES                                                                              |
// |   RASD TRANSLATE - CHECKED : RASD_TRANSLATES                                                                                 |
// +-------------------------------------------------------------------------------------------------+   
*/           
--     dbms_output.put_line('dbms_output.put_line('''');  '); 
     dbms_output.put_line('--INSERT TABLES');   
--     dbms_output.put_line( 'dbms_output.put_line(''INSERTING new data for deleted forms-programs'');');
     dbms_output.put_line( 'prompt INSERTING new data for deleted forms-programs' );
    --INSERT
    for rt in (select t.table_name, c.column_name from all_tables t , all_tab_cols c
               where t.owner = source_rasd_schema 
               and t.owner = c.owner(+)
               and t.table_name = c.table_name(+)
               and c.column_name(+) = 'FORMID' 
               --and t.table_name in ('RASD_LINKS', 'RASD_FORMS')
               and t.table_name in ( 'RASD_FORMS_COMPILED' , 'RASD_ATTRIBUTES','RASD_ATTRIBUTES_TEMPLATE','RASD_ATTRIBUTES_TEMPORARY','RASD_BLOCKS','RASD_ELEMENTS','RASD_ELEMENTS_TEMPLATE',
               'RASD_ELEMENTS_TEMPORARY','RASD_ENGINES','RASD_FIELDS','RASD_FORMS','RASD_HINTS','RASD_LINK_PARAMS','RASD_LINKS','RASD_PAGES','RASD_REFERENCES',
               'RASD_TRANSLATES','RASD_TRIGGERS_CODE_TYPES','RASD_TRIGGERS_TMP')
               order by 
                      decode(t.table_name , 'RASD_ENGINES', 5, 'RASD_FORMS' , 10 , 'RASD_FORMS_COMPILED', 15, 'RASD_BLOCKS', 20, 'RASD_FIELDS' , 30 , 'RASD_LINKS' , 40 , 'RASD_LINK_PARAMS', 50, 'RASD_TRIGGERS' , 60 ,
                             'RASD_PAGES' , 70 , 'RASD_REFERENCES' , 80, 'RASD_ELEMENTS' , 90 , 'RASD_ATTRIBUTES' , 100 ,'RASD_TRIGGERS_TEMPLATE',9,'RASD_ATTRIBUTES_TEMPLATE',6,'RASD_ELEMENTS_TEMPLATE',7, 'RASD_TRIGGERS_CODE_TYPES',8, 200),  table_name
              ) loop

      v_colinto := getcolumnlist(rt.table_name);

--      if rt.table_name = 'RASD_TRANSLATES' then
--      dbms_output.put_line( 'if v_rasd_translates then ');
--      end if;
--     dbms_output.put_line( 'dbms_output.put_line(''    inserting rows for ' || rt.table_name || ''');');
     dbms_output.put_line( 'prompt   inserting rows for ' || rt.table_name );
      execute immediate '
      declare
      
      begin
      for rx in (select '||getColumnListValues(rt.table_name)||' from '||rt.table_name||' x ) loop       
--     if rx.yyy = ''RASD_CLIENT'' then  
--     dbms_output.put_line(''   if v_rasd_ClientPackage then'');
--     end if;
     dbms_output.put_line( '' insert into ' || rt.table_name || ' (' || v_colinto || ') values '');
     dbms_output.put_line( ''( '' || rx.xxx || '' );  '');
--     if rx.yyy = ''RASD_CLIENT'' then     
--     dbms_output.put_line(''    end if; '');
--     end if;     
      end loop;
      end;';
--      if rt.table_name = 'RASD_TRANSLATES' then
--     dbms_output.put_line( 'end if;');
--      end if;
      
      
      if rt.column_name = 'FORMID' then
      v_select_prompt := v_select_prompt || 'prompt '||rt.table_name||' 
select count(*) from '||rt.table_name||' where formid in (select formid from rasd_forms where form in ('||replace(getForms,'||v_RASD_CLIENT_out','')||'));
';
      else
      v_select_prompt := v_select_prompt || 'prompt '||rt.table_name||' 
select count(*) from '||rt.table_name||' ;
';        
      end if; 
    end loop;
  end;

--dbms_output.put_line('end;');
--dbms_output.put_line('/');


dbms_output.put_line('begin');  
/*    
// +-------------------------------------------------------------------------------------------------+
// |   INSERT LARGE TABLES                                                                           |
// |   RASD DATA: 'rasd_triggers' , 'rasd_files','rasd_texts' , 'RASD_TRIGGERS_TEMPLATE'                                       |
// |               DATA of FORM RASD_CLIENT is CHECKED in RASD_TRIGGERS   ?????????????????????????????????????
// +-------------------------------------------------------------------------------------------------+   
*/  
     dbms_output.put_line('--INSERT LARGE TABLES');  
     
     --triggers
     dbms_output.put_line( 'dbms_output.put_line(''    inserting rows for rasd_triggers'');');
declare
  lob_in clob;
  i integer := 0;
  buffer_size integer := 10000;
  v_rows number := 100;
  v_clob clob;
begin
dbms_output.put_line('declare');  
dbms_output.put_line(' rid rowid;');  
dbms_output.put_line('begin');  

for r in ( 
  select formid, blockid, triggerid, replace(replace(replace(plsql,'''',''''''), chr(10) ,'''|| chr(10) 
  ||'''), chr(13) ,'''|| chr(13) 
  ||''') plsql, replace(replace(replace(plsqlspec,'''',''''''), chr(10) ,'''|| chr(10) 
  ||'''), chr(13) ,'''|| chr(13) 
  ||''')plsqlspec, source, hiddenyn, rlobid, rform, rblockid 
  from rasd_triggers
  order by length(plsql)  
  )
loop
dbms_output.put_line('delete from rasd_triggers where formid = '||r.formid||' and nvl(blockid,''_NULL'') = '''||nvl(r.blockid,'_NULL')||''' and triggerid='''||r.triggerid||''';');  
dbms_output.put('insert into rasd_triggers (formid, blockid, triggerid,   source, hiddenyn, rlobid, rform, rblockid)');  
dbms_output.put_line(' values ('||r.formid||', '''||r.blockid||''', '''||r.triggerid||''', '''||r.source||''', '''||r.hiddenyn||''','''||r.rlobid||''' , '''||r.rform||''' , '''||r.rblockid||''' )');
dbms_output.put_line('returning rowid into rid;'); 


v_clob := '||'''||r.plsql||'';
while instr(v_clob,'chr(10)',1,v_rows) > 0 loop
dbms_output.put_line('update  rasd_triggers set  plsql = plsql '||substr(v_clob,1, instr(v_clob,'chr(10)',1,v_rows) + 7 )||''); 
dbms_output.put_line('where rowid = rid;'); 
v_clob := substr(v_clob, instr(v_clob,'chr(10)',1,v_rows) + 8 );
end loop;
dbms_output.put_line('update  rasd_triggers set  plsql = plsql '||v_clob||''''); 
dbms_output.put_line('where rowid = rid;'); 

v_clob := '||'''||r.plsqlspec||'';
while instr(v_clob,'chr(10)',1,v_rows) > 0 loop
dbms_output.put_line('update  rasd_triggers set  plsqlspec = plsqlspec '||substr(v_clob,1, instr(v_clob,'chr(10)',1,v_rows) + 7 )||''); 
dbms_output.put_line('where rowid = rid;'); 
v_clob := substr(v_clob, instr(v_clob,'chr(10)',1,v_rows) + 8 );
end loop;
dbms_output.put_line('update  rasd_triggers set  plsqlspec = plsqlspec '||v_clob||''''); 
dbms_output.put_line('where rowid = rid;'); 

--dbms_output.put_line('commit;'); 
end loop;
      v_select_prompt := v_select_prompt || 'prompt rasd_triggers 
select count(*) from rasd_triggers ;
'; 
dbms_output.put_line('end;');  
--dbms_output.put_line('/');  
end;
  -- FILES
     dbms_output.put_line( 'dbms_output.put_line(''    inserting rows for rasd_files'');');
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
  from rasd_files
  where dbms_lob.getlength(blob_content) > 0
    and name not like '%.zip'
  order by nvl(dbms_lob.getlength(blob_content),0)
  )
loop
dbms_output.put_line('delete from rasd_files where name = '''||r.name||''';');  
dbms_output.put('insert into rasd_files (name, mime_type, doc_size, dad_charset, last_updated, content_type, blob_content)');  
dbms_output.put_line(' values ('''||r.name||''', '''||r.mime_type||''', '||r.doc_size||', '''||r.dad_charset||''', to_date('''||to_char(r.last_updated,'ddmmyyyyhh24miss')||''',''ddmmyyyyhh24miss''), '''||r.content_type||''', empty_blob());');
dbms_output.put_line('declare');
dbms_output.put_line('  lob_out blob;');
dbms_output.put_line('begin');
dbms_output.put_line('  select blob_content into lob_out');
dbms_output.put_line('  from rasd_files');
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
--dbms_output.put_line('/');
--dbms_output.put_line('commit;'); 

end loop;
      v_select_prompt := v_select_prompt || 'prompt rasd_files 
select count(*) from rasd_files ;
'; 
end;
-- texts
     dbms_output.put_line( 'dbms_output.put_line(''    inserting rows for rasd_texts'');');
declare
  lob_in clob;
  i integer := 0;
  buffer_size integer := 10000;
begin
for r in ( 
  select textid, text from rasd_texts
  order by length(text)
  )
loop
dbms_output.put_line('delete from rasd_texts where textid = '||r.textid||' ;');  
dbms_output.put('insert into rasd_texts (textid, text)');  
dbms_output.put_line(' values ('||r.textid||', '''||r.text||''' );');
--dbms_output.put_line('commit;'); 
end loop;
      v_select_prompt := v_select_prompt || 'prompt rasd_texts 
select count(*) from rasd_texts ;
'; 
end;
--rasd_triggers_template
     dbms_output.put_line( 'dbms_output.put_line(''    inserting rows for rasd_triggers_template'');');
declare
  lob_in clob;
  i integer := 0;
  buffer_size integer := 10000;
  v_rows number := 100;
  v_clob clob;
begin
dbms_output.put_line('declare');  
dbms_output.put_line(' rid rowid;');  
dbms_output.put_line('begin');  

for r in ( 
  select lobid, triggerid, 
  replace(replace(replace(preplsql,'''',''''''), chr(10) ,'''|| chr(10) 
  ||'''), chr(13) ,'''|| chr(13) 
  ||''') preplsql, 
  replace(replace(replace(onplsql,'''',''''''), chr(10) ,'''|| chr(10) 
  ||'''), chr(13) ,'''|| chr(13) 
  ||''') onplsql, 
  replace(replace(replace(postplsql,'''',''''''), chr(10) ,'''|| chr(10) 
  ||'''), chr(13) ,'''|| chr(13) 
  ||''') postplsql 
  from rasd_triggers_template x
  order by x.lobid, x.triggerid 
  )
loop
dbms_output.put_line('delete from rasd_triggers_template where nvl(lobid,''-'')||triggerid = '''||nvl(r.lobid,'-')||r.triggerid||''';');  
dbms_output.put('insert into rasd_triggers_template rasd_files (lobid, triggerid)');  
dbms_output.put_line(' values ('''||r.lobid||''', '''||r.triggerid||''' )');
dbms_output.put_line('returning rowid into rid;'); 


v_clob := '||'''||r.preplsql||'';
while instr(v_clob,'chr(10)',1,v_rows) > 0 loop
dbms_output.put_line('update  rasd_triggers_template set  preplsql = preplsql '||substr(v_clob,1, instr(v_clob,'chr(10)',1,v_rows) + 7 )||''); 
dbms_output.put_line('where rowid = rid;'); 
v_clob := substr(v_clob, instr(v_clob,'chr(10)',1,v_rows) + 8 );
end loop;
dbms_output.put_line('update  rasd_triggers_template set  preplsql = preplsql '||v_clob||''''); 
dbms_output.put_line('where rowid = rid;'); 

v_clob := '||'''||r.onplsql||'';
while instr(v_clob,'chr(10)',1,v_rows) > 0 loop
dbms_output.put_line('update  rasd_triggers_template set  onplsql = onplsql '||substr(v_clob,1, instr(v_clob,'chr(10)',1,v_rows) + 7 )||''); 
dbms_output.put_line('where rowid = rid;'); 
v_clob := substr(v_clob, instr(v_clob,'chr(10)',1,v_rows) + 8 );
end loop;
dbms_output.put_line('update  rasd_triggers_template set  onplsql = onplsql '||v_clob||''''); 
dbms_output.put_line('where rowid = rid;'); 

v_clob := '||'''||r.postplsql||'';
while instr(v_clob,'chr(10)',1,v_rows) > 0 loop
dbms_output.put_line('update  rasd_triggers_template set  postplsql = postplsql '||substr(v_clob,1, instr(v_clob,'chr(10)',1,v_rows) + 7 )||''); 
dbms_output.put_line('where rowid = rid;'); 
v_clob := substr(v_clob, instr(v_clob,'chr(10)',1,v_rows) + 8 );
end loop;
dbms_output.put_line('update  rasd_triggers_template set  postplsql = postplsql '||v_clob||''''); 
dbms_output.put_line('where rowid = rid;'); 

--dbms_output.put_line('commit;'); 
end loop;
      v_select_prompt := v_select_prompt || 'prompt rasd_triggers_template 
select count(*) from rasd_triggers_template ;
'; 
dbms_output.put_line('end;');  
--dbms_output.put_line('/');  
end;
--
  
dbms_output.put_line('commit;');
dbms_output.put_line('end;');
dbms_output.put_line('/');
dbms_output.put_line(v_select_prompt);



/*    
// +-------------------------------------------------------------------------------------------------+
// |   CREATE RASD VIEW                                                                              |
Instead of:
   03.rasd_applications files
// +-------------------------------------------------------------------------------------------------+   
*/  
-- CREATE VIEWS
     dbms_output.put_line( 'prompt CREATEING VIEWS');
  
     dbms_output.put_line('--CREATE VIEWS');  
for r in (select * from all_views where owner = source_rasd_schema and view_name like 'RASD%') loop
     dbms_output.put_line( 'prompt    CREATE VIEW '||r.view_name||'');
dbms_output.put_line('create or replace view '||r.view_name||' as ');
dbms_output.put_line(r.text_vc);
dbms_output.put_line(';
/');
end loop;
/*    
// +-------------------------------------------------------------------------------------------------+
// |   CREATE RASD GEN PROGRAMS                                                                      |
// |   CHECK FOR RASDI_CLIENT, RASD_CLIENT, RASDI_TRNSLT                                             |
Instead of:
   03.rasd_applications files
// +-------------------------------------------------------------------------------------------------+   
*/  

-- CREATE RASD APPLICATION
     dbms_output.put_line( 'prompt CREATEING RASD PROGRAMS');
     dbms_output.put_line('--CREATE APPLICATIONS');  
for r in (
select *
from all_source p where p.owner  = source_rasd_schema and name in (
'RASDC_LIBRARY',
'RASDC_PAGES',
'RASDC_STATS',
'RASDVERSIONCHANGES',
'RASD_ENGINE10',
'RASD_ENGINE11',
'RASDC_TEST',
'RASDI_TRNSLT',
'RASD_ELEM_TEMP_BUID',
'RASD_ATTR_TEMP_BUID',
'RASD_ENGINE_BUID',
'RASD_HTML_TEMP_BUID',
'RASD_TRIGG_CODE_TYPES_BUID',
'RASD_TRIGGER_TEMP_BUID',
'RASDC_ERRORS',
'RASDC_FORMS',
'RASDC_SHARE',
'RASD_ENGINEHTML10',
'RASD_ENGINEHTML11',
'RASDC_CSSJS',
'RASDC_VERSIONS',
'RASDC_FIELDSONBLOCK',
'RASDC_REFERENCES',
'RASDC_SECURITY',
'RASDC_HINTS',
'RASDC_FILES',
'RASDC_HTML',
'RASDC_SQL',
'RASDC_SQLCLIENT',
'RASDC_TRIGGERS',
'RASDI_CLIENT',
'RASDC_ATTRIBUTES',
'RASDC_BLOCKSONFORM',
'RASDC_LINKS',
'RASDC_UPLOAD',
'RASDC_EXECUTION'
)
--and 1=2
               order by 
                      decode(name , 'RASDI_TRNSLT', 5, 'RASDI_CLIENT' , 10 , 'RASDC_SECURITY', 15, 'RASD_ENGINE10',20,'RASD_ENGINEHTML10',30, 'RASD_ENGINE11',32,'RASD_ENGINEHTML11',33, 200),  name, p.type, p.line
) loop
    
if r.line = 1 then dbms_output.put_line('/'); 
dbms_output.put_line( 'prompt   CREATE '||r.text||' ');
dbms_output.put(' create or replace '); dbms_output.put_line(substr(r.text,1,length(r.text)-1)); 
else
  dbms_output.put_line(substr(r.text,1,length(r.text)-1)); 
end if;
end loop;
dbms_output.put_line('/');
-- RECOMPILE APPLICATION
dbms_output.put_line('prompt + Import finished -------------------------------------------------------+');
dbms_output.put_line('spool off');
end;
