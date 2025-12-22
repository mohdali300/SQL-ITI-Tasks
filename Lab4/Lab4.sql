use ITI

-- 1
create view vstud as
	select isnull(s.St_Fname+' '+s.St_Lname,'no name') as fullname, c.Crs_Name
	from Student s join Stud_Course sc
	on s.St_Id=sc.St_Id
	join Course c on c.Crs_Id=sc.Crs_Id
	where sc.Grade>50

select * from vstud

-- 2
create view vmgr
with encryption as
	select i.Ins_Name, t.Top_Name
	from Instructor i join Department d
	on i.Ins_Id=d.Dept_Manager
	join Ins_Course ic on i.Ins_Id=ic.Ins_Id
	join Course c on c.Crs_Id=ic.Crs_Id
	join Topic t on t.Top_Id=c.Top_Id

select * from vmgr

-- 3
create view vDept as
	select i.Ins_Name, d.Dept_Name
	from Instructor i join Department d
	on i.Dept_Id=d.Dept_Id
	where d.Dept_Name in ('SD','Java')

select * from vDept

-- 4
create view V1 as
	select * from Student
	where St_Address in ('Cairo','Alex')
	with check option

Update V1 set st_address='tanta'
Where st_address='alex'

-- 5
use Company_SD

create view vProj as
	select p.Pname, count(w.ESSn) as totalEmp
	from Project p join Works_for w
	on p.Pnumber=w.Pno
	group by p.Pname

select * from vProj

-- 6
create clustered index IX_Dept_MGRStartDate
on Departments([MGRStart Date])

-- 7
create unique index IX_Student_age
on Student(St_Age)

-- 8
merge Daily_Transactions as t
using Last_Transactions as s
on t.UserID = s.UserID

when matched then
    update
    set t.Amount = s.Amount

when not matched by target then
    insert (UserID, Amount)
    values (s.UserID, s.Amount)

when not matched by source then delete;

----------------------------------------
-- 1
create view v_clerk
as
select
    w.empno,
    w.pno,
    w.hiredate
from work_on w
where w.job = 'clerk';

select * from v_clerk

-- 2
create view v_without_budget
as
select *
from project
where budget is null;

select * from v_without_budget

-- 3
create view v_count
as
select
    p.name,
    count(w.empno) as job_count
from project p
left join work_on w on p.pno = w.pno
group by p.name;

select * from v_count

-- 4
create view v_project_p2
as
select empno
from v_clerk
where pno = 20;

select * from v_project_p2

-- 5
alter view v_without_budget
as
select *
from project
where pno in (100, 200);


-- 6
drop view v_clerk;
drop view v_count;

-- 7
create view v_emp_d2
as
select
    e.empno,
    e.lname
from employee e
where e.deptno = 30;

select * from v_emp_d2

-- 8
select lname
from v_emp_d2
where lname like '%j%';

-- 9
create view v_dept
as
select
    deptno,
    deptname
from department;

select * from v_dept

-- 10
insert into v_dept (deptno, deptname)
values (50, 'development');

select * from v_dept

-- 11
create view v_2006_check
as
select
    empno,
    pno,
    hiredate
from work_on
where hiredate between '2006-01-01' and '2006-12-31';

select * from v_2006_check




