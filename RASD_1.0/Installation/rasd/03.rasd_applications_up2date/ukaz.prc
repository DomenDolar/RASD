create or replace procedure ukaz (
  p_formid RASD_ELEMENTS.formid%type,
  p_elementid RASD_ELEMENTS.elementid%type,
  p_ukaz in varchar2
) is
  c_engineid varchar2(30) := '20';
  v_akcija varchar2(1);
  v_ukaz varchar2(100);
  v_par1 varchar2(100);
  v_par2 varchar2(100);
  v_par3 varchar2(100);
  v_par4 varchar2(100);
  v_par5 varchar2(100);
  e1 RASD_ELEMENTS%rowtype;
  e2 RASD_ELEMENTS%rowtype;
  v_elementid number;
  p_orderby number;
  p_pelementid number;
  r_lobid varchar2(100);
  r_form   varchar2(100);
  r_id      varchar2(100);
  r_formid number;
  r_elementid number;
  n pls_integer;
  i pls_integer;

  function new_elementid (
    p_formid RASD_ELEMENTS.formid%type
  ) return pls_integer is
    v_formid pls_integer;
  begin
    select nvl(max(elementid),0)+1 into v_formid from RASD_ELEMENTS
    where formid = p_formid;
    return v_formid;
  end;

  function get_param(p_ukaz in out varchar2) return varchar2 is
    i     pls_integer;
    v_par varchar2(100);
  begin
    if p_ukaz is null then return(null); end if;
    i := instr(p_ukaz,' ');
    if i = 0 then
      v_par  := p_ukaz;
      p_ukaz := null;
    else
      v_par  := substr(p_ukaz,1,i-1);
      p_ukaz := substr(p_ukaz,i+1);
    end if;
    return(v_par);
  end;

