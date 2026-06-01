-- Aggregation Practice:

-- 1. Orders per customer
SELECT
    CustomerID,
    COUNT(OrderID) AS NumberOfOrders
FROM Orders
GROUP BY CustomerID;


-- 2. Total Revenue (whole database)
SELECT
    SUM((UnitPrice * (1-Discount) * Quantity)) AS TotalRevenue
FROM [Order Details];

-- 3. Revenue per order
SELECT
    OrderID,
    SUM(UnitPrice * (1-Discount) * Quantity) AS RevenuePerOrder
FROM [Order Details]
GROUP BY OrderID;

-- 4. Revenue per customer
SELECT
    CustomerID,
    SUM(UnitPrice * (1-Discount) * Quantity) AS RevenuePerCustomer,
    COUNT([Order Details].OrderID) AS NumberOfOrders
FROM [Order Details]
    JOIN Orders ON Orders.OrderID = [Order Details].OrderID
GROUP BY CustomerID;

-- 5. Count total number of products
SELECT
    COUNT(ProductID) AS TotalProducts
FROM Products;

-- 6. Find the most expensive product
SELECT
    MAX(UnitPrice) AS MostExpensiveProduct
FROM Products;

-- 7. Total quantity sold per product
SELECT
    ProductID,
    SUM(Quantity) AS TotalQuantity
FROM [Order Details]
GROUP BY ProductID;

-- 8. Customers who made more than 5 orders
SELECT
    o.CustomerID
FROM Orders o
GROUP BY o.CustomerID
HAVING COUNT(o.OrderID) > 5;

-- 9. Top 3 orders by total value
SELECT TOP 3
    OrderID,
    SUM(UnitPrice * (1-Discount) * Quantity) AS TotalValue
FROM [Order Details]
GROUP BY OrderID
ORDER BY TotalValue DESC;

-- Subqueries Practice:

-- 1. Products above avg price
SELECT 
    ProductID
FROM Products 
WHERE (UnitPrice > (SELECT AVG(UnitPrice) FROM Products))

-- 2. Orders above avg order value
SELECT 
    OrderID,
    (UnitPrice * (1-Discount) * Quantity) AS Value
FROM [Order Details] 
WHERE (UnitPrice * (1 - Discount) * Quantity) > (
    SELECT AVG(UnitPrice * (1 - Discount) * Quantity) 
    FROM [Order Details]
);

-- alternative
SELECT OrderID, OrderTotal
FROM ( -- new table created
  SELECT 
    OrderID,
    SUM(Quantity * UnitPrice) AS OrderTotal
  FROM [Order Details]
  GROUP BY OrderID
) TempOrdersTable
WHERE OrderTotal > (
  SELECT AVG(Quantity * UnitPrice)
  FROM [Order Details]
);

-- 3. Customers with more than 5 orders (can be done with or without a subquery)
SELECT 
    CustomerID
FROM Orders 
GROUP BY CustomerID
HAVING COUNT(OrderID) > 5;
 
SELECT 
    CustomerID
FROM (
    SELECT 
        CustomerID, 
        COUNT(OrderID) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
) AS CustomerCounts
WHERE TotalOrders > 5;

-- Bonus!
-- 7. Find products cheaper than the average price
SELECT ProductID
FROM [Order Details]
WHERE UnitPrice < (
    SELECT AVG(UnitPrice) FROM [Order Details]
)
-- 8. Find customers who have placed at least one order

SELECT CustomerID, NumberOfOrders
FROM (
    SELECT c.CustomerID, COUNT(o.OrderID) AS NumberOfOrders
    FROM Customers c
    LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
) AS temptable
WHERE NumberOfOrders >= 1


-- 9. Find orders with total value greater than average
WITH TempOrdersTable AS (
    SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM Orders o
    LEFT JOIN [Order Details] od ON od.OrderID = o.OrderID
    GROUP BY o.OrderID
)
SELECT OrderID, OrderValue
FROM TempOrdersTable
WHERE OrderValue > (
    SELECT AVG(OrderValue) 
    FROM TempOrdersTable
);

-- 10. Find products never ordered (use subquery, not JOIN)
SELECT ProductID, ProductName
FROM Products
WHERE ProductID NOT IN (
    SELECT ProductID 
    FROM [Order Details]
    WHERE ProductID IS NOT NULL
);

-- sanity check 
SELECT COUNT(DISTINCT ProductID) FROM Products 
SELECT COUNT(DISTINCT ProductID) FROM [Order Details]

-- 11. Find employees who handled more than 10 orders
SELECT EmployeeID, COUNT(EmployeeID) AS NumberOfOrders
FROM Orders
GROUP BY EmployeeID 
HAVING COUNT(EmployeeID) > 10

SELECT DISTINCT EmployeeID FROM Orders
