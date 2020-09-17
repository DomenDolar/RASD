create or replace trigger RASD_ELEM_TEMP_BUID
  before insert or update or delete
  on RASD_ELEMENTS_TEMPLATE 
  for each row
declare
  -- local variables here
begin
  --if :new.coreid = 10 or :old.coreid = 10 then
      Raise_Application_Error (-20000, 'Production version. Do not change. If you know what you are doing disable it, and afther change enable it!'); 
  --end if;
end RASD_ELEM_TEMP_BUID;
/

