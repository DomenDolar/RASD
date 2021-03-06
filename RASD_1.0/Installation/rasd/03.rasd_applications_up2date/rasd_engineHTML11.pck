create or replace package rasd_engineHTML11 is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
// +----------------------------------------------------------------------+
// | Copyright (C) 2014       http://rasd.sourceforge.net                 |
// +----------------------------------------------------------------------+
// | This program is free software; you can redistribute it and/or modify |
// | it under the terms of the GNU General Public License as published by |
// | the Free Software Foundation; either version 2 of the License, or    |
// | (at your option) any later version.                                  |
// |                                                                      |
// | This program is distributed in the hope that it will be useful       |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
// | GNU General Public License for more details.                         |
// +----------------------------------------------------------------------+
// | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
// +----------------------------------------------------------------------+
*/


  /*   type atr_type is record (
      attribut        rasd_attributes.attribut%type,
      type            rasd_attributes.type%type,
      text          rasd_attributes.text%type,
      name            rasd_attributes.name%type,
      value       rasd_attributes.value%type,
      valuecode  rasd_attributes.valuecode%type
    );
    type atr_tab is table of atr_type index by binary_integer;
  
  procedure doloci_element(p_tekst in varchar2, p_atr out atr_tab, p_tag out varchar2, p_tip out varchar2);
  procedure prepisi_elemente(p_formid in number);
  procedure prepisi_atribute(p_formid in number);
  procedure beri_tmp(p_formid in pls_integer default null);
  procedure beri(p_formid in number);
  */
  
  function version(p_log out varchar2) return varchar2;
  function core return varchar2;
  
    
  procedure readFromFile(p_formid in number);
 
  procedure writeHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N'
                      , p_lang in varchar2);
  procedure writePrepareHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2);
  procedure writeOutputHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2);
                                            
  procedure writeHTMLError(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2);
 
  procedure writeHTMLHead(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2);

  procedure outputElement(p_formid     rasd_elements.formid%type,
                         p_pelementid rasd_elements.pelementid%type,
                         p_out        in varchar2 default 'N',
                         p_elementid rasd_elements.pelementid%type default null,
                         p_stop_element rasd_elements.element%type default null
                         );
                                               
  function getElementBlockField(p_formid     in rasd_elements.formid%type,
                   p_pelementid in rasd_elements.elementid%type,
                   p_blockid    in rasd_elements.nameid%type)
    return rasd_elements.elementid%type;
    
  function getElementBlock(p_formid  rasd_elements.formid%type,
                       p_element rasd_elements.element%type,
                       p_id rasd_elements.id%type default null)
    return rasd_elements.elementid%type;
                    
  procedure sincFieldsAndElements(p_formid rasd_elements.formid%type);
  procedure sincValuecode(p_formid in rasd_forms.formid%type);
  procedure sincForLoop(p_formid rasd_elements.formid%type);


/*
procedure pisi_element(
  p_formid rasd_elements.formid%type,
  p_pelementid rasd_elements.pelementid%type,
  p_out in varchar2 default 'N');

function beri_atribut(
    pformid in number,
    pelementid in number,
    pime in varchar2,
    pprivzeto  in varchar2 default null,
    ptip in varchar2 default null
  ) return varchar2;
  pragma restrict_references(beri_atribut,WNDS,WNPS,RNPS);

function get_ebp(
    p_formid     in rasd_elements.formid%type,
    p_pelementid  in rasd_elements.elementid%type,
    p_blockid      in rasd_elements.nameid%type
  ) return rasd_elements.elementid%type;
  pragma restrict_references(get_ebp,WNDS,WNPS,RNPS);

procedure uskladi_polja_elemente (
  p_formid rasd_elements.formid%type
);

procedure uskladi_vrednostplsql(
  p_formid in rasd_forms.formid%type
);
procedure uskladi_forloop(
  p_formid     rasd_elements.formid%type
);
*/
end;
/
create or replace package body rasd_engineHTML11 is
/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
// +----------------------------------------------------------------------+
// | Copyright (C) 2014       http://rasd.sourceforge.net                 |
// +----------------------------------------------------------------------+
// | This program is free software; you can redistribute it and/or modify |
// | it under the terms of the GNU General Public License as published by |
// | the Free Software Foundation; either version 2 of the License, or    |
// | (at your option) any later version.                                  |
// |                                                                      |
// | This program is distributed in the hope that it will be useful       |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
// | GNU General Public License for more details.                         |
// +----------------------------------------------------------------------+
// | Author: Domen Dolar       <domendolar@users.sourceforge.net>         |
// +----------------------------------------------------------------------+
*/

 
 
  c_nl     varchar2(4) := '
';
  c_programName constant varchar2(20) := '.webclient';
  c_core  constant integer := 10; -- CORE FOR ELEMENTS, ATTRIBUTES, HTML  
  c_true  constant varchar2(1) := 'Y';
  c_false constant varchar2(1) := 'N';
  type t_vrchrsl is table of varchar2(4000) index by binary_integer;
  v_text   varchar2(32767);
  v_length pls_integer;
  v_level number := 0;
  v_nlx    varchar2(4) := substr('    ', 1, length(c_nl));

   type t_atr is record (
      attribut   rasd_attributes.attribute%type,
      type       rasd_attributes.type%type,
      text       rasd_attributes.text%type,
      name       rasd_attributes.name%type,
      value      rasd_attributes.value%type,
      valuecode  rasd_attributes.valuecode%type
   );
   type v_atrt is table of t_atr index by binary_integer;

  e_htmlerror exception;

  
  function version(p_log out varchar2) return varchar2 is
  begin
   p_log := '/* Change LOG:
