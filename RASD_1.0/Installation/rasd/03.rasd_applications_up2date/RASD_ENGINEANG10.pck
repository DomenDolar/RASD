create or replace package RASD_ENGINEANG10 is

/*
// +----------------------------------------------------------------------+
// | RASD - Rapid Application Service Development                         |
// +----------------------------------------------------------------------+
// | Copyright (C) 2017       http://rasd.sourceforge.net                 |
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


  type t_zipfile is record
  (
    filename varchar2(50),
    content clob
  ); 

  type zipfile is table of t_zipfile index by binary_integer;
  
function version(p_log out varchar2) return varchar2 ;
function generate(pformid number) return zipfile;


end RASD_ENGINEANG10;
/

create or replace package body RASD_ENGINEANG10 is

  function version(p_log out varchar2) return varchar2 is
  begin
   p_log := '/* Change LOG:
20171105 - Engine to export Angular 4 source code
*/';
   return 'v.'||rasd_engine10.c_engversion||'.0.20171105225530'; 
  
  end;

function generate(pformid number) return zipfile is
  content  zipfile;
  begin

    content(1).filename := 'test4.txt';
    content(1).content := '';
    
    content(2).filename := 'dir1/test1.txt';
    content(2).content := q'<A ŠĐČĆŽšđčćžfile with some more text, stored in a subfolder which isn't added>' ;

    content(3).filename := 'test1234.txt';
    content(3).content := 'A small file' ;

    content(4).filename := 'dir2/';
    content(4).content := '';

    content(5).filename := 'dir3/';
    content(5).content := '';

    content(6).filename := 'dir3/test2.txt';
    content(6).content :=  'A small filein a previous created folder' ;
    
  
   return content;
  
  end;

end RASD_ENGINEANG10;
/

