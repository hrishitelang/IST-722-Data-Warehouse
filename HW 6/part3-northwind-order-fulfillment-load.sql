use ist722_hmtelang_dw

-- Matching the data shape of our source with the target dimension of the table with this statement:
SELECT EmployeeID, FirstName + ' ' + LastName as EmployeeName, Title
FROM ist722_hmtelang_stage.dbo.stgNorthwindEmployees

-- load DimEmployee
INSERT INTO Northwind.DimEmployee (EmployeeID, EmployeeName, EmployeeTitle)
SELECT EmployeeID, FirstName + ' ' + LastName as EmployeeName, Title
FROM ist722_hmtelang_stage.dbo.stgNorthwindEmployees 

-- Check if the data was inserted
SELECT * FROM Northwind.DimEmployee

-- load DimCustomer
INSERT INTO Northwind.DimCustomer(CustomerID, CompanyName, ContactName, ContactTitle, 
				CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode)
SELECT CustomerID, CompanyName, ContactName, ContactTitle, Country, 
		CASE WHEN Region is null THEN 'N/A' ELSE Region END,
		City, 
		CASE WHEN PostalCode is null THEN 'N/A' ELSE PostalCode END 
FROM ist722_hmtelang_stage.dbo.stgNorthwindCustomers

-- Check if the data was inserted
SELECT * FROM Northwind.DimCustomer

-- load DimProduct
INSERT INTO Northwind.DimProduct(ProductID, ProductName, Discontinued, SupplierName, CategoryName)
SELECT ProductID, ProductName, Discontinued, CompanyName, CategoryName
FROM ist722_hmtelang_stage.dbo.stgNorthwindProducts

-- Check if the data was inserted
SELECT * FROM Northwind.DimProduct


-- load DimDate
INSERT INTO Northwind.DimDate(Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear,
								MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
SELECT Date, FullDateUSA, DayOfWeekUSA, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthYear, Quarter, QuarterName, Year, IsWeekday
FROM ist722_hmtelang_stage.dbo.stgDate

-- Check if the data was inserted
SELECT * FROM Northwind.DimDate

-- Selecting the appropriate business keys and the respective facts from the fact table
SELECT s.*, c.CustomerKey, p.ProductKey, e.EmployeeKey,
	ExternalSources2.dbo.getDateKey(s.OrderDate) as OrderDateKey,
	ExternalSources2.dbo.getDateKey(s.ShippedDate) as ShippedDateKey,
	s.OrderID,
	Quantity,
	Quantity * UnitPrice as ExtendedPriceAmount,
	Quantity * UnitPrice * Discount as DiscountAmount,
	Quantity * UnitPrice * (1 - Discount) as SoldAmount
FROM ist722_hmtelang_stage.dbo.stgNorthwindSales s
JOIN ist722_hmtelang_dw.northwind.DimCustomer c
ON s.CustomerID = c.CustomerID
JOIN ist722_hmtelang_dw.northwind.DimProduct p
ON s.ProductID = p.ProductID
JOIN ist722_hmtelang_dw.northwind.DimEmployee e
ON s.EmployeeID = e.EmployeeID

-- Loading FactSales
INSERT INTO Northwind.FactSales
	(
	ProductKey,
	CustomerKey,
	EmployeeKey,
	OrderDateKey,
	ShippedDateKey,
	OrderID,
	Quantity,
	ExtendedPriceAmount,
	DiscountAmount,
	SoldAmount
	)
SELECT p.ProductKey, c.CustomerKey, e.EmployeeKey,
	ExternalSources2.dbo.getDateKey(s.OrderDate) as OrderDateKey,
	CASE WHEN ExternalSources2.dbo.getDateKey(s.ShippedDate) IS NULL THEN -1 
	ELSE ExternalSources2.dbo.getDateKey(s.ShippedDate) END AS ShippedDateKey,
	s.OrderID,
	Quantity,
	Quantity * UnitPrice as ExtendedPriceAmount,
	Quantity * UnitPrice * Discount as DiscountAmount,
	Quantity * UnitPrice * (1 - Discount) as SoldAmount
FROM ist722_hmtelang_stage.dbo.stgNorthwindSales s
JOIN ist722_hmtelang_dw.northwind.DimCustomer c
ON s.CustomerID = c.CustomerID
JOIN ist722_hmtelang_dw.northwind.DimProduct p
ON s.ProductID = p.ProductID
JOIN ist722_hmtelang_dw.northwind.DimEmployee e
ON s.EmployeeID = e.EmployeeID

-- Creating a view for the ROLAP Star Schema
CREATE VIEW SalesMart
AS
SELECT s.OrderID, s.Quantity, s.ExtendedPriceAmount, s.DiscountAmount,
	s.SoldAmount, c.CompanyName, c.ContactName, c.ContactTitle, c.CustomerCity,
	c.CustomerCountry, c.CustomerRegion, c.CustomerPostalCode,
	e.EmployeeName, e.EmployeeTitle, p.ProductName, p.DisContinued, p.CategoryName, od.*
FROM Northwind.FactSales s
	join Northwind.DimCustomer c ON c.CustomerKey = s.CustomerKey
	join Northwind.DimEmployee e ON e.EmployeeKey = s.EmployeeKey
	join Northwind.DimProduct p ON p.ProductKey = s.ProductKey
	join Northwind.DimDate od ON od.DateKey = s.OrderDateKey