20210131 - Fixed bug for L objects where UI Field <> Field - line 2917 (added ''????_VALUE'' in htpclob)   
20200324 - Added rasdMandatory class for elements INPUT, SELECT, TEXTAREA, CHECKBOX and RADIO
20200319 - When using VS visible=false now also label is hidden.  
20200128 - Added Error trace log   
20191113 - Changed function sincIncludevis - solved bug #29 : GC: When using CheckBOX field vit VS settings /?> appears   
20190903 - Added debug comment into poutput   
20190617 - Added ERROR and WARNING objects
20190616 - Solved bug on checkbox fields when going back history.go-1. Checkbox is inicialized to loaded value. Changed checkbox field with two javascript functions js_C???click and js_C???init   
20190221 - Added VS - VisualSettings for error, readonly and custom    
20181221 - Added _rasd_link_url for DYNAMCFIELDS   
20181022 - Added custom DYNAMICFIELD elements to output engine    
20180807 - Added #SET to FROM fields -- change on update for dinamic pages on form elements  line 3591
20180618 - Added new element TX instead of TD. Suport for new CSS objects: rasdTxLab, rasdTxLabBlokc+block_name, rasdTxLab+block+field_name, rasdTx+block+field_name, rasdTxType+field_type, rasdTx+block+field_name+position   
20180530 - Added suport for PRE_UI POST_UI BLOCK triggers on engine version 11   
20180525 - New version 11. Blocks output is created in procedures output_<BLOCK>_DIV    
*/';
   return 'v.'||rasd_engine11.c_engversion||'.0.20200324225530'; 
  
  end;
  
  function core return varchar2 is
  begin
    return c_core;   
  end;
  
  
  -----------------------------------------------------------------------------------------
  procedure AREA_TEXT_PROCEDURES is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  -- Change whiteSpaces in text
  function changeWhiteSpace(p_text in varchar2) return varchar2 is
    v_text1 varchar2(32767);
    v_textx varchar2(32767);
    i       pls_integer;
    j       pls_integer;
    l       pls_integer;
  begin
    --change white spaces for ' '
    v_text1 := replace(replace(replace(replace(replace(p_text, c_nl, v_nlx),
                                               chr(13),
                                               ' '),
                                       chr(10),
                                       ' '),
                               chr(20),
                               ' '),
                       chr(21),
                       ' ');
    --change plsql for ' '
    j       := 1;
    l       := length(v_text1);
    v_textx := '';
    loop
      i := instr(v_text1, '<%', j);
      if i = 0 then
        i := l + 1;
      end if;
      v_textx := v_textx || substr(v_text1, j, i - j);
      exit when i >= l;
      i := instr(v_text1, '%>', i);
      if i = 0 then
        v_textx := rpad(nvl(v_textx, ' '), l, ' ');
        j       := l;
      elsif i = instr(v_text1, '/**/%>', i - 4) + 4 then
        v_textx := rpad(nvl(v_textx, ' '), i, ' ') || '>';
        j       := i + 2;
      else
        v_textx := rpad(nvl(v_textx, ' '), i + 1, ' ');
        j       := i + 2;
      end if;
      exit when j >= l;
    end loop;
    return(v_textx);
  end;
  -----------------------------------------------------------------------------------------
  procedure AREA_ATTR_AND_ELEM_PROCEDURES is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
 function getNextElementid(p_formid rasd_elements.formid%type)
    return rasd_elements.elementid%type is
    v_elementid rasd_elements.elementid%type;
  begin
    select nvl(max(elementid), 0) + 1
      into v_elementid
      from rasd_elements
     where formid = p_formid and elementid > 0;
    return(v_elementid);
  end;
  function getElement(p_formid  rasd_elements.formid%type,
                       p_element rasd_elements.element%type,
                       p_id rasd_elements.id%type default null)
    return rasd_elements%rowtype is
    r rasd_elements%rowtype;
  begin
    select *
      into r
      from rasd_elements
     where formid = p_formid
       and element = p_element
       and (id = p_id or p_id is null)
       and elementid > 0;
    return(r);
  exception
    when no_data_found then
      raise_application_error('-20000',
                              'Error! Element ' || p_formid || '/' || p_element ||
                              ' do not exists.');
                             
  end;
  function readAttribute(pformid    in number,
                        pelementid in number,
                        pname       in varchar2,
                        pprivzeto  in varchar2 default null,
                        ptype       in varchar2 default null) return varchar2 is
    v_value rasd_attributes.value%type;
  begin
    if pname is not null then
      --search on attribute name
      select value
        into v_value
        from rasd_attributes
       where formid = pformid
         and elementid = pelementid
         and upper(name) = pname
         and rownum = 1;
      return(upper(v_value));
    else
      --search on atribute type
      select value
        into v_value
        from rasd_attributes
       where formid = pformid
         and elementid = pelementid
         and type = ptype
         and rownum = 1;
      return(v_value);
    end if;
  exception
    when no_data_found then
      return(pprivzeto);
  end; 
  procedure outputAttribute(p_out           varchar2,
                         p_type           rasd_attributes.type%type,
                         p_text         rasd_attributes.text%type,
                         p_textcode    rasd_attributes.text%type,
                         p_name           rasd_attributes.name%type,
                         p_value      rasd_attributes.value%type,
                         p_valuecode rasd_attributes.valuecode%type,
                         p_forloop       rasd_attributes.forloop%type,
                         p_endloop       rasd_attributes.endloop%type) is
  begin
    if p_out = 'Y' then
      if p_type = 'A' and p_value is not null and p_name is not null then
        v_text := nvl(p_text, ' ') || p_name || '="' || p_value || '"';
      elsif p_type = 'A' and p_value is null and p_name is not null then
        v_text := nvl(p_text, ' ') || p_name;
      elsif p_type = 'A' and p_value is not null and p_name is null then
        v_text := nvl(p_text, ' ') || p_name || '' || p_value || '';
      elsif p_type = 'A' and p_value is null and p_name is null then
        v_text := nvl(p_text, ' ') || p_name;
      elsif p_type = 'V' then
        v_text := p_value;
      else
        v_text := p_text || p_name || p_value;
      end if;
      htp.prn(v_text);
      --dbms_output.put_line(v_text);
      return;
    elsif p_out = 'T' then -- for inline editor
      if p_type = 'A' and p_value is not null and p_name is not null then
        v_text := nvl(p_text, ' ') || p_name || '="' || p_value || '"';
      elsif p_type = 'A' and p_value is null and p_name is not null  then
        v_text := nvl(p_text, ' ') || p_name;
      elsif p_type = 'A' and p_value is not null and p_name is null then
        v_text := nvl(p_text, ' ') || p_name || '' || p_value || '';
      elsif p_type = 'A' and p_value is null and p_name is null  then
        v_text := nvl(p_text, ' ') || p_name;
      elsif p_type = 'V' then
        v_text := p_value;
      else
        v_text := p_text || p_name || p_value;
      end if;
      htp.prn(replace(v_text,'<','&lt;'));
      --dbms_output.put_line(v_text);
      return;
    elsif p_out = 'X' then
      if p_type = 'A' then
        v_text := nvl(p_textcode, ' ') || p_forloop || p_name ||
                       p_valuecode || p_endloop;
      else
        v_text := p_textcode || p_forloop || p_name ||
                       p_valuecode || p_endloop;
      end if;      
      htp.prn(v_text);
      --dbms_output.put_line(v_text);
      return;  
    else
      if p_type = 'A' then
        rasd_engine11.addc(nvl(p_textcode, ' ') || p_forloop || p_name ||
                       p_valuecode || p_endloop);
      else
        if instr(p_textcode || p_forloop || p_name ||
                       p_valuecode || p_endloop , '/>') > 0 then
          rasd_engine11.addc(p_textcode || p_forloop || p_name ||
                       p_valuecode || p_endloop||'
');
        else               
          rasd_engine11.addc(p_textcode || p_forloop || p_name ||
                       p_valuecode || p_endloop);
        end if;               
      end if;
    
      --      dbms_output.put_line(p_textcode||p_forloop||p_name||p_valuecode||p_endloop);
    end if;
  end;

  procedure outputElement(p_formid     rasd_elements.formid%type,
                         p_pelementid rasd_elements.pelementid%type,
                         p_out        in varchar2 default 'N',
                         p_elementid rasd_elements.pelementid%type default null,
                         p_stop_element rasd_elements.element%type default null
                         ) is
    i  integer;
    rt rasd_attributes%rowtype;
  begin
    v_level := v_level + 1;
    i      := 0;
    for re in (select a.elementid,
                      a.orderby,
                      a.nameid,
                      a.element,
                      count(b.elementid) numchilds
                 from rasd_elements a, rasd_elements b
                where a.formid = p_formid
                  and (a.pelementid = p_pelementid or a.elementid = p_elementid and p_elementid is not null)
                  and nvl(a.hiddenyn, 'N') = 'N'
                  and b.formid(+) = a.formid
                  and b.pelementid(+) = a.elementid
                group by a.elementid, a.orderby, a.nameid, a.element
                order by orderby) loop
      --dbms_output.put_line(p_pelementid||' '||re.elementid||' '||re.nameid||' '||re.element);
      begin

     
        --start tag
        select *
          into rt
          from rasd_attributes
         where formid = p_formid
           and elementid = re.elementid
           and type in ('S')
           and nvl(hiddenyn, 'N') = 'N';

        if re.element = p_stop_element and p_stop_element is not null then
            re.elementid := -1;
            rt.type := '';
            
              rt.text := '<%';
              rt.textcode := ''');';

            if rasd_engine11.c_debug then
              rt.textcode := rt.textcode||' rlog('' '||replace(re.nameid,'_DIV','')||' - prepare'');';            
            end if;

            if rasd_engine11.trueTrigger(p_formid, 'pre_ui' , replace(re.nameid,'_DIV','') ) then 
              rt.text := rt.text||' pre_output_'||re.nameid||';';
              rt.textcode := rt.textcode||' pre_output_'||re.nameid||';';            
            end if;
              rt.text := rt.text||' output_'||re.nameid||';';
              rt.textcode := rt.textcode||' output_'||re.nameid||';';            
            if rasd_engine11.trueTrigger(p_formid, 'post_ui' , replace(re.nameid,'_DIV','') ) then 
              rt.text := rt.text||' post_output_'||re.nameid||';';
              rt.textcode := rt.textcode||' post_output_'||re.nameid||';';            
            end if;
              rt.text := rt.text||' %>';

              if rasd_engine11.c_debug then
                 rt.textcode := rt.textcode||' rlog('' '||replace(re.nameid,'_DIV','')||' - finish'');';            
              end if;

              rt.textcode := rt.textcode||' htp.p(''';            
--            rt.text := '<% output_'||re.nameid||'; %>';
  --          rt.textcode := '''); output_'||re.nameid||'; htp.p(''';
            
            rt.valuecode := '';
            rt.name := '';
            rt.value := '';
            rt.valuecode := '';
            rt.forloop := '';
            rt.endloop := '';            
        end if;  

        if rt.name is null then   
        outputAttribute(p_out,
                     rt.type,
                     rt.text,
                     rt.textcode,
                     rt.valuecode, --rt.name,
                     null,
                     null,
                     rt.forloop,
                     null);
         else 
        outputAttribute(p_out,
                     rt.type,
                     rt.text,
                     rt.textcode,
                     rt.name,
                     null,
                     null,
                     rt.forloop,
                     null);           
         end if;            
        --attributs
        for ra in (select *
                     from rasd_attributes
                    where formid = p_formid
                      and elementid = re.elementid
                      and type in ('A','C')
                      and nvl(hiddenyn, 'N') = 'N'
                      and (nvl(source, 'G') <> 'G' or value is not null)
                    order by type, orderby) loop
          outputAttribute(p_out,
                       ra.type,
                       ra.text,
                       ra.textcode,
                       ra.name,
                       ra.value,
                       ra.valuecode,
                       null,
                       null);
        end loop;
        
        if re.numchilds = 0 then
          if rt.name is null then  
          outputAttribute(p_out,
                       rt.type,
                       null,
                       null,
                       null,
                       rt.name, --rt.value,
                       rt.name, --rt.valuecode,
                       null,
                       rt.endloop);
          else
          outputAttribute(p_out,
                       rt.type,
                       null,
                       null,
                       null,
                       rt.value,
                       rt.valuecode,
                       null,
                       rt.endloop);            
          end if;             
        else
          if rt.name is null then  
          outputAttribute(p_out,
                       rt.type,
                       null,
                       null,
                       null,
                       rt.name, --rt.value,
                       rt.name, --rt.valuecode,
                       null,
                       null);
          else
          outputAttribute(p_out,
                       rt.type,
                       null,
                       null,
                       null,
                       rt.value,
                       rt.valuecode,
                       null,
                       null);            
          end if;             
          --recursive calling
          
        if re.element = p_stop_element and p_stop_element is not null then
           null;
        else  
          outputElement(p_formid, re.elementid, p_out, null, p_stop_element);
        end if;
 
       end if;
        --content
        
        
        begin
          select *
            into rt
            from rasd_attributes
           where formid = p_formid
             and elementid = re.elementid
             and type in ('V')
             and nvl(hiddenyn, 'N') = 'N';
          outputAttribute(p_out,
                       rt.type,
                       rt.text,
                       rt.textcode,
                       rt.name,
                       rt.value,
                       rt.valuecode,
                       null,
                       null);
        exception
          when no_data_found then
            null;
        end;
        
        
        --end tag
        begin
          select *
            into rt
            from rasd_attributes
           where formid = p_formid
             and elementid = re.elementid
             and type = 'E'
             and nvl(hiddenyn, 'N') = 'N';
          outputAttribute(p_out,
                       rt.type,
                       rt.text,
                       rt.textcode,
                       rt.name,
                       rt.value,
                       rt.valuecode,
                       null,
                       rt.endloop);
        exception
          when no_data_found then
            null;
        end;
      exception
        when no_data_found then
          null;
      end;
      i := i + 1;
    end loop; --endcode
    v_level := v_level - 1;
  exception when others then 
  commit;

declare
  vp_pelementid varchar2(1000);
  vp_elementid varchar2(1000);
begin    
select max(nameid) into vp_pelementid
from rasd.rasd_elements e 
where e.elementid = p_pelementid and formid = p_formid;

select max(nameid) into vp_elementid
from rasd.rasd_elements e 
where e.elementid = p_elementid and formid = p_formid;
     
  raise_application_error('-20999' , 'Error on element '||vp_elementid||' (parent el. '||vp_pelementid||') - '||sqlerrm);     
end;

  end; 
  -----------------------------------------------------------------------------------------
  procedure AREA_ATR_ELEM_FROM_FILE is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  procedure defineElement(p_text in varchar2,
                           p_atr   out v_atrt,
                           p_tag   out varchar2,
                           p_type   out varchar2) is
    j      pls_integer;
    si     pls_integer;
    i      pls_integer;
    z      pls_integer;
    k      pls_integer;
    l      pls_integer;
    v_text varchar2(32767);
    v_eq   boolean;
  begin
    v_text := changeWhiteSpace(p_text);
    l      := length(p_text);
    i      := 1;
    si     := instr(v_text, '<', i);
    dbms_output.put_line(si || ' ' || substr(v_text, 1, 240));
    if substr(p_text, si + 1, 1) = '/' then
      p_type := 'E';
      i     := si + 2;
    else
      p_type := 'S';
      i     := si + 1;
    end if;
    while substr(v_text, i, 1) = ' ' loop
      i := i + 1;
    end loop;
    z := i;
    while substr(v_text, i, 1) not in (' ', '>') loop
      i := i + 1;
    end loop;
    k := i;
    p_tag := upper(substr(p_text, z, k - z));
    p_atr(1).text := substr(p_text, 1, si - 1);
    p_atr(1).name := substr(p_text, si, k - si);
    p_atr(1).attribut := p_type || '_';
    p_atr(1).type := p_type;
    j := 2;
    loop
      exit when i >= l or substr(v_text, i, 1) = '>';
      p_atr(j).type := 'A';
      --name
      z := i;
      while z < l and substr(v_text, z, 1) = ' ' loop
        z := z + 1;
      end loop;
      k := z;
      while k < l and substr(v_text, k, 1) not in (' ', '=', '>') loop
        k := k + 1;
      end loop;
      p_atr(j).text := substr(p_text, i, z - i);
      p_atr(j).name := substr(p_text, z, k - z);
      p_atr(j).attribut := p_atr(j).type || '_' || upper(p_atr(j).name);
      --value
      z    := k;
      v_eq := false;
      while z < l and substr(v_text, z, 1) in (' ', '=') loop
        if substr(v_text, z, 1) = '=' then
          v_eq := true;
        end if;
        z := z + 1;
      end loop;
      k := z;
      if not v_eq then
        p_atr(j).value := '';
      elsif substr(v_text, z, 1) = '>' then
        p_atr(j).value := '';
      elsif substr(v_text, z, 1) = '"' then
        k := k + 1;
        while k < l and substr(v_text, k, 1) <> '"' loop
          k := k + 1;
        end loop;
        p_atr(j).value := substr(p_text, z + 1, k - z - 1);
        k := k + 1;
      else
        while k < l and substr(v_text, k, 1) not in (' ', '>') loop
          k := k + 1;
        end loop;
        p_atr(j).value := substr(p_text, z, k - z);
      end if;
      --debuging
      --      dbms_output.put_line(rpad(p_atr(j).attribute,10,' ')||' '||rpad(p_atr(j).text,10,' ')||' '||rpad(p_atr(j).name,10,' ')||p_atr(j).value);
      j := j + 1;
      i := k;
    end loop;
    p_atr(1).value := substr(p_text, i, l - i + 1);
    j := 1;
    --debuging
    --      dbms_output.put_line(rpad(p_atr(j).attribute,10,' ')||' '||rpad(p_atr(j).text,10,' ')||' '||rpad(p_atr(j).name,10,' ')||p_atr(j).value);
  end;

  --*****************************************************
  function defineTag(p_stg in pls_integer,
                      p_tag out pls_integer,
                      p_atr out pls_integer,
                      p_type out varchar2) return varchar2 is
    --        <...TA<%...%>G...
    --p_stg   x   |         |
    --p_tag       x         |
    --p_atr                 x
    j pls_integer;
    c char;
  begin
    j := p_stg + 1;
    c := substr(v_text, j, 1);
    --exceptions
    if c = '/' then
      j     := j + 1;
      p_type := 'E';
    elsif c = '%' then
      p_tag := j;
      p_atr := j + 1;
      p_type := 'P';
      return('%');
    elsif c = '!' then
      if substr(v_text, j, 3) = '!--' then
        p_tag := j;
        p_atr := j + 3;
        p_type := 'K';
        return('!--');
      else
        p_tag := j;
        p_atr := j + 1;
        p_type := 'D';
        return('!');
      end if;
    else
      p_type := 'S';
    end if;
    --startcode TAG
    while j < v_length loop
      if instr(v_text, c_nl, j) = j then
        j := j + length(c_nl);
      elsif ltrim(substr(v_text, j, 1)) is null then
        j := j + 1;
      else
        exit;
      end if;
    end loop;
    p_tag := j;
    --endcode TAG
    while j < v_length loop
      if instr(v_text, c_nl, j) = j then
        exit;
      elsif nvl(ltrim(substr(v_text, j, 1)), '>') = '>' then
        exit;
      elsif substr(v_text, j, 2) = '<%' then
        j := instr(v_text, '%>', j + 2) + 1;
      end if;
      j := j + 1;
    end loop;
    p_atr := j;
    return(upper(substr(v_text, p_tag, p_atr - p_tag)));
  end;

  function defineAttribute(p_tag  in varchar2,
                      p_type  in varchar2,
                      p_atr  in pls_integer,
                      p_etg  in pls_integer,
                      p_id   out varchar2,
                      p_name out varchar2,
                      v_txt  out t_vrchrsl,
                      v_atr  out t_vrchrsl,
                      v_val  out t_vrchrsl) return varchar2 is
    --attributi
    --...>...<...TAG...ATR...ATR...=...VAL...ATR...=..."content"...>...<...tag...>...</...TAG...>...
    --tag    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    --stg    xxxxxxx
    --atr           xxxxxxxxxxxxxxx       xxxxxxxxx             xxx
    --val                          xxxxxxx         xxxxxxxxxxxx |||
    --etg                                                       xxxx
    --
    --pls
    --ws                           xxxx            xxxxx       x
  
    --      ...AT<%...%>R...=..."VAL"...AT<%...%>R...=...VAL...AT<%...%>R...>
    --ii    x                        x                      x
    --jj                 x                        x                      x
    --hh                         X                       X                  x
    --j
    zac         pls_integer;
    zatr        pls_integer;
    katr        pls_integer;
    zval        pls_integer;
    kval        pls_integer;
    k           pls_integer;
    v_apost     pls_integer;
    v_equal     pls_integer;
    v_typet     varchar2(100);
  begin
    k           := 1;
    v_apost := 0; --value is not in ", kval do not point on "
    kval        := p_atr;
    while kval < p_etg loop
      if v_apost = 1 then
        kval := kval + 1;
      end if;
      --name
      zac  := kval;
      zatr := kval;
      while zatr < p_etg loop
        if instr(v_text, c_nl, zatr) = zatr then
          zatr := zatr + length(c_nl);
        elsif ltrim(substr(v_text, zatr, 1)) is null then
          zatr := zatr + 1;
        else
          exit;
        end if;
        --      zatr := zatr+1;
      end loop;
      --endcode
      v_equal := 0;
      katr     := zatr;
      while katr < p_etg loop
        if instr(v_text, c_nl, katr) = katr then
          exit;
        elsif ltrim(substr(v_text, katr, 1)) is null then
          exit;
        elsif substr(v_text, katr, 1) = '=' then
          v_equal := 1;
          exit;
        elsif substr(v_text, katr, 2) = '<%' then
          katr := instr(v_text, '%>', katr + 2) + 1;
        end if;
        katr := katr + 1;
      end loop;
      if v_equal = 0 then
        zval        := katr;
        kval        := zval;
        v_apost := 0;
      else
        --value
        zval := katr;
        while zval < p_etg loop
          if instr(v_text, c_nl, zval) = zval then
            zval := zval + length(c_nl);
          elsif nvl(ltrim(substr(v_text, zval, 1)), '"') = '"' then
            zval := zval + 1;
          elsif substr(v_text, zval, 1) = '=' then
            v_equal := 1;
            zval     := zval + 1;
          else
            exit;
          end if;
          --        zval := zval+1;
        end loop;
        if v_equal = 0 then
          zval        := katr;
          kval        := zval;
          v_apost := 0;
        else
          --endcode
          kval := zval;
          if substr(v_text, zval - 1, 1) = '"' then
            v_apost := 1;
          else
            v_apost := 0;
          end if;
          while kval < p_etg loop
            if v_apost = 0 then
              if instr(v_text, c_nl, kval) = kval then
                exit;
              elsif ltrim(substr(v_text, kval, 1)) is null then
                exit;
              elsif substr(v_text, kval, 2) = '<%' then
                kval := instr(v_text, '%>', kval + 2) + 1;
              end if;
            else
              if substr(v_text, kval, 1) = '"' then
                exit;
              elsif substr(v_text, kval, 2) = '<%' then
                kval := instr(v_text, '%>', kval + 2) + 1;
              end if;
            end if;
            kval := kval + 1;
          end loop;
        end if;
      end if;
      --results
      k := k + 1;
      if zatr <> katr then
        v_txt(k) := substr(v_text, zac, zatr - zac);
        v_atr(k) := substr(v_text, zatr, katr - zatr);
        v_val(k) := substr(v_text, zval, kval - zval);
        if upper(ltrim(v_atr(k))) = 'TYPE' then
          v_typet := upper(v_val(k));
        end if;
        if upper(ltrim(v_atr(k))) in ('ID', 'HTTP-EQUIV') then
          p_id := upper(v_val(k));
        end if;
        if upper(ltrim(v_atr(k))) = 'NAME' then
          p_name := upper(v_val(k));
        end if;
      end if;
    end loop;
    return(v_typet);
  end;

  procedure parseHTMLText2Temporary(p_formid in pls_integer default null) is
    v_elementid pls_integer;
  
    i   pls_integer;
    zac pls_integer;
    stg pls_integer;
    tag pls_integer;
    atr pls_integer;
    etg pls_integer;
    ktg pls_integer;
    kon pls_integer;
  
    v_apost pls_integer;
  
    v_txt t_vrchrsl;
    v_atr t_vrchrsl;
    v_val t_vrchrsl;
  
    v_tag   varchar2(100);
    v_type   varchar2(100);
    v_typet  varchar2(4000);
    v_id    varchar2(4000);
    v_nameid varchar2(4000);
    c       char;
  
  begin
    --text html from database
    select text
      into v_text
      from rasd_texts
     where textid =
           (select text2id from rasd_forms where formid = p_formid);
    if v_text is null then
      raise_application_error('-20000', 'HTMLError! Text HTML is empty!');
    end if;
    v_length := length(v_text);
    delete rasd_attributes_TEMPORARY where formid = p_formid;
    delete RASD_ELEMENTS_TEMPORARY where formid = p_formid;
    -- tags         ...<...>...
    --script        ...<...>content</...>...
    --xmp           ...<...>content</...>...
    --pre           ...<...>content</...>...
    --listing       ...<...>content</...>...
    --end tag       ...</...>...
    --doctype       ...<!content>...
    --comment       ...<!--content-->...
    --plsql:        ...<%content>...           ...'); plsql block htp.prn('...
    --              ...<%=content>...          ...'|| plsql code ||'...
    --
    --.../ ** /%>...<%...%>...<...TAG...attributI...-->...<%...%>...<%.../ ** /%>...
    --           |            |xxx|  |          xxx|  |                         |
    --zac        x            |   |  |             |  |                         |
    --stg                     x   |  |             |  |                         |
    --tag                         x  |             |  |                         |
    --atr                            x             |  |                         |
    --etg                                          x  |                         |
    --ktg                                             x                         |
    --kon                                                                       x
    kon         := 1;
    v_elementid := 0;
    while kon < v_length loop
      --tag
      zac := kon;
      stg := zac;
      loop
        --jump <%...%>
        stg := instr(v_text, '<', stg);
        exit when stg = 0;
        if substr(v_text, stg + 1, 1) = '%' then
          stg := instr(v_text, '%>', stg) + 1;
        else
          exit;
        end if;
        stg := stg + 1;
      end loop;
      v_tag := defineTag(stg, tag, atr, v_type);
      if v_tag = '!' then
        etg := atr;
        ktg := instr(v_text, '>', etg) + 1;
      elsif v_tag = '!--' then
        etg := atr;
        ktg := instr(v_text, '-->', etg) + 3;
      else
        --parse any tag
        i           := atr;
        v_apost := 0;
        loop
          c := substr(v_text, i, 1);
          if c = '"' then
            v_apost := v_apost + 1;
          elsif substr(v_text, i, 2) = '<%' then
            i := instr(v_text, '%>', i) + 1;
          elsif c = '>' and mod(v_apost, 2) = 0 then
            etg := i;
            ktg := etg + 1;
            exit;
          end if;
          exit when i >= v_length;
          i := i + 1;
        end loop;
        if v_tag in ('SCRIPT', 'PRE', 'XMP', 'LISTING') then
          ktg := instr(v_text, v_tag, i) + length(v_tag) + 1;
        end if;
      end if;
      --kkn
      i := ktg;
      loop
        --first next tag
        i := instr(v_text, '<', i);
        exit when i = 0;
        exit when substr(v_text, i + 1, 1) <> '%';
        i := i + 1;
      end loop;
      kon := instr(v_text, '/**/%>', ktg);
      if kon = 0 then
        kon := v_length + 1;
      end if;
      if i = 0 then
        kon := v_length + 1;
      elsif i < kon then
        kon := ktg;
      else
        kon := kon + 6;
      end if;
      v_elementid := v_elementid + 1;
      v_txt.delete;
      v_atr.delete;
      v_val.delete;
      v_typet := defineAttribute(v_tag,
                           v_type,
                           atr,
                           etg,
                           v_id,
                           v_nameid,
                           v_txt,
                           v_atr,
                           v_val);
      v_txt(1) := substr(v_text, zac, stg - zac);
      v_atr(1) := substr(v_text, stg, atr - stg);
      v_val(1) := substr(v_text, etg, kon - etg);
      -- debuging
      --dbms_output.put_line(v_elementid||' '||v_type||' '||v_tag||' '||v_typet||' '||v_id||' '||v_nameid||' '||zac||' '||stg||' '||tag||' '||atr||' '||etg||' '||ktg||' '||kon);
      --  for k in 1..v_atr.count loop
      --    if v_val(k) is not null then
      --dbms_output.put_line(' '||k||' A '||v_atr(k)||' = "'||v_val(k)||'"');
      --    else
      --dbms_output.put_line(' '||k||' A '||v_atr(k));
      --    end if;
      --  end loop;
    
      insert into rasd_attributes_temporary
        (formid, elementid, orderby, attribute, type, text, name, value)
      values
        (p_formid,
         v_elementid,
         1,
         v_type || '_',
         v_type,
         v_txt(1),
         v_atr(1),
         v_val(1));
      for k in 2 .. v_atr.count loop
        insert into rasd_attributes_TEMPORARY
          (formid,
           elementid,
           orderby,
           attribute,
           type,
           text,
           name,
           value)
        values
          (p_formid,
           v_elementid,
           k,
           'A_' || upper(v_atr(k)),
           'A',
           v_txt(k),
           v_atr(k),
           v_val(k));
      end loop;
      if v_tag in ('HTML', 'HEAD', 'TITLE', 'BODY') and v_id is null then
        v_id := v_tag;
      elsif v_nameid is null and
            (substr(v_id, -5) = '_BLOCK' or substr(v_id, -4) = '_LAB' or
            (v_tag = 'FONT' and substr(v_id, -4) <> '_REF')) then
        v_nameid := v_id;
      else
        v_id := v_nameid;
      end if;
      insert into RASD_ELEMENTS_TEMPORARY
        (formid, elementid, orderby, element, type, tag, id, nameid)
      values
        (p_formid,
         v_elementid,
         v_elementid,
         v_tag || '_' || v_typet,
         v_type,
         v_tag,
         v_id,
         v_nameid);    
    end loop;
  end;
  
  
  --*******************************************

  procedure saveElemFromTemp2Elements(p_formid in number) is
    cursor c(pformid number) is
      select a.*, a.rowid
        from RASD_ELEMENTS_TEMPORARY a
       where formid = pformid
       order by a.orderby;
    r              c%rowtype;
    e_htmlerror exception;
    v_value varchar2(100);
    v_form    varchar2(100);
  
    procedure elem(p_pelementid in pls_integer) is
      s         c%rowtype;
      v_typeelem rasd_elements.type%type;
    begin
      s := r;
      loop
        fetch c
          into r;
        if r.type = 'S' then
          elem(s.elementid);
        end if;
        if r.type = 'E' then
          v_typeelem := null;
          --define type
          if s.tag = r.tag then
            insert into rasd_elements
              (formid,
               elementid,
               pelementid,
               orderby,
               element,
               nameid,
               type,
               id,
               endtagelementid)
            values
              (p_formid,
               s.elementid,
               p_pelementid,
               s.orderby,
               s.element,
               s.nameid,
               v_typeelem,
               s.id,
               r.elementid);
            fetch c
              into r;
            if r.type = 'E' then
              return;
            end if;
          else
            insert into rasd_elements
              (formid,
               elementid,
               pelementid,
               orderby,
               element,
               nameid,
               type,
               id,
               endtagelementid)
            values
              (p_formid,
               s.elementid,
               p_pelementid,
               s.orderby,
               s.element,
               s.nameid,
               v_typeelem,
               s.id,
               to_number(null));
            return;
          end if;
        end if;
        s := r;
      end loop;
    end;
  
  begin
    --control of file and form to import
    select value
      into v_value
      from rasd_attributes_TEMPORARY a, RASD_ELEMENTS_TEMPORARY e
     where e.formid = p_formid
       and e.element = 'FORM_'
       and a.formid = e.formid
       and a.elementid = e.elementid
       and a.attribute = 'A_NAME';
    select form into v_form from rasd_forms where formid = p_formid;
    if upper(v_value) <> upper(v_form) then
      raise_application_error('-20000',
                              'HTMLError! In file is content for form ' ||
                              v_value || ' not for form ' || v_form || ' (' ||
                              p_formid || ').');
    end if;
  
    --prepare hierarchi
    delete rasd_attributes where formid = p_formid;
    delete rasd_elements where formid = p_formid;
    open c(p_formid);
    fetch c
      into r;
    elem(0);
    if c%found then
      raise e_htmlerror;
    end if;
    close c;
    --setting pelementid
    for r in (select rowid rid
                from rasd_elements
               where formid = p_formid
               order by orderby) loop
      update rasd_elements a
         set pelementid =
             (select decode(sign(endtagelementid - a.elementid),
                            1,
                            elementid,
                            pelementid)
                from rasd_elements
               where formid = a.formid
                 and elementid = a.pelementid)
       where exists (select 1
                from rasd_elements
               where formid = a.formid
                 and elementid = a.pelementid)
         and rowid = r.rid;
    end loop;
  exception
    when e_htmlerror then
      close c;
      raise_application_error('-20000',
                              'HTMLError: at processing of element ' ||
                              r.elementid || ' we have an error. (' ||
                              r.content || r.startcode || r.attributes ||
                              r.endcode || ')');
    when others then
      if c%isopen then
        close c;
      end if;
      raise;
  end;

  procedure saveAttFromTemp2Attributes(p_formid in number) is
  begin
    delete rasd_attributes where formid = p_formid;
    insert into rasd_attributes
      (formid,
       elementid,
       orderby,
       attribute,
       type,
       text,
       name,
       value,
       source,
       hiddenyn)
    --start tags and attributs
      select a.formid,
             a.elementid,
             ba.orderby ob,
             ba.attribute,
             ba.type,
             ba.text,
             ba.name,
             ba.value,
             'V' source,
             'N' hiddenyn
        from rasd_elements a, RASD_ELEMENTS_TEMPORARY b, rasd_attributes_TEMPORARY ba
       where a.formid = p_formid
         and b.formid(+) = a.formid
         and b.elementid(+) = a.elementid
         and ba.formid(+) = b.formid
         and ba.elementid(+) = b.elementid
      union
      --text endtags if there is no children elements
      select a.formid,
             a.elementid,
             y.stzap + ca.orderby vr,
             'V_' attribute,
             'V' type,
             null text,
             null name,
             ca.text,
             'V' source,
             c_false hiddenyn
        from rasd_elements a,
             RASD_ELEMENTS_TEMPORARY c,
             rasd_attributes_TEMPORARY ca,
             (select formid, elementid, count(*) stzap
                from rasd_attributes_TEMPORARY
               group by formid, elementid) y
       where a.formid = p_formid
         and c.formid = a.formid
         and c.elementid = a.endtagelementid
         and ca.formid(+) = c.formid
         and ca.elementid(+) = c.elementid
         and ca.attribute(+) = 'E_'
         and not exists (select 1
                from rasd_elements
               where formid = a.formid
                 and pelementid = a.elementid)
         and y.formid(+) = a.formid
         and y.elementid(+) = a.elementid
      union
      --end tags and attributs
      select a.formid,
             a.elementid,
             y.stzap + ca.orderby + 1 vr,
             ca.attribute,
             ca.type,
             decode(nvl(x.stzap, 0), 0, '', ca.text) text,
             ca.name,
             ca.value,
             'V' source,
             c_false hiddenyn
        from rasd_elements a,
             RASD_ELEMENTS_TEMPORARY c,
             rasd_attributes_TEMPORARY ca,
             (select formid, pelementid, count(*) stzap
                from rasd_elements
               group by formid, pelementid) x,
             (select formid, elementid, count(*) stzap
                from rasd_attributes_TEMPORARY
               group by formid, elementid) y
       where a.formid = p_formid
         and c.formid = a.formid
         and c.elementid = a.endtagelementid
         and ca.formid(+) = c.formid
         and ca.elementid(+) = c.elementid
         and ca.attribute(+) = 'E_'
         and x.formid(+) = a.formid
         and x.pelementid(+) = a.elementid
         and y.formid(+) = a.formid
         and y.elementid(+) = a.elementid;
  end;


  /*procedure saveElemAtt2ElemAtt(p_formid in number) is
    v_elementid number;
  begin
    --hidden elements
    for r in (select e.*, p1.elementid elementid1, p1.formid formid1
                from rasd_elements p,
                     rasd_elements e,
                     rasd_elements p1,
                     rasd_elements e1
               where p.formid = e.formid
                 and p.elementid = e.pelementid
                 and e.hiddenyn = 'D'
                 and p.id is not null
                 and p1.formid(+) = -p.formid
                 and p1.id(+) = p.id
                 and e1.formid(+) = -e.formid
                 and e1.id(+) = e.id
                 and e1.id is null
                 and p1.id is not null) loop
      --parents elements must have ID
      v_elementid := getNextElementid(r.formid);
      insert into rasd_elements
        (formid,
         elementid,
         pelementid,
         orderby,
         element,
         type,
         id,
         nameid,
         endtagelementid,
         source,
         hiddenyn,
         rlobid,
         rform)
      values
        (r.formid1,
         v_elementid,
         r.elementid1,
         1,
         r.element,
         r.type,
         r.id,
         r.nameid,
         decode(r.endtagelementid, null, null, 0),
         r.source,
         r.hiddenyn,
         r.rlobid,
         r.rform);
    end loop;
    --reference,source,hiddenyn
    update rasd_elements x
       set (source, hiddenyn, rlobid, rform) =
           (select source, hiddenyn, rlobid, rform
              from rasd_elements
             where formid = x.formid
               and id = x.id)
     where formid = p_formid
       and id is not null;
    --attributes
    merge into rasd_attributes x
    using (select a.*, e.id, e1.elementid elementid1, e1.formid formid1
             from rasd_attributes a, rasd_elements e, rasd_elements e1
            where e.formid = -p_formid
              and a.formid = e.formid
              and a.elementid = e.elementid
              and e1.formid = p_formid
              and e1.id = e.id) y
    on (y.formid1 = x.formid and y.elementid1 = x.elementid and y.attribute = x.attribute)
    when matched then
      update
         set source      = decode(y.value, x.value, y.source, 'V'),
             hiddenyn = 'N'
    when not matched then
      insert 
        (formid,
         elementid,
         orderby,
         attribute,
         type,
         text,
         name,
         value,
         valuecode,
         forloop,
         endloop,
         source,
         hiddenyn,
         valueid,
         textid)
      values
        (y.formid1,
         y.elementid1,
         y.orderby,
         y.attribute,
         y.type,
         y.text,
         y.name,
         y.value,
         y.valuecode,
         y.forloop,
         y.endloop,
         y.source,
         'D',
         y.valueid,
         y.textid);
  end;*/
   procedure sincElementsAndFields(p_formid in number) is
    v_elementid rasd_elements.elementid%type;
    v_label    rasd_blocks.label%type;
    v_fieldid   rasd_fields.fieldid%type;
    v_blockid   rasd_fields.blockid%type;
    v_form     rasd_forms.form%type;
  begin
    for re in (select *
                 from rasd_elements
                where formid = p_formid
                  and element = 'FORM_') loop
      --define label and id label
      begin
        select elementid
          into v_elementid
          from rasd_elements
         where formid = re.formid
           and nameid = re.nameid || '_LAB'
           and rownum = 1;
        v_label := readAttribute(re.formid, v_elementid, null, null, 'V');
      exception
        when no_data_found then
          null; --v_label := re.nameid;
      end;
      --form
      v_form := readAttribute(re.formid, re.elementid, 'NAME');
      update rasd_forms
         set form     = nvl(v_form, form),
             version   = nvl(version, 1),
             label    = nvl(v_label, nvl(label, formid)),
             program   = nvl(program, '!' || v_form || c_programName),
             change = sysdate
       where formid = re.formid;
      if sql%notfound then
        insert into rasd_forms
          (formid, form, version, label, program, change)
        values
          (re.formid,
           v_form,
           1,
           v_label,
           '!' || v_form || c_programName,
           sysdate);
      end if;
      --blocks
      for re in (select *
                   from rasd_elements
                  where formid = p_formid
                    and substr(nameid, -5) = '_BLOCK'
                  order by orderby) loop
        --define label and id label
        begin
          select elementid
            into v_elementid
            from rasd_elements
           where formid = re.formid
             and nameid =
                 substr(re.nameid, 1, length(re.nameid) - 5) || '_LAB'
             and rownum = 1;
          v_label := readAttribute(re.formid, v_elementid, null, null, 'V');
        exception
          when no_data_found then
            null; --v_label := re.nameid;
        end;
        --block
        update rasd_blocks
           set label = nvl(v_label, nvl(label, blockid))
         where formid = re.formid
           and upper(blockid || '_BLOCK') = re.nameid;
        if sql%notfound then
          insert into rasd_blocks
            (formid, blockid,  numrows, label)
          values
            (re.formid,
             substr(re.nameid, 1, length(re.nameid) - 5),
             1,
             v_label);
        end if;
      end loop;
      --field
      for re in (select formid,
                        nameid,
                        element,
                        min(orderby) orderby,
                        min(elementid) elementid
                   from rasd_elements p
                  where formid = p_formid
                    and type = 'D'
                    and not exists (select 1
                           from rasd_elements
                          where formid = p_formid
                            and nameid = p.nameid
                            and id <> p.id)
                  group by formid, nameid, element
                 --               having count(*) = 1
                  order by orderby) loop
        --define fieldid and blockid from nameid
        select substr(re.nameid, nvl(length(max(blockid)), 0) + 1),
               max(blockid)
          into v_fieldid, v_blockid
          from rasd_blocks
         where formid = re.formid
           and re.nameid like blockid || '%';
        --define label and id label
        begin
          select elementid
            into v_elementid
            from rasd_elements
           where formid = re.formid
             and nameid = re.nameid || '_LAB'
             and rownum = 1;
          v_label := readAttribute(re.formid, v_elementid, null, null, 'V');
        exception
          when no_data_found then
            null; --v_label := re.nameid;
        end;
        --field
        update rasd_fields
           set type       = nvl(type, 'C'),
               orderby = re.orderby,
               elementyn = nvl(elementyn, c_true),
               label    = nvl(v_label, nvl(label, nameid)),
               element   = nvl(re.element, element)
         where formid = re.formid
           and nameid = re.nameid;
        if sql%notfound then
          insert into rasd_fields
            (formid,
             fieldid,
             blockid,
             type,
             orderby,
             elementyn,
             nameid,
             label,
             element)
          values
            (re.formid,
             nvl(v_fieldid, '#ERROR#'),
             v_blockid,
             'C',
             nvl(re.orderby, 1),
             c_true,
             re.nameid,
             v_label,
             re.element);
        end if;
      end loop;
    end loop;
    --fields with no elements: elementdn := 'N'
    update rasd_fields a
       set elementyn = c_false
     where formid = p_formid
       and not exists (select 1
              from rasd_elements
             where formid = a.formid
               and nameid = a.nameid);
  end;



  procedure readFromFile(p_formid in number) is
  begin
    parseHTMLText2Temporary(p_formid);
    commit;
    saveElemFromTemp2Elements(p_formid);
    saveAttFromTemp2Attributes(p_formid);
    sincElementsAndFields(p_formid);
    commit;
  end;

  -----------------------------------------------------------------------------------------
  procedure AREA_ATTR_ELEM_FROM_TEMPLATE is
  begin
    null;
  end;
  -----------------------------------------------------------------------------------------
  procedure sincFieldsAndElements(p_formid rasd_elements.formid%type) is
    re           rasd_elements%rowtype;
    v_elementid  rasd_elements.elementid%type;
    v_element1id rasd_elements.elementid%type;
    v_pelementid rasd_elements.elementid%type;
    n            pls_integer;
    i            pls_integer;
    j            pls_integer;
    v_hiddfieldid rasd_elements.elementid%type;
    v_blockid    rasd_blocks.blockid%type;
  begin
/*
  HTML
  HEAD
    
  BODY
    FORM 
    FONT (form_LAB)
       TABLE (block_TABLE)
         TR (block_BLOCK)
         CAPTION
           FONT (block_LAB)
          TD   
           FONT (blockfield_LAB)
     INPUT_ 
*/  
    --html
    begin
      select count(*)
        into n
        From rasd_elements
       where formid = p_formid
         and id = 'HTML';
      if n = 0 then
        v_elementid := getNextElementid(p_formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           type,
           id,
           nameid,
           endtagelementid)
        values
          (p_formid, v_elementid, 0, 1, 'HTML_', '', 'HTML', '', 0);
      end if;
    end;
    --head
    begin
      select count(*)
        into n
        From rasd_elements
       where formid = p_formid
         and elementid > 0 and id = 'HEAD';
      if n = 0 then
        select elementid
          into v_elementid
          From rasd_elements
         where formid = p_formid
           and elementid > 0 and id = 'HTML';
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           type,
           id,
           nameid,
           endtagelementid)
        values
          (p_formid,
           v_elementid + 1,
           v_elementid,
           1,
           'HEAD_',
           '',
           'HEAD',
           'HEAD',
           0);
      end if;
    end;
    --body
    begin
      select count(*)
        into n
        From rasd_elements
       where formid = p_formid
         and elementid > 0 and id = 'BODY';
      if n = 0 then
        select elementid
          into v_elementid
          From rasd_elements
         where formid = p_formid
           and elementid > 0 and id = 'HTML';
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           type,
           id,
           nameid,
           endtagelementid)
        values
          (p_formid,
           v_elementid + 14,
           v_elementid,
           1,
           'BODY_',
           '',
           'BODY',
           '',
           0);
      end if;
    end;
    --form
    for rf in (select * from rasd_forms where formid = p_formid) loop
      select count(*)
        into n
        from rasd_elements
       where formid = rf.formid
         and nameid = upper(rf.form)
         and elementid > 0;
      if n = 0 then
        --add tag on body
        re          := getElement(rf.formid, 'BODY_');
        v_elementid := getNextElementid(rf.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rf.formid,
           v_elementid,
           re.elementid,
           3,
           'FORM_',
           upper(rf.form),
           'F',
           upper(rf.form),
           0);
        --add body to form
        update rasd_elements
           set pelementid = v_elementid
         where formid = rf.formid
           and pelementid = re.elementid
           and element <> 'FORM_'
           and elementid > 0;
      else
        select elementid
          into v_elementid
          from rasd_elements
         where formid = rf.formid
           and nameid = upper(rf.form)
           and elementid > 0;
      end if;
      begin
        select elementid
          into v_elementid
          from rasd_elements
         where formid = rf.formid
           and nameid = upper(rf.form) || '_LAB'
           and rownum = 1
           and elementid > 0;
      exception
        when no_data_found then
          re          := getElement(rf.formid, 'FORM_');
          v_elementid := getNextElementid(rf.formid);
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rf.formid,
             v_elementid,
             re.pelementid,
             1,
             'FORM_LAB',
             upper(rf.form) || '_LAB',
             'F',
             upper(rf.form) || '_LAB',
             0);
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.pelementid,
           2,
           'FORM_MENU',
           upper(rf.form)||'_MENU',
           'F',
           upper(rf.form)||'_MENU',
           0);             
      end;
      -- add DIV to from
      select count(*)
        into n
        from rasd_elements
       where formid = rf.formid
         and element = 'FORM_DIV'
         and elementid > 0;
      if n = 0 then
      re          := getElement(rf.formid, 'FORM_');
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           3,
           'FORM_DIV',
           upper(rf.form)||'_DIV',
           'F',
           upper(rf.form)||'_DIV',
           0);
      re.elementid := v_elementid;
