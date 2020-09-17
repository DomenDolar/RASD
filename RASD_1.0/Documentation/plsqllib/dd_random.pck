create or replace package dd_random is
/*
STATUS

28.11.2006 - First version - Domen Dolar
*/

/* Linear congruential random number generator */   
   
/* Returns random integer between [0, r-1] */   
function rndint(r in number) return number;   
   
/* Returns random real between [0, 1] */   
function rndflt return number;   

/* Returns random real between [0, 1] */   
function rndchar return varchar2;   

end ;
/
create or replace package body dd_random is

/* Linear congruential random number generator */   
  
m constant number:=100000000;  /* initial conditions */   
m1 constant number:=10000;     /* (for best results) */   
b constant number:=31415821;   /*                    */   
   
a number;                      /* seed */   
   
the_date date;                 /*                             */   
days number;                   /* for generating initial seed */   
secs number;                   /*                             */   
   
/*-------------------------- mult ---------------------------*/   
/* Private utility function */   
   
function mult(p in number, q in number) return number is   
   p1 number;   
   p0 number;   
   q1 number;   
   q0 number;   
begin   
   p1:=trunc(p/m1);   
   p0:=mod(p,m1);   
   q1:=trunc(q/m1);   
   q0:=mod(q,m1);   
   return(mod((mod(p0*q1+p1*q0,m1)*m1+p0*q0),m));   
end;   /* mult */   
   
/*-------------------------- rndint --------------------------*/   
/* Returns random integer between [0, r-1] */   
   
function rndint (r in number) return number is   
begin   
   /* generate a random number and set it to be the new seed */   
   a:=mod(mult(a,b)+1,m);   
   
   /* convert it to integer between [0, r-1] and return it */   
   return(trunc((trunc(a/m1)*r)/m1));   
end;   /* rndint */   
   
/*-------------------------- rndflt --------------------------*/   
/* Returns random real between [0, 1] */   
   
function rndflt return number is   
begin   
   /* generate a random number and set it to be the new seed */   
   a:=mod(mult(a,b)+1,m);   
   
   /* return it */   
   return(a/m);   
end;   /* rndflt */   

function rndchar return varchar2 is   
 i number;
 v varchar2(1);
begin   
   i := rndint(34);
   if i = 0 then v := 'a';
   elsif i = 1 then v := 'b';
   elsif i = 2 then v := 'c';
   elsif i = 3 then v := 'c';
   elsif i = 4 then v := 'd';
   elsif i = 5 then v := 'e';
   elsif i = 6 then v := 'f';
   elsif i = 7 then v := 'g';
   elsif i = 8 then v := 'h';
   elsif i = 9 then v := 'i';
   elsif i = 10 then v := 'j';
   elsif i = 11 then v := 'k';
   elsif i = 12 then v := 'l';
   elsif i = 13 then v := 'm';
   elsif i = 14 then v := 'n';
   elsif i = 15 then v := 'o';
   elsif i = 16 then v := 'p';
   elsif i = 17 then v := 'r';
   elsif i = 18 then v := 's';
   elsif i = 19 then v := 's';
   elsif i = 20 then v := 't';
   elsif i = 21 then v := 'u';
   elsif i = 22 then v := 'v';
   elsif i = 23 then v := 'z';
   elsif i = 24 then v := 'z';
   elsif i = 25 then v := '1';
   elsif i = 26 then v := '2';
   elsif i = 27 then v := '3';
   elsif i = 28 then v := '4';
   elsif i = 29 then v := '5';
   elsif i = 30 then v := '6';
   elsif i = 31 then v := '7';
   elsif i = 32 then v := '8';
   elsif i = 33 then v := '9';
   elsif i = 34 then v := '0';
   end if;   
   return v;   
end;
  
   
begin   /* package body random */   
   /* Generate an initial seed "a" based on system date */   
   /* (Must be connected to database.)                  */   
   the_date:=sysdate;   
   days:=to_number(to_char(the_date, 'J'));   
   secs:=to_number(to_char(the_date, 'SSSSS'));   
   a:=days*24*3600+secs;   
end ;
/
