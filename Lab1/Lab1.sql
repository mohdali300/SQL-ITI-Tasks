-- T-SQL, Ranking, Object Fullpath

use ITI
-- 1
select COUNT(st_id)
from Student where St_Age is not null

-- 2
select distinct Ins_Name
from Instructor 

-- 3
select St_Id [Student ID], ISNULL(st_fname,'')+' '+ISNULL(st_lname,'') as [Student Full Name],
d.Dept_Name [Department Name]
from Student s join Department d
on s.Dept_Id=d.Dept_Id

-- 4
select Ins_Name, isnull(Dept_Name,'not attached')
from Instructor i left join Department d
on i.Dept_Id=d.Dept_Id

--5
select concat(st_fname,' ',st_lname), Crs_Name
from Student s join Stud_Course sc
on s.St_Id=sc.St_Id
join Course c
on c.Crs_Id=sc.Crs_Id
where Grade is not null

-- 6
select count(Crs_Id), Top_Name
from Course c join Topic t
on c.Top_Id=t.Top_Id
group by Top_Name

-- 7
select max(salary) max_sal, min(Salary) min_sal
from Instructor

-- 8
select Ins_Name, Salary
from Instructor
where Salary < (select avg(Salary) from Instructor)

-- 9
select Dept_Name
from Department d join Instructor i
on d.Dept_Id=i.Dept_Id
where i.Salary = (select min(Salary) from Instructor)

-- 10
----> non repetition
select salary
from (select salary, ROW_NUMBER() over(order by salary desc) as RN
	from Instructor) as new
where RN<=2
----> with repetition
select distinct salary
from (select salary, dense_rank() over(order by salary desc) as DR
	from Instructor) as new
where DR<=2

-- 11
select Ins_Name, coalesce(convert(varchar(10), salary),'instructor bonus') as Salary
from Instructor

-- 12
select avg(Salary) from Instructor

-- 13
select s.St_Fname, sup.*
from Student s join Student sup
on s.St_super=sup.St_Id

-- 14
select salary
from (select *, DENSE_RANK() over(partition by dept_id order by salary desc) as DR
	from Instructor
	where salary is not null) as new
where DR<=2

-- 15
select *
from (select *, ROW_NUMBER() over(PARTITION BY dept_id order by newid()) as RN
	from Student) as new
where RN=1

---------------------------------

use AdventureWorks2012
-- 1
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '07-28-2002' and '07-29-2014'

-- 2
select ProductID, Name
from Production.Product
where StandardCost<110

-- 3
select ProductID, Name
from Production.Product
where Weight is not null

-- 4
select *
from Production.Product
where Color in ('Red', 'Silver', 'Black')

-- 5
select *
from Production.Product
where Name like 'B%'

-- 6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select *
from Production.ProductDescription
where Description like '%\_%' escape '\'

-- 7
select sum(TotalDue) as total, OrderDate
from Sales.SalesOrderHeader
group by OrderDate
having OrderDate between '07-28-2002' and '07-29-2014'

-- 8
select distinct HireDate
from HumanResources.Employee

-- 9
select avg(distinct ListPrice)
from Production.Product

-- 10
select 'The ' + Name + ' is only! ' + convert(nvarchar(10),ListPrice) AS ProductInfo
from Production.Product
where ListPrice BETWEEN 100 AND 120
order by ListPrice

-- 11
select rowguid, Name, SalesPersonID, Demographics
into store_Archive
from Sales.Store

select count(*)
from store_Archive

select rowguid, Name, SalesPersonID, Demographics
into store_Archive2
from Sales.Store
where 1=2

select count(*)
from store_Archive2

-- 12
select convert(varchar(30), getdate(), 101) as TodayDate
union
select convert(varchar(30), getdate(), 103)
union
select format(getdate(), 'dd-MM-yyyy')
union
select format(getdate(), 'MMMM dd, yyyy')
