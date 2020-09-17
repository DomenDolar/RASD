set feedback off
set define off
spool 2.rasd_clinet_table_of_user_scott.log
prompt Creating BONUS...
create table BONUS
(
  ename VARCHAR2(10),
  job   VARCHAR2(9),
  sal   NUMBER,
  comm  NUMBER
)
;

prompt Creating DEPT...
create table DEPT
(
  deptno NUMBER(2) not null,
  dname  VARCHAR2(14),
  loc    VARCHAR2(13)
)
;
alter table DEPT
  add constraint PK_DEPT primary key (DEPTNO);

prompt Creating EMP...
create table EMP
(
  empno    NUMBER(4) not null,
  ename    VARCHAR2(10),
  job      VARCHAR2(9),
  mgr      NUMBER(4),
  hiredate DATE,
  sal      NUMBER(7,2),
  comm     NUMBER(7,2),
  deptno   NUMBER(2),
  note     VARCHAR2(300)
)
;
alter table EMP
  add constraint PK_EMP primary key (EMPNO);
alter table EMP
  add constraint FK_DEPTNO foreign key (DEPTNO)
  references DEPT (DEPTNO);

prompt Creating JOBS...
create table JOBS
(
  job         VARCHAR2(9) not null,
  description VARCHAR2(40)
)
;

prompt Creating SALGRADE...
create table SALGRADE
(
  grade NUMBER,
  losal NUMBER,
  hisal NUMBER
)
;

prompt Disabling triggers for BONUS...
alter table BONUS disable all triggers;
prompt Disabling triggers for DEPT...
alter table DEPT disable all triggers;
prompt Disabling triggers for EMP...
alter table EMP disable all triggers;
prompt Disabling triggers for JOBS...
alter table JOBS disable all triggers;
prompt Disabling triggers for SALGRADE...
alter table SALGRADE disable all triggers;
prompt Disabling foreign key constraints for EMP...
alter table EMP disable constraint FK_DEPTNO;
prompt Truncating SALGRADE...
truncate table SALGRADE;
prompt Truncating JOBS...
truncate table JOBS;
prompt Truncating EMP...
truncate table EMP;
prompt Truncating DEPT...
truncate table DEPT;
prompt Truncating BONUS...
truncate table BONUS;
prompt Loading BONUS...
insert into BONUS (ename, job, sal, comm)
values ('ADAMS', 'CLERK', 1102.12, 1400);
insert into BONUS (ename, job, sal, comm)
values ('FORD', 'ANALYST', 1600.11, 500);
commit;
prompt 2 records loaded
prompt Loading DEPT...
insert into DEPT (deptno, dname, loc)
values (10, 'ACCOUNTING', 'NEW YORK');
insert into DEPT (deptno, dname, loc)
values (20, 'RESEARCH', 'DALLAS');
insert into DEPT (deptno, dname, loc)
values (30, 'SALES', 'CHICAGO');
insert into DEPT (deptno, dname, loc)
values (40, 'OPERATIONS', 'BOSTON');
commit;
prompt 4 records loaded
prompt Loading EMP...
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7944, 'JOHN DOE', 'SALESMAN', 7499, to_date('01-05-0081', 'dd-mm-yyyy'), 2850, null, 30, 'note');
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7369, 'SMITH', 'CLERK', 7902, to_date('17-12-0080', 'dd-mm-yyyy'), 800, null, 20, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7499, 'ALLEN', 'SALESMAN', 7698, to_date('13-11-2013', 'dd-mm-yyyy'), 1600.18, 300, 10, 'note2');
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7521, 'WARD', 'SALESMAN', 7698, to_date('22-02-0081', 'dd-mm-yyyy'), 1250, 500, null, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7566, 'JONES', 'MANAGER', 7839, to_date('02-04-0081', 'dd-mm-yyyy'), 2975, null, 20, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7654, 'MARTIN', 'SALESMAN', 7698, to_date('28-09-0081', 'dd-mm-yyyy'), 1250, 1400, null, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7698, 'BLAKE', 'SALESMAN', 7839, to_date('13-11-2013', 'dd-mm-yyyy'), 2850, null, 10, 'note3');
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7782, 'CLARK', 'MANAGER', 7839, to_date('09-06-1981', 'dd-mm-yyyy'), 2450, 11, 20, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7788, 'SCOTT', 'ANALYST', 7566, to_date('19-04-0087', 'dd-mm-yyyy'), 3000, null, 20, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7839, 'KING', 'PRESIDENT', null, to_date('17-11-0081', 'dd-mm-yyyy'), 5000, null, 10, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7844, 'TURNER', 'SALESMAN', 7698, to_date('08-09-1981', 'dd-mm-yyyy'), 1500, 0, 30, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7876, 'ADAMS', 'CLERK', 7782, to_date('13-05-2014', 'dd-mm-yyyy'), 1102.13, 22, 10, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7900, 'JAMES', 'CLERRK', 7698, to_date('03-12-2081', 'dd-mm-yyyy'), 950, null, 30, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7902, 'FORD', 'ANALYST', 7566, to_date('03-12-2081', 'dd-mm-yyyy'), 3000, null, 20, null);
insert into EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno, note)
values (7934, 'MILLER', 'CLERK', 7782, to_date('23-01-1982', 'dd-mm-yyyy'), 1300, null, 10, null);
commit;
prompt 15 records loaded
prompt Loading JOBS...
insert into JOBS (job, description)
values ('CLERK', 'CLERK DESCRIPTION');
insert into JOBS (job, description)
values ('SALESMAN', 'SALESMAN DESCRIPTION');
insert into JOBS (job, description)
values ('MANAGER', 'MANAGER DESCRIPTION');
insert into JOBS (job, description)
values ('ANALYST', 'ANALYST DESCRIPTION');
insert into JOBS (job, description)
values ('PRESIDENT', 'PRESIDENT DESCRIPTION');
commit;
prompt 5 records loaded
prompt Loading SALGRADE...
insert into SALGRADE (grade, losal, hisal)
values (1, 700, 1200);
insert into SALGRADE (grade, losal, hisal)
values (2, 1201, 1400);
insert into SALGRADE (grade, losal, hisal)
values (3, 1401, 2000);
insert into SALGRADE (grade, losal, hisal)
values (4, 2001, 3000);
insert into SALGRADE (grade, losal, hisal)
values (5, 3001, 9999);
commit;
prompt 5 records loaded
prompt Enabling foreign key constraints for EMP...
alter table EMP enable constraint FK_DEPTNO;
prompt Enabling triggers for BONUS...
alter table BONUS enable all triggers;
prompt Enabling triggers for DEPT...
alter table DEPT enable all triggers;
prompt Enabling triggers for EMP...
alter table EMP enable all triggers;
prompt Enabling triggers for JOBS...
alter table JOBS enable all triggers;
prompt Enabling triggers for SALGRADE...
alter table SALGRADE enable all triggers;
set feedback on
set define on
prompt Done.
spool off