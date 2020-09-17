create or replace function transformPLSQL(pformid  number,
                          pblockid varchar2,
                          pplsql   varchar2) return varchar2 is
    v_plsql varchar2(32000); --rasd_triggers.plsql%type;
    l       pls_integer;
    n       pls_integer;
    type tsez is table of varchar2(32000) index by binary_integer;
    ix number := 1;
    v_z number;
    v_k number;
    vsez tsez;
    v_pr1 number;
    
  function replaceUpper(p_value clob, p_sstr varchar2 , pnstr varchar2) return clob is
     v_value clob :=  p_value;
     l number;
  begin
   l := 1;
   while instr(upper(v_value) , upper(p_sstr)) > 0 loop
     l := instr(upper(v_value), upper(p_sstr), l, 1);
     v_value := substr(v_value, 1, l - 1) || pnstr || substr(v_value, l + length(p_sstr)); 
   end loop;
   return v_value;
  end;

  begin
      
    v_plsql := pplsql;
    
    -- Trim string values
    v_plsql := replace(v_plsql , '''''' , '##0RASD0##');
    
    while instr(v_plsql , '''') > 0 and ix < 10000000 loop
       v_z := instr(v_plsql, '''');
       v_k := instr(v_plsql, '''', v_z + 1 );
       
       if v_k > 0 then 
           vsez(ix) := substr(v_plsql , v_z , v_k-v_z+1 );
           v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');         
       else
           vsez(ix) := substr(v_plsql , v_z );
           v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
       end if;
       ix := ix+1;
    end loop;  
    --   
  
    if v_plsql is not null then
      for rp in (select length(p.blockid || p.fieldid) dolzina,
                        p.fieldid,
                        p.blockid,
                        upper(p.blockid || p.fieldid) imeid
                   from rasd_fields p
                  where p.formid = pformid
                    and p.blockid is not null
                  order by dolzina desc) loop
      
              if rp.blockid = pblockid then
                  vsez(ix) := rp.imeid||'.';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'.' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'(' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(i__)';
                  v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
                  v_plsql := replaceUpper(v_plsql, rp.imeid, '##RASD'||ix||'##');                  
                  ix := ix + 1;
              else
                  vsez(ix) := rp.imeid||'.';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'.' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(';
                  v_plsql := replaceUpper(v_plsql, rp.imeid||'(' , '##RASD'||ix||'##');                  
                  ix := ix + 1;
                  vsez(ix) := rp.imeid||'(1)';
                  v_plsql := replaceUpper(v_plsql, vsez(ix), '##RASD'||ix||'##');                  
                  v_plsql := replaceUpper(v_plsql, rp.imeid, '##RASD'||ix||'##');                  
                  ix := ix + 1;
              end if;
      end loop;
    end if;
    
    while instr(v_plsql,'##RASD') > 0 loop
      for ix in 1..vsez.count loop
        v_plsql := replace(v_plsql, '##RASD'||ix||'##' , vsez(ix));    
      end loop;    
    end loop;

    v_plsql := replace(v_plsql , '##0RASD0##' , '''''' );

    
    return v_plsql;

  end;
/