/*      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           1,
           'FORM_MENU',
           upper(rf.form)||'_MENU',
           'F',
           upper(rf.form)||'_MENU',
           0);*/           
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           1,
           'FORM_HEAD',
           upper(rf.form)||'_HEAD',
           'F',
           upper(rf.form)||'_HEAD',
           0);  
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           2,
           'FORM_BODY',
           upper(rf.form)||'_BODY',
           'F',
           upper(rf.form)||'_BODY',
           0);                      
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           9998,
           'FORM_'||rasd_engine11.c_message,
           upper(rf.form)||'_'||rasd_engine11.c_message,
           'F',
           upper(rf.form)||'_'||rasd_engine11.c_message,
           0);    
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           9996,
           'FORM_'||rasd_engine11.c_error,
           upper(rf.form)||'_'||rasd_engine11.c_error,
           'F',
           upper(rf.form)||'_'||rasd_engine11.c_error,
           0);    
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           9997,
           'FORM_'||rasd_engine11.c_warning,
           upper(rf.form)||'_'||rasd_engine11.c_warning,
           'F',
           upper(rf.form)||'_'||rasd_engine11.c_warning,
           0);                      
      v_elementid := getNextElementid(rf.formid);
      insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
       values
          (rf.formid,
           v_elementid,
           re.elementid,
           9999,
           'FORM_FOOTER',
           upper(rf.form)||'_FOOTER',
           'F',
           upper(rf.form)||'_FOOTER',
           0);           
       end if;                 
    end loop;
    --blocks
    i := 1;
    for rb in (select b.formid,
                      b.blockid,
                      b.label,
                      min(p.orderby) orderby,
                      b.numrows,
                      b.emptyrows,
                      b.pagingyn
                 from rasd_blocks b, rasd_fields p
                where b.formid = p_formid
                  and p.formid(+) = b.formid
                  and upper(p.blockid(+)) = upper(b.blockid)
                group by b.formid, b.blockid, b.label, b.numrows, b.emptyrows, b.pagingyn
                order by orderby) loop
      --blocks have just attribute id --> nameid
      --loop <%for i in ... %> controled from field
      select count(*)
        into n
        from rasd_elements
       where formid = rb.formid
         and nameid = upper(rb.blockid) || '_BLOCK'
         and elementid > 0;
         
        
      if n = 0 then
        re           := getElement(rb.formid, 'FORM_BODY');
        v_element1id := getNextElementid(rb.formid);
        
        -- BLOCK_DIV
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.elementid,
           re.orderby + 99 + i,
           'BLOCK_DIV',
           upper(rb.blockid) || '_DIV',
           'B',
           upper(rb.blockid) || '_DIV',
           0); 


        re. elementid  := v_element1id;
                
