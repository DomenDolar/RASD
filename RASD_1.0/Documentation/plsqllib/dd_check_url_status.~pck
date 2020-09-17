create or replace package dd_check_url_status is
/*
STATUS

28.11.2006 - First version - Domen Dolar
*/


/*
create table CHECK_URL_STATUS
(
  URL    VARCHAR2(1000),
  TIME   DATE,
  STATUS NUMBER,
  TEXT   VARCHAR2(4000)
);
*/   
  
procedure izrisi_graf(p_url varchar2, p_dt integer, p_t1 date);
procedure izpisi_stanje(p_i varchar2 default null, novurl varchar2 default null, preveri varchar2 default null, zoom varchar2 default '43200', klicaj varchar2 default null);
--procedure izpisi_stanje(
--  name_array  in owa.vc_arr,
--  value_array in owa.vc_arr
--);
procedure test_url(p_url varchar2);
procedure testiraj_vse_url;
procedure dodaj_med_job;
procedure dodaj_med_job_optimizacija;


procedure izdelaj_porocilo(d date default null,  purl varchar2 default null);

procedure optimizacija_baze; 

procedure izpisi_tekst(p_rid varchar2);

end;
/
create or replace package body dd_check_url_status is

NAPAKA_BARVA VARCHAR2(30) := 'Red';
OK_BARVA VARCHAR2(30) := '#C6E3FF';
NEDEFINIRANO_BARVA VARCHAR2(30) := 'Yellow';

procedure izpisi_tekst(p_rid varchar2)  is
 v_tekst varchar(4000);
begin
 select text into v_tekst from CHECK_URL_STATUS p where rowid = chartorowid(p_rid);
 htp.p(v_tekst);
end;

procedure izrisi_graf(p_url varchar2, p_dt integer, p_t1 date) is
  dT integer;
  n number;
  t1 date := sysdate;
  pot_cas integer;
  pot_cas_razlika integer;
  color varchar2(20);
  vexit boolean;
begin
  -- Test statements here
--  p_url := 'x'; -- url, ki ga spremljamo
--  p_dT := 3600*12; --s je interval, ki ga želimo prikazati 1h
--  p_t1 := sysdate; -- datum od katerega želimo spremljati dogajanje
 
  dT := 100; --% lahko so potem tudi toèke
  n := dT/p_dT; -- število toèk na premici
  if p_t1 is not null then  t1 := p_t1; end if;
  pot_cas := 0;
  vexit := false;
