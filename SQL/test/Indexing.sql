CREATE INDEX idx_Orders_Customer_Date 
ON Orders (CustomerID) 
INCLUDE (OrderDate, ShippedDate);

CREATE INDEX idx_Products_ProductID
ON Products (ProductID)


SELECT CustomerID, OrderDate, ShippedDate 
FROM Orders 
WHERE CustomerID = 'ALFKI';





-- 2. Wipe the Data Cache (forces SQL Server to read from disk/index)
DBCC DROPCLEANBUFFERS;

-- 3. Wipe the Query Plan Cache (forces SQL Server to recompile the query)
DBCC FREEPROCCACHE;

-- 4. Turn on performance statistics
SET STATISTICS IO ON;
SET STATISTICS TIME ON;