-- 1. Create a Query that uses CASE to sort Orders into "revenue buckets of "Low", "Medium" and "High"
SELECT OrderID,(Quantity * UnitPrice) AS Revenue,
CASE 
    WHEN (Quantity * UnitPrice) > 100 THEN 'High'
    WHEN (Quantity * UnitPrice) > 50 THEN 'Medium'
    ELSE 'Low'
END AS RevenueBucket
FROM [Order Details] 
-- 2. Output ProductName, UnitsInStock and a custom column called "Stock Status" that reflects the level of stock of that item
SELECT ProductName, UnitsInStock,
CASE 
    WHEN UnitsInStock > 0 THEN 'In stock'
    ELSE 'Out of stock'
END AS [Stock Status]
FROM Products

-- 3. Product Price Categories (CASE + Aggregation)
-- Count how many products fall into each price category:
-- Cheap (< 10)
-- Mid (10–20)
-- Expensive (> 20)

SELECT 
    CASE 
        WHEN UnitPrice < 10 THEN 'Cheap'
        WHEN UnitPrice <= 20 THEN 'Mid'
        ELSE 'Expensive'
    END 
    AS [Product Price Category],
    COUNT(*) AS NumberOfProducts
FROM Products
GROUP BY 
    CASE 
        WHEN UnitPrice < 10 THEN 'Cheap'
        WHEN UnitPrice <= 20 THEN 'Mid'
        ELSE 'Expensive'
    END;


-- 4. Customer Order Count with Labels (CASE + GROUP BY)
-- Show each customer and label them:
-- “Frequent” (> 10 orders)
-- “Occasional” (≤ 10)

SELECT  
    c.CustomerID, 
    COUNT(o.OrderID) AS NumberOfOrders,
    CASE 
        WHEN COUNT(o.OrderID) > 10 THEN 'Frequent'
        ELSE 'Occaisional'
    END AS CustomerType
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

-- 5. Product Sales Buckets (CASE + Aggregation + JOIN)
-- For each product, calculate total quantity sold and categorise:
-- Low (< 50)
-- Medium (50–200)
-- High (> 200)
SELECT 
    ProductID,
    SUM(Quantity) AS TotalSold,
    CASE
        WHEN SUM(Quantity) < 50 THEN 'Low'
        WHEN SUM(Quantity) <= 200 THEN 'Meduim'
        ELSE 'HIGH'
    END AS Category
FROM [Order Details]
GROUP BY ProductID

-- 6. Products Above Category Average (Correlated Subquery + CASE)
-- Return products where:
-- Price is above the average for their category
-- Include a label “Above Avg” / “Below Avg”
SELECT 
    p1.ProductID, 
    p1.CategoryID,
    p1.UnitPrice, 
    CASE
        WHEN p1.UnitPrice > (
            SELECT AVG(p2.UnitPrice) 
            FROM Products p2 
            WHERE p2.CategoryID = p1.CategoryID  
        ) THEN 'Above Avg'
        ELSE 'Below Avg'                        
    END AS Label
FROM Products p1;

GO

-- ---------------------------------------------------------------------------

-- 1. Create an SP to return all products
CREATE PROCEDURE GetAllProducts
AS 
BEGIN
    SELECT * FROM Products
END;
GO;

-- 2. Create an SP that inserts a Product into the Product table
CREATE PROCEDURE InsertProduct 
    @ProductName NVARCHAR(40),
    @UnitPrice DECIMAL(10,2),
    @UnitsInStock SMALLINT
AS 
BEGIN 
    SET NOCOUNT ON; -- if you want no log updates

    INSERT INTO Products (ProductName, UnitPrice, UnitsInStock)
    VALUES (@ProductName, @UnitPrice, @UnitsInStock);
    
END;
GO;
-- 3. Create an SP that updates a product's price
CREATE PROCEDURE UpdatePrice 
    @ProductID INT,
    @NewUnitPrice DECIMAL(10,2)
AS 
BEGIN 
    UPDATE Products 
    SET UnitPrice = @NewUnitPrice
    WHERE ProductID = @ProductID
END;
GO;


-- 4. Create an SP that find high value customers - using conditional logic
CREATE PROCEDURE FindHighValue
    @HighValueThresh DEC(10,2)
AS   
BEGIN
    WITH CustomerLabels AS (
        SELECT 
            c.CustomerID AS CustomerID,
            SUM(od.UnitPrice * od.Quantity) AS TotalValue,
            CASE 
                WHEN SUM(od.UnitPrice * od.Quantity) > @HighValueThresh THEN 'High Value'
                ELSE 'Standard'
            END AS ValueCategory
        
        FROM Customers c 
        JOIN Orders o ON o.CustomerID = c.CustomerID
        JOIN [Order Details] od ON od.OrderID = o.OrderID
        GROUP BY c.CustomerID
    )

    SELECT CustomerID, TotalValue, ValueCategory FROM CustomerLabels
    WHERE ValueCategory = 'High Value';
END;
GO;
-- 5. Create an SP that finds Orders per Employee, using parameters 
CREATE PROCEDURE OrdersPerEmployee
    @EmployeeID INT = NULL 
AS
BEGIN 
    WITH EmployeeOrders AS (
        SELECT EmployeeID, 
        COUNT(OrderID) AS NumberOfOrders
        FROM Orders
        GROUP BY EmployeeID
    )

    SELECT * FROM EmployeeOrders 
    WHERE EmployeeID = CASE 
                            WHEN @EmployeeID IS NULL THEN EmployeeID 
                            ELSE @EmployeeID
                        END;
END;
GO

-- 6. Create an SP that takes a minimum order value and returns orders above that value
CREATE PROCEDURE OrdersAboveMin
    @MinValue DEC(10,2)
AS
BEGIN   
    SELECT OrderID,
    SUM(Quantity * UnitPrice) AS OrderValue
    FROM [Order Details] 
    GROUP BY OrderID
    HAVING SUM(Quantity * UnitPrice) > @MinValue;
END;
GO
-- 7. Create a stored procedure that takes @CustomerID and returns:
-- Total number of orders
-- Total spend
-- Average order value
-- Customer category:
-- “High Value” (> 1000 spend)
-- “Medium” (500–1000)
-- “Low” (< 500)

CREATE PROCEDURE CustomerInfo
    @CustomerID NCHAR(5)
AS 
BEGIN
    WITH CustomerInfoTable AS (
        SELECT 
        o.CustomerID,
        (SELECT COUNT(OrderID) FROM Orders WHERE CustomerID = o.CustomerID) AS TotalOrders, 
        SUM(od.Quantity * od.UnitPrice) AS TotalSpend, 
        SUM(od.Quantity * od.UnitPrice) / COUNT(o.OrderID) AS AverageValue


        FROM Orders o
        JOIN [Order Details] od ON od.OrderID = o.OrderID
        GROUP BY o.CustomerID
    )

    SELECT *,
        CASE 
            WHEN TotalSpend > 1000 THEN 'High Value'
            WHEN TotalSpend > 500 THEN 'Medium'
            ELSE 'Low'
        END AS CustomerValue
    FROM CustomerInfoTable
    WHERE CustomerID = @CustomerID;
END;

