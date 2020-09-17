create or replace view rasd_vw_fields as
select
  p.formid, p.fieldid, p.blockid, p.nameid, upper(p.blockid||p.fieldid) name,
  decode(p.blockid,null,p.nameid,
    decode(nvl(numrows,1),1,decode(nvl(emptyrows,0),0,p.nameid||'_1'
    , p.nameid||'_''||i'||p.blockid||'||''')
    , p.nameid||'_''||i'||p.blockid||'||''')
    ) namecode,
  decode(b.blockid,null
    , p.blockid||p.fieldid,
  decode(nvl(numrows,1),1,decode(nvl(emptyrows,0),0
    , p.blockid||p.fieldid||'(1)'
    , p.blockid||p.fieldid||'(i'||p.blockid||')')
    , p.blockid||p.fieldid||'(i'||p.blockid||')')
    ) valuecode,
  decode(nvl(p.element,'INPUT_TEXT'), 'PLSQL_',
    t.plsql
  ,
  decode(p.type,'N', 'ltrim(to_char('
              ,'D', 'to_char('
              ,'T', 'to_char('
              ,'R', 'to_char('
                  , '')||
  decode(b.blockid,null
    , p.blockid||p.fieldid,
  decode(nvl(numrows,1),1,decode(nvl(emptyrows,0),0
    , p.blockid||p.fieldid||'(1)'
    , p.blockid||p.fieldid||'(i'||p.blockid||')')
    , p.blockid||p.fieldid||'(i'||p.blockid||')')
  )||
  decode(p.type,'N',decode(p.format,null, '))'
                                       , ','||p.format||'))')
              ,'D',decode(p.format,null, ',rasd_client.C_DATE_FORMAT)'
                                       , ','||p.format||')')
              ,'T',decode(p.format,null, ',rasd_client.C_TIMESTAMP_FORMAT)'
                                       , ','||p.format||')')
              ,'R',decode(p.format,null, ')'
                                       , ','''||p.format||''')')
                  ,''
  )) valuetochar, p.element, p.includevis, b.numrows
from rasd_fields p, rasd_blocks b, rasd_triggers t
where b.formid(+) = p.formid
  and b.blockid(+) = p.blockid
  and t.formid(+) = p.formid
  and t.blockid(+) = p.blockid||p.fieldid
  and t.triggerid(+) = 'ON_UI'
  and p.nameid is not null;
