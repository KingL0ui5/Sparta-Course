
--1. Customers and their Orders
SELECT
    Customers.CustomerID,
    Orders.OrderID
FROM Customers
    JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

--2. Orders with Product Names
SELECT
    Orders.OrderID,
    Products.ProductName,
    Invoices.Quantity
FROM Invoices
    JOIN Orders ON Invoices.OrderID = Orders.OrderID
    JOIN Products ON Invoices.ProductID = Products.ProductID;

--3. Order Total Value
SELECT
    Orders.OrderID,
    SUM([Order Details].UnitPrice * ([Order Details].Quantity * (1 - [Order Details].Discount))) AS TotalOrderValue
FROM [Order Details]
    JOIN Orders ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID;

--4. Total Spend and Number of Orders
SELECT
    Customers.CustomerID,
    COUNT(DISTINCT Orders.OrderID) AS NumberOfOrders,
    SUM([Order Details].UnitPrice * ([Order Details].Quantity * (1 - [Order Details].Discount))) AS TotalSpent

FROM Customers
    JOIN Orders ON Customers.CustomerID = Orders.CustomerID
    JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Customers.CustomerID;

-- 5. Top 5 customers by Spend
SELECT TOP 5
    Customers.CustomerID,
    COUNT(DISTINCT Orders.OrderID) AS NumberOfOrders,
    SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalSpent

FROM Customers
    JOIN Orders ON Customers.CustomerID = Orders.CustomerID
    JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Customers.CustomerID
ORDER BY TotalSpent DESC;

--6. Customers with no orders?
SELECT Customers.CustomerID
FROM Customers
    LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;

-- 7. Orders with customer and employee info
SELECT 
    Orders.OrderID,
    Customers.CompanyName,
    Employees.FirstName + ' ' + Employees.LastName AS EmployeeName
    
FROM Orders
    INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
    INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID;

-- 8. Product sales by category
SELECT
    Categories.CategoryName,
    SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalSales
FROM Categories
    INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
    INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName
ORDER BY TotalSales DESC;