htp.p('
<table width="100%" border=0 cellpadding=0 cellspacing=0>
  <TR>
    <TD align=center colspan=1000><B><A href="'||p_url||'" target="blank_">'||p_url||'</A></B></TD>
  </TR>
  <TR >
    <TD  width="10"  style="border-bottom : 2px solid Black; border-right : 2px solid Black;">&nbsp;&nbsp;</TD>
');
  for r in (
   select 
     time cas,  
     status, rowidtochar(rowid) rid
   from CHECK_URL_STATUS
   where url = p_url
     and time <= t1
   order by cas desc
  ) loop
  if pot_cas > p_dT then
    pot_cas_razlika := p_dt - pot_cas;
    pot_cas := p_dt;
    vexit := true;
  else
    pot_cas_razlika := (t1-r.cas)*24*3600 - pot_cas;
    if pot_cas_razlika+pot_cas > p_dt then 
       pot_cas_razlika := p_dt - pot_cas;       
       pot_cas := p_dt;
       vexit := true;
     else  
       pot_cas := (t1-r.cas)*24*3600;
     end if;  
  end if;  
  if pot_cas_razlika > p_dt then vexit := true; end if;
  
  if r.status = 1 then color := NAPAKA_BARVA;
  elsif r.status= -1 then color := NEDEFINIRANO_BARVA;
  else color := OK_BARVA;
  end if;
  
htp.p('
<TD ondblclick="javascript: var xxx = window.open(''dd_check_url_status.izpisi_tekst?p_rid='||r.rid||''',''xxx'',''width=800,height=500,scrollbars=1'')" style="border-bottom : 2px solid Black;border-right : 1px solid #939393;" align="right" valign="bottom" title="'||to_char(r.cas,'dd.mm.yyyy hh24:mi:ss')||'"  width="'||round(pot_cas_razlika*n)||'%" height="100" bgcolor="'||color||'"><img src="x" width="1" height="1" border="0"></TD>
');
 
  if vexit then exit; end if;
  
  end loop;
  if pot_cas < p_dt then
htp.p('
    <TD style="border-bottom : 2px solid Black;" width="'||round((p_dt-pot_cas)*n)||'%" height="100" bgcolor="White">&nbsp</TD>
'); 
  end if;
  
htp.p('
   </TR></table>
');
  htp.p('
<TABLE width="100%" border=0 cellpadding=0 cellspacing=0>
  <TR >
    <TD align=left width="50%">'||to_char(t1,'dd.mm.yyyy hh24:mi:ss')||'</TD>
    <TD  align=right width="50%">'||to_char(t1-(p_dt/(24*3600)),'dd.mm.yyyy hh24:mi:ss')||'</TD>
  </TR>
</table>'); 
end;

FUNCTION namedParam(
  p_searchVal   in varchar2,
  p_name_array  in owa.vc_arr,
  p_value_array in owa.vc_arr) RETURN varchar2 IS

i integer;
BEGIN
  FOR i IN 1..p_name_array.count LOOP
    if p_name_array(i)=p_searchVal then
      return p_value_array(i);
    end if;
  END LOOP;
  return null;
END;

procedure izpisi_stanje(p_i varchar2 default null, novurl varchar2 default null, preveri varchar2 default null, zoom varchar2 default '43200', klicaj varchar2 default null) is
  -- Local variables here
  i integer;
  p date;
  k integer;
begin
  -- Test statements here
  i := to_number(zoom);
  
  
  if p_i is null then
    p := sysdate;
  else
      p := to_date(p_i,'dd.mm.yyyyhh24:mi:ss');
      if p > sysdate then 
        p := sysdate; 
      end if;
  end if;  
  
    
  select count(*) into k
  from user_jobs u where lower(u.what) like '%dd_check_url_status.testiraj_vse_url;%';
  
  htp.p('
<html>
<head>
	<title>Show working of internet pages</title>
</head>
<body onLoad="setTimeout(''location=\'''||klicaj||'dd_check_url_status.izpisi_stanje?zoom='||zoom||'\'''',300000);">
  <H1 align=center>Show working of internet pages - ');
  if k = 0 then
    htp.p('NOT WORKING');
  else
    htp.p('WORKING');
  end if;
  htp.p('</H1>');
  htp.p('<P align=center><A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?p_i='||to_char(p+(i/(24*3600)),'dd.mm.yyyyhh24:mi:ss')||'&zoom='||zoom||'"><--</A>');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?zoom='||round(i/2)||'">+</A>&nbsp;&nbsp;');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje">@</A>&nbsp;&nbsp;');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?zoom='||round(i*2)||'">-</A>&nbsp;&nbsp;');
  htp.p('<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?p_i='||to_char(p-(i/(24*3600)),'dd.mm.yyyyhh24:mi:ss')||'&zoom='||zoom||'">--></A></P>');
  
  htp.p('<TABLE width="90%"><TR width="90%"><TD>');
  for r in (select distinct url from CHECK_URL_STATUS t
  order by url) loop  
      htp.p('<BR><BR>');
      izrisi_graf(r.url,i, p);  
  end loop;
  htp.p('</TD></TR></TABLE>');
  htp.p('<P align=center><A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?p_i='||to_char(p+(i/(24*3600)),'dd.mm.yyyyhh24:mi:ss')||'&zoom='||zoom||'"><--</A>');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?zoom='||round(i/2)||'">+</A>&nbsp;&nbsp;');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje">@</A>&nbsp;&nbsp;');
  htp.p('&nbsp;&nbsp;<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?zoom='||round(i*2)||'">-</A>&nbsp;&nbsp;');
  htp.p('<A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?p_i='||to_char(p-(i/(24*3600)),'dd.mm.yyyyhh24:mi:ss')||'&zoom='||zoom||'">--></A></P>');
  htp.p('<BR>Add new URL:<input type=text name=novurl><input type=button name=Potrdi value="Dodaj" onclick="location='''||klicaj||'dd_check_url_status.izpisi_stanje?p_i='||to_char(p+(i/(24*3600)),'dd.mm.yyyyhh24:mi:ss')||'&novurl=''+novurl.value">');  
  htp.p('<BR>Check working now? <A href ="'||klicaj||'dd_check_url_status.izpisi_stanje?preveri=TRUE">Yes</A> ');
  htp.p('<BR><A href ="'||klicaj||'dd_check_url_status.izdelaj_porocilo">Working report</A> ');
  htp.p('<P align=right><FONT size=1>Domen Dolar, domen.dolar@gmail.com</FONT></P>
</body>
</html>  
  ');
  if novurl is not null then
    insert into CHECK_URL_STATUS (url,time,status) values (novurl,sysdate,-1);
  end if;
  if preveri = 'TRUE' then
    if k = 0 then  
      dodaj_med_job;
      update CHECK_URL_STATUS p set status = -1 
      where (url,time) in 
      (select p.url, max(time) from CHECK_URL_STATUS p group by p.url);    
    else
      select u.job into k
      from user_jobs u where lower(u.what) like '%dd_check_url_status.testiraj_vse_url;%';
      
      dbms_job.run(k);    
    
      
    end if; 
  end if;

end;

--procedure izpisi_stanje(
--  name_array  in owa.vc_arr,
--  value_array in owa.vc_arr
--) is
--begin
-- izpisi_stanje1(namedParam('p_i',name_array,value_array), namedParam('novurl',name_array,value_array), namedParam('preveri',name_array,value_array), namedParam('zoom',name_array,value_array), '!');
--end;


procedure test_url(p_url varchar2) is
 v varchar2(4000);
 a varchar2(10);
begin
 v := utl_http.request(p_url);
 
 for i in 1..length(v) loop
   a := substr(v,i,1);  
 end loop;
 
 if instr(upper(p_url),'IZRACUN') > 0 and instr(upper(v),'(3CV1)') = 0 then
   raise_application_error('-20000','');
 end if;

 if instr(upper(v),'IO EXCEPTION: BROKEN PIPE') > 0 and instr(v,'(3CV1)') = 0 then
   raise_application_error('-20000','');
 end if;
   
 if instr(upper(v),'SPLETKARADMIN.CVI@GOV.SI') > 0 then
   raise_application_error('-20000','');
 end if;
  
 if instr(upper(v),'WAS NO RESPONSE FROM') > 0 then
   raise_application_error('-20000','');
 end if;
 
 if instr(upper(v),'WAS NOT FOUND ON THIS SERVER') > 0 then
   raise_application_error('-20000','');
 end if;
 
 
 insert into CHECK_URL_STATUS
   (url, time, status,text)
 values
   (p_url,sysdate, 0,v);
 commit;   
exception when others then   
 insert into CHECK_URL_STATUS
   (url, time, status,text)
 values
   (p_url,sysdate, 1,v);
 commit;      
end ;


procedure testiraj_vse_url is
begin
  
  declare 
    v_interval varchar2(200);
    v_lastdate date;
    v_SQL varchar2(500);
  begin
    select interval into v_interval
    from user_jobs where upper(what) like upper('%testiraj_vse_url%');
    select max(x.time) into v_lastdate from CHECK_URL_STATUS x;
    
    v_SQL :=  'update CHECK_URL_STATUS p set status = -1 
               where (url,time) in 
               (select p.url, max(time) from CHECK_URL_STATUS p group by p.url)
                and (sysdate - to_date('''||to_char(v_lastdate,'dd.mm.yyyy hh24:mi:ss')||''',''dd.mm.yyyy hh24:mi:ss'')) > 2*(sysdate - '||v_interval||')';
    execute immediate v_sql;                
    commit;                 
  exception when others then null;
  end;


  for r in (select distinct url from CHECK_URL_STATUS t
  order by url) loop 
  
  test_url(r.url);
  
  end loop;  
end;

procedure dodaj_med_job is
 i integer;
begin
  dbms_job.submit(i,'begin dd_check_url_status.testiraj_vse_url; end;',sysdate,'sysdate+5/(24*60)');
end;

procedure dodaj_med_job_optimizacija is
 i integer;
begin
  dbms_job.submit(i,'begin dd_check_url_status.optimizacija_baze; end;',to_date(to_char(sysdate,'dd.mm.yyyy')||' 5:00:00','dd.mm.yyyy hh24:mi:ss'),'sysdate+1');
end;


procedure izpis_porocila_url( purl varchar2, pd date default null) is
  y date := sysdate;
  x date := sysdate;
  v_status CHECK_URL_STATUS.status%type;
  v_url CHECK_URL_STATUS.url%type;
  v_d date;
  v_xd date;
begin
if pd is null then
  v_d := sysdate - 7;
else 
  v_d := pd;  
end if; 

select nvl(max(time),sysdate) into v_xd
from CHECK_URL_STATUS
where time < v_d
  and url = purl;

htp.p('
<P align="center"><B><A href="'||purl||'" target="blank_">'||purl||'</A> </B></P>
<TABLE width="50%" border="1" cellpadding=0 cellspacing=0>
<TR>
<TH width="20%">From</TH>
<TH width="20%">To</TH>
<TH width="10%">Difference (s)</TH>
</TR>
');
  

  for r in (
select url, time cas, status, rownum ri from CHECK_URL_STATUS
where time >= v_xd
  and url = purl
order by 1,2  
  ) loop
if r.ri = 1 then
  y := r.cas;
end if;

if r.status = 1 and (v_status <> r.status or v_url <> r.url) then --gremo na napako
  y := r.cas;  
end if;
if r.status <> 1 and (v_status <> r.status or v_url <> r.url) then  
  x := r.cas;
  if x >= y and r.status = 0 then
htp.p('
<TR>
<TD>'||to_char(y,'dd.mm.yyyy hh24:mi:ss')||'</TD>
<TD>'||to_char(x,'dd.mm.yyyy hh24:mi:ss')||'</TD>
<TD align=right bgcolor="'||NAPAKA_BARVA||'">'||to_char(round((x-y)*24*3600))||'</TD>
</TR>
');
  end if;
end if;
v_status := r.status;
v_url := r.url;
  end loop;

if v_status = 1 then
htp.p('
<TR>
<TD>'||to_char(y,'dd.mm.yyyy hh24:mi:ss')||'</TD>
<TD>'||to_char(sysdate,'dd.mm.yyyy hh24:mi:ss')||'</TD>
<TD align=right bgcolor="'||NAPAKA_BARVA||'">'||to_char(round((sysdate-y)*24*3600))||'</TD>
</TR>
');
end if;  
  
htp.p('</TABLE>('||to_char(v_xd,'dd.mm.yyyy hh24:mi:ss')||'-'||to_char(sysdate,'dd.mm.yyyy hh24:mi:ss')||')');


end;


procedure izdelaj_porocilo(d date default null,  purl varchar2 default null) is 
begin
  -- Test statements here
  htp.p('
<html>
<head>
	<title>Report of NOT working </title>
</head>
<body>
  <H1 align=center>Report of NOT working </H1>');

  htp.p('<P align=center>');
  htp.p('&nbsp;&nbsp;<A href ="javascript: history.go(-1);">Back</A>');
  htp.p('</P>');

 
for r1 in (select distinct url from CHECK_URL_STATUS where (url = purl or purl is null) order by 1) loop  
  
  izpis_porocila_url(r1.url,d);

end loop;  
  

  htp.p('<P align=center>');
  htp.p('&nbsp;&nbsp;<A href ="javascript: history.go(-1);">Back</A>');
  htp.p('</P>');

htp.p('</BODY></HTML>');

end;


procedure optimizacija_baze is 

 v_status CHECK_URL_STATUS.status%type := -2;

begin
  -- Test statements here

--ARHIVIRAMO STARE !!!
declare
 x_datum date := sysdate;
begin
  --insert into CHECK_URL_STATUS (url,cas,status,tekst)
  --select url,time,status,text from preverjanje_delovanja p
  --where p.time < x_datum-30;
  delete from CHECK_URL_STATUS p
  where p.time < x_datum-30;
end;

  
  
--OPTIMIZACIJA  
for r1 in (select distinct url from CHECK_URL_STATUS order by 1) loop  


  for r in (
select url, time cas, status, rowid rid from CHECK_URL_STATUS
where url = r1.url
  and time < (sysdate-1/24)
order by 1,2  
  ) loop
if v_status <> r.status then  
  null;
else  
   delete from  CHECK_URL_STATUS where rowid = r.rid;
end if;

v_status := r.status;
  end loop;
  

end loop;  


commit;

end;



end ;
/
