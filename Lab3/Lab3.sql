use ITI

-- 1
create function getMonth(@date date)
returns varchar(15)
	begin
		declare @m varchar(15)
		set @m = DATENAME(month,@date)
		return @m
	end

select dbo.getMonth('12/01/2025')

-- 2
create function numbers(@x int, @y int)
returns @t table(num int)
begin
	declare @a int = iif(@x<@y,@x,@y)
	declare @b int= iif(@x<@y,@y,@x)
	while @a <= @b
		begin
			insert into @t select @a
			set @a+=1
		end
	return
end

select * from numbers(1,5) --(5,1)

-- 3
create function getDept(@id int)
returns table as
return
	(
		select St_Fname+' '+St_Lname as fullname, Dept_Name
		from Student s join Department d
		on s.Dept_Id=d.Dept_Id and s.St_Id=@id
	)

select * from getDept(10)

-- 4
create function getName(@id int)
returns varchar(50)
begin
	declare @msg varchar(50), @fname varchar(10), @lname varchar(10)
	select @fname=St_Fname, @lname=St_Lname
	from Student where St_Id=@id

	if @fname is null set @msg='first name is null'
	if @lname is null set @msg='last name is null'
	if @fname is null and @lname is null set @msg='first name & last name is null'
	else set @msg='first name & last name is not null'

	/*--or
	set @msg=
		case
			when @fname is null then 'first name is null'
			if @lname is null then 'last name is null'
			if @fname is null and @lname is null then 'first name & last name is null'
			else 'first name & last name is not null'
		end
	*/	
	return @msg
end

select dbo.getName(5)

-- 5
create function getManager(@id int)
returns table as
return
	(
		select Ins_Name, Dept_Name, Manager_hiredate
		from Instructor s join Department d
		on s.Dept_Id=d.Dept_Id and d.Dept_Manager=@id and Ins_Id=@id
	)

select * from getManager(4)

-- 6
create function getStudName(@str varchar(20))
returns @t table(name varchar(20))
begin
	declare @name varchar(20)
	insert into @t select 
		case
			when @str='first name' then isnull(St_Fname,'')
			when @str='last name' then isnull(St_lname,'')
			when @str='full name' then isnull(St_Fname,'')+' '+isnull(St_lname,'')
		end
	from Student
	return
end

select * from getStudname('full name')


-- 7
select St_Id, SUBSTRING(St_Fname,1,len(st_fname)-1)
from Student

-- 8
delete sc from Stud_Course sc
join Student s on sc.St_Id=s.St_Id
join Department d 
on d.Dept_Id=s.Dept_Id and d.Dept_Name='SD'

---- Bonus
-- 1
create table empTest
(
	empId int primary key,
	name varchar(20),
	node hierarchyid unique
)

insert into empTest values
(1,'CEO',hierarchyid::GetRoot()),		-- root parent
(2,'CTO',hierarchyid::Parse('/1/')),	-- child 1
(3,'CFO',hierarchyid::Parse('/2/')),	-- child 2
(4,'Developer',hierarchyid::Parse('/1/1/')),		-- ancestor
(5,'Tester',hierarchyid::Parse('/1/2/'))		-- ancestor
---> Manually assigning paths like /1/, /2/ is dangerous in real systems.	************

-- get root parent
select empId, name
from empTest
where node=hierarchyid::GetRoot()

-- get levels
select name, node.GetLevel() empLevel
from empTest

-- get parent node of ancestor (1 -> direct parent, 2 -> grandparent...etc)
select name, node.GetAncestor(1).ToString() parent
from empTest

-- display all emps if they are children for this parent
declare @cto hierarchyid
select @cto=node from empTest where name='CTO'
--insert into empTest values
--(10,'Product Mgr',@cto.GetDescendant(NULL,NULL))			*************
select name
from empTest
where node.IsDescendantOf(@cto)!=0	-- is a child for this parent?


-- 2
declare @i int=3000
while @i<=6000
	begin
		insert into Student (St_Id,St_Fname,St_Lname)
		values (@i,'Jane','Smith')
		set @i+=1
	end

---- or	
with numbers as (
	select top(3000) ROW_NUMBER() over(order by (select null))+2999 as id
	from sys.objects a cross join sys.objects b
)
insert into Student(St_Id,St_Fname,St_Lname)
select id,'Jane','Smith'
from numbers