create or replace trigger RASD_ENGINE_BUID
  before insert or update or delete
  on RASD_ENGINES 
   for each row
declare
  -- local variables here
begin
      Raise_Application_Error (-20000, 'Production version. Do not change. If you know what you are doing disable it, and afther change enable it!'); 
end RASD_ENGINE_BUID;
/

