use ist722_hmtelang_dw
GO

DROP TABLE FactSales
DROP TABLE DimEmployee
DROP TABLE DimProduct
DROP TABLE DimDate
DROP TABLE DimCustomer
GO

-- Customer Dimension
CREATE TABLE DimCustomer (
	CustomerKey int identity not null,
	CustomerID nvarchar(5) not null,
	CompanyName nvarchar(40) not null,
	ContactName nvarchar(30) not null,
	ContactTitle nvarchar(30) not null,
	CustomerCountry nvarchar(15) not null,
	CustomerRegion nvarchar(15) default 'N/A' not null,
	CustomerCity nvarchar(15) not null,
	CustomerPostalCode nvarchar(10) not null,
	RowIsCurrent bit default 1 not null,
	RowStartDate datetime default '12/31/1899' not null,
	RowEndDate datetime default '12/31/9999' not null,
	RowChangeReason nvarchar(200) not null,
	CONSTRAINT pkDimCustomerKey PRIMARY KEY (CustomerKey)
);
GO

-- Date Dimension
CREATE TABLE DimDate (
	DateKey int not null,
	Date date not null,
	FullDateUSA nchar(10) not null,
	DayofMonth tinyint not null,
	MonthName  nchar(10) not null,
	MonthOfYear tinyint not null,
	Quarter tinyint not null,
	QuarterName nchar(10) not null,
	Year smallint not null,
	IsWeekday bit default 0 not null,
	CONSTRAINT pkDimDateKey PRIMARY KEY (DateKey)
);
GO

-- Product Dimension
CREATE TABLE DimProduct (
   ProductKey int identity not null,
   ProductID int not null,
   ProductName nvarchar(40) not null,
   Discontinued nchar(1)  default 'N' not null,
   SupplierName nvarchar(40) not null,
   CategoryName nvarchar(15) not null,
   RowIsCurrent bit  default 1 not null,
   RowStartDate datetime  default '12/31/1899' not null,
   RowEndDate datetime  default '12/31/9999' not null,
   RowChangeReason nvarchar(200) null,
   CONSTRAINT pkDimProductKey PRIMARY KEY (ProductKey) 
);

-- Employee Dimension
CREATE TABLE DimEmployee (
   EmployeeKey int identity  not null,
   EmployeeID int not null,
   EmployeeName nvarchar(40) not null,
   EmployeeTitle nvarchar(30) not null,
   RowIsCurrent bit default 1 not null,
   RowStartDate datetime default '12/31/1899' not null,
   RowEndDate datetime default '12/31/9999' not null,
   RowChangeReason nvarchar(200) null,
   CONSTRAINT pkDimEmployeeKey PRIMARY KEY (EmployeeKey)
);

-- Sales Fact
CREATE TABLE FactSales (
  ProductKey int NOT NULL,
  CustomerKey int NOT NULL,
  EmployeeKey int NOT NULL,
  OrderDateKey int NOT NULL,
  ShippedDateKey int NOT NULL,
  OrderID int NOT NULL,
  Quantity smallint NOT NULL,
  ExtendedPriceAmount money NOT NULL,
  DiscountAmount money DEFAULT 0 NOT NULL,
  SoldAmount money NOT NULL,
  CONSTRAINT pkFactSalesKey PRIMARY KEY (ProductKey, OrderID),
  CONSTRAINT fkFactSalesProductKey FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),
  CONSTRAINT fkFactSalesCustomerKey FOREIGN KEY (CustomerKey) REFERENCES DimProduct(CustomerKey),
  CONSTRAINT fkFactSalesEmployeeKey FOREIGN KEY (EmployeeKey) REFERENCES DimProduct(EmployeeKey),
  CONSTRAINT fkFactSalesOrderDateKey FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey),
  CONSTRAINT fkFactSalesShippedDateKey FOREIGN KEY (ShippedDateKey) REFERENCES DimDate(DateKey)
);




