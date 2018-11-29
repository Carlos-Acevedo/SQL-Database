--1
select itemid, Description, listprice
FROM PET..merchandise
where listprice > (
		select avg (listprice)
		FROM PET..merchandise
		)
--2
select s.Itemid,avg(o.cost)[Average Cost],avg(s.saleprice) [Average Sale Price]
FROM PET..saleitem s inner join PET..orderitem o on s.itemid = o.itemid
group by s.itemid
having avg(s.saleprice) > 1.5*avg(o.cost)
order by s.itemid
--3
select e.EmployeeID,	e.LastName,	sum (si.saleprice)TotalSales, (sum (si.saleprice)/(select sum(saleprice)
																						from PET..saleitem))*100 as PctSales
FROM PET..sale s inner join PET..employee e on s.employeeid =e.employeeid
	inner join PET..saleitem si on si.saleid= s.saleid
group by e.employeeid, e.lastname
--4
select top 1 s.SupplierID, s.Name, (sum(m.shippingcost)/(select sum(shippingcost) from PET..merchandiseorder))*100 as PctShipCost												
FROM PET..supplier s inner join PET..merchandiseorder m on s.supplierid =m.supplierid
group by s.SupplierID,	s.Name
order by PctShipCost desc
--5
select  top 1 c.CustomerID,	c.LastName,	c.FirstName, sum(si.saleprice)MercTotal, sum(sa.saleprice)AnimalTotal,(sum(si.saleprice)+sum(sa.saleprice)) GrandTotal
FROM PET..customer c inner join PET..sale s on c.Customerid = s.Customerid inner join 
PET..saleanimal sa on sa.saleid =s.saleid inner join PET..saleitem si on si.saleid =s.saleid 
group by c.CustomerID,	c.LastName,	c.FirstName
order by grandtotal desc
--6
select c.CustomerID,	c.LastName,	c.FirstName, si.saleprice as MayTotal
FROM PET..customer c inner join PET..sale s on c.Customerid = s.Customerid
inner join PET..saleitem si on si.saleid =s.saleid
where si.saleprice > 100 and (DATEPART(MM, s.saledate)=5) or si.saleprice > 50 and (DATEPART(MM, s.saledate)=10)
--7
SELECT    m.DESCRIPTION, m.ITEMID, m.QuantityOnHand AS [PURCHASED], 
COUNT(si.SALEID) AS [SOLD], m.QuantityOnHand - COUNT(si.SaleID) AS [NETINCREASE]
FROM    PET..MERCHANDISE m INNER JOIN PET..SALEITEM si ON m.ITEMID = si.ITEMID 
INNER JOIN PET..SALE s ON s.SALEID = si.SALEID
WHERE  m.Description LIKE 'Dog Food-Can-Premium'and ((DATEPART(MM, s.SaleDate)=1) and (DATEPART(MM, s.SaleDate)=7))
GROUP BY m.ITEMID, m.Description,m.QuantityOnHand 
--8
select m.ItemID,	Description,	ListPrice
FROM PET..merchandise m inner join  PET..saleitem si on m.itemid= si.itemid
inner join PET..sale s on s.saleid =si.saleid
where m.listprice > 50 and (DATEPART(MM, s.saledate)=5) and si.saleprice = 0
--9
select distinct m.ItemID,	m.Description,	m.QuantityOnHand,	si.ItemID
FROM    PET..Merchandise m full OUTER JOIN PET..SaleItem si on m.ItemID = si.ItemID
full outer join PET..sale s on s.saleid =si.saleid
WHERE    m.QuantityOnHand >100 and (DATEPART(yyyy, s.saledate)<>2004)
order by m.itemid
--10
select distinct m.ItemID,	m.Description,	m.QuantityOnHand,	si.ItemID
FROM    PET..Merchandise m full OUTER JOIN PET..SaleItem si on m.ItemID = si.ItemID
full outer join PET..sale s on s.saleid =si.saleid
where    m.QuantityOnHand in (select QuantityOnHand
							 from PET..Merchandise 
							 where QuantityOnHand >100) 
and (DATEPART(yyyy, s.saledate)<>2004)
order by m.itemid
--11
CREATE TABLE Category
(
	Category VARCHAR(30),
	low int,
	High int	
)
INSERT INTO Category
(category, low, High)
VALUES('weak', 0, 200)
INSERT INTO Category
VALUES('Good', 200, 800)
INSERT INTO Category
VALUES('Best', 800, 10000)

select  c.CustomerID,	c.LastName,	c.FirstName,(sum(si.saleprice)+sum(sa.saleprice)) GrandTotal
FROM PET..customer c inner join PET..sale s on c.Customerid = s.Customerid inner join 
PET..saleanimal sa on sa.saleid =s.saleid inner join PET..saleitem si on si.saleid =s.saleid 
group by c.CustomerID,	c.LastName,	c.FirstName
order by grandtotal desc
--12
select distinct s.Name as [Name], OrderType =
(CASE WHEN a.orderid IS NULL THEN 'Merchandise Order' ELSE 'Animal Order' END)								
FROM PET..supplier s left outer join PET..animalorder a on s.supplierid =a.supplierid
left outer join PET..merchandiseorder m on s.supplierid =m.supplierid
where (DATEPART(MM, a.OrderDate)=6)or  (DATEPART(MM,m.OrderDate)=6)
group by s.Name, a.orderid,	m.ponumber
--13
drop table Category

CREATE TABLE Category
(
	Category VARCHAR(30),
	low int,
	High int	
)

--14
INSERT INTO Category
(category, low, High)
VALUES('weak', 0, 200)
--15
UPDATE Category
set High = 400
where High = 200
--17
DELETE TOP (1)
FROM    Category
WHERE Category = 'weak'
--18
--copy table
SELECT *
INTO employeecopy
FROM PET..employee;
--delete data
delete 
from employeecopy
--copy data 
insert Employeecopy
select *
from PET..employee