-- new label part on block
        begin
          select elementid
            into v_elementid
            from rasd_elements
           where formid = rb.formid
             and nameid = upper(rb.blockid) || '_LAB'
             and rownum = 1
             and elementid > 0;
        exception
          when no_data_found then          
               v_elementid := getNextElementid(rb.formid);              
               insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (re.formid,
                 v_elementid,
                 re.elementid,
                 1,
                 'CAPTION_',
                 '',
                 'L',
                 '',
                 0);
              v_element1id := v_elementid ;   
              v_elementid := getNextElementid(rb.formid);
              insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (re.formid,
                 v_elementid,
                 v_element1id,
                 1,
                 'FONT_',
                 upper(rb.blockid) || '_LAB',
                 'B',
                 upper(rb.blockid) || '_LAB',
                 0);
        end;
-- end new label part on block

        v_element1id := getNextElementid(rb.formid);

        -- BLOCK
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.elementid,
           re.orderby + 100 + i,
           decode(rb.numrows, 1 , 'TABLE_' , 'TABLE_N' ),
           upper(rb.blockid) || '_TABLE',
           '',
           upper(rb.blockid) || '_TABLE',
           0); --upper(rb.blockid)||'_TABLE'
        
--          
        v_elementid := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_elementid,
           v_element1id,
           3,
           'TR_',
           upper(rb.blockid) || '_BLOCK',
           'B',
           upper(rb.blockid) || '_BLOCK',
           0);


            begin
              select *
                into re
                from rasd_elements
               where formid = rb.formid
                 and nameid = upper(rb.blockid) || '_BLOCK'
                 and element = 'TR_'
                 and elementid > 0;

if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' then
  null;
else        
        v_element1id := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.pelementid,
           2,
           'THEAD_',
           upper(rb.blockid) || '_THEAD',
           '',
           upper(rb.blockid) || '_THEAD',
           0); 
end if;       
       
            exception
              when no_data_found then
                re           := getElement(rb.formid, 'FORM_DIV');

if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' then
  null;
else
         
        v_element1id := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.pelementid,
           2,
           'THEAD_',
           upper(rb.blockid) || '_THEAD',
           '',
           upper(rb.blockid) || '_THEAD',
           0);       
                       
end if;            
            end;

  

/*        begin
          select elementid
            into v_elementid
            from rasd_elements
           where formid = rb.formid
             and nameid = upper(rb.blockid) || '_LAB'
             and rownum = 1
             and elementid > 0;
        exception
          when no_data_found then
            begin
              select *
                into re
                from rasd_elements
               where formid = rb.formid
                 and nameid = upper(rb.blockid) || '_BLOCK'
                 and element = 'TR_'
                 and elementid > 0;
\* OLD Label on block
               v_element1id := getNextElementid(rb.formid);
               insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (re.formid,
                 v_element1id,
                 re.pelementid,
                 1,
                 'CAPTION_',
                 '',
                 'L',
                 '',
                 0);
                 
              v_elementid := getNextElementid(rb.formid);
              insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (re.formid,
                 v_elementid,
                 v_element1id,
                 1,
                 'FONT_',
                 upper(rb.blockid) || '_LAB',
                 'L',
                 upper(rb.blockid) || '_LAB',
                 0);
*\
if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' then
  null;
else        
        v_element1id := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.pelementid,
           2,
           'THEAD_',
           upper(rb.blockid) || '_THEAD',
           '',
           upper(rb.blockid) || '_THEAD',
           0); 
end if;       
       
            exception
              when no_data_found then
                re           := getElement(rb.formid, 'FORM_DIV');
\* OLD Label on block
                v_element1id := getNextElementid(rb.formid);
                insert into rasd_elements
                  (formid,
                   elementid,
                   pelementid,
                   orderby,
                   element,
                   nameid,
                   type,
                   id,
                   endtagelementid)
                values
                  (re.formid,
                   v_element1id,
                   re.pelementid,
                   1,
                   'CAPTION_',
                   '',
                   'L',
                   '',
                   0);
                v_elementid := getNextElementid(rb.formid);
                insert into rasd_elements
                  (formid,
                   elementid,
                   pelementid,
                   orderby,
                   element,
                   nameid,
                   type,
                   id,
                   endtagelementid)
                values
                  (re.formid,
                   v_elementid,
                   v_element1id,
                   1,
                   'FONT_',
                   upper(rb.blockid) || '_LAB',
                   'L',
                   upper(rb.blockid) || '_LAB',
                   0);
*\
if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' then
  null;
else
            
                    v_element1id := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_element1id,
           re.pelementid,
           2,
           'THEAD_',
           upper(rb.blockid) || '_THEAD',
           '',
           upper(rb.blockid) || '_THEAD',
           0);       
                       
end if;            
            end;

        end;
 */       
      end if;
      --label fields up
