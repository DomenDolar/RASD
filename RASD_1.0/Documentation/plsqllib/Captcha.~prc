create or replace procedure Captcha (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
) is
 pt raw(100);
 l_lob blob;
 vt varchar2(100);
 FUNCTION namedParam(
  p_searchVal   in varchar2,
  p_name_array  in owa.vc_arr,
  p_value_array in owa.vc_arr
  ) RETURN varchar2 IS
  i integer;
 BEGIN
  FOR i IN 1..nvl(p_name_array.count,0) LOOP
    if p_name_array(i)=p_searchVal then
      return p_value_array(i);
    end if;
  END LOOP;
  return null;
 END;
begin
pt := namedParam(
  'pt',
  name_array ,
  value_array
  );
pt := utl_encode.base64_decode(pt);
vt := utl_raw.cast_to_varchar2(pt);
l_lob := dd_bmp.captcha(vt);
owa_util.mime_header( 'image/bmp', FALSE );
htp.p('Content-length: '  || dbms_lob.getlength( l_lob ));
owa_util.http_header_close;
wpg_docload.download_file( l_lob );

end;
/
