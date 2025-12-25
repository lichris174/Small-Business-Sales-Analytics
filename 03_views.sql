USE SmallBusinessSales;
GO

CREATE OR ALTER VIEW dbo.vw_OrderTotals AS 
SELECT
	o.OrderID,
	o.OrderDate,
	o.Status,
	c.FirstName,
	c.LastName,
	SUM(oi.Quantity * oi.UnitPrice)	AS OrderTotal
FROM dbo.Orders o
JOIN dbo.Customers c
	ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems oi
	ON oi.OrderID = o.OrderID
GROUP BY 
	o.OrderID,
	o.OrderDate,
	o.Status,
	c.FirstName,
	c.LastName;
GO

CREATE OR ALTER VIEW dbo.vw_MonthlyRevenue AS
SELECT 
	DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1) AS MonthStart, 
	SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.Orders o 
JOIN dbo.OrderItems oi
	ON oi.OrderID = o.OrderID
GROUP BY 
	DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1);
GO

CREATE OR ALTER VIEW dbo.vw_ProductPerformance AS
SELECT
	p.ProductID,
	p.ProductName,
	p.Category,
	SUM(oi.Quantity) AS UnitsSold,
	SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.Products p
JOIN dbo.OrderItems oi
	ON oi.ProductID = p.ProductID
GROUP BY 
	p.ProductID,
	p.ProductName,
	p.Category;
GO

CREATE OR ALTER VIEW dbo.vw_CustomerLifetimeValue AS
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	c.Email,

	COUNT(DISTINCT o.OrderID) AS OrderCount,
	SUM(oi.Quantity * oi.UnitPrice) AS LifetimeValue,
	CAST(SUM(oi.Quantity * oi.UnitPrice) / NULLIF(COUNT(DISTINCT o.OrderID), 0) AS DECIMAL(10,2)) AS AvgOrderValue,

	MIN(o.OrderDate) AS FirstOrderDate,
	MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers c
JOIN dbo.Orders o
	ON o.CustomerID = c.CustomerID
JOIN dbo.OrderItems oi
	ON oi.OrderID = o.OrderID
GROUP BY 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	c.Email;
GO
