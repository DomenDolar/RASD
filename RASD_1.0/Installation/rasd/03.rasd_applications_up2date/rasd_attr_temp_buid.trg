create or replace trigger RASD_ATTR_TEMP_BUID
  before insert or update or delete
  on RASD_ATTRIBUTES_TEMPLATE 
  for each row
declare
  -- local variables here
begin
 -- if :new.coreid = 10 or :old.coreid = 10 then
      Raise_Application_Error (-20000, 'Production version. Do not change. If you know what you are doing disable it, and afther change enable it!'); 
  --end if;
end RASD_ATTR_TEMP_BUID;
/

