create or replace trigger RASD_TRIGGER_TEMP_BUID
 before insert or update or delete 
  on RASD_TRIGGERS_TEMPLATE 
  for each row
declare
  -- local variables here
begin
      Raise_Application_Error (-20000, 'Production version. Do not change. If you know what you are doing disable it, and afther change enable it!'); 

end RASD_TRIGGER_TEMP_BUID;
/

