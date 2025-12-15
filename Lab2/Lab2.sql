use SD

-- Department
sp_Addtype loc, 'nchar(2)'

create default d1 as 'NY'
create rule r1 as @x in ('NY','DS','KW')

sp_bindrule r1,loc
sp_bindefault d1,loc

create table Department
(
 DeptNo varchar(5) primary key,
 DeptName varchar(20),
 Location loc
)

-- Employee
create table Employee
(
 EmpNo int primary key,
 Fname varchar(15) not null,
 Lname varchar(15) not null,
 Salary int,
 DeptNo varchar(5),
 constraint c1 foreign key(DeptNo) references Department(DeptNo),
 constraint c2 unique(Salary),
)

create rule r2 as @s<6000
sp_bindrule r2,'Employee.Salary'

--------------------------
insert into Department values
('d1','Research','NY'),
('d2','Accounting','DS'),
('d3','Marketing','KW')

insert into Employee values
(25348,'Mathew','Smith',2500,'d3'),
(10102,'Ann','Jones',3000,'d3'),
(9031,'Lisa','Hansel',4000,'d2')

insert into Project values
('p1','Apollo',120000),
('p2','Gemini',65000),
('p3','Mercury',1850000)

insert into Works_On values
(10102,'p1','Analyst','2006-10-01'),
(10102,'p3','Manager','2012-01-01'),
(9031,'p1','Manager','2007-04-15')

--- Testing Referential Integrity
-- 1
insert into Works_on values (11111,'p3','Analyst',GETDATE())

-- 2
update Works_On
set EmpNo=11111
where EmpNo=10102

-- 3
update Employee
set EmpNo=22222
where EmpNo=10102

-- 4
delete from Employee where EmpNo=10102

----- Table modification
-- 1
alter table Employee add TelNumber varchar(15)
--2
alter table Employee drop column TelNumber

---------------------
--2
create schema Company
alter schema Company transfer Department

create schema HR
alter schema HR transfer Employee

-- 3
sp_helpconstraint 'HR.Employee';

-- 4
create synonym Emp for HR.Employee

select * from Employee
select * from HR.Employee
select * from Emp
select * from HR.Emp

-- 5
update Company.Project
set budget=budget*1.10
where ProjectNo = (select p.ProjectNo
		from Company.Project p join Works_On w
		on p.ProjectNo = w.ProjectNo and w.EmpNo=10102
		and w.Job='Manager')

-- 6
update Company.Department
set DeptName='Sales'
where DeptNo= (select d.DeptNo
	from Company.Department d join HR.Employee e
	on d.DeptNo=e.DeptNo and e.Fname='Ann')

-- 7
update Works_On
set Enter_Date='2007-12-12'
where EmpNo= (select e.EmpNo
	from HR.Employee e join Company.Department d
	on e.DeptNo=d.DeptNo and d.DeptName='Sales'
	join Works_On w on w.EmpNo=e.EmpNo and w.ProjectNo='p1')

-- 8
delete from Works_On
where EmpNo in (select e.EmpNo
	from HR.Employee e join Company.Department d
	on e.DeptNo=d.DeptNo and d.Location='KW')

