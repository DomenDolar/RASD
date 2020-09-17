create or replace package rasdc_cssjs is
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
  function version(p_log out varchar2) return varchar2;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr);

  procedure openLOV(name_array in owa.vc_arr, value_array in owa.vc_arr);
end;
/

create or replace package body rasdc_cssjs is
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

  type rtab is table of rowid index by binary_integer;
  type ntab is table of number index by binary_integer;
  type dtab is table of date index by binary_integer;
  type ctab is table of varchar2(4000) index by binary_integer;
  type itab is table of pls_integer index by binary_integer;
  type cctab is table of varchar2(32000) index by binary_integer;
  
  function version(p_log out varchar2) return varchar2 is
  begin
    p_log := '/* Change LOG:
20200410 - Added new compilation message     
20181129 - Added character counter    
20180917 - Added order by in drop down lists    
20180608 - Default code for JS, ...    
20180423 - Added option to upload file for RASD engine - do not use these in build forms - applications     
20170119 - Added new trigger FORM_UIHEAD - for customizing form element <HEAD>
20160704 - Added button Preview    
20160629 - Added log function for RASD.      
20160629 - Added CSS_REF and JS_REF triggers.          
20160627 - Included reference form future.    
20160408 - Solved bug with large data in general CSS,JS part
20160324 - Added Compile button
20160310 - Included CodeMirror    
20151202 - Included session variables in filters    
20150817 - Added tab look
20150814 - Added superuser    
20150813 - Added option to create JS and CSS for custom FORM
20141027 - Added footer on all pages
20141126 - solved error on package - using method currentDADUser
*/';
    return 'v.1.1.20200410225530';

  end;

  procedure openLOV(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    num_entries number := name_array.count;
    TYPE pLOVType IS RECORD(
      output varchar2(300),
      p1     varchar2(200));
    TYPE tab_pLOVType IS TABLE OF pLOVType INDEX BY BINARY_INTEGER;
    v_lov         tab_pLOVType;
    v_counter     number := 1;
    v_description varchar2(100);
    p_lov         varchar2(100);
    p_nameid      varchar2(100);
    v_output      boolean;
  begin
    for i in 1 .. num_entries loop
      if name_array(i) = 'P_LOV' then
        p_lov := value_array(i);
      elsif name_array(i) = 'pnameid' then
        p_nameid := value_array(i);
      end if;
    end loop;
    htp.p('
  <script language="JavaScript"><!--
   function close() {
     this.close ();
   }
   function chose() {
     var value = window.document.' || p_lov ||
          '.theList.options[window.document.' || p_lov ||
          '.theList.selectedIndex].value;
     var tekst = window.document.' || p_lov ||
          '.theList.options[window.document.' || p_lov ||
          '.theList.selectedIndex].text;');
    htp.p('this.close ();
   }
  with (document) {
  if (screen.availWidth < 900){
    moveTo(-4,-4)}
  }
// --></script>');
    htp.p('
<html>');
    htp.bodyOpen('', '');
    htp.p('<div class="LOVName">' || v_description || '</div>');
    htp.formOpen(curl        => '!rasdc_cssjs.openLOV',
                 cattributes => 'name="' || p_lov || '"');
    htp.p('');
    htp.p('<div class="LOV" align="center"><center>');
    htp.formselectOpen('theList', cattributes => 'size=15 width="100%"');
    for i in 1 .. v_counter loop
      if i = 1 then
        -- fokus na prvem
        htp.formSelectOption(cvalue      => v_lov(i).output,
                             cselected   => 1,
                             Cattributes => 'value="' || v_lov(i).p1 || '"');
      else
        htp.formSelectOption(cvalue      => v_lov(i).output,
                             Cattributes => 'value="' || v_lov(i).p1 || '"');
      end if;
    end loop;
    htp.formselectClose;
    htp.p('');
    htp.line;
    htp.p('<input type=button value="Select and Confirm" onClick="select();">');
    htp.p('<input type=button value="Cancel" onClick="close();">');
    htp.p('</center></div>');
    htp.p('</form>');
    htp.p('</body>');
    htp.p('</html>');
  end;
  procedure webclient(name_array in owa.vc_arr, value_array in owa.vc_arr) is
    RECNUMb10   number := 1;
    RECNUMb20   number := 1;
    vcom number;
    LANG        varchar2(4000);
    PFORMID     varchar2(4000);
    GBUTTONBCK  varchar2(4000) := 'GBUTTONBCK';
    GBUTTONCLR  varchar2(4000) := 'GBUTTONCLR';
    GBUTTONFWD  varchar2(4000) := 'GBUTTONFWD';
    GBUTTONSAVE varchar2(4000) := 'Save';
    GBUTTONSRC  varchar2(4000) := '';
    PAGE        number := 0;
    ACTION      varchar2(4000);
    GBUTTONRES  varchar2(4000) := 'Reset';
    pparameter  ctab;
    b10RS       ctab;
    b10rid      rtab;
    b10NAME     ctab;
    b10BLOBVC   cctab;
    PFORMIDN          number;
    PBLOKPROZILECNOV varchar2(4000);
    --PBLOKtriggerid   varchar2(4000);
    B20RID           rtab;
    B20RS            ctab;
    B20formid        ctab;
    B20blockid       ctab;
    B20rform       ctab;
    B20triggerid     ctab;
    B20plsql         cctab;
    B20plsqlspec     cctab;

    v_table varchar2(1000); 
    v_paket varchar2(1000); 
    message     varchar2(4000);
             unlink   varchar2(4000);
predogled             varchar2(1000); 
v_form              varchar2(1000); 
procedure on_session is
    i__ pls_integer := 1;
  begin
  if ACTION is not null then
begin
 rasdi_client.sessionStart;
rasdi_client.sessionSetValue(to_char(pformid)||'PBLOKPROZILECNOV', PBLOKPROZILECNOV ); 
 rasdi_client.sessionClose;
exception when others then null; end;
else
declare vc varchar2(2000); begin
null;
if PBLOKPROZILECNOV is null then vc := rasdi_client.sessionGetValue(to_char(pformid)||'PBLOKPROZILECNOV'); PBLOKPROZILECNOV  := vc;  end if; 
exception when others then  null; end;  end if;
  end;

    
    procedure on_submit is
      num_entries number := name_array.count;
      v_max       pls_integer := 0;
    begin
      -- submit fields
      for i__ in 1 .. nvl(num_entries, 0) loop
        if 1 = 2 then
          null;
        elsif upper(name_array(i__)) = upper('RECNUMB10') then
          RECNUMb10 := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('GBUTTONBCK') then
          GBUTTONBCK := value_array(i__);
        elsif upper(name_array(i__)) = upper('LANG') then
          LANG := value_array(i__);
        elsif upper(name_array(i__)) = upper('UNLINK') then
          unlink := value_array(i__);          
        elsif upper(name_array(i__)) = upper('PFORMID') then
          PFORMID := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONCLR') then
          GBUTTONCLR := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONFWD') then
          GBUTTONFWD := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONSAVE') then
          GBUTTONSAVE := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONSRC') then
          GBUTTONSRC := value_array(i__);
        elsif upper(name_array(i__)) = upper('PAGE') then
          PAGE := rasdi_client.varchr2number(value_array(i__));
        elsif upper(name_array(i__)) = upper('ACTION') then
          ACTION := value_array(i__);
        elsif upper(name_array(i__)) = upper('GBUTTONRES') then
          GBUTTONRES := value_array(i__);
        elsif upper(name_array(i__)) = upper('PBLOKPROZILECNOV') then
          PBLOKPROZILECNOV := value_array(i__);          
        elsif upper(name_array(i__)) =
              upper('PPARAMETER_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          pparameter(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10rid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B10NAME_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10NAME(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B10BLOB_CONTENT_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          b10BLOBVC(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20RID_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RID(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := chartorowid(value_array(i__));
        elsif upper(name_array(i__)) =
              upper('B20RS_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20RS(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20formid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20formid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20blockid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20blockid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);         
        elsif upper(name_array(i__)) =
              upper('B20triggerid_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20triggerid(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20PLSQL_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20plsql(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);
        elsif upper(name_array(i__)) =
              upper('B20PLSQLSPEC_' ||
                    substr(name_array(i__),
                           instr(name_array(i__), '_', -1) + 1)) then
          B20plsqlspec(to_number(substr(name_array(i__), instr(name_array(i__), '_', -1) + 1))) := value_array(i__);

        end if;
      end loop;
      -- init fields
      v_max := 0;
      if b10RS.count > v_max then
        v_max := b10RS.count;
      end if;
      if b10rid.count > v_max then
        v_max := b10rid.count;
      end if;
      if b10NAME.count > v_max then
        v_max := b10NAME.count;
      end if;
      if b10BLOBVC.count > v_max then
        v_max := b10BLOBVC.count;
      end if;
      for i__ in 1 .. v_max loop
        if not b10RS.exists(i__) then
          b10RS(i__) := null;
        end if;
        if not b10rid.exists(i__) then
          b10rid(i__) := null;
        end if;
        if not b10NAME.exists(i__) then
          b10NAME(i__) := null;
        end if;
        if not b10BLOBVC.exists(i__) then
          b10BLOBVC(i__) := null;
        end if;
        null;
      end loop;
      v_max := 0;
      if pparameter.count > v_max then
        v_max := pparameter.count;
      end if;
      for i__ in 1 .. v_max loop
        if not pparameter.exists(i__) then
          pparameter(i__) := null;
        end if;
        null;
      end loop;
      
      
            v_max := 0;
      if B20RID.count > v_max then
        v_max := B20RID.count;
      end if;
      if B20RS.count > v_max then
        v_max := B20RS.count;
      end if;
      if B20formid.count > v_max then
        v_max := B20formid.count;
      end if;
      if B20blockid.count > v_max then
        v_max := B20blockid.count;
      end if;
      if B20triggerid.count > v_max then
        v_max := B20triggerid.count;
      end if;
      if B20plsql.count > v_max then
        v_max := B20plsql.count;
      end if;
      if B20plsqlspec.count > v_max then
        v_max := B20plsqlspec.count;
      end if;     
      for i__ in 1 .. v_max loop
        if not B20RID.exists(i__) then
          B20RID(i__) := null;
        end if;
        if not B20RS.exists(i__) then
          B20RS(i__) := null;
        end if;
        if not B20formid.exists(i__) then
          B20formid(i__) := null;
        end if;
        if not B20blockid.exists(i__) then
          B20blockid(i__) := null;
        end if;
        if not B20triggerid.exists(i__) then
          B20triggerid(i__) := null;
        end if;
        if not B20plsql.exists(i__) then
          B20plsql(i__) := null;
        end if;
        if not B20plsqlspec.exists(i__) then
          B20plsqlspec(i__) := null;
        end if;      
        null;
      end loop;
    end;
    procedure post_submit is
    begin
      if PBLOKPROZILECNOV is null then PBLOKPROZILECNOV := '/.../FORM_CSS'; end if;
      null;
    end;
    procedure psubmit is
    begin
      on_submit;
      on_session;
      post_submit;
    end;
    procedure pclear_p(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 1 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 1 then
          k__ := i__ + 0;
        else
          k__ := 0 + 1;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        pparameter(j__) := 'rasd/rasd.css';

      end loop;
    end;
    procedure pclear_b10(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 1 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 1 then
          k__ := i__ + 0;
        else
          k__ := 0 + 1;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        b10RS(j__) := null;
        b10rid(j__) := null;
        b10NAME(j__) := null;
        b10BLOBVC(j__) := null;

      end loop;
    end;

    procedure pclear_B20(pstart number) is
      i__ pls_integer;
      j__ pls_integer;
      k__ pls_integer;
    begin
      i__ := pstart;
      if 1 = 0 then
        k__ := i__ + 0;
      else
        if i__ > 1 then
          k__ := i__ + 0;
        else
          k__ := 0 + 1;
        end if;
      end if;
      for j__ in i__ + 1 .. k__ loop
        B20RID(j__) := null;
        B20RS(j__) := null;
        B20formid(j__) := null;
        B20blockid(j__) := null;
        B20triggerid(j__) := null;
 --        B20plsql(j__) := null;
        B20plsql(j__) := trim(rasd_engine11.createtriggertemplateplsql(pformid, substr(PBLOKPROZILECNOV, instr(PBLOKPROZILECNOV, '/.../') + 5) , ''));
        B20plsqlspec(j__) := null;
        B20rform(j__) := null;
        B20RS(j__) := 'I';

      end loop;
    end;
    
    
    procedure pclear_form is
    begin
      RECNUMb10   := 1;
      GBUTTONBCK  := 'GBUTTONBCK';
      GBUTTONCLR  := 'GBUTTONCLR';
      GBUTTONFWD  := 'GBUTTONFWD';
      GBUTTONSAVE := 'Save';
      GBUTTONSRC  := 'Isci';
      PAGE        := 0;
      ACTION      := null;
      GBUTTONRES  := 'Reset';
      null;
    end;
    procedure pclear is
    begin
      pclear_form;
      pclear_p(0);
      pclear_b10(0);
      pclear_b20(0);
      null;
    end;
    procedure pselect_p is
      i__ pls_integer;
    begin
      pclear_p(pparameter.count);
      null;
    end;
    procedure pselect_b10 is
      i__ pls_integer;
    begin
      b10RS.delete;
      b10rid.delete;
      b10NAME.delete;
      b10BLOBVC .delete;
      --<pre_select formid="6" blockid="b10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          'select rowid rid,
                 name,
                 '||v_table||'_API.Blob2Clob(blob_content) BLOBVC
                 --UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(blob_content,
                   --                                       32767,
                     --                                     1)) BLOBVC
            from '||v_table||'
           where name = '''||pparameter(1)||'''
           order by name';           
           
        i__ := 1;
        LOOP
          FETCH c__
            INTO b10rid(i__), b10NAME(i__), b10BLOBVC(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            b10RS(i__) := null;

            --<post_select formid="6" blockid="b10">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          b10RS.delete(1);
          b10rid.delete(1);
          b10NAME.delete(1);
          b10BLOBVC .delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_b10(b10rid.count);
      null;
    end;

    procedure pselect_B20 is
      i__ pls_integer;
    begin
      B20RID.delete;
      B20RS.delete;
      B20formid.delete;
      B20blockid.delete;
      B20triggerid.delete;
      B20plsql.delete;
      B20plsqlspec.delete;
      b20rform.delete;
      --<pre_select formid="5" blockid="B10">
      --</pre_select>
      declare
        TYPE ctype__ is REF CURSOR;
        c__ ctype__;
      begin
        OPEN c__ FOR
          select rowid     rid,
                 formid    formid,
                 blockid   blockid,
                 triggerid,
                 plsql,
                 plsqlspec, rform
            from RASD_TRIGGERS
           where formid = PFORMID
             and triggerid = substr(PBLOKPROZILECNOV,
                                          instr(PBLOKPROZILECNOV, '/.../') + 5)
           order by triggerid  ;
        i__ := 1;
        LOOP
          FETCH c__
            INTO B20RID(i__),
                 B20formid(i__),
                 B20blockid(i__),
                 B20triggerid(i__),
                 B20plsql(i__),
                 B20plsqlspec(i__),
                 b20rform(i__);
          exit when c__%notfound;
          if c__%rowcount >= 1 then
            B20RS(i__) := null;
            B20RS(i__) := 'U';

            --<post_select formid="5" blockid="B10">
            --</post_select>
            i__ := i__ + 1;
          end if;
        END LOOP;
        if c__%rowcount < 1 then
          B20RID.delete(1);
          B20RS.delete(1);
          B20formid.delete(1);
          B20blockid.delete(1);
          B20triggerid.delete(1);
          B20plsql.delete(1);
          B20plsqlspec.delete(1);
          B20rform.delete(1);
          i__ := 0;
        end if;
        CLOSE c__;
      end;
      pclear_B20(B20RID.count);
      null;
    end;
    
    
    procedure pselect is
    begin
      if nvl(PAGE, 0) = 1 then
        pselect_p;
      end if;
      if nvl(PAGE, 0) = 1 then
        pselect_b10;
      end if;
      if nvl(PAGE, 0) = 0 then
        pselect_b20;
      end if;

      null;
    end;
    procedure pcommit_p is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. pparameter.count loop
        --<on_validate formid="6" blockid="p">
        --</on_validate>
        null;
      end loop;
      null;
    end;
    procedure pcommit_b10 is
      v_locking varchar2(4000);
    begin
      for i__ in 1 .. b10RS.count loop
        --<on_validate formid="6" blockid="b10">
        --</on_validate>
        if substr(b10RS(i__), 1, 1) = 'I' then
          --INSERT
          null;
        else
          -- UPDATE or DELETE;

          --<on_update formid="6" blockid="b10">
          execute immediate
          'update '||v_table||'
             set BLOB_CONTENT = '||v_table||'_API.Clob2Blob('''||replace(b10BLOBVC(i__),'''','''''')||''')
          where ROWID = '''||b10rid(i__)||'''';
          
          --</on_update>
          null;
        end if;
        null;
      end loop;
      null;
    end;
    
    
    procedure pcommit_B20 is
      v_zaklepanje varchar2(4000);
      v_def clob;
      v_code clob;
    begin
      for i__ in 1 .. B20RID.count loop
        --<on_validate formid="5" blockid="B20">
        --</on_validate>
        if substr(B20RS(i__), 1, 1) = 'I' then
          --INSERT
          if B20plsql(i__) is not null or B20plsqlspec(i__) is not null then
            --<pre_insert formid="5" blockid="B20">
            
--            htp.p('BB'||(trim(replace(replace(B20plsql(i__),' ',''),'
--','')))||'BB');
            
--            htp.p('CC'||(trim(replace(replace(rasd_engine11.createtriggertemplateplsql(pformid, substr(PBLOKPROZILECNOV, instr(PBLOKPROZILECNOV, '/.../') + 5) , ''),' ',''),'
--','')))||'CC');

            v_def :=  trim(replace(replace(rasd_engine11.createtriggertemplateplsql(pformid, substr(PBLOKPROZILECNOV, instr(PBLOKPROZILECNOV, '/.../') + 5) , ''),' ',''),'
','X'));
            v_code := trim(replace(replace(replace(B20plsql(i__),' ',''),chr(10),'X'),chr(13),''));


       --     htp.p('BB'||(v_def)||'BB');
            
      --      htp.p('CC'||(v_code)||'CC');


         --   htp.p('BB'||length(v_def)||'BB');
            
        --    htp.p('CC'||length(v_code)||'CC');

            
            if nvl(v_code,'XX:#:XX') <>  nvl(v_def,'XX:#:XX')
              then
            B20formid(i__) := PFORMID;

              B20blockid(i__) := null;
              B20triggerid(i__) := substr(PBLOKPROZILECNOV,
                                          instr(PBLOKPROZILECNOV, '/.../') + 5);
            --</pre_insert>
            insert into RASD_TRIGGERS
              (formid, blockid, triggerid, plsql, plsqlspec)
            values
              (B20formid(i__),
               B20blockid(i__),
               B20triggerid(i__),
               B20plsql(i__),
               B20plsqlspec(i__));
            --<post_insert formid="5" blockid="B10">
            --</post_insert>
            null;
            end if;
          end if;
          null;
        else
          -- UPDATE ali DELETE;

          if B20plsql(i__) is null then
            --DELETE
            --<pre_delete formid="5" blockid="B10">
            --</pre_delete>
            delete RASD_TRIGGERS where ROWID = B20RID(i__) and rform is null;
            --<post_delete formid="5" blockid="B20">
            --</post_delete>
          else
            --UPDATE
            --<pre_update formid="5" blockid="B20">
            --</pre_update>
            declare
              vtig_first pls_integer;
            begin

              select count(1)
                into vtig_first
                from rasd_triggers_code_types c, rasd_triggers s
               where c.tctype = s.triggerid
                 and c.language = 'P'
                 and s.rowid = B20RID(i__);
                                  
              if vtig_first = 0 then

                update RASD_TRIGGERS s
                   set plsql = B20plsql(i__)
                   ,plsqlspec =  B20plsqlspec(i__)
,                   rform  = decode (unlink,'Y',null,rform)
                 where ROWID = B20RID(i__) and (rform is null or unlink = 'Y');
              else

                update RASD_TRIGGERS s
                   set plsql = B20plsql(i__), plsqlspec = B20plsqlspec(i__)
,                   rform  = decode (unlink,'Y',null,rform)
                 where ROWID = B20RID(i__) and (rform is null or unlink = 'Y');

              end if;

            end;
            --<post_update formid="5" blockid="B20">
            --</post_update>
            null;
          end if;
          null;
        end if;
        null;
      end loop;
      null;
    end;
    
    
    procedure pcommit is
    begin
      --<pre_commit formid="6" blockid="">
      --</pre_commit>
      if nvl(PAGE, 0) = 1 then
        pcommit_p;
      end if;
      if nvl(PAGE, 0) = 1 then
        pcommit_b10;
      end if;
      
     if nvl(PAGE, 0) = 0 then
        pcommit_B20;
      end if;
      --<post_commit formid="6" blockid="">
      --</post_commit>
      null;
    end;
    procedure poutput is
      procedure js_LOV_SQL(value varchar2, name varchar2 default null) is
      begin
        htp.p('<script language="JavaScript">');
        htp.p('js_LOV_SQL(''' || value || ''');');
        htp.p('</script>');
      end;
    begin
      htp.p('<script language="JavaScript">');
      htp.p('function js_LOV_SQL(pvalue) {');
      declare
        TYPE ctype__ is REF CURSOR;
         c__ ctype__;
         v_id varchar2(300);
         v_label  varchar2(300);
      begin
      OPEN c__ FOR 
                  --<lovsql formid="6" linkid="LOV_SQL">
                  'select name id, name label
                    from '||v_table||'
                   where upper(name) like ''%RASD%.HTML''
                     or upper(name) like ''%RASD%.JS''
                     or upper(name) like ''%RASD%.CSS''  
                   order by name                   
                   ';
                  --</lovsql>
      loop
        FETCH c__
            INTO v_id, v_label;
          exit when c__%notfound;
        htp.p('  document.write(''<option class=selectp ''+ ((pvalue==''' ||
              v_id || ''')?''selected'':'''') +'' value="' || v_id || '">' ||
              v_label || ' '')');
      end loop;
      end;
      htp.p('}');
      htp.prn('</script>');
      htp.prn('<html>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">
'||RASDC_LIBRARY.RASD_UI_Libs||'
  <script>
  $(function() {
    $( "#tabs" ).tabs({
      active: '||page||'
    });
  });
 
 
  function submit_form(valll) {
    document.getElementById(''PAGE'').value = valll; 
    document.getElementById(''ACTION'').value = ''Search'';
    document.getElementById(''RASDC_CSSJS'').submit();   
  }
  
  </script>
');
/*
htp.p('  
  <STYLE>

.CodeMirror {
  font-size: 140%; 
}

.CodeMirror-hints {
  font-size: 130%;
}

</STYLE>');
*/
htp.p('
<SCRIPT LANGUAGE="Javascript1.2">
 $(function() {
     addSpinner();   
  }); 
</SCRIPT>
  
</HEAD>
<body>
<div id="rasdSpinner" class="rasdSpinner" style="display:none;"></div>
<FONT ID="RASDC_CSSJS_LAB">');
      RASDC_LIBRARY.showhead('RASDC_CSSJS',
                                PFORMID,
                                rasdi_client.secGetUsername,
                                lang);
      htp.prn('</FONT>
<form id="RASDC_CSSJS" name="RASDC_CSSJS" method="post" action="!rasdc_cssjs.webclient"><input name="RECNUMB10" type="hidden" value="' ||
              RECNUMb10 || '">
<input id="PAGE" name="PAGE" type="hidden" value="' || PAGE || '">
<INPUT NAME="LANG" TYPE="HIDDEN" VALUE="' || lang ||
              '" CLASS="HIDDEN">
<INPUT NAME="PFORMID" TYPE="HIDDEN" VALUE="' || PFORMID ||
              '" CLASS="HIDDEN">
<P align="right">

<table width="100%"><tbody>
<tr>

<td align="left">');
--<input type="submit" value="Form CSS, JS" class="button" onclick="PAGE.value=''0'';ACTION.value=''Search''; submit();">
--<input type="submit" value="General CSS, JS" class="button" onclick="PAGE.value=''1''; ACTION.value=''Search'';submit();">
htp.p('
</td>
<td align="right">
<INPUT id="ACTION" type="hidden" name="ACTION">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT class="SUBMIT" id="ACTION" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" name="ACTION" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_CSSJS.submit();">
');
      htp.prn('
<INPUT class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_CSSJS.submit(); this.disabled = true;">');
end if;
htp.p('
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" >
');
      htp.p(predogled);
htp.p('              
</td>              
</tr>
</tbody>
</table>
</P>

<div id="tabs">
 <ul>
    <li id="tab0"><a href="#tabs-'||page||'" onclick="submit_form(0);" >Form CSS, JS</a></li>
    <li id="tab1"><a href="#tabs-'||page||'" selected onclick="submit_form(1);" >General CSS, JS</a></li>
  </ul>
');

if nvl(PAGE, 0) = 0 then
htp.p('
<div id="#tabs-'||page||'" style="');

              if b20rform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;
htp.prn('">

<TABLE BORDER="0" width="100%" style="');

              if b20rform(1) is not null then
                 htp.prn('background-color: #aaccf7; border-color: #aaccf7;');
              end if;
htp.prn('">
<CAPTION  style="width: 100%; text-align: left;">

');
        /**/
        htp.prn('
<B><FONT ID="B20_LAB">' || RASDI_TRNSLT.text('File', lang) ||
                '
</FONT></B><SELECT name="PBLOKPROZILECNOV" CLASS="SELECT" onchange="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              '''; document.RASDC_CSSJS.submit();">');
htp.prn('<OPTION CLASS=selectp '); if instr(PBLOKPROZILECNOV,'FORM_CSS') > 0 then htp.p('selected'); end if;  htp.p(' value="/.../FORM_CSS">FORM_CSS</OPTION>
  <OPTION CLASS=selectp '); if instr(PBLOKPROZILECNOV,'FORM_JS') > 0 then htp.p('selected'); end if;  htp.p(' value="/.../FORM_JS">FORM_JS</OPTION>
  <OPTION CLASS=selectp '); if instr(PBLOKPROZILECNOV,'FORM_UIHEAD') > 0 then htp.p('selected'); end if;  htp.p(' value="/.../FORM_UIHEAD">FORM_UIHEAD</OPTION>
');

for r in (select * from rasd_triggers t where t.formid = pformid and ( triggerid like 'FORM_CSS_REF%' or triggerid like 'FORM_JS_REF%'or triggerid like 'FORM_UIHEAD_REF%') order by triggerid) loop
htp.prn('<OPTION CLASS=selectp '); if instr(PBLOKPROZILECNOV,r.triggerid) > 0 then htp.p('selected'); end if;  htp.p(' value="/.../'||r.triggerid||'">'||r.triggerid||'</OPTION>
');
   
end loop;
 htp.prn('</select>
 
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Search', lang) || '""  onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              '''; document.RASDC_CSSJS.submit();">');

htp.p('<a align="left" href="javascript: var link=window.open(''!DOCUMENTS_API2.page?showfiles=true'','''',''width=550,height=400,scrollbars=1'')"><img height="20" title="' ||
              RASDI_TRNSLT.text('Upload new custom images for projects', lang) || '" src="rasdc_files.showfile?pfile=pict/gumbupload.jpg" width="21" border="0"></a>');
              
htp.p(''); 
        rasdc_hints.link('RASDC_CSSJS', lang);
        htp.prn('
');
      htp.prn('      
</CAPTION><TR></TR>
<TR ID="B20_BLOK"><INPUT NAME="B20RID_1" TYPE="HIDDEN" VALUE="' ||
              B20RID(1) ||
              '" CLASS="HIDDEN"><INPUT NAME="B20RS_1" TYPE="HIDDEN" VALUE="' ||
              B20RS(1) || '" CLASS="HIDDEN">
<TD><TEXTAREA '||
              ' style="FONT-SIZE: 8pt; font-face: Lucida Console" name="B20PLSQL_1" id="B20PLSQL_1" rows="30" cols="80" CLASS="TEXTAREA">' ||
              B20plsql(1) || '</TEXTAREA>
              </br>
              <div id="B20PLSQLCOUNT_1"></div>
              </TD>
</TR>
</TABLE>


<script>
window.onload = function() {');

if instr(PBLOKPROZILECNOV , 'JS') > 0 then
htp.p('  var mime = ''text/javascript'';');
else
htp.p('  var mime = ''text/css'';');
end if;
htp.p('  // get mime type
  if (window.location.href.indexOf(''mime='') > -1) {
    mime = window.location.href.substr(window.location.href.indexOf(''mime='') + 5);
  }
  window.editor = CodeMirror.fromTextArea(document.getElementById(''B20PLSQL_1''), {
    mode: mime,
    indentWithTabs: true,
    smartIndent: true,
    lineNumbers: true,
    matchBrackets : true,
    autofocus: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    hintOptions: {tables: {
      __RASD_VARIABLES: {},
      __OTHER_FUNCTIONS: {}      
    }}
  });
  window.editor.setSize("100%","450");

  window.editor.setOption("maxLength", 31905);
 

window.editor.on("beforeChange", function (cm, change) {
    var maxLength = cm.getOption("maxLength");
    if (maxLength && change.update) {
        var str = change.text.join("\n");
        var delta = str.length-(cm.indexFromPos(change.to) - cm.indexFromPos(change.from));
        if (delta <= 0) { return true; }
        delta = cm.getValue().length+delta-maxLength;
        document.getElementById("B20PLSQLCOUNT_1").innerHTML = "'||RASDI_TRNSLT.text('Characters left:', lang)||' " + ((delta*-1)+1) ;
        if (delta > 0) {
            str = str.substr(0, str.length-delta);
            change.update(change.from, change.to, str.split("\n"));
        }
    }
    return true;
  
}); 


};
</script>

</div>
');

      htp.prn('     
</div> ');

htp.p('</br>External links:</br>
<ul>
<li> <a href="https://jsbin.com/woqokaquju/edit?html,css,js,output" target="_blank"> RASD CSS,HTML,JS template </a></li>
<li> <a href="https://htmlg.com/html-editor/" target="_blank"> External HTML editor </a></li>
<li> <a href="https://regex101.com/" target="_blank">External RegEX editor </a></li>
</ul>
');


elsif nvl(PAGE, 0) = 1 then

htp.p('
<div id="#tabs-'||page||'">
<TABLE BORDER="0" width="100%">
<CAPTION  style="width: 100%; text-align: left;"><FONT ID="B10_LAB">

');

      htp.prn('
<B>' || RASDI_TRNSLT.text('File', lang) ||
              '</B>&nbsp;<select name="PPARAMETER_1" class="select" onChange="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              '''; document.RASDC_CSSJS.submit();">');
      js_LOV_SQL(pparameter(1), 'PPARAMETER_1');
      htp.prn('</select>
<img src="rasdc_files.showfile?pfile=pict/gumbok.jpg" border="0" title="' ||
              RASDI_TRNSLT.text('Search', lang) || '""  onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Search', lang) ||
              '''; document.RASDC_CSSJS.submit();">
');

htp.p('<a align="left" href="javascript: var link=window.open(''!RASDC_FILES.page'','''',''width=550,height=400,scrollbars=1'')"><img height="20" title="' ||
              RASDI_TRNSLT.text('Customize your RASD enviorment', lang) || '" src="rasdc_files.showfile?pfile=pict/gumbupload.jpg" width="21" border="0"></a>
');

      rasdc_hints.link('RASDC_CSSJS', lang);
      htp.prn('
');

      htp.prn('
</FONT></CAPTION>
<TR>
<TD>
<input name="B10RID_1" type="hidden" value="' || b10rid(1) ||
              '"><input name="B10RS_1" type="hidden" value="' || b10RS(1) || '">
<textarea name="B10BLOB_CONTENT_1" id="B10BLOB_CONTENT_1" class="textarea" rows="25" cols="100">' ||
              b10BLOBVC(1) || '</textarea></TD>
</TR></TABLE>
</div>
');

end if;

      if message is not null then
        htp.prn('
<table border="0"><tr><td width="1%" class="sporociloh" nowrap><FONT COLOR="green" size="4">' ||
                RASDI_TRNSLT.text('Message', lang) ||
                ': </FONT></td>
<td class="sporocilom">' ||
                RASDI_TRNSLT.text(message, lang) || '</td></tr></table>
');
      htp.prn('     
</div> ');

      end if;


      htp.prn('     


  
<P align="right">
');
if rasdc_library.allowEditing(pformid) then
htp.p('
<INPUT class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Save', lang) ||
              '''; document.RASDC_CSSJS.submit();">
');
      htp.prn('
<INPUT class="SUBMIT" type="button" value="' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '" onClick="document.getElementById(''ACTION'').value=''' ||
              RASDI_TRNSLT.text('Compile', lang) ||
              '''; document.RASDC_CSSJS.submit(); this.disabled = true;">');
end if;
htp.p('
<INPUT class="SUBMIT" type="reset" value="' ||
              RASDI_TRNSLT.text('Reset', lang) || '" >
');
      htp.p(predogled);
htp.p('                
</p>
</form>
<SCRIPT LANGUAGE="JavaScript">
 izpis_dna('''||rasdi_client.c_registerto||''');
</SCRIPT>
</body>
</html>
    ');

      null;
    end;
  begin
    rasdc_library.log('CSSJS',pformid, 'START', vcom);

   /*
  if instr(owa_util.get_cgi_env('DOCUMENT_TABLE'),'.') = 0 then 
      v_table := owa_util.get_cgi_env('REMOTE_USER')||'.'||owa_util.get_cgi_env('DOCUMENT_TABLE'); 
    else v_table:=owa_util.get_cgi_env('DOCUMENT_TABLE');         
  end if;
  */
    v_table := 'zpizrasd.documents';
  begin
    null;
 -- select distinct owner||'.'||table_name into v_table
 -- from table_privileges where table_name = 'DOCUMENTS';
  
  --htp.p(v_table);
  exception when others then
    raise_application_error ('-20000','Could not locate DOCUMENTS table for connected user '||user||'.');
  end;
    
  --
    psubmit;

      select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;
           
      predogled := '<input type=button class=submitp value="' ||
                   RASDI_TRNSLT.text('Preview', lang) || '" ' ||
                   owa_util.ite(RASDC_LIBRARY.formhaserrors(v_form) = true,
                                'style="background-color: red;" title="' ||
                                RASDI_TRNSLT.text('Program has ERRORS!',
                                                  lang) || '" ',
                                owa_util.ite(RASDC_LIBRARY.formischanged(PFORMID) = true,
                                             'style="background-color: orange;" title="' ||
                                             RASDI_TRNSLT.text('Programa has changes. Compile it.',
                                                               lang) ||
                                             '" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ',
                                             'style="background-color: green;" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ')) || '>';    
    if ACTION = 'GBUTTONBCK' then
      pselect;
      poutput;
    elsif ACTION = 'GBUTTONFWD' then
      pselect;
      poutput;
    elsif ACTION = 'Search' then
      RECNUMb10 := 1;
      pselect;
      poutput;
    elsif ACTION = 'Save' then
      pcommit;

        rasdc_library.RefData(PFORMID);       

      pselect;
      
           message :=  RASDI_TRNSLT.text('Changes are saved.', lang);  
           
 if nvl(PAGE, 0) = 0 then
        if b20rform(1) is not null then
           message :=  message ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if;        
      end if;           

      poutput;
 
    elsif ACTION = 'GBUTTONCLR' then
      pclear;
      poutput;
    elsif action = RASDI_TRNSLT.text('Compile', lang) then
        rasdc_library.log('CSSJS',pformid, 'COMMIT_S', vcom);         
        pcommit;
        rasdc_library.log('CSSJS',pformid, 'COMMIT_E', vcom);             
        commit;
        rasdc_library.log('CSSJS',pformid, 'REF_S', vcom);                
        rasdc_library.RefData(PFORMID);         
        rasdc_library.log('CSSJS',pformid, 'REF_E', vcom);       
        rasdc_library.log('CSSJS',pformid, 'SELECT_S', vcom);                          
        pselect;
        rasdc_library.log('CSSJS',pformid, 'SELECT_E', vcom);       
        rasdc_library.log('CSSJS',pformid, 'COMPILE_S', vcom);          
        declare
         v_server RASD_ENGINES.server%type;
      cid      pls_integer;
      n        pls_integer;
      vup      varchar2(30) := rasdi_client.secGetUsername;
          v_form   varchar2(100);
        begin
      select upper(form)
        into v_form
        from RASD_FORMS
       where formid = PFORMID;          
        
          if v_form in ('RASDC_BLOCKSONFORM',
                        'RASDC_FIELDSONBLOCK',
                        'RASDC_TRIGGERS',
                        'RASDC_LINKS',
                        'RASDC_PAGES',
                        'F_FORME',
                        'RASDC_FORMS') then
            message := RASDI_TRNSLT.text('From is not generated.', lang);  
          else
            select server
              into v_server
              from RASD_FORMS_COMPILED fg, RASD_ENGINES g
             where fg.engineid = g.engineid
               and fg.formid = PFORMID
               and fg.editor = vup
               and (fg.lobid = rasdi_client.secGetLOB or
                   fg.lobid is null and rasdi_client.secGetLOB is null);

            cid := dbms_sql.open_cursor;
            dbms_sql.parse(cid,
                           'begin ' || v_server || '.form(' || PFORMID ||
                           ',''' || lang || ''');end;',
                           dbms_sql.native);
            n := dbms_sql.execute(cid);
            dbms_sql.close_cursor(cid);
            message := RASDI_TRNSLT.text('From is generated.', lang);  

       if b20rform(1) is not null then
           message :=  message ||  RASDI_TRNSLT.text('To unlink referenced code check:', lang)||'<input type="checkbox" name="UNLINK" value="Y"/>.';
        end if;        
                  
          end if;
        exception
          when others then
           if sqlcode = -24344 then
              
            message := RASDI_TRNSLT.text('Form is generated with compilation error. Check your code.', lang)||'('||sqlerrm||')';
             
            else
            message := RASDI_TRNSLT.text('Form is NOT generated - internal RASD error.', lang) || '('||sqlerrm||')<br>'||
                         RASDI_TRNSLT.text('To debug run: ', lang) || 'begin ' || v_server || '.form(' || PFORMID ||
                         ',''' || lang || ''');end;' ;
            end if; 
        end;
      rasdc_library.log('CSSJS',pformid, 'COMPILE_E', vcom);                  
        pselect;  
      rasdc_library.log('CSSJS',pformid, 'POUTPUT_S', vcom);  
      
      predogled := '<input type=button class=submitp value="' ||
                   RASDI_TRNSLT.text('Preview', lang) || '" ' ||
                   owa_util.ite(RASDC_LIBRARY.formhaserrors(v_form) = true,
                                'style="background-color: red;" title="' ||
                                RASDI_TRNSLT.text('Program has ERRORS!',
                                                  lang) || '" ',
                                owa_util.ite(RASDC_LIBRARY.formischanged(PFORMID) = true,
                                             'style="background-color: orange;" title="' ||
                                             RASDI_TRNSLT.text('Programa has changes. Compile it.',
                                                               lang) ||
                                             '" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ',
                                             'style="background-color: green;" onclick="x=window.open(''!' ||
                                             v_form ||
                                             '.webclient'','''','''')" ')) || '>';      
           
      poutput;  
      rasdc_library.log('CSSJS',pformid, 'POUTPUT_E', vcom);       
                  
    else
      pselect;
      rasdc_library.log('CSSJS',pformid, 'POUTPUT_S', vcom);       
        poutput;  
      rasdc_library.log('CSSJS',pformid, 'POUTPUT_E', vcom);       
    end if;
    rasdc_library.log('CSSJS',pformid, 'END', vcom);         

  exception
    when rasdi_client.e_finished then
      null;
    when others then
      htp.prn('<html><head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=WINDOWS-1250">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"><META HTTP-EQUIV="Expires" CONTENT="-1">      
'||RASDC_LIBRARY.RASD_UI_Libs||'      
<title></title>
</head>
<body><div class="htmlerror"><div class="htmlerrorcode">' ||
              sqlcode || '</div><div class="htmlerrortext">' || sqlerrm ||
              '</div></div></body><html>
    ');
  end;
end rasdc_cssjs;
/

