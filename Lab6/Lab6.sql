use Company_SD

-- 1
declare c1 cursor
for select salary from Employee
for update
declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS=0
	begin
		if @sal>=3000
			update Employee
				set Salary=@sal*1.20
			where current of c1
		else if @sal<3000
			update Employee
				set Salary=Salary*1.10
			where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1

-- 2
declare c2 cursor
for select d.Dname, e.Fname from Departments d join Employee e
	on d.MGRSSN=e.SSN
for read only       
declare @dname varchar(20),@empname varchar(20)
open c2
fetch c2 into @dname,@empname
while @@FETCH_STATUS=0	
	begin
		select @dname,@empname
		fetch c2 into @dname,@empname
	end
close c2
deallocate c2

-- 3
declare c3 cursor
for select distinct Fname from Employee where Fname is not null
for read only
declare @name varchar(20),@all_names varchar(300)
open c3
fetch c3 into @name
while @@FETCH_STATUS=0
	begin
		set @all_names=concat(@all_names,',',@name)
		fetch c3 into @name
	end
select @all_names
close c3
deallocate c3

-- 4
create procedure spgetmonth
	@date date,
	@month varchar(15) output
as
	set @month = datename(month, @date)

declare @m varchar(15)
exec spgetmonth '2007-12-01', @m output
select @m

--
create procedure spnumbers
	@x int, @y int
as
	declare @a int = iif(@x < @y, @x, @y)
	declare @b int = iif(@x < @y, @y, @x)
	while @a <= @b
	begin
		select @a as num
		set @a += 1
	end

exec spnumbers 1, 5
exec spnumbers 5, 1

--
create procedure spgetdept
	@id int
as
	select s.st_fname + ' ' + s.st_lname as fullname,
		   d.dept_name
	from student s
	join department d
		on s.dept_id = d.dept_id
	where s.st_id = @id

exec spgetdept 10

--
create procedure spgetname
	@id int,
	@msg varchar(50) output
as
	declare @fname varchar(10), @lname varchar(10)
	select @fname = st_fname,
		   @lname = st_lname
	from student
	where st_id = @id

	if @fname is null and @lname is null
		set @msg = 'first name & last name is null'
	else if @fname is null
		set @msg = 'first name is null'
	else if @lname is null
		set @msg = 'last name is null'
	else
		set @msg = 'first name & last name is not null'

declare @result varchar(50)
exec spgetname 5, @result output
select @result

--
create procedure spgetmanager
	@id int
as
	select s.ins_name,
		   d.dept_name,
		   d.manager_hiredate
	from instructor s
	join department d
		on s.dept_id = d.dept_id
	where d.dept_manager = @id
	  and s.ins_id = @id

exec spgetmanager 4

--
create procedure spgetstudname
	@str varchar(20)
as
	select
		case
			when @str = 'first name' then isnull(st_fname, '')
			when @str = 'last name' then isnull(st_lname, '')
			when @str = 'full name' then isnull(st_fname, '') + ' ' + isnull(st_lname, '')
		end as name
	from student

exec spgetstudname 'full name'
exec spgetstudname 'first name'

-- 5
create sequence MySeq
start with 1
increment BY 1
MinValue 1
MaxValue 10
no cycle
no cache