if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0  and nvl(rb.pagingyn,'N') = 'N' then
  null;
else      
      select count(*), min(pelementid)
        into n, v_pelementid
        from rasd_elements e, rasd_fields p
       where e.formid = p.formid
         and e.nameid = p.nameid || '_LAB'
         and p.formid = rb.formid
         and upper(p.blockid) = upper(rb.blockid)
         and p.elementyn = c_true
--         and nvl(p.element, 'INPUT_TEXT') <> 'INPUT_HIDDEN'
         and instr(nvl(p.element, 'INPUT_TEXT'), 'INPUT_HIDDEN') = 0
         and e.elementid > 0;
      if n = 0 then
        select *
          into re
          from rasd_elements
         where formid = rb.formid
           and nameid = upper(rb.blockid) || '_THEAD'
           and element = 'THEAD_'
           and elementid > 0;
        v_pelementid := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid, v_pelementid, re.elementid, 2, 'TR_', '', '', '', 0);
      end if;

      j := 1;
      for rp in (select *
                   from rasd_fields p
                  where formid = rb.formid
                    and upper(blockid) = upper(rb.blockid)
                    and elementyn = c_true
--                    and nvl(element, 'INPUT_TEXT') <> 'INPUT_HIDDEN'
                    and instr(nvl(element, 'INPUT_TEXT'), 'INPUT_HIDDEN') = 0                   
                    and not exists
                  (select 1
                           from rasd_elements
                          where formid = p.formid
                            and nameid = p.nameid || '_LAB'
                            and elementid > 0)
                  order by orderby) loop
        v_element1id := getNextElementid(rp.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid, v_element1id, v_pelementid, j, 'TX_', upper(rp.nameid) || '_TX_LAB', 'E', '', 0);
          
        v_elementid := getNextElementid(rp.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid,
           v_elementid,
           v_element1id,
           j,
           'FONT_',
           upper(rp.nameid) || '_LAB',
           'L',
           upper(rp.nameid) || '_LAB',
           0);
        j := j + 1;
        commit;
      end loop;
      
