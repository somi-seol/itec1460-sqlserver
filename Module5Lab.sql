-- part 1
sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('STUD2', 'Student Company', 'Somi Seol', 'USA');"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "INSERT INTO Orders(CustomerID, EmployeeID, OrderDate, ShipCountry) 
VALUES ('STUDE', 1, GETDATE(), 'USA');"
sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;"
sqlq "UPDATE Customers SET ContactName = 'Jane Doe' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "UPDATE Orders SET ShipCountry = 'New Countryland' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "DELETE FROM Orders WHERE CustomerID = 'STUDE';"

--- part 2

-- new supplier
INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-up Foods', 'Somi Seol', 'Owner', 'USA');

-- new product
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock) 
VALUES ('House Special Pizza', (SELECT SupplierID FROM Suppliers WHERE ContactName = 'Somi Seol'), 2, 15.99, 50);

-- update stock & price
UPDATE Products SET UnitPrice = 17.99, UnitsInStock = 25 WHERE ProductName = 'House Special Pizza'

-- check work
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- delete pizza
DELETE FROM Products WHERE ProductName = 'House Special Pizza'

--- part 2.2

-- new product
INSERT INTO Products (ProductName) VALUES ('Lasagna')

-- update price & stock
UPDATE Products SET UnitPrice = 100, UnitsInStock = 1000 WHERE ProductName = 'Lasagna'

-- check work
SELECT * FROM Products WHERE ProductName = 'Lasagna'