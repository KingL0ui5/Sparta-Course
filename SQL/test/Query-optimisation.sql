-- Basic Query optimisation exercises
-- Improve the performance of the below queries!

-- 1. Basic Filter

-- SELECT *
-- FROM Orders
-- WHERE CustomerID = 'ALFKI';
CREATE INDEX idx_Customers
ON Orders(CustomerID, OrderID);

SELECT OrderID
FROM Orders
WHERE CustomerID = 'ALFKI';

-- Solution hint - add index and remove wildcard:

-- 2. Function Issue
SELECT *
FROM Orders
WHERE OrderDate >= '1997-01-01' 
  AND OrderDate < '1998-01-01';

CREATE INDEX idx_Orders_OrderDate 
ON Orders(OrderDate);

-- Solution hint - Tighten the filter

-- 3. Sorting Bottleneck

CREATE INDEX idx_Orders_CustID_OrderDate
ON Orders(OrderID, CustomerID, OrderDate);

SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI'
ORDER BY OrderDate;

-- Solution hint - Create an Index to avoid table scan:

-- 4. JOIN Performance
CREATE INDEX idx_Orders_Customers
ON Orders(CustomerID);

SELECT *
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID;

-- Solution hint - Make Indexes to help with Index Seek

-- 5. Covering Index:
CREATE INDEX idx_CustomerID_OrderDate
ON Orders(CustomerID)
INCLUDE (OrderDate);

SELECT CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI';

-- Solution hint - Avoid Key Lookups, create a covering index, using the INCLUDE key ord

-- 6. Aggregation
CREATE INDEX idx_Orders_CustomerID
ON Orders(CustomerID);

SELECT CustomerID, COUNT(*)
FROM Orders
GROUP BY CustomerID;

-- Solution hint - Create Index to remove need for GROUP BY in SELECT statement:

-- 7. Broken Search Pattern
CREATE INDEX idx_Customers_CompanyName
ON Customers(CompanyName);

SELECT CustomerID
FROM Customers
WHERE CompanyName LIKE 'market%';
-- Solution hint - Remove wildcard as it prevents Index use







