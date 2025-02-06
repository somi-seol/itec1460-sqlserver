-- join customers and orders tables
-- CustomerID is pk in customers and fk in orders

SELECT C.CompanyName, O.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID

-- LEFT JOIN example
SELECT  c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID

-- built-in functions example
SELECT OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalValue, COUNT(*) AS NumberOfItems
FROM [Order Details] GROUP BY OrderID ORDER BY TotalValue DESC

-- GROUP BY & HAVING example
SELECT p.ProductID, p.ProductName, COUNT(od.OrderID) AS TimesOrdered FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID GROUP BY p.ProductID, p. ProductName HAVING COUNT(od.OrderID) > 10

-- subquery example
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products) ORDER BY UnitPrice

-- complex query example
-- limit result to top 5
SELECT TOP 5 
c.CustomerID, c.CompanyName, 
ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalPurchase 
FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
WHERE YEAR(o.OrderDate) = 2001 
GROUP BY c.CustomerID, c.CompanyName 
ORDER BY TotalPurchase DESC;


-- part 2
-- What is the total revenue for each customer in the year 1997, and how many orders did they place?

SELECT TOP 10
    o.CustomerID,
    od.OrderDetails,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalRevenue,
    COUNT(od.OrderID)
FROM 
    Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY 
    o.CustomerID,
    od.OrderDetails
ORDER BY 
    TotalRevenue DESC