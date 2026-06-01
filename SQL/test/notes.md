# Notes on SQL 

## Joins
- INNER JOIN:
    - Only returned matching rows based on the logic we stated in the SQL code
    - If there is no match, the data is excluded
    - So in the example, Charlie is missing because no orders are attributed to him
- 
- LEFT JOIN:
    - Return all rows from the left table, and only the matched rows from the right table
- RIGHT JOIN:
    - Return all rows from the right table and only the matched rows from the left table
- FULL JOIN = Everything


## Aggregations

Basic examples: 
```sql 
SUM(), AVG(), COUNT(), MIN(), MAX()
```

For example 
```sql
SELECT CustomerID, COUNT(*) AS Orders 
FROM Orders 
GROUP BY CustomerID;
```
Sends the data into buckets - how many orders per the item you group by

Another example 
```sql 
SELET CustomerID, Count(*) AS totalorders
FROM Orders 
GROUP BY CustomerID 
HAVING COUNT(*) > 5; 
```

## Subquerys 

A query inside a query - the query uses the value produced by the inner query
```sql 
SELECT * 
FROM Products 
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
);
```
## Cases

```sql
SELECT 
    ProductName,
    UnitPrice,
    CASE
        WHEN UnitPrice > 50 THEN 'Premium'
        WHEN UnitPrice > 20 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS PriceCategory
FROM Products;
```

## stored procedures 

```sql
CREATE PROCEDURE GetAllProducts
AS 
BEGIN
    SELECT * FROM Products
END

EXEC GetAllProjects;
```

remove the procedure by running 
```sql 
DROP PROCEDURE procedure_name;
```

## Indexing

```sql
CREATE INDEX idx_Orders_CustomerID 
ON Orders (CustomerID);

-- should be happening in the background
SELECT *
FROM Orders
WHERE CustomerID = 'ALFKI';
```

You might also want to do a cache wipe, to give you an idea of the 'cold' runtime of your query or index.


If you run this with an index on OrderDate, you break the index
```sql
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2026;
```
A better way of writing is like this
```sql
SELECT * FROM Orders WHERE OrderDate >= '2026-01-01' AND OrderDate <= '2026-12-31';
```


## CTE
CTEs are used to replace subqueries. They let you reusue the CTE with an alias. 
You can also JOIN on a CTE and chain them ie 
```sql
WITH Step1 AS ( SELECT ... ),
     Step2 AS ( SELECT ... FROM Step1 ), 
     Step3 AS ( SELECT ... FROM Step2 )
SELECT * FROM Step3;
```



## Basic SQL Query Performance

Things that make a query slow
- Repeated lookups
- Too much data scanned 
- Poor JOINS 
- Not using a limit when applicable 
- Bad or lack of use of filtering
- No DRY 
- Not using Indicies


## Data Modelling 

When we need to store data we need to think about the different options and how we are going to plan out this storage. 

Assuming we need a relational database, the main consideration is the relationships between the tables.

### Normalisation 

Rule 1 - No repeating columns 
Bad: 
``` Product1, Product2, Product3 ...```

Good: 
```Products```

Rule 2 - Each table should contain a single "entity"

Rule 3 - No duplicated data 


Look at ERD diagrams.