end if;      
      i := i + 10;
    end loop;
   
    
    --fields
        for rp in (select a.formid,
                      a.fieldid,
                      a.blockid,
                      a.type,
                      a.orderby,
                      a.format,
                      a.pkyn,
                      a.selectyn,
                      a.insertyn,
                      a.updateyn,
                      a.deleteyn,
                      a.insertnnyn,
                      a.notnullyn,
                      a.lockyn,
                      a.defaultval,
                      a.elementyn,
                      a.nameid,
                      a.label,
                      nvl(a.element, 'INPUT_TEXT')||decode(a.type,'D','D','') element,
                      a.linkid,
                      a.source,
                      a.hiddenyn,
                      a.rlobid,
                      a.rform,
                      a.rblockid,
                      a.rfieldid,
                      first_value(orderby) over(partition by formid, blockid order by orderby) orderbyblock                      
                 from rasd_fields a
                where formid = p_formid
                  and elementyn = c_true
                order by orderbyblock,
--                         decode(element, 'INPUT_HIDDEN', 1, 2),
                         decode(instr(nvl(element, 'INPUT_TEXT'), 'INPUT_HIDDEN'), 0 , 2, 1),
                         orderby) loop
      --    
      if v_blockid <> rp.blockid then
        v_hiddfieldid := null;
      end if;               
      v_blockid := rp.blockid;      
                         
      --element exists
      select count(*)
        into n
        from rasd_elements
       where formid = rp.formid
         and nameid = rp.nameid
         and elementid > 0;
      if n = 0 then
        --if field do not have block add field on form
        if rp.blockid is null then
          commit;
          if rp.element <> ('FONT_' ) then
          re          := getElement(rp.formid, 'FORM_HEAD');
          v_elementid := getNextElementid(rp.formid);          
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rp.formid,
             v_elementid,
             re.elementid,
             re.orderby + rp.orderby,
             rp.element,
             rp.nameid,
             'D',
             rp.nameid,
             decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
          end if;   
          -- form footer just buttons
          if rp.element in ('INPUT_SUBMIT' , 'INPUT_RESET' , 'INPUT_BUTTON','PLSQL_') then         
          re          := getElement(rp.formid, 'FORM_FOOTER');
          v_elementid := getNextElementid(rp.formid);
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rp.formid,
             v_elementid,
             re.elementid,
             re.orderby + rp.orderby,
             rp.element,
             rp.nameid,
             'D',
             rp.nameid,
             decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
          end if;
          -- form message just message field   
          if rp.element in ('FONT_' ) and rp.nameid = rasd_engine11.c_message then
          re          := getElement(rp.formid, 'FORM_'||rasd_engine11.c_message);
          v_elementid := getNextElementid(rp.formid);
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rp.formid,
             v_elementid,
             re.elementid,
             re.orderby + rp.orderby,
             rp.element,
             rp.nameid,
             'D',
             rp.nameid,
             decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
          end if;  
          if rp.element in ('FONT_' ) and rp.nameid = rasd_engine11.c_error then
          re          := getElement(rp.formid, 'FORM_'||rasd_engine11.c_error);
          v_elementid := getNextElementid(rp.formid);
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rp.formid,
             v_elementid,
             re.elementid,
             re.orderby + rp.orderby,
             rp.element,
             rp.nameid,
             'D',
             rp.nameid,
             decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
          end if;  
          if rp.element in ('FONT_' ) and rp.nameid = rasd_engine11.c_warning then
          re          := getElement(rp.formid, 'FORM_'||rasd_engine11.c_warning);
          v_elementid := getNextElementid(rp.formid);
          insert into rasd_elements
            (formid,
             elementid,
             pelementid,
             orderby,
             element,
             nameid,
             type,
             id,
             endtagelementid)
          values
            (rp.formid,
             v_elementid,
             re.elementid,
             re.orderby + rp.orderby,
             rp.element,
             rp.nameid,
             'D',
             rp.nameid,
             decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
          end if;                     
        else
          --field on block
          begin
            select *
              into re
              from rasd_elements
              where elementid in (
               select max(elementid) from rasd_elements
                where formid = rp.formid
                  and nameid like upper(rp.blockid) || '_BLOCK%'
                  and elementid > 0
              )
              and formid = rp.formid

               ;
            --v_pelementid := elementid;
            --element for block exists,
            --add default content of field on tag of block.
            
            if re.element = 'TR_' then
              --  tag blocka == TR => <td><field></td>
              if instr(rp.element ,'INPUT_HIDDEN') > 0 then               
                        
        if v_hiddfieldid is null then   
        v_element1id := re.elementid; --input hidden on TR!!!
              
        v_hiddfieldid := getNextElementid(rp.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rp.formid, v_hiddfieldid, v_element1id, 1 , 'HIDDFIELD_', rp.blockid, '', '', 0);                  
        v_element1id :=  v_hiddfieldid;

        end if;
              
              else

for rbx in (select formid
         from rasd_blocks
         where nvl(numrows, 1) = 1
           and nvl(emptyrows, 0) = 0
           and nvl(pagingyn,'N') = 'N'
           and formid = rp.formid
           and blockid = rp.blockid         
         ) loop
--if nvl(rb.numrows, 1) = 1  and nvl(rb.emptyrows, 0) = 0 and nvl(rb.pagingyn,'N') = 'N' then

        v_element1id := getNextElementid(rp.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rbx.formid, v_element1id, re.elementid,((rp.orderby * 2)-1) , 'TX_', upper(rp.nameid) || '_TX_LAB', 'E', '', 0);
        v_elementid := getNextElementid(rbx.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rbx.formid,
           v_elementid,
           v_element1id,
           1,
           'FONT_',
           upper(rp.nameid) || '_LAB',
           'L',
           upper(rp.nameid) || '_LAB',
           0);
           
--        create new TR  
declare
 v_xelementid rasd_elements.elementid%type;
begin
            select max(elementid)
            into  v_xelementid         
              from rasd_elements
             where formid = rp.formid
               and nameid = upper(rp.blockid) || '_TABLE'
               and elementid > 0;        
--          
        v_elementid := getNextElementid(rbx.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rp.formid,
           v_elementid,
           v_xelementid,
           (((rp.orderby * 2)-1) + 3),
           'TR_',
           upper(rp.blockid) || '_BLOCK'||(((rp.orderby * 2)-1) + 3),
           'B',
           '',
           0);

/* 
        v_pelementid := getNextElementid(rb.formid);
        insert into rasd_elements
          (formid,
           elementid,
           pelementid,
           orderby,
           element,
           nameid,
           type,
           id,
           endtagelementid)
        values
          (rb.formid, v_pelementid, re.elementid, 2, 'TR_', '', '', '', 0);
*/   
end;       
--end if;
end loop;

                v_element1id := getNextElementid(rp.formid);
                insert into rasd_elements
                  (formid,
                   elementid,
                   pelementid,
                   orderby,
                   element,
                   nameid,
                   type,
                   id,
                   endtagelementid)
                values
                  (rp.formid,
                   v_element1id,
                   re.elementid,
                   (rp.orderby * 2),
                   'TX_',-- Change from TD_
                   upper(rp.nameid)||'_TX',
                   'E',
                   null,--upper(rp.nameid),
                   0);
              end if;
              
              
              v_elementid := getNextElementid(rp.formid);
              insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (rp.formid,
                 v_elementid,
                 v_element1id,
                 1,
                 rp.element,
                 upper(rp.nameid),
                 'D',
                 upper(rp.nameid),
                 decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
                 
                 
                 
                 
            else
              --  tag blocks <> TR => <field>
              v_elementid := getNextElementid(rp.formid);
              insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (rp.formid,
                 v_elementid,
                 re.elementid,
                 rp.orderby,
                 rp.element,
                 upper(rp.nameid),
                 'D',
                 upper(rp.nameid),
                 decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
            end if;
          exception
            when no_data_found then
              --element for block do not exists, add field as first element on form
              re          := getElement(rp.formid, 'FORM_DIV');
              v_elementid := getNextElementid(rp.formid);
              insert into rasd_elements
                (formid,
                 elementid,
                 pelementid,
                 orderby,
                 element,
                 nameid,
                 type,
                 id,
                 endtagelementid)
              values
                (rp.formid,
                 v_elementid,
                 re.elementid,
                 rp.orderby,
                 rp.element,
                 upper(rp.nameid),
                 'D',
                 upper(rp.nameid),
                 decode(substr(rp.element, 1, 6), 'INPUT_', null, 0));
              re.elementid := v_elementid;
          end;
        end if;
      end if;
    end loop;
  
  
    
    --skriti elemente z nameid brez polja,blocka,forme, labele
    -- zakometiral, ker se v TABLE ni pokazal CLASS ....
    /*  for r in (
      select distinct rowid rid from rasd_elements a
      connect by formid = prior formid
             and pelementid = prior elementid
      start with formid = p_formid
        and nameid is not null
        and not exists (select 1 from rasd_fields
                        where formid = p_formid
                          and (nameid = a.nameid or
                               nameid||'_LAB' = a.nameid)
                          and elementdn = 'D')
        and not exists (select 1 from rasd_blocks
                        where formid = p_formid
                          and (upper(blockid)||'_block' = a.nameid or
                               upper(blockid)||'_LAB' = a.nameid))
        and not exists (select 1 from rasd_forms
                        where formid = p_formid
                          and (upper(form) = a.nameid or
                               upper(form)||'_LAB' = a.nameid)))
    loop
      update rasd_elements a set hiddenyn = 'D' where rowid = r.rid;
    end loop;*/
    --uskladi attribut
  
    for b in (select e.formid,
                     e.elementid,
                     p.nameid,
                     g.coreid,
                     g.element,
                     g.attribute,
                     g.type,
                     g.orderby,
                     g.text,
                     g.textid,
                     g.name,
                     replace(
                     replace(replace(replace(replace(replace(g.value, ':NAME', p.anameid
                                     ),
                                     ':VALUE',
                                     p.value
                                     ),
                             ':LINK',
                             decode(length(p.linkid) , 0 , '' , p.linkid)
                             ),
                             ':TYPE', 
                             p.type),
                             ':FORMAT',
                             replace(p.format,'''','')),
                             ':MAND',
                             decode(p.mand,'Y','rasdMandatory','')
                             ) value,
                     g.valueid,
                     g.hiddenyn,
                     g.source
                from rasd_elements e,
                     rasd_attributes_template g,
                     rasd_links l,
                     (select p.formid,
                             p.nameid nameid,
                             p.nameid||'_NAME' anameid,
                             decode(p.type , 'L' , '<% htpClob( '''||p.nameid||'_VALUE'' ); %>' , p.nameid||'_VALUE' ) value,
                             p.linkid linkjsid,
                             p.linkid, --||'_LINK' not tested jet
                             'D' elementtype,
                             nvl(p.element, 'INPUT_TEXT')||decode( nvl(p.element, 'INPUT_TEXT'), 'INPUT_TEXT' ,decode(p.type,'D','D',''),'') element,
                             p.type,
                             p.format,
                             p.notnullyn mand
                        from rasd_fields p
                      union
                      select formid,
                             nameid || '_LAB' nameid,
                             nameid || '_LAB' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'L' elementtype,
                             'FONT_' element,
                             '',
                             '',
                             ''
                        from rasd_fields
                      union
                      select formid,
                             upper(blockid) || '_BLOCK' nameid,
                             upper(blockid) || '_BLOCK' anameid,
                             '' value,
                             '' linkjsid,
                             '' linkid,
                             'B' elementtype,
                             'TR_' element,
                             '',
                             '',
                             ''
                        from rasd_blocks
                      union
                      select formid,
                             upper(blockid) || '_LAB' nameid,
                             upper(blockid) || '_LAB' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'B' elementtype,
                             'FONT_',
                             '',
                             '',
                             ''
                        from rasd_blocks
                      union
                      select formid,
                             upper(blockid)  nameid,
                             upper(blockid)  anameid,
                             decode(numrows,1,'1','<%=i'||upper(blockid)||'%>') value,
                             '' linkjsid,
                             '' linkid,
                             'E' elementtype,
                             'HIDDFIELD_',
                             '',
                             '',
                             ''
                        from rasd_blocks                       
                      union
                      select formid,
                             upper(blockid) || '_TABLE' nameid,
                             upper(blockid) || '_TABLE' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'E' elementtype,
                             decode(x.numrows, 1 , 'TABLE_', 'TABLE_N'),
                             '',
                             '',
                             ''
                        from rasd_blocks x
                      union
                      select formid,
                             upper(blockid) || '_DIV' nameid,
                             upper(blockid) || '_DIV' anameid,
                             'block' value,
                             '' linkjsid,
                             '' linkid,
                             'B' elementtype,
                             'BLOCK_DIV',
                             '',
                             '',
                             ''
                        from rasd_blocks
                      union
                      select formid,
                             upper(form) nameid,
                             upper(form) anameid,
                             '' value,
                             '' linkjsid,
                             program linkid,
                             'F' elementtype,
                             'FORM_',
                             '',
                             '',
                             ''
                        from rasd_forms
                      union
                      select formid,
                             upper(form) || '_LAB' nameid,
                             upper(form) || '_LAB' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_LAB',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             upper(form) || '_DIV' nameid,
                             upper(form) || '_DIV' anameid,
                             'form' value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_DIV',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             'TITLE_HEAD' nameid,
                             'TITLE_HEAD' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'TITLE_',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             'HEAD' nameid,
                             'HEAD' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'E' elementtype,
                             'HEAD_',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             upper(form) ||'_HEAD' nameid,
                             upper(form) ||'_HEAD' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_HEAD',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             upper(form) ||'_BODY' nameid,
                             upper(form) ||'_BODY' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_BODY',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union                        
                        select formid,
                             upper(form) ||'_FOOTER' nameid,
                             upper(form) ||'_FOOTER' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_FOOTER',
                             '',
                             '',
                             ''
                        from rasd_forms
                        union
                        select formid,
                             upper(form) ||'_'||rasd_engine11.c_message nameid,
                             upper(form) ||'_'||rasd_engine11.c_message anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_'||rasd_engine11.c_message,
                             '',
                             '',
                             ''
                        from rasd_forms                        
                        union
                        select formid,
                             upper(form) ||'_'||rasd_engine11.c_error nameid,
                             upper(form) ||'_'||rasd_engine11.c_error anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_'||rasd_engine11.c_error,
                             '',
                             '',
                             ''
                        from rasd_forms                        
                        union
                        select formid,
                             upper(form) ||'_'||rasd_engine11.c_warning nameid,
                             upper(form) ||'_'||rasd_engine11.c_warning anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_'||rasd_engine11.c_warning,
                             '',
                             '',
                             ''
                        from rasd_forms                        
                        union
                        select formid,
                             upper(form) ||'_MENU' nameid,
                             upper(form) ||'_MENU' anameid,
                             label value,
                             '' linkjsid,
                             '' linkid,
                             'F' elementtype,
                             'FORM_MENU',
                             '',
                             '',
                             ''
                        from rasd_forms  
                      union 
                      select formid,
                             nameid||'_TX'  nameid,
                             'rasdTx'||nameid||'_NAME'  anameid,
                             'rasdTx'||nameid||' rasdTxType'||f.type value,
                             '' linkjsid,
                             '' linkid,
                             'E' elementtype,
                             'TX_' element,
                             '',
                             '',
                             ''
                        from rasd_fields f
                      union 
                      select formid,
                             nameid||'_TX_LAB'  nameid,
                             'rasdTxLab'||nameid||''  anameid,
                             'rasdTxLab rasdTxLabBlock'||f.blockid||''  value,
                             '' linkjsid,
                             '' linkid,
                             'E' elementtype,
                             'TX_' element,
                             '',
                             '',
                             ''
                        from rasd_fields f                        
                        ) p
               where g.coreid = c_core
                 and g.elementtype = nvl(p.elementtype, 'E')
                 and g.element = nvl(p.element, e.element)
                 and p.formid(+) = e.formid
                 and p.nameid(+) = e.nameid
                 and e.formid = p_formid
                 and l.linkid(+) = p.linkid
                 and e.elementid > 0
                 ) loop
                 
      update rasd_attributes a
         set type        = b.type,
             text      = decode(nvl(a.source, 'G'), 'G', b.text, a.text),
             textid    = decode(nvl(a.source, 'G'), 'G', b.textid, a.textid),
             name        = b.name,
             value   = decode(nvl(a.source, 'G'),
                                 'G',
                                 b.value,
                                 a.value),
             valueid = decode(nvl(a.source, 'G'),
                                 'G',
                                 b.valueid,
                                 a.valueid)
             --       source = b.source,
             --hiddenyn = b.hiddenyn
       where (a.formid = b.formid and a.elementid = b.elementid and
             a.attribute = b.attribute);
      if sql%notfound then
        --  when matched then update set
        --  when not matched then
        insert into rasd_attributes
          (formid,
           elementid,
           orderby,
           attribute,
           type,
           text,
           textid,
           name,
           value,
           valueid,
           source,
           hiddenyn)
        values
          (b.formid,
           b.elementid,
           b.orderby,
           b.attribute,
           b.type,
           b.text,
           b.textid,
           b.name,
           b.value,
           b.valueid,
           b.source,
           b.hiddenyn);
      end if;
    end loop;
    -- update attributes manualy changed - elements < 0
    for rxx in (select a.formid, a.elementid, a.orderby, a.attribute, a.type, a.text, a.name, a.value,
                     a.valuecode, a.forloop, a.endloop, a.source, a.hiddenyn, a.valueid, 
                     a.textid, a.textcode, e.element, e.type etype, e.id, e.nameid from rasd_elements e, rasd_attributes a 
              where a.formid = p_formid
                and a.elementid = e.elementid
                and a.formid = e.formid
                and a.elementid < 0
                and nvl(a.source,'G') in ('V','R') ) loop

      declare
       v_rid rowid;
       v_elementid rasd_attributes.elementid%type;
      begin
             
      select rowid into v_rid   
      from rasd_attributes 
      where attribute = rxx.attribute
        and  type = rxx.type
        and  formid = p_formid
        and  elementid > 0
        and  elementid in (select elementid from rasd_elements 
                           where  formid = p_formid
                             and  element = rxx.element
                             and  id = rxx.id
                             and  elementid > 0
                             and  nameid = rxx.nameid 
                             and type = rxx.etype) ;     
        update rasd_attributes 
           set orderby = rxx.orderby,
               name = rxx.name,
               value = rxx.value,
               source = rxx.source,
               hiddenyn = rxx.hiddenyn
        where rowid = v_rid;
            
      exception when no_data_found then       
          begin
                          select elementid into v_elementid
                          from rasd_elements 
                           where  formid = p_formid
                             and  element = rxx.element
                             and  id = rxx.id
                             and  elementid > 0
                             and  nameid = rxx.nameid 
                             and type = rxx.etype;
          insert into rasd_attributes
            (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid)
          values
            (rxx.formid, v_elementid, rxx.orderby, rxx.attribute, rxx.type, rxx.text, rxx.name, rxx.value, rxx.valuecode, rxx.forloop, rxx.endloop, rxx.source, rxx.hiddenyn, rxx.valueid);
        exception when others then null;
        end;
      when others then null;
      end;          
    end loop;
    delete from rasd_attributes where formid= p_formid and elementid < 0;
    delete from rasd_elements where formid = p_formid and elementid < 0;

  end;

  function getElementBlock(p_formid  rasd_elements.formid%type,
                       p_element rasd_elements.element%type,
                       p_id rasd_elements.id%type default null)
    return rasd_elements.elementid%type is
    r rasd_elements.elementid%type;
  begin
    select e.elementid
      into r
      from rasd_elements e
     where formid = p_formid
       and element = p_element
       and (id = p_id or p_id is null)
       and elementid > 0;
    return(r);
  exception when others then
    return null;
  end;

  function getElementBlockField(p_formid     in rasd_elements.formid%type,
                   p_pelementid in rasd_elements.elementid%type,
                   p_blockid    in rasd_elements.nameid%type)
    return rasd_elements.elementid%type is
    v_pelementid rasd_elements.elementid%type;
    v_elementid  rasd_elements.elementid%type;
    v_nameid      rasd_elements.nameid%type;
  begin
    v_pelementid := p_pelementid;
    loop
      begin
        select elementid, pelementid, nameid
          into v_elementid, v_pelementid, v_nameid
          from rasd_elements
         where formid = p_formid
           and elementid = v_pelementid;
        if v_nameid = upper(p_blockid) || '_BLOCK' then
          exit;
        end if;
      exception
        when no_data_found then
          --if block is not parent of element field then it is field
          v_elementid := null;
          exit;
      end;
    end loop;
    return v_elementid;
  end;

  procedure changeNameid2Valuecode(p_formid in rasd_forms.formid%type,
                           p_text  in out varchar2) is
    i      pls_integer;
    n      pls_integer;
    v_text varchar2(4000) := upper(p_text);
  begin
    for r in (select nameid name, length(name) length, valuetochar valuecode --before valuecode
                from RASD_VW_FIELDS
               where formid = p_formid
                 and v_text like '%' || nameid || '%' --before iz vas name but in case when nameid is diffenrent there were problems
               order by length desc, name) loop
      i := 1;
      loop
        i := instr(v_text, r.name, i);
        exit when i = 0;
        select count(*)
          into n
          from rasd_fields
         where formid = p_formid
           and blockid || fieldid is not null
           and blockid || fieldid like '%' || r.name || '%'
           and blockid || fieldid <> r.name
           and blockid || fieldid =
               substr(v_text,
                      i - instr(upper(blockid || fieldid), r.name, 1, 1) + 1,
                      length(blockid || fieldid));
        if n = 0 and substr(p_text, i - 1, 1) in
           (' ',
                      '=',
                      '*',
                      ';',
                      '/',
                      '|',
                      '<',
                      '>',
                      '-',
                      substr(c_nl, -1, 1)) then
          --change nameid 2 valuecode
          p_text := substr(p_text, 1, i - 1) || r.valuecode ||
                     substr(p_text, i + r.length);
        end if;
        i := i + r.length;
      end loop;
    end loop;
  end;

  procedure changeNameid2PLSQL(p_formid in rasd_forms.formid%type, p_blockid in rasd_blocks.blockid%type,
                           p_text  in out varchar2) is
    i       pls_integer := 1;
    imax    pls_integer := 1;
    v_plsql varchar2(5000);
  begin
    i    := 1;
    imax := 1;
    loop
      i := instr(p_text, '<%', imax);
      exit when i = 0;
      imax := instr(p_text, '%>', i);
      if instr(substr(p_text,i+2,imax-(i+2)), '<%') > 0 then
         imax := instr(p_text, '%>', -1);
      end if;
      exit when imax = 0;
      if substr(p_text, i + 2, 1) = '=' then
        v_plsql := substr(p_text, i + 3, imax - (i + 3));
        v_plsql := replace(
          rasd_engine11.transformPLSQL(p_formid, p_blockid,v_plsql),'(i__)','(i'||p_blockid||')'
          );
        --changeNameid2Valuecode(p_formid, v_plsql);
        p_text := substr(p_text, 1, i - 1) || '''||' || v_plsql || '||''' ||
                   substr(p_text, imax + 2);
      else
        v_plsql := substr(p_text, i + 2, imax - (i + 2));
        v_plsql := replace(
           rasd_engine11.transformPLSQL(p_formid,p_blockid,v_plsql),'(i__)','(i'||p_blockid||')'
           );
        --changeNameid2Valuecode(p_formid, v_plsql);
        p_text := substr(p_text, 1, i - 1) || '''); ' || v_plsql ||
                   ' 
htp.prn(''' || substr(p_text, imax + 2);
      end if;
      imax := i+2;
    end loop;
  end;

  procedure sincValuecode(p_formid in rasd_forms.formid%type) is
    v_txt varchar2(10000);
    function setNameValue(v_value varchar2, p_formid in rasd_forms.formid%type, v_elementid rasd_elements.elementid%type ) return varchar2 is
      v_vtxt varchar2(10000) := v_value;
      v_eid rasd_elements.id%type;
      v_eelement  rasd_elements.element%type;
    begin
        select e.element, e.id into v_eelement, v_eid
        from rasd_elements e
        where e.formid = p_formid
          and e.elementid = v_elementid;
     
        for r in (select * from rasd_vw_fields p 
                 where instr(v_vtxt, p.nameid ) > 0
                   and p.formid = p_formid
                  order by length(p.nameid) desc 
                  ) loop

          if  v_eelement = 'PLSQL_' then

          v_vtxt :=  replace (
                     replace (v_vtxt, r.nameid||'_VALUE',  r.valuetochar )
                                   , r.nameid||'_NAME' , nvl(r.namecode, v_eid) );

          else

          v_vtxt :=  replace (
                     replace (v_vtxt, r.nameid||'_VALUE', '''||' || r.valuetochar || '||''')
                                   , r.nameid||'_NAME' , nvl(r.namecode, v_eid) );
          end if;
        end loop;   
        return v_vtxt;   
    end;
  begin
    --type S,E
    update rasd_attributes a
       set valuecode = value, textcode = text
    --  nameplsql = name
     where a.formid = p_formid;
    --    and a.type <> 'A';
    --type A
    update rasd_attributes a
       set valuecode =
           (select decode(a.value,
                          null,
                          null,
                          decode(a.type, 'A', '="', null)) ||
                   decode(a.attribute,
                          'A_NAME',
                          decode(a.value, null, null, e.id),
                          'A_ID',
                          decode(a.value, null, null, e.id),
                          a.value                         
                          ) ||                          
                   decode(a.value,
                          null,
                          null,
                          decode(a.type, 'A', '"', null)) valuecode
              from rasd_elements e
             where e.formid = a.formid
               and e.elementid = a.elementid)
     where a.formid = p_formid
       and a.type in ('A');
    --type a: id, name, value=nameid

    declare
     v_t varchar2(5000);
    begin 
       for r in (select rowid rid, value, type, elementid from rasd_attributes a
         where a.formid = p_formid
       and a.type in ('A', 'V', 'E') 
       and exists (select 1
              from rasd_fields
             where formid = a.formid
               and instr(a.value , nameid)>0 )      
                ) loop         
          v_t :=  setNameValue(r.value , p_formid , r.elementid );
          
          if r.type = 'A' then
             v_t := '="' || v_t || '"';         
          end if; 
          
          update rasd_attributes a 
             set valuecode = v_t
          where a.rowid = r.rid;      
                
       end loop;         
    end; 

   
    /*update rasd_attributes a
       set valuecode =
           (select decode(a.type, 'A', '="', null) ||
                   /*decode(a.attribute,
                          'A_NAME',
                          decode(a.value,
                                 null,
                                 null,
                                 nvl(p.namecode, e.id)),
                          'A_ID',
                          decode(a.value,
                                 null,
                                 null,
                                 nvl(p.namecode, e.id)),
                          decode(upper(a.value),
                                 p.nameid,
                                 '''||' || p.valuetochar || '||''')                                 
                                 )** 
                        setNameValue(a.value , a.formid , e.id)                                          
                                 || --before valuecode
                   decode(a.type, 'A', '"', null) valuecode
              from --rasd_vw_fields p, 
                   rasd_elements e
             where --p.formid(+) = a.formid
               --and p.nameid(+) = a.value
               --and 
                   e.formid = a.formid
               and e.elementid = a.elementid)
     where a.formid = p_formid
       and a.type in ('A', 'V') 
       and exists (select 1
              from rasd_fields
             where formid = a.formid
               and nameid = a.value);*/
    --links; linkid v values must be in upercases!!!!!!!!!!!

    
    update rasd_attributes a
       set valuecode =
            (
--XXSTART            
            select decode(decode(nvl(l.type, 'U'), 'U', 'U', 'F', 'U', 'S'),
                          'S',
                          decode(a.type, 'A', '="', null) ||
                          decode(upper(a.value),
                                 upper(l.linkid),
                                 '''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )|| l.linkid || '(' ||
                                 nvl(p.valuetochar, '''''') || ',''' || 
                                 p.namecode || '''); 
htp.prn(''',
                                 a.value) ||
                          decode(a.type, 'A', '"', null),
                          'U',
                          decode(p.element,
                          'INPUT_SUBMIT',
decode( nvl(length(jslinkvalue),0), 0,
                               '="javascript: ''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                nvl(l.linkid, '''''') || '(' ||
                                p.valuetochar || ',''' || p.namecode || 
                                '''); 
htp.prn('''||replace(a.value, l.linkid||'#')||'"' ,
                               '="javascript: '||replace(replace(jslinkvalue,'''',''''), '#GC#',
                               ' ''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                nvl(l.linkid, '''''') || '(' ||
                                p.valuetochar || ',''' || p.namecode || 
                                '''); 
htp.prn('''||replace(a.value, l.linkid||'#') ) ||'"'
                         
)
                          ,
                          decode(instr(upper(a.value), upper(l.linkid)),
                                 0,
                                 replace(a.valuecode,
                                         l.linkid,
                                         '''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )|| l.linkid || '(' ||
                                         nvl(p.valuetochar, '''''') || ',''' || 
                                         p.namecode || '''); 
htp.prn('''),
                                 decode(l.location,
                                        'N',
                                        decode ( nvl(length(jslinkvalue),0), 0,
                                        '="javascript: var link=window.open(encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn(''),''''x1'''',''''resizable,scrollbars,width=680,height=550'''');"',
                                        '="javascript:'||replace(replace(jslinkvalue,'''',''''''), '#GC#',
                                        ' var link=window.open(encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn(''),''''x1'''',''''resizable,scrollbars,width=680,height=550'''');')||'"'
)
                                        ,
                                        'I',
                                        decode ( nvl(length(jslinkvalue),0), 0,
                                        '="javascript: location=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');"'                           ,
                                        '="javascript: '||
                                        replace(replace(jslinkvalue,'''',''''''), '#GC#',                                         
                                        'location=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');')||'"'                            
                                        )
)
                                 ))) valuecodex--, length(jslinkvalue) hh
              from rasd_links l, rasd_elements e, rasd_vw_fields p,
                   (select max(value) jslinkvalue, t.linkid, t.formid from RASD_LINK_PARAMS t where fieldid = '#JSLINK#' group by formid, linkid) jslink
             where l.formid = a.formid
               and e.formid = a.formid
               and e.elementid = a.elementid
               and p.formid(+) = e.formid
               and p.nameid(+) = e.nameid
               and l.formid = jslink.formid(+)
               and l.linkid = jslink.linkid(+)
               and instr(upper('#'||a.value||'#'), upper('#'||l.linkid||'#')) <> 0
               and upper(substr(a.value,
                                instr(upper(a.value), upper(l.linkid)) - 3,
                                3)) <> 'JS_'
--XXEND                                
                                )                             
     where a.formid = p_formid
       and a.type in ('A', 'V' )
       and exists
     (select 1
              from rasd_links l
             where l.formid = a.formid
               and instr(upper('#'||a.value||'#'), upper('#'||l.linkid||'#')) <> 0
               and upper(substr(a.value,
                                instr(upper(a.value), upper(l.linkid)) - 3,
                                3)) <> 'JS_');
--DYNAMIC FIELDS
    update rasd_attributes a
       set valuecode = 
            (select replace (a.valuecode, '%'||l.linkid||'%' ,
                          decode(decode(nvl(l.type, 'U'), 'U', 'U', 'F', 'U', 'S'),
                          'S',
                          decode(instr(upper(a.value),upper(l.linkid)),
                                 0,
                                 a.value,                                 
                                 '''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )|| l.linkid || '(' ||
                                 nvl(p.valuetochar, '''''') || ',''' || 
                                 p.namecode || '''); 
htp.prn(''') 
                                 ,
                          'U',
                          decode(p.element,
                          'INPUT_SUBMIT',
decode( nvl(length(jslinkvalue),0), 0,
                               'javascript: ''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                nvl(l.linkid, '''''') || '(' ||
                                p.valuetochar || ',''' || p.namecode || 
                                '''); 
htp.prn('''||replace(a.value, l.linkid||'#')||'"' ,
                               'javascript: '||replace(replace(jslinkvalue,'''',''''), '#GC#',
                               ' ''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                nvl(l.linkid, '''''') || '(' ||
                                p.valuetochar || ',''' || p.namecode || 
                                '''); 
htp.prn('''||replace(a.value, l.linkid||'#') ) 
                         
)
                          ,
                          decode(instr(upper(a.value), upper(l.linkid)),
                                 0,
                                 replace(a.valuecode,
                                         l.linkid,
                                         '''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )|| l.linkid || '(' ||
                                         nvl(p.valuetochar, '''''') || ',''' || 
                                         p.namecode || '''); 
htp.prn('''),
                                 decode(l.location,
                                        'N',
                                        decode ( nvl(length(jslinkvalue),0), 0,
                                        'var _rasd_url_type='''''||decode(l.type, 'S', 'LOV', 'T', 'LOV', 'C','LOV', 'LINK')||''''';'||
                                        'var _rasd_url_loc='''''||decode(l.type, 'S', 'N', 'T', 'N', 'C','N', nvl(l.location,'N') )||''''';'||
                                        'var _rasd_link_url=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');'
--htp.prn('');var link=window.open(_rasd_link_url,''''x1'''',''''resizable,scrollbars,width=680,height=550'''');'
,
                                        ''||replace(replace(jslinkvalue,'''',''''''), '#GC#',
                                        'var _rasd_url_type='''''||decode(l.type, 'S', 'LOV', 'T', 'LOV', 'C','LOV', 'LINK')||''''';'||
                                        'var _rasd_url_loc='''''||decode(l.type, 'S', 'N', 'T', 'N', 'C','N', nvl(l.location,'N') )||''''';'||
                                        'var _rasd_link_url=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');'
--htp.prn('');var link=window.open(_rasd_link_url,''''x1'''',''''resizable,scrollbars,width=680,height=550'''');'
)
)
                                        ,
                                        'I',
                                        decode ( nvl(length(jslinkvalue),0), 0,
                                        'var _rasd_url_type='''''||decode(l.type, 'S', 'LOV', 'T', 'LOV', 'C','LOV', 'LINK')||''''';'||
                                        'var _rasd_url_loc='''''||decode(l.type, 'S', 'N', 'T', 'N', 'C','N', nvl(l.location,'N') )||''''';'||
                                        'var _rasd_link_url=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');'
--htp.prn(''); location=_rasd_link_url;' 
                          ,
                                        ''||
                                        replace(replace(jslinkvalue,'''',''''''), '#GC#',                                         
                                        'var _rasd_url_type='''''||decode(l.type, 'S', 'LOV', 'T', 'LOV', 'C','LOV', 'LINK')||''''';'||
                                        'var _rasd_url_loc='''''||decode(l.type, 'S', 'N', 'T', 'N', 'C','N', nvl(l.location,'N') )||''''';'||
                                        'var _rasd_link_url=encodeURI(''); js_' || decode(p.element, 'FONT_RADIO', 'R', 'SELECT_', 'S', 'INPUT_CHECKBOX' , 'C' )||
                                        nvl(l.linkid, '''''') || '(' ||
                                        p.valuetochar || ',''' || p.namecode || 
                                        '''); 
htp.prn('');'
--htp.prn(''); location=_rasd_link_url;' 
)
                                        )
)
                                 ))) ) valuecodex--, length(jslinkvalue) hh
              from rasd_links l, rasd_elements e, rasd_vw_fields p,
                   (select max(value) jslinkvalue, t.linkid, t.formid from RASD_LINK_PARAMS t where fieldid = '#JSLINK#' group by formid, linkid) jslink
             where l.formid = a.formid
               and e.formid = a.formid
               and e.elementid = a.elementid
               and e.element like 'DYNAMICFIELD_%'   
               and p.formid(+) = e.formid
               and p.nameid(+) = e.nameid
               and l.formid = jslink.formid(+)
               and l.linkid = jslink.linkid(+)
               and instr(upper(a.value), upper('%'||l.linkid||'%')) <> 0
               and upper(substr(a.value,
                                instr(upper(a.value), upper(l.linkid)) - 3,
                                3)) <> 'JS_')                             
--
     where a.formid = p_formid
       and a.type in ('A', 'V')
       and exists (
       select 1 from rasd_elements e
       where e.formid = a.formid
       and e.elementid = a.elementid
       and e.element like 'DYNAMICFIELD_%'       
       )       
       and exists
     (select 1
              from rasd_links l
             where l.formid = a.formid
               and instr(upper(a.value), upper('%'||l.linkid||'%')) <> 0
               and upper(substr(a.value,
                                instr(upper(a.value), upper(l.linkid)) - 3,
                                3)) <> 'JS_');


update rasd_attributes a
set  valuecode = replace(valuecode ,'%%' , 'var _rasd_url_type=''''''''; var _rasd_url_loc=''''''''; var _rasd_link_url='''''''';' )
where a.formid = p_formid
       and a.type in ('A', 'V')
       and instr(value, '_rasd_link_url') > 0
       and instr(value, '%%') > 0
       and instr(value, '_rasd_link_url') > instr(value, '%%')
       and exists (
       select 1 from rasd_elements e
       where e.formid = a.formid
       and e.elementid = a.elementid
       and e.element like 'DYNAMICFIELD_%'       
      );
      
      

    update rasd_attributes a
       set valuecode = '="'||substr(valuecode,4),                             
           value = substr(value,2)                              
    where a.formid = p_formid
      and a.type in ('A', 'V')  
      and substr(value , 1, 1 ) = '#';

  -- updates values of <%= and <% -> PL/SQL CODE
    for r in (select a.rowid rid, a.textcode , f.blockid , f.element
                from rasd_attributes a, rasd_elements e, rasd_vw_fields f
               where a.formid = p_formid
                 and a.textcode like '%<#%%' escape '#'
                 and a.elementid = e.elementid
                 and a.formid = e.formid
                 and e.formid = f.formid(+)
                 and e.nameid = f.nameid(+)) loop
      v_txt := r.textcode;
      changeNameid2PLSQL(p_formid, r.blockid,  v_txt);
      update rasd_attributes set textcode = v_txt where rowid = r.rid;
    end loop;
    for r in (select a.rowid rid, a.valuecode , f.blockid , f.element
                from rasd_attributes a, rasd_elements e, rasd_vw_fields f
               where a.formid = p_formid
                 and a.valuecode like '%<#%%' escape '#'
                 and a.elementid = e.elementid
                 and a.formid = e.formid
                 and e.formid = f.formid(+)
                 and e.nameid = f.nameid(+)) loop
      v_txt := r.valuecode;
      changeNameid2PLSQL(p_formid, r.blockid,  v_txt);
      update rasd_attributes set valuecode = v_txt where rowid = r.rid;
    end loop;
 
   --update for dinamic pages on form elements

   for r in (
select a.rowid rid, p.nameid, 


     decode(a.type,'S',''');  
if  ShowField'||p.nameid||'  then  
htp.prn(''')||nvl(a.name,a.valuecode) name,

    decode(a.name, null ,

decode(a.type,'S', ''');  end if;  
htp.prn(''' ,'')     
,    
   a.valuecode||decode(a.type,'S',decode(a.valuecode,'/>',''');  end if;  
htp.prn(''',''), ''');  end if;  
htp.prn(''')
)
  valuecode
from RASD_ELEMENTS n, RASD_ELEMENTS p, rasd_attributes a
where n.formid = p_formid and n.element in ('FORM_HEAD','FORM_FOOTER')
  and p.formid = n.formid
  and n.elementid = p.pelementid
--  and p.element not in ('INPUT_HIDDEN')
  and instr(p.element, 'INPUT_HIDDEN') = 0  
  and p.elementid = a.elementid
  and p.formid = a.formid
  and a.type in ('S','E')
  and a.valuecode is not null     
     ) loop
  
      update rasd_attributes set name = r.name, valuecode = r.valuecode where rowid = r.rid;
  
    end loop;   

    
  end;

  procedure sincForLoop(p_formid rasd_elements.formid%type) is
  begin
    for r in (select *
                from (select e.formid,
                             e.elementid,
                             'P' source,
                             decode(p.blockid,
                                    null,
                                    '',
                                    decode(rasd_engineHTML10.getElementBlockField(p.formid,
                                                                e.pelementid,
                                                                p.blockid),
                                           null,
                                           decode(nvl(b.numrows, 1),
                                                  1,
                                                  decode(nvl(b.emptyrows, 0),
                                                         0,
                                                         '',
                                                         '''); for i' ||
                                                         p.blockid || ' in 1..' ||
                                                         p.blockid || p.fieldid ||
                                                         '.count loop 
htp.prn('''),
                                                  '''); for i' || p.blockid ||
                                                  ' in 1..' || p.blockid ||
                                                  p.fieldid ||
                                                  '.count loop 
htp.prn('''),
                                           '')) forloop,
                             decode(p.blockid,
                                    null,
                                    '',
                                    decode(rasd_engineHTML10.getElementBlockField(p.formid,
                                                                e.pelementid,
                                                                p.blockid),
                                           null,
                                           decode(nvl(b.numrows, 1),
                                                  1,
                                                  decode(nvl(b.emptyrows, 0),
                                                         0,
                                                         '',
                                                         '''); end loop; 
htp.prn('''),
                                                  '''); end loop; 
htp.prn('''),
                                           '')) endloop
                        from rasd_fields p, rasd_blocks b, rasd_elements e
                       where p.formid = e.formid
                         and p.nameid = e.nameid
                         and b.formid = p.formid
                         and b.blockid = p.blockid
                         and nvl(b.numrows, 1) + nvl(b.emptyrows, 0) <> 1
                         and e.formid = p_formid
                      union
                      select e.formid,
                             e.elementid,
                             'B' source,
                             decode(nvl(b.numrows, 1),
                                    1,
                                    decode(nvl(b.emptyrows, 0),
                                           0,
                                           '',
                                           '''); for i' || p.blockid ||
                                           ' in 1..' || p.fieldid ||
                                           '.count loop 
htp.prn('''),
                                    '''); for i' || p.blockid || ' in 1..' ||
                                    p.fieldid || '.count loop 
htp.prn(''') forloop,
                             decode(nvl(b.numrows, 1),
                                    1,
                                    decode(nvl(b.emptyrows, 0),
                                           0,
                                           '',
                                           '''); end loop; 
htp.prn('''),
                                    '''); end loop; 
htp.prn(''') endloop
                        from (select formid,
                                     blockid,
                                     min(blockid || fieldid) keep(dense_rank first order by decode(selectyn,'Y',0,1), orderby, --added order 6.2.2018
                                                                                            length(blockid || fieldid), blockid || fieldid) fieldid
                                from rasd_fields
                               group by formid, blockid) p,
                             rasd_blocks b,
                             rasd_elements e
                       where b.formid = e.formid
                         and upper(b.blockid) || '_BLOCK' = e.nameid
                         --and nvl(b.numrows, 1) + nvl(b.emptyrows, 0) <> 1 Commented because othervise we ned to change fields type prom record -> B10FIELD ctab -> B10FIELD varchar2(..)
                         and p.formid = b.formid
                         and p.blockid = b.blockid
                         and e.formid = p_formid)
               where forloop is not null) loop
      update rasd_attributes
         set forloop = r.forloop
       where formid = r.formid
         and elementid = r.elementid
         and attribute = 'S_';
      update rasd_attributes
         set endloop = r.endloop
       where formid = r.formid
         and elementid = r.elementid
         and attribute = 'E_'
         and hiddenyn = 'N';
      if sql%notfound then
        --element with no tag must not be in rasd_attributes or must be hidden
        update rasd_attributes
           set endloop = r.endloop
         where formid = r.formid
           and elementid = r.elementid
           and attribute = 'S_';
      end if;
    end loop;
  end;

  procedure sincIncludevis(p_formid rasd_elements.formid%type) is
    v_ev rasd_attributes.value%type;
    v_evc rasd_attributes.valuecode%type;
begin
update rasd_elements e set e.includevis = c_true
where e.formid = p_formid and (
e.nameid in (select nameid from rasd_fields f where f.formid = e.formid and f.includevis = c_true)
or e.nameid in (select nameid||'_LAB' from rasd_fields f, rasd_blocks b where f.formid = b.formid and f.blockid = b.blockid and f.formid = e.formid and f.includevis = c_true and nvl(b.numrows,1) = 1)
);

for v in (
select '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.visible then htp.p('''||a.name svaluecode,
       '<% if '||f.blockid||f.fieldid  ||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.visible then %>'||a.name svalue,
       
       decode(INSTR(a.value,'/>'),0,A.VALUE,a.value||'<% end if; %>') cvalue,
       decode(INSTR(a.valuecode,'/>'),0,a.VALUECODE,a.valuecode||'''); end if; htp.p(''') cvaluecode,
       
       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.readonly then htp.p('' readonly="readonly"''); end if; htp.p(''' rvaluecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.readonly then htp.p('' readonly="readonly"''); end if; %>' rvalue,
       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.disabled then htp.p('' disabled="disabled"''); end if; htp.p(''' dvaluecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.disabled then htp.p('' disabled="disabled"''); end if; %>' dvalue,       
       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.required then htp.p('' required="required"''); end if; htp.p(''' qvaluecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.required then htp.p('' required="required"''); end if; %>' qvalue,       
       '''); htp.p('||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.custom); htp.p(''' tvaluecode,
         '<% htp.p('||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.custom); %>' tvalue,       

       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error is not null then htp.p('' title="''||'||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error||''"''); end if; htp.p(''' e1valuecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error is not null then htp.p('' title="''||'||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error||''"''); end if; %>' e1value,
       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error is not null then htp.p('' errorField''); end if; htp.p(''' eclass1valuecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.error is not null then htp.p('' errorField''); end if; %>' eclass1value,


       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info is not null then htp.p('' title="''||'||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info||''"''); end if; htp.p(''' i1valuecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info is not null then htp.p('' title="''||'||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info||''"''); end if; %>' i1value,
       '''); if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info is not null then htp.p('' infoField''); end if; htp.p(''' iclass1valuecode,
         '<% if '||f.blockid||f.fieldid||'#SET'||decode(nvl(f.numrows,-1),-1, '', 1 , '(1)' , '(i'||f.blockid||')'  )||'.info is not null then htp.p('' infoField''); end if; %>' iclass1value,

       a.* ,
       f.fieldid,
       f.blockid,
       decode (e.nameid ,  f.nameid||'_LAB' , 'LABEL', 'NOT_LABEL') label
from rasd_elements e, rasd_attributes a, rasd_vw_fields f
where e.formid = p_formid
  and e.includevis = c_true
  and e.elementid = a.elementid
  and e.formid = a.formid
  and a.type = 'S'
  and f.formid = e.formid
--  and e.nameid = f.nameid
  and (e.nameid = f.nameid or e.nameid = f.nameid||'_LAB')
  and a.name is not null
) loop

delete from rasd_attributes a where a.formid = v.formid and a.elementid = v.elementid and a.type = v.type;
delete from rasd_attributes a where a.formid = v.formid and a.elementid = v.elementid and a.type = 'C';
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, v.orderby, v.attribute, v.type, v.text, '', v.svalue, v.svaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
 
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 999, 'C_', 'C', v.text, '', v.cvalue, v.cvaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);


if v.label = 'NOT_LABEL' then -- is not a label

insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.rvalue, v.rvaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.dvalue, v.dvaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.qvalue, v.qvaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.tvalue, v.tvaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);


insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.e1value, v.e1valuecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);

insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, 998, 'C_', 'C', v.text, '', v.i1value, v.i1valuecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);

update rasd_attributes set
 value = value || v.eclass1value || v.iclass1value,
 valuecode =   valuecode || v.eclass1valuecode || v.iclass1valuecode
where formid = v.formid  and elementid = v.elementid and attribute = 'A_CLASS';

end if;

end loop;

for v in (
select a.name||a.value||'''); end if; htp.p(''' evaluecode,
       a.name||a.value||'<% end if; %>' evalue,
       value cvalue,
       value cvaluecode,
       a.* ,
       f.fieldid,
       f.blockid
from rasd_elements e, rasd_attributes a, rasd_vw_fields f
where e.formid = p_formid
  and e.includevis = c_true
  and e.elementid = a.elementid
  and e.formid = a.formid
  and a.type = 'E'
  and f.formid = e.formid
--  and e.nameid = f.nameid
  and (e.nameid = f.nameid or e.nameid = f.nameid||'_LAB')
  and a.name is not null
) loop

delete from rasd_attributes a where a.formid = v.formid and a.elementid = v.elementid and a.type = v.type;
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, v.orderby, v.attribute, v.type, v.text, '', v.evalue, v.evaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
end loop;


for v in (
select a.name||a.value||'''); end if; htp.p(''' evaluecode,
       a.name||a.value||'<% end if; %>' evalue,
       value cvalue,
       value cvaluecode,
       a.* ,
       f.fieldid,
       f.blockid
from rasd_elements e, rasd_attributes a, rasd_vw_fields f
where e.formid = p_formid
  and e.includevis = c_true
  and e.elementid = a.elementid
  and e.formid = a.formid
  and a.type = 'E'
  and f.formid = e.formid
--  and e.nameid = f.nameid  
  and (e.nameid = f.nameid or e.nameid = f.nameid||'_LAB')
  and a.name is not null
) loop

delete from rasd_attributes a where a.formid = v.formid and a.elementid = v.elementid and a.type = v.type;
insert into rasd_attributes
  (formid, elementid, orderby, attribute, type, text, name, value, valuecode, forloop, endloop, source, hiddenyn, valueid, textid, textcode, rlobid, rform, rid)
values
  (v.formid, v.elementid, v.orderby, v.attribute, v.type, v.text, '', v.evalue, v.evaluecode, v.forloop, v.endloop, v.source, v.hiddenyn, v.valueid, v.textid, v.textcode, v.rlobid, v.rform, v.rid);
end loop;

for rx  in (
select formid, elementid from (
select formid, elementid, count(*) st
from rasd_attributes a 
where a.formid = p_formid 
and (type = 'E' or (type = 'C' and value = '<% end if; %>'  and orderby = 999) )
group by  formid, elementid
)
where st = 2
) loop

v_ev  := null;
v_evc := null;

for r in (
select *
from rasd_attributes a 
where a.formid = rx.formid 
and elementid in rx.elementid
and (type = 'E' or (type = 'C' and value = '<% end if; %>' and orderby = 999) )
order by type
) loop

if r.type = 'C' then
v_ev := r.value;
v_evc := r.valuecode;

update rasd_attributes a set value = '', valuecode = '' 
where a.formid = r.formid and a.elementid = r.elementid and a.type = r.type and a.orderby = r.orderby;

elsif r.type = 'E' then 
  
update rasd_attributes a set value = value||v_ev, valuecode = valuecode|| v_evc
where a.formid = r.formid and a.elementid = r.elementid and a.type = r.type and a.orderby = r.orderby;


end if; 

end loop;

end loop;


end;    
  
  procedure writePrepareHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2) is
  begin
    for r in (select * from rasd_forms x where x.formid = p_formid and x.autodeletehtmlyn = 'Y') loop   
        delete from rasd_elements t where t.formid = r.formid and not exists (select 1 from rasd_attributes a where a.formid = r.formid and a.elementid = t.elementid and a.source in ('V','R')) and nvl(t.source,'G') not in  ('V','R');
        delete from rasd_attributes t where formid = r.formid and not exists (select 1 from rasd_elements a where a.formid = r.formid and a.elementid = t.elementid);
        update rasd_elements set pelementid = 0, elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = r.formid;
        update rasd_attributes set elementid=decode(substr(to_char(elementid),1,1),'-',elementid,elementid*-1) where formid = r.formid;
    end loop;
  
    sincFieldsAndElements(p_formid);
    sincIncludevis(p_formid);    
    sincValuecode(p_formid);
   
    sincForLoop(p_formid);   
  
  end;
 
  procedure writeOutputHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2) is
  begin   
    v_level := 0;
    outputElement(p_formid, 0, p_out, null, 'BLOCK_DIV');
  end;

  procedure writeHTML(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2) is
  begin
    writePrepareHTML(p_formid, p_out, p_lang); 
    writeOutputHTML(p_formid, p_out, p_lang);
  end;

  procedure writeHTMLError(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2) is
    re           rasd_elements%rowtype;
    v_form       rasd_forms.form%type;
  begin
    v_level := 0;   
    rasd_engine11.addcnl('    htp.p(''');    
    
    select f.form into v_form from rasd_forms f where f.formid = p_formid;
    
    re          := getElement(p_formid, 'HEAD_');
    rasd_engine11.addc('<html>');
    outputElement(p_formid, re.elementid, p_out, re.elementid, null);
    rasd_engine11.addc('<body>');
    
    re          := getElement(p_formid, 'FORM_LAB');
    outputElement(p_formid, re.elementid, p_out, re.elementid, null);
    
    rasd_engine11.addc('<div class="rasdForm">');
    
    rasd_engine11.addc('<div class="rasdFormHead"><input onclick="history.go(-1);" type="button" value="'|| rasdi_trnslt.text('Back',p_lang) ||'" class="rasdButton"></div>');
    
    rasd_engine11.addc('<div class="rasdHtmlError">');
    rasd_engine11.addc('  <div class="rasdHtmlErrorText"><div class="rasdHtmlErrorText">''||sqlerrm||''(''||sqlcode||'')</div></div><div class="rasdHtmlErrorText">'');');   

    rasd_engine11.addcnl('declare ');   
    rasd_engine11.addcnl('  v_trace varchar2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE; ');   
    rasd_engine11.addcnl('  v_nl varchar2(2) := chr(10); ');   
    rasd_engine11.addcnl('begin '); 
    rasd_engine11.addcnl('rlog(''ERROR:''||v_trace); ');       
    rasd_engine11.addcnl('htp.p ( '''|| rasdi_trnslt.text('Error trace',p_lang) ||'''||'':''||''<br/>''|| replace(v_trace, v_nl ,''<br/>''));');   
    rasd_engine11.addcnl('htp.p ( ''</div><div class="rasdHtmlErrorText">''||'''|| rasdi_trnslt.text('Error stack',p_lang) ||'''||'':''||''<br/>''|| replace(DBMS_UTILITY.FORMAT_ERROR_STACK, v_nl ,''<br/>''));');   
    rasd_engine11.addcnl('rlog(''ERROR:''||DBMS_UTILITY.FORMAT_ERROR_STACK); ');  
    rasd_engine11.addcnl('');   
    rasd_engine11.addcnl('htp.p(''</div>'');');
--    rasd_engine11.addcnl('htp.p(''<div class="rasdHtmlErrorText">''||'''|| rasdi_trnslt.text('Code snippet',p_lang) ||'''||'':''||''<br/>'');');   
--    rasd_engine11.addcnl('htp.p(''<div class="rasdHtmlErrorSniped">'');');   
--    rasd_engine11.addcnl('htp.p(''...<br/>'');');  

--    rasd_engine11.addcnl(''rasdi_trnslt.text('Code snippet',p_lang)
    rasd_engine11.addcnl('rlog(''ERROR:...''); ');       
    rasd_engine11.addcnl('declare ');   
    rasd_engine11.addcnl('  v_line  number;');   
    rasd_engine11.addcnl('  v_x varchar2(32000); ');   
    rasd_engine11.addcnl('begin ');   
    rasd_engine11.addcnl('v_x := substr(v_trace,1,instr(v_trace, v_nl )-1 );  ');   
    rasd_engine11.addcnl('v_line := substr(v_x,instr(v_x,'' '',-1));');   
    rasd_engine11.addcnl('for r in  (');   
    rasd_engine11.addcnl('select line, text from user_source s where s.name = '''||v_form||''' and line > v_line-5 and line < v_line+5 ');   
    rasd_engine11.addcnl(') loop ');  
     rasd_engine11.addcnl('rlog(''ERROR:''||r.line||'' - ''||r.text); ');      
--    rasd_engine11.addcnl('if r.line = v_line then ');   
--    rasd_engine11.addcnl('htp.p(''<font color="red">''||r.line||'' - ''||r.text||''</font><br/>'');');   
--    rasd_engine11.addcnl('else  ');   
--    rasd_engine11.addcnl('htp.p(r.line||'' - ''||r.text||''<br/>'');');   
--    rasd_engine11.addcnl('end if;');   
    rasd_engine11.addcnl('end loop;  ');   
    rasd_engine11.addcnl('rlog(''ERROR:...''); ');      
--    rasd_engine11.addcnl('htp.p(''...<br/>'');');   
    rasd_engine11.addcnl('exception when others then null;end;');   
    rasd_engine11.addcnl('end;');   
--    rasd_engine11.addc('htp.p(''</div></div>');


    rasd_engine11.addc('htp.p(''</div>');
    rasd_engine11.addc('<div class="rasdFormFooter"><input onclick="history.go(-1);" type="button" value="'|| rasdi_trnslt.text('Back',p_lang) ||'" class="rasdButton">');
    
    --re          := getElement(p_formid, 'FORM_FOOTER'); -- Not OK because added buttons
    --outputElement(p_formid, re.elementid, p_out, re.elementid, null);
   
    rasd_engine11.addc('''|| rasd_client.getHtmlFooter(version , substr('''||v_form||'_FOOTER'',1,instr('''||v_form||'_FOOTER'', ''_'',-1)-1) , '''') ||''');
    rasd_engine11.addc('</div></div>');
    rasd_engine11.addc('</body></html>');
    rasd_engine11.addcnl('    '');'); 
  
       
  end;

  procedure writeHTMLHead(p_formid rasd_elements.formid%type,
                      p_out    in varchar2 default 'N', p_lang in varchar2) is
    re           rasd_elements%rowtype;
  begin
    v_level := 0;   
    re          := getElement(p_formid, 'HEAD_');

    rasd_engine11.addc('<head>');
    outputElement(p_formid, re.elementid, p_out, re.elementid, null);
    rasd_engine11.addc('</head>');
  end;


begin
  null;
end;
/
