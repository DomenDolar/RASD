create or replace procedure TestCaptcha (
  name_array  in owa.vc_arr,
  value_array in owa.vc_arr
)
as
 x raw(100);
 vcapchapreveri raw(100);
 vcapchavrednost raw(100);
 v varchar2(100);
begin
    for i__ in 1..nvl(name_array.count,0) loop
      if name_array(i__) = 'capchavrednost' then vcapchavrednost := value_array(i__);
      elsif name_array(i__) = 'capchapreveri' then vcapchapreveri := utl_raw.cast_to_raw(value_array(i__));
      end if;
    end loop;
begin

if utl_encode.base64_encode(vcapchapreveri) = vcapchavrednost then
  htp.p ('OK<BR>');
else
  htp.p ('NOT OK<BR>'); 
end if;

exception when others then null;
  htp.p ('NOT OK<BR>'); 
end;
 v := dd_random.rndchar||dd_random.rndchar||dd_random.rndchar||dd_random.rndchar;

 x := utl_raw.cast_to_raw(v);
 x := utl_encode.base64_encode(x);

htp.p('


<form method=post>
<img src="!Captcha?pt='||x||'">
<input type="text" name="capchapreveri" value="" size="4" maxlength="4">
<input type="hidden" name="capchavrednost" value="'||x||'">

<input type="submit" name="nnnn" value="Check">
</form>
');

exception when others then htp.p(sqlerrm);
end;
/
