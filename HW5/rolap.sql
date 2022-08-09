-- Homework E Starting Point
-- Create a schema to hold user views (set schema name on home page of workbook). DO THIS FIRST
-- It would be good to do this only if the schema doesn't exist already.

/*
if exists(select * from sys.schemas where name = 'northwind')
BEGIN
	PRINT 'Dropping Northwind schema'
	DROP SCHEMA northwind
END
GO 

PRINT 'Creating Northwind schema'
GO
CREATE SCHEMA northwind
GO

Our script should include
Drops (Tables, Views), 
Creates (Tables, Views), 
Inserts of "missing data" records
*/


/*
	Clean up by dropping objects
*/
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Sales]'))
	DROP VIEW [northwind].[Sales]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE northwind.FactSales 
GO

IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Employee]'))
	DROP VIEW [northwind].[Employee]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimEmployee') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE northwind.DimEmployee 
GO

IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Product]'))
	DROP VIEW [northwind].[Product]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE northwind.DimProduct 
GO

IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Date]'))
	DROP VIEW [northwind].[Date]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimDate 
GO

IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Customer]'))
	DROP VIEW [northwind].[Customer]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE northwind.DimCustomer 
GO




/*
	Create the tables and views
*/

CREATE TABLE northwind.DimCustomer (
	   [CustomerKey]  int IDENTITY  NOT NULL
	,  [CustomerID]  nvarchar(5)   NOT NULL
	,  [CompanyName]  nvarchar(40)   NOT NULL
	,  [ContactName]  nvarchar(30)   NOT NULL
	,  [ContactTitle]  nvarchar(30)   NOT NULL
	,  [CustomerCountry]  nvarchar(15)   NOT NULL
	,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
	,  [CustomerCity]  nvarchar(15)   NOT NULL
	,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
	,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
	,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
	,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
	,  [RowChangeReason]  nvarchar(200)   NULL
	, CONSTRAINT [PK_northwind.DimCustomer] PRIMARY KEY CLUSTERED ( [CustomerKey] )
) ON [PRIMARY]
GO

CREATE VIEW [northwind].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
	, [CustomerID] AS [CustomerID]
	, [CompanyName] AS [CompanyName]
	, [ContactName] AS [ContactName]
	, [ContactTitle] AS [ContactTitle]
	, [CustomerCountry] AS [CustomerCountry]
	, [CustomerRegion] AS [CustomerRegion]
	, [CustomerCity] AS [CustomerCity]
	, [CustomerPostalCode] AS [CustomerPostalCode]
	, [RowIsCurrent] AS [Row Is Current]
	, [RowStartDate] AS [Row Start Date]
	, [RowEndDate] AS [Row End Date]
	, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimCustomer
GO

CREATE TABLE northwind.DimDate (
	   [DateKey]  int   NOT NULL
	,  [Date]  date   NULL
	,  [FullDateUSA]  nchar(11)   NOT NULL
	,  [DayOfWeek]  tinyint   NOT NULL
	,  [DayName]  nchar(10)   NOT NULL
	,  [DayOfMonth]  tinyint   NOT NULL
	,  [DayOfYear]  smallint   NOT NULL
	,  [WeekOfYear]  tinyint   NOT NULL
	,  [MonthName]  nchar(10)   NOT NULL
	,  [MonthOfYear]  tinyint   NOT NULL
	,  [Quarter]  tinyint   NOT NULL
	,  [QuarterName]  nchar(10)   NOT NULL
	,  [Year]  smallint   NOT NULL
	,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
	, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED ( [DateKey] )
) ON [PRIMARY]
GO

CREATE VIEW [northwind].[Date] AS 
	SELECT [DateKey] AS [DateKey]
		, [Date] AS [Date]
		, [FullDateUSA] AS [FullDateUSA]
		, [DayOfWeek] AS [DayOfWeek]
		, [DayName] AS [DayName]
		, [DayOfMonth] AS [DayOfMonth]
		, [DayOfYear] AS [DayOfYear]
		, [WeekOfYear] AS [WeekOfYear]
		, [MonthName] AS [MonthName]
		, [MonthOfYear] AS [MonthOfYear]
		, [Quarter] AS [Quarter]
		, [QuarterName] AS [QuarterName]
		, [Year] AS [Year]
	, [IsWeekday] AS [IsWeekday]
FROM northwind.DimDate
GO

CREATE TABLE northwind.DimProduct (
	   [ProductKey]  int IDENTITY  NOT NULL
	,  [ProductID]  int   NOT NULL
	,  [ProductName]  nvarchar(40)   NOT NULL
	,  [Discontinued]  nchar(1)  DEFAULT 'N' NOT NULL
	,  [SupplierName]  nvarchar(40)   NOT NULL
	,  [CategoryName]  nvarchar(15)   NOT NULL
	,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
	,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
	,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
	,  [RowChangeReason]  nvarchar(200)   NULL
	, CONSTRAINT [PK_northwind.DimProduct] PRIMARY KEY CLUSTERED ( [ProductKey] )
) ON [PRIMARY]
GO

