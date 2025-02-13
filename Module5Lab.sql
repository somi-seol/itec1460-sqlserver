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