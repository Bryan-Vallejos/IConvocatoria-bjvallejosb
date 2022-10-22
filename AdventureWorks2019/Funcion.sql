use AdventureWorks2019
go

IF OBJECT_ID (N'Person.ufn_FindSalesByDateRange') IS NOT NULL
   DROP FUNCTION Person.ufn_FindSalesByDateRange
GO

CREATE FUNCTION Person.ufn_FindSalesByDateRange(@StartDate date = NULL,@EndDate date = NULL)
RETURNS @SalesByDateRange TABLE (
		EmployeeID INT,
		EmployeeName NVARCHAR(50),
		OrderDate datetime,
		SalesTotal DECIMAL(18,2),
		SalesTotalAmount DECIMAL(18,2)
	)
AS
BEGIN
	IF(@StartDate IS NULL AND @EndDate IS NULL)

		INSERT INTO @SalesByDateRange(EmployeeID, EmployeeName, OrderDate, SalesTotal, SalesTotalAmount)
		SELECT pp.BusinessEntityID, pp.[FirstName] + ' ' + PP.MiddleName+ ' ' + PP.LastName, soh.OrderDate, COUNT(sod.ProductID)
		, SUM(soh.TotalDue) 
		FROM Person.Person pp
		INNER JOIN Sales.Store sst ON pp.BusinessEntityID =sst.BusinessEntityID
		INNER JOIN Sales.SalesOrderHeader soh ON sst.SalesPersonID= soh.SalesPersonID
		INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
		INNER JOIN Production.Product prod ON sod.ProductID = prod.ProductID
		WHERE  MONTH(soh.OrderDate) = MONTH(GETDATE())
		GROUP BY pp.BusinessEntityID, pp.[FirstName] + ' ' + PP.MiddleName+ ' ' + PP.LastName, sod.ProductID, soh.OrderDate
	
	IF(@StartDate > '2011-01-01' AND @EndDate <= EOMONTH(GETDATE()))
		INSERT INTO @SalesByDateRange(EmployeeID, EmployeeName, OrderDate, SalesTotal, SalesTotalAmount)
		SELECT pp.BusinessEntityID, pp.[FirstName] + ' ' + PP.MiddleName+ ' ' + PP.LastName, soh.OrderDate, COUNT(sod.ProductID) 
		, SUM(soh.TotalDue) 
		FROM Person.Person pp
		INNER JOIN Sales.Store sst ON pp.BusinessEntityID =sst.BusinessEntityID
		INNER JOIN Sales.SalesOrderHeader soh ON sst.SalesPersonID= soh.SalesPersonID
		INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
		INNER JOIN Production.Product prod ON sod.ProductID = prod.ProductID
		WHERE  MONTH(soh.OrderDate) = MONTH(GETDATE())
		GROUP BY pp.BusinessEntityID, pp.[FirstName] + ' ' + PP.MiddleName+ ' ' + PP.LastName, sod.ProductID, soh.OrderDate
	RETURN;
END
GO

SELECT * FROM Person.ufn_FindSalesByDateRange('2011-10-10','2012-10-10')
go
SELECT * FROM Sales.SalesPerson