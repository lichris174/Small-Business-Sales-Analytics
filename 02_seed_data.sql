USE SmallBusinessSales;
GO

INSERT INTO dbo.Products(ProductName, Category, UnitPrice)
VALUES
('Notebook', 'Stationery', 3.50),
('Pen', 'Stationery', 1.25),
('Pencil', 'Stationery', 0.99),
('Stapler', 'Stationery', 6.75),
('Highlighter', 'Stationery', 1.80),
('Coffee Mug', 'Kitchen', 9.99),
('Water Bottle', 'Kitchen', 14.50),
('Desk Organizer', 'Office', 12.00),
('Mouse Pad', 'Office', 7.25),
('USB Flash Drive', 'Electronics', 11.99);
GO

WITH Numbers as (
	SELECT TOP(100)
		ROW_NUMBER() OVER(ORDER BY(SELECT NULL)) AS n
	FROM sys.objects
)
INSERT INTO dbo.Customers(FirstName, LastName, Email)
SELECT 
	CONCAT('First', n) AS FirstName,
	CONCAT('Last', n) AS LastName,
	CONCAT('customer', n, '@example.com') as Email
FROM Numbers;
GO

DECLARE @NewOrders TABLE (OrderID INT PRIMARY KEY);

INSERT INTO dbo.Orders (CustomerID, OrderDate, Status)
OUTPUT INSERTED.OrderID INTO @NewOrders(OrderID)
SELECT TOP(500)
	c.CustomerID,
	DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, SYSDATETIME()) AS OrderDate,
	CASE
		WHEN ABS(CHECKSUM(NEWID())) % 100 < 10 THEN 'CANCELLED'
		WHEN ABS(CHECKSUM(NEWID())) % 100 < 40 THEN 'NEW' 
		WHEN ABS(CHECKSUM(NEWID())) % 100 < 80 THEN 'PAID' 
		ELSE 'SHIPPED'
	END AS Status
FROM dbo.Customers c
ORDER BY NEWID();
GO

WITH OrdersToFill AS (
	SELECT no.OrderID
	FROM @NewOrders no
),
ItemCounts AS(
	SELECT 
		otf.OrderID,
		1 + (ABS(CHECKSUM(NEWID())) % 5) AS ItemCount
	FROM OrdersToFill otf
),
Items AS (
	SELECT 
		ic.OrderID,
		p.ProductID,
		1 + (ABS(CHECKSUM(NEWID())) % 4) AS Quantity,
		p.UnitPrice	
	FROM ItemCounts ic
	CROSS APPLY (
		SELECT TOP (ic.ItemCount) ProductID, UnitPrice
		FROM dbo.Products
		ORDER BY NEWID()
	) p
)
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice)
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM Items;
GO
