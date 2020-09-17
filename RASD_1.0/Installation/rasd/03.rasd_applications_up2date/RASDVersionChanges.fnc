create or replace function RASDVersionChanges(d date default sysdate) return varchar2 is

  y varchar2(32000);

begin

  y := rasdc_library.RASDVersionChanges( d ); 
  
  return y;
end;
/

