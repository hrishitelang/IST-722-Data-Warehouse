use ist722_hmtelang_stage
go

-- Stage Customers
SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City,Region, PostalCode, Country
INTO stgNorthwindCustomers
FROM Northwind.dbo.Customers
GO

-- Stage Employees
SELECT EmployeeID, FirstName, LastName, Title
INTO stgNorthwindEmployees
FROM Northwind.dbo.Employees
GO

-- Querying the Products table before staging
SELECT ProductID, ProductName, Discontinued, CompanyName, CategoryName
FROM Northwind.dbo.Products p
	join Northwind.dbo.Suppliers s
		on p.SupplierID = s.SupplierID
	join Northwind.dbo.Categories c
		on c.CategoryID = p.CategoryID
GO

-- Stage Products
SELECT ProductID, ProductName, Discontinued, CompanyName, CategoryName
INTO stgNorthwindProducts
FROM Northwind.dbo.Products p
	join Northwind.dbo.Suppliers s
		on p.SupplierID = s.SupplierID
	join Northwind.dbo.Categories c
		on c.CategoryID = p.CategoryID
GO

-- Querying the min and max of Shipped and Order Dates
SELECT min(OrderDate), max(OrderDate), min(ShippedDate), max(ShippedDate)
FROM Northwind.dbo.Orders


-- Stage date
SELECT *
INTO stgNorthwindDates
FROM ExternalSources2.dbo.date_dimension
WHERE Year between 1996 and 1998
GO

-- Stage Fact
SELECT ProductID, d.OrderID, CustomerID, EmployeeID, OrderDate, ShippedDate, UnitPrice, Quantity, Discount
INTO stgNorthwindSales
FROM Northwind.dbo.[Order Details] d
	join Northwind.dbo.Orders o
	on o.OrderID = d.OrderID







