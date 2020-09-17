create or replace trigger RASD_TRIGG_CODE_TYPES_BUID
  before insert or update or delete
  on RASD_TRIGGERS_CODE_TYPES 
  for each row
declare
  -- local variables here
begin
      Raise_Application_Error (-20000, 'Production version. Do not change. If you know what you are doing disable it, and afther change enable it!'); 
end RASD_TRIGG_CODE_TYPES_BUID;
/

