use AdventureWorks2019
go

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'Production'
     AND SPECIFIC_NAME = N'usp_SalesByDateRange' 
)
   DROP PROCEDURE Production.usp_SalesByDateRange
GO

CREATE PROCEDURE Production.usp_SalesByDateRange
@StartDate date = NULL,
@EndDate date = NULL,
@ReturnPar bit = NULL ,
@Message VARCHAR(500) = NULL OUTPUT
AS
	
	IF(@StartDate IS NULL AND @EndDate IS NULL)
		SELECT pp.ProductID, pp.[Name] as 'Nombre del producto', soh.OrderDate, COUNT(sod.ProductID) as 'Cantidad Total de Ventas'
		, SUM(soh.TotalDue) as 'Monto de Ventas Totales'
		FROM Production.Product pp
		INNER JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
		INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID

		--Busqueda de  las ventas del mes de la fecha actual.
		--WHERE soh.OrderDate BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())

		--Busqueda de las ventas con el mismo mes, pero puede ser distinto el año.
		WHERE  MONTH(soh.OrderDate) = MONTH(GETDATE())
			
		GROUP BY pp.ProductID,pp.[Name], sod.ProductID, soh.OrderDate

	IF(@StartDate > '2011-01-01' AND @EndDate <= EOMONTH(GETDATE()))
		SELECT prodp.ProductID, prodp.[Name] as 'Nombre del producto', salesoh.OrderDate, COUNT(salesod.ProductID) as 'Cantidad Total de Ventas'
		, SUM(salesoh.TotalDue) as 'Monto de Ventas Totales'
		FROM Production.Product prodp
		INNER JOIN Sales.SalesOrderDetail salesod ON prodp.ProductID = salesod.ProductID
		INNER JOIN Sales.SalesOrderHeader salesoh ON salesod.SalesOrderID = salesoh.SalesOrderID
		WHERE CONVERT(date, salesoh.OrderDate) BETWEEN @StartDate AND @EndDate
		GROUP BY prodp.ProductID, prodp.[Name], salesod.ProductID, salesoh.OrderDate 

	ELSE
		SET @Message = 'El rango de fechas no es válido';
		PRINT @Message;
		SET @ReturnPar = '0';
		PRINT @ReturnPar;

GO

EXEC Production.usp_SalesByDateRange '2011-10-10', '2011-11-13'
GO