create or replace function transformPLSQLOld(pformid  number,
                          pblockid varchar2,
                          pplsql   varchar2) return varchar2 is
    v_plsql varchar2(32000); --rasd_triggers.plsql%type;
    l       pls_integer;
    n       pls_integer;
  begin
    v_plsql := pplsql;
    if v_plsql is not null then
      for rp in (select length(p.blockid || p.fieldid) dolzina,
                        p.fieldid,
                        p.blockid,
                        p.blockid || p.fieldid imeid
                   from rasd_fields p
                  where p.formid = pformid
                    and p.blockid is not null
                  order by dolzina desc) loop

        l := 1;
        loop
          l := instr(upper(v_plsql), upper(rp.imeid), l, 1);
          exit when l = 0;
          select count(*)
            into n
            from rasd_fields
           where formid = pformid
             and blockid is not null
             and substr(upper(v_plsql), l) like
                 upper(blockid || fieldid) || '%'
             and blockid || fieldid <> rp.imeid
             and length(blockid || fieldid) > length(rp.imeid);
          if n > 0 then
            null;
          else
            if instr(v_plsql, '(', l) > 0 or instr(v_plsql, '.', l) > 0 then
              select count(*)
                into n
                from (select blockid, fieldid
                        from rasd_fields
                       where blockid = rp.blockid
                         and formid = pformid)
               where blockid = rp.blockid
                 and (upper(rp.imeid) =
                     upper(rtrim(substr(v_plsql,
                                        l,
                                        instr(v_plsql, '(', l) - l)))
                     or upper(rp.imeid) =
                     upper(rtrim(substr(v_plsql,
                                        l,
                                        instr(v_plsql, '.', l) - l)))
                      );
              if n = 0 then
                if rp.blockid = pblockid then
                  v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                             '(i__)' ||
                             substr(v_plsql, l + length(rp.imeid));
                else
                  v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                             '(1)' || substr(v_plsql, l + length(rp.imeid));
                end if;
              end if;
            else
              if rp.blockid = pblockid then
                v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                           '(i__)' || substr(v_plsql, l + length(rp.imeid));
              else
                v_plsql := substr(v_plsql, 1, l + length(rp.imeid) - 1) ||
                           '(1)' || substr(v_plsql, l + length(rp.imeid));
              end if;
            end if;
          end if;
          l := l + length(rp.imeid);
        end loop;
      end loop;
    end if;
    return v_plsql;
  end;
/