CREATE VIEW [northwind].[Product] AS 
	SELECT [ProductKey] AS [ProductKey]
		, [ProductID] AS [ProductID]
		, [ProductName] AS [ProductName]
		, [Discontinued] AS [Discontinued]
		, [SupplierName] AS [SupplierName]
		, [CategoryName] AS [CategoryName]
		, [RowIsCurrent] AS [Row Is Current]
		, [RowStartDate] AS [Row Start Date]
		, [RowEndDate] AS [Row End Date]
		, [RowChangeReason] AS [Row Change Reason]
	FROM northwind.DimProduct
GO

CREATE TABLE northwind.DimEmployee (
	   [EmployeeKey]  int IDENTITY  NOT NULL
	,  [EmployeeID]  int   NOT NULL
	,  [EmployeeName]  nvarchar(40)   NOT NULL
	,  [EmployeeTitle]  nvarchar(30)   NOT NULL
	,  [RowIsCurrent]  bit   DEFAULT 1 NOT NULL
	,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
	,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
	,  [RowChangeReason]  nvarchar(200)   NULL
	, CONSTRAINT [PK_northwind.DimEmployee] PRIMARY KEY CLUSTERED ( [EmployeeKey] )
) ON [PRIMARY]
GO

CREATE VIEW [northwind].[Employee] AS 
	SELECT [EmployeeKey] AS [EmployeeKey]
		, [EmployeeID] AS [EmployeeID]
		, [EmployeeName] AS [EmployeeName]
		, [EmployeeTitle] AS [EmployeeTitle]
		, [RowIsCurrent] AS [Row Is Current]
		, [RowStartDate] AS [Row Start Date]
		, [RowEndDate] AS [Row End Date]
		, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimEmployee
GO

CREATE TABLE northwind.FactSales (
	   [ProductKey]  int   NOT NULL
	,  [CustomerKey]  int   NOT NULL
	,  [EmployeeKey]  int   NOT NULL
	,  [OrderDateKey]  int   NOT NULL
	,  [ShippedDateKey]  int   NOT NULL
	,  [OrderID]  int   NOT NULL
	,  [Quantity]  smallint   NOT NULL
	,  [ExtendedPriceAmount]  money   NOT NULL
	,  [DiscountAmount]  money  DEFAULT 0 NOT NULL
	,  [SoldAmount]  money   NOT NULL
	, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED ( [ProductKey], [OrderID] )
) ON [PRIMARY]
GO

CREATE VIEW [northwind].[Sales] AS 
	SELECT [ProductKey] AS [ProductKey]
		, [CustomerKey] AS [CustomerKey]
		, [EmployeeKey] AS [EmployeeKey]
		, [OrderDateKey] AS [OrderDateKey]
		, [ShippedDateKey] AS [ShippedDateKey]
		, [OrderID] AS [OrderID]
		, [Quantity] AS [Quantity]
		, [ExtendedPriceAmount] AS [ExtendedPriceAmount]
		, [DiscountAmount] AS [DiscountAmount]
		, [SoldAmount] AS [SoldAmount]
	FROM northwind.FactSales
GO

ALTER TABLE northwind.FactSales 
	ADD 
		CONSTRAINT FK_northwind_FactSales_ProductKey FOREIGN KEY (ProductKey) REFERENCES northwind.DimProduct( ProductKey )
		, CONSTRAINT FK_northwind_FactSales_CustomerKey FOREIGN KEY (CustomerKey) REFERENCES northwind.DimCustomer( CustomerKey )
		, CONSTRAINT FK_northwind_FactSales_EmployeeKey FOREIGN KEY (EmployeeKey) REFERENCES northwind.DimEmployee( EmployeeKey )
		, CONSTRAINT FK_northwind_FactSales_OrderDateKey FOREIGN KEY (OrderDateKey) REFERENCES northwind.DimDate( DateKey )
		, CONSTRAINT FK_northwind_FactSales_ShippedDateKey FOREIGN KEY (ShippedDateKey) REFERENCES northwind.DimDate( DateKey )

/*
	Set up initial data (missing value rows, etc.)
*/

SET IDENTITY_INSERT northwind.DimCustomer ON
INSERT INTO northwind.DimCustomer (CustomerKey, CustomerID, CompanyName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'NONE', 'No Customer', 'None', 'None', 'None', 'None', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
SET IDENTITY_INSERT northwind.DimCustomer OFF
GO

INSERT INTO northwind.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
GO

SET IDENTITY_INSERT northwind.DimProduct ON
INSERT INTO northwind.DimProduct (ProductKey, ProductID, ProductName, Discontinued, SupplierName, CategoryName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', '?', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
SET IDENTITY_INSERT northwind.DimProduct OFF
GO

SET IDENTITY_INSERT northwind.DimEmployee ON
INSERT INTO northwind.DimEmployee (EmployeeKey, EmployeeID, EmployeeName, EmployeeTitle, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
SET IDENTITY_INSERT northwind.DimEmployee OFF
GO