begin
  if p_ukaz is null then return; end if;
  v_akcija := upper(substr(p_ukaz,1,1));
  v_ukaz := trim(substr(p_ukaz,2));
  v_par1 := get_param(v_ukaz);
  v_par2 := get_param(v_ukaz);
  v_par3 := get_param(v_ukaz);
  v_par4 := get_param(v_ukaz);
  v_par5 := get_param(v_ukaz);

  select a.* into e1 from RASD_ELEMENTS a
  where a.formid = p_formid
    and a.elementid = p_elementid;
  if instr('mMcC', v_akcija) > 0 then
    p_pelementid := nvl(to_number(v_par1), e1.pelementid);
    p_orderby := nvl(to_number(v_par2)-0.5,0.5);
  elsif instr('aArR', v_akcija) > 0 then
    p_pelementid := p_elementid;
    p_orderby := 0.5;
    begin
      select upper(lobid) into r_lobid from RASD_FORMS
      where formid = p_formid;
    exception
      when no_data_found then
        raise_application_error('-20000','form '||p_formid||' ni v tabeli RASD_FORMS');
    end;
    r_form := upper(v_par1);
    r_id := upper(v_par2);
  end if;

  --mM
 if v_akcija in ('m','M') then
  declare
  begin
    update RASD_ELEMENTS set
      pelementid = p_pelementid,
      orderby = p_orderby
    where formid = p_formid and elementid = p_elementid;
    if v_akcija = 'm' then
      update RASD_ELEMENTS set pelementid = e1.pelementid
      where formid = p_formid and pelementid = p_elementid;
    end if;
  end;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = p_pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = e1.pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
  --cC
 elsif v_akcija in ('c','C') then
  declare
    procedure cC(
      pp_formid RASD_ELEMENTS.formid%type,
      pp_elementid RASD_ELEMENTS.elementid%type,
      pp_pelementid RASD_ELEMENTS.pelementid%type
    ) is
      v_elementid pls_integer;
    begin
      for r in (select elementid from RASD_ELEMENTS
                where formid = pp_formid and pelementid = pp_elementid)
      loop
        v_elementid := new_elementid(p_formid);
        insert into RASD_ELEMENTS
          (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
          select formid, v_elementid, pp_pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid
          from RASD_ELEMENTS
          where formid = pp_formid and elementid = r.elementid;
        insert into RASD_ATTRIBUTES
          (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
          select formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql
          from RASD_ATTRIBUTES
          where formid = pp_formid and elementid = r.elementid;
        cC(pp_formid, r.elementid, v_elementid);
      end loop;
    end;
  begin
    select count(*) into n from RASD_ELEMENTS
    where elementid = p_pelementid
    connect by formid = prior formid
           and pelementid = prior elementid
    start with formid = p_formid
           and elementid = p_elementid;
    if v_akcija = 'C' and n > 0 then
      raise_application_error('-20000','Kopiranje strukture na podrejene elemente ni dovoljeno!');
    end if;
    v_elementid := new_elementid(p_formid);
    insert into RASD_ELEMENTS
      (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
      select formid, v_elementid, p_pelementid, p_orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid
      from RASD_ELEMENTS
      where formid = p_formid and elementid = p_elementid;
    insert into RASD_ATTRIBUTES
      (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
      select formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql
      from RASD_ATTRIBUTES
      where formid = p_formid and elementid = p_elementid;
    if v_akcija = 'C' then
      cC(p_formid, p_elementid, v_elementid);
    end if;
  end;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = p_pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
  --dD
 elsif v_akcija in ('d','D') then
  declare
    procedure dD(
      pp_formid RASD_ELEMENTS.formid%type,
      pp_elementid RASD_ELEMENTS.elementid%type
    ) is
    begin
      for r in (select elementid from RASD_ELEMENTS
                where formid = pp_formid and pelementid = pp_elementid)
      loop
        dD(pp_formid, r.elementid);
        delete RASD_ATTRIBUTES where formid = pp_formid and elementid = r.elementid;
        delete RASD_ELEMENTS where formid = pp_formid and elementid = r.elementid;
      end loop;
    end;
  begin
    if v_akcija = 'D' then
      dD(p_formid, p_elementid);
    end if;
    delete RASD_ATTRIBUTES where formid = p_formid and elementid = p_elementid;
    delete RASD_ELEMENTS where formid = p_formid and elementid = p_elementid;
    if v_akcija = 'd' then
      update RASD_ELEMENTS set pelementid = e1.pelementid
      where formid = p_formid and pelementid = p_elementid;
    end if;
  end;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = e1.pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i
    where rowid = r.rowid;
    i := i+1;
  end loop;
  --iI
/*
 elsif v_akcija in ('i','I') then
    begin
      select engineid into v_engineid from RASD_FORMS_COMPILED
      where formid = p_formid
        and rownum = 1;
    exception
      when no_data_found then
        v_engineid = c_engineid;
    end;
    v_elementid := new_elementid(p_formid);
    insert into RASD_ELEMENTS
      (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
    values
      (p_formid, v_elementid, p_pelementid, p_orderby, p_element, p_type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid);
      where formid = p_formid and elementid = p_elementid;
    insert into RASD_ATTRIBUTES
      (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
      select formid, v_elementid, orderby, attribute, type, text, name, value, null, null, null, source, hiddenyn, valueid, textid, null
      from gen_attributei
      where formid = p_formid and elementid = p_elementid;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = p_pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
*/
  --uU
  --rR
 elsif v_akcija in ('r','R') then
  declare
    procedure aA(
      rr_formid RASD_ELEMENTS.formid%type,
      rr_elementid RASD_ELEMENTS.elementid%type,
      pp_pelementid RASD_ELEMENTS.pelementid%type
    ) is
      v_elementid pls_integer;
    begin
      for r in (select elementid from RASD_ELEMENTS
                where formid = rr_formid and pelementid = rr_elementid)
      loop
        v_elementid := new_elementid(p_formid);
        update RASD_ELEMENTS set id = elementid
        where formid = rr_formid and elementid = r.elementid
          and id is null;
        insert into RASD_ELEMENTS
          (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
          select p_formid, v_elementid, pp_pelementid, orderby, element, type, id, nameid, endtagelementid, 'R', hiddenyn, r_lobid, r_form, id
          from RASD_ELEMENTS
          where formid = rr_formid and elementid = r.elementid;
        insert into RASD_ATTRIBUTES
          (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
          select p_formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, 'R', hiddenyn, valueid, textid, textplsql
          from RASD_ATTRIBUTES
          where formid = rr_formid and elementid = r.elementid;
        aA(rr_formid, r.elementid, v_elementid);
      end loop;
    end;
  begin
    v_elementid := new_elementid(p_formid);
    begin
      select formid into r_formid from RASD_FORMS a
      where a.lobid = r_lobid
        and a.form = r_form
        and a.referenceyn = 'Y';
    exception
      when no_data_found then
        raise_application_error('-20000','Referen?ne forme '||r_lobid||'.'||r_form||' ni v tabeli RASD_FORMS');
    end;
    begin
      select elementid into r_elementid from RASD_ELEMENTS a
      where a.formid = r_formid
        and a.id = r_id;
    exception
      when no_data_found then
        raise_application_error('-20000','Referen?nega objekta '||r_lobid||'.'||r_form||'.'||r_id||' ni v tabeli RASD_ELEMENTS');
      when too_many_rows then
        raise_application_error('-20000','Ve? enekih referen?nih objektov '||r_lobid||'.'||r_form||'.'||r_id||' .');
    end;
   /*
    if v_akcija = 'r' then
      update RASD_ELEMENTS set
     */



    update RASD_ELEMENTS set id = elementid
    where formid = r_formid and elementid = r_elementid
      and id is null;
    insert into RASD_ELEMENTS
      (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
      select p_formid, v_elementid, p_elementid, 0.5, element, type, id, nameid, endtagelementid, 'R', hiddenyn, r_lobid, r_form, id
      from RASD_ELEMENTS
      where formid = r_formid and elementid = r_elementid;
    insert into RASD_ATTRIBUTES
      (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
      select p_formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, 'R', hiddenyn, valueid, textid, textplsql
      from RASD_ATTRIBUTES
      where formid = r_formid and elementid = r_elementid;
    if v_akcija = 'R' then
      aA(r_formid, r_elementid, v_elementid);
    end if;
  end;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = p_pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
  --aA
 elsif v_akcija in ('a','A') then
  declare
    procedure aA(
      rr_formid RASD_ELEMENTS.formid%type,
      rr_elementid RASD_ELEMENTS.elementid%type,
      pp_pelementid RASD_ELEMENTS.pelementid%type
    ) is
      v_elementid pls_integer;
    begin
      for r in (select elementid from RASD_ELEMENTS
                where formid = rr_formid and pelementid = rr_elementid)
      loop
        v_elementid := new_elementid(p_formid);
        update RASD_ELEMENTS set id = elementid
        where formid = rr_formid and elementid = r.elementid
          and id is null;
        insert into RASD_ELEMENTS
          (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
          select p_formid, v_elementid, pp_pelementid, orderby, element, type, id, nameid, endtagelementid, 'V', hiddenyn, r_lobid, r_form, id
          from RASD_ELEMENTS
          where formid = rr_formid and elementid = r.elementid;
        insert into RASD_ATTRIBUTES
          (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
          select p_formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, 'V', hiddenyn, valueid, textid, textplsql
          from RASD_ATTRIBUTES
          where formid = rr_formid and elementid = r.elementid;
        aA(rr_formid, r.elementid, v_elementid);
      end loop;
    end;
  begin
    v_elementid := new_elementid(p_formid);
    begin
      select formid into r_formid from RASD_FORMS a
      where a.lobid = r_lobid
        and a.form = r_form
        and a.referenceyn = 'Y';
    exception
      when no_data_found then
        raise_application_error('-20000','Referen?ne forme '||r_lobid||'.'||r_form||' ni v tabeli RASD_FORMS');
    end;
    begin
      select elementid into r_elementid from RASD_ELEMENTS a
      where a.formid = r_formid
        and a.id = r_id;
    exception
      when no_data_found then
        raise_application_error('-20000','Referen?nega objekta '||r_lobid||'.'||r_form||'.'||r_id||' ni v tabeli RASD_ELEMENTS');
      when too_many_rows then
        raise_application_error('-20000','Ve? enekih referen?nih objektov '||r_lobid||'.'||r_form||'.'||r_id||' .');
    end;
    update RASD_ELEMENTS set id = elementid
    where formid = r_formid and elementid = r_elementid
      and id is null;
    insert into RASD_ELEMENTS
      (formid, elementid, pelementid, orderby, element, type, id, nameid, endtagelementid, source, hiddenyn, rlobid, rform, rid)
      select p_formid, v_elementid, p_elementid, 0.5, element, type, id, nameid, endtagelementid, 'V', hiddenyn, r_lobid, r_form, id
      from RASD_ELEMENTS
      where formid = r_formid and elementid = r_elementid;
    insert into RASD_ATTRIBUTES
      (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textplsql)
      select p_formid, v_elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, 'V', hiddenyn, valueid, textid, textplsql
      from RASD_ATTRIBUTES
      where formid = r_formid and elementid = r_elementid;
    if v_akcija = 'A' then
      aA(r_formid, r_elementid, v_elementid);
    end if;
  end;
  i := 1;
  for r in (select rowid from RASD_ELEMENTS
            where formid = p_formid and pelementid = p_pelementid
            order by orderby)
  loop
    update RASD_ELEMENTS set orderby = i where rowid = r.rowid;
    i := i+1;
  end loop;
 else
  raise_application_error('-20000','Napa?en ukaz');
 end if;
end;
/

