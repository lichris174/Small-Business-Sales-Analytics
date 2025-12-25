USE SmallBusinessSales;
GO

CREATE TABLE dbo.Customers(
	CustomerID INT IDENTITY(1,1) PRIMARY KEY, -- starts at 1, increments ID by 1
	FirstName VARCHAR(50) NOT NULL, -- enforces required data
	LastName VARCHAR(50) NOT NULL,
	Email VARCHAR(255) UNIQUE, -- prevents duplicates
	CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Products(
	ProductID INT IDENTITY(1,1) PRIMARY KEY,
	ProductName VARCHAR(100) NOT NULL,
	Category VARCHAR(50) NOT NULL,
	UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0), -- max 10 digits, 2 to the right of the decimal point. Checks if unit price is >= 0
	IsActive BIT NOT NULL DEFAULT 1 -- true by default
);
GO

CREATE TABLE dbo.Orders(
	OrderID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT NOT NULL,
	OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
	Status VARCHAR(20) NOT NULL DEFAULT 'NEW',

	CONSTRAINT FK_Orders_Customers
		FOREIGN KEY (CustomerID) 
		REFERENCES dbo.Customers(CustomerID) -- can't insert a row with a customer ID that doesn't exist in table Customers
);
GO

CREATE TABLE dbo.OrderItems(
	OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL CHECK (Quantity > 0),
	UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),

	CONSTRAINT FK_OrderItems_Orders
		FOREIGN KEY (OrderID)
		REFERENCES dbo.Orders(OrderID),

	CONSTRAINT FK_OrderItems_Products
		FOREIGN KEY (ProductID)
		REFERENCES dbo.Products(ProductID)
);
GO
