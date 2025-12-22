use ITI

-- 1
create proc studNum
as
	select count(St_Id), d.Dept_Name
	from Student s join Department d
	on s.Dept_Id=d.Dept_Id
	group by d.Dept_Name

exec studNum

-- 2
use Company_SD
create proc p1Emps
as
    declare @emp_count int;
    select @emp_count = count(*)
    from works_for
    where pno = (select top(1) Pnumber from project)

    if @emp_count>= 3
        select 'the number of employees in the project p1 is 3 or more'
    else
    begin
        print 'the following employees work for the project p1'
        select e.fname, e.lname
        from employee e
        join Works_for w on e.SSN = w.ESSn
        where w.pno = 100
    end

exec p1Emps

-- 3
create proc replaceEmp
(
    @old_emp int,
    @new_emp int,
    @pno varchar(10)
)
as
begin try
    update Works_for
    set ESSn = @new_emp
    where ESSn = @old_emp and pno = @pno
end try
begin catch
	select ERROR_MESSAGE()
end catch

exec replaceEmp 521634,968574,500 --300

-- 4
alter table project add budget int

update project
set budget = 95000
where Pnumber = 100

update project
set budget = 120000
where Pnumber = 100

create table project_audit
(
    projectno int,
    username varchar(50),
    modifieddate date,
    budget_old int,
    budget_new int
)

create trigger tr1
on project
after update
as
    if update(budget)
    begin
        insert into project_audit
        select
            d.Pnumber,
            suser_name(),
            getdate(),
            d.budget,
            i.budget
        from deleted d
        join inserted i
            on d.Pnumber = i.Pnumber;
    end

update project
set budget = 200000
where Pnumber = 100;

select * from project_audit

-- 5
create trigger tr_insDept
on department
instead of insert
as
    select 'you cannot insert a new record in department table'

insert into Department (Dept_Id, Dept_Name)
values (1000, 'Cloud Arch')

-- 6
create trigger tr_insEmp
on employee
instead of insert
as
    if month(getdate())=3
        select 'insertion is not allowed in employee table during march'
    else
    begin
        insert into employee
        select *
        from inserted;
    end

-- 7
create table student_audit
(
    username varchar(50),
    audit_date date,
    note varchar(200)
)

create trigger tr_studIns
on student
after insert
as
    insert into student_audit
    select suser_name(), getdate(),
        suser_name()+' insert new row with key= '
        +convert(varchar(20),st_id)
        +' in table student'
    from inserted

insert into Student (St_Id,St_Fname)
values (36565,'Ali')

select * from student_audit

-- 8
create trigger tr_studDel
on student
instead of delete
as
    insert into student_audit
    select
        suser_name(),
        getdate(),
        'try to delete row with key= '
        +convert(varchar(20),st_id)
    from deleted

delete from Student where St_Id=12345

