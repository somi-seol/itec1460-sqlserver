-- 1. List all ProductName with their CategoryName and SupplierName
SELECT 
    Products.ProductName, 
    Categories.CategoryName, 
    Suppliers.CompanyName AS SupplierName 
FROM 
    Products 
JOIN 
    Categories ON Products.CategoryID = Categories.CategoryID 
JOIN 
    Suppliers ON Products.SupplierID = Suppliers.SupplierID

-- 2. Find all customers who have never placed an order
SELECT 
    Customers.CustomerID, 
    Customers.CompanyName 
FROM 
    Customers 
LEFT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID 
WHERE 
    Orders.OrderID IS NULL

-- 3. List top 5 employees by total sales amount
SELECT TOP 5 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    SUM(od.Quantity * od.UnitPrice) AS TotalSales 
FROM 
    Employees e 
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID 
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID 
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName 
ORDER BY 
    TotalSales DESC

-- 4. Add a new product to the Products table

INSERT INTO Products
(
    ProductName, 
    SupplierID, 
    CategoryID, 
    QuantityPerUnit, 
    UnitPrice, 
    UnitsInStock, 
    UnitsOnOrder, 
    ReorderLevel, 
    Discontinued 
) 
VALUES 
(
    'Northwind Coffee', 
    1, 
    1, 
    '10 boxes x 20 bags', 
    18.00, 
    39, 
    0, 
    10, 
    0 
)

-- 5. Increase the UnitPrice of all products in the "Beverages" category by 10%
UPDATE Products 
SET Products.UnitPrice = Products.UnitPrice * 1.10 
FROM Products 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 
WHERE Categories.CategoryName = 'Beverages'

-- 6. Insert a new order for customer VINET with today's date and delete the order you just created

-- 7. Create a new table named "ProductReviews"
CREATE TABLE ProductReviews
( 
    ReviewID INT PRIMARY KEY, 
    ProductID INT, 
    CustomerID NCHAR(5), 
    Rating INT, 
    ReviewText NVARCHAR(MAX), 
    ReviewDate DATE, 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

-- 8. Create a view named "vw_ProductSales" that shows ProductName, CategoryName, and TotalSales (sum of UnitPrice * Quantity) for each product
CREATE VIEW vw_ProductSales AS 
SELECT 
    Products.ProductName, 
    Categories.CategoryName, 
    SUM(Products.UnitPrice * Products.Quantity) AS TotalSales -- quantity?
FROM Products 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 

-- 9. Write a stored procedure named "sp_TopCustomersByCountry" that takes a country name as input and returns the top 3 customers by total order amount for that country

-- 10. Write a query to find the employee who has processed orders for the most unique products. Display the EmployeeID, FirstName, LastName, and the count of unique products they've processed
